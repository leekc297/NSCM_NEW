# AS-IS 액션 대조표 — FP00641

> 원천: `Doc/asisfacts/screens/FP00641/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2021행 · 메서드 163 · 종류 DATA_OP 963 · RETURN 238 · FLAG 136 · UI_PROP 110 · VALUE_SET 103 · CALL_EXT 80 · GRID_SET 76 · COMBO_DATA 64 · UI_MISC 50 · ENDPOINT 45 · MESSAGE 35 · POPUP 30 · GRID_INIT 23 · LIST_REBIND 13 · CALL_BASE 11 · STATE 9 · GRID_LOCK 9 · VALUE_CLEAR 6 · THROW 6 · STATE_RESET 5 · FOCUS 3 · EXCEL 2 · LIST_BIND 2 · GRID_STYLE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 91


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edf8eb9c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9908 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3928c539 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9914 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-7f474f40 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9929 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-980c3bd6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9930 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-2959abec | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9931 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-237645fe | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9932 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-fd97bd81 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9933 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b96ec62a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9934 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-aa09d037 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9935 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-e698fc32 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9936 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-3b6285cb | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9939 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-9943357a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10224 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a623a00 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10225 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-3eb39e48 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10226 |  | DATA_OP | material_column.ContainsKey | ("P_IN_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9ad5875 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10227 | if (material_column.ContainsKey("P_IN_CELL")) | UI_PROP | dlLine._P_IN_CELL | material_column["P_IN_CELL"] | 속성 _P_IN_CELL 설정 |  |  |  |
| AC-741d212e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10228 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-55d7f404 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10229 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-0f0740bc | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10230 |  | DATA_OP | material_column.ContainsKey | ("P_OUT_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-5311711a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10231 | if (material_column.ContainsKey("P_OUT_CELL")) | UI_PROP | dlLine._P_OUT_CELL | material_column["P_OUT_CELL"] | 속성 _P_OUT_CELL 설정 |  |  |  |
| AC-325c357f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10233 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.DO_INC_P_RESULT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-710bfc30 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10328 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Do_SET_P_OUT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a140efe5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10332 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f7251f0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10044 | if (amend_calendar == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-79c280c7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10063 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-296ea6a5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10064 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d33423f4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10065 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ccef659a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10066 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-82b7c3ad | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10073 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0669d4b2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10074 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c29a0491 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10061 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-2399442d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10111 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "FORM_P_REMAINED": | UI_PROP | loc.FORM_P_REMAINED | row_index | 속성 FORM_P_REMAINED 설정 |  |  |  |
| AC-b14cc649 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10114 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "FORM_P_YIELD": | UI_PROP | loc.FORM_P_YIELD | row_index | 속성 FORM_P_YIELD 설정 |  |  |  |
| AC-847d6eec | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10120 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "FORM_P_OUT": | UI_PROP | loc.FORM_P_OUT | row_index | 속성 FORM_P_OUT 설정 |  |  |  |
| AC-0f2f7622 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10123 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "PACK_I_SCP": | UI_PROP | loc.PACK_I_SCP | row_index | 속성 PACK_I_SCP 설정 |  |  |  |
| AC-aa775541 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10126 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "PACK_I_SHIPPING": | UI_PROP | loc.PACK_I_SHIPPING | row_index | 속성 PACK_I_SHIPPING 설정 |  |  |  |
| AC-549fa916 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10129 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "PACK_P_YIELD": | UI_PROP | loc.PACK_P_YIELD | row_index | 속성 PACK_P_YIELD 설정 |  |  |  |
| AC-3eb537a5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10135 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "PACK_P_OUT": | UI_PROP | loc.PACK_P_OUT | row_index | 속성 PACK_P_OUT 설정 |  |  |  |
| AC-810d6ff3 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10138 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "PACK_S_SCP": | UI_PROP | loc.PACK_S_SCP | row_index | 속성 PACK_S_SCP 설정 |  |  |  |
| AC-bbfa307e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10141 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "PACK_S_SHIPPING": | UI_PROP | loc.PACK_S_SHIPPING | row_index | 속성 PACK_S_SHIPPING 설정 |  |  |  |
| AC-bb87a0c6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10186 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-9abf35ea | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10188 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c356b58 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10034 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0824c8d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9979 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-46564b03 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9980 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-33dce3a4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9981 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-938b4449 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9982 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6c91c65 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9989 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-be9674c5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9990 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a9c1b24 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9977 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-efc0954f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10013 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (uom == "CELL") | DATA_OP | dict.ContainsKey | (category_id + "_" + uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-47def1ee | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10014 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (uom == "CELL") ▸ if (!dict.ContainsKey(category_id + "_" + u… | DATA_OP | dict.Add | (category_id + "_" + uom, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-987bac43 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10018 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ else of (uom == "CELL") | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-a170da4c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10019 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ else of (uom == "CELL") ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-5461bec2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:10025 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3baa47f1 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9952 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49bf377c | .ctor | FP00641_Cell_Simulation_Cell_Pack.cs:165 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATION_CELL_PACK") ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-579bd953 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3970 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-65ab00b1 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3971 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-42c67d62 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3972 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6d8bc5f1 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3973 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-31502a52 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3974 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5ef806ae | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3975 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-2cdc6078 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3975 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9c69fffb | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3976 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-e7ef2c2b | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3976 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-094d6458 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3977 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-883f217f | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3977 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d9774244 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3978 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-758760d4 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3978 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b0a77ba | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3989 |  | UI_PROP | measure.ForceTrue | true | 속성 ForceTrue 설정 |  |  |  |
| AC-c1dd0872 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3991 |  | UI_PROP | measure.ForceTrue | false | 속성 ForceTrue 설정 |  |  |  |
| AC-73a04bc7 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3993 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-5e713063 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3994 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-0245952c | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3995 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.btnCatagory_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-148cefb8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11287 |  | FLAG | measure | MeasureService.GetMeasure("FP00641_Main") | 화면 필드/플래그 변경 |  |  |  |
| AC-e5b61ff0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11287 |  | COMBO_DATA | MeasureService.GetMeasure | ("FP00641_Main") | Measure 목록 조회 |  |  |  |
| AC-77dbefa0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11288 |  | POPUP | new FP00641_MeasureSetForm_Popup | ("FP00641", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-73e4972a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11289 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-73159d05 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11290 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-92b904f2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11291 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1a31f050 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11296 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-0235df18 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11297 | if (frm.DialogResult == DialogResult.OK) | CALL_BASE | SetCategoryFilter | ("CATEGORY_NAME", "FP00641_Main", measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2addfc2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11307 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d3090f0e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11316 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aca9fcf2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11325 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.btnCategory_Click

진입점: this.btnCategory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94eb95b0 | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11621 |  | FLAG | measure | MeasureService.GetMeasure("FP00641_Main") | 화면 필드/플래그 변경 |  |  |  |
| AC-011fdcd7 | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11621 |  | COMBO_DATA | MeasureService.GetMeasure | ("FP00641_Main") | Measure 목록 조회 |  |  |  |
| AC-34597df6 | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11622 |  | POPUP | new FP00641_MeasureSetForm_Popup | ("FP00641", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-fe523ebd | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11624 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-ca5350f4 | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11626 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2eabefdf | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11627 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8fb98149 | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11631 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a7737ff2 | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11632 | if (frm.DialogResult == DialogResult.OK) | CALL_BASE | SetCategoryFilter | ("CATEGORY_NAME", "FP00611_Main", measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad0ad698 | this.btnCategory.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11641 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-665dda32 | this.btn_column.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11139 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00641", SpdSheet.shtPlanAmendMA, true, "") | 팝업/폼 생성 |  |  |  |
| AC-a4efb4ab | this.btn_column.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11140 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0199cac1 | this.btn_column.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11141 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c510e91d | this.btn_column.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11158 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ef8e35e | this.btnSql.Click | FP00641_Cell_Simulation_Cell_Pack.cs:2635 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7d7f1c0c | this.btnSql.Click | FP00641_Cell_Simulation_Cell_Pack.cs:2636 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b4a4ac4d | this.btnSql.Click | FP00641_Cell_Simulation_Cell_Pack.cs:2638 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00641_CELL_SIMULATION_CELL_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d7c4537 | this.btnSql.Click | FP00641_Cell_Simulation_Cell_Pack.cs:2639 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fffa2149 | this.btnToggleSave.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11362 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd409428 | this.button1.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11969 | if (flo2 != null) | VALUE_SET | chk_pack_plan_info.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-40574915 | this.button1.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11970 | if (flo2 != null) | VALUE_SET | chk_form_plan_info.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-f139b87f | this.button1.Click | FP00641_Cell_Simulation_Cell_Pack.cs:11971 | if (flo2 != null) | VALUE_SET | chk_cell_plan_info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.call_Excel_Col_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8d970a2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4575 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.call_Excel_Col_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbab106e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4215 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.call_Excel_Col_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16079e95 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4210 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.call_Excel_Col_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-375a6c23 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4569 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65969990 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4753 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61d4c382 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4620 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-051ec9f7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4829 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.cbo_cell_plan_id_changed

진입점: cbo_cell_plan_id.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72fbfe9b | cbo_cell_plan_id.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10737 |  | DATA_OP | Filter["ASSY_PLAN_ID"] | CString.GetCheckedListValue(dtPlan_cell, cbo_cell_plan_id.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.cbo_form_plan_id_changed

진입점: cbo_form_plan_id.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14f9ed05 | cbo_form_plan_id.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10733 |  | DATA_OP | Filter["FORM_PLAN_ID"] | CString.GetCheckedListValue(dtPlan_form, cbo_form_plan_id.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.cbo_pack_plan_group_changed

진입점: this.Load / cbo_site.SelectedIndexChanged / cbo_pack_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a88736ac | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10662 | if (pack_index >= 0) ▸ if (cbo_form_plan_group.Items.Count > 0) | VALUE_SET | cbo_form_plan_group.SelectedIndex | pack_index | 컨트롤 값 설정 |  |  |  |
| AC-7add6951 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10664 | if (pack_index >= 0) ▸ if (cbo_cell_plan_group.Items.Count > 0) | VALUE_SET | cbo_cell_plan_group.SelectedIndex | pack_index | 컨트롤 값 설정 |  |  |  |
| AC-5e7c9f18 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10668 |  | DATA_OP | Filter["PLAN_DATE"] | date_instance.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.cbo_pack_plan_id_changed

진입점: cbo_pack_plan_id.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d82fc794 | cbo_pack_plan_id.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10728 |  | DATA_OP | Filter["PACK_PLAN_ID"] | CString.GetCheckedListValue(dtPlan_pack, cbo_pack_plan_id.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.cbo_site_changed

진입점: cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b4d538c | cbo_site.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10851 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-55144364 | cbo_site.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10855 |  | VALUE_CLEAR | cbo_pack_plan_id.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-491cfc81 | cbo_site.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10856 |  | VALUE_CLEAR | cbo_form_plan_id.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-e2ad1381 | cbo_site.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10857 |  | VALUE_CLEAR | cbo_cell_plan_id.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9132b210 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:844 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d0b987e | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:844 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-e8fcf5b4 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:846 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00641_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d646edb8 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:846 |  | POPUP | new FP00641_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.chk_changed

진입점: chk_form_plan_group.CheckedChanged / chk_pack_plan_group.CheckedChanged / chk_cell_plan_group.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14570b26 | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10929 | if (chkBox == chk_form_plan_group) ▸ if (chkBox.Checked == true) | STATE | cbo_form_plan_id.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e06c19a1 | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10930 | if (chkBox == chk_form_plan_group) ▸ else of (chkBox.Checked == true) | STATE | cbo_form_plan_id.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-160a215b | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10936 | else of (chkBox == chk_form_plan_group) ▸ if (chkBox == chk_cell_plan_group) ▸ if (chkBox.Checked == true) | STATE | cbo_cell_plan_id.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6493674e | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10938 | else of (chkBox == chk_form_plan_group) ▸ if (chkBox == chk_cell_plan_group) ▸ else of (chkBox.Checked == true) | STATE | cbo_cell_plan_id.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-764876f7 | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10942 | else of (chkBox == chk_form_plan_group) ▸ else of (chkBox == chk_cell_plan_group) ▸ if (chkBox == chk_pack_plan_group) ▸ if (chkBox.Checked … | STATE | cbo_pack_plan_id.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f28814ab | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10943 | else of (chkBox == chk_form_plan_group) ▸ else of (chkBox == chk_cell_plan_group) ▸ if (chkBox == chk_pack_plan_group) ▸ else of (chkBox.Che… | STATE | cbo_pack_plan_id.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-42ec3716 | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10947 |  | DATA_OP | Filter["IS_REL_PACK"] | Filter["IS_REL_FORM"] = Filter["IS_REL_ASSY"] = "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d03bf953 | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10947 |  | DATA_OP | Filter["IS_REL_FORM"] | Filter["IS_REL_ASSY"] = "N" | 행/컬럼 값 대입 |  |  |  |
| AC-5ddb4bd6 | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10947 |  | DATA_OP | Filter["IS_REL_ASSY"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-c0c3b93c | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10950 | if (chk_pack_plan_group.Checked) | DATA_OP | Filter["IS_REL_PACK"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-11744ca3 | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10952 | if (chk_cell_plan_group.Checked) | DATA_OP | Filter["IS_REL_ASSY"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-6ffe57ed | chk_form_plan_group.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10954 | if (chk_form_plan_group.Checked) | DATA_OP | Filter["IS_REL_FORM"] | "Y" | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.chk_info_changed

진입점: chk_pack_plan_info.CheckedChanged / chk_form_plan_info.CheckedChanged / chk_cell_plan_info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74352de3 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10965 | if (chk_pack_plan_info.Checked) | DATA_OP | Filter["INSTANCE_ID"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-27688fc5 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10966 | if (chk_pack_plan_info.Checked) | DATA_OP | Filter["PLAN_ID"] | Filter["PACK_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-036b58db | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10967 | if (chk_pack_plan_info.Checked) | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-fc41c5bc | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10967 | if (chk_pack_plan_info.Checked) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c30e8c7f | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10977 | if (chk_pack_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-ccdde93b | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10978 | if (chk_pack_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-60947473 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10979 | if (chk_pack_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-f9d537f5 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10980 | if (chk_pack_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-c584b399 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10981 | if (chk_pack_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-ce5bcee8 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10982 | if (chk_pack_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-49efa01c | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10985 | if (chk_pack_plan_info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_pack_plan_info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-31b07c22 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10985 | if (chk_pack_plan_info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_pack_plan_info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dac8daba | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10989 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) | DATA_OP | Filter["INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-af9462aa | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10990 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) | DATA_OP | Filter["PLAN_ID"] | Filter["FORM_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0cb54325 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10991 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-405c24c5 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10991 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d62ade00 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11001 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-033c8e61 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11002 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-631c2300 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11003 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-2485c77c | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11004 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-90bbe221 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11005 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-d6d20525 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11006 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-51f6ccfc | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11009 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_form_plan_info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c3ef645 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11009 | else of (chk_pack_plan_info.Checked) ▸ if (chk_form_plan_info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_form_plan_info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5257304f | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11013 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) | DATA_OP | Filter["INSTANCE_ID"] | Filter["ASSY_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0d89b32c | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11014 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) | DATA_OP | Filter["PLAN_ID"] | Filter["ASSY_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b16a6c35 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11015 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9c0656e | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11015 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-03764351 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11025 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-73977524 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11026 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-98d65fa1 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11027 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-f3ee2eb2 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11028 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-ca281511 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11029 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-aff48482 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11030 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) ▸ if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-feed91d7 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11033 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_cell_plan_info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb5a8f95 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11033 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ if (chk_cell_plan_info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_cell_plan_info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-879f95e8 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11039 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ else of (chk_cell_plan_info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-3cfbd007 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11040 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ else of (chk_cell_plan_info.Checked) ▸ if (flo2 != null) ▸ if … | FOCUS | chk_pack_plan_info.Focus | () | 포커스 이동 |  |  |  |
| AC-0796971e | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11041 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ else of (chk_cell_plan_info.Checked) ▸ if (flo2 != null) ▸ if … | FOCUS | chk_form_plan_info.Focus | () | 포커스 이동 |  |  |  |
| AC-ae592202 | chk_pack_plan_info.CheckedChanged 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:11042 | else of (chk_pack_plan_info.Checked) ▸ else of (chk_form_plan_info.Checked) ▸ else of (chk_cell_plan_info.Checked) ▸ if (flo2 != null) ▸ if … | FOCUS | chk_cell_plan_info.Focus | () | 포커스 이동 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.chk_input_mode_changed

진입점: chk_input_mode.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f184de09 | chk_input_mode.CheckedChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11052 | if (chk_input_mode.Checked) | DATA_OP | Filter["IS_INPUT_MODE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-ce409393 | chk_input_mode.CheckedChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11054 | else of (chk_input_mode.Checked) | DATA_OP | Filter["IS_INPUT_MODE"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.CreateEditDataGridDataSet

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sInputMode.Equals("N")) ▸ if (dgEditDataTable == null)] / SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90b1977e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10434 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-f617f15d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10438 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f0f02a6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10439 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b332957b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10440 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f13dc53b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10441 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-256d7c8b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10442 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3a58b1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10443 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-77387e15 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10444 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-20515475 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10445 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0eff40fd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10446 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-784db99a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10447 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d89e214 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10448 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-134cdde1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10449 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1597eaa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10450 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae34181 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10451 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a31e6ab5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10452 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d6f46c8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10453 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8638353e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10454 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d23279be | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10455 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e596300 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10456 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbaec19b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10457 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8848bdfa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10458 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-92eab2a6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10460 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ebf79a1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10461 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-72142202 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10462 | switch (edit_type) case "PACK_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfb5794b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10465 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2107c4eb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10466 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f488550 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10467 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea5ca6f1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10468 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-909f7665 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10469 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fc48238 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10470 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-00af55a8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10471 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5558c705 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10472 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-899f9b41 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10473 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7355d82e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10474 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-972323ce | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10475 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-39d2b77f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10476 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-723c1935 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10477 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-031156fa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10478 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-745d5616 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10479 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d26affdd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10480 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-262b7744 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10481 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-326a9e6e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10482 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d9e1f24 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10483 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fc1aa8d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10484 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-df2d6d49 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10485 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a452c74f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10486 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-af5f5626 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10488 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c856fce | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10489 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-50cf2db2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10490 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-43d78d5f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10491 | switch (edit_type) case "PACK_S_SHIPPING_SIM": | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7853134f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10494 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca6ec7ff | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10495 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a080000e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10496 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-234fe7e0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10497 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d60c69ed | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10498 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcde67b5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10499 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f480476 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10500 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-95c10ab4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10501 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-559e3f12 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10502 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6dfb84de | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10503 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4086fde | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10504 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-017faa7c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10505 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b88541c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10506 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d4ccb8d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10507 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-945c4b71 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10508 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bba93b7d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10509 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-02c852e5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10510 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-416f86a2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10511 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5c14905 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10512 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("CUSTOMER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-76281f86 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10513 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8875a38 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10514 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc229b36 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10515 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1adab77f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10517 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-82da6261 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10518 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-00bf65d0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10519 | switch (edit_type) case "FORM_P_OUT": | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e13fdcc | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10522 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7de6fcd6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10523 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-00d8dfec | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10524 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-77d98ed5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10525 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4affa44 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10526 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-042f4bff | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10527 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4114706 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10528 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb7c86ef | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10529 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3357327c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10530 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-661a680b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10531 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1dff213 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10532 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-04a413c6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10533 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2263dca6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10534 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-85ef2679 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10535 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebadf77a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10536 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-829de941 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10537 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-203d99b0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10538 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ffc30bc | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10539 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-90ba1a31 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10540 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-73197fa5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10541 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-63f658a0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10542 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee69a3ad | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10543 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("VERSION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-45f3146b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10544 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("PLM_EC_NO", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-808dbce9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10546 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-72d71cad | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10547 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-40c5ac4d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10548 | switch (edit_type) case "CELL_P_OUT_CELL": | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8fee689 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:10552 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c855ab6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:2689 |  | DATA_OP | dsResult.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-12587be4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:2689 |  | RETURN | return dsResult.Copy(); |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a94f548e | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:802 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c0bc4b7d | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:803 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-b459c289 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:804 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c1e80b5 | DeleteButton | FP00641_Cell_Simulation_Cell_Pack.cs:1300 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78f1a6eb | Dispose | FP00641_Cell_Simulation_Cell_Pack.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df408e55 | EditButton | FP00641_Cell_Simulation_Cell_Pack.cs:1308 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-ec5db0db | EditButton | FP00641_Cell_Simulation_Cell_Pack.cs:1310 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9b8cdd7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00641_Cell_Simulation_Cell_Pack.cs:5117 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e213039 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00641_Cell_Simulation_Cell_Pack.cs:5118 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-f689f4e8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00641_Cell_Simulation_Cell_Pack.cs:5119 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-fc513495 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00641_Cell_Simulation_Cell_Pack.cs:5121 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee0db744 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00641_Cell_Simulation_Cell_Pack.cs:5133 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-4e1075a3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00641_Cell_Simulation_Cell_Pack.cs:5134 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-695ec272 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5175 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db30f4f2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5176 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9d8332b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5177 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-a277b88b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5179 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f590c25a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5187 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-f8c1c2bf | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5188 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-687251dc | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5193 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.EditByFunc

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53979d9a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5144 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16de9a94 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5146 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-a63cbc87 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5147 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-b99d6649 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5149 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30cc042b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5159 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-771dbfe2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5165 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-249b7395 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5167 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54b2bcfe | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00641_Cell_Simulation_Cell_Pack.cs:3257 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00487346 | ExcelButton | FP00641_Cell_Simulation_Cell_Pack.cs:3228 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e8f04147 | ExcelButton | FP00641_Cell_Simulation_Cell_Pack.cs:3229 |  | VALUE_SET | select_popup.Text | "SELECT EXCEL TYPE" | 컨트롤 값 설정 |  |  |  |
| AC-05f1630a | ExcelButton | FP00641_Cell_Simulation_Cell_Pack.cs:3230 |  | CALL_EXT | select_popup.SetOption | (0, "Cascaded Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bdcf818c | ExcelButton | FP00641_Cell_Simulation_Cell_Pack.cs:3231 |  | CALL_EXT | select_popup.SetOption | (1, "Seperated Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c691888 | ExcelButton | FP00641_Cell_Simulation_Cell_Pack.cs:3232 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-404038f0 | ExcelButton | FP00641_Cell_Simulation_Cell_Pack.cs:3239 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | base.ExcelOption | ExcelExportOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |
| AC-deef62a3 | ExcelButton | FP00641_Cell_Simulation_Cell_Pack.cs:3245 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Exec_Procedure

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_result) ▸ try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3764ca8b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2579 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-91ff40c1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2580 | try | UI_PROP | req.CommandTimeout | 3 * 160 | 속성 CommandTimeout 설정 |  |  |  |
| AC-87a6af55 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2582 | try | DATA_OP | req.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-2c47b4a5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2583 | try | DATA_OP | req.Parameters["p_sys_flag"] | pSysFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c60a0dd3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2584 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce5da983 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2585 | try | DATA_OP | req.Parameters["p_user_id"] | user_id | 행/컬럼 값 대입 |  |  |  |
| AC-84e76ae2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2586 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-04e8ca64 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2587 | try | DATA_OP | req.Parameters["p_plan_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-40f66437 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2588 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-a58f1d37 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2589 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c18791b1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2590 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e7bc6f27 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2591 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bf4569a1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2592 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3c0cce44 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2593 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7689c8b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2594 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c18e37cb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2595 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f187d53 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2596 | try | DATA_OP | req.Parameters["p_plan_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1d635fb3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2597 | try | DATA_OP | req.Parameters["p_prod_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3c0720c6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2598 | try | DATA_OP | req.Parameters["p_top_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5aea787 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2599 | try | DATA_OP | req.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5536963e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2600 | try | DATA_OP | req.Parameters["p_item_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be1cbeee | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2601 | try | DATA_OP | req.Parameters["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f3c2c01 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2602 | try | DATA_OP | req.Parameters["p_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-16a9e1dd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2603 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0bcbca79 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2604 | try | DATA_OP | req.Parameters["p_customer_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c81f5d5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2605 | try | DATA_OP | req.Parameters["p_cell_group"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b2b278b1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2606 | try | DATA_OP | req.Parameters["p_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-75fead25 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2607 | try | DATA_OP | req.Parameters["p_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de0308a1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2608 | try | DATA_OP | req.Parameters["p_shorter_lt_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e77d2513 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2609 | try | DATA_OP | req.Parameters["p_mpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-96b5e31e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2610 | try | DATA_OP | req.Parameters["p_wpp_out_qty"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68705139 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2612 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4d7a558a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2619 | try | RETURN | return bRtn; |  | 처리 중단/반환 |  |  |  |
| AC-3c3d92c3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2623 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.FilterValidation

진입점: popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATION_CELL_PACK")] / FindButton [try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72568506 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:354 |  | CALL_EXT | MessageService.Require | (Filter, "SITE_ID", "Site") | ⚠ 의미 확인 필요 |  |  |  |
| AC-386b1a7e | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:355 | if (!MessageService.Require(Filter, "SITE_ID", "Site")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c75804ac | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:356 |  | CALL_EXT | MessageService.Require | (Filter, "PLAN_DATE", "Instance Date") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b978ec7 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:357 | if (!MessageService.Require(Filter, "PLAN_DATE", "Instance Date")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a43970b7 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:359 |  | CALL_EXT | MessageService.Require | (Filter, "PACK_INSTANCE_ID", "Plan Group(Pack)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd10739a | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:360 | if (!MessageService.Require(Filter, "PACK_INSTANCE_ID", "Plan Group(Pack)")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-da9bd566 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:365 | if (Filter["PACK_PLAN_ID"] == "") ▸ if (Filter["IS_REL_PACK"] != "Y") | MESSAGE | MessageBox.Show | (MessageService.RequireMessage("Plan ID(Pack)")) | 메시지 표시 |  |  |  |
| AC-0dd0807b | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:365 | if (Filter["PACK_PLAN_ID"] == "") ▸ if (Filter["IS_REL_PACK"] != "Y") | CALL_EXT | MessageService.RequireMessage | ("Plan ID(Pack)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4b985b1 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:366 | if (Filter["PACK_PLAN_ID"] == "") ▸ if (Filter["IS_REL_PACK"] != "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f5ffa050 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:369 |  | CALL_EXT | MessageService.Require | (Filter, "FORM_INSTANCE_ID", "Plan Group(Form)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-57da3894 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:370 | if (!MessageService.Require(Filter, "FORM_INSTANCE_ID", "Plan Group(Form)")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6d8969a0 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:375 | if (Filter["FORM_PLAN_ID"] == "") ▸ if (Filter["IS_REL_FORM"] != "Y") | MESSAGE | MessageBox.Show | (MessageService.RequireMessage("Plan ID(Form)")) | 메시지 표시 |  |  |  |
| AC-142e8b87 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:375 | if (Filter["FORM_PLAN_ID"] == "") ▸ if (Filter["IS_REL_FORM"] != "Y") | CALL_EXT | MessageService.RequireMessage | ("Plan ID(Form)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-123b0602 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:376 | if (Filter["FORM_PLAN_ID"] == "") ▸ if (Filter["IS_REL_FORM"] != "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-654554bc | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:379 |  | CALL_EXT | MessageService.Require | (Filter, "ASSY_INSTANCE_ID", "Plan Group(Assy)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-567c9c8a | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:380 | if (!MessageService.Require(Filter, "ASSY_INSTANCE_ID", "Plan Group(Assy)")) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ad9aeb00 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:385 | if (Filter["ASSY_PLAN_ID"] == "") ▸ if (Filter["IS_REL_ASSY"] != "Y") | MESSAGE | MessageBox.Show | (MessageService.RequireMessage("Plan ID(Assy)")) | 메시지 표시 |  |  |  |
| AC-3ec74a55 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:385 | if (Filter["ASSY_PLAN_ID"] == "") ▸ if (Filter["IS_REL_ASSY"] != "Y") | CALL_EXT | MessageService.RequireMessage | ("Plan ID(Assy)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-86c72504 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:386 | if (Filter["ASSY_PLAN_ID"] == "") ▸ if (Filter["IS_REL_ASSY"] != "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-748fe242 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:391 | if (Filter["BUCKET_FROM"] == "" \|\| Filter["BUCKET_TO"] == "") | MESSAGE | MessageBox.Show | (MessageService.RequireMessage("Plan Period")) | 메시지 표시 |  |  |  |
| AC-d07c3639 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:391 | if (Filter["BUCKET_FROM"] == "" \|\| Filter["BUCKET_TO"] == "") | CALL_EXT | MessageService.RequireMessage | ("Plan Period") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2c6bf22 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:392 | if (Filter["BUCKET_FROM"] == "" \|\| Filter["BUCKET_TO"] == "") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a91097a8 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:394 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.FindFP00641

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f5c2eae | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:3692 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.FindListData

진입점: FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90ae1de3 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3842 | try | DATA_OP | Filter["PACK_AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-4bb01e4e | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3843 | try | DATA_OP | Filter["PACK_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-04302887 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3844 | try | DATA_OP | Filter["FORM_AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-3f99791d | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3845 | try | DATA_OP | Filter["CELL_AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-855c13f6 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3846 | try | DATA_OP | Filter["CELL_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-46c82583 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3851 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["TARGET_INSTANCE"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fb5ff73d | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3852 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-61ff171d | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3853 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-7ad8d70b | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3855 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_Release_Plan_list", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-778ae5cc | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3867 | try ▸ if (Filter["IS_REL_PACK"] == "Y") ▸ if (dtReleasePlanList.Good()) | DATA_OP | Filter["PACK_PLAN_LT"] | sRel | 행/컬럼 값 대입 |  |  |  |
| AC-4ed9bf7e | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3873 | try ▸ else of (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_PLAN_LT"] | "'" + Filter["PACK_PLAN_ID"] + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-b250c4f9 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3879 | try ▸ if (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["TARGET_INSTANCE"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-911cce36 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3880 | try ▸ if (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["FORM_AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-3b6d1f97 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3883 | try ▸ if (Filter["IS_REL_FORM"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_Release_Plan_list", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b9794612 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3895 | try ▸ if (Filter["IS_REL_FORM"] == "Y") ▸ if (dtReleasePlanList.Good()) | DATA_OP | Filter["FORM_PLAN_LT"] | sRel | 행/컬럼 값 대입 |  |  |  |
| AC-a7f842c3 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3901 | try ▸ else of (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["FORM_PLAN_LT"] | "'" + Filter["FORM_PLAN_ID"] + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-ff55cdf1 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3907 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["TARGET_INSTANCE"] | Filter["ASSY_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b24db5af | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3908 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["CELL_AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-ce3d7377 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3909 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["CELL_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-fbae4214 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3911 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_Release_Plan_list", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-57caf24f | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3923 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") ▸ if (dtReleasePlanList.Good()) | DATA_OP | Filter["ASSY_PLAN_LT"] | sRel | 행/컬럼 값 대입 |  |  |  |
| AC-79d8f1e4 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3929 | try ▸ else of (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["ASSY_PLAN_LT"] | "'" + Filter["ASSY_PLAN_ID"] + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-3e9ddf6e | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3933 | try | DATA_OP | Filter["PLAN_ID_SCRIPT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5fcad44c | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3948 | try | DATA_OP | Filter["PLAN_ID_SCRIPT"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-2abb65c7 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3951 | try | FLAG | ds_bom | find_BOM_RATE = DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_BO… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-7ba081d8 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3951 | try | FLAG | find_BOM_RATE | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_BOM_RATE", Filter.… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6685227 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3951 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_BOM_RATE", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5b6b8b8a | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3952 | try | FLAG | ds_yield | find_YLD_F6000 = DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_Y… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] \| FP\Planning\… | 화면 필드/플래그 변경 |  |  |  |
| AC-f3a88adb | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3952 | try | FLAG | find_YLD_F6000 | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_YLD_F6000", Filter… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] \| FP\Planning\… | 화면 필드/플래그 변경 |  |  |  |
| AC-3a9da5cd | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3952 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_YLD_F6000", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-90a97c0b | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3953 | try | FLAG | ds_agingStock | find_AGING_STOCK = DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-cd79d205 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3953 | try | FLAG | find_AGING_STOCK | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_AGING_STOCK", Filt… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-36a9c84f | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3953 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_AGING_STOCK", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8fbad4eb | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3954 | try | FLAG | ds_cellExchange | find_Cell_ExchangeValue = DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack"… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] \| FP\… | 화면 필드/플래그 변경 |  |  |  |
| AC-034dc249 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3954 | try | FLAG | find_Cell_ExchangeValue | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_Cell_ExchangeValue… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] \| FP\… | 화면 필드/플래그 변경 |  |  |  |
| AC-1d92ed66 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3954 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_Cell_ExchangeValue", Filter.Dictionary, "Plann… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c3fe2362 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3956 | try | FLAG | ds_yield_F1000 | find_yield_F1000 = DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-7c74f2ee | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3956 | try | FLAG | find_yield_F1000 | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_yield_F1000", Filt… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-e55f7cdd | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3956 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_yield_F1000", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a3aaed0f | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3958 | try | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ce6e9c01 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3964 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATION_CELL_PACK")] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b8e5655 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3705 | try | DATA_OP | Filter["CATE_INFO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-80e30991 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3707 | try | DATA_OP | Filter["PACK_AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b183ac94 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3708 | try | DATA_OP | Filter["PACK_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-db12a81e | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3709 | try | DATA_OP | Filter["FORM_AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b16edcca | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3710 | try | DATA_OP | Filter["CELL_AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-8b53f3ae | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3711 | try | DATA_OP | Filter["CELL_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-355e7253 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3716 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["TARGET_INSTANCE"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4351ef59 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3717 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-50dcd9c1 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3718 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-204c5f67 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3720 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_Release_Plan_list", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4adc9f89 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3732 | try ▸ if (Filter["IS_REL_PACK"] == "Y") ▸ if (dtReleasePlanList.Good()) | DATA_OP | Filter["PACK_PLAN_LT"] | sRel | 행/컬럼 값 대입 |  |  |  |
| AC-682f9a3e | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3734 | try ▸ if (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_CONFIRM_AREA"] | sConfirmArea | 행/컬럼 값 대입 |  |  |  |
| AC-9553c52c | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3738 | try ▸ else of (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_PLAN_LT"] | "'" + Filter["PACK_PLAN_ID"] + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-10f6a9c7 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3739 | try ▸ else of (Filter["IS_REL_PACK"] == "Y") | DATA_OP | Filter["PACK_CONFIRM_AREA"] | "NNN" | 행/컬럼 값 대입 |  |  |  |
| AC-a8ff4e7f | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3744 | try ▸ if (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["TARGET_INSTANCE"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-483f1c86 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3745 | try ▸ if (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["FORM_AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-059fc061 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3748 | try ▸ if (Filter["IS_REL_FORM"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_Release_Plan_list", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1e803481 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3760 | try ▸ if (Filter["IS_REL_FORM"] == "Y") ▸ if (dtReleasePlanList.Good()) | DATA_OP | Filter["FORM_PLAN_LT"] | sRel | 행/컬럼 값 대입 |  |  |  |
| AC-4371d713 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3762 | try ▸ if (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["FORM_CONFIRM_AREA"] | sConfirmArea | 행/컬럼 값 대입 |  |  |  |
| AC-0e64a3ce | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3766 | try ▸ else of (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["FORM_PLAN_LT"] | "'" + Filter["FORM_PLAN_ID"] + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-77a3bc4e | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3767 | try ▸ else of (Filter["IS_REL_FORM"] == "Y") | DATA_OP | Filter["FORM_CONFIRM_AREA"] | "NNN" | 행/컬럼 값 대입 |  |  |  |
| AC-ff49e73e | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3772 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["TARGET_INSTANCE"] | Filter["ASSY_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ec39484 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3773 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["CELL_AMEND_TABLE"] | "FP_AMEND_PLAN_CELL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-e2854a3a | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3774 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["CELL_AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_CELL_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-cb672d26 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3776 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_Release_Plan_list", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ce8d9464 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3788 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") ▸ if (dtReleasePlanList.Good()) | DATA_OP | Filter["ASSY_PLAN_LT"] | sRel | 행/컬럼 값 대입 |  |  |  |
| AC-129a184a | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3790 | try ▸ if (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["ASSY_CONFIRM_AREA"] | sConfirmArea | 행/컬럼 값 대입 |  |  |  |
| AC-8d1b0387 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3794 | try ▸ else of (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["ASSY_PLAN_LT"] | "'" + Filter["ASSY_PLAN_ID"] + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-eafb2d0d | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3795 | try ▸ else of (Filter["IS_REL_ASSY"] == "Y") | DATA_OP | Filter["ASSY_CONFIRM_AREA"] | "NNN" | 행/컬럼 값 대입 |  |  |  |
| AC-3c7be7f9 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3807 | try | FLAG | dsYieldChild | AmendService.FindYieldInfoChild(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-891e44ee | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3807 | try | CALL_EXT | AmendService.FindYieldInfoChild | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0ac56b0 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3808 | try | FLAG | dtAgingYield | Data_FP.CallGeneralProcedure2(("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-85be4c5e | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3808 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "AGING_YIELD") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-23d21682 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3809 | try | FLAG | dtAgingLT | Data_FP.CallGeneralProcedure2(("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-6f17a968 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3809 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00641_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "AGING_LT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-69967d9e | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3817 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00641_CELL_SIMULATION_CELL_PACK", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f9789820 | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3822 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-8fe8f6ee | popSql.OnSql [if (programID == "PR_UI_FP00641_CELL_SIMULATIO… 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3828 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.FindTotalColorStart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1b2b26f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:1068 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.FindTotalValue

진입점: FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de478207 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3678 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4523032 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:199 |  | CALL_BASE | SetDefaultFrozenColumn | ("CATEGORY_NAME", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9177bf06 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:202 |  | CALL_BASE | SetCategoryFilter | ("CATEGORY_NAME", "FP00641_Main", measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09c26e4c | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:204 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetCellDataOfCellGroup

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sInputMode.Equals("N")) ▸ if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CELL_P_OUT_CELL")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71d7bc68 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9808 | if (!dtSource.Good() \|\| click_row == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-953f8d68 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9816 | lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-26d37f5e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9817 | lambda | DATA_OP | x.Field | ("SHOP_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-769225a0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9818 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-eec5b5e1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9819 | lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9499dd9f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9820 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cc3d552 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9821 | lambda | DATA_OP | x.Field | ("PACK_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-c76d14b7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9814 | lambda | RETURN | return ( x.Field<string>("DATA_TYPE") == "DATA" && x.Field<string>("SHOP_TYPE") … |  | 처리 중단/반환 |  |  |  |
| AC-f2cc41ee | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9825 |  | RETURN | return rows; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetCurrDate

진입점: this.Load / cbo_site.SelectedIndexChanged / cbo_pack_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e4c953e | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3433 |  | FLAG | dtCurrdate | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_currdate", Filter.… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-344b2b70 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3433 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_currdate", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6c847c48 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3437 | if (dtCurrdate.Good()) | VALUE_SET | date_instance.Value | DateTime.ParseExact(date, "yyyyMMdd", enUS) | 컨트롤 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetDataOfCellGroup

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sInputMode.Equals("N"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88705f55 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9744 | if (!dtSource.Good() \|\| click_row == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e7b63eab | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9752 | lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d89608b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9753 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f0ef716e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9750 | lambda | RETURN | return ( x.Field<string>("DATA_TYPE") == "DATA" && x.Field<string>("CELL_GROUP_C… |  | 처리 중단/반환 |  |  |  |
| AC-d6da6f85 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9757 |  | RETURN | return rows; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetFilter

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_result) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30d35dfd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:3327 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetFormDataOfCellGroup

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sInputMode.Equals("N")) ▸ if (true) ▸ if (sCate == "PACK_P_OUT")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c472c6b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9785 | if (!dtSource.Good() \|\| click_row == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6bf3a0d4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9793 | lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9cce5ee1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9794 | lambda | DATA_OP | x.Field | ("SHOP_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-94c53331 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9795 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1842d90 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9797 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-408ede8c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9791 | lambda | RETURN | return ( x.Field<string>("DATA_TYPE") == "DATA" && x.Field<string>("SHOP_TYPE") … |  | 처리 중단/반환 |  |  |  |
| AC-4ff8404a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9802 |  | RETURN | return rows; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetInstance

진입점: this.Load / cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd853d3a | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3391 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID_BY_SIMUL", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_by_simul] \| FP\C… | 화면 필드/플래그 변경 |  |  |  |
| AC-732c68cf | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3391 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID_BY_SIMUL", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_by_simul] \| FP\C… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d5ab3ce8 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3393 |  | STATE_RESET | dtInstance_pack.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f045053c | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3394 |  | STATE_RESET | dtInstance_cell.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0121aa20 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3395 |  | STATE_RESET | dtInstance_form.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-faa31bf2 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3400 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | dtInstance_pack.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-16a6d4b0 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3401 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | dtInstance_cell.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-83929d9d | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3402 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | dtInstance_form.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00817e74 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3404 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | pack_row["CODE"] | row["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce12ecc5 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3405 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | pack_row["NAME"] | row["PACK_INSTANCE_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-b698f3de | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3407 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | cell_row["CODE"] | row["CELL_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6b65e2d7 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3408 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | cell_row["NAME"] | row["CELL_INSTANCE_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6a943e0 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3410 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | form_row["CODE"] | row["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-90732947 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3411 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | form_row["NAME"] | row["INSTANCE_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-86803714 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3413 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | dtInstance_pack.Rows.Add | (pack_row) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee9ed1b9 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3415 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | dtInstance_cell.Rows.Add | (cell_row) | 데이터 객체 조작/조회 |  |  |  |
| AC-6080791a | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3417 | if (dtInstance.Good()) ▸ foreach (DataRow row in dtInstance.Rows) | DATA_OP | dtInstance_form.Rows.Add | (form_row) | 데이터 객체 조작/조회 |  |  |  |
| AC-e86f3a68 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3422 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance_pack, cbo_pack_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7efe3313 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3423 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance_cell, cbo_cell_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1a09b801 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3424 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance_form, cbo_form_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f0ba31b9 | this.Load 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:3426 | if (cbo_pack_plan_group.Items.Count > 0) | VALUE_SET | cbo_pack_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetLastReleaseTime

진입점: this.Load / cbo_site.SelectedIndexChanged / cbo_pack_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf6be5a2 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3443 |  | FLAG | dtLastestRel | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_LastestReleaseTime… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] \| FP\… | 화면 필드/플래그 변경 |  |  |  |
| AC-135c8492 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3443 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_LastestReleaseTime", Filter.Dictionary, "Plann… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-58cdb183 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:3446 | if (dtLastestRel.Good()) | DATA_OP | Filter["LAST_RELEASE_TIME"] | dtLastestRel.Rows[0]["LAST_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetLine

진입점: this.Load / cbo_site.SelectedIndexChanged [else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner_Form.Items.Count) ▸ if (mcbo_planner_Form.Items[k].ToString() == sValueName.ToString())] / mcbo_planner_Cell.SelectedIndexChanged / mcbo_planner_Pack.SelectedIndexChanged / mcbo_planner_Form.SelectedIndexChanged / chk_allLine_Cell.CheckedChanged / chk_allLine_Pack.CheckedChanged / chk_allLine_Form.CheckedChanged / cbo_pack_plan_group.SelectedIndexChanged [else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7651aec8 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:747 | if (_TYPE == "CELL") ▸ try | DATA_OP | Filter["PLANNER_YN"] | Filter["PLANNER_YN_CELL"] | 행/컬럼 값 대입 |  |  |  |
| AC-33d8bcc5 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:748 | if (_TYPE == "CELL") ▸ try | DATA_OP | Filter["ALL_LINE"] | chk_allLine_Cell.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-cd49d261 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:749 | if (_TYPE == "CELL") ▸ try | DATA_OP | Filter["LINE_ID_CELL"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-2af8d7e7 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:750 | if (_TYPE == "CELL") ▸ try | DATA_OP | Filter["INSTANCE_ID"] | Filter["ASSY_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d6ac1dea | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:751 | if (_TYPE == "CELL") ▸ try | DATA_OP | Filter["USER_LT"] | Filter["USER_CELL_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-3a00247e | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:753 | if (_TYPE == "CELL") ▸ try | FLAG | dtLine_Cell | DataService.FP_ExecuteProcedure2(("PR_UI_FP00599_findLineCode_List").ToUpper(), Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e840e101 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:753 | if (_TYPE == "CELL") ▸ try | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_FP00599_findLineCode_List").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a63b1313 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:754 | if (_TYPE == "CELL") ▸ try | LIST_REBIND | clsCtrl.setListBox | (dtLine_Cell, mcbo_line_Cell, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0d8b46fc | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:760 | if (_TYPE == "CELL") ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-c110da58 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:765 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | DATA_OP | Filter["PLANNER_YN"] | Filter["PLANNER_YN_PACK"] | 행/컬럼 값 대입 |  |  |  |
| AC-fb96c53e | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:766 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | DATA_OP | Filter["ALL_LINE"] | chk_allLine_Pack.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b42368f6 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:767 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | DATA_OP | Filter["LINE_ID_PACK"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-9652eaf8 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:768 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | DATA_OP | Filter["INSTANCE_ID"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b84ede7a | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:769 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | DATA_OP | Filter["USER_LT"] | Filter["USER_PACK_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-c251ed9d | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:771 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | FLAG | dtLine_Pack | Data_FP.CallGeneralProcedure2(("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-a31fce38 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:771 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "LINE_CODE_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-95272ab8 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:772 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | LIST_REBIND | clsCtrl.setListBox | (dtLine_Pack, mcbo_line_Pack, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-cb79d76d | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:778 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | DATA_OP | Filter["PLANNER_YN"] | Filter["PLANNER_YN_FORM"] | 행/컬럼 값 대입 |  |  |  |
| AC-ef218901 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:779 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | DATA_OP | Filter["ALL_LINE"] | chk_allLine_Form.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-9b5ffdfa | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:780 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | DATA_OP | Filter["LINE_ID_FORM"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-17cc898b | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:781 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | DATA_OP | Filter["INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ca462df | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:782 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | DATA_OP | Filter["USER_LT"] | Filter["USER_FORM_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-428fc2ea | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:784 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | FLAG | dtLine_Form | DataCommon.GetPlannnigUserFormCodeData("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00621_fin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-524ea8e3 | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:784 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00621_findLineCode_List", Filter["INSTANCE_ID"]… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ce45edf | this.Load 외 8 | FP00641_Cell_Simulation_Cell_Pack.cs:787 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | LIST_REBIND | clsCtrl.setListBox | (dtLine_Form, mcbo_line_Form, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetListBucketDate

진입점: this.Load / cbo_site.SelectedIndexChanged / date_instance.ValueChanged / cbo_pack_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-748e51db | this.Load 외 3 | FP00641_Cell_Simulation_Cell_Pack.cs:3452 |  | FLAG | dtBucketdate | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_bucketdate", Filte… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] \| FP\Planning… | 화면 필드/플래그 변경 |  |  |  |
| AC-b73f2817 | this.Load 외 3 | FP00641_Cell_Simulation_Cell_Pack.cs:3452 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_bucketdate", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c7a03af6 | this.Load 외 3 | FP00641_Cell_Simulation_Cell_Pack.cs:3457 | if (dtBucketdate.Good()) | UI_PROP | range_plan.Values | new Tuple<DateTime, DateTime>( DateTime.ParseExact(dtBucketdate.Rows[0]["START_DATE"].ToSt… | 속성 Values 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac71b7be | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:3563 |  | FLAG | dtOperation | DataService.FP_ExecuteProcedure2(("PR_UI_" + "FP00599" + "_" + "findOperationCode_common")… | 화면 필드/플래그 변경 |  |  |  |
| AC-4050c489 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:3563 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetPackDataOfCellGroup

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sInputMode.Equals("N")) ▸ if (true) ▸ if (sCate == "PACK_P_OUT")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2faa166e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9763 | if (!dtSource.Good() \|\| click_row == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b63ce530 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9771 | lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cab908b5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9772 | lambda | DATA_OP | x.Field | ("SHOP_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1aee95c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9773 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa1a8255 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9774 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-628d5225 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9775 | lambda | DATA_OP | x.Field | ("PACK_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5118608 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9769 | lambda | RETURN | return ( x.Field<string>("DATA_TYPE") == "DATA" && x.Field<string>("SHOP_TYPE") … |  | 처리 중단/반환 |  |  |  |
| AC-5689669b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:9779 |  | RETURN | return rows; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetPlan

진입점: this.Load / cbo_site.SelectedIndexChanged / date_instance.ValueChanged / this.cbo_form_plan_id.DropDown / this.cbo_cell_plan_id.DropDown / this.cbo_pack_plan_id.DropDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fecb166 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3466 |  | DATA_OP | Filter["SHOP"] | type | 행/컬럼 값 대입 |  |  |  |
| AC-a5b79373 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3472 | switch (type) case "P": | DATA_OP | Filter["INSTANCE_ID"] | inst | 행/컬럼 값 대입 |  |  |  |
| AC-6dcbc8d1 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3473 | switch (type) case "P": | FLAG | sCurrPlan | (cbo_pack_plan_id.SelectedValue == null) ? "" : cbo_pack_plan_id.SelectedValue.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7dbf73f1 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3474 | switch (type) case "P": | FLAG | dtPlan_pack | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_plan", Filter.Dict… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] \| FP\Planning\FP006… | 화면 필드/플래그 변경 |  |  |  |
| AC-7270f8e8 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3474 | switch (type) case "P": | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_plan", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] \| FP\Planning\FP006… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c38353b3 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3475 | switch (type) case "P": | LIST_REBIND | clsCtrl.setListBox | (dtPlan_pack, cbo_pack_plan_id, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1d96693a | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3479 | switch (type) case "P": ▸ if (sCurrPlan != "") | VALUE_SET | cbo_pack_plan_id.SelectedValue | sCurrPlan | 컨트롤 값 설정 |  |  |  |
| AC-fc9e8605 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3480 | switch (type) case "P": ▸ if (sCurrPlan != "") | STATE | cbo_pack_plan_id.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ff11f933 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3482 | switch (type) case "P": ▸ if (sCurrPlan != "") | FLAG | sCurrPlan | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f5ece615 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3487 | switch (type) case "P": ▸ else of (sCurrPlan != "") ▸ if (cbo_pack_plan_id.Items.Count > 0) | VALUE_SET | cbo_pack_plan_id.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e7d7513d | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3489 | switch (type) case "P": | DATA_OP | Filter["PACK_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9e02a563 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3491 | switch (type) case "P": ▸ if (cbo_pack_plan_id.Items.Count > 0) | DATA_OP | Filter["PACK_PLAN_ID"] | CString.GetCheckedListValue(dtPlan_pack, cbo_pack_plan_id.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5fa6a8da | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3495 | switch (type) case "F": | DATA_OP | Filter["INSTANCE_ID"] | inst | 행/컬럼 값 대입 |  |  |  |
| AC-937c0338 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3496 | switch (type) case "F": | FLAG | sCurrPlan | (cbo_form_plan_id.SelectedValue == null) ? "" : cbo_form_plan_id.SelectedValue.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-43d6f2de | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3497 | switch (type) case "F": | FLAG | dtPlan_form | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_plan", Filter.Dict… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] \| FP\Planning\FP006… | 화면 필드/플래그 변경 |  |  |  |
| AC-f1870acf | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3497 | switch (type) case "F": | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_plan", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] \| FP\Planning\FP006… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4139e332 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3498 | switch (type) case "F": | LIST_REBIND | clsCtrl.setListBox | (dtPlan_form, cbo_form_plan_id, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-891133c3 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3502 | switch (type) case "F": ▸ if (sCurrPlan != "") | VALUE_SET | cbo_form_plan_id.SelectedValue | sCurrPlan | 컨트롤 값 설정 |  |  |  |
| AC-6391f243 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3503 | switch (type) case "F": ▸ if (sCurrPlan != "") | STATE | cbo_form_plan_id.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bee46783 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3504 | switch (type) case "F": ▸ if (sCurrPlan != "") | FLAG | sCurrPlan | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-762b9c17 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3509 | switch (type) case "F": ▸ else of (sCurrPlan != "") ▸ if (cbo_form_plan_id.Items.Count > 0) | VALUE_SET | cbo_form_plan_id.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-247a14dc | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3511 | switch (type) case "F": | DATA_OP | Filter["FORM_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6cbd6b3f | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3513 | switch (type) case "F": ▸ if (cbo_form_plan_id.Items.Count > 0) | DATA_OP | Filter["FORM_PLAN_ID"] | CString.GetCheckedListValue(dtPlan_form, cbo_form_plan_id.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f965cf91 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3517 | switch (type) case "A": | DATA_OP | Filter["INSTANCE_ID"] | inst | 행/컬럼 값 대입 |  |  |  |
| AC-3aa8725e | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3518 | switch (type) case "A": | FLAG | sCurrPlan | (cbo_cell_plan_id.SelectedValue == null) ? "" : cbo_cell_plan_id.SelectedValue.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f58ec1d8 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3519 | switch (type) case "A": | FLAG | dtPlan_cell | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_plan", Filter.Dict… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] \| FP\Planning\FP006… | 화면 필드/플래그 변경 |  |  |  |
| AC-8cbf2981 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3519 | switch (type) case "A": | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_plan", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] \| FP\Planning\FP006… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5668537a | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3520 | switch (type) case "A": | LIST_REBIND | clsCtrl.setListBox | (dtPlan_cell, cbo_cell_plan_id, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b75ed24a | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3524 | switch (type) case "A": ▸ if (sCurrPlan != "") | VALUE_SET | cbo_cell_plan_id.SelectedValue | sCurrPlan | 컨트롤 값 설정 |  |  |  |
| AC-030214c1 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3525 | switch (type) case "A": ▸ if (sCurrPlan != "") | STATE | cbo_cell_plan_id.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bf9868e5 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3526 | switch (type) case "A": ▸ if (sCurrPlan != "") | FLAG | sCurrPlan | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3425c38a | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3531 | switch (type) case "A": ▸ else of (sCurrPlan != "") ▸ if (cbo_cell_plan_id.Items.Count > 0) | VALUE_SET | cbo_cell_plan_id.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-6b93246e | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3533 | switch (type) case "A": | DATA_OP | Filter["ASSY_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6fb1d2f4 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3535 | switch (type) case "A": ▸ if (cbo_cell_plan_id.Items.Count > 0) | DATA_OP | Filter["ASSY_PLAN_ID"] | CString.GetCheckedListValue(dtPlan_cell, cbo_cell_plan_id.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a3afed01 | this.Load 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3538 |  | DATA_OP | Filter["INSTANCE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetPlanner

진입점: this.Load / cbo_site.SelectedIndexChanged / cbo_pack_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de83d5bd | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:588 | if (_TYPE == "CELL") | DATA_OP | Filter["INSTANCE_ID"] | Filter["ASSY_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-52d27fa6 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:589 | if (_TYPE == "CELL") | FLAG | dtPlanner_Cell | DataService.FP_ExecuteProcedure2(("PR_UI_FP00599_findPlanner_List").ToUpper(), Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f51401ec | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:589 | if (_TYPE == "CELL") | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_FP00599_findPlanner_List").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bb49c4b7 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:590 | if (_TYPE == "CELL") | LIST_REBIND | clsCtrl.setListBox | (dtPlanner_Cell, mcbo_planner_Cell, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-12d13694 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:602 | if (_TYPE == "CELL") ▸ if (dtPlanner_Cell.Good()) ▸ foreach (DataRow row in dtPlanner_Cell.Rows) ▸ if (mcbo_planner_Cell.Items[i].ToString()… | CALL_EXT | mcbo_planner_Cell.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afd2916d | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:606 | if (_TYPE == "CELL") ▸ if (dtPlanner_Cell.Good()) ▸ foreach (DataRow row in dtPlanner_Cell.Rows) ▸ if (mcbo_planner_Cell.Items[i].ToString()… | CALL_EXT | mcbo_planner_Cell.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-878ff98b | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:620 | if (_TYPE == "CELL") ▸ if (!dtPlanner_Cell.Good()) | VALUE_SET | chk_allLine_Cell.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-42318c1f | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:624 | if (_TYPE == "CELL") ▸ else of (!dtPlanner_Cell.Good()) | VALUE_SET | chk_allLine_Cell.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-05a229be | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:629 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") ▸ if (Filter["PACK_INSTANCE_ID"] == "" \|\| Filter["PACK_INSTANCE_ID"] == null) | DATA_OP | Filter["PACK_INSTANCE_ID"] | dtInstance.Rows[0]["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c61b20db | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:631 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | DATA_OP | Filter["INSTANCE_ID"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-691c4020 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:632 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | FLAG | dtPlanner_Pack | Data_FP.CallGeneralProcedure2(("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-530df077 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:632 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00601_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLANNER_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-22e5956e | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:633 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") | LIST_REBIND | clsCtrl.setListBox | (dtPlanner_Pack, mcbo_planner_Pack, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-b3ddfa0c | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:645 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") ▸ if (dtPlanner_Pack.Good()) ▸ foreach (DataRow row in dtPlanner_Pack.Rows) ▸ if (mcbo_plan… | CALL_EXT | mcbo_planner_Pack.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3cc23de | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:649 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") ▸ if (dtPlanner_Pack.Good()) ▸ foreach (DataRow row in dtPlanner_Pack.Rows) ▸ if (mcbo_plan… | CALL_EXT | mcbo_planner_Pack.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cbf30ac | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:663 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") ▸ if (!dtPlanner_Pack.Good()) | VALUE_SET | chk_allLine_Pack.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-9f3d9c02 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:667 | else of (_TYPE == "CELL") ▸ if (_TYPE == "PACK") ▸ else of (!dtPlanner_Pack.Good()) | VALUE_SET | chk_allLine_Pack.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-54ad4e5e | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:677 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | DATA_OP | Filter["INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-51058f20 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:681 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (sInstance.Equals("PL_FORM_A")) | FLAG | dtPlanner_Form | DataCommon.GetPlannnigUserFormCodeData("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00607_fin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-77241a6d | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:681 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (sInstance.Equals("PL_FORM_A")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00607_findPlanner_List_exception", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa535a23 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:683 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ else of (sInstance.Equals("PL_FORM_A")) | FLAG | dtPlanner_Form | DataCommon.GetPlannnigUserFormCodeData("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00594_fin… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-bcd269c1 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:683 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ else of (sInstance.Equals("PL_FORM_A")) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00594_findPlanner_List", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6d4e22e | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:685 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") | LIST_REBIND | clsCtrl.setListBox | (dtPlanner_Form, mcbo_planner_Form, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-03657bc7 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:695 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (dtPlanner_Form.Good()) ▸ foreach (DataRow row in dtPlanne… | CALL_EXT | mcbo_planner_Form.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-563c8cdc | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:699 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (dtPlanner_Form.Good()) ▸ foreach (DataRow row in dtPlanne… | CALL_EXT | mcbo_planner_Form.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c405ae27 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:715 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (dtPlanner_Form != null) ▸ if (dtPlanner_Form.Rows.Count =… | VALUE_SET | chk_allLine_Form.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6149bd36 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:716 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (dtPlanner_Form != null) ▸ if (dtPlanner_Form.Rows.Count =… | DATA_OP | Filter["ALL_LINE_FORM"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f87ca191 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:720 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (dtPlanner_Form != null) ▸ else of (dtPlanner_Form.Rows.Co… | VALUE_SET | chk_allLine_Form.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-d5eb603d | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:721 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (dtPlanner_Form != null) ▸ else of (dtPlanner_Form.Rows.Co… | DATA_OP | Filter["ALL_LINE_FORM"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-918daadf | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:731 | else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planne… | CALL_EXT | mcbo_planner_Form.SetItemChecked | (k, true) | ⚠ 의미 확인 필요 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3d03c5e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9843 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-9092be16 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9844 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GetSite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0032c63e | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:3384 |  | FLAG | dtSite | DataService.FP_ExecuteQuery2("FP00641_Cell_Simulation_Cell_Pack", "find_site", Filter.Dict… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] \| FP\Planning\FP006… | 화면 필드/플래그 변경 |  |  |  |
| AC-a5ae72af | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:3384 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00641_Cell_Simulation_Cell_Pack", "find_site", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] \| FP\Planning\FP006… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-165f8b51 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:3385 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5623306 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:3584 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73342aa5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:1316 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9d3f6d1 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:1318 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e3ad10d2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:1347 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On && calendar.Days != null) ▸ foreach (var day_item i… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d5568d9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:1348 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On && calendar.Days != null) ▸ foreach (var day_item i… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-8a3f4c84 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:1356 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / FindButton [try ▸ if (siMain.ActiveShe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5e1a41e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1378 | if (do_edit_mode) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d615d049 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1386 | if (do_edit_mode) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDate day in calendar.Days.Valu… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-cf9d21d4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1387 | if (do_edit_mode) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDate day in calendar.Days.Valu… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-97d3e8e8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1431 | if (do_edit_mode) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDate day in calendar.Days.Valu… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e726c9f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1449 | if (do_edit_mode) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDate day in calendar.Days.Valu… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-828ee2ee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1457 | if (do_edit_mode) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a7ed6bc1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1458 | if (do_edit_mode) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daafdec0 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:219 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e9e7093 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:223 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-18cb410f | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:224 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d42396ef | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:228 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-a35e49ba | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:231 |  | DATA_OP | Filter["BUCKET"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-ac5422a0 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:232 |  | DATA_OP | Filter["USER_ID"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-06b9758c | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:233 |  | DATA_OP | Filter["IS_REL_PACK"] | Filter["IS_REL_FORM"] = Filter["IS_REL_ASSY"] = "N" | 행/컬럼 값 대입 |  |  |  |
| AC-858afc72 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:233 |  | DATA_OP | Filter["IS_REL_FORM"] | Filter["IS_REL_ASSY"] = "N" | 행/컬럼 값 대입 |  |  |  |
| AC-49cba07b | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:233 |  | DATA_OP | Filter["IS_REL_ASSY"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-a37b974c | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:234 |  | DATA_OP | Filter["IS_INPUT_MODE"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d4cbfb02 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:236 |  | FLAG | dtInstance_pack | DataService.CreateCodeTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-27844872 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:236 |  | CALL_EXT | DataService.CreateCodeTable | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08a5e006 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:237 |  | FLAG | dtInstance_form | DataService.CreateCodeTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-b671373f | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:237 |  | CALL_EXT | DataService.CreateCodeTable | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ddd1e9f0 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:238 |  | FLAG | dtInstance_cell | DataService.CreateCodeTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-d81c5266 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:238 |  | CALL_EXT | DataService.CreateCodeTable | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c77a5af7 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:241 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-de75bb48 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:257 |  | DATA_OP | Filter["PLAN_DATE"] | date_instance.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-480320bc | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:260 |  | DATA_OP | Filter["BUCKET_FROM"] | range_plan.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-eb77dc07 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:261 |  | DATA_OP | Filter["BUCKET_TO"] | range_plan.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.InitEditingBuf

진입점: FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3825e620 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5105 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-be97786e | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5106 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-ccbc2f1d | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5107 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-29e41967 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5108 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fd7ab92e | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5109 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-79f3f234 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5110 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fa2bc3a5 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5111 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52b2817f | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:503 |  | UI_PROP | mcbo_planner_Cell.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-0012c86f | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:504 |  | UI_PROP | mcbo_planner_Pack.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8f60de96 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:505 |  | UI_PROP | mcbo_planner_Form.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e29b4512 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:514 |  | FLAG | init_event_done | true | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.InitSpread

진입점: this.Load / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96ce4ad9 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:816 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e284db94 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:817 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1c184da5 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:819 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d60606ea | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:823 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ceba9d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:3292 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setCell_EOH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4613a7a3 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9359 | if (dtSource == null \|\| cell_group_rows == null \|\| cell_data_rows == null \|\| cell_data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e78f1a8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9374 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-94153ede | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9373 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "CELL_I_EOH"); |  | 처리 중단/반환 |  |  |  |
| AC-13b13367 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9381 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd6d9c90 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9380 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "CELL_S_FORM_REQUEST"); |  | 처리 중단/반환 |  |  |  |
| AC-51686bb3 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9412 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c011576 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9411 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "CELL_P_OUT_UOM"); |  | 처리 중단/반환 |  |  |  |
| AC-eea81a93 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9419 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4991e32 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9471 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-bd5bdcb6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9478 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |
| AC-f3abb7b4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9517 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-12f2dc9d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9524 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setCell_Form_Request

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ec278fe | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7357 |  | COMBO_DATA | data_cell_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f3386d2f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7358 | if (dtSource == null \|\| cell_group_rows == null \|\| data_cell_rows == null \|\| data_cell_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afc840e4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7369 |  | COMBO_DATA | data_cell_rows.Where | (x => { return ( x.Field<string>("CATEGORY_ID") == "CELL_S_FORM_REQUEST"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-047ba49c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7373 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b882ad5e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7372 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "CELL_S_FORM_REQUEST"); |  | 처리 중단/반환 |  |  |  |
| AC-73da3ca8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7381 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-49dd2018 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7380 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-d02e0389 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7389 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-627d2e0f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7388 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "FORM_P_YIELD"); |  | 처리 중단/반환 |  |  |  |
| AC-a9afbfd7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7397 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d4e5f0f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7436 | if (run_cond) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-715444ce | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7443 | if (run_cond) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setCell_SCP_Balance

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acd7dc1c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9198 | if (dtSource == null \|\| cell_group_rows == null \|\| cell_data_rows == null \|\| cell_data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c61ea71c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9215 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-190ae1c8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9214 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "CELL_I_SCP"); |  | 처리 중단/반환 |  |  |  |
| AC-7e16f0dc | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9224 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-641d7990 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9223 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "CELL_P_OUT_UOM"); |  | 처리 중단/반환 |  |  |  |
| AC-620fcfd4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9231 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-80643a8c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9230 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "CELL_S_TARGET"); |  | 처리 중단/반환 |  |  |  |
| AC-9abb8bf4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9237 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fbe51ae | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9300 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-7b5528fb | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9307 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |
| AC-9ce45342 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9337 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-bb2b667a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9345 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Activated_Cell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1020c9a3 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7834 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a0a98c2f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7835 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b67ddd4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7845 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1665f9b6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7848 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-18118782 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7848 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Activated_Cell_Detail

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b33bdd8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7867 | if (form_p_out == null \|\| cell_group_rows == null \|\| data_rows == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b960030f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7873 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ddbe14e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7876 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d53bffc8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7876 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); |  | 처리 중단/반환 |  |  |  |
| AC-5658b539 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7880 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED_CELL"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11672a83 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7883 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d0c5cd1 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7883 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED_CELL"); |  | 처리 중단/반환 |  |  |  |
| AC-dde95d63 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7888 | if (nRow_Activated_Cell.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6596c52d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7917 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-06a8166f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7918 | lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f686ad30 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7919 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-79a3278a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7920 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-986846b5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7915 | lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == form_p_out["FACTORY_ID"].ToString() &&… |  | 처리 중단/반환 |  |  |  |
| AC-2e6e3508 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7973 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-39b7a59b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7974 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-012ea126 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7975 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f16da30 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7976 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-db0a6d0e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7977 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4efab1c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7971 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | RETURN | return ( x.Field<string>("PLAN_DATE") == each_date.ToString() && x.Field<string>… |  | 처리 중단/반환 |  |  |  |
| AC-34ec1a19 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8010 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | RactivatedCell[adDefDate.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-c045db20 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8020 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | GRID_SET | siMain.SetText | (scr_RactivatedCell, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |
| AC-3257764b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8052 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd3f4c4a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8053 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-16919d6d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8054 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-906731c7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8055 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b25772e0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8056 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-96570ffc | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8050 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | RETURN | return ( x.Field<string>("PLAN_DATE") == each_date.ToString() && x.Field<string>… |  | 처리 중단/반환 |  |  |  |
| AC-e6170b74 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8088 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | RactivatedCell[each_date.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-d710cb9b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8098 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | GRID_SET | siMain.SetText | (scr_RactivatedCell, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Aging_Wip

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-887b0799 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8421 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90447a60 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8422 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e93fab6a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8431 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43230eb8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8434 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e4eb405 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8434 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-89831801 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8438 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fac594e6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8441 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ee7a92a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8441 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); |  | 처리 중단/반환 |  |  |  |
| AC-11520205 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8445 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-68ca2128 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8448 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-eff64612 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8448 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); |  | 처리 중단/반환 |  |  |  |
| AC-ffdff9ee | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8452 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-876bcd50 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8455 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-44b92b35 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8455 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); |  | 처리 중단/반환 |  |  |  |
| AC-38199b0d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8462 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcb0c66b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8462 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "CELL_P_OUT_CELL"); |  | 처리 중단/반환 |  |  |  |
| AC-b9446998 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8469 | if (nRow_Activated.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b95ff786 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8491 | lambda | DATA_OP | each_row.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-af7507a5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8517 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-496e00d0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8520 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b47529f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8525 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbe9aa40 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8525 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f7f904ce | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8532 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[adDefDate.Value] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-26839ec8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8542 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |
| AC-16b5efda | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8563 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-82e81175 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8563 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-138b1496 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8570 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[d.Value] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-937aab00 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8578 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Aging_Wip_

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e08aaab9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8108 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95a310e4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8109 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5c9ace5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8119 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ee0d92fc | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8122 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-69bd04ad | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8122 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Aging_Wip_D

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1bfc193 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8141 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a9894f8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8142 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3d43e1e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8151 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de5dc5cc | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8154 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e7d030a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8154 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); |  | 처리 중단/반환 |  |  |  |
| AC-0e85d144 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8158 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8957ba7f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8161 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0856ef70 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8161 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); |  | 처리 중단/반환 |  |  |  |
| AC-c050b3b9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8168 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c5b50d4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8168 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "CELL_P_OUT_CELL"); |  | 처리 중단/반환 |  |  |  |
| AC-bcc1c240 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8175 | if (nRow_Activated.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a87607b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8197 | lambda | DATA_OP | each_row.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb1edd89 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8199 | lambda | DATA_OP | each_row.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe3bc6da | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8234 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3165b71 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8234 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62a2edc9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8241 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[adDefDate.Value] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-839a8855 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8251 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |
| AC-611caaa8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8272 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9a0f68e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8272 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-efe69ae8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8279 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[d.Value] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-f1afaf46 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8287 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |
| AC-530de121 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8317 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-832f5889 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8317 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7c6337bd | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8327 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-879aa135 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8334 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[sCol_Lt] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-bd879bd2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8344 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |
| AC-59a58503 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8368 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-82018b5d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8368 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-442c44e4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8377 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6c05eea | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8384 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[sCol_Lt] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-e6f27c10 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8394 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Aging_Wip_Detail

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-987a2731 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8603 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f699b48e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8604 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c6df547 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8613 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aef7d96c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8616 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-56947232 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8616 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-27090a02 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8620 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b25629a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8623 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ab5ef60 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8623 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); |  | 처리 중단/반환 |  |  |  |
| AC-5baced8d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8627 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7ad74232 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8630 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-94f12d5b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8630 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); |  | 처리 중단/반환 |  |  |  |
| AC-ec7f1861 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8634 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06ea6dd9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8637 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-010d64f7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8637 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_AGING_WIP"); |  | 처리 중단/반환 |  |  |  |
| AC-b58111b2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8644 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-45bc8e7a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8644 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "CELL_P_OUT_CELL"); |  | 처리 중단/반환 |  |  |  |
| AC-f42bcc0c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8651 | if (nRow_Activated.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d93a9b7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8673 | lambda | DATA_OP | each_row.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-214abd10 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8700 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd0f196e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8700 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-217c8178 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8705 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c28df4c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8710 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90bca40b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8717 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[sCol_Lt] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-52d8c079 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8727 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |
| AC-c4765f16 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8751 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable().Compute | ("Sum(" + d.Value + ")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-222c59d2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8751 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c08d623d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8755 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d1c5d1f1 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8760 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-089121ff | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8767 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | DATA_OP | RagingWip[sCol_Lt] | Math.Round(nAgingWip) | 행/컬럼 값 대입 |  |  |  |
| AC-52c769e5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8777 | if (result.Count() > 0) ▸ foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) … | GRID_SET | siMain.SetText | (scr_RagingWip, col, string.Format("{0}", Math.Round(nAgingWip))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Cell_Request

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80f787cc | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7454 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2edf3ced | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7455 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f56c8319 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7466 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_S_SHIPPING"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f8cef05c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7469 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab5b89a4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7469 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_S_SHIPPING"); |  | 처리 중단/반환 |  |  |  |
| AC-fe90ce42 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7485 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c64db44 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7484 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "PACK_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-52bac3c4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7499 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4312d93 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7499 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_P_YIELD"); |  | 처리 중단/반환 |  |  |  |
| AC-ac98ee3c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7507 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fb62b8a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7560 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("RNK") | 데이터 객체 조작/조회 |  |  |  |
| AC-04620d08 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7561 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f1f72dd | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7562 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-615de87d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7563 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PARENT_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f62ce6a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7564 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("MONTH") | 데이터 객체 조작/조회 |  |  |  |
| AC-331b6389 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7559 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | RETURN | return ( x.Field<System.Int64>("RNK") == 1 && x.Field<string>("PLANT_ID") == out… |  | 처리 중단/반환 |  |  |  |
| AC-52b638aa | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7577 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-242ac4a7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7578 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e28c24e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7579 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PARENT_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8810cace | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7575 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | RETURN | return ( //x.Field<string>("RNK") == "1" && x.Field<string>("PLANT_ID") == out_r… |  | 처리 중단/반환 |  |  |  |
| AC-0ef17718 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7622 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | FLAG | lvn_shipping_plan | Math.Round(nInvt) - Rinvert[d.Value].SafeDouble() | 화면 필드/플래그 변경 |  |  |  |
| AC-46177783 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7624 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-6f469fd5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7632 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_EOH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7588791c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9535 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b86c149f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9536 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ecd067d0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9547 |  | COMBO_DATA | data_rows.Where | ( x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_EOH"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00ce0eb0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9551 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9836a35b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9551 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_EOH"); |  | 처리 중단/반환 |  |  |  |
| AC-5d5ff235 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9555 |  | COMBO_DATA | data_rows.Where | ( x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_EOH_GOOD"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b6991a21 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9559 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f022c15b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9559 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_EOH_GOOD"); |  | 처리 중단/반환 |  |  |  |
| AC-032daad9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9563 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_S_SHIPPING"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9b2d25c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9566 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d27c7c7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9566 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_S_SHIPPING"); |  | 처리 중단/반환 |  |  |  |
| AC-4c8dea2c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9571 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3e0b640 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9574 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-14987176 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9574 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-4bd3b882 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9582 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fe32087 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9619 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8a04666 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9620 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6de6658 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9656 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-c8e44931 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9657 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | RinvertGood[d.Value] | Math.Round(nInvtGood) | 행/컬럼 값 대입 |  |  |  |
| AC-ec996662 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9664 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |
| AC-68df2628 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9665 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.SetText | (scr_RinvertGood, col, string.Format("{0}", Math.Round(nInvtGood))) | 그리드 값 설정 |  |  |  |
| AC-ce65bc95 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9721 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-74ddca13 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9722 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | RinvertGood[d.Value] | Math.Round(nInvtGood) | 행/컬럼 값 대입 |  |  |  |
| AC-7a748f8c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9731 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |
| AC-e9df6fed | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9732 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.SetText | (scr_RinvertGood, col, string.Format("{0}", Math.Round(nInvtGood))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Pack_Group

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sInputMode.Equals("N")) ▸ if (true) ▸ if (sCate == "PACK_P_OUT")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13ed12aa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7645 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2c665d0b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7646 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e94fc00 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7657 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_S_SHIPPING_GROUP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33c51cf5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7660 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-db0a4388 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7660 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_S_SHIPPING_GROUP"); |  | 처리 중단/반환 |  |  |  |
| AC-e9dffd46 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7676 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a78f58c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7675 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "PACK_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-e9623167 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7690 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-43b29809 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7690 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_P_YIELD"); |  | 처리 중단/반환 |  |  |  |
| AC-2b886df3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7698 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d347f0fc | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7751 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("RNK") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a00296c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7752 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad3003ee | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7753 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PARENT_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2fae98f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7754 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("MONTH") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2e9dc55 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7750 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | RETURN | return ( x.Field<System.Int64>("RNK") == 1 && x.Field<string>("PLANT_ID") == out… |  | 처리 중단/반환 |  |  |  |
| AC-24ba8f52 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7767 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6b02853 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7768 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | x.Field | ("PARENT_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fc0bbe2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7765 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | RETURN | return ( //x.Field<string>("RNK") == "1" && x.Field<string>("PLANT_ID") == out_r… |  | 처리 중단/반환 |  |  |  |
| AC-9407e0ed | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7811 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | FLAG | lvn_shipping_plan | Math.Round(nInvt) - Rinvert[d.Value].SafeDouble() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ba819b7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7813 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-952cd831 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:7821 | foreach (AmendDate d in calendar.Days.Values) ▸ if (date_num >= start && date_num <= end) ▸ if (pack_p_outs != null && pack_p_yields != null… | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Remained_Activated_Cell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fd8b6c4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8804 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87dc7c8e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8805 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-523a6a41 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8814 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-971377bd | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8817 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2086b34 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8817 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-bd42a022 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8821 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9dd3fcb7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8824 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-48dc0875 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8824 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "FORM_I_ACTIVATED"); |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setForm_Remained_Activated_Cell_Detail

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1990bde9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8902 | if (form_p_remined == null \|\| form_p_out == null \|\| cell_group_rows == null \|\| data_rows == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b18615c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8928 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f5fec9c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8929 | lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-af3ad52c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8930 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbb89df5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8931 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f4189b7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8926 | lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == form_p_remined["FACTORY_ID"].ToString(… |  | 처리 중단/반환 |  |  |  |
| AC-db76ec51 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8967 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-57eb7704 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8968 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9226888 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8969 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c6de18d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8965 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | RETURN | return ( x.Field<string>("PLAN_DATE") == Filter["PLAN_DATE"] && x.Field<string>(… |  | 처리 중단/반환 |  |  |  |
| AC-6f496a10 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8992 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1adef811 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8993 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-22a82ad6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8994 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b40db2f4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8995 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb6f32ca | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8996 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6c2b262 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:8990 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | RETURN | return ( x.Field<string>("PLAN_DATE") == each_date.ToString() && x.Field<string>… |  | 처리 중단/반환 |  |  |  |
| AC-a94481f2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9033 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f0867886 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9034 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1f349f3 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9035 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7fb5386 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9036 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | x.Field | ("MONTH") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd81c056 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9031 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | RETURN | return ( x.Field<string>("FACTORY_ID") == form_p_remined["FACTORY_ID"].ToString(… |  | 처리 중단/반환 |  |  |  |
| AC-9e3dc083 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9061 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | DATA_OP | form_p_remined[each_date.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-4e8ac0c9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9062 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (useB… | GRID_SET | siMain.SetText | (row, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |
| AC-b15e098d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9089 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3ff48a9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9090 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-661f7228 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9091 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd7eb9d7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9087 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | RETURN | return ( x.Field<string>("PLAN_DATE") == each_date.ToString() && x.Field<string>… |  | 처리 중단/반환 |  |  |  |
| AC-62c488f8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9114 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-574f4728 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9115 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cdbc7ebf | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9116 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-32c0f9aa | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9117 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5919b28b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9118 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-082cd89a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9112 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | RETURN | return ( x.Field<string>("PLAN_DATE") == each_date.ToString() && x.Field<string>… |  | 처리 중단/반환 |  |  |  |
| AC-e7301802 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9155 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bc4b04d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9157 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-79585a2e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9158 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb0dc2d9 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9159 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | x.Field | ("MONTH") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb8a7d0b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9153 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | RETURN | return ( x.Field<string>("FACTORY_ID") == form_p_remined["FACTORY_ID"].ToString(… |  | 처리 중단/반환 |  |  |  |
| AC-2919d43c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9184 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | DATA_OP | form_p_remined[each_date.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-d54b20a5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:9185 | foreach (AmendDate each_date in calendar.Days.Values) ▸ if (each_date.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!use… | GRID_SET | siMain.SetText | (row, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setPack_EOH_SCPTarget

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92fb2216 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7164 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be1ead69 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7165 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f3c165a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7174 |  | COMBO_DATA | data_rows.Where | (x => { return ( x.Field<string>("CATEGORY_ID") == "PACK_I_SCP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06206f30 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7178 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-08f59f81 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7177 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "PACK_I_SCP"); |  | 처리 중단/반환 |  |  |  |
| AC-7d1a17ab | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7190 |  | COMBO_DATA | data_rows.Where | (x => { return ( x.Field<string>("CATEGORY_ID") == "PACK_P_OUT"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-156c2623 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7194 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-941816e0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7193 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "PACK_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-c5a1f6ec | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7198 |  | COMBO_DATA | data_rows.Where | (x => { return ( x.Field<string>("CATEGORY_ID") == "PACK_S_SCP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff3cf1e0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7202 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a37d6e1d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7201 | lambda | RETURN | return ( x.Field<string>("CATEGORY_ID") == "PACK_S_SCP"); |  | 처리 중단/반환 |  |  |  |
| AC-cbb711d3 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7218 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6e50039 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7285 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | Rinvert[adDefDate.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-dd8dd3c7 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7292 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |
| AC-7248f2dd | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7338 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (!useBoh) | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-59c09f03 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7345 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (!useBoh) | GRID_SET | siMain.SetText | (scr_Rinvert, col, string.Format("{0}", Math.Round(nInvt))) | 그리드 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setPack_EOH_ShippingPlan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b417e9f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6837 |  | COMBO_DATA | data_rows.Count | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce9b1cad | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6838 | if (dtSource == null \|\| cell_group_rows == null \|\| data_rows == null \|\| data_rows.Count() == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41dfbebb | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6849 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1f01b92 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6852 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4bd6556 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6852 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING"); |  | 처리 중단/반환 |  |  |  |
| AC-3bfd3b2c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6856 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING_GOOD"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-df08221e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6859 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-288ae0be | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6859 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING_GOOD"); |  | 처리 중단/반환 |  |  |  |
| AC-709a93eb | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6863 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING_SIM"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e78ecfa8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6866 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1edc98b8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6866 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING_SIM"); |  | 처리 중단/반환 |  |  |  |
| AC-20048fc4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6870 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING_SIM_GOOD"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae245304 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6873 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4399eccd | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6873 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_I_SHIPPING_SIM_GOOD"); |  | 처리 중단/반환 |  |  |  |
| AC-e2dcdc94 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6878 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_S_SHIPPING"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dc161e78 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6881 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dba71d28 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6881 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_S_SHIPPING"); |  | 처리 중단/반환 |  |  |  |
| AC-fd9cd9de | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6885 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_S_SHIPPING_SIM"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b549af2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6888 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a17787c8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6888 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_S_SHIPPING_SIM"); |  | 처리 중단/반환 |  |  |  |
| AC-e5907456 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6892 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_S_SHIPPING_GAP"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e59a443d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6895 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5c6c4cb | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6895 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_S_SHIPPING_GAP"); |  | 처리 중단/반환 |  |  |  |
| AC-9c5bbf5f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6899 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_P_OUT"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b6a284a2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6902 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-787d4a36 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6902 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_P_OUT"); |  | 처리 중단/반환 |  |  |  |
| AC-4059c5b6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6906 |  | COMBO_DATA | data_rows.Where | (x => { return (x.Field<string>("CATEGORY_ID") == "PACK_P_YIELD"); } ) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7dc49987 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6909 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9cf8dd06 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6909 | lambda | RETURN | return (x.Field<string>("CATEGORY_ID") == "PACK_P_YIELD"); |  | 처리 중단/반환 |  |  |  |
| AC-fb233f7d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6915 | if (nRow_Invt.Count() < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7d31415 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6958 | if (scr_Rinvert < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d41052b5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6988 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2b75d6b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:6991 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | COMBO_DATA | data_rows.ElementAt | (0) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37198465 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7025 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | Rinvert[adDefDate.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-922f36e8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7026 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | RinvertGood[adDefDate.Value] | Math.Round(nInvtGood) | 행/컬럼 값 대입 |  |  |  |
| AC-e8e49523 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7027 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | RinvertSim[adDefDate.Value] | Math.Round(nInvtSim) | 행/컬럼 값 대입 |  |  |  |
| AC-3004abbb | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7028 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | RinvertSimGood[adDefDate.Value] | Math.Round(nInvtSimGood) | 행/컬럼 값 대입 |  |  |  |
| AC-be2d8464 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7029 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | DATA_OP | RinvertGap[adDefDate.Value] | Math.Round(nShipGap) | 행/컬럼 값 대입 |  |  |  |
| AC-86763344 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7039 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.ActiveSheet.Cells[scr_Rinvert, col].Value | Math.Round(nInvt) | 그리드 속성/값 설정 |  |  |  |
| AC-f2948e39 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7040 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertGood, col].Value | Math.Round(nInvtGood) | 그리드 속성/값 설정 |  |  |  |
| AC-43efcb03 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7041 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertSim, col].Value | Math.Round(nInvtSim) | 그리드 속성/값 설정 |  |  |  |
| AC-d371a264 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7042 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertSimGood, col].Value | Math.Round(nInvtSimGood) | 그리드 속성/값 설정 |  |  |  |
| AC-8cf0a336 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7043 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (date_num == start &&… | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertGap, col].Value | Math.Round(nShipGap) | 그리드 속성/값 설정 |  |  |  |
| AC-f38634a4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7112 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | Rinvert[d.Value] | Math.Round(nInvt) | 행/컬럼 값 대입 |  |  |  |
| AC-bcf14d85 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7113 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | RinvertGood[d.Value] | Math.Round(nInvtGood) | 행/컬럼 값 대입 |  |  |  |
| AC-b29df664 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7114 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | RinvertSim[d.Value] | Math.Round(nInvtSim) | 행/컬럼 값 대입 |  |  |  |
| AC-b552876e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7115 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | RinvertSimGood[d.Value] | Math.Round(nInvtSimGood) | 행/컬럼 값 대입 |  |  |  |
| AC-4eaaae5c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7116 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | DATA_OP | RinvertGap[d.Value] | Math.Round(nShipGap) | 행/컬럼 값 대입 |  |  |  |
| AC-65c4568d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7136 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.ActiveSheet.Cells[scr_Rinvert, col].Value | Math.Round(nInvt) | 그리드 속성/값 설정 |  |  |  |
| AC-b0a9a12c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7137 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertGood, col].Value | Math.Round(nInvtGood) | 그리드 속성/값 설정 |  |  |  |
| AC-bdb0bca5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7138 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertSim, col].Value | Math.Round(nInvtSim) | 그리드 속성/값 설정 |  |  |  |
| AC-398a171e | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7139 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertSimGood, col].Value | Math.Round(nInvtSimGood) | 그리드 속성/값 설정 |  |  |  |
| AC-ac31c247 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:7140 | foreach (AmendDate d in calendar.Days.Values) ▸ if (d.IsPlan == true) ▸ if (date_num >= start && date_num <= end) ▸ if (!useBoh) | GRID_SET | siMain.ActiveSheet.Cells[scr_RinvertGap, col].Value | Math.Round(nShipGap) | 그리드 속성/값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.lfn_setUpdateTotalValue

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / SaveButton [if (save_su…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97ea29fc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6743 | if (monthInfo != null && calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-5242873e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6744 | if (monthInfo != null && calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6ea3e9e2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6745 | if (monthInfo != null && calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-e5b450ea | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6746 | if (monthInfo != null && calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-645e1880 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6750 | if (calendar == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e9f1c19 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6765 | if (adDefDate == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92b736b9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6767 |  | DATA_OP | dtFiltered.AsEnumerable().GroupBy(x => x.Field<string>("CELL_GROUP_CODE")).Select | (x => x) | 데이터 객체 조작/조회 |  |  |  |
| AC-532a078e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6767 |  | CALL_EXT | dtFiltered.AsEnumerable().GroupBy | (x => x.Field<string>("CELL_GROUP_CODE")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6797ec2a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6767 | lambda | DATA_OP | x.Field | ("CELL_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5706a4ac | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6792 | foreach (var each_cell_group_code in cell_group_codes) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae51072b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6793 | foreach (var each_cell_group_code in cell_group_codes) ▸ lambda | DATA_OP | x.Field | ("SHOP_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-995b92cc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6791 | foreach (var each_cell_group_code in cell_group_codes) ▸ lambda | RETURN | return ( x.Field<string>("DATA_TYPE") == "DATA" && x.Field<string>("SHOP_TYPE") … |  | 처리 중단/반환 |  |  |  |
| AC-13dbb2a9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6812 | foreach (var each_cell_group_code in cell_group_codes) ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-71ca4deb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6813 | foreach (var each_cell_group_code in cell_group_codes) ▸ lambda | DATA_OP | x.Field | ("SHOP_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-043067fb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:6811 | foreach (var each_cell_group_code in cell_group_codes) ▸ lambda | RETURN | return ( x.Field<string>("DATA_TYPE") == "DATA" && x.Field<string>("SHOP_TYPE") … |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.MakeInstanceLT

진입점: this.Load / cbo_site.SelectedIndexChanged / cbo_pack_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c8e0633 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:322 |  | DATA_OP | Filter["PACK_INSTANCE_ID"] | pack | 행/컬럼 값 대입 |  |  |  |
| AC-a89fcab3 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:323 |  | DATA_OP | Filter["FORM_INSTANCE_ID"] | form | 행/컬럼 값 대입 |  |  |  |
| AC-67f6a01a | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:324 |  | DATA_OP | Filter["ASSY_INSTANCE_ID"] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-5b2533a5 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:326 |  | DATA_OP | Filter["INSTANCE_LT"] | "'" + pack + "','" + form + "','" + cell + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-2d826587 | this.Load 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:327 |  | RETURN | return Filter["INSTANCE_LT"]; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.mcbo_planner_Cell_changed

진입점: mcbo_planner_Cell.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-976578a9 | mcbo_planner_Cell.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:541 | if (!dtPlanner_Cell.Good()) | VALUE_SET | chk_allLine_Cell.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-c78b38c3 | mcbo_planner_Cell.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:543 | else of (!dtPlanner_Cell.Good()) | VALUE_SET | chk_allLine_Cell.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.mcbo_planner_Form_changed

진입점: this.Load [else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner_Form.Items.Count) ▸ if (mcbo_planner_Form.Items[k].ToString() == sValueName.ToString())] / cbo_site.SelectedIndexChanged [else of (_TYPE == "CELL") ▸ else of (_TYPE == "PACK") ▸ if (_TYPE == "FORM") ▸ if (!string.IsNullOrEmpty(sValueName)) ▸ for (k < mcbo_planner_Form.Items.Count) ▸ if (mcbo_planner_Form.Items[k].ToString() == sValueName.ToString())] / mcbo_planner_Form.SelectedIndexChanged / cbo_pack_plan_group.SelectedIndexChanged [else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a6f7ab6 | this.Load [else of (_TYPE == "CELL") ▸ else of (_TYPE == "PA… 외 3 | FP00641_Cell_Simulation_Cell_Pack.cs:571 | if (!dtPlanner_Form.Good()) | VALUE_SET | chk_allLine_Form.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-242daa83 | this.Load [else of (_TYPE == "CELL") ▸ else of (_TYPE == "PA… 외 3 | FP00641_Cell_Simulation_Cell_Pack.cs:573 | else of (!dtPlanner_Form.Good()) | VALUE_SET | chk_allLine_Form.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.mcbo_planner_Pack_changed

진입점: mcbo_planner_Pack.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfc21138 | mcbo_planner_Pack.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:556 | if (!dtPlanner_Pack.Good()) | VALUE_SET | chk_allLine_Pack.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-17c64172 | mcbo_planner_Pack.SelectedIndexChanged | FP00641_Cell_Simulation_Cell_Pack.cs:558 | else of (!dtPlanner_Pack.Good()) | VALUE_SET | chk_allLine_Pack.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cd609a1 | memo_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:4938 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9051d119 | memo_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:4941 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ceb6c37 | memo_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:4945 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.onNLFAmendMenu

진입점: nlfamend_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be862a8e | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5048 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34cbfb4a | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5051 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ed1a75c | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5069 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-f9801218 | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5070 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-da4037dd | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5070 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff4fd97b | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5071 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-378839ee | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5072 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bec29fb1 | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5073 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25737e84 | nlfamend_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:5074 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.onZeroMaterialMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2c97fa8 | bucke_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:4894 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5433b54 | bucke_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:4897 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df148621 | bucke_menu.Click | FP00641_Cell_Simulation_Cell_Pack.cs:4921 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !coln… | GRID_SET | siMain.ActiveSheet.Cells[j, i].Value | "0" | 그리드 속성/값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-289a22e7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11938 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-97549abe | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11938 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4892096 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11940 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-f211ef1d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11941 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-b71f9fd7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11941 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-488fea62 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11942 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-1c6db67d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11943 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7be53a52 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11944 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f2e8a467 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11948 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-40ac712f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11950 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a295a51f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11955 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8662cd5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11898 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-c81034a9 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11899 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-4a279d44 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11900 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-4ab04a8a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11900 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8efbc03e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11901 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-0dcb7111 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11902 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6d236235 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11903 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aad660ab | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11907 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-16b087ec | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11909 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7beca5ca | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11915 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-62707cde | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11916 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-e969bdd8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11917 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-1472b0db | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11917 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bca84137 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11918 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-21fb8e46 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11919 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0fe335c0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11920 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ed18af61 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11924 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2a212a09 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP00641_Cell_Simulation_Cell_Pack.cs:11926 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.plan_day_changed

진입점: date_instance.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f43fd7a | date_instance.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10893 |  | DATA_OP | Filter["PLAN_DATE"] | date_instance.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-84b8496d | date_instance.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10896 |  | VALUE_CLEAR | cbo_pack_plan_id.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-e02b333b | date_instance.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10897 |  | VALUE_CLEAR | cbo_form_plan_id.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-80ae7175 | date_instance.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:10898 |  | VALUE_CLEAR | cbo_cell_plan_id.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.plan_range_changed

진입점: range_plan.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75164deb | range_plan.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11085 |  | DATA_OP | Filter["BUCKET_FROM"] | range_plan.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-30f5fa7f | range_plan.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11086 |  | DATA_OP | Filter["BUCKET_TO"] | range_plan.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-07fae459 | range_plan.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11091 | if (gap.Days > 365) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-a6d40ebe | range_plan.ValueChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11092 | if (gap.Days > 365) | UI_PROP | range_plan.Value2 | range_plan.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5deb5c0 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:869 | if (monthInfo != null) ▸ if (calendar == null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-5fa9b7b2 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:870 | if (monthInfo != null) ▸ if (calendar == null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-03f65db1 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:871 | if (monthInfo != null) ▸ if (calendar == null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-e93e32e1 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:872 | if (monthInfo != null) ▸ if (calendar == null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-3934e5d8 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:883 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "", null, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8092f5bb | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:886 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-17b9fa80 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:888 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cf9fa22 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:889 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cb89346 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:890 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1a0f1bc | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:893 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e6691e9 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:894 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8383f03f | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:900 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) ▸ if (froz_index > 0) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | froz_index +1 | 그리드 속성/값 설정 |  |  |  |
| AC-330b9c24 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:903 | if (monthInfo != null) ▸ if (RefreshHeaderWidth == true) ▸ else of (froz_index > 0) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetMaxColumnIndex() - siMain.DayWeekMonthPartCount | 그리드 속성/값 설정 |  |  |  |
| AC-a45dcf48 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:910 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c863f68 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:915 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cde6c63b | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:919 | if (monthInfo != null) | CALL_EXT | siMain.SetMergeRange | (0, category_idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be4c15cb | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:922 | if (monthInfo != null) | CALL_EXT | siMain.SetMergeRange | (category_idx + 1, ((siMain.GetMaxColumnIndex() - siMain.DayWeekMonthPartCount) - category… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8e29244 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:924 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.RefreshHeaderOnly

진입점: this.Load [try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4239a19c | this.Load [try] 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1031 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-e0d1a8ec | this.Load [try] 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1032 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-68c27cb7 | this.Load [try] 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1033 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75eb8175 | this.Load [try] 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1034 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e6cc70c | this.Load [try] 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1035 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e122ea0 | this.Load [try] 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1040 | else of (monthInfo == null) ▸ if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5f5bd017 | this.Load [try] 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:1043 | else of (monthInfo == null) ▸ if (siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b943f1a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3149 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d7270dc5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3170 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-efbfd326 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3188 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec290fd3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 5 | FP00641_Cell_Simulation_Cell_Pack.cs:3222 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-230e589b | popSql.OnSql | FP00641_Cell_Simulation_Cell_Pack.cs:3669 | if (programID == "PR_UI_FP00641_CELL_SIMULATION_CELL_PACK") ▸ if (FilterValidation() == false) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6c03dbcf | popSql.OnSql | FP00641_Cell_Simulation_Cell_Pack.cs:3671 | if (programID == "PR_UI_FP00641_CELL_SIMULATION_CELL_PACK") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-a72d070f | popSql.OnSql | FP00641_Cell_Simulation_Cell_Pack.cs:3673 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62a24d6a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1482 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ad5adf03 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1487 |  | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2bf78a41 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1499 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Save_Data_Amend

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_result) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e5be001 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2516 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE") ⇒ FP_Planning.PR_UI_FP00621_AMEND_LINE_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-07a46371 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2517 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4130ef03 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2519 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-9fdf9896 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2520 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-7eff1bd5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2521 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a1c5b242 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2522 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7071dc19 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2523 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b9a41064 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2524 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-47877ca4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2525 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-6cd4841d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2526 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-1614adf8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2527 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d30e345 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2528 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-865fc76c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2529 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-8869479c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2530 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-3335ef26 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2531 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b49a2a6f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2532 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd48ed76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2533 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a443a7fc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2534 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-6158cc99 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2535 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-99bcbe3d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2536 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-feed3882 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2537 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-5a0a9f7d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2538 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-5fb43975 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2539 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_location"] | p_location | 행/컬럼 값 대입 |  |  |  |
| AC-ddd5b2df | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2540 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-32894a19 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2541 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_customer_id"] | p_customer_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa40dd46 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2542 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_cell_group"] | p_cell_group | 행/컬럼 값 대입 |  |  |  |
| AC-b7746918 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2543 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6c522473 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2544 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-7dce0858 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2545 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shorter_lt_qty"] | p_shorter_lt_qty | 행/컬럼 값 대입 |  |  |  |
| AC-94f466d8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2546 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mpp_out_qty"] | p_mpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-ffbb9746 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2547 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_wpp_out_qty"] | p_wpp_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-89d42992 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2549 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5dc68bf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2550 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-492f347c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2556 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2daf3e84 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2562 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Save_Data_Cell

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_result)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33b47506 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1921 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3604acc0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1943 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12229d9c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1944 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6c8bf0ea | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1950 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b83234f5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1951 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e240755 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1954 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-0ab1ba76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1955 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3639ed86 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1956 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b4296d1d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1976 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["ASSY_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-11ec6c97 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1985 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d9b47db | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1986 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-57d34e45 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1987 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e89c00d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1990 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcd07b0d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1991 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d100ee38 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1992 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-791f1a51 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1993 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d75c25b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1994 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c8264927 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1995 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7dc5991 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1996 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-597b8b5e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1997 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcf22f4a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1998 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f726467 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2001 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab8e6f14 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2002 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-36e64e51 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2003 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6b22304 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2005 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-520ff3f8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1983 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-c144ecc6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2035 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-6deb1b76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2036 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-a905ac52 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2037 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-c13d42f0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2051 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ee9a6775 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2055 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d7cac5b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2057 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-a666d962 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2058 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-4a1f7550 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2059 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0b580f5a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2060 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-350f9565 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2062 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-933a525a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2063 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7f9738b4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2064 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56a134ec | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2065 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-58fb5bfe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2066 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-71a3069d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2067 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-24fe7791 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2068 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e62e35cc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2069 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-17f5432d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2070 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LOCATION"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-c097a219 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2071 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-26b8256c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2072 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c341ebb8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2073 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["CELL_ASSY_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc426082 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2074 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-600c186c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2075 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-6b16d3ef | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2076 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-3a642beb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2077 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-53abea5c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2078 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2cbbdefb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2079 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["VERSION"] | enum_row_from_Saving["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-714aa9ed | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2080 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLM_EC_NO"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-e637f2d3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2082 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-13e9fb3e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2090 | try ▸ if (dt.Rows.Count < 1) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-146abf9e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2093 | try ▸ if (dt.Rows.Count < 1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0c98a045 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2112 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ee026ac1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2116 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-71752dfa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2117 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0fba0e24 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2122 | try | DATA_OP | BohSet["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-15a70e12 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2123 | try | DATA_OP | BohSet["MASTER_ID"] | Filter["ASSY_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9deafa08 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2124 | try | DATA_OP | BohSet["PLAN_ID"] | Filter["ASSY_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-61b7de93 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2125 | try | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-1f1bc77d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2133 | try | UI_PROP | amend.ShopType | ShopType.ASSY | 속성 ShopType 설정 |  |  |  |
| AC-ac0250c2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2134 | try | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-24d56873 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2135 | try | UI_PROP | amend.SaveType | SaveType.SAVE | 속성 SaveType 설정 |  |  |  |
| AC-c4b1cf28 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2136 | try | UI_PROP | amend.dtSaveData | objDs | 속성 dtSaveData 설정 |  |  |  |
| AC-4e40a7ed | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2137 | try | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-43eb3511 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2138 | try | UI_PROP | amend.Filter | Filter | 속성 Filter 설정 |  |  |  |
| AC-5cc50fca | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2139 | try | UI_PROP | amend.PlanId | GetFilter("ASSY_PLAN_ID") | 속성 PlanId 설정 |  |  |  |
| AC-d67c54c0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2140 | try | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3c42a25 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2141 | try | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-bef5bae8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2148 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-25e4d0c5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2153 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3063c395 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2155 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Save_Data_Form

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_result)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dbd956e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2164 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-18047062 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2175 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b8b04c36 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2176 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5caf8af5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2181 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4ff7a6b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2194 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8116d401 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2201 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-f5851ca9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2202 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d044334e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2203 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2d5723b6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2236 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-525f78aa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2237 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a507dfe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2238 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4c9a0d6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2239 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c318903 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2240 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5eb5013c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2241 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-56b11a43 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2242 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-704a525e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2243 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ebbd5f0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2244 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae7ec659 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2245 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-70f27650 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2246 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b6c4001 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2247 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1dc80b4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2248 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-df081ef4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2234 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("PLAN_… |  | 처리 중단/반환 |  |  |  |
| AC-a53ebc48 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2281 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-c7bfe6a4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2282 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-8b2c7a25 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2283 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-64fd5be4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2295 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f520bb87 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2297 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3792fc9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2298 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-e28ea3dd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2299 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-e2530b23 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2300 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-696b8316 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2301 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2db7da3a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2302 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef31363f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2303 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-83e30a87 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2304 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8306d818 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2305 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa5522d3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2306 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2be4a83e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2307 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b526f5a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2308 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["CELL_ASSY_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cee34510 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2309 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-81f809bd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2310 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LOCATION"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-86129376 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2311 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-48675fa6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2312 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a4a768d5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2313 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-3524d725 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2314 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CUSTOMER_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-d7c73263 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2315 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d54e23af | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2316 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-d10df6f7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2317 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-f2f647a9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2318 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-230d370f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2319 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c8531d4c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2322 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-91d87647 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2332 | try ▸ if (dt.Rows.Count < 1) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dd975d3d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2335 | try ▸ if (dt.Rows.Count < 1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-07baa4cb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2345 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8d1895ab | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2349 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-ae132627 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2350 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-afb4e7e8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2375 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ lambda ▸ if (!bRtn1) | CALL_BASE | this.Invoke | (new System.Action(delegate () { MessageService.CloseProgress(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6fe9289 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2377 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ lambda ▸ if (!bRtn1) ▸ lambda | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1d3f1b17 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2379 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ lambda ▸ if (!bRtn1) | MESSAGE | MessageBox.Show | ("EXEC_PR_PARALLEL_A is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Info… | 메시지 표시 |  |  |  |
| AC-56c3fb25 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2386 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") | CALL_EXT | modalThread.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d510f357 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2387 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") | CALL_EXT | System.Threading.Thread.Sleep | (500) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3057d0df | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2393 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ lambda ▸ if (!bRtn2) | CALL_BASE | this.Invoke | (new System.Action(delegate () { MessageService.CloseProgress(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1936d01 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2395 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ lambda ▸ if (!bRtn2) ▸ lambda | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-db194025 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2397 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ lambda ▸ if (!bRtn2) | MESSAGE | MessageBox.Show | ("EXEC_PR_PARALLEL_B is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Info… | 메시지 표시 |  |  |  |
| AC-ae2f48cd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2400 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") | CALL_EXT | modalThread2.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a439296 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2401 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") | CALL_EXT | modalThread2.Wait | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d5e54b7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2404 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-40486819 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2406 | try ▸ if (ds2 != null) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-178f7aa6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2414 | try ▸ if (!string.IsNullOrEmpty(sError)) | MESSAGE | MessageBox.Show | (sError, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2af77ab1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2416 | try ▸ if (!string.IsNullOrEmpty(sError)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cfdbb6bf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2423 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2bf21049 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2428 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5a064b50 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:2430 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ceca3c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2629 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Save_Data_Pack

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_result)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b552509c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1701 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18cbfd35 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1702 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-71847cab | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1708 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ff0d9da1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1711 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-02e3d1b2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1717 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-efb13278 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1718 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-188dee62 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1719 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-640ca674 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1738 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PACK_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-783184ab | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1747 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b79c3a2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1748 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-35bff8f6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1749 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c161ff5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1752 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5da45658 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1753 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-71ce0c13 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1754 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb81e667 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1755 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-773ef75e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1756 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2df9a32 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1757 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-64d60642 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1758 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-bdb43824 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1759 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0be153de | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1760 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-15d7c28a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1763 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab96c0ef | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1765 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d6da1ad | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1745 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-73d0e88f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1791 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-62c50948 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1796 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-c6e91b48 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1797 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-17355407 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1798 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-500a98f1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1812 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f045d33 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1816 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-58f59f1a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1818 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-f3115f0b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1819 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-0588c080 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1820 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9aa6effd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1821 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8203d316 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1823 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a7d80ff6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1824 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-563ba992 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1825 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07d837c7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1826 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3fe51016 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1827 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0265dfbc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1828 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eb5f318d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1829 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b5895d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1830 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-85f47c02 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1831 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LOCATION"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b62ebefe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1832 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-38b04789 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1833 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["PACK_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8f165a6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1834 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["PACK_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52270890 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1835 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-48079736 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1836 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-201dc0eb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1837 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-cb2cb8b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1839 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-9322e5d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1840 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0002440c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1842 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5859a0f9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1852 | try ▸ if (dt.Rows.Count < 1) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a0f72181 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1855 | try ▸ if (dt.Rows.Count < 1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-836d8082 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1872 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-84001d77 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1876 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-4b715a11 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1877 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-de199365 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1881 | try | DATA_OP | BohSet["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-54b6c8ff | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1882 | try | DATA_OP | BohSet["MASTER_ID"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-82b04c3e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1883 | try | DATA_OP | BohSet["PLAN_ID"] | Filter["PACK_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6179d707 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1884 | try | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-e482d234 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1892 | try | UI_PROP | amend.ShopType | ShopType.PACK | 속성 ShopType 설정 |  |  |  |
| AC-63544af1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1893 | try | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-17b42d16 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1894 | try | UI_PROP | amend.SaveType | SaveType.SAVE | 속성 SaveType 설정 |  |  |  |
| AC-b52fb67e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1895 | try | UI_PROP | amend.dtSaveData | objDs | 속성 dtSaveData 설정 |  |  |  |
| AC-3e2547c8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1896 | try | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-cd0d18cc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1897 | try | UI_PROP | amend.Filter | Filter | 속성 Filter 설정 |  |  |  |
| AC-8bc1ed88 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1898 | try | UI_PROP | amend.PlanId | Filter["PACK_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-feba86f6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1899 | try | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc2b0c3f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1901 | try | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-b1e46b26 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1907 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-847c9df5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1908 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1dc462a0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1912 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.Save_Data_Sim

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21d3c8ab | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1512 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-527bdc63 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1513 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e43c8efe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1519 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-454f8a98 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1522 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf7d7c82 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1528 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-30007de0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1529 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8f477c0c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1530 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-da27fccb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1549 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PACK_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7244d15f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1558 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-96bc53bc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1559 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4bdd6ed6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1561 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-339137d0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1562 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-71875f29 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1563 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d03d4cbf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1564 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c06fb9e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1565 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bec892c1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1566 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-70939c77 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1567 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7b77544 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1556 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-605b760a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1593 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e763d76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1598 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["SALES_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-bb57a518 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1599 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-93b32f78 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1613 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c788bdc9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1615 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-59540820 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1616 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-172e1a58 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1618 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | "SHIPMENT_SIMUL" | 행/컬럼 값 대입 |  |  |  |
| AC-83966996 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1619 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bee8652b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1620 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7c29e98 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1621 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d04747c5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1622 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8be7287 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1623 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-d2f199e5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1624 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["PACK_GROUP_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c7abbba0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1625 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SALES_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-fdf801cd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1626 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-efc69e01 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1627 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-10e8a724 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1629 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-76d7574b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1639 | try ▸ if (dt.Rows.Count < 1) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b10187ae | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1642 | try ▸ if (dt.Rows.Count < 1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0fba1e41 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1649 | try | DATA_OP | saveDs.Tables.Add | (objDs) | 데이터 객체 조작/조회 |  |  |  |
| AC-1db3f156 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1651 | try | DATA_OP | saveDs.Tables[0].Columns.Contains | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-10104ef9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1653 | try ▸ if (!saveDs.Tables[0].Columns.Contains("SEQ")) | DATA_OP | saveDs.Tables[0].Columns.Add | (new DataColumn("SEQ", typeof(int))) | 데이터 객체 조작/조회 |  |  |  |
| AC-80a3ebd4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1656 | try ▸ if (!saveDs.Tables[0].Columns.Contains("SEQ")) ▸ foreach (DataRow dr in saveDs.Tables[0].Rows) | DATA_OP | dr["SEQ"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ec5b7ad1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1665 | try ▸ if (saveDs.Good()) ▸ foreach (DataRow ro in saveDs.Tables[0].Rows) ▸ if (ro.RowState == DataRowState.Unchanged) | CALL_EXT | ro.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-27ceeb76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1669 | try | ENDPOINT | DataService.FP_UpdateBatch | ("FP00641_Cell_Simulation_Cell_Pack", "merge_shipment", saveDs, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_shipment] \| FP\Planning\F… | 엔드포인트 호출 |  |  |  |
| AC-cf64c021 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1677 | try | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-9ee5e190 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1683 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-77a1619a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1684 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fb3d318c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00641_Cell_Simulation_Cell_Pack.cs:1688 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fa2a49c | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:1468 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-28781041 | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:1469 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1fef7249 | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:1472 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad56e18a | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:1475 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f64cece6 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4296 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de790014 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2659 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a19603ad | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2660 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-64309f34 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2665 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-e637b66d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2671 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d594781d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2672 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c1867a8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2673 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-767d801c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2674 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe4241b5 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2675 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f14944d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2676 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1b6cfb2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2677 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6584ff66 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2678 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-23a583c2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:2682 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetChangeControl

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c25780a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:405 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f055a6c4 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11995 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (!dtSite.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3ced0e0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11995 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (!dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0fc9483f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11999 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetColumnsFormat

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e650b6d7 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:949 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExcel… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc7bc814 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:951 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (for… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-87f9b9be | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:954 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68dd4a0e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:978 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExc… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2eb3ab7 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:980 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (f… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d11de236 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:983 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15c3fe80 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:1009 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forE… | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5dc3b9bf | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:1011 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of … | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c52906a3 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00641_Cell_Simulation_Cell_Pack.cs:1014 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (iRoundPoint, sColFormat, colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6aa580d | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:176 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88e0255f | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:178 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-de104321 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:182 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b1fa5592 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:184 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-fb64cd43 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:185 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-044f1dd7 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:187 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b97e6f45 | this.Load | FP00641_Cell_Simulation_Cell_Pack.cs:191 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetDirty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0e7565c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 4 | FP00641_Cell_Simulation_Cell_Pack.cs:11450 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetFilter

진입점: this.Load [if (_TYPE == "CELL") ▸ if (!dtPlanner_Cell.Good() \|\| dtPlanner_Cell.Rows.Count < 0)] / cbo_site.SelectedIndexChanged [if (_TYPE == "CELL") ▸ if (!dtPlanner_Cell.Good() \|\| dtPlanner_Cell.Rows.Count < 0)] / range_plan.ValueChanged [if (gap.Days > 365)] / txt_pack_code.TextChanged / txt_cell_code.TextChanged / txt_pack_nick.TextChanged / txt_cell_nick.TextChanged / txt_group_cell.TextChanged / mcbo_planner_Cell.SelectedIndexChanged / mcbo_planner_Pack.SelectedIndexChanged / mcbo_planner_Form.SelectedIndexChanged / chk_allLine_Cell.CheckedChanged / chk_allLine_Pack.CheckedChanged / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84671713 | this.Load [if (_TYPE == "CELL") ▸ if (!dtPlanner_Cell.Good()… 외 16 | FP00641_Cell_Simulation_Cell_Pack.cs:3322 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetMemoCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5f33060 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4971 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-321bc6b0 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4971 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74a4db42 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4975 | if (dlData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b03e8ca | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4996 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-f058efac | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:4998 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | bcell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-6448f13c | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5012 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | bcell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-42d92743 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5016 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | bcell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-0c9b1861 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5020 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | bcell.Font | 속성 Font 설정 |  |  |  |
| AC-e8ab6786 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5027 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | bcell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-1717e7ec | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5031 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | bcell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-7edd1647 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:5035 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | bcell.Font | 속성 Font 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetPlanOutCell

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fece47f5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5250 | if (EditingCol != cCol) | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-f63f2621 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5276 | if (EditingCol != cCol) ▸ try ▸ if (dlData != null) | UI_PROP | dlData.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-735893ed | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5277 | if (EditingCol != cCol) ▸ try ▸ if (dlData != null) | UI_PROP | dlData.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-8945a353 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5281 | if (EditingCol != cCol) ▸ try ▸ if (dlView != null) | UI_PROP | dlView.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-70343207 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5282 | if (EditingCol != cCol) ▸ try ▸ if (dlView != null) | UI_PROP | dlView.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-66f883d4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5291 | if (EditingRow != cRow) | FLAG | EditingRow | cRow | 화면 필드/플래그 변경 |  |  |  |
| AC-3b263f9d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5294 | if (EditingRow != cRow) ▸ if (dsMain.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fb1fa55 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5294 | if (EditingRow != cRow) ▸ if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17bbd378 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5298 | if (EditingRow != cRow) ▸ if (dsMainFiltered.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMainFiltered, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee7ba6e6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5298 | if (EditingRow != cRow) ▸ if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMainFiltered, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7f6ca86 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5303 | if (dlData == null \|\| dlView == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetPlanOutCellRaw

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (sInputMode.Equals("N"))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b0570a8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5317 | if (!dsMainFiltered.Good() \|\| clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea99ae91 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5353 |  | CALL_EXT | Math.Sign | (delta) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2653e685 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5380 | if (adDefDate == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6cd30b73 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5411 | if (dgEditDataTable == null) | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7dce0c62 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5412 | if (dgEditDataTable == null) | DATA_OP | ds.Tables.Add | (dgEditDataTable) | 데이터 객체 조작/조회 |  |  |  |
| AC-d06a04cf | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5420 | else of (dgEditDataTable == null) ▸ else of (dgEditDataTable.DataSet != null) | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f67a67f2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5421 | else of (dgEditDataTable == null) ▸ else of (dgEditDataTable.DataSet != null) | DATA_OP | ds.Tables.Add | (dgEditDataTable) | 데이터 객체 조작/조회 |  |  |  |
| AC-a637a2fe | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5439 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-15ae86b8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5440 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9689bf1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5441 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d3b4846 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5442 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2a5664b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5443 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-52dbbc56 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5444 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c34964ff | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5445 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e98fcf1e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5446 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1a4bfd6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5447 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-783ad70b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5448 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-acf0c498 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5437 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == sFact && x.Field<string>("LOCATION") =… |  | 처리 중단/반환 |  |  |  |
| AC-c8934f43 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5461 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | dgEditDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aebb25f7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5462 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["INSTANCE_ID"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-53baf03a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5463 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["FP_PLAN_ID"] | Filter["PACK_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dd0c97e4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5464 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-bc38758c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5465 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-8119a4c6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5466 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-aa383fc6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5467 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-32d3b7b4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5468 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-75270065 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5469 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-9338a1da | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5470 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-b081b0d8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5471 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-f5e9908a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5472 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-902d9e1d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5473 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["ITEM_ID"] | sPtem | 행/컬럼 값 대입 |  |  |  |
| AC-94022e7d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5474 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["TOP_ITEM_ID"] | sPtem | 행/컬럼 값 대입 |  |  |  |
| AC-3bb14be8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5475 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-18a8acb7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5476 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-dc7f8ed2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5477 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["ITEM_TYPE"] | sType | 행/컬럼 값 대입 |  |  |  |
| AC-b8e1897d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5478 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-39444b74 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5479 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-4034397c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5480 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ else of (relating_rows.Count() > 0) | DATA_OP | dgEditDataTable.Rows.Add | (new_row) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf68a5ac | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5486 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | editorCurrentRow["OUT_QTY"] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-19e344d2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5487 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | editorCurrentRow["ORG_QTY"] | org_value | 행/컬럼 값 대입 |  |  |  |
| AC-aad009e9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5492 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | clicked_row[adDefDate.Value] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-f3237906 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5503 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-26f0c21d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5507 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-de19620e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5511 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-70ff2eaf | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5515 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-b6f2c877 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5519 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-a85c4d5a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5562 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bShip) ▸ if (rowEoh.Length … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEoh + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-017f3eef | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5571 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bShip) ▸ if (rowEohGood.Len… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGood + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-724ced31 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5580 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bShip) ▸ if (rowEohSim.Leng… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohSim + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-f2c5d9b7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5589 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bShip) ▸ if (rowEohGoodSim.… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodSim + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-7c3afc41 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5599 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (rowEohGoodUnhold.Length > 0… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodUnhold + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-c78b7c31 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5628 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-1e5208f2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5631 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-7ff228b5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5634 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-bc122044 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5637 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-da76983f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5640 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-4c109aa7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5643 | if (true) ▸ if (sCate == "PACK_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-c53f2565 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5680 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (rowEohForm.Length > 0) | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEoh + (lvn_shipping_plan * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-8efc88ca | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5689 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (rowEohGoodForm.Length > 0) | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGood + (lvn_shipping_plan * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-ecad1bba | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5698 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (rowEohFormGroup.Length > 0) | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGroup + (lvn_shipping_plan * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-9b489e27 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5707 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (rowEohGoodFormGroup.Length … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodGroup + (lvn_shipping_plan * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-eb0d06cf | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5716 | if (true) ▸ if (sCate == "PACK_P_OUT") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (rowEohGoodUnholdFormGroup.L… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodUnholdGroup + (lvn_shipping_plan * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-fb720cc0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5751 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bfd782f4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5752 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3ada2e8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5753 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-29f23ee2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5754 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-90dd9bd2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5755 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-95970689 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5756 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b78e252e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5757 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-761b53f3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5758 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9f06430 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5759 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-adaead8d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5760 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-6197d97a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5749 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == sFact && x.Field<string>("LOCATION") =… |  | 처리 중단/반환 |  |  |  |
| AC-35fb5ea6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5773 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | dgEditDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4d2ae5a3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5774 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["INSTANCE_ID"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-83390a23 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5775 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["FP_PLAN_ID"] | Filter["PACK_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8123c5b0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5776 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-2ee273bb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5777 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-3df98a75 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5778 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-51ed7a2e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5779 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-47eb000f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5780 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-9101c399 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5781 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-26a1bb52 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5782 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-8faaad84 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5783 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-dc32435a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5784 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-4f523603 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5785 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["ITEM_ID"] | sPtem | 행/컬럼 값 대입 |  |  |  |
| AC-c34ebf32 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5786 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["TOP_ITEM_ID"] | sPtem | 행/컬럼 값 대입 |  |  |  |
| AC-05eb0ead | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5787 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-1d90f19e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5788 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-8ad9c7fd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5789 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["ITEM_TYPE"] | sType | 행/컬럼 값 대입 |  |  |  |
| AC-92b4aba8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5790 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-a4a553ff | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5791 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | new_row["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-6cd41fc5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5792 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (relating_rows.Count() > 0) | DATA_OP | dgEditDataTable.Rows.Add | (new_row) | 데이터 객체 조작/조회 |  |  |  |
| AC-348fa77a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5798 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | editorCurrentRow["OUT_QTY"] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-593d277e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5799 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | editorCurrentRow["ORG_QTY"] | org_value | 행/컬럼 값 대입 |  |  |  |
| AC-4ca3fe36 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5807 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | clicked_row[adDefDate.Value] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-f84c4ff1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5811 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-2d0aae96 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5815 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-3b70f41f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5819 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-3a5f3143 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5823 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-644ba9a6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5827 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND PACK_GROUP_CODE =… | 데이터 객체 조작/조회 |  |  |  |
| AC-47ebf7e1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5893 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsW… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohSim + (delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-b5092e8c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5902 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsW… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodSim + (delta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-67385277 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5925 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ if (sCate == "PACK_S_SHIPPING_SIM") ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsW… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingShippingGap + (delta) | 그리드 속성/값 설정 |  |  |  |
| AC-b74675f3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5962 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-99417d09 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5963 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-164a05c7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5964 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d7a6e8e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5965 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd692321 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5966 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c80a985b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5967 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-08dc8f98 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5968 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6df3bf4b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5969 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-be712b61 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5970 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-79eafe23 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5971 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-047dc324 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5972 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f902e85e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5960 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sFact && x.Field<string>("SITE_ID") =… |  | 처리 중단/반환 |  |  |  |
| AC-5538bb63 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5985 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | dgEditDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-266a3e58 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5986 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bf40f125 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5987 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["FP_PLAN_ID"] | Filter["FORM_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-11c12748 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5988 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-685abde4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5989 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-64ed3f8a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5990 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-5441a4da | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5991 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-e90b3ced | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5992 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-e4cb5a61 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5993 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-ffde68f2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5995 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["ITEM_ID"] | sCtem | 행/컬럼 값 대입 |  |  |  |
| AC-287301ba | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5996 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["TOP_ITEM_ID"] | sCtem | 행/컬럼 값 대입 |  |  |  |
| AC-000ff029 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5997 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-ff3ea6ab | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5998 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-84292a45 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:5999 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-fcd4c0d7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6000 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-a33ed6c1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6001 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-37e21d5b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6002 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-d7c10cf3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6004 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | new_row["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-1ed87770 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6005 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ else of (relating_rows… | DATA_OP | dgEditDataTable.Rows.Add | (new_row) | 데이터 객체 조작/조회 |  |  |  |
| AC-8feed921 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6011 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | editorCurrentRow["OUT_QTY"] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-d6742357 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6012 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | editorCurrentRow["ORG_QTY"] | org_value | 행/컬럼 값 대입 |  |  |  |
| AC-9aa8cfdd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6017 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | clicked_row[adDefDate.Value] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-cc340dd1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6025 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dtAgingYield.Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND LINE_ID = '" + row["LINE_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-b7852606 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6036 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-452bcffe | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6041 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-fc675693 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6046 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-4b708eb9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6050 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-2494bb8b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6054 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-30f9c827 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6057 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-8e3e535f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6060 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-bbb6acbe | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6063 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") | DATA_OP | dsMain.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'FO… | 데이터 객체 조작/조회 |  |  |  |
| AC-e5258e28 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6133 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingActivated + (tempDelta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-34af86a4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6150 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingActivated + (tempDelta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-0f915828 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6173 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingActivatedBoh + (tempDelta * -1) | 그리드 속성/값 설정 |  |  |  |
| AC-b743c883 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6183 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEoh + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-ac68766e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6192 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGood + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-11c82db4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6201 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGroup + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-ebf970bc | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6210 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodGroup + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-55484b7b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6219 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodUnholdGroup + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-01132359 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6230 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ if (sCate == "FORM_P_OUT") ▸ while (!string.IsNullO… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingPlanOutGroup + (delta * 1) | 그리드 속성/값 설정 |  |  |  |
| AC-32c43398 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6275 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e1b9a14 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6276 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8d53f27 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6277 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb16b052 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6278 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-151e9124 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6279 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fd76683 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6280 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-37b67769 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6281 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-566247de | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6282 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-df11c7a2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6283 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-79d7293d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6285 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcbb0cf9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6286 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbaa4b9e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6287 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0a7b3e5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6289 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-10fbb11e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6273 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | RETURN | return ( x.Field<string>("DIVISION_ID") == sFact && x.Field<string>("SITE_ID") =… |  | 처리 중단/반환 |  |  |  |
| AC-6a373a98 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6302 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dgEditDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6104b55b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6303 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-add0eab1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6304 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["FP_PLAN_ID"] | Filter["FORM_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b690c191 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6305 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-1e1be4d4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6306 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-562743e7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6307 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-1c1b2184 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6308 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-eded0c80 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6309 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-f359b5fb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6310 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-201a6d5c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6312 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["ITEM_ID"] | sCtem | 행/컬럼 값 대입 |  |  |  |
| AC-5639952c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6313 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["TOP_ITEM_ID"] | sCtem | 행/컬럼 값 대입 |  |  |  |
| AC-c9c5058b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6314 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-21c5612b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6315 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-5e066eb8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6316 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-c0750979 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6317 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-5cdcf008 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6318 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-93f4b642 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6319 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-16fe9d24 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6321 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["ITEM_TYPE"] | sType | 행/컬럼 값 대입 |  |  |  |
| AC-bcf02e90 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6322 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | new_row["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-a0b7e0e8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6323 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dgEditDataTable.Rows.Add | (new_row) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae0d8951 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6329 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | editorCurrentRow["OUT_QTY"] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-502d030f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6330 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | editorCurrentRow["ORG_QTY"] | org_value | 행/컬럼 값 대입 |  |  |  |
| AC-c1030714 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6364 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | clicked_row[adDefDate.Value] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-aea27ef0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6382 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dtAgingLT.Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND LINE_ID = '" + row["LINE_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-6aac5684 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6390 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | CALL_EXT | Convert.ToInt16 | (rowLT[0]["STANDARD_LT"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c251815 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6391 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | CALL_EXT | Convert.ToInt16 | (rowLT[0]["STANDARD_LT_SUM"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aecb19f2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6394 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dtAgingYield.Select | ("FACTORY_ID = '" + row["FACTORY_ID"].ToString() + "'" + " AND LINE_ID = '" + row["LINE_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-457d57eb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6434 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-468de79b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6439 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-bcfdc7c7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6444 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-80eecc06 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6449 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-cc218f39 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6454 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-b58f9b46 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6459 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-8fa5015e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6464 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-cf3a0227 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6469 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-ec4c3ba8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6474 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-2f2d9f68 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6479 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CELL_ITEM_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-1b920306 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6484 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'CE… | 데이터 객체 조작/조회 |  |  |  |
| AC-49a8c6d6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6487 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | DATA_OP | dsMainFiltered.Tables[0].Select | ("CELL_GROUP_CODE = '" + row["CELL_GROUP_CODE"].ToString() + "'" + " AND CATEGORY_ID = 'CE… | 데이터 객체 조작/조회 |  |  |  |
| AC-4858ff8d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6500 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | CALL_EXT | n_col.Replace("D", "").ToSafeInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e157797 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6578 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEoh + delta | 그리드 속성/값 설정 |  |  |  |
| AC-07a88908 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6587 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGood + delta | 그리드 속성/값 설정 |  |  |  |
| AC-e8932d81 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6596 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGroup + delta | 그리드 속성/값 설정 |  |  |  |
| AC-41677781 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6605 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingEohGoodGroup + delta | 그리드 속성/값 설정 |  |  |  |
| AC-25ee6fba | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6620 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingBD + (delta) - beforeDelta | 그리드 속성/값 설정 |  |  |  |
| AC-485eb01b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6636 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingBDBoh + (boh_delta_bd) - boh_beforeDelta | 그리드 속성/값 설정 |  |  |  |
| AC-01b82cc1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6653 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingAD + beforeDeltaYield - afterDeltaYield | 그리드 속성/값 설정 |  |  |  |
| AC-4a153bf4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6667 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingADBoh + boh_beforeDeltaYield - boh_afterDeltaYield | 그리드 속성/값 설정 |  |  |  |
| AC-88dcab09 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6674 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | tempBD + tempAD | 그리드 속성/값 설정 |  |  |  |
| AC-561ad1e4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6681 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | tempBDBoh + tempADBoh | 그리드 속성/값 설정 |  |  |  |
| AC-8913b59c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6696 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingActivated + afterDeltaActivate | 그리드 속성/값 설정 |  |  |  |
| AC-61c34738 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6708 | if (true) ▸ else of (sCate == "PACK_P_OUT") ▸ else of (sCate == "PACK_S_SHIPPING_SIM") ▸ else of (sCate == "FORM_P_OUT") ▸ if (sCate == "CEL… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingActivatedBoh + afterDeltaActivateBoh | 그리드 속성/값 설정 |  |  |  |
| AC-26ea99f5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6729 |  | LIST_BIND | dgEditPack.DataSource | dgEditDataTable | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-6e4b94cb | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:6730 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetReleaseProcess

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a537929b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:3123 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-af77ef2f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:3132 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ if (row_Date < curr_Date) | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-1483dfd3 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:3136 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ else of (row_Date < curr_Date) | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SetSpreadInit

진입점: this.Load [try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46a9c44e | this.Load [try] 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:831 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-491c5a32 | this.Load [try] 외 2 | FP00641_Cell_Simulation_Cell_Pack.cs:832 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1153192 | this.spdMain.ButtonClicked | FP00641_Cell_Simulation_Cell_Pack.cs:11444 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e6547ee | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11819 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-2002a437 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11820 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-9ff5f480 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11822 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-0048b152 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11841 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-e96e927f | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11842 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-dd7890ff | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11844 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb42f16a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11858 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-c9f6003d | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11859 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-ae9bc070 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11861 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b717437 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11870 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-4f9d6121 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11871 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-ceebd938 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11873 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-df977402 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11877 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | VALUE_SET | nlfamend_menu.Text | "NLF Amend" | 컨트롤 값 설정 |  |  |  |
| AC-b49f827a | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11878 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | UI_PROP | nlfamend_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-370882c8 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11880 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered != null && dsMainFiltered.Tables != null && dsMainFiltered.Table… | DATA_OP | m.MenuItems.Add | (nlfamend_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-b66a9390 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11888 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_CellClick2

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd7cf8ed | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10556 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91548901 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10575 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Column >= froz) | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-0c89eb70 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10576 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Column >= froz) | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-380c15b8 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10578 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Column >= froz) | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-e22c4512 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10585 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Column >= froz) ▸ if (colname.St… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-e6a69e59 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10586 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Column >= froz) ▸ if (colname.St… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-b2d25198 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10588 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Column >= froz) ▸ if (colname.St… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-b767a8c1 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10600 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ if (row["… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-6b670442 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10601 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ if (row["… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-4bcbaa40 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10603 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ if (row["… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-fda47335 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10612 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-498b0e76 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10613 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-67205804 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10615 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-a688a45d | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10619 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ else of (… | VALUE_SET | nlfamend_menu.Text | "NLF Amend" | 컨트롤 값 설정 |  |  |  |
| AC-e2f87baf | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10620 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ else of (… | UI_PROP | nlfamend_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-976fef42 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10622 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (e.Column >= froz) ▸ else of (… | DATA_OP | m.MenuItems.Add | (nlfamend_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-c955c2a6 | spdMain.CellClick | FP00641_Cell_Simulation_Cell_Pack.cs:10630 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2de3f731 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11478 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-749e6883 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11487 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-17abac2b | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11489 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_plan_group", Filter["FORM_INSTANCE_ID"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-791fcf3a | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11490 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "dp_plan_date", Filter["PLAN_DATE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-18a6f853 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11491 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_planid", Filter["FORM_PLAN_ID"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9399c0a0 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11492 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_division", clicked_row["DIVISION_ID"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f79b1c7b | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11493 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_site", clicked_row["SITE_ID"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-905dd041 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11494 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "mcbo_plant", clicked_row["PLANT_ID"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19ce41a3 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11497 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_EXT | BaseForm.SetManualCondition | (Msc, "rp_plan_period", Filter["BUCKET_FROM"] + "-" + Filter["BUCKET_TO"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb839630 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11499 | if (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | CALL_BASE | openSubMenu | ("FP00634", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9734a9fe | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11502 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) ▸ if (sColName.IndexOf("_QTY") < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b752036b | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11506 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4a8c0d7 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11507 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-37186050 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11508 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0d3309d | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11509 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["PLANT_ID"] | clicked_row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d616e8c4 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11511 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["GROUP_CELL_CODE"] | clicked_row["CELL_GROUP_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87806794 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11512 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["CELL_ITEM_ID"] | clicked_row["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c3dba053 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11513 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["PACK_ITEM_ID"] | clicked_row["PACK_GROUP_CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81b4b427 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11514 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["SHOP_TYPE"] | clicked_row["SHOP_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-773011b3 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11515 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["BUCKET_FROM"] | Filter["BUCKET_FROM"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f289d04 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11516 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["BUCKET_TO"] | Filter["BUCKET_TO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a9ef10d2 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11517 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["ITEM_IN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b99987e5 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11518 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter["GROUP_CELL_YN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-9b61faec | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11549 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) ▸ if (inputFilter["CELL_ITEM_ID"].ToString()… | DATA_OP | inputFilter["GROUP_CELL_YN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-cffb3e07 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11558 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | POPUP | new FP00641_InvDetail_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5fab3dcb | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11559 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f22d7c98 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11559 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f0e738 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11560 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-b0b68d76 | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11561 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-877c329d | this.spdMain.CellDoubleClick | FP00641_Cell_Simulation_Cell_Pack.cs:11562 | else of (sColName.Equals("CELL_ITEM_ID") && clicked_row["SHOP_TYPE"].ToString().Equals("FORM")) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae24330b | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11416 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f629124b | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11421 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | fps.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55457a8a | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11423 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cf1296c | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11424 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveColumnWith | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b91b5d09 | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11429 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreColumnWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2c662e7 | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11430 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a16a0ff | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11432 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | fps.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-888ee528 | this.spdMain.Change | FP00641_Cell_Simulation_Cell_Pack.cs:11437 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37d1bd6f | this.spdMain.ClipboardPasted | FP00641_Cell_Simulation_Cell_Pack.cs:11578 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f55db6a | this.spdMain.ClipboardPasted | FP00641_Cell_Simulation_Cell_Pack.cs:11586 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5def4625 | this.spdMain.ClipboardPasted | FP00641_Cell_Simulation_Cell_Pack.cs:11588 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8313a03e | this.spdMain.ClipboardPasted | FP00641_Cell_Simulation_Cell_Pack.cs:11589 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9278820c | this.spdMain.ClipboardPasted | FP00641_Cell_Simulation_Cell_Pack.cs:11590 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0f2eefe5 | this.spdMain.ClipboardPasted | FP00641_Cell_Simulation_Cell_Pack.cs:11593 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3233704d | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11599 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-2ec46954 | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11600 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-51287147 | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11600 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfe973fb | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11604 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-d71b8ad8 | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11604 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d95b482f | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11608 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-479f48c0 | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11609 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7db7f664 | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11610 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c5f4be87 | this.spdMain.ClipboardPasting | FP00641_Cell_Simulation_Cell_Pack.cs:11613 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_ColumnWidthChanged

진입점: this.spdMain.ColumnWidthChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f90288c | this.spdMain.ColumnWidthChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11466 | if (fp != null && fp.ActiveSheet != null && fp.ActiveSheet.ColumnHeader != null && fp.ActiveSheet.ColumnHeader.Columns != nu…) ▸ foreach (Fa… | DATA_OP | ColWidths.Keys.Contains | (col) | 데이터 객체 조작/조회 |  |  |  |
| AC-cee3261a | this.spdMain.ColumnWidthChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11468 | if (fp != null && fp.ActiveSheet != null && fp.ActiveSheet.ColumnHeader != null && fp.ActiveSheet.ColumnHeader.Columns != nu…) ▸ foreach (Fa… | DATA_OP | ColWidths.Add | (col, col.Width) | 데이터 객체 조작/조회 |  |  |  |
| AC-d73b42cc | this.spdMain.ColumnWidthChanged | FP00641_Cell_Simulation_Cell_Pack.cs:11471 | if (fp != null && fp.ActiveSheet != null && fp.ActiveSheet.ColumnHeader != null && fp.ActiveSheet.ColumnHeader.Columns != nu…) ▸ foreach (Fa… | DATA_OP | ColWidths[col] | col.Width | 행/컬럼 값 대입 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11e6827b | this.spdMain.EditModeOn | FP00641_Cell_Simulation_Cell_Pack.cs:11408 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d2ddc56 | this.spdMain.KeyDown | FP00641_Cell_Simulation_Cell_Pack.cs:10642 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-7ab8cc17 | this.spdMain.KeyDown | FP00641_Cell_Simulation_Cell_Pack.cs:10646 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8015c203 | this.spdMain.KeyDown | FP00641_Cell_Simulation_Cell_Pack.cs:10648 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe44fb21 | this.spdMain.KeyDown | FP00641_Cell_Simulation_Cell_Pack.cs:10650 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6cb6fb12 | this.spdMain.KeyDown | FP00641_Cell_Simulation_Cell_Pack.cs:10652 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.SwitchMemo

진입점: memo_menu.Click [if (day != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-703274d7 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11669 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c003102d | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11686 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-d35ac329 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11711 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1476a5d | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11715 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8c4ec08 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11715 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-703bbd74 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11737 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-7ca8dc16 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11739 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-5fd642ca | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11742 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6296e40a | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11744 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c057ba7f | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11744 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-96ad5ae8 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11745 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-e359c336 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11747 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-4ed002b2 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11749 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c21116e9 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11761 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f97d4ddd | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11761 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-400f2e08 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11781 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-c19597e2 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11782 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-f4324f77 | memo_menu.Click [if (day != null)] | FP00641_Cell_Simulation_Cell_Pack.cs:11784 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.tbNickName_BeforeOpenSearch

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b704630 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11112 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-29408e2b | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11113 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9db6ed2 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11114 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdc33ced | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11115 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-37ac20de | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11116 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 400) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e5aed49 | (진입점 미연결) | FP00641_Cell_Simulation_Cell_Pack.cs:11117 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.UIFindData

진입점: FindButton / SaveButton [if (save_success == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18fd4240 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1095 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca00ad03 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1096 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fb29b6b | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1099 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-782d9975 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1102 | try ▸ if (FilterValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee74dae9 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1121 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6aa9457b | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1134 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5f64a0e1 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1138 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1d2a075f | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1139 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fa44124c | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1143 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-816fe64d | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1156 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e0b7fb9c | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1158 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-afd3a801 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1158 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2340a098 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1163 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | LastTotalRaw | FindTotalValue() | 화면 필드/플래그 변경 |  |  |  |
| AC-f83e0199 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1170 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-3e7ddab6 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1178 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["PLAN_ID"… | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-dfffa350 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1183 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["PLA… | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a8e411c | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1227 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-792a29bd | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1232 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b426ba1a | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1234 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-34b4ec9b | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1243 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b860d03 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1247 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-47e36055 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1251 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8011b575 | FindButton 외 1 | FP00641_Cell_Simulation_Cell_Pack.cs:1253 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00641_Cell_Simulation_Cell_Pack.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7c82362 | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:3267 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-8480fa92 | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:3270 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-79f8ca06 | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:3277 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-ecdfb59c | SaveButton | FP00641_Cell_Simulation_Cell_Pack.cs:3281 | finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |

## FP00641_InvDetail_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67e4ee16 | (진입점 미연결) | FP00641_InvDetail_Popup.cs:333 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e11ff03d | (진입점 미연결) | FP00641_InvDetail_Popup.cs:336 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3864ecd2 | (진입점 미연결) | FP00641_InvDetail_Popup.cs:337 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00641_InvDetail_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fba88686 | this.Load | FP00641_InvDetail_Popup.cs:143 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5fd86f10 | this.Load | FP00641_InvDetail_Popup.cs:144 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed5202f6 | this.Load | FP00641_InvDetail_Popup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00641_InvDetail_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6526c15e | this.Load | FP00641_InvDetail_Popup.cs:138 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00641_InvDetail_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-947dc5ad | Dispose | FP00641_InvDetail_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00641_InvDetail_Popup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ff39d04 | ExcelButton | FP00641_InvDetail_Popup.cs:207 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00641_InvDetail_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c7471ab | this.Load [try ▸ lambda] 외 2 | FP00641_InvDetail_Popup.cs:266 | try | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP00641_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "INV_D… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-264b8d53 | this.Load [try ▸ lambda] 외 2 | FP00641_InvDetail_Popup.cs:298 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-44c89383 | this.Load [try ▸ lambda] 외 2 | FP00641_InvDetail_Popup.cs:302 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00641_InvDetail_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1864b1b8 | this.Load 외 2 | FP00641_InvDetail_Popup.cs:222 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5c440f05 | this.Load 외 2 | FP00641_InvDetail_Popup.cs:228 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8499165f | this.Load 외 2 | FP00641_InvDetail_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b2fa4213 | this.Load 외 2 | FP00641_InvDetail_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0ab0955b | this.Load 외 2 | FP00641_InvDetail_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-d7a280de | this.Load 외 2 | FP00641_InvDetail_Popup.cs:250 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-b1423b80 | this.Load 외 2 | FP00641_InvDetail_Popup.cs:256 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00641_InvDetail_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a6f6590 | this.Load | FP00641_InvDetail_Popup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e221c570 | this.Load | FP00641_InvDetail_Popup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00641_InvDetail_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87338540 | this.Load | FP00641_InvDetail_Popup.cs:155 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94803069 | this.Load | FP00641_InvDetail_Popup.cs:156 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00641_InvDetail_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2082c2fe | (진입점 미연결) | FP00641_InvDetail_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00641_InvDetail_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2dda091 | this.Load | FP00641_InvDetail_Popup.cs:162 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e90f670a | this.Load | FP00641_InvDetail_Popup.cs:163 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-95c854dd | this.Load | FP00641_InvDetail_Popup.cs:167 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00641_InvDetail_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52cf9cde | this.spdMain.CellClick | FP00641_InvDetail_Popup.cs:348 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0576fd16 | this.spdMain.CellClick | FP00641_InvDetail_Popup.cs:349 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-893de689 | this.spdMain.CellClick | FP00641_InvDetail_Popup.cs:352 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00641_InvDetail_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c668c42 | this.spdMain.CellDoubleClick | FP00641_InvDetail_Popup.cs:358 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-827d039b | this.spdMain.CellDoubleClick | FP00641_InvDetail_Popup.cs:359 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3a955108 | this.spdMain.CellDoubleClick | FP00641_InvDetail_Popup.cs:362 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-6e4cc7d8 | this.spdMain.CellDoubleClick | FP00641_InvDetail_Popup.cs:365 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00641_InvDetail_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-337124ae | this.spdMain.EditChange | FP00641_InvDetail_Popup.cs:403 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00641_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-083ba477 | .ctor | FP00641_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-b2af7606 | .ctor | FP00641_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-729748d0 | .ctor | FP00641_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-bfd02448 | .ctor | FP00641_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00641_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-979dac0e | Dispose | FP00641_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00641_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46f3b0f1 | this.Load | FP00641_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00641_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81f13e12 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:216 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-cd8302bb | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:217 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-ae55f96b | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_pack_shipping_plan) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d73850 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_pack_shipping_plan_sim) | 데이터 객체 조작/조회 |  |  |  |
| AC-866543e8 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_pack_shipping_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-e86b5780 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_pack_shipping_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b93d502 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:228 |  | DATA_OP | ctrls.Add | (chk_pack_scp_target) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1732a1b | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:229 |  | DATA_OP | ctrls.Add | (chk_pack_prod_target) | 데이터 객체 조작/조회 |  |  |  |
| AC-a769da52 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_pack_plan_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f51e95b | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_pack_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-adc97c1f | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_pack_yield) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fdc10be | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_pack_eoh) | 데이터 객체 조작/조회 |  |  |  |
| AC-6787f273 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_pack_eoh_good) | 데이터 객체 조작/조회 |  |  |  |
| AC-740d96ea | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_pack_eoh_sim) | 데이터 객체 조작/조회 |  |  |  |
| AC-4685ccef | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_pack_eoh_good_sim) | 데이터 객체 조작/조회 |  |  |  |
| AC-70435c4e | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_pack_unhold_exp_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d1e87a6 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_pack_eoh_good_unhold_exp) | 데이터 객체 조작/조회 |  |  |  |
| AC-59f67e75 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_form_shipping_plan) | 데이터 객체 조작/조회 |  |  |  |
| AC-493d62f7 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_form_prod_target) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb46a61f | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:245 |  | DATA_OP | ctrls.Add | (chk_form_plan_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c46ce73 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_form_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-1bc0f75e | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_form_yield) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f4e0851 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_form_eoh) | 데이터 객체 조작/조회 |  |  |  |
| AC-17f4e3b5 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_form_eoh_good) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a06e5c0 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_form_activated) | 데이터 객체 조작/조회 |  |  |  |
| AC-75fe09c4 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_form_activated_boh) | 데이터 객체 조작/조회 |  |  |  |
| AC-07d0011a | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:256 |  | DATA_OP | ctrls.Add | (chk_form_wip_boh) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce3e60c1 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_form_bd_boh) | 데이터 객체 조작/조회 |  |  |  |
| AC-39969759 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_form_ad_boh) | 데이터 객체 조작/조회 |  |  |  |
| AC-207f8809 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:260 |  | DATA_OP | ctrls.Add | (chk_form_unhold_exp_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-9917f007 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:261 |  | DATA_OP | ctrls.Add | (chk_form_eoh_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6cd00ee | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_form_eoh_good_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-e81b7b92 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_form_eoh_good_unhold_exp_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-61c7577b | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:264 |  | DATA_OP | ctrls.Add | (chk_form_plan_out_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1d6c740 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_form_receipt_qty) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a1a05fb | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_cell_scp_target_uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbbc01b1 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_cell_prod_target_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-724572bd | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:270 |  | DATA_OP | ctrls.Add | (chk_cell_plan_out_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe923582 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:272 |  | DATA_OP | ctrls.Add | (chk_cell_result_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3549da1 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:274 |  | DATA_OP | ctrls.Add | (chk_cell_yield) | 데이터 객체 조작/조회 |  |  |  |
| AC-b259dfef | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:276 |  | DATA_OP | ctrls.Add | (chk_cell_eoh_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-eaf3c42e | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:277 |  | DATA_OP | ctrls.Add | (chk_cell_eoh_good_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-dda21765 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:278 |  | DATA_OP | ctrls.Add | (chk_cell_plan_out_cell_group) | 데이터 객체 조작/조회 |  |  |  |
| AC-e591859e | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:281 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-bab2572a | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:281 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-c9217627 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:288 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-b01efa5e | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:292 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-e2f34a1b | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:296 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00641_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b07ed378 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_pack_shipping_plan.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-71ea9cc1 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_pack_shipping_plan_sim.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-630813d7 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_pack_shipping_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dcbeb1e0 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_pack_shipping_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-24ffa55e | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_pack_scp_target.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e999f7eb | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_pack_prod_target.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-864e563b | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_pack_plan_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f2b9e39f | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_pack_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c851b2ff | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_pack_yield.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3b0bd17f | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_pack_eoh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ae0e664f | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_pack_eoh_good.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bef248ec | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_pack_eoh_sim.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f89fb8df | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_pack_eoh_good_sim.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1ef860f0 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_pack_unhold_exp_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3f767ac0 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_pack_eoh_good_unhold_exp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ee2bf29f | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_form_shipping_plan.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-569c66a5 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_form_prod_target.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-92bf51ed | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_form_plan_out.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4a119bb7 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_form_yield.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1ece6afd | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_form_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-eb720d88 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_form_eoh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dfcd045a | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_form_eoh_good.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dbc3fea7 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_form_activated.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-995da11e | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_form_activated_boh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8f01e103 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:175 |  | VALUE_SET | chk_form_wip_boh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-23fa34ee | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_form_bd_boh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c57b4929 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:177 |  | VALUE_SET | chk_form_ad_boh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c1476b91 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:179 |  | VALUE_SET | chk_form_unhold_exp_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-47265da3 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_form_eoh_group.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-62653dcd | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:181 |  | VALUE_SET | chk_form_eoh_good_group.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b3a3e679 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:182 |  | VALUE_SET | chk_form_eoh_good_unhold_exp_group.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8d664a08 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:183 |  | VALUE_SET | chk_form_plan_out_group.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6c5909a8 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:184 |  | VALUE_SET | chk_form_receipt_qty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c71385dc | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:186 |  | VALUE_SET | chk_cell_scp_target_uom.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c77a7417 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:187 |  | VALUE_SET | chk_cell_prod_target_cell.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-df8fdb9a | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:189 |  | VALUE_SET | chk_cell_plan_out_cell.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e3b42d73 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:191 |  | VALUE_SET | chk_cell_result_cell.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e18ae131 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:193 |  | VALUE_SET | chk_cell_yield.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-60318f96 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:195 |  | VALUE_SET | chk_cell_eoh_group.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fb16b3fb | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:196 |  | VALUE_SET | chk_cell_eoh_good_group.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-eb4451b9 | this.Load 외 1 | FP00641_MeasureSetForm_Popup.cs:197 |  | VALUE_SET | chk_cell_plan_out_cell_group.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00641_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39991b5c | (진입점 미연결) | FP00641_MeasureSetForm_Popup.cs:358 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-19be574d | (진입점 미연결) | FP00641_MeasureSetForm_Popup.cs:369 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abb74e9a | (진입점 미연결) | FP00641_MeasureSetForm_Popup.cs:380 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00641_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-849e8882 | this.Load | FP00641_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a68f612b | this.Load | FP00641_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00641_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49fb0b3a | this.usrButton1.Click | FP00641_MeasureSetForm_Popup.cs:342 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-481cdbc2 | this.usrButton1.Click | FP00641_MeasureSetForm_Popup.cs:342 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-d98ed9a4 | this.usrButton1.Click | FP00641_MeasureSetForm_Popup.cs:344 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-8bda5b5d | this.usrButton1.Click | FP00641_MeasureSetForm_Popup.cs:348 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-136dbe49 | this.usrButton1.Click | FP00641_MeasureSetForm_Popup.cs:349 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ffd5c1c4 | this.usrButton1.Click | FP00641_MeasureSetForm_Popup.cs:351 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7fdf898 | this.usrButton1.Click | FP00641_MeasureSetForm_Popup.cs:353 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00641_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad6dd164 | this.usrButton2.Click | FP00641_MeasureSetForm_Popup.cs:314 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-64d3531e | this.usrButton2.Click | FP00641_MeasureSetForm_Popup.cs:314 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-3333dda1 | this.usrButton2.Click | FP00641_MeasureSetForm_Popup.cs:316 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-6053b3b5 | this.usrButton2.Click | FP00641_MeasureSetForm_Popup.cs:320 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-f538652d | this.usrButton2.Click | FP00641_MeasureSetForm_Popup.cs:321 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-6d620e3a | this.usrButton2.Click | FP00641_MeasureSetForm_Popup.cs:322 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-c7977f85 | this.usrButton2.Click | FP00641_MeasureSetForm_Popup.cs:323 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

