# AS-IS 액션 대조표 — FP02841

> 원천: `Doc/asisfacts/screens/FP02841/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 3101행 · 메서드 238 · 종류 DATA_OP 1143 · FLAG 264 · RETURN 247 · UI_PROP 237 · CALL_EXT 199 · VALUE_SET 141 · UI_MISC 125 · MESSAGE 109 · GRID_SET 104 · POPUP 92 · STATE 86 · ENDPOINT 81 · GRID_INIT 69 · LIST_REBIND 37 · COMBO_DATA 35 · VALUE_CLEAR 30 · CALL_BASE 26 · GRID_STYLE 20 · GRID_LOCK 19 · THROW 12 · LIST_CLEAR 8 · EXCEL 5 · GRID_BIND 5 · FOCUS 4 · STATE_RESET 3 · ⚠ 의미 확인 필요 225


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-255ade55 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:4995 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-45081a2f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5001 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-508bac0e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5010 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-e8872be3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5013 |  | DATA_OP | material_column.ContainsKey | ("SLITTING_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-950e098c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5014 | if (material_column.ContainsKey("SLITTING_PLAN")) | UI_PROP | dlLine._SLITTING_PLAN | material_column["SLITTING_PLAN"] | 속성 _SLITTING_PLAN 설정 |  |  |  |
| AC-799d4d61 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5015 |  | DATA_OP | material_column.ContainsKey | ("ROLL_PRESS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-069c2f6a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5016 | if (material_column.ContainsKey("ROLL_PRESS_PLAN")) | UI_PROP | dlLine._ROLL_PRESS_PLAN | material_column["ROLL_PRESS_PLAN"] | 속성 _ROLL_PRESS_PLAN 설정 |  |  |  |
| AC-50f90ad6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5017 |  | DATA_OP | material_column.ContainsKey | ("EOH_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-28c0dc5b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5018 | if (material_column.ContainsKey("EOH_JR_QTY")) | UI_PROP | dlLine._EOH_JR | material_column["EOH_JR_QTY"] | 속성 _EOH_JR 설정 |  |  |  |
| AC-883a0ac8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5019 |  | DATA_OP | material_column.ContainsKey | ("EOH_PC_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-40018655 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5020 | if (material_column.ContainsKey("EOH_PC_QTY")) | UI_PROP | dlLine._EOH_PC | material_column["EOH_PC_QTY"] | 속성 _EOH_PC 설정 |  |  |  |
| AC-450acb00 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5022 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-023a066b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5187 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-3629c5af | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5189 |  | DATA_OP | material_column.ContainsKey | ("SLITTING_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e102794 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5190 | if (material_column.ContainsKey("SLITTING_PLAN")) | UI_PROP | dlLine._SLITTING_PLAN | material_column["SLITTING_PLAN"] | 속성 _SLITTING_PLAN 설정 |  |  |  |
| AC-503453d0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5191 |  | DATA_OP | material_column.ContainsKey | ("ROLL_PRESS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-480827a9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5192 | if (material_column.ContainsKey("ROLL_PRESS_PLAN")) | UI_PROP | dlLine._ROLL_PRESS_PLAN | material_column["ROLL_PRESS_PLAN"] | 속성 _ROLL_PRESS_PLAN 설정 |  |  |  |
| AC-7a5c25df | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5193 |  | DATA_OP | material_column.ContainsKey | ("EOH_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-36183f8b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5194 | if (material_column.ContainsKey("EOH_JR_QTY")) | UI_PROP | dlLine._EOH_JR | material_column["EOH_JR_QTY"] | 속성 _EOH_JR 설정 |  |  |  |
| AC-77b46a82 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5195 |  | DATA_OP | material_column.ContainsKey | ("EOH_PC_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf0a99a2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5196 | if (material_column.ContainsKey("EOH_PC_QTY")) | UI_PROP | dlLine._EOH_PC | material_column["EOH_PC_QTY"] | 속성 _EOH_PC 설정 |  |  |  |
| AC-99b89348 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5198 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-fd7b3149 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4865 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a7d87e7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4871 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1dcb19b4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4880 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-31e24b2b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4883 |  | DATA_OP | material_column.ContainsKey | ("SLITTING_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b116777 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4884 | if (material_column.ContainsKey("SLITTING_PLAN")) | UI_PROP | dlLine._SLITTING_PLAN | material_column["SLITTING_PLAN"] | 속성 _SLITTING_PLAN 설정 |  |  |  |
| AC-7d6567c0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4885 |  | DATA_OP | material_column.ContainsKey | ("ROLL_PRESS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-4caa044b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4886 | if (material_column.ContainsKey("ROLL_PRESS_PLAN")) | UI_PROP | dlLine._ROLL_PRESS_PLAN | material_column["ROLL_PRESS_PLAN"] | 속성 _ROLL_PRESS_PLAN 설정 |  |  |  |
| AC-15bcc3dc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4887 |  | DATA_OP | material_column.ContainsKey | ("EOH_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-dddd06f8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4888 | if (material_column.ContainsKey("EOH_JR_QTY")) | UI_PROP | dlLine._EOH_JR | material_column["EOH_JR_QTY"] | 속성 _EOH_JR 설정 |  |  |  |
| AC-74bd1060 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4889 |  | DATA_OP | material_column.ContainsKey | ("EOH_PC_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b66979c0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4890 | if (material_column.ContainsKey("EOH_PC_QTY")) | UI_PROP | dlLine._EOH_PC | material_column["EOH_PC_QTY"] | 속성 _EOH_PC 설정 |  |  |  |
| AC-996459e9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4892 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-3f0fbfb1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5057 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-0a3f5d11 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5059 |  | DATA_OP | material_column.ContainsKey | ("SLITTING_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f5de4c8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5060 | if (material_column.ContainsKey("SLITTING_PLAN")) | UI_PROP | dlLine._SLITTING_PLAN | material_column["SLITTING_PLAN"] | 속성 _SLITTING_PLAN 설정 |  |  |  |
| AC-61eed67e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5061 |  | DATA_OP | material_column.ContainsKey | ("ROLL_PRESS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-58e16536 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5062 | if (material_column.ContainsKey("ROLL_PRESS_PLAN")) | UI_PROP | dlLine._ROLL_PRESS_PLAN | material_column["ROLL_PRESS_PLAN"] | 속성 _ROLL_PRESS_PLAN 설정 |  |  |  |
| AC-6c246d00 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5063 |  | DATA_OP | material_column.ContainsKey | ("EOH_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-37d851dc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5064 | if (material_column.ContainsKey("EOH_JR_QTY")) | UI_PROP | dlLine._EOH_JR | material_column["EOH_JR_QTY"] | 속성 _EOH_JR 설정 |  |  |  |
| AC-2c40e833 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5065 |  | DATA_OP | material_column.ContainsKey | ("EOH_PC_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0d39fd8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5066 | if (material_column.ContainsKey("EOH_PC_QTY")) | UI_PROP | dlLine._EOH_PC | material_column["EOH_PC_QTY"] | 속성 _EOH_PC 설정 |  |  |  |
| AC-0b0a3fdb | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5068 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.DO_INC_P_RESULT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b066cffa | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5293 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-a1b75063 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5163 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Do_SET_P_OUT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e95c647 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5297 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-a94bcd9a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5167 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31015eb8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5116 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4c906e9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5117 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-afa09ae4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5118 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9ef7a02 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5119 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-01fe596c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5120 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c6d54be | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5121 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-26e3a0e7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5122 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f1d2361 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5123 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-97e60618 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5114 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-4d6c71c7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5137 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "ROLL_PRESS_PLAN": | DATA_OP | loc.ROLL_PRESS_PLAN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc4d27e2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5140 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "SLITTING_PLAN": | DATA_OP | loc.SLITTING_PLAN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a55a311 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5143 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "EOH_JR_QTY": | DATA_OP | loc.EOH_JR.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d25be60 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5146 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "EOH_PC_QTY": | DATA_OP | loc.EOH_PC.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-90056583 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5149 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-2f7adf60 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5155 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-cff48150 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5157 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-95435dff | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4986 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bf34fc2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4987 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-253be624 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4988 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-133dc0d4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4989 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6f7a537 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4990 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-99fd9a44 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4991 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-399aa8b9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4992 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d22bc9b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4993 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff7c708c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4984 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-3a08c917 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5007 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "ROLL_PRESS_PLAN": | DATA_OP | loc.ROLL_PRESS_PLAN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-209f9349 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5010 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "SLITTING_PLAN": | DATA_OP | loc.SLITTING_PLAN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-33093961 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5013 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "EOH_JR_QTY": | DATA_OP | loc.EOH_JR.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-aca57cd7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5016 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "EOH_PC_QTY": | DATA_OP | loc.EOH_PC.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a036607 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5019 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-eca9d331 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5025 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-2c030cd1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5027 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e3bdfa5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5089 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |
| AC-2b7bc846 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4959 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa61dcc0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5060 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ca6b6c4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5061 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fa0e3c3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5062 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7234d452 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5063 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c58a12f6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5064 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9eaadfbc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5065 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad682d28 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5066 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a4988a3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5067 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-074e7afb | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5058 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-21a7326d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5075 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-a35b7f29 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5076 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca85adbc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5081 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |
| AC-f71aa0ed | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4930 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e80e9c7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4931 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-65332546 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4932 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ad0ee23 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4933 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb3f1aa0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4934 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c503e38 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4935 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d46d2e6c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4936 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2aa60d2c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4937 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-20da92ce | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4928 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-8cf391a4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4945 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5c9a989 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4946 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f999de0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4951 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bf72a86 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:5034 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |
| AC-58913dc6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4904 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP02841_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccc21558 | .ctor | FP02841_BucketSetForm_Popup.cs:72 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-b7142e7e | .ctor | FP02841_BucketSetForm_Popup.cs:73 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-bccc7abd | .ctor | FP02841_BucketSetForm_Popup.cs:74 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f8ddef73 | .ctor | FP02841_BucketSetForm_Popup.cs:76 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP02841_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6259c73f | Dispose | FP02841_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce9dc5e0 | this.Load | FP02841_BucketSetForm_Popup.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP02841_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e9e06e1 | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:139 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-2635a06f | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-6796d42b | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-18105b60 | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-5acedf35 | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:152 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-d56b18f6 | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:152 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-e385c329 | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:159 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-b40a3bc1 | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:163 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-528db9ff | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:167 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP02841_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c44eabb | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-50f41e8c | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-30592d03 | this.Load 외 1 | FP02841_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP02841_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f03f023 | (진입점 미연결) | FP02841_BucketSetForm_Popup.cs:227 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-24f51ac8 | (진입점 미연결) | FP02841_BucketSetForm_Popup.cs:238 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac125c38 | (진입점 미연결) | FP02841_BucketSetForm_Popup.cs:249 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP02841_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37140870 | this.Load | FP02841_BucketSetForm_Popup.cs:87 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d0c00740 | this.Load | FP02841_BucketSetForm_Popup.cs:95 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02841_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cad0699f | this.usrButton1.Click | FP02841_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-00a1769d | this.usrButton1.Click | FP02841_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-3c16c13b | this.usrButton1.Click | FP02841_BucketSetForm_Popup.cs:213 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-c27d5b31 | this.usrButton1.Click | FP02841_BucketSetForm_Popup.cs:217 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-75f5b160 | this.usrButton1.Click | FP02841_BucketSetForm_Popup.cs:218 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-65aa4941 | this.usrButton1.Click | FP02841_BucketSetForm_Popup.cs:220 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ed6dbef | this.usrButton1.Click | FP02841_BucketSetForm_Popup.cs:222 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP02841_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e89e248 | this.usrButton2.Click | FP02841_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-49b44676 | this.usrButton2.Click | FP02841_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-05d36fd1 | this.usrButton2.Click | FP02841_BucketSetForm_Popup.cs:187 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-7da53e25 | this.usrButton2.Click | FP02841_BucketSetForm_Popup.cs:191 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-e871ffbf | this.usrButton2.Click | FP02841_BucketSetForm_Popup.cs:192 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-1cbb5373 | this.usrButton2.Click | FP02841_BucketSetForm_Popup.cs:193 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-4e518cb2 | this.usrButton2.Click | FP02841_BucketSetForm_Popup.cs:194 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-361ff21b | .ctor | FP02841_ExcelPopup.cs:134 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7fcc9214 | .ctor | FP02841_ExcelPopup.cs:137 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-0a7eaf0c | .ctor | FP02841_ExcelPopup.cs:138 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP02841_ExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba991a49 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:218 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fe3228b5 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:219 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-104d98f2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:220 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-159f2be1 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:221 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ca37cc25 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:223 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-5813b063 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:223 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-32faf992 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:224 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-1cf70b57 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:224 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6576c160 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:225 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-00111523 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:225 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1a2a8d0c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:226 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-21a5413c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:226 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3d996a4f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:235 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-30ea55d8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:236 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-f827fa31 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:237 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-7f6f26fe | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_ExcelPopup.cs:238 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP02841_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35e42a90 | this.btnClose.Click | FP02841_ExcelPopup.cs:938 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95d597df | this.btnDownload.Click | FP02841_ExcelPopup.cs:922 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-ef281e99 | this.btnDownload.Click | FP02841_ExcelPopup.cs:923 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP02841_ExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-021a6e6f | this.btnFind.Click | FP02841_ExcelPopup.cs:913 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date." ) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7ac1253 | this.btnFind.Click | FP02841_ExcelPopup.cs:914 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02841_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc0057b | this.Load | FP02841_ExcelPopup.cs:266 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-853e8388 | this.Load | FP02841_ExcelPopup.cs:267 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-879a2a94 | this.Load | FP02841_ExcelPopup.cs:268 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_ExcelPopup.dateRange_ValueChanged

진입점: this.dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d49825e | this.dateRange.ValueChanged | FP02841_ExcelPopup.cs:946 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7a1063ad | this.dateRange.ValueChanged | FP02841_ExcelPopup.cs:947 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP02841_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e961744e | (진입점 미연결) | FP02841_ExcelPopup.cs:876 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-789fce6f | (진입점 미연결) | FP02841_ExcelPopup.cs:876 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP02841_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05577cbb | this.Load | FP02841_ExcelPopup.cs:261 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02841_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5abbbd78 | Dispose | FP02841_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e041f01 | (진입점 미연결) | FP02841_ExcelPopup.cs:838 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP02841_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71e7453a | FindButton | FP02841_ExcelPopup.cs:310 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-42eb3305 | FindButton | FP02841_ExcelPopup.cs:311 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e093df6e | FindButton | FP02841_ExcelPopup.cs:313 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b88ebec | this.Load 외 2 | FP02841_ExcelPopup.cs:341 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-828215b1 | this.Load 외 2 | FP02841_ExcelPopup.cs:342 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c878cec | this.Load 외 2 | FP02841_ExcelPopup.cs:342 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce7f14cb | this.Load 외 2 | FP02841_ExcelPopup.cs:346 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-911518d3 | this.Load 외 2 | FP02841_ExcelPopup.cs:347 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7594a75e | this.Load 외 2 | FP02841_ExcelPopup.cs:349 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-53b9c6a8 | this.Load 외 2 | FP02841_ExcelPopup.cs:350 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2b729cde | this.Load 외 2 | FP02841_ExcelPopup.cs:351 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9a93baa0 | this.Load 외 2 | FP02841_ExcelPopup.cs:352 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b7ee568f | this.Load 외 2 | FP02841_ExcelPopup.cs:353 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a0d8a011 | this.Load 외 2 | FP02841_ExcelPopup.cs:354 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-93c4ff4f | this.Load 외 2 | FP02841_ExcelPopup.cs:361 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d7bd509 | this.Load 외 2 | FP02841_ExcelPopup.cs:366 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-30a443d7 | this.Load 외 2 | FP02841_ExcelPopup.cs:368 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-811854c4 | this.Load 외 2 | FP02841_ExcelPopup.cs:369 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-04b03537 | this.Load 외 2 | FP02841_ExcelPopup.cs:370 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-40ab774c | this.Load 외 2 | FP02841_ExcelPopup.cs:372 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-324da809 | this.Load 외 2 | FP02841_ExcelPopup.cs:375 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c58111f5 | this.Load 외 2 | FP02841_ExcelPopup.cs:376 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; //if (init) //{ // DictColumn = siMain.Se… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1db5b0cb | this.Load 외 2 | FP02841_ExcelPopup.cs:395 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-818d73a2 | this.Load 외 2 | FP02841_ExcelPopup.cs:395 | if (DoSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, 2, Au… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d94af8a | this.Load 외 2 | FP02841_ExcelPopup.cs:401 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-7fe59a4f | this.Load 외 2 | FP02841_ExcelPopup.cs:402 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-3efe4eaa | this.Load 외 2 | FP02841_ExcelPopup.cs:403 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-854a58ca | this.Load 외 2 | FP02841_ExcelPopup.cs:408 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44fe26e6 | this.Load 외 2 | FP02841_ExcelPopup.cs:411 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9812d30d | this.Load 외 2 | FP02841_ExcelPopup.cs:440 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string, AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, sColFormat, "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e0372d7 | this.Load 외 2 | FP02841_ExcelPopup.cs:443 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-87a24dc0 | this.Load 외 2 | FP02841_ExcelPopup.cs:452 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b44e154b | this.Load 외 2 | FP02841_ExcelPopup.cs:455 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7e917ce7 | this.Load 외 2 | FP02841_ExcelPopup.cs:456 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d966a8ad | this.Load 외 2 | FP02841_ExcelPopup.cs:457 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c9b48ca8 | this.Load 외 2 | FP02841_ExcelPopup.cs:458 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3ccc041f | this.Load 외 2 | FP02841_ExcelPopup.cs:459 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9afd363a | this.Load 외 2 | FP02841_ExcelPopup.cs:460 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02841_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-178df021 | this.Load | FP02841_ExcelPopup.cs:146 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a7d9bff6 | this.Load | FP02841_ExcelPopup.cs:148 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_ExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47f29c1 | (진입점 미연결) | FP02841_ExcelPopup.cs:812 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-a3ff49ea | (진입점 미연결) | FP02841_ExcelPopup.cs:813 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-407a35b2 | (진입점 미연결) | FP02841_ExcelPopup.cs:814 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-1dbc13dc | (진입점 미연결) | FP02841_ExcelPopup.cs:815 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-e6c7eccb | (진입점 미연결) | FP02841_ExcelPopup.cs:816 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-27d7f915 | (진입점 미연결) | FP02841_ExcelPopup.cs:817 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-f0b8721b | (진입점 미연결) | FP02841_ExcelPopup.cs:818 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-31e17aac | (진입점 미연결) | FP02841_ExcelPopup.cs:820 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-b48772b5 | (진입점 미연결) | FP02841_ExcelPopup.cs:821 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-26b62af9 | (진입점 미연결) | FP02841_ExcelPopup.cs:825 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ea9d5b51 | (진입점 미연결) | FP02841_ExcelPopup.cs:826 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP02841_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dce24854 | this.Load | FP02841_ExcelPopup.cs:194 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-e9741358 | this.Load | FP02841_ExcelPopup.cs:195 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-848f5914 | this.Load | FP02841_ExcelPopup.cs:199 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-6eeb6c64 | this.Load | FP02841_ExcelPopup.cs:200 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-1022b703 | this.Load | FP02841_ExcelPopup.cs:203 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2cf901e6 | this.Load | FP02841_ExcelPopup.cs:204 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f1e44384 | this.Load | FP02841_ExcelPopup.cs:208 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP02841_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0369e3a0 | this.Load | FP02841_ExcelPopup.cs:279 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-345926c7 | this.Load | FP02841_ExcelPopup.cs:280 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a96a71 | (진입점 미연결) | FP02841_ExcelPopup.cs:300 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff8d68a2 | this.btnUpload.Click | FP02841_ExcelPopup.cs:848 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-174c3907 | this.btnUpload.Click | FP02841_ExcelPopup.cs:848 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32209915 | this.btnUpload.Click | FP02841_ExcelPopup.cs:850 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-30a3e2b3 | this.btnUpload.Click | FP02841_ExcelPopup.cs:851 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-69b5c78b | this.btnUpload.Click | FP02841_ExcelPopup.cs:852 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-661e5623 | this.btnUpload.Click | FP02841_ExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-38e7e135 | this.btnUpload.Click | FP02841_ExcelPopup.cs:856 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2fe395aa | this.btnUpload.Click | FP02841_ExcelPopup.cs:857 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-1433d60c | this.btnUpload.Click | FP02841_ExcelPopup.cs:857 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-76fc9972 | this.btnUpload.Click | FP02841_ExcelPopup.cs:864 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f8aacfc4 | this.btnUpload.Click | FP02841_ExcelPopup.cs:865 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-b9358228 | this.btnUpload.Click | FP02841_ExcelPopup.cs:867 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02841_ExcelPopup.rdoMpp_CheckedChanged

진입점: this.rdoMpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-573dff8a | this.rdoMpp.CheckedChanged | FP02841_ExcelPopup.cs:953 | if (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-96f4d5e5 | this.rdoMpp.CheckedChanged | FP02841_ExcelPopup.cs:955 | else of (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP02841_ExcelPopup.rdoWpp_CheckedChanged

진입점: this.rdoWpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e21813a7 | this.rdoWpp.CheckedChanged | FP02841_ExcelPopup.cs:962 | if (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-26238873 | this.rdoWpp.CheckedChanged | FP02841_ExcelPopup.cs:964 | else of (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP02841_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f270223 | this.btnSave.Click | FP02841_ExcelPopup.cs:561 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-2508389c | this.btnSave.Click | FP02841_ExcelPopup.cs:562 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2527eda6 | this.btnSave.Click | FP02841_ExcelPopup.cs:566 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-d938d6a0 | this.btnSave.Click | FP02841_ExcelPopup.cs:567 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38dc334a | this.btnSave.Click | FP02841_ExcelPopup.cs:571 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-428e0270 | this.btnSave.Click | FP02841_ExcelPopup.cs:571 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d742da14 | this.btnSave.Click | FP02841_ExcelPopup.cs:576 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-64d139f3 | this.btnSave.Click | FP02841_ExcelPopup.cs:577 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a8f9d87d | this.btnSave.Click | FP02841_ExcelPopup.cs:578 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-82821360 | this.btnSave.Click | FP02841_ExcelPopup.cs:579 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e81db78e | this.btnSave.Click | FP02841_ExcelPopup.cs:580 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c9dcb219 | this.btnSave.Click | FP02841_ExcelPopup.cs:581 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8d127bc5 | this.btnSave.Click | FP02841_ExcelPopup.cs:589 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72f9e038 | this.btnSave.Click | FP02841_ExcelPopup.cs:592 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-706a38d0 | this.btnSave.Click | FP02841_ExcelPopup.cs:594 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-a067660b | this.btnSave.Click | FP02841_ExcelPopup.cs:597 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-af2be556 | this.btnSave.Click | FP02841_ExcelPopup.cs:602 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-4c6c1494 | this.btnSave.Click | FP02841_ExcelPopup.cs:603 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-b4238744 | this.btnSave.Click | FP02841_ExcelPopup.cs:610 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-f7aca12b | this.btnSave.Click | FP02841_ExcelPopup.cs:611 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-296436fe | this.btnSave.Click | FP02841_ExcelPopup.cs:612 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-15381d1f | this.btnSave.Click | FP02841_ExcelPopup.cs:613 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-de6e9ecd | this.btnSave.Click | FP02841_ExcelPopup.cs:614 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c70891ad | this.btnSave.Click | FP02841_ExcelPopup.cs:615 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-06895dbb | this.btnSave.Click | FP02841_ExcelPopup.cs:616 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7f2485cf | this.btnSave.Click | FP02841_ExcelPopup.cs:617 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22b5327a | this.btnSave.Click | FP02841_ExcelPopup.cs:623 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b19c9d00 | this.btnSave.Click | FP02841_ExcelPopup.cs:656 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e0e6a8b | this.btnSave.Click | FP02841_ExcelPopup.cs:658 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a10b901 | this.btnSave.Click | FP02841_ExcelPopup.cs:661 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | dr["NEW_SEQ"] | Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b5571e5 | this.btnSave.Click | FP02841_ExcelPopup.cs:666 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9fe82ce7 | this.btnSave.Click | FP02841_ExcelPopup.cs:668 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9dbe4af1 | this.btnSave.Click | FP02841_ExcelPopup.cs:671 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0c985e62 | this.btnSave.Click | FP02841_ExcelPopup.cs:675 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-be492be5 | this.btnSave.Click | FP02841_ExcelPopup.cs:677 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-776d9a3e | this.btnSave.Click | FP02841_ExcelPopup.cs:680 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1bfbe2a1 | this.btnSave.Click | FP02841_ExcelPopup.cs:699 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8426c42 | this.btnSave.Click | FP02841_ExcelPopup.cs:711 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-08060bcd | this.btnSave.Click | FP02841_ExcelPopup.cs:713 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT_CNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b303a074 | this.btnSave.Click | FP02841_ExcelPopup.cs:715 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT_EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-c03a88f9 | this.btnSave.Click | FP02841_ExcelPopup.cs:719 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-3bd3639d | this.btnSave.Click | FP02841_ExcelPopup.cs:734 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-23159de4 | this.btnSave.Click | FP02841_ExcelPopup.cs:735 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d4a7d4bc | this.btnSave.Click | FP02841_ExcelPopup.cs:739 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("{0} data Saved", result_count)) | 메시지 표시 |  |  |  |
| AC-b6810061 | this.btnSave.Click | FP02841_ExcelPopup.cs:740 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-aa9af004 | this.btnSave.Click | FP02841_ExcelPopup.cs:745 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-d6dc2e14 | this.btnSave.Click | FP02841_ExcelPopup.cs:778 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-ff6845f9 | this.btnSave.Click | FP02841_ExcelPopup.cs:780 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ed56f23 | this.btnSave.Click | FP02841_ExcelPopup.cs:781 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a6885419 | this.btnSave.Click | FP02841_ExcelPopup.cs:791 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-553e3112 | this.btnSave.Click | FP02841_ExcelPopup.cs:796 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c95ce85e | this.btnSave.Click | FP02841_ExcelPopup.cs:797 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-26d962b2 | this.btnSave.Click | FP02841_ExcelPopup.cs:798 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f6f0c9fa | this.btnSave.Click | FP02841_ExcelPopup.cs:799 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2f511502 | this.btnSave.Click | FP02841_ExcelPopup.cs:800 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e84117cc | this.btnSave.Click | FP02841_ExcelPopup.cs:801 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02841_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a098718 | this.Load | FP02841_ExcelPopup.cs:292 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b56938bb | this.Load | FP02841_ExcelPopup.cs:293 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02841_ExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e857de38 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_ExcelPopup.cs:246 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-814c5ea7 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_ExcelPopup.cs:247 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f3f2269d | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_ExcelPopup.cs:248 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0b476bc3 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_ExcelPopup.cs:252 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d228359a | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_ExcelPopup.cs:253 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fa373d03 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_ExcelPopup.cs:254 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02841_InvalidExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f98b22bc | .ctor | FP02841_InvalidExcelPopup.cs:133 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-757c978d | .ctor | FP02841_InvalidExcelPopup.cs:136 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbdaa373 | .ctor | FP02841_InvalidExcelPopup.cs:137 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP02841_InvalidExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f4cb735 | this.btnClose.Click | FP02841_InvalidExcelPopup.cs:282 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_InvalidExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87ee954a | this.btnDownload.Click | FP02841_InvalidExcelPopup.cs:275 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-cc9c08bc | this.btnDownload.Click | FP02841_InvalidExcelPopup.cs:276 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP02841_InvalidExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2cc4692 | this.Load | FP02841_InvalidExcelPopup.cs:180 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8aa1a65a | this.Load | FP02841_InvalidExcelPopup.cs:181 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdccf7f4 | this.Load | FP02841_InvalidExcelPopup.cs:182 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_InvalidExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3b812f6 | this.Load | FP02841_InvalidExcelPopup.cs:175 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02841_InvalidExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddeec343 | Dispose | FP02841_InvalidExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_InvalidExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d394ed54 | FindButton | FP02841_InvalidExcelPopup.cs:222 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a6b0ba03 | FindButton | FP02841_InvalidExcelPopup.cs:223 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2ead6bcb | FindButton | FP02841_InvalidExcelPopup.cs:225 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_InvalidExcelPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec9e81b7 | this.Load 외 1 | FP02841_InvalidExcelPopup.cs:255 | if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c3e34e5 | this.Load 외 1 | FP02841_InvalidExcelPopup.cs:257 | if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de59a3d5 | this.Load 외 1 | FP02841_InvalidExcelPopup.cs:260 |  | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-620de9de | this.Load 외 1 | FP02841_InvalidExcelPopup.cs:261 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP02841_InvalidExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee86ec51 | this.Load | FP02841_InvalidExcelPopup.cs:145 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-26907678 | this.Load | FP02841_InvalidExcelPopup.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_InvalidExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51cbbff6 | this.Load | FP02841_InvalidExcelPopup.cs:192 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae1e6242 | this.Load | FP02841_InvalidExcelPopup.cs:193 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_InvalidExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f4803fc | (진입점 미연결) | FP02841_InvalidExcelPopup.cs:213 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_InvalidExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9da7d625 | this.Load | FP02841_InvalidExcelPopup.cs:205 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbd7693b | this.Load | FP02841_InvalidExcelPopup.cs:206 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-61e0187e | this.Load | FP02841_InvalidExcelPopup.cs:207 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP02841_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ea4ad66 | this.btnButtonList.UsrButtonList_Click_Detected | FP02841_ItemPopup.cs:279 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a3066093 | this.btnButtonList.UsrButtonList_Click_Detected | FP02841_ItemPopup.cs:282 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4aa7fc7e | this.btnButtonList.UsrButtonList_Click_Detected | FP02841_ItemPopup.cs:283 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-804f7e3b | this.Load | FP02841_ItemPopup.cs:137 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6be81628 | this.Load | FP02841_ItemPopup.cs:138 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e687a066 | this.Load | FP02841_ItemPopup.cs:139 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-988daf71 | this.Load | FP02841_ItemPopup.cs:132 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02841_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-772a975b | Dispose | FP02841_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6721cd29 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:208 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-80c99644 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:209 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9101ebd1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:211 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1b813e5d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:212 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-059d198b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:218 | if (string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpace(Filter["NICK_NAME"])) | MESSAGE | MessageBox.Show | ("It is required at least one of these : Item, Nick Name") | 메시지 표시 |  |  |  |
| AC-0006570e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:219 | if (string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpace(Filter["NICK_NAME"])) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f0cc4148 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:220 | if (string.IsNullOrWhiteSpace(Filter["ITEM_ID"]) && string.IsNullOrWhiteSpace(Filter["NICK_NAME"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-996b8e61 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:224 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-99299775 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:226 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { //DataSet dtInstType = DataService.FP_ExecuteQuery("FP00601_LineAdd", "find_Insta… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4fca5c28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:236 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_ADD", Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dfa46300 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:238 | lambda | RETURN | return itemList; |  | 처리 중단/반환 |  |  |  |
| AC-28ee494e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:242 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a19fb511 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:245 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bdfdbe72 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:247 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-03795c66 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP02841_ItemPopup.cs:251 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08bea695 | this.Load | FP02841_ItemPopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d4b3e1e | this.Load | FP02841_ItemPopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea2fceff | this.Load | FP02841_ItemPopup.cs:149 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e72edac3 | this.Load | FP02841_ItemPopup.cs:150 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b951e22 | (진입점 미연결) | FP02841_ItemPopup.cs:169 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a27f2580 | this.Load | FP02841_ItemPopup.cs:156 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a6e3652 | this.Load | FP02841_ItemPopup.cs:157 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-f0123263 | this.Load | FP02841_ItemPopup.cs:161 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP02841_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aada8888 | this.spdMain.CellClick | FP02841_ItemPopup.cs:294 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-dd28b068 | this.spdMain.CellClick | FP02841_ItemPopup.cs:295 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6d49f32d | this.spdMain.CellClick | FP02841_ItemPopup.cs:298 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP02841_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d256404 | this.spdMain.CellDoubleClick | FP02841_ItemPopup.cs:304 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8743987c | this.spdMain.CellDoubleClick | FP02841_ItemPopup.cs:305 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cea76596 | this.spdMain.CellDoubleClick | FP02841_ItemPopup.cs:308 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-b993ccf2 | this.spdMain.CellDoubleClick | FP02841_ItemPopup.cs:311 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-871b3b1f | this.spdMain.CellDoubleClick | FP02841_ItemPopup.cs:321 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad67aaad | .ctor | FP02841_LineAddPopup.cs:97 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-375b3011 | .ctor | FP02841_LineAddPopup.cs:98 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP02841_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4283e28a | this.btnClose.Click | FP02841_LineAddPopup.cs:283 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_LineAddPopup.btnItem_Click

진입점: this.btnItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3effc2a4 | this.btnItem.Click | FP02841_LineAddPopup.cs:472 |  | POPUP | new FP02841_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-942fc9fd | this.btnItem.Click | FP02841_LineAddPopup.cs:473 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-7d1d4b1e | this.btnItem.Click | FP02841_LineAddPopup.cs:475 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-22669f03 | this.btnItem.Click | FP02841_LineAddPopup.cs:476 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-033db466 | this.btnItem.Click | FP02841_LineAddPopup.cs:478 |  | DATA_OP | popup.Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d4336c62 | this.btnItem.Click | FP02841_LineAddPopup.cs:479 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-29b77abf | this.btnItem.Click | FP02841_LineAddPopup.cs:481 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-37906000 | this.btnItem.Click | FP02841_LineAddPopup.cs:486 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_ID"] | txtItem.Text = data["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2543d7ff | this.btnItem.Click | FP02841_LineAddPopup.cs:486 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-64638dc7 | this.btnItem.Click | FP02841_LineAddPopup.cs:487 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text = data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a0cfe37b | this.btnItem.Click | FP02841_LineAddPopup.cs:487 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtNickName.Text | data["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP02841_LineAddPopup.btnLine_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1905199 | (진입점 미연결) | FP02841_LineAddPopup.cs:502 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-70953b45 | (진입점 미연결) | FP02841_LineAddPopup.cs:503 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9768e572 | (진입점 미연결) | FP02841_LineAddPopup.cs:505 |  | POPUP | new FP02841_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-a388980e | (진입점 미연결) | FP02841_LineAddPopup.cs:506 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-54cef20d | (진입점 미연결) | FP02841_LineAddPopup.cs:508 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f3e2d12 | (진입점 미연결) | FP02841_LineAddPopup.cs:509 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-70aa4c65 | (진입점 미연결) | FP02841_LineAddPopup.cs:510 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2a0684ca | (진입점 미연결) | FP02841_LineAddPopup.cs:511 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ff741a0 | (진입점 미연결) | FP02841_LineAddPopup.cs:512 |  | DATA_OP | popup.Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-941b03e0 | (진입점 미연결) | FP02841_LineAddPopup.cs:513 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-619348f6 | (진입점 미연결) | FP02841_LineAddPopup.cs:514 |  | DATA_OP | popup.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d26436e2 | (진입점 미연결) | FP02841_LineAddPopup.cs:515 |  | DATA_OP | popup.Filter["RELEASE_VALUE"] | Filter["RELEASE_VALUE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bf567744 | (진입점 미연결) | FP02841_LineAddPopup.cs:516 |  | DATA_OP | popup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-8b33105b | (진입점 미연결) | FP02841_LineAddPopup.cs:518 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2bdb1748 | (진입점 미연결) | FP02841_LineAddPopup.cs:520 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-da702be7 | (진입점 미연결) | FP02841_LineAddPopup.cs:525 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["FACTORY_ID"] | txtBuilding.Text = data["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9c5e2c56 | (진입점 미연결) | FP02841_LineAddPopup.cs:525 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5470cf06 | (진입점 미연결) | FP02841_LineAddPopup.cs:527 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | data["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP02841_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6f863d8 | this.btnSave.Click | FP02841_LineAddPopup.cs:276 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02841_LineAddPopup.cbo_electrode_changed

진입점: cbo_electrode.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2626eb3 | cbo_electrode.SelectedIndexChanged | FP02841_LineAddPopup.cs:260 |  | DATA_OP | Filter["ELECTRODE_TYPE"] | CString.GetCheckedListValue(dtElectrode, cbo_electrode.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP02841_LineAddPopup.cbo_prodtype_changed

진입점: cbo_prodtype.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca720a2a | cbo_prodtype.SelectedIndexChanged | FP02841_LineAddPopup.cs:265 |  | DATA_OP | Filter["PRODUCTION_TYPE"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP02841_LineAddPopup.cbo_type_changed

진입점: cbo_type.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bb2a637 | cbo_type.SelectedIndexChanged | FP02841_LineAddPopup.cs:255 |  | DATA_OP | Filter["WH_TYPE"] | CString.GetCheckedListValue(dtWHType, cbo_electrode.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP02841_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c0ce45 | this.btnSave.Click | FP02841_LineAddPopup.cs:294 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-f91707c7 | this.btnSave.Click | FP02841_LineAddPopup.cs:295 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f29c5ca2 | this.btnSave.Click | FP02841_LineAddPopup.cs:303 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-b324cbd0 | this.btnSave.Click | FP02841_LineAddPopup.cs:304 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-971152ac | this.btnSave.Click | FP02841_LineAddPopup.cs:309 | if (string.IsNullOrWhiteSpace(cbo_prodtype.ControlValues.ToString())) | MESSAGE | MessageBox.Show | ("You need to Production data") | 메시지 표시 |  |  |  |
| AC-9a2ea98e | this.btnSave.Click | FP02841_LineAddPopup.cs:310 | if (string.IsNullOrWhiteSpace(cbo_prodtype.ControlValues.ToString())) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-765a312b | this.btnSave.Click | FP02841_LineAddPopup.cs:315 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Select Material") | 메시지 표시 |  |  |  |
| AC-c07d153a | this.btnSave.Click | FP02841_LineAddPopup.cs:316 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-792d9df2 | this.btnSave.Click | FP02841_LineAddPopup.cs:319 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02841_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94db5397 | Dispose | FP02841_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a7292c2 | this.Load | FP02841_LineAddPopup.cs:111 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-049d9921 | this.Load | FP02841_LineAddPopup.cs:113 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-11bba37a | this.Load | FP02841_LineAddPopup.cs:120 |  | FLAG | dtSave | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8a2c725 | this.Load | FP02841_LineAddPopup.cs:122 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b0fde7b | this.Load | FP02841_LineAddPopup.cs:123 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a6bc7d9 | this.Load | FP02841_LineAddPopup.cs:124 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-218c2bc0 | this.Load | FP02841_LineAddPopup.cs:125 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-47e91d8a | this.Load | FP02841_LineAddPopup.cs:126 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3144dc13 | this.Load | FP02841_LineAddPopup.cs:127 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c3462ea | this.Load | FP02841_LineAddPopup.cs:128 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e322ec4f | this.Load | FP02841_LineAddPopup.cs:129 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f34c8347 | this.Load | FP02841_LineAddPopup.cs:130 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6af48f92 | this.Load | FP02841_LineAddPopup.cs:131 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("NICK_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-33a1a7b5 | this.Load | FP02841_LineAddPopup.cs:132 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1489fed | this.Load | FP02841_LineAddPopup.cs:133 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e4c2563 | this.Load | FP02841_LineAddPopup.cs:134 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-abf190df | this.Load | FP02841_LineAddPopup.cs:135 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5be9cff | this.Load | FP02841_LineAddPopup.cs:137 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-92ae77ed | this.Load | FP02841_LineAddPopup.cs:138 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-166085fb | this.Load | FP02841_LineAddPopup.cs:140 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-61d0c9e8 | this.Load | FP02841_LineAddPopup.cs:140 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP02841_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e373f88e | this.Load | FP02841_LineAddPopup.cs:156 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8b10961 | this.Load | FP02841_LineAddPopup.cs:160 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add Material") | 메시지 표시 |  |  |  |
| AC-a9dea4de | this.Load | FP02841_LineAddPopup.cs:161 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-8e37c076 | this.Load | FP02841_LineAddPopup.cs:162 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f0abb4f | this.Load | FP02841_LineAddPopup.cs:165 |  | DATA_OP | Filter["CURR_DATE"] | "20210715" | 행/컬럼 값 대입 |  |  |  |
| AC-86738c5b | this.Load | FP02841_LineAddPopup.cs:171 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["FP_PLAN_DATE"] | Filter["PLAN_DATE"] = DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-13daaac8 | this.Load | FP02841_LineAddPopup.cs:171 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ebd5c572 | this.Load | FP02841_LineAddPopup.cs:173 |  | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-bfeac494 | this.Load | FP02841_LineAddPopup.cs:180 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(Filter["PLAN_DATE"].ToString()) < int.Parse(Filter["CURR_DATE"].ToString())) | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["CURR_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-6f925202 | this.Load | FP02841_LineAddPopup.cs:185 | else of (Filter["PLAN_TYPE"] == "RELEASE") | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-79810296 | this.Load | FP02841_LineAddPopup.cs:189 |  | VALUE_SET | txtNickName.Text | Filter["NICK_NAME"] = InitRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-14710276 | this.Load | FP02841_LineAddPopup.cs:189 |  | DATA_OP | Filter["NICK_NAME"] | InitRow["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f884d53c | this.Load | FP02841_LineAddPopup.cs:192 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-25b38bbb | this.Load | FP02841_LineAddPopup.cs:201 |  | FLAG | dtProdType | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-88802014 | this.Load | FP02841_LineAddPopup.cs:201 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PROD_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2afeb353 | this.Load | FP02841_LineAddPopup.cs:202 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cbo_prodtype, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1f7fa021 | this.Load | FP02841_LineAddPopup.cs:205 |  | FLAG | dtElectrode | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02844_Plan_ELEC_POST_WH_LOAD", "E… | 화면 필드/플래그 변경 |  |  |  |
| AC-36d18c71 | this.Load | FP02841_LineAddPopup.cs:205 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02844_Plan_ELEC_POST_WH_LOAD", "ELEC_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0788518 | this.Load | FP02841_LineAddPopup.cs:211 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, cbo_electrode, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-95740023 | this.Load | FP02841_LineAddPopup.cs:214 |  | FLAG | dtWHType | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-0f40996f | this.Load | FP02841_LineAddPopup.cs:214 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "WH_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d2f523fc | this.Load | FP02841_LineAddPopup.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtWHType, cbo_type, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4e77620d | this.Load | FP02841_LineAddPopup.cs:218 |  | VALUE_SET | cbo_prodtype.SelectedValue | Filter["PRODTYPE_ID"]= InitRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8f217831 | this.Load | FP02841_LineAddPopup.cs:218 |  | DATA_OP | Filter["PRODTYPE_ID"] | InitRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae982ebb | this.Load | FP02841_LineAddPopup.cs:220 |  | VALUE_SET | txtItem.Text | Filter["ITEM_ID"] = InitRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-83039a4d | this.Load | FP02841_LineAddPopup.cs:220 |  | DATA_OP | Filter["ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c541115b | this.Load | FP02841_LineAddPopup.cs:222 |  | VALUE_SET | txtBuilding.Text | Filter["FACTORY_ID"] = InitRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-682d21fa | this.Load | FP02841_LineAddPopup.cs:222 |  | DATA_OP | Filter["FACTORY_ID"] | InitRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-11c22b59 | this.Load | FP02841_LineAddPopup.cs:225 |  | DATA_OP | Filter["ELECTRODE_TYPE"] | InitRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2c184304 | this.Load | FP02841_LineAddPopup.cs:228 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-64c82846 | this.Load | FP02841_LineAddPopup.cs:229 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-baceb3a8 | this.Load | FP02841_LineAddPopup.cs:231 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-45bf9c09 | this.Load | FP02841_LineAddPopup.cs:232 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aaca69d5 | this.Load | FP02841_LineAddPopup.cs:233 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d6567e07 | this.Load | FP02841_LineAddPopup.cs:234 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8d5a2434 | this.Load | FP02841_LineAddPopup.cs:236 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-501192ff | this.Load | FP02841_LineAddPopup.cs:237 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6cc7cf13 | this.Load | FP02841_LineAddPopup.cs:240 |  | VALUE_SET | cbo_electrode.SelectedValue | Filter["ELECTRODE_TYPE"] = InitRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2569bc04 | this.Load | FP02841_LineAddPopup.cs:240 |  | DATA_OP | Filter["ELECTRODE_TYPE"] | InitRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP02841_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4a0852f | this.btnSave.Click | FP02841_LineAddPopup.cs:329 |  | DATA_OP | dtDateMap.Select | ("_DATE = '" + dpPlanDate.Value.ToString("yyyyMMdd") + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc29b2cd | this.btnSave.Click | FP02841_LineAddPopup.cs:341 | if (rowDay.Length < 1) | MESSAGE | MessageBox.Show | ("Out of plan period : " + sFromDate + " ~ " + sToDate ) | 메시지 표시 |  |  |  |
| AC-9ef59060 | this.btnSave.Click | FP02841_LineAddPopup.cs:342 | if (rowDay.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1970c7ad | this.btnSave.Click | FP02841_LineAddPopup.cs:345 |  | DATA_OP | Filter["CATEGORY_ID"] | "SLITTING_PLAN" | 행/컬럼 값 대입 |  |  |  |
| AC-5b115d33 | this.btnSave.Click | FP02841_LineAddPopup.cs:347 |  | DATA_OP | Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f646431e | this.btnSave.Click | FP02841_LineAddPopup.cs:348 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ce2354b6 | this.btnSave.Click | FP02841_LineAddPopup.cs:350 |  | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_ADD", Filter, UserInfoContext.Current.UserId, "SELECT", "DUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c08cc2a2 | this.btnSave.Click | FP02841_LineAddPopup.cs:355 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Material is already exists.") | 메시지 표시 |  |  |  |
| AC-0e867c02 | this.btnSave.Click | FP02841_LineAddPopup.cs:356 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-897fec20 | this.btnSave.Click | FP02841_LineAddPopup.cs:361 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-892ecd03 | this.btnSave.Click | FP02841_LineAddPopup.cs:365 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-26dad251 | this.btnSave.Click | FP02841_LineAddPopup.cs:366 | if (checkSave.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7652d36 | this.btnSave.Click | FP02841_LineAddPopup.cs:370 |  | DATA_OP | saveFilter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0ba10950 | this.btnSave.Click | FP02841_LineAddPopup.cs:371 |  | DATA_OP | saveFilter["FP_PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aed2c5c7 | this.btnSave.Click | FP02841_LineAddPopup.cs:372 |  | DATA_OP | saveFilter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f514787 | this.btnSave.Click | FP02841_LineAddPopup.cs:373 |  | DATA_OP | saveFilter["COMPANY_ID"] | Filter["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f978627c | this.btnSave.Click | FP02841_LineAddPopup.cs:374 |  | DATA_OP | saveFilter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6eac0545 | this.btnSave.Click | FP02841_LineAddPopup.cs:375 |  | DATA_OP | saveFilter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a046d033 | this.btnSave.Click | FP02841_LineAddPopup.cs:376 |  | DATA_OP | saveFilter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eb4c719f | this.btnSave.Click | FP02841_LineAddPopup.cs:377 |  | DATA_OP | saveFilter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-436e28c4 | this.btnSave.Click | FP02841_LineAddPopup.cs:378 |  | DATA_OP | saveFilter["ELECTRODE_TYPE"] | cbo_electrode.ControlValues.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c26aa087 | this.btnSave.Click | FP02841_LineAddPopup.cs:379 |  | DATA_OP | saveFilter["PRODUCTION_TYPE"] | cbo_prodtype.ControlValues.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-98229cfe | this.btnSave.Click | FP02841_LineAddPopup.cs:380 |  | DATA_OP | saveFilter["WH_TYPE"] | cbo_type.ControlValues.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2eda5dca | this.btnSave.Click | FP02841_LineAddPopup.cs:381 |  | DATA_OP | saveFilter["CATEGORY_ID"] | "SLITTING_PLAN" | 행/컬럼 값 대입 |  |  |  |
| AC-cca5a5b2 | this.btnSave.Click | FP02841_LineAddPopup.cs:382 |  | DATA_OP | saveFilter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-109d67e0 | this.btnSave.Click | FP02841_LineAddPopup.cs:383 |  | DATA_OP | saveFilter["DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4514a177 | this.btnSave.Click | FP02841_LineAddPopup.cs:384 |  | DATA_OP | saveFilter["USER_ID"] | Filter["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a5f06de9 | this.btnSave.Click | FP02841_LineAddPopup.cs:396 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-ff182841 | this.btnSave.Click | FP02841_LineAddPopup.cs:397 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5922cb64 | this.btnSave.Click | FP02841_LineAddPopup.cs:400 |  | DATA_OP | saveFilter["OUT_QTY"] | qty.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-009a9797 | this.btnSave.Click | FP02841_LineAddPopup.cs:402 |  | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_ADD_SAVE", saveFilter, CurrentUser, "SAVE", "ADD_SAVE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-72761aa8 | this.btnSave.Click | FP02841_LineAddPopup.cs:410 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e52ad62f | this.btnSave.Click | FP02841_LineAddPopup.cs:411 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_LinePopup.btnButtonList_UsrButtonList_Click_Detected_1

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-396e14ba | this.btnButtonList.UsrButtonList_Click_Detected | FP02841_LinePopup.cs:320 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d4ce1c5c | this.btnButtonList.UsrButtonList_Click_Detected | FP02841_LinePopup.cs:323 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-76f275b5 | this.btnButtonList.UsrButtonList_Click_Detected | FP02841_LinePopup.cs:324 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_LinePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a65d069d | this.Load | FP02841_LinePopup.cs:139 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9ac076a2 | this.Load | FP02841_LinePopup.cs:140 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-73a01773 | this.Load | FP02841_LinePopup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_LinePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3d8d7e9 | this.Load | FP02841_LinePopup.cs:134 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02841_LinePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d194845 | Dispose | FP02841_LinePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_LinePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1021a67 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:210 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-61287775 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:211 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-63850afd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:214 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0799568b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:216 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { //DataSet dtInstType = DataService.FP_ExecuteQuery("FP00601_LineAdd", "find_Insta… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f387faff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:219 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "INSTANCE_TYPE… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-94153d58 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:222 | lambda ▸ if (dtInstType.Good()) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstType.Tables[0].Rows[0]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-365035f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:225 | lambda | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a3f5ebfb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:226 | lambda | DATA_OP | Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-13117cff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:229 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_ADDLINE", Filter, UserInfoContext.Current.UserId, "SELECT", "LINE_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fed8d62a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:230 | lambda | RETURN | return lineList; |  | 처리 중단/반환 |  |  |  |
| AC-442772a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:234 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-162fbbad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:237 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-febc5388 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:239 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2e72137c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP02841_LinePopup.cs:243 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_LinePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52e7a6ae | this.Load | FP02841_LinePopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b28b6e0d | this.Load | FP02841_LinePopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_LinePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3215c516 | this.Load | FP02841_LinePopup.cs:128 |  | VALUE_SET | txtMaterial.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP02841_LinePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fca0295b | this.Load | FP02841_LinePopup.cs:151 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c177cb5 | this.Load | FP02841_LinePopup.cs:152 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_LinePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c811181 | (진입점 미연결) | FP02841_LinePopup.cs:171 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_LinePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c52c8334 | this.Load | FP02841_LinePopup.cs:158 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f98f15b7 | this.Load | FP02841_LinePopup.cs:159 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-f1c3a396 | this.Load | FP02841_LinePopup.cs:163 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP02841_LinePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c957529 | this.spdMain.CellClick | FP02841_LinePopup.cs:268 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-874a7914 | this.spdMain.CellClick | FP02841_LinePopup.cs:269 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3561d368 | this.spdMain.CellClick | FP02841_LinePopup.cs:272 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP02841_LinePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67f48f7b | this.spdMain.CellDoubleClick | FP02841_LinePopup.cs:278 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e7b06ee1 | this.spdMain.CellDoubleClick | FP02841_LinePopup.cs:279 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9378f66c | this.spdMain.CellDoubleClick | FP02841_LinePopup.cs:282 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-af11e726 | this.spdMain.CellDoubleClick | FP02841_LinePopup.cs:285 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c857e23 | this.spdMain.CellDoubleClick | FP02841_LinePopup.cs:295 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a35f138 | .ctor | FP02841_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-2c00f714 | .ctor | FP02841_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b07b92f7 | .ctor | FP02841_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-e885220d | .ctor | FP02841_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP02841_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-267ea63b | Dispose | FP02841_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cb14887 | this.Load | FP02841_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP02841_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34704903 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:184 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-bf3185a8 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:185 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-c4ca927f | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:212 |  | DATA_OP | ctrls.Add | (chk_notching) | 데이터 객체 조작/조회 |  |  |  |
| AC-17c5a2fa | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:213 |  | DATA_OP | ctrls.Add | (chk_intransit) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a61bcac | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:214 |  | DATA_OP | ctrls.Add | (chk_shipment) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab1cb7fa | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:215 |  | DATA_OP | ctrls.Add | (chk_coater) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b35a503 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:216 |  | DATA_OP | ctrls.Add | (chk_rollpress) | 데이터 객체 조작/조회 |  |  |  |
| AC-950029be | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:217 |  | DATA_OP | ctrls.Add | (chk_slitting) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdc8fe42 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:218 |  | DATA_OP | ctrls.Add | (chk_rollpress_roll) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfaf50ce | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_slitting_roll) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9e3cebf | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:220 |  | DATA_OP | ctrls.Add | (chk_moving) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b17ac47 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:222 |  | DATA_OP | ctrls.Add | (chk_eoh_jr) | 데이터 객체 조작/조회 |  |  |  |
| AC-3132b95b | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_eoh_pc) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3ca5251 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_eoh_jr_pre) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b002bf7 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_eoh_jr_post) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab7d027f | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_assy_eoh) | 데이터 객체 조작/조회 |  |  |  |
| AC-929858e6 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_eoh_elec) | 데이터 객체 조작/조회 |  |  |  |
| AC-d062b9e6 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_eoh_jr_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a49a87f | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_eoh_pc_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7f061c3 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_eoh_jr_pre_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-673575a7 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_eoh_jr_post_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe9c32a5 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:233 |  | DATA_OP | ctrls.Add | (chk_assy_eoh_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bf4fa05 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_eoh_elec_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-f78b2cd5 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_tot_coater) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba92b304 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_tot_rollpress) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac2d0383 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_tot_slitting) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3633b49 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_tot_notching) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdf2cdc1 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_tot_load) | 데이터 객체 조작/조회 |  |  |  |
| AC-823593b9 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_tot_roll) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ae9dc8a | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbeb4749 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:248 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a810aff1 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:248 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-9c9e5dd8 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:255 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-76d04087 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:259 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-f64e3ef0 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:263 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP02841_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47234733 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_notching.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-69e67536 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_intransit.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b9fba8a8 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_shipment.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a3903a25 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:133 |  | VALUE_SET | chk_coater.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ed73f6eb | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_rollpress.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-04963c90 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_slitting.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bbc4e1ee | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_rollpress_roll.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a4170b9e | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_slitting_roll.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0f722dfa | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_moving.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-36e3c8ef | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_eoh_jr.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5cf0af2c | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_eoh_pc.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b1242fdf | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_eoh_jr_pre.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c2aad6a5 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_eoh_jr_post.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fe6cfc52 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_assy_eoh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b3eea80f | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_eoh_elec.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-88d7b98d | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_eoh_jr_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-97c7fa48 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_eoh_pc_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3e8694b4 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_eoh_jr_pre_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-80af181f | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_eoh_jr_post_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e8f9b713 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_assy_eoh_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4bc5319e | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_eoh_elec_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-50047e64 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_tot_coater.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b0d957c6 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_tot_rollpress.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-018475a8 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_tot_slitting.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d61f95d4 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_tot_notching.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cfb6c139 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_tot_load.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-548863ad | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_tot_roll.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2a417f00 | this.Load 외 1 | FP02841_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP02841_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c4745f2 | (진입점 미연결) | FP02841_MeasureSetForm_Popup.cs:323 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-261f23e0 | (진입점 미연결) | FP02841_MeasureSetForm_Popup.cs:334 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab08a96d | (진입점 미연결) | FP02841_MeasureSetForm_Popup.cs:345 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP02841_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ebc9593 | this.Load | FP02841_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-08b3f5e4 | this.Load | FP02841_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02841_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0723a8a | this.usrButton1.Click | FP02841_MeasureSetForm_Popup.cs:307 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-2176008b | this.usrButton1.Click | FP02841_MeasureSetForm_Popup.cs:307 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-4fcc447e | this.usrButton1.Click | FP02841_MeasureSetForm_Popup.cs:309 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-14fce9a4 | this.usrButton1.Click | FP02841_MeasureSetForm_Popup.cs:313 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-d81c29ff | this.usrButton1.Click | FP02841_MeasureSetForm_Popup.cs:314 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-8622a1d3 | this.usrButton1.Click | FP02841_MeasureSetForm_Popup.cs:316 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff273a52 | this.usrButton1.Click | FP02841_MeasureSetForm_Popup.cs:318 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP02841_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ae05bac | this.usrButton2.Click | FP02841_MeasureSetForm_Popup.cs:281 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-65b68121 | this.usrButton2.Click | FP02841_MeasureSetForm_Popup.cs:281 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-7c55aaf5 | this.usrButton2.Click | FP02841_MeasureSetForm_Popup.cs:283 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-9e64bb57 | this.usrButton2.Click | FP02841_MeasureSetForm_Popup.cs:287 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-074a01f6 | this.usrButton2.Click | FP02841_MeasureSetForm_Popup.cs:288 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-8d2e2917 | this.usrButton2.Click | FP02841_MeasureSetForm_Popup.cs:289 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b97d3f5f | this.usrButton2.Click | FP02841_MeasureSetForm_Popup.cs:290 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60634609 | .ctor | FP02841_Plan_Amend_Elec_Post.cs:114 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-3350cdb7 | .ctor | FP02841_Plan_Amend_Elec_Post.cs:115 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-83a2c422 | .ctor | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:114 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-d9263cea | .ctor | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:115 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELEC_POST") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlan…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80694fb8 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2845 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7874453b | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2846 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2dc0bd0d | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2847 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-749389c1 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2848 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-637c0640 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2849 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-80890a81 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2852 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-e20df29b | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2852 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-36e2ab84 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2853 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-1e1cf3b2 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2853 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0f42cd08 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2854 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-da433e49 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2854 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c54bfdf9 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2855 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-3364dea2 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2855 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-abbb1f07 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2867 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-5a8d6108 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2868 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-7322a515 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2869 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-7895eb07 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2870 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-66870cc9 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2734 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-20d95082 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2735 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-03539c27 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2736 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e20aa169 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2737 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-053d4025 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2738 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6626c25f | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2741 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-0faeeec4 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2741 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c1fa04f1 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2742 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-22451161 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2742 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4f666509 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2743 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-43cecdd5 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2743 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dc9f1615 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2744 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-4aa49219 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2744 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-50f6cc6d | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2756 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-80acc7f4 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2757 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-b8dfec6f | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2758 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f32cc494 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2759 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELEC_POST") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlan…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25530596 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2876 | if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-74fae386 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2882 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //set["USER_ID"] = "chkim.68"; Filter["BUCKET_FROM"] = dr… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8272a997 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2885 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-bec8968a | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2886 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-fcfc6094 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2887 | lambda | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0e6ef28f | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2891 | lambda ▸ if (cboPlanId.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-71c345fe | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2897 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-89155206 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2898 |  | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R " | 행/컬럼 값 대입 |  |  |  |
| AC-ec4a36d9 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2899 |  | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_R " | 행/컬럼 값 대입 |  |  |  |
| AC-dd3dde06 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2900 |  | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-01c0941c | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2901 |  | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_R " | 행/컬럼 값 대입 |  |  |  |
| AC-a7ad5c46 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2905 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-870f1d46 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2906 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H " | 행/컬럼 값 대입 |  |  |  |
| AC-8c393ec2 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2907 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_H " | 행/컬럼 값 대입 |  |  |  |
| AC-48863e81 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2908 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-d397ecb5 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2909 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_H " | 행/컬럼 값 대입 |  |  |  |
| AC-dc2717a8 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2913 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cad2be1f | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2769 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d22a50c6 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2770 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d27053f4 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2771 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-522b061c | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2776 | if (cboPlanId.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-9f2ff655 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2779 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-bfcad0d2 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2780 |  | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R " | 행/컬럼 값 대입 |  |  |  |
| AC-cdd0e3b3 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2781 |  | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_R " | 행/컬럼 값 대입 |  |  |  |
| AC-d992c551 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2782 |  | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-7765474f | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2783 |  | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_R " | 행/컬럼 값 대입 |  |  |  |
| AC-543554f8 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2787 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-503a125d | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2788 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H " | 행/컬럼 값 대입 |  |  |  |
| AC-d7141a9a | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2789 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_H " | 행/컬럼 값 대입 |  |  |  |
| AC-3417c1be | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2790 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-4289bec9 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2791 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_H " | 행/컬럼 값 대입 |  |  |  |
| AC-4fd2a708 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2795 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cadaa12 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post.cs:5842 |  | POPUP | new FP02841_BucketSetForm_Popup | ("FP02841", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-3a0a194b | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post.cs:5843 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-678f9729 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post.cs:5844 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-63e55617 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post.cs:5845 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a0da26d0 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post.cs:5849 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-444703d3 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post.cs:5858 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4e8fe041 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post.cs:5860 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-14a1571d | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5715 |  | POPUP | new FP02841_BucketSetForm_Popup | ("FP02841", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-dfb4e139 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5716 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-0c251ed3 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5717 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-96de59cb | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5718 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-76550738 | this.btnBucket.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5722 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnCatagory_Click

진입점: this.btnCategory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37572b30 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post.cs:5805 |  | POPUP | new FP02841_MeasureSetForm_Popup | ("FP02841", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-02c42d07 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post.cs:5807 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-47650f85 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post.cs:5809 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bf95f813 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post.cs:5810 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c860d79c | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post.cs:5814 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a9bee929 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post.cs:5823 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7ff5c641 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post.cs:5825 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2503d51e | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5680 |  | POPUP | new FP02841_MeasureSetForm_Popup | ("FP02841", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-f8c60fb5 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5682 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-b1ddeb9f | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5684 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-80239bd9 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5685 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7b63f6d6 | this.btnCategory.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5689 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a651a14 | this.btnColumn.Click | FP02841_Plan_Amend_Elec_Post.cs:5784 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP02841", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-df3ce514 | this.btnColumn.Click | FP02841_Plan_Amend_Elec_Post.cs:5786 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c2278406 | this.btnColumn.Click | FP02841_Plan_Amend_Elec_Post.cs:5787 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a2c57362 | this.btnColumn.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5659 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP02841", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-d0c8ddd5 | this.btnColumn.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5661 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0070fe14 | this.btnColumn.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5662 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnCreatePlan_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05f93766 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6133 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f2b7a4a6 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6134 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f521425a | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6144 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Master.PR_UI_FP02841_ETC | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-61a7501b | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6146 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6127a711 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6152 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1315912 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6153 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c288ad07 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6158 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9da5d98 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6159 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07005591 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6162 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-60696546 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6163 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e7dca4c | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6164 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3690c37 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6170 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-2cc0452a | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6173 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-ab9a8f8d | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6174 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-ec20a601 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6175 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-dadda8fa | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6177 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-148fccb5 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6178 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b14d3121 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6189 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-54ec8137 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6189 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-4ecedda2 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post.cs:6196 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cboPlanId.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |
| AC-fd12754a | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5948 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-69142d94 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5954 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a9a4d872 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5955 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6d217fa | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5965 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Master.PR_UI_FP02841_ETC | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a1d45ca | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5967 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d9f14fe3 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5973 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-698a73c9 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5974 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8305f6d0 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5979 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34789d28 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5980 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34efec66 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5983 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-83c6a680 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5984 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-697b68cf | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5985 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3c2811a | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5991 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-f5a73ad1 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5994 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-be5865b7 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5995 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-da7cccfa | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5996 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-19206cc3 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5998 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-d85c5737 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5999 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2f027fdb | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6010 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-5c966caf | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6010 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-056a4ee4 | this.usrButton1.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6017 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cboPlanId.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b428a1f4 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2919 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-cfe0b4c7 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2920 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54c06bd2 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2925 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-78962b6c | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2926 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf41b2ef | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2929 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d1f995fc | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2930 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf5a9d6d | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2931 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2aa25767 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2932 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6ad50be6 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2939 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP02841_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-68198a64 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2941 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e3f0f5e8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2941 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cb0b4e48 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2943 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.QTY | 속성 DateColumnType 설정 |  |  |  |
| AC-b085140f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2945 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6deb9dd | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2946 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ab94c80b | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2947 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2a6a8b58 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2948 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fa894911 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2949 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-baa22488 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2950 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-be0fd98f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2951 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ATTR_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5b1101fa | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2952 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5c52de68 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2955 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-2a88bb08 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2956 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-6a5b83f6 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2957 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-d90abecb | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2958 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-3d2aa138 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2959 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-b93d06c4 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2960 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-c98ae431 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2961 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-28b91da5 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2962 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-392bc2ee | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2963 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ATTR_TYPE"] | "W/H Type" | 행/컬럼 값 대입 |  |  |  |
| AC-cbc9454b | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2964 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MOVING_FACTORY"] | "Moving Factory" | 행/컬럼 값 대입 |  |  |  |
| AC-b0ba9f64 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2965 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["CATEGORY_ID"] | "Category" | 행/컬럼 값 대입 |  |  |  |
| AC-a235d447 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2968 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | call_Excel_Col_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-7b0e1a68 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2969 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | call_Excel_Col_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-7d9494b8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2970 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | call_Excel_Col_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-259a079d | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2971 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | call_Excel_Col_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-e9aed346 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2972 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3c52c172 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2982 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP02841_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-4c2a3b72 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2984 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9731621d | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2984 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e46c89b4 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2988 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-362e4c21 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2989 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d2499818 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2990 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8801058b | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2991 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0fc8e79c | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2992 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9883fb1e | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2993 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-89404f0e | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2994 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-00b80385 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2995 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ATTR_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d5f45021 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2996 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["CATEGORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-334391d0 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2997 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-92636d18 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:2998 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-bd8de81c | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3000 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-84750f43 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3001 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-6b03d37a | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3002 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-2cb4c511 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3003 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-44b8c190 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3004 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-331c1141 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3005 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-817bfae6 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3006 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-fd077c46 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3007 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-2c2098c9 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3008 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ATTR_TYPE"] | "W/H Type" | 행/컬럼 값 대입 |  |  |  |
| AC-361fb38f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3009 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MOVING_FACTORY"] | "Moving Factory" | 행/컬럼 값 대입 |  |  |  |
| AC-0d7d6f7a | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3010 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["CATEGORY_ID"] | "Category" | 행/컬럼 값 대입 |  |  |  |
| AC-125dbadd | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3011 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-26fb5973 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3012 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9d3e8516 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3013 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-87376fac | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3015 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["DIVISION_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-5dc1fa61 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3016 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["SITE_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-a288702a | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3017 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PLANT_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-e28231ef | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3018 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["FACTORY_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-51211188 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3019 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ITEM_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-6f3b886e | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3020 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ELECTRODE_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-ae41e500 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3021 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PRODUCTION_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-e5388803 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3022 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ATTR_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-af2e46c9 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3023 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["MOVING_FACTORY"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-7609254e | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3024 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["CATEGORY_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-b71a04e8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3025 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PLAN_DATE"] | "DATE_YYYYMMDD" | 행/컬럼 값 대입 |  |  |  |
| AC-c33252e7 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3026 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["QTY"] | "NUMBER" | 행/컬럼 값 대입 |  |  |  |
| AC-4614cbd0 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3028 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["DIVISION_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-d58a9ee8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3029 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["SITE_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-df30a660 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3030 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PLANT_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-3af1c725 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3031 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["FACTORY_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-7062d334 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3032 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ITEM_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-692089a0 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3033 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ELECTRODE_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-332b2c4c | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3034 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PRODUCTION_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-895b7937 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3035 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ATTR_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-3bb56472 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3036 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["MOVING_FACTORY"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-7fafdc76 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3037 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["CATEGORY_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-f3a8209d | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3038 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PLAN_DATE"] | 8 | 행/컬럼 값 대입 |  |  |  |
| AC-f0e00138 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3039 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["QTY"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-9a65c1b8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3041 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-14e5c04a | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3043 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-1b419dd5 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3044 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-0e10727f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post.cs:3045 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-64f35058 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2801 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-c58cc484 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2802 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99d0a0f0 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2807 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-6c93333a | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2808 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13345fea | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2811 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-f2a61e90 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2812 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f062c9f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2813 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-77edfa20 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2814 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3e57e1bc | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2821 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP02841_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-d6a41155 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2823 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-fc4256aa | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2823 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e166d0b6 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2825 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.QTY | 속성 DateColumnType 설정 |  |  |  |
| AC-8a2e548b | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2827 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1b46eb94 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2828 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c95a0403 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2829 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1c9e0ea9 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2830 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a5bd8a89 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2831 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3984e561 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2832 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b4500e2f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2833 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ATTR_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d353e069 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2834 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-610dd41a | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2837 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-9203f664 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2838 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-c4c3c2de | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2839 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-842e6f8f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2840 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-0ee1f872 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2841 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-df5b5506 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2842 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-9ed7d915 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2843 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-f687102f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2844 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-6972d47d | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2845 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ATTR_TYPE"] | "W/H Type" | 행/컬럼 값 대입 |  |  |  |
| AC-63ce7435 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2846 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MOVING_FACTORY"] | "Moving Factory" | 행/컬럼 값 대입 |  |  |  |
| AC-8a325aa8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2847 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["CATEGORY_ID"] | "Category" | 행/컬럼 값 대입 |  |  |  |
| AC-5bbc38e9 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2850 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | call_Excel_Col_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-a63bfa82 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2851 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | call_Excel_Col_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-131fe191 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2852 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | call_Excel_Col_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-5d0456d5 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2853 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | call_Excel_Col_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-edeb5e70 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2854 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-585ee8bc | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2864 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP02841_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-b36cebe7 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2866 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-e5500df2 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2866 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b3cdb32 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2870 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a91487de | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2871 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fe4d6684 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2872 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e74f0bd8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2873 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a4b4e4e1 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2874 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-60ab77b3 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2875 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b1b932cb | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2876 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-17c36d27 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2877 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ATTR_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6717cd04 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2878 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["CATEGORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0aff2a25 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2879 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0255a46e | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2880 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-df75c200 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2882 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-c5eae2d7 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2883 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-6710b1b2 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2884 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-dd584cd4 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2885 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-3f6439ee | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2886 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-abc7f0d2 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2887 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-a9fef0cd | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2888 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-d1f0735b | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2889 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-befc1aea | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2890 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ATTR_TYPE"] | "W/H Type" | 행/컬럼 값 대입 |  |  |  |
| AC-d3334d22 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2891 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MOVING_FACTORY"] | "Moving Factory" | 행/컬럼 값 대입 |  |  |  |
| AC-addc24d8 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2892 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["CATEGORY_ID"] | "Category" | 행/컬럼 값 대입 |  |  |  |
| AC-337cb7df | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2893 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-f0136818 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2894 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-8da085c2 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2895 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-709a4f7e | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2897 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["DIVISION_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-0ad14195 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2898 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["SITE_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-5bf00564 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2899 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PLANT_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-18cddb72 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2900 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["FACTORY_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-19ee7687 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2901 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ITEM_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-e2424b9c | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2902 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ELECTRODE_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-707bf89a | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2903 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PRODUCTION_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-a82aae65 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2904 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["ATTR_TYPE"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-b99a0f2f | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2905 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["MOVING_FACTORY"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-e0f3a346 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2906 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["CATEGORY_ID"] | "STRING" | 행/컬럼 값 대입 |  |  |  |
| AC-06220f50 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2907 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["PLAN_DATE"] | "DATE_YYYYMMDD" | 행/컬럼 값 대입 |  |  |  |
| AC-4235b074 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2908 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnType["QTY"] | "NUMBER" | 행/컬럼 값 대입 |  |  |  |
| AC-e70b4683 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2910 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["DIVISION_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-7fd75dfa | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2911 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["SITE_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-5b5d64d5 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2912 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PLANT_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-25ddd2be | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2913 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["FACTORY_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-8d0690ad | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2914 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ITEM_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-86677781 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2915 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ELECTRODE_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-a4f39b00 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2916 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PRODUCTION_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-d569007c | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2917 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["ATTR_TYPE"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-57b66b02 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2918 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["MOVING_FACTORY"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-a6f17cb7 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2919 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["CATEGORY_ID"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-fb03382b | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2920 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["PLAN_DATE"] | 8 | 행/컬럼 값 대입 |  |  |  |
| AC-5d8d8fad | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2921 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnLength["QTY"] | 30 | 행/컬럼 값 대입 |  |  |  |
| AC-cb3283e0 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2923 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-15d4ccb6 | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2925 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-5735adaa | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2926 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-59be07af | this.btnExcelImport.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2927 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnMemo_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ab839a7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6203 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-53ed5fb5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6206 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-5d8551f3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6207 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28a4dd50 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6210 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-597ad2cf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6211 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-626c5a50 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6212 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-305fdece | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6212 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c3eb17be | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6213 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b06da3e2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6214 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac4c24b0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6215 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f530039c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6215 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-85ffaa43 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6216 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b64cdc35 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6217 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5d8f9392 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6218 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3ab3fb19 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6219 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-50d9af00 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6220 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e54e116f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6221 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-afb9988c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6222 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4aa86503 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6223 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ea3311b2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6224 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-40fbb587 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6226 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-672dface | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6227 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-71aaf99e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6228 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-79ad9248 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6229 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnMenu_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab513e82 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6240 | if (flo == null) | FLAG | flo | new MenuFloater() | 화면 필드/플래그 변경 |  |  |  |
| AC-8ce01a01 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6241 | if (flo == null) | POPUP | flo.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2e8af2c5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6243 | if (flo == null) ▸ if (mainForm != null) | CALL_EXT | flo.SetMainForm | (mainForm) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01d4207c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6244 | if (flo == null) | CALL_EXT | flo.SetMyPanel | (btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e49994f1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6252 | else of (flo == null) ▸ if (flo.Visible == false) | POPUP | flo.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1764c9a4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6253 | else of (flo == null) ▸ if (flo.Visible == false) | CALL_EXT | flo.SetMyPanel | (btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c286c6a5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6256 | else of (flo == null) ▸ else of (flo.Visible == false) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnMRP_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-140d8f53 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5912 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-6e53713c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5915 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-abbeba0a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5917 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c47ab0f4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5920 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-1c6e76a6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5921 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e338b55 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5926 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-0366b886 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5927 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2e10b6f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5932 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-2f763467 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5933 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-128ec5ac | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5937 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-5c769421 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5938 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86a6f5ad | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5939 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1d775cf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5940 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-05e29d0c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5942 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnRelease_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21320dcd | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6051 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-a165d808 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6057 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e9d8629 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6058 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4fac9e4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6062 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b1c87394 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6063 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e6d7ef86 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6066 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-1f52d1cb | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6067 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5da2c5e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6081 | if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f35112a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6082 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-948212b2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6088 | if (sPlanID == "-") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4efccac | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6089 | if (sPlanID == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3de0623 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6096 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "00 Plan cant not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8abfe88b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6097 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d5a7d78 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6100 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_instanceInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-25d3c5e9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6101 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_planInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d9863d44 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6103 |  | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-741e56c9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6109 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Release type plan can not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b7b2b90 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6110 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff345b42 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6114 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1afdfb59 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6118 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7df49188 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6119 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be3f7fd1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6126 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-770d95ce | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6127 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a59a57f8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6138 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2569bf85 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6141 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-162a281f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6143 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5ecf18af | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6149 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a47a0f5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6150 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26d450df | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6163 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca230a91 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6164 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-01750688 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6176 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e05365ab | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6179 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-59eee24d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6180 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-dbef4abd | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6181 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-a98a698f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6182 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-908b608c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6190 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-907fe739 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6193 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-da9b45af | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6194 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-3ae23cb0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6195 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-8dc827a4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6196 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnReplan_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bbb20ef | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6045 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnRePlan_Click

진입점: this.usrButton3.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98687010 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6012 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5ebfde2 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6013 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8321c3e | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6019 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release Plan cant't Re-Release.!") | 메시지 표시 |  |  |  |
| AC-fba4282f | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6020 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b27c96b | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6025 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageBox.Show | ("Select Plan ID !") | 메시지 표시 |  |  |  |
| AC-1040fd90 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6026 | if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b5eb24f | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6031 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", Filter["INSTANCE_ID"].ToString()) ⇒ FP_Master.PR_UI_FP02841_ETC | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6fb00ef | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6033 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0f37cc6b | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6039 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9043bd8e | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6040 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11c91cc7 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6056 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", pInstance)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d48a79a4 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6057 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-196c8c76 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6060 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7058b51c | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6061 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c393908f | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6062 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e771a1f | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6063 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("PLAN_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0375006c | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6066 |  | GRID_SET | dtParam.Rows[0]["PLAN_TYPE"] | pPlanType | 그리드 속성/값 설정 |  |  |  |
| AC-2ed1c656 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6071 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-00925875 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6078 |  | POPUP | new FP00590_RePlanTotalPopup | (pSite, pInstance, pPlanDate, pPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-252e21d0 | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6079 |  | VALUE_SET | popPlanTotal.Text | "Re Plan" | 컨트롤 값 설정 |  |  |  |
| AC-60bc569c | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6080 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-694c394b | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6082 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-aeccd76c | this.usrButton3.Click | FP02841_Plan_Amend_Elec_Post.cs:6083 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42802b48 | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post.cs:1650 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5d5f8983 | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post.cs:1651 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6f19f10b | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post.cs:1653 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02841_PLAN_AMEND_ELEC_POST") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f80f5a8 | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post.cs:1654 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-52a51150 | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1462 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-abc637dd | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1463 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ce4d65dd | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1465 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02841_PLAN_AMEND_ELEC_POST") | 데이터 객체 조작/조회 |  |  |  |
| AC-f67aefb3 | this.btnSql.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1466 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnSSP_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9965e5f1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5879 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-c05f191e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5880 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cfaa35f7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5881 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c0200add | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5884 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-ce77803d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5885 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90187100 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5890 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-340aace7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5891 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6ddeb67 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5896 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-17491d6c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5897 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d00e262c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5901 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-b464f90e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5902 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09c4ce85 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5903 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9ab0d97f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5904 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_SSP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-c3aa3ca7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5906 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-456fbea3 | this.btnToggleSave.Click | FP02841_Plan_Amend_Elec_Post.cs:5876 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-f996905f | this.btnToggleSave.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5747 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10c748ea | this.button1.Click | FP02841_Plan_Amend_Elec_Post.cs:6239 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.call_Excel_Col_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27527cd2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3290 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-949014af | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3172 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.call_Excel_Col_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32ae5727 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3090 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-721bd119 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3094 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-1db6d1cc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3095 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-184b34f5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3098 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-dc725c20 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3103 | if (popup != null) | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0d1326a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3108 | if (popup != null) ▸ if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2257a7e4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3113 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_SAVE", popup.Filter, CurrentUser, "SAVE", "MERGE_SAVE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b24a111 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3122 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-243f103a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3123 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-689eacf7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3126 | if (popup != null) ▸ if (do_save) | RETURN | return rsSave; |  | 처리 중단/반환 |  |  |  |
| AC-3d73b63d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3130 | if (popup != null) ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-26c076cd | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3135 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a64be23c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2972 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ee6d8ac7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2976 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-b6da922e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2977 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d3a959cb | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2980 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-fdf7cc45 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2985 | if (popup != null) | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d8485eba | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2990 | if (popup != null) ▸ if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-84bf7493 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2995 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_SAVE", popup.Filter, CurrentUser, "SAVE", "MERGE_SAVE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1890a7be | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3004 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-b381c925 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3005 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-96254c80 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3008 | if (popup != null) ▸ if (do_save) | RETURN | return rsSave; |  | 처리 중단/반환 |  |  |  |
| AC-81303bd8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3012 | if (popup != null) ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-a88865d7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3017 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.call_Excel_Col_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d7a560e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3061 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-cf251b01 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3065 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_COLUMN_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-43324ba9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3068 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ( "INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTOR… | ⚠ 의미 확인 필요 |  |  |  |
| AC-42afa3ca | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3074 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("INSTANCE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-57b19495 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3075 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("FP_PLAN_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2138be5e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3076 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("COMPANY_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec4941cf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3078 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-3819450d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3081 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-33c2bf19 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2943 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ff7d4548 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2947 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_COLUMN_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-44be2ee9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2950 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ( "INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTOR… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa2a6c39 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2956 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("INSTANCE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-173807f9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2957 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("FP_PLAN_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f51046ba | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2958 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("COMPANY_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7c324ca | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2960 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-b3399070 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2963 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.call_Excel_Col_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4a283d2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3143 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e5c0fc53 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3145 |  | UI_PROP | popup.dsSaveExcelData | new DataSet() | 속성 dsSaveExcelData 설정 |  |  |  |
| AC-ca7002f0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3146 |  | DATA_OP | popup.dsSaveExcelData.Tables.Add | (data.Tables[0].Clone()) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ab6da9b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3146 |  | DATA_OP | data.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-80efb2b3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3149 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-93b0896f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3150 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("PLAN_DATE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-76ecee60 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3151 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e0edd58 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3152 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("QTY")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf9a9519 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3153 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-379db293 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3154 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc51f83c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3155 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-38e3442a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3156 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b8ca926 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3157 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-25ecc901 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3158 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5ae60d0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3159 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba0a1312 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3160 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("COMPANY_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c63b28d7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3161 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1dca3af7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3162 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("PRODUCTION_TYPE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b79f86cf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3163 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("MOVING_FACTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-426b39c5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3164 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("MOVING_FACTORY")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("MOVING_FACTORY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb5fe7df | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3185 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b98c0f56 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3187 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["INSTANCE_ID"] | popup.Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-76f0bdb9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3188 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-06a53d9d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3189 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["COMPANY_ID"] | popup.Filter["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f5a40499 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3191 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLAN_DATE"] | aDate.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e151ca80 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3192 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["QTY"] | row[sQtyCol].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-5497e6d5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3194 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["DIVISION_ID"] | row["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-00ba1715 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3195 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SITE_ID"] | row["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3c691056 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3196 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLANT_ID"] | row["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-577df50b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3197 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FACTORY_ID"] | row["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-013b6e9f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3198 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_ID"] | row["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-92434923 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3199 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-65fe5aa6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3200 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-25772792 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3201 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ATTR_TYPE"] | row["ATTR_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c5abcddc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3202 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["CATEGORY_ID"] | row["CATEGORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-91723a49 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3204 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["MOVING_FACTORY"] | row["MOVING_FACTORY"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9d910fd | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3207 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].Rows.Add | (pivotLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-d55908c2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3224 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-68b30c6d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3228 | if (popup != null) ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-16d39752 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3232 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d4783ea | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3233 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-995494e3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3234 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5015d2a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3235 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9966d2c2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3236 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5fdaf7c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3237 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0681487f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3238 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-85bb29a5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3239 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-73477035 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3240 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-593cdef9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3241 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-394901ac | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3242 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5913097b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3243 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31e59086 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3244 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-40d63e2a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3245 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-676544d7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3246 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c02ea04 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3247 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("NP_ITEM_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc78cdd2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3248 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MOVING_FACTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-7508e8a0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3249 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("MOVING_FACTORY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MOVING_FACTORY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-91001593 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3255 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-a2ad581a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3257 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-cf529c59 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3258 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0837e886 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3259 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bf4d1199 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3264 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-db6aabc5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3267 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-9035945b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3268 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-7bbc74df | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3269 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-086b095e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3270 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-b394767e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3273 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NP_ITEM_ID"] | np_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ddb2e0b5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3276 | if (popup != null) | ENDPOINT | DataService.FP_UpdateBatch | ("FP02841_Plan_Amend_Elec_Post", "insert_Excel_buffer", dataLocal, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-44915852 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3278 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_VALIDATION") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c5406b8a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3280 | if (popup != null) | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-79ba20a1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3284 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-569d0656 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3025 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c031f289 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3027 |  | UI_PROP | popup.dsSaveExcelData | new DataSet() | 속성 dsSaveExcelData 설정 |  |  |  |
| AC-2c50d2e5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3028 |  | DATA_OP | popup.dsSaveExcelData.Tables.Add | (data.Tables[0].Clone()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8675b74d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3028 |  | DATA_OP | data.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8fe662b0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3031 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbe00da4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3032 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("PLAN_DATE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b42c3a8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3033 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-19262f65 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3034 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("QTY")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-52463c7b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3035 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-961cc69e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3036 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ee0e401 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3037 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2b668a5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3038 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-35700a8d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3039 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f33e6131 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3040 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fdb4d06 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3041 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6ab6124 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3042 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("COMPANY_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f5b8d7c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3043 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc187719 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3044 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("PRODUCTION_TYPE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb93cb63 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3045 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("MOVING_FACTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-996eb7dc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3046 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("MOVING_FACTORY")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("MOVING_FACTORY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ca81bd4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3067 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3eee84d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3069 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["INSTANCE_ID"] | popup.Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7a46918f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3070 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3ded0a46 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3071 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["COMPANY_ID"] | popup.Filter["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3f31d435 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3073 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLAN_DATE"] | aDate.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-23f4ff6f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3074 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["QTY"] | row[sQtyCol].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-394e6c94 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3076 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["DIVISION_ID"] | row["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8cbd070e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3077 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SITE_ID"] | row["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dd97c595 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3078 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLANT_ID"] | row["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d2c9b693 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3079 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FACTORY_ID"] | row["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2116f7a8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3080 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_ID"] | row["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a0bc058b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3081 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-dc1dbfa5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3082 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8df3ec74 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3083 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ATTR_TYPE"] | row["ATTR_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2056933b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3084 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["CATEGORY_ID"] | row["CATEGORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ff686e2a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3086 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["MOVING_FACTORY"] | row["MOVING_FACTORY"] | 행/컬럼 값 대입 |  |  |  |
| AC-b9d468ab | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3089 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].Rows.Add | (pivotLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9426063 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3106 | if (popup != null) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c25f7a96 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3110 | if (popup != null) ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-9255929d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3114 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8a41346 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3115 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3b28e13 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3116 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-d958dec7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3117 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ce3479e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3118 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-c80b8fdb | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3119 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee46bae1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3120 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-10ec0195 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3121 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-33b4e411 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3122 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-645c62a3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3123 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-435621f0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3124 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e479d0f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3125 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cc77834 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3126 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f1bd314 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3127 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-103d0686 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3128 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-88ca6f20 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3129 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("NP_ITEM_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed5370d0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3130 | if (popup != null) | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MOVING_FACTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f45155c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3131 | if (popup != null) ▸ if (!dataLocal.Tables[0].Columns.Contains("MOVING_FACTORY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MOVING_FACTORY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-74e85988 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3137 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-02d7245c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3139 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8d93abbe | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3140 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-220ab4ce | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3141 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f869e62 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3146 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-d33bdd60 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3149 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-2da81b53 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3150 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-c846c9d8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3151 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-fed5471d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3152 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-04a8461b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3155 | if (popup != null) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NP_ITEM_ID"] | np_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d863bba0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3158 | if (popup != null) | ENDPOINT | DataService.FP_UpdateBatch | ("FP02841_Plan_Amend_Elec_Post", "insert_Excel_buffer", dataLocal, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-fb6341e6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3160 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_VALIDATION") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-26daa874 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3162 | if (popup != null) | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-00b36a8c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3166 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b03178a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3314 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e033a3d6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3316 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4f00d756 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3320 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-87d62a03 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3321 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f882f39d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3327 | if (popup != null) | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf362334 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3332 | if (popup != null) ▸ if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5007e4a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3338 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_SAVE", popup.Filter, CurrentUser, "SAVE", "MERGE_SAVE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d2b3930a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3347 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-11752f19 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3348 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-996d5266 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3351 | if (popup != null) ▸ if (do_save) | RETURN | return rsSave; |  | 처리 중단/반환 |  |  |  |
| AC-9f7064c5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3355 | if (popup != null) ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-f2dbcd3a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3360 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-7dcb06f6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3196 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d84ce691 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3198 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b05c5768 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3202 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-8805ace4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3203 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b7b4fb3a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3209 | if (popup != null) | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d12e127 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3214 | if (popup != null) ▸ if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c2172f7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3220 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_SAVE", popup.Filter, CurrentUser, "SAVE", "MERGE_SAVE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bd46b33b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3229 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-321684c4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3230 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-051e083c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3233 | if (popup != null) ▸ if (do_save) | RETURN | return rsSave; |  | 처리 중단/반환 |  |  |  |
| AC-05fdca73 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3237 | if (popup != null) ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-46a92028 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3242 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2045939 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3298 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5cb92fee | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3302 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_ROW_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a4608f79 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3303 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-ab6fe3bb | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3306 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6aeb333e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3180 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c44eda66 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3184 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_ROW_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2cbf1134 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3185 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-bb58564c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3188 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04fbcc75 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3366 |  | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9af8d71 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3369 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b4b2998c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3379 | if (popup != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d5fbf5ff | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3383 | if (popup != null) ▸ try ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4b76940a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3388 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3fd89519 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3389 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34fe8b09 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3390 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd09f532 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3391 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3571de4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3392 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-d37d470a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3393 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3d7bdfc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3394 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8c84eaf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3395 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4b938fb | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3396 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-4be1ad3c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3397 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c647ed9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3398 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-00042623 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3399 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-55a59500 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3400 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2bb58f9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3401 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65c716df | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3402 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e502989f | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3403 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("NP_ITEM_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e27b86cd | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3404 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MOVING_FACTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce3f8cbe | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3405 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("MOVING_FACTORY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MOVING_FACTORY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11034603 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3411 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-2df8dcbc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3413 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b916b516 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3414 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f4205e0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3415 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-83ce68b4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3420 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-a7825614 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3423 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-28df96d3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3424 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-1a392bf7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3425 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-cf74551b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3426 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-76820af6 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3429 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NP_ITEM_ID"] | np_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-71652a37 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3441 | if (popup != null) ▸ try | ENDPOINT | DataService.FP_UpdateBatch | ("FP02841_Plan_Amend_Elec_Post", "insert_Excel_buffer", dataLocal, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-0eb8d64e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3443 | if (popup != null) ▸ try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_VALIDATION") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dec8a4b1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3445 | if (popup != null) ▸ try | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-1fc37015 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3464 | if (popup != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-67ef888d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3467 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-59ec3ef0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3248 |  | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-3aca2315 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3251 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-18ec21a7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3261 | if (popup != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8fba0f2c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3265 | if (popup != null) ▸ try ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f1085a34 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3270 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-9491d573 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3271 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-faada970 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3272 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-968e37e2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3273 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3408cc3a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3274 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-c8fcf3b3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3275 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2562f71 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3276 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("IN_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-949703ce | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3277 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("IN_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("IN_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3f055f1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3278 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("OUT_JR_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-5dee7fe9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3279 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("OUT_JR_QTY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("OUT_JR_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c64f98e7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3280 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6a8495e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3281 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d3f67a1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3282 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a4efc00c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3283 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad889443 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3284 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("NP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b40720ea | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3285 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("NP_ITEM_ID")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("NP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-427b4210 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3286 | if (popup != null) ▸ try | DATA_OP | dataLocal.Tables[0].Columns.Contains | ("MOVING_FACTORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb0b4281 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3287 | if (popup != null) ▸ try ▸ if (!dataLocal.Tables[0].Columns.Contains("MOVING_FACTORY")) | DATA_OP | dataLocal.Tables[0].Columns.Add | ("MOVING_FACTORY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0d3cf40 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3293 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-faa6aba2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3295 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c24c9a32 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3296 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-73574eb0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3297 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e51f8642 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3302 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-e332e9d9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3305 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-79db6a9b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3306 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-96918ee1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3307 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["IN_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-e1e29ba9 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3308 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["OUT_JR_QTY"] | qty | 행/컬럼 값 대입 |  |  |  |
| AC-dc0a5537 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3311 | if (popup != null) ▸ try ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NP_ITEM_ID"] | np_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-022ca967 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3323 | if (popup != null) ▸ try | ENDPOINT | DataService.FP_UpdateBatch | ("FP02841_Plan_Amend_Elec_Post", "insert_Excel_buffer", dataLocal, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-21d583e5 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3325 | if (popup != null) ▸ try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_VALIDATION") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5870d74a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3327 | if (popup != null) ▸ try | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-ab18feb1 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3346 | if (popup != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-8e373d29 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3349 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.cboPlanId_changed

진입점: cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d8b85e5 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5544 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d2adb132 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5546 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d9ac3f77 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5547 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-974a2cca | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5548 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9537e8e0 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5549 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-cb4bb042 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5550 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-64e859e8 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5552 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a05b796c | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5587 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-2bc67700 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5590 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-eddce1cb | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5591 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-cfd62d20 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5594 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-6d6de8ee | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5595 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-21ed851d | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5596 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-d22a1e21 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5597 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-08463e11 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5598 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-8ad63dfc | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5603 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-e185ef46 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5604 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-6c50da7e | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5609 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2927ba76 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5610 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f58ef6d8 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5611 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d1609236 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5612 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5e3fc5b9 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:5613 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-880bad89 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5406 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d7bad1db | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5408 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5129e346 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5409 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a0b85fc5 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5410 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-71d71668 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5411 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-94784296 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5412 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-eeff4903 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5414 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8d224d6 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5449 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-ea7a9f4c | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5452 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-5b095759 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5453 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-8007d2ba | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5456 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-a8afc18a | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5457 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-d8262afc | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5458 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-f9e12b33 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5459 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-b33af808 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5460 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-17d09fac | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5465 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-fa805086 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5466 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-69c48584 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5471 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6a17efd2 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5472 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2f75271b | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5473 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-65826f5c | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5474 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-aa5d6332 | cboPlanId.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5475 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52012553 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:470 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-66379e1b | this.Load | FP02841_Plan_Amend_Elec_Post.cs:470 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-a982e3a0 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:472 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02841_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b34a7de | this.Load | FP02841_Plan_Amend_Elec_Post.cs:472 |  | POPUP | new FP02841_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0541933f | this.Load | FP02841_Plan_Amend_Elec_Post.cs:473 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02841_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-231a7ecd | this.Load | FP02841_Plan_Amend_Elec_Post.cs:473 |  | POPUP | new FP02841_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-033f60ba | this.Load | FP02841_Plan_Amend_Elec_Post.cs:476 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ab0fc07 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:477 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-10d3b5e2 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:478 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6326852 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:479 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-dcac99f5 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:480 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-eeaff352 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:481 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f75a196d | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:463 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-79a871bc | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:463 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-22a6f1d2 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:465 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02841_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39e8db89 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:465 |  | POPUP | new FP02841_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0dfd1dc2 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:466 |  | CALL_EXT | MeasureService.MakeDefault | (new FP02841_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d7b386e | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:466 |  | POPUP | new FP02841_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-2e2db849 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:469 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-7da412f2 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:470 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-bd6de071 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:471 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-a88cd7c4 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:472 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-8657c8a1 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:473 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-46cadd89 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:474 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.chk_Info_CheckedChanged

진입점: chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a156313f | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post.cs:5669 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-02802430 | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post.cs:5669 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11bf444d | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post.cs:5675 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-97a25312 | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post.cs:5676 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |
| AC-d51962bf | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5537 | if (chk_Info.Checked) ▸ if (flo2 == null) | FLAG | flo2 | new MenuFloater() | 화면 필드/플래그 변경 |  |  |  |
| AC-bdbcce7b | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5538 | if (chk_Info.Checked) ▸ if (flo2 == null) | POPUP | flo2.Show | () | 팝업/폼 열기 |  |  |  |
| AC-885191e1 | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5540 | if (chk_Info.Checked) ▸ if (flo2 == null) ▸ if (mainForm != null) | CALL_EXT | flo2.SetMainForm | (mainForm) | ⚠ 의미 확인 필요 |  |  |  |
| AC-865d05ff | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5541 | if (chk_Info.Checked) ▸ if (flo2 == null) | CALL_EXT | flo2.SetMyPanel | (chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-647fde07 | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5545 | if (chk_Info.Checked) ▸ else of (flo2 == null) | POPUP | flo2.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6e266631 | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5546 | if (chk_Info.Checked) ▸ else of (flo2 == null) | CALL_EXT | flo2.SetMyPanel | (chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a050f628 | chk_Info.CheckedChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5552 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21e2860f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5384 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-e7c9e0f0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5385 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eb55344 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5386 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-49e3c55e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5387 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9433d59 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5388 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc4a7922 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5389 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eee5032a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5390 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-998a7ae8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5391 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-30e548a6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5392 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d54554f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5393 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-260edbd1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5394 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf6c8400 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5395 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbe9c6d5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5396 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4b14992 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5397 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ATTR_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4858ea57 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5398 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1fdbcc5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5399 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-15157757 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5400 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6b1e6a5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5401 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_JR_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d71b0c6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5402 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_JR_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0dd600c8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5403 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_PC_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-56bd4072 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5404 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_PC_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ee9a5b4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5405 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MOVING_FACTORY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed72909f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5408 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfc5a23d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5409 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c150d094 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5410 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-76ba3e84 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5411 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b743a8af | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5413 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bb78ccd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5419 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cb69f1c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:5422 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-435dbe3e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5254 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-3ce7381c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5255 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-36890f6d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5256 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a78d931 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5257 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a3cdf74 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5258 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dc1f0df | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5259 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ba60760 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5260 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a06193a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5261 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f62d7cf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5262 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d01653e4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5263 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-07ce25de | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5264 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-87e23da3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5265 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-84c7ae2a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5266 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c98420b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5267 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ATTR_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3cce8cb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5268 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0312f99 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5269 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad8a7f52 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5270 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-84b65f7d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5271 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_JR_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b8e7ceb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5272 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_JR_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0d66151 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5273 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_PC_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-de0c2ee2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5274 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_PC_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-705f1dd9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5275 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MOVING_FACTORY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-776981fe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5278 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d04bc9e0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5279 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7dbdf6f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5280 |  | DATA_OP | dt.Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e79226e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5281 |  | DATA_OP | dt.Columns.Add | (new DataColumn("JOB_ORDER", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-34f66982 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5283 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f2dee66 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5289 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-29c23a1e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5292 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb2dc1ce | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1706 | if (dsResult == null \|\| dsTotal == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e61833ee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1717 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-e3a83bae | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1718 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-3c4c9bd3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1730 | if (measure["chk_notching"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "NOTCHING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-70610d62 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1734 | if (measure["chk_intransit"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "INTRANSIT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d93ac591 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1738 | if (measure["chk_shipment"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SHIPMENT_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e7272cd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1742 | if (measure["chk_coater"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "COATING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc1c477f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1746 | if (measure["chk_rollpress"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "ROLL_PRESS_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ef66068 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1750 | if (measure["chk_slitting"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SLITTING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc481d98 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1754 | if (measure["chk_rollpress_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "ROLL_PRESS_ROLL_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7be2828 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1758 | if (measure["chk_slitting_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SLITTING_ROLL_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a546725f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1762 | if (measure["chk_moving"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1137bc6c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1766 | if (measure["chk_moving"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbfa4425 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1771 | if (measure["chk_eoh_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-69d25af4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1775 | if (measure["chk_eoh_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_PC_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c424ba8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1779 | if (measure["chk_eoh_jr_pre"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_PRE_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-28629f18 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1783 | if (measure["chk_eoh_jr_post"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_POST_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce258f7d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1791 | if (measure["chk_eoh_elec"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_ELEC_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d816fbe | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1796 | if (measure["chk_eoh_jr_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f85bea28 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1800 | if (measure["chk_eoh_pc_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_PC_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c892747d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1804 | if (measure["chk_eoh_jr_pre_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_PRE_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3467acc4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1808 | if (measure["chk_eoh_jr_post_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_POST_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-13792c13 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1816 | if (measure["chk_eoh_elec_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_ELEC_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-29e906e6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1825 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_coater"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "COATING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7f56f8f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1829 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_rollpress"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "ROLL_PRESS_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f90a8a9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1833 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_slitting"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SLITTING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcc83c51 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1837 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_notching"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "NOTCHING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1668c63f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1841 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_load"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_LOAD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7beb7e88 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1845 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_ROLL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-64f1bcbf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1853 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6e06988 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1854 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41a3d8e2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1858 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4529450 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1862 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b15b4a5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1865 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-645f8279 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1867 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |
| AC-c934d719 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1518 | if (dsResult == null \|\| dsTotal == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-939fe07d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1529 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-358289f2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1530 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-3cacee80 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1542 | if (measure["chk_notching"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "NOTCHING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fce00bc7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1546 | if (measure["chk_intransit"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "INTRANSIT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-53d19f64 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1550 | if (measure["chk_shipment"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SHIPMENT_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-449c6b32 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1554 | if (measure["chk_coater"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "COATING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dbd12de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1558 | if (measure["chk_rollpress"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "ROLL_PRESS_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-acbc7cfa | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1562 | if (measure["chk_slitting"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SLITTING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-17640bba | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1566 | if (measure["chk_rollpress_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "ROLL_PRESS_ROLL_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b78f5b8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1570 | if (measure["chk_slitting_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SLITTING_ROLL_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-904645f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1574 | if (measure["chk_moving"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe092b46 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1578 | if (measure["chk_moving"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d6937e5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1583 | if (measure["chk_eoh_jr"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc854a45 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1587 | if (measure["chk_eoh_pc"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_PC_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0298fb5e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1591 | if (measure["chk_eoh_jr_pre"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_PRE_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c998c25 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1595 | if (measure["chk_eoh_jr_post"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_POST_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b52724c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1603 | if (measure["chk_eoh_elec"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_ELEC_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f825ed87 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1608 | if (measure["chk_eoh_jr_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-da186c74 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1612 | if (measure["chk_eoh_pc_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_PC_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c5db8fc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1616 | if (measure["chk_eoh_jr_pre_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_PRE_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-eaf5705f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1620 | if (measure["chk_eoh_jr_post_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_JR_POST_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a98df1e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1628 | if (measure["chk_eoh_elec_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_ELEC_QTY_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ebad80b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1637 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_coater"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "COATING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-74b2f429 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1641 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_rollpress"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "ROLL_PRESS_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5c02891 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1645 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_slitting"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SLITTING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-532d077f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1649 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_notching"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "NOTCHING_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-23328f6c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1653 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_load"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_LOAD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-905b3d98 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1657 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_tot_roll"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_ROLL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a2a07c2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1665 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-163fb72f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1666 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f192e5b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1670 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-e09c9583 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1674 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c75affba | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1677 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5e27c19 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1679 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a65d67f | this.Load | FP02841_Plan_Amend_Elec_Post.cs:428 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5245bb7b | this.Load | FP02841_Plan_Amend_Elec_Post.cs:429 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a0a955b | this.Load | FP02841_Plan_Amend_Elec_Post.cs:430 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-254d0ff4 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:421 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-30ea9980 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:422 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d74157f | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:423 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.dCalendar_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bda2f5b | drpPeriod.ValueChanged | FP02841_Plan_Amend_Elec_Post.cs:5693 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c8e2236 | drpPeriod.ValueChanged | FP02841_Plan_Amend_Elec_Post.cs:5700 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-26cd8b74 | drpPeriod.ValueChanged | FP02841_Plan_Amend_Elec_Post.cs:5701 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-70d864ee | drpPeriod.ValueChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5568 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a081c63e | drpPeriod.ValueChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5575 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-2aba44e7 | drpPeriod.ValueChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5576 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d981d25 | DeleteButton | FP02841_Plan_Amend_Elec_Post.cs:1001 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cdb16d23 | DeleteButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:815 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02841_Plan_Amend_Elec_Post.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2623efe | Dispose | FP02841_Plan_Amend_Elec_Post.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dd989e3 | EditButton | FP02841_Plan_Amend_Elec_Post.cs:1009 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-990e5b2f | EditButton | FP02841_Plan_Amend_Elec_Post.cs:1011 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a46456d5 | EditButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:823 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-29ac3320 | EditButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:825 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.EditByChange

진입점: spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b83cc14 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:3698 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78f06192 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:3699 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-2285358a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:3700 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-6b1390fc | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:3702 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3f6b06f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:3714 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-041785a1 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:3715 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b1dac20 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3601 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e34f0473 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3602 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a122060 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3603 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-700752ce | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3605 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-912c1490 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3617 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-b44183cd | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3618 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08d1d8b7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3756 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b69eeed | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3757 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f8061ca | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3758 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-354990d4 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3760 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e818aac3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3768 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-0953e307 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3769 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0fcde9c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3774 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0c6cfcf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3659 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ced15ed8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3660 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-008e3374 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3661 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-1407a440 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3663 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45f1937a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3671 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-79652c2d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3672 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61cae4a8 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3677 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.EditByFunc

진입점: spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (nMovingRow > -1)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a36e9c54 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3725 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdebf939 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3727 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-24762c0d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3728 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-632330a3 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3730 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b653b08 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3740 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85f523f8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3746 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac44ee1d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3748 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |
| AC-8b3d77c1 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3628 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac08e323 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3630 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-ddfc15a5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3631 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-084e15be | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3633 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e02ed89b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3643 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d358e2c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3649 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40b84c7a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3651 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-740ff508 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP02841_Plan_Amend_Elec_Post.cs:2494 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |
| AC-ff7f4d2b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2396 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f24652a1 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2458 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3ff732e4 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2459 |  | VALUE_SET | select_popup.Text | "SELECT EXCEL TYPE" | 컨트롤 값 설정 |  |  |  |
| AC-8f29d9e1 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2460 |  | CALL_EXT | select_popup.SetOption | (0, "Cascaded Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-24901ffd | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2461 |  | CALL_EXT | select_popup.SetOption | (1, "Seperated Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4217e968 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2462 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ce9c0dc8 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2470 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | base.ExcelOption | ExcelExportOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |
| AC-9f34fd79 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2472 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (selected2==0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.All | 속성 Border 설정 |  |  |  |
| AC-a93e87b3 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2474 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ else of (selected2==0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.None | 속성 Border 설정 |  |  |  |
| AC-db63e7f0 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2480 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |
| AC-eb841296 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2482 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (selected2 == 0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.All | 속성 Border 설정 |  |  |  |
| AC-0dbe6f13 | ExcelButton | FP02841_Plan_Amend_Elec_Post.cs:2484 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ else of (selected2 == 0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.None | 속성 Border 설정 |  |  |  |
| AC-cd0d7e1e | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2360 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-877b3139 | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2361 |  | VALUE_SET | select_popup.Text | "SELECT EXCEL TYPE" | 컨트롤 값 설정 |  |  |  |
| AC-e6a0d092 | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2362 |  | CALL_EXT | select_popup.SetOption | (0, "Cascaded Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b0cd982 | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2363 |  | CALL_EXT | select_popup.SetOption | (1, "Seperated Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a82fb26 | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2364 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d00cc8de | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2372 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | base.ExcelOption | ExcelExportOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |
| AC-e05d39aa | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2374 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (selected2==0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.All | 속성 Border 설정 |  |  |  |
| AC-ab09f9f2 | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2376 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ else of (selected2==0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.None | 속성 Border 설정 |  |  |  |
| AC-ec24a8ba | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2382 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |
| AC-b78effe2 | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2384 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (selected2 == 0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.All | 속성 Border 설정 |  |  |  |
| AC-bb7b828f | ExcelButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2386 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ else of (selected2 == 0) | UI_PROP | base.ExcelOptionEx.Border | ExcelBorderOptionEx.None | 속성 Border 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-451e62d1 | FindButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:755 | if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-f510cb78 | FindButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:755 | if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["FP_PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-2759efe5 | FindButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:759 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-4987db7c | FindButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:760 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1dd61515 | FindButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:770 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELEC_POST")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a96c55d | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2817 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { dgEdit.DataSource = null; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb1d6530 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2819 | try ▸ lambda | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-e60cca7c | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2823 | try | LIST_CLEAR | dgShipment.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-547d58ed | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2828 | try | FLAG | dtYield | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-2d70ae69 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2828 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "YIELD_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-41303bf2 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2830 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_PLAN_AMEND_ELEC_POST", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f96e386c | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2832 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-5c2e9aa9 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2838 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-402fece4 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post.cs:2840 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6c8609cc | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2711 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-febd1208 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2712 | try | LIST_CLEAR | dgShipment.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-c4d78872 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2719 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_PLAN_AMEND_ELEC_POST", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a43fa2c8 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2721 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-1d0a0efe | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2727 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-a567d437 | popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELE… 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2729 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnExcelImport.C…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-574abaf7 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:815 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |
| AC-1ffb5166 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:735 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.FindTotalValue

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4187a17 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2791 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d4fb163e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2792 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b9ee84d2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2798 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-bc2f3f9d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2800 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e7328329 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2685 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f4380678 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2686 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-4b3bb38f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2692 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-09e3b967 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2694 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.fn_setInventory

진입점: spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (dsMainFiltered.Good() \|\| clicked_row == null)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73f2bade | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2175 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-61409ce8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2176 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-4e71679d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2177 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ba77772b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2178 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-46dc4bf0 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2180 | lambda | DATA_OP | rowx.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab9122a4 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2209 | foreach (DataRow row in list_total) ▸ lambda | DATA_OP | rowx.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0fd0399f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2210 | foreach (DataRow row in list_total) ▸ lambda | DATA_OP | rowx.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a814373 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2331 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dJrCapa + dJrTempCapa > 0) | CALL_EXT | double.IsNaN | (dEOH_JR_QTY / (dJrCapa + dJrTempCapa) * 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2061ddfd | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2337 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dATypeCapa + dATypeTempCapa > 0) | CALL_EXT | double.IsNaN | (dEOH_ELEC_QTY / (dATypeCapa + dATypeTempCapa) * 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5447cd53 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2342 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dBTypeCapa + dBTypeTempCapa > 0) | CALL_EXT | double.IsNaN | (dEOH_ELEC_QTY / (dBTypeCapa + dBTypeTempCapa) * 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fc85e67 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2387 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ if (sATTR.Equals("-") && sCategoryGr… | DATA_OP | row[colname] | dJR_Total | 행/컬럼 값 대입 |  |  |  |
| AC-fcbc059f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2389 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dJR_Roll_Total | 행/컬럼 값 대입 |  |  |  |
| AC-248aad72 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2391 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dA_TYPE_Total | 행/컬럼 값 대입 |  |  |  |
| AC-0f6a4d35 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2393 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dA_TYPE_Roll_Total | 행/컬럼 값 대입 |  |  |  |
| AC-14fe4350 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2395 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dB_TYPE_Total | 행/컬럼 값 대입 |  |  |  |
| AC-4670edbc | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2397 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dB_TYPE_Roll_Total | 행/컬럼 값 대입 |  |  |  |
| AC-1755c33f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2402 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ if (sATTR.Eq… | VALUE_SET | cCell.Value | dJR_Total | 컨트롤 값 설정 |  |  |  |
| AC-5dfa85ad | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2404 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dJR_Roll_Total | 컨트롤 값 설정 |  |  |  |
| AC-62b80346 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2406 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dA_TYPE_Total | 컨트롤 값 설정 |  |  |  |
| AC-41be6f2a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2408 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dA_TYPE_Roll_Total | 컨트롤 값 설정 |  |  |  |
| AC-4f7df611 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2410 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dB_TYPE_Total | 컨트롤 값 설정 |  |  |  |
| AC-a74487c8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post.cs:2412 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dB_TYPE_Roll_Total | 컨트롤 값 설정 |  |  |  |
| AC-c09fa8ee | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2077 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb4e5488 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2078 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-111a71e2 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2079 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2adc291b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2080 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c43b9071 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2082 | lambda | DATA_OP | rowx.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2af6a565 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2111 | foreach (DataRow row in list_total) ▸ lambda | DATA_OP | rowx.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b12704c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2112 | foreach (DataRow row in list_total) ▸ lambda | DATA_OP | rowx.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c40cbeae | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2233 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dJrCapa + dJrTempCapa > 0) | CALL_EXT | double.IsNaN | (dEOH_JR_QTY / (dJrCapa + dJrTempCapa) * 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38aea7bd | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2239 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dATypeCapa + dATypeTempCapa > 0) | CALL_EXT | double.IsNaN | (dEOH_ELEC_QTY / (dATypeCapa + dATypeTempCapa) * 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98f5dce8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2244 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (dBTypeCapa + dBTypeTempCapa > 0) | CALL_EXT | double.IsNaN | (dEOH_ELEC_QTY / (dBTypeCapa + dBTypeTempCapa) * 100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2d59082 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2289 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ if (sATTR.Equals("-") && sCategoryGr… | DATA_OP | row[colname] | dJR_Total | 행/컬럼 값 대입 |  |  |  |
| AC-40a7cbd6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2291 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dJR_Roll_Total | 행/컬럼 값 대입 |  |  |  |
| AC-548c9215 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2293 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dA_TYPE_Total | 행/컬럼 값 대입 |  |  |  |
| AC-489b4137 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2295 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dA_TYPE_Roll_Total | 행/컬럼 값 대입 |  |  |  |
| AC-8044b77b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2297 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dB_TYPE_Total | 행/컬럼 값 대입 |  |  |  |
| AC-9758b4b7 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2299 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ if (UseDataSet) ▸ else of (sATTR.Equals("-") && sCateg… | DATA_OP | row[colname] | dB_TYPE_Roll_Total | 행/컬럼 값 대입 |  |  |  |
| AC-de246b25 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2304 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ if (sATTR.Eq… | VALUE_SET | cCell.Value | dJR_Total | 컨트롤 값 설정 |  |  |  |
| AC-4c660920 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2306 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dJR_Roll_Total | 컨트롤 값 설정 |  |  |  |
| AC-80c5ec50 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2308 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dA_TYPE_Total | 컨트롤 값 설정 |  |  |  |
| AC-279427db | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2310 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dA_TYPE_Roll_Total | 컨트롤 값 설정 |  |  |  |
| AC-a077b7a7 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2312 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dB_TYPE_Total | 컨트롤 값 설정 |  |  |  |
| AC-6029137b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 13 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2314 | foreach (DataRow row in list_total) ▸ foreach (AmendDate a in calendar.Days.Values) ▸ else of (UseDataSet) ▸ if (cCell!=null) ▸ else of (sAT… | VALUE_SET | cCell.Value | dB_TYPE_Roll_Total | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90b2d82a | this.Load | FP02841_Plan_Amend_Elec_Post.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-52b19301 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetBasisTime

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4822d95c | this.Load | FP02841_Plan_Amend_Elec_Post.cs:336 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter… | 화면 필드/플래그 변경 |  |  |  |
| AC-1e5e43d1 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:336 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3bc26f78 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:329 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter… | 화면 필드/플래그 변경 |  |  |  |
| AC-c8ebbefa | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:329 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetDivision

진입점: cboInstance.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-293201dc | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2582 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-b0ca9403 | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2582 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4277843 | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2584 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-23b60cdc | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2484 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-a9c42cb7 | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2484 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d40ae191 | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2486 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetFactory

진입점: cboPlanId.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc13d02 | cboPlanId.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2649 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-75d3048c | cboPlanId.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2649 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf57c1b1 | cboPlanId.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2654 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6b47ee15 | cboPlanId.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2543 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-94112d09 | cboPlanId.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2543 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4cbdde1f | cboPlanId.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2548 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetFilter

진입점: this.Load [if (dtPlanId.Good())] / cboPlanId.SelectedIndexChanged [if (dtPlanId.Good())] / popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELEC_POST") ▸ try] / this.cboPlanId.DropDown [if (dtPlanId.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-859ea91f | this.Load [if (dtPlanId.Good())] 외 11 | FP02841_Plan_Amend_Elec_Post.cs:2577 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |
| AC-b4a8536d | this.Load [if (dtPlanId.Good())] 외 11 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2479 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetFpPlandId

진입점: cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4566515f | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2616 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-0c88f9e4 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2616 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7bc65d9c | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2617 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6ea684f6 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2620 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a952184 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2620 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-215e30e7 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2621 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b704cff9 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2625 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-6027befa | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2625 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8b03dbba | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post.cs:2626 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56c794a7 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2510 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-df13d8e4 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2510 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d5fc18fd | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2511 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c1e950fc | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2514 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e123a44c | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2514 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1e3fb03b | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2515 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4851c32 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2519 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-c02e9c98 | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2519 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e57d91b | cboInstance.SelectedIndexChanged 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2520 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetFpPlanId

진입점: this.Load / this.cboPlanId.DropDown / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e21cd32d | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:279 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-7fefc78d | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:279 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0ddeeb3a | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:280 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0e4f09d9 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:284 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6708e0b | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:285 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2877f974 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:286 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69edbbf3 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:287 | if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21262a73 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:297 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-dc94997f | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:298 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-16f508b0 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:299 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-b3fd8bd6 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:300 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-dc0db3ae | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:301 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-e128c819 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:303 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-c9c1dbda | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:305 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-367b5791 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:306 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a13485f7 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:308 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-329cf457 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:309 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-635844f3 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:317 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a76aaf14 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:318 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f7348ea | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:319 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3301e0e8 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:320 | else of (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-725b15ae | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:324 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ce5e759c | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:325 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e9537401 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:326 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-99ada3d3 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:327 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c688d44a | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post.cs:328 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c383f4df | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:272 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-4594859f | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:272 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2090157a | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:273 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-92e2c4ad | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:277 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-783d1c4c | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:278 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34ce7a7c | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:279 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2ade34f6 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:280 | if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2ff4028e | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:290 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-d2401392 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:291 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-de4bdaf2 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:292 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-a2bb821c | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:293 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-e80ab0da | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:294 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-7da7383f | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:296 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-1ce331e8 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:298 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-8d8f9a18 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:299 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-03d05e42 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:301 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-77d6528f | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:302 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-12121fd7 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:310 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4b7afd57 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:311 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b29c7777 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:312 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-67551826 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:313 | else of (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ace18f8f | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:317 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-52d0172d | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:318 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3202103e | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:319 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-287bb3dc | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:320 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e374f811 | this.Load 외 2 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:321 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") ▸ else of (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") ▸ try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb7cceab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6573 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "findOperationCode_common", Filter[… ⇒ FP_Master.PR_UI_FP02841_ETC | 화면 필드/플래그 변경 |  |  |  |
| AC-8442b436 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6573 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVISION_ID"]… ⇒ FP_Master.PR_UI_FP02841_ETC | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetPlanGroup

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b34ef65e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2599 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth ,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-368463c5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2599 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2494ac44 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2604 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-ff24e642 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2606 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { clsCtrl.setListBox(dtInstance, cboInstance, false, "CODE"… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5bba7608 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:2608 | lambda | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4c919cbe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2501 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth ,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-695c5a15 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2501 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-68cb9e36 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2505 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetPlant

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef267a12 | cboSite.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:2640 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-e30a485d | cboSite.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:2640 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9fadfbfe | cboSite.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post.cs:2642 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-9bde33fd | cboSite.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2534 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-902167a2 | cboSite.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2534 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc7aadf1 | cboSite.SelectedIndexChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2536 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c740f974 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:4957 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-fe84c0e2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:4958 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |
| AC-c4f0a5fc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4827 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-cac8707b | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4828 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GetSite

진입점: clbDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd83f88e | clbDivision.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2633 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-732894fc | clbDivision.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2633 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd698acc | clbDivision.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:2635 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6575cc0a | clbDivision.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2527 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0769a3af | clbDivision.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2527 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a060cbd8 | clbDivision.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2529 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8a24eca | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2677 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |
| AC-bba13acf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2571 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e41a5ff | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1017 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e46d536 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1019 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-76ebf281 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1061 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a01a286a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1062 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-6e9ef792 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1091 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b69913dd | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1092 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-7c36f9a0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1121 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32abb8e0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1122 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-9bc43aa3 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1137 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9b42981c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:831 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67e471b7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:833 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-506a7516 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:875 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-083cab78 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:876 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-2ba3e696 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:905 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b58a881 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:906 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-5d1ff3fc | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:935 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-18561738 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:936 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-ab480ba2 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:951 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CAT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-817cdcb1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1160 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fdc7c663 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1170 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-48def8c3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1171 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-24a12b07 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1223 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b367be05 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1230 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor2 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(191, 255, 191)) | 그리드 표시 설정 |  |  |  |
| AC-7e344419 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1235 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor2 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(239, 239, 239)) | 그리드 표시 설정 |  |  |  |
| AC-a61f5f51 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1245 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee9a894f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1246 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d4eb26c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1259 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-520461f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1260 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-873c7671 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1276 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor2 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-0dbd5bac | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1293 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor2 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(248, 203, 173)… | 그리드 표시 설정 |  |  |  |
| AC-27c25ecb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1298 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3169be18 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:974 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6c46b7da | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:984 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-a8222aad | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:985 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-3eaf7807 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1037 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2262dc94 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1044 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor2 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(191, 255, 191)) | 그리드 표시 설정 |  |  |  |
| AC-b32d98d5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1049 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor2 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(239, 239, 239)) | 그리드 표시 설정 |  |  |  |
| AC-f5b59a49 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1059 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-509a83b4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1060 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fddf9c5c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1073 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b110aa36 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1074 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d8a169c0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1090 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor2 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-1b1ff6cc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1107 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor2 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(248, 203, 173)… | 그리드 표시 설정 |  |  |  |
| AC-fcabb6be | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1112 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3098f2f2 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:181 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9e560fd | this.Load | FP02841_Plan_Amend_Elec_Post.cs:185 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2975818f | this.Load | FP02841_Plan_Amend_Elec_Post.cs:186 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6400a1d5 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:190 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-66019345 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:194 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-abcbede0 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:198 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-90c951b1 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:200 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNo… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-bd6b6238 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:200 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ea468b6 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:205 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-8d1c6d9b | this.Load | FP02841_Plan_Amend_Elec_Post.cs:207 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b63289aa | this.Load | FP02841_Plan_Amend_Elec_Post.cs:210 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-379f4f53 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:212 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-f33cf4c2 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:214 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-31d963fe | this.Load | FP02841_Plan_Amend_Elec_Post.cs:215 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-4e8caba0 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:215 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-43ce7163 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:219 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-4cf40b68 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:220 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(27) | 속성 Value2 설정 |  |  |  |
| AC-5448901d | this.Load | FP02841_Plan_Amend_Elec_Post.cs:223 |  | FLAG | dtUom | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02841_PLANAMEND_ELEC_POST", "UOM_… | 화면 필드/플래그 변경 |  |  |  |
| AC-befe02f6 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:223 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02841_PLANAMEND_ELEC_POST", "UOM_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-164892cd | this.Load | FP02841_Plan_Amend_Elec_Post.cs:231 |  | LIST_REBIND | clsCtrl.setListBox | (dtUom, cboUom, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9fe5c50a | this.Load | FP02841_Plan_Amend_Elec_Post.cs:235 |  | FLAG | dtElecType | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02841_PLANAMEND_ELEC_POST", "ELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-862e0bb4 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:235 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02841_PLANAMEND_ELEC_POST", "ELEC_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f0439a8 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:243 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-2bbf848c | this.Load | FP02841_Plan_Amend_Elec_Post.cs:247 |  | FLAG | dtUnit | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02841_PLANAMEND_ELEC_POST", "LENG… | 화면 필드/플래그 변경 |  |  |  |
| AC-95b7ea7d | this.Load | FP02841_Plan_Amend_Elec_Post.cs:247 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02841_PLANAMEND_ELEC_POST", "LENGTH_UNIT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7d12bcb | this.Load | FP02841_Plan_Amend_Elec_Post.cs:255 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnit, cboUnit, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4a38c377 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:259 |  | FLAG | dtRoundPoint | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02841_PLANAMEND_ELEC_POST", "ROUN… | 화면 필드/플래그 변경 |  |  |  |
| AC-b9ab4d07 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:259 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02841_PLANAMEND_ELEC_POST", "ROUND_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-42dcba11 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:269 |  | LIST_REBIND | clsCtrl.setListBox | (dtRoundPoint, cboRoundPoint, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e5558121 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:270 |  | VALUE_SET | cboRoundPoint.SelectedValue | 2 | 컨트롤 값 설정 |  |  |  |
| AC-b4974f78 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:181 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0526fb0 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:185 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0cd5a413 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:186 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4a246261 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:190 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d357b7a8 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:194 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdccbadd | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:198 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fddb25f8 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:200 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNo… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-4a30a234 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:200 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-568e3cb8 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4e5a06c2 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:207 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d430727c | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:209 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-1396103d | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:211 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9522fc32 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:212 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-53c3814c | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:212 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-50b32d23 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:216 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-f554a735 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:217 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(27) | 속성 Value2 설정 |  |  |  |
| AC-731e3b07 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:220 |  | FLAG | dtUom | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-cdc4bca0 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:221 |  | DATA_OP | dtUom.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-caf69735 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:222 |  | DATA_OP | dtUom.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-648c1d67 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:224 |  | DATA_OP | dtUom.Rows.Add | ("JR", "Jumbo Roll") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb63a60a | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:225 |  | DATA_OP | dtUom.Rows.Add | ("PC", "Pancake") | 데이터 객체 조작/조회 |  |  |  |
| AC-8303e9c9 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtUom, cboUom, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-42878ceb | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:231 |  | FLAG | dtElecType | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-a76758c0 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:232 |  | DATA_OP | dtElecType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e32b719 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:233 |  | DATA_OP | dtElecType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cc5efcc | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:235 |  | DATA_OP | dtElecType.Rows.Add | ("ANODE", "ANODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9dded960 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:236 |  | DATA_OP | dtElecType.Rows.Add | ("CATHODE", "CATHODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c20821b | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0ec25c72 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:242 |  | FLAG | dtUnit | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-4289a251 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:243 |  | DATA_OP | dtUnit.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ede370f5 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:244 |  | DATA_OP | dtUnit.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-673bbeab | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:246 |  | DATA_OP | dtUnit.Rows.Add | ("1000", "km") | 데이터 객체 조작/조회 |  |  |  |
| AC-392b7528 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:247 |  | DATA_OP | dtUnit.Rows.Add | ("1", "m") | 데이터 객체 조작/조회 |  |  |  |
| AC-ade41032 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:249 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnit, cboUnit, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-18a0dd8f | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:253 |  | FLAG | dtRoundPoint | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-000b944e | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:254 |  | DATA_OP | dtRoundPoint.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe2788d5 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:255 |  | DATA_OP | dtRoundPoint.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c1219f3 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:257 |  | DATA_OP | dtRoundPoint.Rows.Add | ("0", "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bca09cd | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:258 |  | DATA_OP | dtRoundPoint.Rows.Add | ("1", "1") | 데이터 객체 조작/조회 |  |  |  |
| AC-48cbcc15 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:259 |  | DATA_OP | dtRoundPoint.Rows.Add | ("2", "2") | 데이터 객체 조작/조회 |  |  |  |
| AC-58a948e3 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:260 |  | DATA_OP | dtRoundPoint.Rows.Add | ("3", "3") | 데이터 객체 조작/조회 |  |  |  |
| AC-bdd39d54 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:262 |  | LIST_REBIND | clsCtrl.setListBox | (dtRoundPoint, cboRoundPoint, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5f684ff8 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:263 |  | VALUE_SET | cboRoundPoint.SelectedValue | 2 | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.InitEditingBuf

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-616ed342 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:3686 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-11800cc4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:3687 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-44bd2215 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:3688 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-0bd0c898 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:3689 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-096061b9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:3690 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-b21ec5a7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:3691 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f7bbd002 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:3692 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4926d4a1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3589 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-87809975 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3590 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-a45ae554 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3591 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-9cb8cceb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3592 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-78a67459 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3593 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-e7696e8e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3594 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aa2a6832 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3595 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2404533 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:393 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4023d026 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:394 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-260ac700 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:395 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-58f36b08 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:396 |  | UI_PROP | clbElecType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d871bda7 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:397 |  | UI_PROP | cboSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-24df6192 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:386 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-bee7a7e4 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:387 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e6432c41 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:388 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b7151cd9 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:389 |  | UI_PROP | clbElecType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f2df92f5 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:390 |  | UI_PROP | cboSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.InitSpread

진입점: this.Load / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2541ee0 | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post.cs:442 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-699ea0f8 | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post.cs:443 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6784f85 | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post.cs:445 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fee3f9f4 | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post.cs:449 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-4d5bfdf0 | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:435 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d28ed168 | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:436 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-273ccc67 | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:438 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a01d8eb | this.Load 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:442 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a43b0fff | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:965 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-106c37c5 | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:968 | if (row != null) | POPUP | new FP02841_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-3191f774 | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:969 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-493244fc | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:969 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5ffed55b | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:970 | if (row != null) | UI_PROP | popup.DateMap | dateMap.Tables[0].Copy() | 속성 DateMap 설정 |  |  |  |
| AC-37bbf002 | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:970 | if (row != null) | DATA_OP | dateMap.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-12799fba | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:973 | if (row != null) | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8d91d010 | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:974 | if (row != null) | DATA_OP | popup.Filter["FP_PLAN_ID"] | Filter["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-574044fb | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:975 | if (row != null) | DATA_OP | popup.Filter["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-115924c6 | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:976 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-77d291da | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:977 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d43ce413 | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:978 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc8bff1e | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:979 | if (row != null) | DATA_OP | popup.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a607553f | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:981 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-931b9328 | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:982 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6071527d | InsertButton | FP02841_Plan_Amend_Elec_Post.cs:993 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |
| AC-c9b32ade | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:779 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7866a4aa | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:782 | if (row != null) | POPUP | new FP02841_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-ad2b4fe8 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:783 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-dceb0be1 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:783 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e3752e54 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:784 | if (row != null) | UI_PROP | popup.DateMap | dateMap.Tables[0].Copy() | 속성 DateMap 설정 |  |  |  |
| AC-090a884f | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:784 | if (row != null) | DATA_OP | dateMap.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7245d168 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:787 | if (row != null) | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-60d04ff5 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:788 | if (row != null) | DATA_OP | popup.Filter["FP_PLAN_ID"] | Filter["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f86e0cc2 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:789 | if (row != null) | DATA_OP | popup.Filter["COMPANY_ID"] | row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-283e67fb | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:790 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68f74228 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:791 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-680b90d5 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:792 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80d410a4 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:793 | if (row != null) | DATA_OP | popup.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3e828c17 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:795 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-67439f30 | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:796 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4d0ebafb | InsertButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:807 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82609674 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2542 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cdb64441 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2444 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02841_Plan_Amend_Elec_Post.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fc4c35c | memo_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3583 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7907d6e8 | memo_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3586 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-979b4f0c | memo_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3590 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2146e582 | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3465 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f50b986 | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3468 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96aac398 | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3486 | if (day != null) | POPUP | new FPC0096_MemoEditPopup | (row, day, arg.Row, arg.Column) | 팝업/폼 생성 |  |  |  |
| AC-b0088515 | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3487 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e299a623 | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3487 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b945ec6c | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3488 | if (day != null) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-7e95a9eb | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3489 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f1bb64ea | memo_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3490 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-965af60e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:3661 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c290fc17 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3564 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6fe69b9 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3476 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a58de13d | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3479 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff36db3e | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3486 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-82da7b2c | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3529 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cc2dc596 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3358 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22754a08 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3361 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a4e0c23 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3368 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bc7205b8 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3411 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.onZeroMaterialMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c51a7e16 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3539 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1377b7b4 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3542 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-027ac7f5 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post.cs:3569 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-9bf4b287 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3421 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-368762db | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3424 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55671bb9 | bucke_menu.Click | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3451 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") ▸ else of (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DAT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cdd1132 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6549 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-374b61a3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6549 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-86ed1c61 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6551 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-3cd1dcdd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6552 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-51a7185d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6552 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-44c502c9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6553 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-3a57dfb0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6554 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a582138f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6555 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6e9ca922 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6559 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0ae91a97 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6561 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7b1cc712 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6566 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") ▸ else of (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") ▸ try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47b0fe17 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6509 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-f6456806 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6510 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-ac6d1302 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6511 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-49484406 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6511 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78f65f6e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6512 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e581f742 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6513 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-728b5a1e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6514 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7417b0e8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6518 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6c75f539 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6520 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") ▸ else of (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") ▸ try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ee27554 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6526 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-6e126e86 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6527 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-a94cefb5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6528 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-edbb04a6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6528 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-20650180 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6529 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-caa08b2e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6530 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0c1cff19 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6531 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c8507d09 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6535 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1917d8cd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6537 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.planday_changed

진입점: cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-346eb498 | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post.cs:5658 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-62f7ac5d | cboInstance.SelectedIndexChanged 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5520 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.Query

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d67f41af | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:664 |  | DATA_OP | Filter["LINE_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f18d2b4e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:665 |  | DATA_OP | Filter["MARKET"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-8fff0457 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:666 |  | DATA_OP | Filter["OPERATION_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-2f371ed0 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:668 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-59a4fe31 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:668 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-da8f4e4e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:669 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-baf92dbe | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:674 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-a65bde84 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:697 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-3cf60a28 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:703 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba3dcc9c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:703 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-82cdff6a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:704 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-6ecc9231 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:704 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1e3ca88a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:707 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f105a110 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:714 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-0ac139fe | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:719 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-840f0d77 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:720 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80f03fff | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:722 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToSt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7f340ed | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:488 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe870775 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:489 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-7aca4a6f | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:490 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-f86b8e03 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:491 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-d73bb78d | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:510 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9476eeed | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:513 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-6ce32f00 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:514 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-379ccfe7 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:515 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30665b49 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:516 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a9d69fe | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:520 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-905bc549 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:521 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f0dd780 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:524 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-88c04ef1 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:530 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40efdc48 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:532 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dccad1af | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:571 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor2 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-4340182d | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:575 | if (monthInfo != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2bf8bd7e | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:591 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-440eea57 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:595 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-2895d165 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:597 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8da44542 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:601 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-c3e6839b | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:624 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-75e9b0d5 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post.cs:642 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-fb39c350 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:481 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-b20996ed | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:482 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-7745750c | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:483 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-e5402a11 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:484 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-3d7acd39 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:503 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b4c7610 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:506 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-40ba93fb | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:507 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8646dc6 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:508 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ee94c82 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:509 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33fe960e | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:513 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f79f5e97 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:514 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3588f74e | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:517 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-b48b8d6d | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:522 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f7861ee | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:524 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ba21c0b | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:562 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor2 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-ee46d076 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:566 | if (monthInfo != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b2c6cf90 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:582 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d79c62c1 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:586 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-5e01698d | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:588 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5359c787 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:592 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d5d3d506 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:615 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-dea5ad0d | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:633 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.RefreshHeaderOnly

진입점: this.Load [try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3afd1ab6 | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post.cs:782 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-bbcac07a | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post.cs:783 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-8c8a657e | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post.cs:784 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb1f581b | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post.cs:785 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05f57e12 | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post.cs:786 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b244c3f1 | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:702 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-ddafdefb | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:703 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-93424d57 | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:704 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0b51892 | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:705 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-270403f6 | this.Load [try] 외 8 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:706 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edf6482f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1883 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-cc8d706d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1884 |  | LIST_CLEAR | dgShipment.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-f46c44bc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1888 |  | FLAG | dsSubTotalFiltered | SubTotalFilterDataSet(dsMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-9aff78c6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1891 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-446c0c11 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1897 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b83fc1d2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1901 | if (dsMainFiltered.Good()) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22985c9b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1768 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-6df1f992 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1769 |  | LIST_CLEAR | dgShipment.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-f3376eac | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1773 |  | FLAG | dsSubTotalFiltered | SubTotalFilterDataSet(dsMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8d708ed | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1776 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc8ce402 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1782 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f06158d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1786 | if (dsMainFiltered.Good()) | CALL_EXT | siMain.MergeLineOptions.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-faa83bee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1791 | if (dsMainFiltered.Good()) | CALL_EXT | siMain.AddRawMergeLineOption | ("PRODUCTION_TYPE", Color.White, Color.White, Color.Blue, Color.Blue, FarPoint.Win.Complex… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1539e1fb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1797 | if (dsMainFiltered.Good()) | CALL_EXT | siMain.AddRawMergeLineOption | ("CATEGORY_NAME", null, null, null, Color.Blue, FarPoint.Win.ComplexBorderSideStyle.ThinLi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-23a427fa | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1803 | if (dsMainFiltered.Good()) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33b4d581 | popSql.OnSql | FP02841_Plan_Amend_Elec_Post.cs:2774 | if (programID == "PR_UI_FP02841_PLAN_AMEND_ELEC_POST") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-ae45b29c | popSql.OnSql | FP02841_Plan_Amend_Elec_Post.cs:2776 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-77eeb2a1 | popSql.OnSql | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2668 | if (programID == "PR_UI_FP02841_PLAN_AMEND_ELEC_POST") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-096e8fe4 | popSql.OnSql | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2670 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecb89a9d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1319 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4e31eefa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1340 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d13c7a4a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1341 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9abbcfe4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1347 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e5eab246 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1349 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c2cc93b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1358 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-428fa943 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1359 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a584efe8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1360 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-31462e9a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1374 | try ▸ if (editDs.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ef4f57cd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1378 | try ▸ if (editDs.Good()) ▸ if (nSeq.Good()) | DATA_OP | Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-921955e2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1391 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd9b0263 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1401 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-827cb7db | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1402 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ead22a79 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1403 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-551b092b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1404 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a8274a4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1405 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-001f9943 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1406 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bd975e0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1407 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f771582 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1408 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f097cc90 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1409 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c402539 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1410 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe610242 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1411 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10158721 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1412 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-40c64433 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1399 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-e83217bf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1438 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-46319c43 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1443 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-33f66a99 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1444 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-107ff819 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1445 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-f0c33540 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1446 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-7aa7687c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1447 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-4f72cf76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1448 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-269315b6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1449 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["JOB_ORDER"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-854437af | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1463 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d136bbf3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1465 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-bd2d4281 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1466 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-933b5044 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1468 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3f8195f5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1469 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2d95a02 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1470 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6067b0b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1471 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-47e9c8b4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1472 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b8fdcdf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1473 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | enum_row_from_Saving["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9be6074 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1474 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b1d01e31 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1475 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39a0b179 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1476 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["NP_ITEM_ID"] | enum_row_from_Saving["NP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-74a41176 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1477 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ATTR_TYPE"] | enum_row_from_Saving["ATTR_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2cab7b2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1478 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-910bced4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1479 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b8209c24 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1480 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-274dcf00 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1481 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-031fbe0d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1482 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-59c2f4cd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1483 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-e830755b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1484 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-7f9d51a1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1485 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-cd53b78a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1486 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MOVING_FACTORY"] | enum_row_from_Saving["MOVING_FACTORY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-419695a0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1488 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-34f9517e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1489 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d79afdae | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1490 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["JOB_ORDER"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-1d1ce5d0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1492 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dc88c45 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1500 | try | DATA_OP | dt.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-87ed271b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1506 | try ▸ if (saveDt == null && Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-b9184215 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1507 | try ▸ if (saveDt == null && Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6f916c98 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1508 | try ▸ if (saveDt == null && Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9e2dc94a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1518 | try ▸ if (cboPlanId.SelectedIndex >= 0) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-651ef7a7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1524 | try | DATA_OP | saveDs.Tables.Add | (saveDt) | 데이터 객체 조작/조회 |  |  |  |
| AC-31f81e82 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1536 | try | ENDPOINT | DataService.FP_UpdateBatch | ("FP02841_Plan_Amend_Elec_Post", "insert_Excel_buffer", saveDs, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-9dd933d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1538 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_SAVE", Filter, CurrentUser, "SAVE", "MERGE_SAVE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9b6bfd89 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1542 | try ▸ if (rsSave.Good() && rsSave.Tables[0].Rows[0]["RESULT_CODE"].ToString() == "SUCCESS") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4ae241f3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1550 | try ▸ if (rsSave.Tables[0].Rows[0]["RESULT_CODE"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | (msg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-eab45ceb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1553 | try | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-77756271 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1632 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ee667ac9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1633 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-af069c5e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1637 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b3d4b5bc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post.cs:1639 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-0e0b21c0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1131 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6b334163 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1152 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65f4831b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1153 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fbcde7f0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1159 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3f2472f2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1161 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-abd20037 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1170 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-5cadd7fc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1171 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6881be06 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1172 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7e213ffe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1186 | try ▸ if (editDs.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c1d54aa6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1190 | try ▸ if (editDs.Good()) ▸ if (nSeq.Good()) | DATA_OP | Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-aa656bb5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1203 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0c7ec96c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1213 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ca20681 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1214 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-403ddb56 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1215 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5471dbc5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1216 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4652de0a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1217 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ce365e3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1218 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-175f3cec | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1219 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e874904e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1220 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-12e3ac88 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1221 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-00104adf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1222 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7591fe85 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1223 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f48c9a2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1224 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0fc915a3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1211 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-f7cfdb6b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1250 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e58baf2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1255 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-db38cfc0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1256 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-49d3fc81 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1257 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-e87386ff | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1258 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-3ba89d19 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1259 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-5cd7550b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1260 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-df78e7bc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1261 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["JOB_ORDER"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3c3ce2b6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1275 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33ff6f9c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1277 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-23e79385 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1278 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-3c7445da | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1280 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2531d127 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1281 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8fdbefec | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1282 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ba57c89 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1283 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2c534239 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1284 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b9aecc5f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1285 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | enum_row_from_Saving["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-93363855 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1286 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43dcc3b9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1287 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-126a77ec | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1288 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["NP_ITEM_ID"] | enum_row_from_Saving["NP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-473c9cdd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1289 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ATTR_TYPE"] | enum_row_from_Saving["ATTR_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-14138dac | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1290 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7fc42e4e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1291 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-1883fb81 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1292 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-56b79b7b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1293 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-d380af5c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1294 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-5102694c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1295 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_JR_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-efa3b3a1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1296 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-d5f6289a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1297 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-948010d5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1298 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MOVING_FACTORY"] | enum_row_from_Saving["MOVING_FACTORY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-112e913e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1300 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-232322e9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1301 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-975cce8f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1302 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["JOB_ORDER"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c26007ae | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1304 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-852fe253 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1312 | try | DATA_OP | dt.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f362df50 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1318 | try ▸ if (saveDt == null && Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-204f4bc0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1319 | try ▸ if (saveDt == null && Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fd1fe6b0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1320 | try ▸ if (saveDt == null && Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b67fa094 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1330 | try ▸ if (cboPlanId.SelectedIndex >= 0) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-c0cbfab9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1336 | try | DATA_OP | saveDs.Tables.Add | (saveDt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9785cc23 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1348 | try | ENDPOINT | DataService.FP_UpdateBatch | ("FP02841_Plan_Amend_Elec_Post", "insert_Excel_buffer", saveDs, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-b15dfe03 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1350 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP02841_SAVE", Filter, CurrentUser, "SAVE", "MERGE_SAVE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0cfc56bd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1354 | try ▸ if (rsSave.Good() && rsSave.Tables[0].Rows[0]["RESULT_CODE"].ToString() == "SUCCESS") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d4e1e66b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1362 | try ▸ if (rsSave.Tables[0].Rows[0]["RESULT_CODE"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | (msg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2d7885ce | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1365 | try | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a877533d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1444 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-16f6a8b0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1445 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f76fdddf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1449 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1b0fa17b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1451 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37c72f58 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:1644 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-59a0c832 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1456 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5b87575 | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:1307 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c5043f7 | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:1308 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-11b27b54 | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:1310 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-75ec2fc1 | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:1312 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1e27d85 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1121 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da85a533 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1124 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetBohQty

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ecbb896 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1674 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-409cf4a6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1681 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-46f139a7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1687 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-21164baf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1688 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef750653 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1689 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ade0d10 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1690 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-59c4e901 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1691 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0114da8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1693 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-054b1f59 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1694 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd6fc518 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:1698 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-964531cf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1486 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-068e9258 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1493 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-5a33d90e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1499 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c6c81ec | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1500 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ec548f9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1501 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6815b4c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1502 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-94ff96e3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1503 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9ac62b2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1505 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea373dd1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1506 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8dbf5453 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1510 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetCalendarFormat

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (siMain != null) ▸ if (Filter["UNIT"].SafeZeroInt() == 1000)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (siMain != null) ▸ if (Filter["UNIT"].SafeZeroInt() == 1000)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d07de82 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2041 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExcel… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4effb2e6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2043 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (for… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd20f70e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2046 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c143a89 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2070 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExc… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e53affa7 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2072 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (f… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78696bae | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2075 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-446a4b11 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2101 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forE… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2da40ed6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2103 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of … | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ed26a3b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:2106 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f245c2f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1943 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExcel… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7eb0684 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1945 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (for… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-063defbc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1948 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da29e619 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1972 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExc… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eea6359a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1974 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (f… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-627bc9cc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1977 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dad3087 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2003 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forE… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc1911b0 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2005 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of … | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29cb5d70 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2008 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee51d19b | this.Load | FP02841_Plan_Amend_Elec_Post.cs:357 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-fc522b3e | this.Load | FP02841_Plan_Amend_Elec_Post.cs:357 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8dd580d6 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:359 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-678aa82e | this.Load | FP02841_Plan_Amend_Elec_Post.cs:363 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-80af1a4d | this.Load | FP02841_Plan_Amend_Elec_Post.cs:363 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa954f10 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:365 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-2c5cc252 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:369 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-1b52f5dc | this.Load | FP02841_Plan_Amend_Elec_Post.cs:369 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-191d0350 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:371 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-c2f34e12 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:375 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-ddb46cd7 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:375 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-65bda286 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:380 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-f9f1a0ae | this.Load | FP02841_Plan_Amend_Elec_Post.cs:384 |  | FLAG | dtProdType | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-d5a97001 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:384 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PROD_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5a2f6c61 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:385 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-33333a36 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:350 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-d79a0c1b | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:350 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f374d2fd | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:352 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-9779ae40 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:356 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-e00b1ae2 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:356 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b63e482 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:358 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-1ed66d52 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:362 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-f25e9216 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:362 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe0485ce | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:364 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-93d0ad14 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:368 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-0bcd96e6 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:368 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-640fd389 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:373 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-9ef18baf | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:377 |  | FLAG | dtProdType | Data_FP.CallGeneralProcedure2(("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-bef78f8a | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:377 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP02841_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PROD_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f118e448 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:378 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, true) | 목록 컨트롤 재구성 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetColMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcc359cf | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2122 |  | FLAG | sv | siMain.ActiveSheet | 화면 필드/플래그 변경 |  |  |  |
| AC-05ab9e2a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2125 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-53b0399a | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2130 | for (i < sv.ColumnCount) | CALL_EXT | sv.Columns.Get | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a091399 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2131 | for (i < sv.ColumnCount) | CALL_EXT | sv.Columns.Get | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9aa38401 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2146 | for (j < sv.RowCount) ▸ if (sDataType == "DATA") | GRID_SET | sv.Cells[j, columnIdx].ColumnSpan | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-8f0db63e | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post.cs:2150 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-57589b61 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2024 |  | FLAG | sv | siMain.ActiveSheet | 화면 필드/플래그 변경 |  |  |  |
| AC-14c5e381 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2027 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c2c67d8d | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2032 | for (i < sv.ColumnCount) | CALL_EXT | sv.Columns.Get | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17abdbe7 | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2033 | for (i < sv.ColumnCount) | CALL_EXT | sv.Columns.Get | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19eea68c | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2048 | for (j < sv.RowCount) ▸ if (sDataType == "DATA") | GRID_SET | sv.Cells[j, columnIdx].ColumnSpan | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-c4528ddd | (진입점 미연결) | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2052 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1e3e0b3 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:125 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1125d3f | this.Load | FP02841_Plan_Amend_Elec_Post.cs:127 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-73dd2bd3 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:128 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2d38dfc5 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:129 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1f01c7e3 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:131 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-1b03e941 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:132 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8c31f216 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:133 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-12caac2f | this.Load | FP02841_Plan_Amend_Elec_Post.cs:137 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-47a1206f | this.Load | FP02841_Plan_Amend_Elec_Post.cs:138 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a4ea1b13 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:139 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ef9d19da | this.Load | FP02841_Plan_Amend_Elec_Post.cs:141 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-386c474b | this.Load | FP02841_Plan_Amend_Elec_Post.cs:142 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a8809d84 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:143 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f521d301 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:145 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-4c727b65 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:146 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64139565 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:148 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-d0a2906b | this.Load | FP02841_Plan_Amend_Elec_Post.cs:149 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8a015378 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:150 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b2b678a5 | this.Load | FP02841_Plan_Amend_Elec_Post.cs:154 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b729e84f | this.Load | FP02841_Plan_Amend_Elec_Post.cs:155 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-88ad9dfb | this.Load | FP02841_Plan_Amend_Elec_Post.cs:156 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-361633e0 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:125 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0871398 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:127 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-077ede32 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:128 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3da441c1 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:129 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-63731455 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:131 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-cade20d5 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:132 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-92fd0b49 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:133 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-57896c8a | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:137 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c40879f0 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:138 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnExcelImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-308a7445 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:139 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5d1cb3fc | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:141 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-24b23554 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:142 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3cafd665 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:143 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8a992554 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:145 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-9bf4a172 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:146 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63d83f89 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:148 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a1282204 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:149 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1ec023a1 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:150 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8cc6880f | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:154 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-7340f117 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:155 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ce84eab0 | this.Load | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:156 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetDirty

진입점: spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.Sa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbbbf63d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 11 | FP02841_Plan_Amend_Elec_Post.cs:6230 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |
| AC-2b433ca5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 11 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6268 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetFilter

진입점: this.Load / cboInstance.SelectedIndexChanged [if (dtInstance.Good())] / cboPlanId.SelectedIndexChanged [if (dtPlanId.Good())] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / txtItem.TextChanged / clbElecType.SelectedIndexChanged / drpPeriod.ValueChanged / cboUom.SelectedIndexChanged / cboUnit.SelectedIndexChanged / cboRoundPoint.SelectedIndexChanged / clbProdType.SelectedIndexChanged / popSql.OnSql [if (programID == "PR_UI_FP02841_PLAN_AMEND_ELEC_POST") ▸ try ▸ if (GetFilter("INSTANCE_ID") == "") ▸ lambda] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46200111 | this.Load 외 22 | FP02841_Plan_Amend_Elec_Post.cs:2572 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-f72421d5 | this.Load 외 22 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2474 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetPlanOutCell

진입점: spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.Sa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad520a90 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3786 |  | STATE_RESET | stopwatch.Reset | () | 저장/작업 상태 초기화 |  |  |  |
| AC-96addb58 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3788 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8df2c395 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3808 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-9d0582bf | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3852 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a856b16 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3852 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed9f8af9 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3856 | if (dsMain.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-fddb9997 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3856 | if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fde6145 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3863 | if (dlData == null \|\| dlView == null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8cf2a1ea | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:3864 | if (dlData == null \|\| dlView == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec10b353 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4001 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6f46c23 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4012 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa6f12d3 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4041 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dtYield.Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-c6a11a3d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4047 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ELECTRODE_TYPE = '" + row["… | 데이터 객체 조작/조회 |  |  |  |
| AC-5f2c2e4a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4052 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ELECTRODE_TYPE = '" + row["… | 데이터 객체 조작/조회 |  |  |  |
| AC-aadbd98a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4058 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-faa7971c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4065 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-66f1d5d5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4072 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-91a20d46 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4079 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-b098cf5c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4086 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-d534cd44 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4093 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-f61f6cba | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4100 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-58273277 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4107 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-55c51128 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4114 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-19618745 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4121 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-ba478878 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4129 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsSubTotalFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-6eb8a193 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4135 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsSubTotalFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-d05bf107 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4141 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsSubTotalFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-b4638033 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4163 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '"+ n_col +"' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-25ce19a8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4166 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | weekInfo.Tables[0].Select | ("WEEK = '"+ sWeek+"' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6b8c026 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4171 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-8176758a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4179 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_total") && current_catagory.Equals("SLITTING_PLAN"))… | GRID_SET | siMain.ActiveSheet.Cells[nRow, iWeekIdx].Value | existingSubTotalSlittingPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-98e25ec4 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4183 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa9a38f6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4191 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_total") && current_catagory.Equals("ROLL_PRESS_PLAN"… | GRID_SET | siMain.ActiveSheet.Cells[nRow, iWeekIdx].Value | existingSubTotalRollPressPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-09a34ef1 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4239 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr") | 데이터 객체 조작/조회 |  |  |  |
| AC-d704d2de | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4245 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr") | 데이터 객체 조작/조회 |  |  |  |
| AC-2df7ba42 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4251 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_pre") | 데이터 객체 조작/조회 |  |  |  |
| AC-04313569 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4257 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post") | 데이터 객체 조작/조회 |  |  |  |
| AC-876b34f0 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4263 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post") | 데이터 객체 조작/조회 |  |  |  |
| AC-67fb1c2b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4269 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e62b7f2 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4275 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc") | 데이터 객체 조작/조회 |  |  |  |
| AC-2aad5094 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4288 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec") | 데이터 객체 조작/조회 |  |  |  |
| AC-78eb1cf7 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4294 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5f79b77 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4300 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d67a567 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4307 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-591e57a6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4313 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-60830ab7 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4319 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_pre_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-eae3a640 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4325 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-67bbdcde | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4331 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-30ecfd42 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4337 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-c98cbb8e | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4343 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-4dc31435 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4355 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-35fb9067 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4361 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-82195d9e | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4367 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ae6bb71 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4373 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-13015607 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4379 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-f566dad5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4396 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (bTotalSlittingPlan) ▸ if (rowTotalSlittingP… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingSubTotalSlittingPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-4cda020d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4408 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (bTotalRollPressgPlan) ▸ if (rowTotalRollPre… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingSubTotalRollPressPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-f9eca3c8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4443 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJr) ▸ if (… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJR + (in_delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-9f86d6d2 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4457 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPre) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPre + (in_delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-2a934c74 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4473 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPost) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPost + (in_delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-527f8607 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4478 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPost) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPost + in_delta | 그리드 속성/값 설정 |  |  |  |
| AC-20fe7031 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4494 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohPc) ▸ if (… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohPC + in_delta | 그리드 속성/값 설정 |  |  |  |
| AC-274b44a5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4507 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohElec) ▸ if… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohElec + in_delta | 그리드 속성/값 설정 |  |  |  |
| AC-827f0ddc | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4522 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrHold) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRHold + (in_delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-5e6ccce4 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4538 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPreHold)… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPreHold + (in_delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-abef8358 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4554 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPostHold… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPostHold + (in_delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-fef6de94 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4559 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPostHold… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPostHold + in_delta | 그리드 속성/값 설정 |  |  |  |
| AC-82124cf8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4575 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohPcHold) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohPCHold + in_delta | 그리드 속성/값 설정 |  |  |  |
| AC-15d19c60 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4590 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohElecHold) … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohElecHold + in_delta | 그리드 속성/값 설정 |  |  |  |
| AC-8d6a0388 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4607 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohJr[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-30a22ee1 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4608 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohJr[0][n_col] | existingSubTotalEohJR / (nJUMBO_ROLL_LENGTH.SafeZeroInt() > 0 ? nJUMBO_ROLL_LENGTH : nRoll… | 행/컬럼 값 대입 |  |  |  |
| AC-f43e558e | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4618 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohPc[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-fcac5bbf | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4619 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohPc[0][n_col] | existingSubTotalEohPC * (nLane > 0 ? nLane : 1) / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? nPC… | 행/컬럼 값 대입 |  |  |  |
| AC-713f62db | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4625 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohElec[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-96c11438 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4626 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohElec[0][n_col] | existingSubTotalEohElec * (nLane > 0 ? nLane : 1) / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? n… | 행/컬럼 값 대입 |  |  |  |
| AC-d32bc659 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4640 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohJr[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-fb780c32 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4641 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohJr[0][n_col] | existingSubTotalEohJR / (nLane > 0 ? nLane : 1) / (nJUMBO_ROLL_LENGTH.SafeZeroInt() > 0 ? … | 행/컬럼 값 대입 |  |  |  |
| AC-31665351 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4651 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohPc[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-f13fbeae | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4652 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohPc[0][n_col] | existingSubTotalEohPC / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? nPC_ROLL_LENGTH : nRoll) | 행/컬럼 값 대입 |  |  |  |
| AC-c62a3f36 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4657 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohElec[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-756a76d5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4658 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohElec[0][n_col] | existingSubTotalEohElec / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? nPC_ROLL_LENGTH : nRoll) | 행/컬럼 값 대입 |  |  |  |
| AC-b802cd0b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4701 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_slitting_roll") | 데이터 객체 조작/조회 |  |  |  |
| AC-607c8ff7 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4702 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_rollpress_roll") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2bfa91c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4709 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-755e5470 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4724 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | GRID_SET | siMain.ActiveSheet.Cells[nRow, nColumn].Value | Math.Ceiling(tt) | 그리드 속성/값 설정 |  |  |  |
| AC-256c7c8f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4731 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-88133d36 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4745 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | GRID_SET | siMain.ActiveSheet.Cells[nRow, nColumn].Value | Math.Ceiling(new_value * Filter["UNIT"].SafeZeroInt() / nM_Per_Roll) | 그리드 속성/값 설정 |  |  |  |
| AC-e84123a4 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4759 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcdebfb0 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4763 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ce3124a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4768 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4194ffb6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4782 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (current_catagory.Equals("MOVING_PLAN") && sMoving_Factory != "") | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + sMoving_Factory + "'" + " AND ITEM_ID = '" + row["ITEM_ID"].ToString()… | 데이터 객체 조작/조회 |  |  |  |
| AC-29573fe2 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post.cs:4803 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7131c531 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3689 |  | STATE_RESET | stopwatch.Reset | () | 저장/작업 상태 초기화 |  |  |  |
| AC-79b2bdee | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3691 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-61873991 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3711 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-a283af03 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3755 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-75d3835b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3755 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d125e26 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3759 | if (dsMain.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f6d179e | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3759 | if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54064829 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3766 | if (dlData == null \|\| dlView == null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fb9b78fa | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3767 | if (dlData == null \|\| dlView == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4234ab6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3901 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e76aec6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3910 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b3741b4 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3939 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ELECTRODE_TYPE = '" + row["… | 데이터 객체 조작/조회 |  |  |  |
| AC-50edfe2c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3944 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ELECTRODE_TYPE = '" + row["… | 데이터 객체 조작/조회 |  |  |  |
| AC-9d8b2a2f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3950 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-db9e3ca0 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3957 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-29911b9c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3964 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-309f1091 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3971 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-444bfe24 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3978 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-aa2ce541 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3985 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-f0f3db94 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3992 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-91f8cd9a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:3999 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-6d69cebe | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4006 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-20e6ccb7 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4013 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-06ea067d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4021 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsSubTotalFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-baaa4a4c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4027 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsSubTotalFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-dca58058 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4033 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dsSubTotalFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-cd85c10c | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4055 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '"+ n_col +"' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-16f0b4af | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4058 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | weekInfo.Tables[0].Select | ("WEEK = '"+ sWeek+"' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-f9cb555a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4063 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9b817ca | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4071 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_total") && current_catagory.Equals("SLITTING_PLAN"))… | GRID_SET | siMain.ActiveSheet.Cells[nRow, iWeekIdx].Value | existingSubTotalSlittingPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-5cf89f55 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4075 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-69ece7e1 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4083 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_total") && current_catagory.Equals("ROLL_PRESS_PLAN"… | GRID_SET | siMain.ActiveSheet.Cells[nRow, iWeekIdx].Value | existingSubTotalRollPressPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-9b5bc5ff | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4121 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr") | 데이터 객체 조작/조회 |  |  |  |
| AC-007f8040 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4127 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr") | 데이터 객체 조작/조회 |  |  |  |
| AC-71a548d5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4133 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_pre") | 데이터 객체 조작/조회 |  |  |  |
| AC-4718a1fb | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4139 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post") | 데이터 객체 조작/조회 |  |  |  |
| AC-ecc60d14 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4145 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post") | 데이터 객체 조작/조회 |  |  |  |
| AC-80693f08 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4151 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b108ae6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4157 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc") | 데이터 객체 조작/조회 |  |  |  |
| AC-314b940e | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4170 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8cc3a2a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4176 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec") | 데이터 객체 조작/조회 |  |  |  |
| AC-d760d752 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4182 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec") | 데이터 객체 조작/조회 |  |  |  |
| AC-58e79fe4 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4189 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e2cbd27 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4195 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1eab90f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4201 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_pre_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f95bc1d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4207 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-3249aee8 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4213 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_jr_post_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e113253 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4219 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c37525a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4225 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_pc_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-33cf84ab | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4237 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-8356f585 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4243 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-68bac951 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4249 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh_elec_hold") | 데이터 객체 조작/조회 |  |  |  |
| AC-f69d231a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4255 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c59e702 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4261 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_total") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6932f62 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4278 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (bTotalSlittingPlan) ▸ if (rowTotalSlittingP… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingSubTotalSlittingPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-cc3117b7 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4290 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (bTotalRollPressgPlan) ▸ if (rowTotalRollPre… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingSubTotalRollPressPlan + delta | 그리드 속성/값 설정 |  |  |  |
| AC-9dd00bfe | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4324 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJr) ▸ if (… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJR + ( delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-dc842ff0 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4338 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPre) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPre + (delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-f344c55a | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4354 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPost) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPost + (delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-9398607f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4358 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPost) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPost + delta | 그리드 속성/값 설정 |  |  |  |
| AC-4bc61228 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4373 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohPc) ▸ if (… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohPC + delta | 그리드 속성/값 설정 |  |  |  |
| AC-181e1e90 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4386 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohElec) ▸ if… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohElec + delta | 그리드 속성/값 설정 |  |  |  |
| AC-93f138c5 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4401 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrHold) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRHold + (delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-74b620de | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4415 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPreHold)… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPreHold + (delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-4c048d0e | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4431 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPostHold… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPostHold + (delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-8a70fb61 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4435 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohJrPostHold… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohJRPostHold + delta | 그리드 속성/값 설정 |  |  |  |
| AC-eee898cc | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4450 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohPcHold) ▸ … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohPCHold + delta | 그리드 속성/값 설정 |  |  |  |
| AC-cbb91afd | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4463 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bEohElecHold) … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohElecHold + delta | 그리드 속성/값 설정 |  |  |  |
| AC-ffbafbfd | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4479 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohJr[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-f3d8ab1b | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4480 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohJr[0][n_col] | existingSubTotalEohJR / (nJUMBO_ROLL_LENGTH.SafeZeroInt() > 0 ? nJUMBO_ROLL_LENGTH : nRoll… | 행/컬럼 값 대입 |  |  |  |
| AC-f4edaecd | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4490 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohPc[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-1de3bef4 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4491 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohPc[0][n_col] | existingSubTotalEohPC * (nLane > 0 ? nLane : 1) / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? nPC… | 행/컬럼 값 대입 |  |  |  |
| AC-c89509d0 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4497 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohElec[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-9e1ddf4d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4498 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (Filter["UOM_TY… | DATA_OP | rowSubTotalEohElec[0][n_col] | existingSubTotalEohElec * (nLane > 0 ? nLane : 1) / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? n… | 행/컬럼 값 대입 |  |  |  |
| AC-92e9cb10 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4512 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohJr[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-9cabc144 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4513 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohJr[0][n_col] | existingSubTotalEohJR / (nLane > 0 ? nLane : 1) / (nJUMBO_ROLL_LENGTH.SafeZeroInt() > 0 ? … | 행/컬럼 값 대입 |  |  |  |
| AC-b9b7bb69 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4523 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohPc[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b3d378b6 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4524 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohPc[0][n_col] | existingSubTotalEohPC / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? nPC_ROLL_LENGTH : nRoll) | 행/컬럼 값 대입 |  |  |  |
| AC-1ba0c38d | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4529 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohElec[0][n_col] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-30daab69 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4530 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ else of (Filter["U… | DATA_OP | rowSubTotalEohElec[0][n_col] | existingSubTotalEohElec / (nPC_ROLL_LENGTH.SafeZeroInt() > 0 ? nPC_ROLL_LENGTH : nRoll) | 행/컬럼 값 대입 |  |  |  |
| AC-ac243da3 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4573 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_slitting_roll") | 데이터 객체 조작/조회 |  |  |  |
| AC-106e07d1 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4574 | if (dsMainFiltered.Good() \|\| clicked_row == null) | DATA_OP | measure.Data.ContainsKey | ("chk_rollpress_roll") | 데이터 객체 조작/조회 |  |  |  |
| AC-3348e117 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4581 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-f7d327f2 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4595 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | GRID_SET | siMain.ActiveSheet.Cells[nRow, nColumn].Value | Math.Ceiling(tt) | 그리드 속성/값 설정 |  |  |  |
| AC-50d39cb9 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4602 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND ITEM_ID = '" + row["ITEM_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-97dea56f | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4615 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (measure.Data.ContainsKey("chk_slitting_roll") \|\| measure.Data.ContainsKey("chk_r… | GRID_SET | siMain.ActiveSheet.Cells[nRow, nColumn].Value | Math.Ceiling(new_value * Filter["UNIT"].SafeZeroInt() / nMeter_Per_Roll) | 그리드 속성/값 설정 |  |  |  |
| AC-d5fba772 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4629 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fe68554 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4633 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-445ef391 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4638 | if (dsMainFiltered.Good() \|\| clicked_row == null) | CALL_EXT | stopwatch.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-af89adc2 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4652 | if (dsMainFiltered.Good() \|\| clicked_row == null) ▸ if (current_catagory.Equals("MOVING_PLAN") && sMoving_Factory != "") | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID = '" + sMoving_Factory + "'" + " AND ITEM_ID = '" + row["ITEM_ID"].ToString()… | 데이터 객체 조작/조회 |  |  |  |
| AC-3064a493 | spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet… 외 3 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:4673 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetRowFormat

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleCli…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce8f2ea4 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:1945 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (category_id == "TOTAL_ROLL" \|\| category_id == "S… | CALL_EXT | siMain.SetRowFormatDecimalDigit | (iRoundPoint, row_index, 1, colindex, -1, sColFormat, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8389d9d6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:1947 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (category_id == "TOTAL_ROLL" \|\| category_id == "S… | CALL_EXT | siMain.SetRowFormatDecimalDigit | (iRoundPoint, row_index, 1, colindex, -1, sColFormat, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34c4facb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post.cs:1950 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (category_id == "TOTAL_ROLL" \|\| category_id == "S… | CALL_EXT | siMain.SetRowFormatDecimalDigit | (iRoundPoint, row_index, 1, colindex, -1, sColFormat, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29d7759f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1847 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (category_id == "TOTAL_ROLL" \|\| category_id == "S… | CALL_EXT | siMain.SetRowFormatDecimalDigit | (iRoundPoint, row_index, 1, colindex, -1, sColFormat, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f84c875a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1849 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (category_id == "TOTAL_ROLL" \|\| category_id == "S… | CALL_EXT | siMain.SetRowFormatDecimalDigit | (iRoundPoint, row_index, 1, colindex, -1, sColFormat, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ebc25ea | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1852 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (category_id == "TOTAL_ROLL" \|\| category_id == "S… | CALL_EXT | siMain.SetRowFormatDecimalDigit | (iRoundPoint, row_index, 1, colindex, -1, sColFormat, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SetSpreadInit

진입점: this.Load [try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-565faa2d | this.Load [try] 외 7 | FP02841_Plan_Amend_Elec_Post.cs:457 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a536431d | this.Load [try] 외 7 | FP02841_Plan_Amend_Elec_Post.cs:458 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-82dcbd7b | this.Load [try] 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:450 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ffb5fef | this.Load [try] 외 7 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:451 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-450bea1e | this.spdMain.ButtonClicked | FP02841_Plan_Amend_Elec_Post.cs:6002 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-d1cdf262 | this.spdMain.ButtonClicked | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5873 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7247ee01 | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5428 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbd1a0c2 | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5451 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-ff514ac2 | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5452 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-b06ce02f | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5454 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-c536afab | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5463 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-abf3284b | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5464 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-61653ed4 | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5466 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-61f0aa3e | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5472 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-367c5a39 | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5477 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-b54e6ea0 | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5478 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-4dbe6afb | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5480 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-da8c4f11 | this.spdMain.CellClick | FP02841_Plan_Amend_Elec_Post.cs:5488 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_CellClick2

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58d802f1 | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5316 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-c27312cb | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5317 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-721c21ec | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5319 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ed0a1e4 | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5328 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-d589d35f | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5329 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-8f6bf3f4 | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5331 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-44764be8 | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5337 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9227fb68 | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5342 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-89db0a9f | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5343 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-24aca26d | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5345 | if (e.Button == MouseButtons.Right) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Tables.Count > 0) ▸ if (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-27f8766e | spdMain.CellClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5353 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcfa2c1c | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6262 |  | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a45aee9 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6273 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_plan_group", CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues)… | ⚠ 의미 확인 필요 |  |  |  |
| AC-06296527 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6274 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "drpPlanDate", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7ccdc9c | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6275 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_fpplanid", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6948126 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6276 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_division", CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0cdac8a | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6277 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_site", CString.GetCheckedListValue(dtSite, cboSite.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-799fd39e | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6278 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_plant", CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ded3c384 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6279 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_factory", CString.GetCheckedListValue(dtSite, clbFactory.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f736c13 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6280 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "dCalendar_planrange", Filter["BUCKET_FROM"] + "-" + Filter["BUCKET_TO"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5ab98a9 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6283 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_BASE | openSubMenu | ("FP02842", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a393a7f | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6291 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_plan_group", CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues)… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b163c2e | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6292 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "sCalendar_planday", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-877581d8 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6293 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_fpplanid", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00052a54 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6294 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_division", CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25aa07ab | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6295 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_site", CString.GetCheckedListValue(dtSite, cboSite.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-654f81c4 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6296 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_plant", CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21db2949 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6298 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_factory", Filter["SEL_FACTORY_ID"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1bb99344 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6299 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_EXT | BaseForm.SetManualCondition | (Msc, "dCalendar_planrange", Filter["PLAN_DATE"] + "-" + Filter["BUCKET_TO"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98f72def | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6301 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ if (colname.IndexOf("CATEGORY_NAME") > -1 && row["… | CALL_BASE | openSubMenu | ("FP02844", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-84525682 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6309 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "drpCutoffDate", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9508764c | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6310 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "clbDivision", CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-beb1049c | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6311 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "clbSite", CString.GetCheckedListValue(dtSite, cboSite.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8da7b9fc | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6314 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "txtItemId", Filter["SEL_ITEM_ID"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c03552f6 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6316 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && … | CALL_BASE | openSubMenu | ("FP00731", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9b8111b | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6355 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && … | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-9368003a | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post.cs:6362 | else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && … | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-4383c8a7 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6300 |  | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2684e0a1 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6311 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_plan_group", CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues)… | ⚠ 의미 확인 필요 |  |  |  |
| AC-24de6dd9 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6312 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "drpPlanDate", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f8fa6ef | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6313 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_fpplanid", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-814d6643 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6314 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_division", CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77f38731 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6315 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_site", CString.GetCheckedListValue(dtSite, cboSite.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d322ee7b | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6316 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_plant", CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e709877f | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6317 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_factory", CString.GetCheckedListValue(dtSite, clbFactory.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36e410ea | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6318 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "dCalendar_planrange", Filter["BUCKET_FROM"] + "-" + Filter["BUCKET_TO"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8aa6164 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6321 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") | CALL_BASE | openSubMenu | ("FP02842", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-920f4121 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6329 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_plan_group", CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues)… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe5bdac5 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6330 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "sCalendar_planday", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f456019e | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6331 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_fpplanid", CString.GetCheckedListValue(dtPlanId, cboPlanId.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3791cf0e | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6332 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_division", CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89804d18 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6333 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_site", CString.GetCheckedListValue(dtSite, cboSite.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4555bb1 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6334 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_plant", CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3ba95f0 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6336 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_factory", Filter["SEL_FACTORY_ID"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11ae1cd6 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6337 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "dCalendar_planrange", Filter["PLAN_DATE"] + "-" + Filter["BUCKET_TO"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-906ada4c | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6339 | if (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") | CALL_BASE | openSubMenu | ("FP02844", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-861b63d8 | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6347 | if (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "drpCutoffDate", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54a3901d | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6348 | if (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "clbDivision", CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-547e426f | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6349 | if (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "clbSite", CString.GetCheckedListValue(dtSite, cboSite.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e86312e | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6352 | if (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") | CALL_EXT | BaseForm.SetManualCondition | (Msc, "txtItemId", Filter["SEL_ITEM_ID"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f8bb94d | this.spdMain.CellDoubleClick | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:6354 | if (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") | CALL_BASE | openSubMenu | ("FP00731", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_Change

진입점: spdMain.Change / this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb77692c | spdMain.Change 외 1 | FP02841_Plan_Amend_Elec_Post.cs:5990 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9cad990c | spdMain.Change 외 1 | FP02841_Plan_Amend_Elec_Post.cs:5997 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c85b797e | spdMain.Change 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5861 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d5a8e2d | spdMain.Change 외 1 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5868 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5af759b | this.spdMain.ChildControlDeactivated | FP02841_Plan_Amend_Elec_Post.cs:5949 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-8c4a8843 | this.spdMain.ChildControlDeactivated | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5820 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bf24a1f | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post.cs:5912 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a003ce1d | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post.cs:5920 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a94ba00b | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post.cs:5921 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5287edc | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post.cs:5923 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-87ba8d02 | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5783 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-289d87b2 | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5791 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ed437a50 | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5792 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bda40b1f | this.spdMain.ClipboardPasted | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5794 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ee65cdc | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post.cs:5885 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-122a8ca8 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post.cs:5886 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-9fbdbe0e | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post.cs:5886 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-974ca1e6 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post.cs:5890 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-43ae7761 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post.cs:5890 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e98fc716 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post.cs:5894 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ab7f607 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post.cs:5896 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0669dd20 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5756 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-755e2ffd | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5757 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-338eaca6 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5757 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-679afe99 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5761 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f14b1d7 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5761 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-45a33915 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5765 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-787efcb7 | this.spdMain.ClipboardPasting | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5767 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52626dd7 | this.spdMain.DragFillBlockCompleted | FP02841_Plan_Amend_Elec_Post.cs:5959 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-1087c2f7 | this.spdMain.DragFillBlockCompleted | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5830 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2471fbd5 | this.spdMain.EditModeOff | FP02841_Plan_Amend_Elec_Post.cs:5977 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-b62ff428 | this.spdMain.EditModeOff | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5848 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f770f1ab | this.spdMain.EditModeOn | FP02841_Plan_Amend_Elec_Post.cs:5983 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-341ce8a6 | this.spdMain.EditModeOn | FP02841_Plan_Amend_Elec_Post.cs:5984 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |
| AC-10090ce9 | this.spdMain.EditModeOn | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5854 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-bf752d40 | this.spdMain.EditModeOn | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5855 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e49e32fd | this.spdMain.EditorFocused | FP02841_Plan_Amend_Elec_Post.cs:5971 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-c1735af8 | this.spdMain.EditorFocused | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5842 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3880ae47 | this.spdMain.Enter | FP02841_Plan_Amend_Elec_Post.cs:5934 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-3301c4ad | this.spdMain.Enter | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5805 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfd7b77b | this.spdMain.KeyDown | FP02841_Plan_Amend_Elec_Post.cs:5502 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-ea988bb5 | this.spdMain.KeyDown | FP02841_Plan_Amend_Elec_Post.cs:5506 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f43aa1d9 | this.spdMain.KeyDown | FP02841_Plan_Amend_Elec_Post.cs:5507 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5e5f8e04 | this.spdMain.KeyDown | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5367 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-29f351f7 | this.spdMain.KeyDown | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5371 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1e66696 | this.spdMain.KeyDown | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5372 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8e36649 | this.spdMain.Leave | FP02841_Plan_Amend_Elec_Post.cs:5929 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-29c76fb9 | this.spdMain.Leave | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5800 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01ee92ef | this.spdMain.SubEditorClosed | FP02841_Plan_Amend_Elec_Post.cs:5965 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-48472c64 | this.spdMain.SubEditorClosed | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5836 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f84fe3c | this.spdMain.SubEditorOpening | FP02841_Plan_Amend_Elec_Post.cs:5954 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-78a7e0a1 | this.spdMain.SubEditorOpening | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5825 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4854c4f8 | this.spdMain.Validated | FP02841_Plan_Amend_Elec_Post.cs:5939 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-00b753e7 | this.spdMain.Validated | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5810 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ff2dcc2 | this.spdMain.Validating | FP02841_Plan_Amend_Elec_Post.cs:5944 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-43a94a9b | this.spdMain.Validating | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5815 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SubTotalFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-868d0eda | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:2158 | lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d16ecc3f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:2162 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-234ef117 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:2165 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-502bc76a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post.cs:2167 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |
| AC-edca65ea | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2060 | lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3dabb932 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2064 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d882e032 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2067 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-adb80ab5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 9 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2069 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() =="DATA") ▸ else of (colname.IndexOf("CATEGORY_NAME") > -1 && row["DATA_TYPE"].ToString() == "TOTAL") ▸ else of (colname.IndexOf("ASSY") > -1 && row["DATA_TYPE"].ToString() == "DATA") ▸ try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-357ea939 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6378 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7c71948 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6395 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-e531b026 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6420 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b5ce42b | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6446 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4909d057 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6448 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-b6545ce3 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6451 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a01ed76b | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6453 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-99f177b4 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6453 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d58a7ce | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6454 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-ae925351 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6456 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-cf3f473f | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6458 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f2c97461 | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6470 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5d6905c | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6470 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6acf6ca | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6490 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-efbdc88e | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6491 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-c30aba4a | memo_menu.Click [if (day != null)] 외 1 | FP02841_Plan_Amend_Elec_Post.cs:6493 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b33ae0b8 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5712 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04753291 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5716 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-65c523a0 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5717 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 65) | 데이터 객체 조작/조회 |  |  |  |
| AC-60d848bb | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5718 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-265a36a5 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5719 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 50) | 데이터 객체 조작/조회 |  |  |  |
| AC-6acb1248 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5720 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 120) | 데이터 객체 조작/조회 |  |  |  |
| AC-03261e8c | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5721 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 10) | 데이터 객체 조작/조회 |  |  |  |
| AC-e871e3ed | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5726 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-1e45e84b | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post.cs:5727 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |
| AC-d31b6c70 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5587 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d854d3db | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5591 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2b765f1 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5592 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 65) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0c3d15f | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5593 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-c10315f7 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5594 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 50) | 데이터 객체 조작/조회 |  |  |  |
| AC-2da01f77 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5595 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 120) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c5ad684 | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5596 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 10) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ca595ad | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5601 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-ae6b959d | tbNickName.BeforeOpenSearch | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5602 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d412f6b6 | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post.cs:5736 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4def1501 | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post.cs:5737 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e8d50a2 | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post.cs:5743 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-2285c01d | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post.cs:5746 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-55eebd57 | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post.cs:5748 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c6674cb8 | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5611 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39591566 | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5612 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-517f90ae | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5618 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-0e8ecc2c | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5621 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e361a25d | tbNickName.OnSearchConditionChanged | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:5623 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true)] / this.usrButton3.Click [if (popPlanTotal.DialogResult == DialogResult.OK)] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCategory.Clic…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64cbdbe3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:841 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3afeee1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:842 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-353d9de2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:845 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-360dfe1e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:848 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-4bf9858f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:848 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["FP_PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-fa5e24c4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:852 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-9092a0ff | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:853 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-515dcb70 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:874 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d578f625 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:875 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5050a26 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:879 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b2a16a1b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:883 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cd6c6111 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:884 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-741cda45 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:888 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-de7457c5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:898 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2fa80241 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:900 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4171ed9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:900 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5248555f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:907 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf93c979 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:909 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | LastTotalRaw | FindTotalValue() | 화면 필드/플래그 변경 |  |  |  |
| AC-d22de1aa | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:912 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0619337 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:924 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e7c3139c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:928 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02f282df | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:934 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c131815d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:938 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4b259497 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:946 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c18efbf5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:950 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-238cc75d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post.cs:954 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c09bffba | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1698 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-988fcdb4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1699 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe5cb60d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1703 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a3462cda | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1707 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c681633e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1708 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c5bdf0c8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1712 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-861b8cbf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1720 | try | FLAG | dsMain | FindMainData(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-31f4866e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1721 | try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b421101 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1723 | try | FLAG | LastTotalRaw | FindTotalValue() | 화면 필드/플래그 변경 |  |  |  |
| AC-7997ad0f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1726 | try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5cd2c18 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1738 | try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6f4df8e7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1742 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bfbea866 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1748 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55bb7971 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 6 | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:1752 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_Plan_Amend_Elec_Post.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29d530cd | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2501 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-ed4690ed | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2502 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5987ccc | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2510 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-27c0a221 | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2513 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fdc76887 | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2515 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-89a3a42b | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2522 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-d97772f5 | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2527 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d581383d | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2531 | if (save_success == true) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f875f62c | SaveButton | FP02841_Plan_Amend_Elec_Post.cs:2533 | if (save_success == true) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5c4be38 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2403 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-c5714c47 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2404 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18cd9368 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2412 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-7be270c4 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2415 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-be1264d1 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2417 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe356a42 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2424 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-57ff00a8 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2429 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-818e79e4 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2433 | if (save_success == true) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-18889de7 | SaveButton | FP02841_Plan_Amend_Elec_Post_MergeLineSample.cs:2435 | if (save_success == true) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02841_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b4c9302 | .ctor | FP02841_RowExcelPopup.cs:138 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-af233502 | .ctor | FP02841_RowExcelPopup.cs:141 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-265e1031 | .ctor | FP02841_RowExcelPopup.cs:142 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP02841_RowExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9a71f1e | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:217 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-79a4f213 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:218 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-300d48b5 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:219 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-911e02a7 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:220 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c2caaf9c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:222 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-e2659370 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:222 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-419c77a0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:223 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-5f3c5631 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:223 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-61188ba8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:224 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-966a2d84 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:224 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-68bf364c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:225 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-448c5de1 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:225 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP02841_Plan_Amend_Elec_Post", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-faa1315b | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:235 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-c8cfc46d | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:236 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-ef96d1ef | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:237 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-fc1a9f74 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP02841_RowExcelPopup.cs:238 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP02841_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa3a7ae2 | this.btnClose.Click | FP02841_RowExcelPopup.cs:821 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-281442a2 | this.btnDownload.Click | FP02841_RowExcelPopup.cs:803 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-e57b0d88 | this.btnDownload.Click | FP02841_RowExcelPopup.cs:804 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP02841_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e515c40 | this.btnFind.Click | FP02841_RowExcelPopup.cs:794 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6bbe384 | this.btnFind.Click | FP02841_RowExcelPopup.cs:795 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02841_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ab6bcda | this.Load | FP02841_RowExcelPopup.cs:266 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-50e4d3b8 | this.Load | FP02841_RowExcelPopup.cs:267 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0f250ab | this.Load | FP02841_RowExcelPopup.cs:268 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02841_RowExcelPopup.dateRange_ValueChanged

진입점: this.dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79f8442e | this.dateRange.ValueChanged | FP02841_RowExcelPopup.cs:826 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-be64ca4f | this.dateRange.ValueChanged | FP02841_RowExcelPopup.cs:827 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP02841_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-834be822 | (진입점 미연결) | FP02841_RowExcelPopup.cs:757 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4daebef | (진입점 미연결) | FP02841_RowExcelPopup.cs:757 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP02841_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00c55728 | this.Load | FP02841_RowExcelPopup.cs:261 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP02841_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11e9d0cf | Dispose | FP02841_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02841_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b1d62d6 | (진입점 미연결) | FP02841_RowExcelPopup.cs:722 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP02841_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e150654 | FindButton | FP02841_RowExcelPopup.cs:308 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e106505f | FindButton | FP02841_RowExcelPopup.cs:309 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b806858d | FindButton | FP02841_RowExcelPopup.cs:311 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP02841_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb628b2b | this.Load 외 2 | FP02841_RowExcelPopup.cs:350 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b19cbbdb | this.Load 외 2 | FP02841_RowExcelPopup.cs:351 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-bf33ea6d | this.Load 외 2 | FP02841_RowExcelPopup.cs:351 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2220ecf1 | this.Load 외 2 | FP02841_RowExcelPopup.cs:355 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-eb08f0fc | this.Load 외 2 | FP02841_RowExcelPopup.cs:356 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ef07f8d0 | this.Load 외 2 | FP02841_RowExcelPopup.cs:358 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dca67c67 | this.Load 외 2 | FP02841_RowExcelPopup.cs:359 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-479f368f | this.Load 외 2 | FP02841_RowExcelPopup.cs:360 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5d30bfd7 | this.Load 외 2 | FP02841_RowExcelPopup.cs:361 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-38486211 | this.Load 외 2 | FP02841_RowExcelPopup.cs:362 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8633120c | this.Load 외 2 | FP02841_RowExcelPopup.cs:363 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-78bbd29e | this.Load 외 2 | FP02841_RowExcelPopup.cs:370 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39bec3ae | this.Load 외 2 | FP02841_RowExcelPopup.cs:375 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-bc059d55 | this.Load 외 2 | FP02841_RowExcelPopup.cs:377 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-552c114c | this.Load 외 2 | FP02841_RowExcelPopup.cs:378 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-c5a3362d | this.Load 외 2 | FP02841_RowExcelPopup.cs:379 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-9a7230e7 | this.Load 외 2 | FP02841_RowExcelPopup.cs:381 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaaf27be | this.Load 외 2 | FP02841_RowExcelPopup.cs:383 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f828456 | this.Load 외 2 | FP02841_RowExcelPopup.cs:384 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = true; //if (init) //{ // //DictColumn = siMain.… | ⚠ 의미 확인 필요 |  |  |  |
| AC-495a1dba | this.Load 외 2 | FP02841_RowExcelPopup.cs:405 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-ed34106c | this.Load 외 2 | FP02841_RowExcelPopup.cs:405 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK) | 그리드 재구성/초기화 |  |  |  |
| AC-693c0a34 | this.Load 외 2 | FP02841_RowExcelPopup.cs:411 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-84cde8e9 | this.Load 외 2 | FP02841_RowExcelPopup.cs:412 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-4cda43cc | this.Load 외 2 | FP02841_RowExcelPopup.cs:413 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-dd0d76d6 | this.Load 외 2 | FP02841_RowExcelPopup.cs:417 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-05cbec76 | this.Load 외 2 | FP02841_RowExcelPopup.cs:420 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-074daa57 | this.Load 외 2 | FP02841_RowExcelPopup.cs:421 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-81176b94 | this.Load 외 2 | FP02841_RowExcelPopup.cs:430 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c846c005 | this.Load 외 2 | FP02841_RowExcelPopup.cs:433 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-15fd9122 | this.Load 외 2 | FP02841_RowExcelPopup.cs:434 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a8ce6252 | this.Load 외 2 | FP02841_RowExcelPopup.cs:435 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-862430aa | this.Load 외 2 | FP02841_RowExcelPopup.cs:436 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-096a2346 | this.Load 외 2 | FP02841_RowExcelPopup.cs:437 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-30fb8bab | this.Load 외 2 | FP02841_RowExcelPopup.cs:438 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02841_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bedfa87 | this.Load | FP02841_RowExcelPopup.cs:150 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e0ffa80 | this.Load | FP02841_RowExcelPopup.cs:152 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02841_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc7f6d04 | (진입점 미연결) | FP02841_RowExcelPopup.cs:696 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-c0a07c28 | (진입점 미연결) | FP02841_RowExcelPopup.cs:697 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-e32d89a2 | (진입점 미연결) | FP02841_RowExcelPopup.cs:698 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-99369118 | (진입점 미연결) | FP02841_RowExcelPopup.cs:699 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-3f7a820e | (진입점 미연결) | FP02841_RowExcelPopup.cs:700 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-37382e01 | (진입점 미연결) | FP02841_RowExcelPopup.cs:701 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-d4077239 | (진입점 미연결) | FP02841_RowExcelPopup.cs:702 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2d51a764 | (진입점 미연결) | FP02841_RowExcelPopup.cs:704 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-47f63a9c | (진입점 미연결) | FP02841_RowExcelPopup.cs:705 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-99709378 | (진입점 미연결) | FP02841_RowExcelPopup.cs:709 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ddab0ddd | (진입점 미연결) | FP02841_RowExcelPopup.cs:710 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP02841_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b773b2cc | this.Load | FP02841_RowExcelPopup.cs:195 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-ea073481 | this.Load | FP02841_RowExcelPopup.cs:196 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-d95c0a80 | this.Load | FP02841_RowExcelPopup.cs:200 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-f053f66a | this.Load | FP02841_RowExcelPopup.cs:201 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-614b27bf | this.Load | FP02841_RowExcelPopup.cs:204 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-344a80d3 | this.Load | FP02841_RowExcelPopup.cs:205 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b9cb4a43 | this.Load | FP02841_RowExcelPopup.cs:207 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP02841_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-029b1aaa | this.Load | FP02841_RowExcelPopup.cs:278 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-092b0950 | this.Load | FP02841_RowExcelPopup.cs:279 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c808e5db | (진입점 미연결) | FP02841_RowExcelPopup.cs:299 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02841_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-360b11f5 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:730 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-99de2cda | this.btnUpload.Click | FP02841_RowExcelPopup.cs:730 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-111d08cd | this.btnUpload.Click | FP02841_RowExcelPopup.cs:732 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7e25e0d1 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:733 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-db148833 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:734 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e6cde13 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:736 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e954c8aa | this.btnUpload.Click | FP02841_RowExcelPopup.cs:738 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f17118e1 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:739 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba39c5d6 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:739 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-06476894 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:746 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6e16ef55 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:747 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-bd763bf1 | this.btnUpload.Click | FP02841_RowExcelPopup.cs:749 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02841_RowExcelPopup.rdoMpp_CheckedChanged

진입점: this.rdoWpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01f6452c | this.rdoWpp.CheckedChanged | FP02841_RowExcelPopup.cs:833 | if (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-4173210d | this.rdoWpp.CheckedChanged | FP02841_RowExcelPopup.cs:835 | else of (rdoMpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP02841_RowExcelPopup.rdoWpp_CheckedChanged

진입점: this.rdoMpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fa5ed27 | this.rdoMpp.CheckedChanged | FP02841_RowExcelPopup.cs:842 | if (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-eb5c7d32 | this.rdoMpp.CheckedChanged | FP02841_RowExcelPopup.cs:844 | else of (rdoWpp.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP02841_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6edd13a | this.btnSave.Click | FP02841_RowExcelPopup.cs:450 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-22e3f5e4 | this.btnSave.Click | FP02841_RowExcelPopup.cs:451 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1bfafcd | this.btnSave.Click | FP02841_RowExcelPopup.cs:455 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-44f17e64 | this.btnSave.Click | FP02841_RowExcelPopup.cs:456 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f42230ff | this.btnSave.Click | FP02841_RowExcelPopup.cs:460 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-44d7e0c0 | this.btnSave.Click | FP02841_RowExcelPopup.cs:460 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2881a97a | this.btnSave.Click | FP02841_RowExcelPopup.cs:465 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4afdaa08 | this.btnSave.Click | FP02841_RowExcelPopup.cs:466 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-57f5adbb | this.btnSave.Click | FP02841_RowExcelPopup.cs:467 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9ef76349 | this.btnSave.Click | FP02841_RowExcelPopup.cs:468 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f522c625 | this.btnSave.Click | FP02841_RowExcelPopup.cs:469 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4ea282a1 | this.btnSave.Click | FP02841_RowExcelPopup.cs:470 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dc96a24c | this.btnSave.Click | FP02841_RowExcelPopup.cs:478 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-634ef701 | this.btnSave.Click | FP02841_RowExcelPopup.cs:481 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4fd03c2 | this.btnSave.Click | FP02841_RowExcelPopup.cs:483 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6c0dee5 | this.btnSave.Click | FP02841_RowExcelPopup.cs:486 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-b68ac579 | this.btnSave.Click | FP02841_RowExcelPopup.cs:491 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-99d06cb0 | this.btnSave.Click | FP02841_RowExcelPopup.cs:492 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-047233a4 | this.btnSave.Click | FP02841_RowExcelPopup.cs:499 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-18fda09c | this.btnSave.Click | FP02841_RowExcelPopup.cs:500 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ffffa0bc | this.btnSave.Click | FP02841_RowExcelPopup.cs:501 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-059d8308 | this.btnSave.Click | FP02841_RowExcelPopup.cs:502 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1351b843 | this.btnSave.Click | FP02841_RowExcelPopup.cs:503 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-215ebb45 | this.btnSave.Click | FP02841_RowExcelPopup.cs:504 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-467920e5 | this.btnSave.Click | FP02841_RowExcelPopup.cs:505 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-060f3653 | this.btnSave.Click | FP02841_RowExcelPopup.cs:506 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34dcc963 | this.btnSave.Click | FP02841_RowExcelPopup.cs:513 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-977c424e | this.btnSave.Click | FP02841_RowExcelPopup.cs:547 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ea9800d | this.btnSave.Click | FP02841_RowExcelPopup.cs:549 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-88a3617d | this.btnSave.Click | FP02841_RowExcelPopup.cs:552 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | dr["NEW_SEQ"] | validation.Tables[0].Rows[0]["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-b99a1a45 | this.btnSave.Click | FP02841_RowExcelPopup.cs:556 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c36fc568 | this.btnSave.Click | FP02841_RowExcelPopup.cs:558 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c9444bd | this.btnSave.Click | FP02841_RowExcelPopup.cs:561 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-331ab207 | this.btnSave.Click | FP02841_RowExcelPopup.cs:565 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72f95d53 | this.btnSave.Click | FP02841_RowExcelPopup.cs:567 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2d2b860 | this.btnSave.Click | FP02841_RowExcelPopup.cs:570 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba22651b | this.btnSave.Click | FP02841_RowExcelPopup.cs:574 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d806b12 | this.btnSave.Click | FP02841_RowExcelPopup.cs:586 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4fa7641b | this.btnSave.Click | FP02841_RowExcelPopup.cs:588 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT_CNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-40e2d9a6 | this.btnSave.Click | FP02841_RowExcelPopup.cs:590 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT_EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-2543d9d3 | this.btnSave.Click | FP02841_RowExcelPopup.cs:594 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-22155794 | this.btnSave.Click | FP02841_RowExcelPopup.cs:609 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-c5b8a402 | this.btnSave.Click | FP02841_RowExcelPopup.cs:610 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-668007dd | this.btnSave.Click | FP02841_RowExcelPopup.cs:614 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("{0} data Saved", result_count)) | 메시지 표시 |  |  |  |
| AC-922e20aa | this.btnSave.Click | FP02841_RowExcelPopup.cs:615 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3dd6fb8 | this.btnSave.Click | FP02841_RowExcelPopup.cs:620 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-16c81aa0 | this.btnSave.Click | FP02841_RowExcelPopup.cs:659 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-16c5a571 | this.btnSave.Click | FP02841_RowExcelPopup.cs:661 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afb23b08 | this.btnSave.Click | FP02841_RowExcelPopup.cs:662 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a9b40c85 | this.btnSave.Click | FP02841_RowExcelPopup.cs:673 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6777351a | this.btnSave.Click | FP02841_RowExcelPopup.cs:678 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3c3068d4 | this.btnSave.Click | FP02841_RowExcelPopup.cs:679 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fdd510a7 | this.btnSave.Click | FP02841_RowExcelPopup.cs:680 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2d3cfcd8 | this.btnSave.Click | FP02841_RowExcelPopup.cs:681 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-032d7341 | this.btnSave.Click | FP02841_RowExcelPopup.cs:682 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3cc9882f | this.btnSave.Click | FP02841_RowExcelPopup.cs:683 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP02841_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2afdf9e | this.Load | FP02841_RowExcelPopup.cs:291 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f7165d9 | this.Load | FP02841_RowExcelPopup.cs:292 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02841_RowExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6260ebe6 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_RowExcelPopup.cs:246 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-41f3ce3e | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_RowExcelPopup.cs:247 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-57d04c30 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_RowExcelPopup.cs:248 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0f732e57 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_RowExcelPopup.cs:252 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fb0ad7ea | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_RowExcelPopup.cs:253 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a4681c63 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP02841_RowExcelPopup.cs:254 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

