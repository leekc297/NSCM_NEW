# AS-IS 액션 대조표 — FP00600

> 원천: `Doc/asisfacts/screens/FP00600/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1319행 · 메서드 129 · 종류 DATA_OP 477 · UI_PROP 149 · RETURN 116 · FLAG 112 · CALL_EXT 72 · VALUE_SET 64 · MESSAGE 52 · UI_MISC 46 · POPUP 43 · GRID_SET 42 · ENDPOINT 37 · LIST_REBIND 20 · COMBO_DATA 19 · VALUE_CLEAR 15 · GRID_INIT 15 · THROW 8 · GRID_STYLE 8 · STATE 8 · GRID_LOCK 7 · LIST_CLEAR 4 · CALL_BASE 2 · FOCUS 1 · EXCEL 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 74


## DataLines.CreateDataLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd20f5e8 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3665 | if (dsData == null) ▸ if (dt != null) ▸ else of (dt.DataSet != null) | DATA_OP | dsData.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-66fc09e9 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3671 | if (dsData == null) ▸ else of (dt != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-eecfa222 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3680 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-b3d72a61 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3681 |  | UI_PROP | dlLine._INV_SHIP | line_savings.INV_SHIP | 속성 _INV_SHIP 설정 |  |  |  |
| AC-ad35c6c3 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3684 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-91534531 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3685 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-e5dfa6a1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3686 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-41940641 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3687 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-2bdd4347 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3688 |  | DATA_OP | material_column.ContainsKey | ("BOH_2ND_ACTIVATED") | 데이터 객체 조작/조회 |  |  |  |
| AC-e85ee3f0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3689 | if (material_column.ContainsKey("BOH_2ND_ACTIVATED")) | UI_PROP | dlLine._ACTIVATED | material_column["BOH_2ND_ACTIVATED"] | 속성 _ACTIVATED 설정 |  |  |  |
| AC-c7e7bd10 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3690 |  | DATA_OP | material_column.ContainsKey | ("BOH_2ND_EXPECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-46fe9aff | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3691 | if (material_column.ContainsKey("BOH_2ND_EXPECT")) | UI_PROP | dlLine._OCV | material_column["BOH_2ND_EXPECT"] | 속성 _OCV 설정 |  |  |  |
| AC-8a0d8f23 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3693 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |
| AC-1edea06d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3874 |  | UI_PROP | dlLine._I | line_savings.I | 속성 _I 설정 |  |  |  |
| AC-7d31fbaa | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3875 |  | UI_PROP | dlLine._INV_SHIP | line_savings.INV_SHIP | 속성 _INV_SHIP 설정 |  |  |  |
| AC-11ce8183 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3877 |  | DATA_OP | material_column.ContainsKey | ("P_IN") | 데이터 객체 조작/조회 |  |  |  |
| AC-4db9f820 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3878 | if (material_column.ContainsKey("P_IN")) | UI_PROP | dlLine._P_IN | material_column["P_IN"] | 속성 _P_IN 설정 |  |  |  |
| AC-f9000fc3 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3879 |  | DATA_OP | material_column.ContainsKey | ("P_OUT") | 데이터 객체 조작/조회 |  |  |  |
| AC-16f086e1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3880 | if (material_column.ContainsKey("P_OUT")) | UI_PROP | dlLine._P_OUT | material_column["P_OUT"] | 속성 _P_OUT 설정 |  |  |  |
| AC-cfe1bd54 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3881 |  | DATA_OP | material_column.ContainsKey | ("BOH_2ND_ACTIVATED") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec26c91e | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3882 | if (material_column.ContainsKey("BOH_2ND_ACTIVATED")) | UI_PROP | dlLine._ACTIVATED | material_column["BOH_2ND_ACTIVATED"] | 속성 _ACTIVATED 설정 |  |  |  |
| AC-e6bed2d8 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3883 |  | DATA_OP | material_column.ContainsKey | ("BOH_2ND_EXPECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcbed6d2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3884 | if (material_column.ContainsKey("BOH_2ND_EXPECT")) | UI_PROP | dlLine._OCV | material_column["BOH_2ND_EXPECT"] | 속성 _OCV 설정 |  |  |  |
| AC-c6b1130a | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3886 |  | RETURN | return dlLine; |  | 처리 중단/반환 |  |  |  |

## DataLines.DO_INC_P_RESULT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d056f693 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3981 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Do_SET_P_OUT_CELL

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3d705d9 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3985 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-086ae0ef | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3793 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ace90c5 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3794 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca93952b | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3795 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3825ac9 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3796 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ea21e1f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3797 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-db016e4d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3800 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3be0af | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3804 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce1b06d2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3805 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5924c6a7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3791 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-cc8ca014 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3821 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "S": | DATA_OP | loc.S.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a980750 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3824 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "P_OUT": | DATA_OP | loc.P_OUT.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-75a19474 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3827 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "BOH_2ND_ACTIVATED": | DATA_OP | loc.ACTIVATED.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d5424fd | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3830 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "BOH_2ND_EXPECT": | DATA_OP | loc.OCV.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-87a21e2a | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3833 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I_SSP": | UI_PROP | loc.INV_SHIP | row_index | 속성 INV_SHIP 설정 |  |  |  |
| AC-c3f58987 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3836 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "I": | UI_PROP | loc.I | row_index | 속성 I 설정 |  |  |  |
| AC-f2dc1efd | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3842 | if (clicked_row != null) | RETURN | return loc; |  | 처리 중단/반환 |  |  |  |
| AC-a120df24 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3844 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_Line_Savings_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45883ba4 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3766 |  | RETURN | return Find_Line_Savings_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a13941db | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3731 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e928484 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3732 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2febc88b | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3733 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8b94706 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3734 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3362645 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3735 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-da99e97b | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3736 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5f849e7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3738 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4362dda6 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3739 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d454fc4d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3742 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a84f69cf | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3743 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-92df93cb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3744 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-90a26286 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3729 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-52871d4a | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3752 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) | DATA_OP | dict.ContainsKey | (category_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-d128fbc2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3753 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ if (!dict.ContainsKey(category_id)) | DATA_OP | dict.Add | (category_id, row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-a20f97e1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3758 |  | RETURN | return dict; |  | 처리 중단/반환 |  |  |  |

## DataLines.Find_MaterialData_Index_FromScreen

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26f3f38d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3705 |  | RETURN | return Find_MaterialData_Index_FromData(data_src_same_order, amend_calendar, spr… |  | 처리 중단/반환 |  |  |  |

## FP00600_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c31c957a | .ctor | FP00600_BucketSetForm_Popup.cs:72 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-ded9d0f1 | .ctor | FP00600_BucketSetForm_Popup.cs:73 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-1a315502 | .ctor | FP00600_BucketSetForm_Popup.cs:74 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-528942ff | .ctor | FP00600_BucketSetForm_Popup.cs:76 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00600_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ec247ef | Dispose | FP00600_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00600_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05dd35aa | this.Load | FP00600_BucketSetForm_Popup.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00600_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f61335b1 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:139 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-a3df0b50 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab0a9753 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-71a128a7 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c5684ba | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:152 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-b42a7dc4 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:152 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-d7ea765e | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:159 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-00a381c6 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:163 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-bdebed07 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:167 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00600_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d6f311f | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4331d061 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-38c9ff29 | this.Load 외 1 | FP00600_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00600_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38ae8245 | (진입점 미연결) | FP00600_BucketSetForm_Popup.cs:227 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-03e86ae5 | (진입점 미연결) | FP00600_BucketSetForm_Popup.cs:238 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aba59205 | (진입점 미연결) | FP00600_BucketSetForm_Popup.cs:249 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00600_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a1306d3 | this.Load | FP00600_BucketSetForm_Popup.cs:87 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-289890ab | this.Load | FP00600_BucketSetForm_Popup.cs:95 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00600_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16925858 | this.usrButton1.Click | FP00600_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-876ff72e | this.usrButton1.Click | FP00600_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-7fc2de60 | this.usrButton1.Click | FP00600_BucketSetForm_Popup.cs:213 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-0f8c49f9 | this.usrButton1.Click | FP00600_BucketSetForm_Popup.cs:217 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-ffe6f676 | this.usrButton1.Click | FP00600_BucketSetForm_Popup.cs:218 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3a31eac5 | this.usrButton1.Click | FP00600_BucketSetForm_Popup.cs:220 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3a3db70 | this.usrButton1.Click | FP00600_BucketSetForm_Popup.cs:222 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00600_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fb769ee | this.usrButton2.Click | FP00600_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-37bf666c | this.usrButton2.Click | FP00600_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-ab51cc99 | this.usrButton2.Click | FP00600_BucketSetForm_Popup.cs:187 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-66cc6916 | this.usrButton2.Click | FP00600_BucketSetForm_Popup.cs:191 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-c337586b | this.usrButton2.Click | FP00600_BucketSetForm_Popup.cs:192 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-d18811cf | this.usrButton2.Click | FP00600_BucketSetForm_Popup.cs:193 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e0fdcf50 | this.usrButton2.Click | FP00600_BucketSetForm_Popup.cs:194 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00600_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-230d54b7 | .ctor | FP00600_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-7bdfec11 | .ctor | FP00600_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-34630553 | .ctor | FP00600_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-14347757 | .ctor | FP00600_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00600_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f5eb6be | Dispose | FP00600_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00600_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26e20fcb | this.Load | FP00600_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00600_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55bd32e8 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:176 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-74cb9a9d | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:177 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-61b6b811 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:204 |  | DATA_OP | ctrls.Add | (chk_sales) | 데이터 객체 조작/조회 |  |  |  |
| AC-44055968 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:205 |  | DATA_OP | ctrls.Add | (chk_ssp) | 데이터 객체 조작/조회 |  |  |  |
| AC-18a27b9f | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:206 |  | DATA_OP | ctrls.Add | (chk_past_sales) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd47d6db | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:208 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-bce17f32 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:209 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-82c73b5e | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:210 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ca95cb8 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:212 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-4136360c | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:213 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc71b0a0 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:214 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-41c2a538 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:215 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-45078ce6 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:217 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6b2ac09 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_inventory) | 데이터 객체 조작/조회 |  |  |  |
| AC-0db66a3a | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:220 |  | DATA_OP | ctrls.Add | (chk_do) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2ec10e0 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:221 |  | DATA_OP | ctrls.Add | (chk_ssp_inventory) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec28b7de | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_BOH_2nd) | 데이터 객체 조작/조회 |  |  |  |
| AC-67adaa42 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:224 |  | DATA_OP | ctrls.Add | (chk_activated) | 데이터 객체 조작/조회 |  |  |  |
| AC-55d33923 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_sspSimul) | 데이터 객체 조작/조회 |  |  |  |
| AC-95444320 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_sspSimul_inventory) | 데이터 객체 조작/조회 |  |  |  |
| AC-e47187c5 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-a45ae18d | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_total_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9acdede | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:235 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-f753840b | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:235 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-6de1a17b | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:242 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-a195c99f | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:246 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-51f52ddc | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:250 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00600_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b97ff0db | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:127 |  | VALUE_SET | chk_sales.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f8a92fe9 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:128 |  | VALUE_SET | chk_ssp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-80a21773 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:129 |  | VALUE_SET | chk_past_sales.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-87324f50 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6e02e746 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0bb392f4 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:133 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-719c2158 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b550a792 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2c3ccc32 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7b13788f | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7cb1ec9d | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-37b1c42c | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_inventory.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5f253ec0 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_do.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-393b1717 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_ssp_inventory.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a3ec3506 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_BOH_2nd.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d1904217 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_activated.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3f1922ba | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_sspSimul.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4a713ce7 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_sspSimul_inventory.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8593c6f0 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5e93bb65 | this.Load 외 1 | FP00600_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_total_2.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00600_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce53c869 | (진입점 미연결) | FP00600_MeasureSetForm_Popup.cs:310 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-976a87cc | (진입점 미연결) | FP00600_MeasureSetForm_Popup.cs:321 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7deca6d | (진입점 미연결) | FP00600_MeasureSetForm_Popup.cs:332 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00600_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76fcf2af | this.Load | FP00600_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0e3bbb87 | this.Load | FP00600_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00600_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09b40560 | this.usrButton1.Click | FP00600_MeasureSetForm_Popup.cs:294 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-3e0baf9f | this.usrButton1.Click | FP00600_MeasureSetForm_Popup.cs:294 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-6a5f3c68 | this.usrButton1.Click | FP00600_MeasureSetForm_Popup.cs:296 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-f25cc1a1 | this.usrButton1.Click | FP00600_MeasureSetForm_Popup.cs:300 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-b11ac638 | this.usrButton1.Click | FP00600_MeasureSetForm_Popup.cs:301 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-4d5529b6 | this.usrButton1.Click | FP00600_MeasureSetForm_Popup.cs:303 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b83f872 | this.usrButton1.Click | FP00600_MeasureSetForm_Popup.cs:305 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00600_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fd13d07 | this.usrButton2.Click | FP00600_MeasureSetForm_Popup.cs:268 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-43a0aec3 | this.usrButton2.Click | FP00600_MeasureSetForm_Popup.cs:268 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-29c8b600 | this.usrButton2.Click | FP00600_MeasureSetForm_Popup.cs:270 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-77fca87a | this.usrButton2.Click | FP00600_MeasureSetForm_Popup.cs:274 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-984e87ce | this.usrButton2.Click | FP00600_MeasureSetForm_Popup.cs:275 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-41bf910f | this.usrButton2.Click | FP00600_MeasureSetForm_Popup.cs:276 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-7ba7913a | this.usrButton2.Click | FP00600_MeasureSetForm_Popup.cs:277 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00600_PlanAmend_Model_Pack..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-013ba49b | .ctor | FP00600_PlanAmend_Model_Pack.cs:111 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-6e8d9d7e | .ctor | FP00600_PlanAmend_Model_Pack.cs:112 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00600_PlanAmend_Model_Pack.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5797e9b6 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2272 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fb1490bc | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2273 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-67706c4a | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2274 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6eecb736 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2275 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8fe3aa19 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2276 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-92742857 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2279 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-60bdd6bd | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2279 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e66e0717 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2280 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-b212347b | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2280 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ee30ee2c | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2281 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-46735220 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2281 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4c407ae2 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2282 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-0b9c8a22 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2282 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-81eb765f | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2294 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-ff74eed7 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2295 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-f2f28b3a | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2296 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-1e4c6a63 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2297 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00600_PlanAmend_Model_Pack.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.S…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b74a4328 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2303 | if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5b65e53 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2309 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //set["USER_ID"] = "chkim.68"; Filter["BUCKET_FROM"] = dr… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8335fcfe | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2312 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-eba14418 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2313 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1cb3bac8 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2314 | lambda | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-43b8a6ab | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2318 | lambda ▸ if (cboPlanId.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-bca6becd | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2323 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-652ab200 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2324 |  | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R " | 행/컬럼 값 대입 |  |  |  |
| AC-459ef700 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2325 |  | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_R " | 행/컬럼 값 대입 |  |  |  |
| AC-f4b24a8e | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2326 |  | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2108aca4 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2327 |  | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_R " | 행/컬럼 값 대입 |  |  |  |
| AC-8825fdc7 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2331 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-ae14ae90 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2332 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H " | 행/컬럼 값 대입 |  |  |  |
| AC-df06a24f | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2333 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_PACK_BOR_H " | 행/컬럼 값 대입 |  |  |  |
| AC-6ee9663b | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2334 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_PACK_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-7a11cc42 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2335 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_PACK_UTIL_H " | 행/컬럼 값 대입 |  |  |  |
| AC-6f67b370 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2338 |  | DATA_OP | Filter["RESULT_QTY"] | "RESULT_OUT_QTY " | 행/컬럼 값 대입 |  |  |  |
| AC-c24b45f1 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2349 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9931fa62 | this.btnBucket.Click | FP00600_PlanAmend_Model_Pack.cs:4627 |  | POPUP | new FP00600_BucketSetForm_Popup | ("FP00600", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-f05e6c26 | this.btnBucket.Click | FP00600_PlanAmend_Model_Pack.cs:4628 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-2460a6f8 | this.btnBucket.Click | FP00600_PlanAmend_Model_Pack.cs:4629 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-76bf93a3 | this.btnBucket.Click | FP00600_PlanAmend_Model_Pack.cs:4630 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d7535409 | this.btnBucket.Click | FP00600_PlanAmend_Model_Pack.cs:4634 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-5324c825 | this.btnBucket.Click | FP00600_PlanAmend_Model_Pack.cs:4643 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ad8121f3 | this.btnBucket.Click | FP00600_PlanAmend_Model_Pack.cs:4645 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnCatagory_Click

진입점: this.btnCategory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74bf78aa | this.btnCategory.Click | FP00600_PlanAmend_Model_Pack.cs:4590 |  | POPUP | new FP00600_MeasureSetForm_Popup | ("FP00600", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-3720243f | this.btnCategory.Click | FP00600_PlanAmend_Model_Pack.cs:4592 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-25e88e53 | this.btnCategory.Click | FP00600_PlanAmend_Model_Pack.cs:4594 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e23f1c69 | this.btnCategory.Click | FP00600_PlanAmend_Model_Pack.cs:4595 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-94ad7e54 | this.btnCategory.Click | FP00600_PlanAmend_Model_Pack.cs:4599 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-d795bfd6 | this.btnCategory.Click | FP00600_PlanAmend_Model_Pack.cs:4608 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dddc4837 | this.btnCategory.Click | FP00600_PlanAmend_Model_Pack.cs:4610 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3eaad84c | this.btnColumn.Click | FP00600_PlanAmend_Model_Pack.cs:4569 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00600", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-9df0f520 | this.btnColumn.Click | FP00600_PlanAmend_Model_Pack.cs:4571 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-180df1ba | this.btnColumn.Click | FP00600_PlanAmend_Model_Pack.cs:4572 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnCreatePlan_Click

진입점: this.btnCreatePlan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ba87467 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4945 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a93cde73 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4946 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00a22099 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4956 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Master.PR_UI_FP00600_ETC | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad2ce5ec | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4958 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a89a4055 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4964 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-397270b6 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4965 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f57d000c | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4970 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49a6a35b | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4971 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aee3d8e9 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4974 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("AMEND_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-39d0cff3 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4975 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("FIX_DATE_SYNC", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-63a96c9f | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4976 |  | DATA_OP | dtParam.Columns.Add | (new DataColumn("SYNC_YN", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-389dc27c | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4982 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-cdbb38dd | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4985 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-a5828714 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4986 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-c465d705 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4987 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-0f889d22 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4989 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-aa68f00c | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:4990 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b56e05fc | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:5001 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-845ce589 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:5001 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-63a83ef9 | this.btnCreatePlan.Click | FP00600_PlanAmend_Model_Pack.cs:5008 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cboPlanId.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebec4a60 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2359 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ed05ebc | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2360 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1706ee2 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2365 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-598f994b | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2366 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c175833 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2371 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-27afe149 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2372 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3a9fe9c | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2375 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-ce82d636 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2376 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-56a8f25d | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2377 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f853f6c | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2378 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-25105ecc | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2385 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00601_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-849eafc5 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2387 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b6739040 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2387 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e3a5277 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2389 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.QTY | 속성 DateColumnType 설정 |  |  |  |
| AC-33bce658 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2391 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5200c68f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2392 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b407f23b | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2393 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-90ab1d98 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2394 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-139a32fe | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2395 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6c5d816f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2396 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b8dc145f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2397 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1ca48493 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2398 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-064e0ff0 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2399 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2676879d | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2400 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5cf7adfe | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2401 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-96236e0a | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2404 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-379f146f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2405 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-f5d4e3e1 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2406 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-6276927c | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2407 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-41d7e5bc | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2408 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-369d773d | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2410 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-82bb8b73 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2411 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-3a4d2b49 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2413 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-68536037 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2414 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-a3fed62f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2415 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-0ced9234 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2416 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-9c9f72e5 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2417 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-16bb2ecc | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2418 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-12ed2596 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2419 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-dc7718fc | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2420 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-434519b6 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2422 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | call_Excel_Col_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-1b820618 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2423 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | call_Excel_Col_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-d5609943 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2424 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | call_Excel_Col_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-46b7024f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2425 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | call_Excel_Col_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-624ff577 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2426 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-523c989c | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2436 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00601_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-1752b6e4 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2438 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c8851465 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2438 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-14f3c0a0 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2442 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-17572dba | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2443 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a2c8cf0e | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2444 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e451aadd | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2445 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-663dc461 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2446 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-488d8f0f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2447 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-27bb480a | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2448 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8ccbd9bc | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2449 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LOCATION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c9ea4f56 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2450 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b9edb3ea | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2451 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6e4f0eaf | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2452 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d3d86631 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2454 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f3d45c0c | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2455 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["QTY"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1abd1b3b | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2457 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-e3a085ee | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2458 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-cbbb642c | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2459 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-bd3b66be | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2460 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-4c495d9e | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2461 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-0d9a4893 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2463 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-d0f38265 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2464 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_TYPE"] | "Item Type" | 행/컬럼 값 대입 |  |  |  |
| AC-35437e2f | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2466 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-d5ca847e | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2467 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-24b6fcf8 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2468 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LOCATION"] | "Loc." | 행/컬럼 값 대입 |  |  |  |
| AC-052b52ba | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2469 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-dd5564f3 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2470 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-d9b360d8 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2471 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-fdc02122 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2472 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-6b7608a0 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2473 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-7afd190d | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2474 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-44da8339 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2475 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["QTY"] | "QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-aa751688 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2476 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-604ec472 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2478 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-31df78b8 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2480 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-55200da0 | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2481 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-a3b3c10e | this.btnExcelImport.Click | FP00600_PlanAmend_Model_Pack.cs:2482 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb5012fb | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5191 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29947b8f | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5192 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fac38479 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5198 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-fb38a078 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5199 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d2b04bd | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5202 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9afa0895 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5203 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-7e4424a7 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5204 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d2fc62cd | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5204 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eac7eb1b | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5205 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-3b3ed4ec | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5206 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-7065520a | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5207 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-89d41bf2 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5207 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e8e8aa65 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5208 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e81d27a | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5209 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e78c69e3 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5210 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-83ce055a | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5211 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-07471593 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5212 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eb81bb81 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5213 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-915b780e | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5214 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-26050f01 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5215 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6898b633 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5216 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed3e6e73 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5218 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-69d5e66d | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5219 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5f876349 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5220 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-77eb4f66 | this.btnMemo.Click | FP00600_PlanAmend_Model_Pack.cs:5221 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnMRP_Click

진입점: this.btnMrp.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8daf463 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4903 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33172535 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4904 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfa9edc5 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4908 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8da3c374 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4910 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-afc850e0 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4913 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-699a9ea4 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4914 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09baf173 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4919 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-16aab9ee | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4920 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8de0ad00 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4925 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-81743836 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4926 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ff8d744 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4930 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-714504e7 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4931 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e3ec3b3 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4932 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-947fb5ae | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4933 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-87ed6c73 | this.btnMrp.Click | FP00600_PlanAmend_Model_Pack.cs:4935 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnRelease_Click

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e6d86f6 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5040 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8277c960 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5041 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1e0480f | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5045 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8f250590 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5046 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-206aec2f | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5049 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-b7dfed00 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5050 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-511043c3 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5064 | if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6607d133 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5065 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c98eaaa | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5071 | if (sPlanID == "-") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-953250fe | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5072 | if (sPlanID == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9a99d8e | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5079 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "00 Plan cant not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edb971ab | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5080 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-700eb151 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5083 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_instanceInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-15733161 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5084 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_planInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-04c2e069 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5086 |  | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2245555b | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5092 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Release type plan can not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e0c467e | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5093 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e08335fa | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5097 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af2052f7 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5101 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ad9a7d1 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5102 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6130f63b | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5109 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d3e7b71 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5110 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aeb04b1a | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5121 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e0a1d13 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5124 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de27968e | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5126 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3f9c212a | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5132 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9ca2eddd | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5133 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-765e7d80 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5146 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-461a6821 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5147 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3d67906 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5159 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-394ff90a | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5162 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-30a23337 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5163 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-698caf8d | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5164 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-50215441 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5165 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-32639d3d | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5173 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-9f31227e | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5176 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-fa78a6ec | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5177 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-17f813c6 | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5178 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-bf8215be | this.btnRelease.Click | FP00600_PlanAmend_Model_Pack.cs:5179 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ffd6f4b | this.btnSql.Click | FP00600_PlanAmend_Model_Pack.cs:1604 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-68e5611c | this.btnSql.Click | FP00600_PlanAmend_Model_Pack.cs:1605 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ae716e68 | this.btnSql.Click | FP00600_PlanAmend_Model_Pack.cs:1607 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ef2853c | this.btnSql.Click | FP00600_PlanAmend_Model_Pack.cs:1608 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-715ea882 | this.btnToggleSave.Click | FP00600_PlanAmend_Model_Pack.cs:4661 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26a7834b | this.button1.Click | FP00600_PlanAmend_Model_Pack.cs:5244 |  | VALUE_SET | chk_info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.call_Excel_Col_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13b3caa3 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2697 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.call_Excel_Col_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6981e32 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2531 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-502dde97 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2535 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-b13dab73 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2536 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-fe37dbd8 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2539 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1e06e89d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2542 |  | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c9e03ae6 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2547 | if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-27e4dc6c | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2552 |  | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_EXCEL_IMPORT", "merge_ExcelImport", dsMerge, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_ExcelImport] \| FP\Common\… | 엔드포인트 호출 |  |  |  |
| AC-f7779890 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2560 | if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-38048524 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2561 | if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-8f272ee4 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2572 | if (do_save) ▸ lambda ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul_2", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-c91e2345 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2576 | if (do_save) ▸ lambda ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-f95df878 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2579 | if (do_save) | CALL_EXT | runnerPack.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4efb854 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2580 | if (do_save) | CALL_EXT | Thread.Sleep | (100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc019e18 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2582 | if (do_save) | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-d07f0d4e | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2586 | if (do_save) | RETURN | return result.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1ebd17d2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2590 | else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-3fbaf98a | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2593 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.call_Excel_Col_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0d8e6d0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2498 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-02cab552 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2502 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_COLUMN_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5398de75 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2505 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ( "INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_IT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-06d81745 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2512 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("INSTANCE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-27053f19 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2513 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("FP_PLAN_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f14963e1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2514 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("COMPANY_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f9dbcd2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2515 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("ELECTRODE_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-03b7802c | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2516 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumns | ("EQUIPMENT_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b174dbd7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2517 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumnsEndsWith | ("_SEQ") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b0ee917 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2518 | if (popup != null) ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].RemoveColumnsEndsWith | ("_CELL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4966a55 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2520 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-c1b3a1cb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2523 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.call_Excel_Col_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-664e21f5 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2600 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-3587dd3b | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2602 |  | UI_PROP | popup.dsSaveExcelData | new DataSet() | 속성 dsSaveExcelData 설정 |  |  |  |
| AC-6c1d85c9 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2603 |  | DATA_OP | popup.dsSaveExcelData.Tables.Add | (data.Tables[0].Clone()) | 데이터 객체 조작/조회 |  |  |  |
| AC-920c5355 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2603 |  | DATA_OP | data.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2bdd1136 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2606 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c6357b2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2607 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("PLAN_DATE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-24f84f2f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2608 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-17d50268 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2609 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("QTY")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a13691f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2610 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-130931c4 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2611 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("ELECTRODE_TYPE")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e579e93 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2612 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72df4127 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2613 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8be2e48 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2614 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4237084 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2615 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b58572c | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2616 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Contains | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-50b6a435 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2617 | if (popup.Calendar != null) ▸ if (!popup.dsSaveExcelData.Tables[0].Columns.Contains("COMPANY_ID")) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-98ac3835 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2638 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1a22eb0d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2640 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["INSTANCE_ID"] | popup.Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-06e714b0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2641 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ec2a3100 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2642 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["COMPANY_ID"] | popup.Filter["COMPANY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dcc8aa90 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2644 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLAN_DATE"] | aDate.Date.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-865a79c7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2645 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["QTY"] | row[sQtyCol].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-b6325184 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2647 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["DIVISION_ID"] | row["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d687d7a7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2648 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SITE_ID"] | row["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aff2e5ff | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2649 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLANT_ID"] | row["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f83a4a5 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2650 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_ID"] | row["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c44792d5 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2651 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["OPERATION_ID"] | row["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-89a89323 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2652 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FACTORY_ID"] | row["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e6fc2b1a | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2653 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LOCATION"] | row["LOCATION"] | 행/컬럼 값 대입 |  |  |  |
| AC-1db7f929 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2654 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6b40bb18 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2655 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["MARKET"] | row["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-eb2d08a7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2656 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_ID"] | row["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f5f94ee | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2658 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-46151b67 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2659 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["TOP_ITEM_ID"] | row["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ee587e71 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2660 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_TYPE"] | row["ITEM_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bc6d28a1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2664 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].Rows.Add | (pivotLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d493133 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2679 | if (popup != null) | UI_PROP | amend.ShopType | ShopType.PACK | 속성 ShopType 설정 |  |  |  |
| AC-2e79b05c | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2680 | if (popup != null) | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-63f609d8 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2681 | if (popup != null) | UI_PROP | amend.dtSaveData | popup.dsSaveExcelData.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-86bf021c | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2682 | if (popup != null) | UI_PROP | amend.Filter | popup.Filter | 속성 Filter 설정 |  |  |  |
| AC-a288ff13 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2683 | if (popup != null) | UI_PROP | amend.PlanId | Filter["PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-21ce2d8f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2684 | if (popup != null) | UI_PROP | amend.sInstanceId | Filter["INSTANCE_ID"] | 속성 sInstanceId 설정 |  |  |  |
| AC-e319fbdb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2686 | if (popup != null) | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb673dee | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2688 | if (popup != null) | RETURN | return amend.dsValidationReturn; |  | 처리 중단/반환 |  |  |  |
| AC-49830ff8 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2691 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0d2935d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2721 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c198eb96 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2723 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-247c8f27 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2727 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-0d31a0b0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2728 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-edc4cfaa | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2734 | if (popup != null) | COMBO_DATA | data.Copy | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5af95ede | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2739 | if (popup != null) ▸ if (dsMerge.Good()) ▸ while (dsMerge.Tables[0].Rows.Count > 1) | DATA_OP | dsMerge.Tables[0].Rows.RemoveAt | (dsMerge.Tables[0].Rows.Count - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e00d814 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2744 | if (popup != null) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00601_EXCEL_IMPORT", "merge_ExcelImport", dsMerge, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_ExcelImport] \| FP\Common\… | 엔드포인트 호출 |  |  |  |
| AC-800e0175 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2752 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-b53643d7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2753 | if (popup != null) ▸ if (do_save) ▸ if (popup != null) | UI_MISC | popup.Close | () | 창 닫기/해제 |  |  |  |
| AC-5b18b6d4 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2763 | if (popup != null) ▸ if (do_save) ▸ lambda ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul_2", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul_2] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-438c6139 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2767 | if (popup != null) ▸ if (do_save) ▸ lambda ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-9c389192 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2770 | if (popup != null) ▸ if (do_save) | CALL_EXT | runnerPack.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-702ecfdb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2771 | if (popup != null) ▸ if (do_save) | CALL_EXT | Thread.Sleep | (100) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ccc4267f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2773 | if (popup != null) ▸ if (do_save) | ENDPOINT | DataService.FP_RunProcedure | ("FP00600_PlanAmend", "execute_psiCalcul", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-a597e913 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2777 | if (popup != null) ▸ if (do_save) | RETURN | return result.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1746eba0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2781 | if (popup != null) ▸ else of (do_save) | MESSAGE | MessageBox.Show | ("Cannot save data : Unknown reason") | 메시지 표시 |  |  |  |
| AC-392a2c96 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2786 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-393ea747 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2705 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9ceb46f3 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2709 | if (popup != null) | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00601_EXCEL", popup.Filter, CurrentUser, "SELECT", "EXCEL_ROW_IMPORT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dd25d58f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2710 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-347b5500 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2713 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b29a9fc5 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2792 |  | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-57ace2c7 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2795 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-937477cb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2803 | if (popup != null) ▸ try | UI_PROP | amend.ShopType | ShopType.PACK | 속성 ShopType 설정 |  |  |  |
| AC-9b9c9813 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2804 | if (popup != null) ▸ try | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-c9622fe9 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2805 | if (popup != null) ▸ try | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-1a0ad2f1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2806 | if (popup != null) ▸ try | UI_PROP | amend.Filter | popup.Filter | 속성 Filter 설정 |  |  |  |
| AC-ac22354f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2807 | if (popup != null) ▸ try | UI_PROP | amend.PlanId | Filter["PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-81e5d002 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2808 | if (popup != null) ▸ try | UI_PROP | amend.sInstanceId | Filter["INSTANCE_ID"] | 속성 sInstanceId 설정 |  |  |  |
| AC-c0805003 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2810 | if (popup != null) ▸ try | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-37f06b83 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2812 | if (popup != null) ▸ try | RETURN | return amend.dsValidationReturn; |  | 처리 중단/반환 |  |  |  |
| AC-53bfbbc2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2817 | if (popup != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-8c074fbc | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2820 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.cboPlanId_changed

진입점: cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8eaa4f2 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4306 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b8502713 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4308 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f51d7736 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4309 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3d1b380a | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4310 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-519dfcfb | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4311 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-75b581a9 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4312 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1de9345f | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4314 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c08f519 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4348 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-cab2e2d5 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4351 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-7db4ace3 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4352 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-91bc6593 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4355 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-ca06b5d1 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4356 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-37578795 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4357 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-d073caa7 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4358 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-86b0ed7a | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4359 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-33cf3cec | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4364 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-e0583e90 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4365 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-cdb5446a | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4370 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a93374cc | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4371 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8b28266f | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4372 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-92bc501c | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4373 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-bd4ad1c8 | cboPlanId.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4374 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00600_PlanAmend_Model_Pack.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb8f1de1 | this.Load | FP00600_PlanAmend_Model_Pack.cs:443 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-07a70d37 | this.Load | FP00600_PlanAmend_Model_Pack.cs:443 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-f1f4f9d2 | this.Load | FP00600_PlanAmend_Model_Pack.cs:445 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00600_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a785427 | this.Load | FP00600_PlanAmend_Model_Pack.cs:445 |  | POPUP | new FP00600_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-6e9cd2ed | this.Load | FP00600_PlanAmend_Model_Pack.cs:446 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00600_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e735992 | this.Load | FP00600_PlanAmend_Model_Pack.cs:446 |  | POPUP | new FP00600_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-306b5cbe | this.Load | FP00600_PlanAmend_Model_Pack.cs:449 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-46eb6f9e | this.Load | FP00600_PlanAmend_Model_Pack.cs:450 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-bc194ed5 | this.Load | FP00600_PlanAmend_Model_Pack.cs:451 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b6fd7dc | this.Load | FP00600_PlanAmend_Model_Pack.cs:452 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-464f2a0f | this.Load | FP00600_PlanAmend_Model_Pack.cs:453 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-c69baf80 | this.Load | FP00600_PlanAmend_Model_Pack.cs:454 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00600_PlanAmend_Model_Pack.chk_Info_CheckedChanged

진입점: chk_info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d1c2f43 | chk_info.CheckedChanged | FP00600_PlanAmend_Model_Pack.cs:4460 | if (chk_info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-2d0907f5 | chk_info.CheckedChanged | FP00600_PlanAmend_Model_Pack.cs:4460 | if (chk_info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-904c1a25 | chk_info.CheckedChanged | FP00600_PlanAmend_Model_Pack.cs:4466 | else of (chk_info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-7671996b | chk_info.CheckedChanged | FP00600_PlanAmend_Model_Pack.cs:4467 | else of (chk_info.Checked) ▸ if (flo2 != null) | FOCUS | chk_info.Focus | () | 포커스 이동 |  |  |  |

## FP00600_PlanAmend_Model_Pack.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9699184 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4072 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-34e8be33 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4073 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f01d1191 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4074 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2860267 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4075 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bbac8b9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4076 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d21aad8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4077 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd835f11 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4078 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-317c34bc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4079 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c78bc81b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4080 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d671a58e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4081 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OPERATION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-07161084 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4082 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PRODUCTION_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3aaa655b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4083 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f19975e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4084 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-820f983a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4085 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LINE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7ea0e67 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4086 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ELECTRODE_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9960d1d6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4087 |  | DATA_OP | dt.Columns.Add | (new DataColumn("LOCATION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a922a2be | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4088 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-88c4c109 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4089 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c93bb09a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4090 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e06c1841 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4091 |  | DATA_OP | dt.Columns.Add | (new DataColumn("BOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ee17df6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4092 |  | DATA_OP | dt.Columns.Add | (new DataColumn("IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-90200afa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4093 |  | DATA_OP | dt.Columns.Add | (new DataColumn("OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c145293f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4094 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-52dcf656 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4095 |  | DATA_OP | dt.Columns.Add | (new DataColumn("EOH_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-34de7d2c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4096 |  | DATA_OP | dt.Columns.Add | (new DataColumn("YIELD", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-51902f49 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4099 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_IN_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8de719b6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4100 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_OUT_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1560d8e0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4102 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-87915a37 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4108 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d246c0df | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4111 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.CreateEditShipmentDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dtShipment == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99a9d8d4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4117 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-50934e6a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4118 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e4f452a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4119 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7052ced0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4120 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-80c1eb6d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4121 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8415bb38 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4122 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c203778e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4123 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f5f1207 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4124 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c6075a4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4125 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1e82e06 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4126 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TOP_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c62e6092 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4127 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a256c125 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4130 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_SALES_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e9d0c3d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4132 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ccc17f92 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4137 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a784d0c2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:4140 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.CreateFilterDataSet

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18f50de2 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1659 | if (dsResult == null \|\| dsTotal == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ea58d11c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1670 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-fa77b627 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1671 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-2045e870 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1682 | if (measure["chk_sales"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ee2a2fb | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1690 | if (measure["chk_ssp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SSP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-948b9a36 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1694 | if (measure["chk_past_sales"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PAST_SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbb726b4 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1698 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b721226 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1702 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-363b7fd8 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1706 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a72b866 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1710 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-70957b8b | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1714 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad1310d6 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1718 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bb3ed9b | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1722 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_WPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e16bbdc | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1726 | if (measure["chk_inventory"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d724db0 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1730 | if (measure["chk_ssp_inventory"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "I_SSP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b4d9aef | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1734 | if (measure["chk_do"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "DO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-738783b8 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1738 | if (measure["chk_BOH_2nd"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "BOH_2ND_EXPECT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0c825a1 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1742 | if (measure["chk_activated"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "BOH_2ND_ACTIVATED")) | 데이터 객체 조작/조회 |  |  |  |
| AC-593dc0f3 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1746 | if (measure["chk_sspSimul"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SSP_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-40adc4d1 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1750 | if (measure["chk_sspSimul_inventory"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "I_SSP_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b22aab56 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1755 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-79e27ce3 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1762 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b80efa10 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1763 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SSP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e11cf92 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1764 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "PAST_SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e29d8d9 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1765 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1316a5cc | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1766 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0428773 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1767 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-61b844d0 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1768 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-be721a65 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1769 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_MPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b2a61d | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1770 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c3086fc | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1771 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_WPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4f3094c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1772 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b828727 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1773 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "I_SSP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3c26576 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1774 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "DO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-45a7122c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1775 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "BOH_2ND_EXPECT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a230d98 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1776 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "BOH_2ND_ACTIVATED")) | 데이터 객체 조작/조회 |  |  |  |
| AC-184bccc5 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1777 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SSP_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-917842e0 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1778 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "I_SSP_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fb74cc0 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1784 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c98190f4 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1785 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SSP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a2da377 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1786 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "PAST_SALES")) | 데이터 객체 조작/조회 |  |  |  |
| AC-36b80b29 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1787 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a95fd483 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1788 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b2ea534 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1789 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-babf0677 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1790 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65fc4497 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1791 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_MPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-334a013d | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1792 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fd7e5bb | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1793 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_WPP_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d88ea34b | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1794 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b603ccb | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1795 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "I_SSP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b00b9d1 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1796 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "DO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffdf1132 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1797 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "BOH_2ND_EXPECT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfcd41c8 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1798 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "BOH_2ND_ACTIVATED")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a64c627 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1799 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SSP_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-849a87a7 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1800 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "I_SSP_SIMUL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-86cb0e12 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1803 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-586b7c9f | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1804 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3189ec1c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1808 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd92a6df | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1812 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b654facb | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1815 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b411236 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1817 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80da7b0b | this.Load | FP00600_PlanAmend_Model_Pack.cs:401 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-86ab6679 | this.Load | FP00600_PlanAmend_Model_Pack.cs:402 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b2293df | this.Load | FP00600_PlanAmend_Model_Pack.cs:403 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.dCalendar_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-368ce6f1 | drpPeriod.ValueChanged | FP00600_PlanAmend_Model_Pack.cs:4492 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ca40195 | drpPeriod.ValueChanged | FP00600_PlanAmend_Model_Pack.cs:4499 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-28ff54f5 | drpPeriod.ValueChanged | FP00600_PlanAmend_Model_Pack.cs:4500 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e22fcf9 | DeleteButton | FP00600_PlanAmend_Model_Pack.cs:967 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00600_PlanAmend_Model_Pack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f894a05 | Dispose | FP00600_PlanAmend_Model_Pack.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00600_PlanAmend_Model_Pack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ab42032 | EditButton | FP00600_PlanAmend_Model_Pack.cs:975 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-d657042a | EditButton | FP00600_PlanAmend_Model_Pack.cs:977 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00600_PlanAmend_Model_Pack.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4e5c28c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00600_PlanAmend_Model_Pack.cs:4770 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-492f9ada | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00600_PlanAmend_Model_Pack.cs:4771 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e21b932 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00600_PlanAmend_Model_Pack.cs:4772 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-1a14cf73 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00600_PlanAmend_Model_Pack.cs:4774 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a170849d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00600_PlanAmend_Model_Pack.cs:4785 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-f9537075 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00600_PlanAmend_Model_Pack.cs:4786 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66acf1a1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:4827 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45f72129 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:4828 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-536031ee | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:4829 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-9fad36db | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:4831 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0858aef8 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:4839 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-8817f728 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:4840 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-605e6d13 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:4845 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].SafeString() == "M")] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null &&…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d479f863 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00600_PlanAmend_Model_Pack.cs:4796 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a71cb214 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00600_PlanAmend_Model_Pack.cs:4798 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-14a1f9c7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00600_PlanAmend_Model_Pack.cs:4799 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-709b3c20 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00600_PlanAmend_Model_Pack.cs:4801 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0fe1cd5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00600_PlanAmend_Model_Pack.cs:4811 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ff048fe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00600_PlanAmend_Model_Pack.cs:4817 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5710e1bc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 1 | FP00600_PlanAmend_Model_Pack.cs:4819 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd43749c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00600_PlanAmend_Model_Pack.cs:1879 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-331c3d6a | ExcelButton | FP00600_PlanAmend_Model_Pack.cs:1852 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d040b039 | ExcelButton | FP00600_PlanAmend_Model_Pack.cs:1853 |  | VALUE_SET | select_popup.Text | "SELECT EXCEL TYPE" | 컨트롤 값 설정 |  |  |  |
| AC-311f38f6 | ExcelButton | FP00600_PlanAmend_Model_Pack.cs:1854 |  | CALL_EXT | select_popup.SetOption | (0, "Cascaded Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-531a74fa | ExcelButton | FP00600_PlanAmend_Model_Pack.cs:1855 |  | CALL_EXT | select_popup.SetOption | (1, "Seperated Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c49a2d68 | ExcelButton | FP00600_PlanAmend_Model_Pack.cs:1856 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e3abb72a | ExcelButton | FP00600_PlanAmend_Model_Pack.cs:1863 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | base.ExcelOption | ExcelExportOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |
| AC-bd877e8b | ExcelButton | FP00600_PlanAmend_Model_Pack.cs:1869 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |

## FP00600_PlanAmend_Model_Pack.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.SheetName == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-785fc955 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2249 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-1507229b | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2250 | try | LIST_CLEAR | dgShipment.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-7a5b37f0 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2254 | try | FLAG | dsYieldChild | AmendService.FindYieldInfoChild(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-99cc996a | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2254 | try | CALL_EXT | AmendService.FindYieldInfoChild | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b41fb92f | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2255 | try | FLAG | dtOcv2Lt | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-896d1eb2 | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2255 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "OCV2_LT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c213f56c | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2257 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b67a868e | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2259 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-6dde63ef | popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_… 외 6 | FP00600_PlanAmend_Model_Pack.cs:2265 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00600_PlanAmend_Model_Pack.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026dc1a3 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:777 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.FindTotalValue

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == Dialo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6cb67ec | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:2223 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00600_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5e4b1f66 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:2224 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b3700568 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:2230 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00600_PlanAmend_Model_Pack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ceea2e0 | this.Load | FP00600_PlanAmend_Model_Pack.cs:155 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetBasisTime

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25650490 | this.Load | FP00600_PlanAmend_Model_Pack.cs:286 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter… | 화면 필드/플래그 변경 |  |  |  |
| AC-b8b6f834 | this.Load | FP00600_PlanAmend_Model_Pack.cs:286 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetDivision

진입점: cboInstance.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbd938d8 | cboInstance.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:1962 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-22d74c32 | cboInstance.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:1962 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c6de2ca | cboInstance.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:1964 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetFactory

진입점: cboPlanId.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e94e7adf | cboPlanId.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:2063 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-16aecd09 | cboPlanId.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:2063 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f56fd4e | cboPlanId.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:2068 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetFilter

진입점: this.Load [if (dtPlanId.Good())] / cboPlanId.SelectedIndexChanged [if (dtPlanId.Good())] / popSql.OnSql [if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK") ▸ try] / this.cboPlanId.DropDown [if (dtPlanId.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSp…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd74c1bf | this.Load [if (dtPlanId.Good())] 외 10 | FP00600_PlanAmend_Model_Pack.cs:1957 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetFpPlandId

진입점: cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eab22b9a | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2030 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-765e6963 | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2030 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-07b8ddba | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2031 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0955fda9 | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2034 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d1870ede | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2034 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b9f9851 | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2035 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0bb141cd | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2039 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-78fd36b0 | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2039 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03a62dc8 | cboInstance.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2040 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetFpPlanId

진입점: this.Load / this.cboPlanId.DropDown / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a2e181c | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:229 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-965af184 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:229 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ca398f04 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:230 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3493bbee | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:234 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d3b1c6f | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:235 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e71a1525 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:236 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-73802ac1 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:237 | if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f76eca8 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:247 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-bb6b762a | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:248 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-1d920867 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:249 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-6b51ccab | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:250 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-29a6ecfc | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:251 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-58105e6f | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:253 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-9bcf9ef4 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:255 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6c4a54f | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:256 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-15004eeb | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:258 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-3d01ecce | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:259 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-996ff334 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:267 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38074e5c | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:268 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d17fe38f | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:269 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d2f7d62 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:270 | else of (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-403e506d | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:274 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-473f3995 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:275 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0ea2571b | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:276 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-8433b919 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:277 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-82a1ea01 | this.Load 외 2 | FP00600_PlanAmend_Model_Pack.cs:278 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetLine

진입점: clbPlanner.SelectedIndexChanged / clbOperation.SelectedIndexChanged / chk_allLine.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a80bd93 | clbPlanner.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2086 |  | DATA_OP | Filter["ALL_LINE"] | chk_allLine.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-bcb851b7 | clbPlanner.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2087 |  | DATA_OP | Filter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-1607a78b | clbPlanner.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2089 |  | FLAG | dtLine | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-3d897e78 | clbPlanner.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2089 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "LINE_CODE_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c67266b9 | clbPlanner.SelectedIndexChanged 외 2 | FP00600_PlanAmend_Model_Pack.cs:2090 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetOperation

진입점: clbFactory.SelectedIndexChanged / memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f63b699 | clbFactory.SelectedIndexChanged 외 3 | FP00600_PlanAmend_Model_Pack.cs:2073 |  | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-84a457ab | clbFactory.SelectedIndexChanged 외 3 | FP00600_PlanAmend_Model_Pack.cs:2073 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "OPERATION_CODE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b768f516 | clbFactory.SelectedIndexChanged 외 3 | FP00600_PlanAmend_Model_Pack.cs:2074 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetPlanGroup

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d8d2b03 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:2017 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth ,… | 화면 필드/플래그 변경 |  |  |  |
| AC-2848e996 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:2018 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff28035c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:2023 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-ea821146 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:2025 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetPlanner

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e242ad0 | this.Load 외 1 | FP00600_PlanAmend_Model_Pack.cs:1978 |  | FLAG | dtPlanner | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-1161ec09 | this.Load 외 1 | FP00600_PlanAmend_Model_Pack.cs:1978 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLANNER_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e826741d | this.Load 외 1 | FP00600_PlanAmend_Model_Pack.cs:1979 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, clbPlanner, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-a60574f4 | this.Load 외 1 | FP00600_PlanAmend_Model_Pack.cs:1991 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (clbPlanner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row["D… | CALL_EXT | clbPlanner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1aebeb39 | this.Load 외 1 | FP00600_PlanAmend_Model_Pack.cs:1995 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (clbPlanner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of (r… | CALL_EXT | clbPlanner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-291dde27 | this.Load 외 1 | FP00600_PlanAmend_Model_Pack.cs:2009 | if (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-2a46c6b0 | this.Load 외 1 | FP00600_PlanAmend_Model_Pack.cs:2011 | else of (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetPlant

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-725164ad | cboSite.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:2054 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-b3494c24 | cboSite.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:2054 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63167a19 | cboSite.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:2056 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetProdType

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62dc9fa8 | clbDivision.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:2079 |  | FLAG | dtProdType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-0084bdaa | clbDivision.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:2079 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PROD_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d150e2a3 | clbDivision.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:2080 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GetSite

진입점: clbDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1ba934e | clbDivision.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:2047 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-fd9d2754 | clbDivision.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:2047 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d4a2ab8 | clbDivision.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:2049 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89fefc72 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2105 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-545275f0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:983 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4660c334 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:985 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-933ecc17 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1027 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ee7c880 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1028 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-397c025f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1057 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-930fed7a | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1058 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-4e310dbb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1087 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1097d796 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1088 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-698445aa | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1103 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00600_PlanAmend_Model_Pack.GoEditMode

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoIn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53f35459 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1126 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f26ab350 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1136 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-965b2558 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1137 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-67e4c935 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1188 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03d89edd | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1199 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ad664a2 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1200 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-13ddbf16 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1213 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82848108 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1214 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c691a153 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1230 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-7dff892c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1247 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(248, 203, 173)… | 그리드 표시 설정 |  |  |  |
| AC-9c5b61f7 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1252 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00600_PlanAmend_Model_Pack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4532921c | this.Load | FP00600_PlanAmend_Model_Pack.cs:170 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b65fa23 | this.Load | FP00600_PlanAmend_Model_Pack.cs:174 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-efb0671f | this.Load | FP00600_PlanAmend_Model_Pack.cs:175 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-074d04ce | this.Load | FP00600_PlanAmend_Model_Pack.cs:179 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f371203b | this.Load | FP00600_PlanAmend_Model_Pack.cs:183 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ebd04000 | this.Load | FP00600_PlanAmend_Model_Pack.cs:187 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bf075233 | this.Load | FP00600_PlanAmend_Model_Pack.cs:189 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNo… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-a8f9675b | this.Load | FP00600_PlanAmend_Model_Pack.cs:189 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5be9ad57 | this.Load | FP00600_PlanAmend_Model_Pack.cs:194 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-0cfb0cea | this.Load | FP00600_PlanAmend_Model_Pack.cs:196 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ca9ca718 | this.Load | FP00600_PlanAmend_Model_Pack.cs:199 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b111517c | this.Load | FP00600_PlanAmend_Model_Pack.cs:201 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-e455088f | this.Load | FP00600_PlanAmend_Model_Pack.cs:203 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a003421b | this.Load | FP00600_PlanAmend_Model_Pack.cs:204 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6ac96f68 | this.Load | FP00600_PlanAmend_Model_Pack.cs:204 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3a586910 | this.Load | FP00600_PlanAmend_Model_Pack.cs:208 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-033fbef7 | this.Load | FP00600_PlanAmend_Model_Pack.cs:209 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(27) | 속성 Value2 설정 |  |  |  |
| AC-3ba2a8b8 | this.Load | FP00600_PlanAmend_Model_Pack.cs:212 |  | FLAG | dtShipment | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00600_PlanAmend_Model_Pack", "SHI… | 화면 필드/플래그 변경 |  |  |  |
| AC-c4d3a20b | this.Load | FP00600_PlanAmend_Model_Pack.cs:212 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00600_PlanAmend_Model_Pack", "SHIPMENT_OPTION") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2403449 | this.Load | FP00600_PlanAmend_Model_Pack.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtShipment, cboShipment, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.InitEditingBuf

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79ed2c1c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:3115 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-34af8762 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:3116 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-07140c8b | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:3117 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-abec27d2 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:3118 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2358ede2 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:3119 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-fd647850 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:3120 |  | FLAG | dlData | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e9d34dfd | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:3121 |  | FLAG | dlView | null | 화면 필드/플래그 변경 |  |  |  |

## FP00600_PlanAmend_Model_Pack.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77ce10b4 | this.Load | FP00600_PlanAmend_Model_Pack.cs:358 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c8c07976 | this.Load | FP00600_PlanAmend_Model_Pack.cs:359 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a83c1bf3 | this.Load | FP00600_PlanAmend_Model_Pack.cs:360 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-bdf7aed9 | this.Load | FP00600_PlanAmend_Model_Pack.cs:361 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-90084e3e | this.Load | FP00600_PlanAmend_Model_Pack.cs:362 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-085c9563 | this.Load | FP00600_PlanAmend_Model_Pack.cs:363 |  | UI_PROP | clbProdType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-425a8e3b | this.Load | FP00600_PlanAmend_Model_Pack.cs:364 |  | UI_PROP | clbPlanner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-aad9426b | this.Load | FP00600_PlanAmend_Model_Pack.cs:365 |  | UI_PROP | cboSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.InitSpread

진입점: this.Load / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogRes…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7722340d | this.Load 외 6 | FP00600_PlanAmend_Model_Pack.cs:415 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa88e22b | this.Load 외 6 | FP00600_PlanAmend_Model_Pack.cs:416 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6f42ce5f | this.Load 외 6 | FP00600_PlanAmend_Model_Pack.cs:418 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5927355b | this.Load 외 6 | FP00600_PlanAmend_Model_Pack.cs:422 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00600_PlanAmend_Model_Pack.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab37a393 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:930 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2c191904 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:935 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | MESSAGE | MessageBox.Show | ("Please select row with model first") | 메시지 표시 |  |  |  |
| AC-b243ef22 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:936 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60d511e5 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:938 | if (row != null) | POPUP | new FP00601_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-bb155c0d | InsertButton | FP00600_PlanAmend_Model_Pack.cs:939 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-de6610c6 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:939 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7a7f3fdc | InsertButton | FP00600_PlanAmend_Model_Pack.cs:940 | if (row != null) | UI_PROP | popup.DateMap | dateMap.Tables[0].Copy() | 속성 DateMap 설정 |  |  |  |
| AC-91874644 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:940 | if (row != null) | DATA_OP | dateMap.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c3f05c5 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:943 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b7b5046 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:944 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c2f317d | InsertButton | FP00600_PlanAmend_Model_Pack.cs:945 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39fc6af6 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:947 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d143826f | InsertButton | FP00600_PlanAmend_Model_Pack.cs:948 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-49a41d06 | InsertButton | FP00600_PlanAmend_Model_Pack.cs:959 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00600_PlanAmend_Model_Pack.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63d0fdfb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1922 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00600_PlanAmend_Model_Pack.MakeMemoBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-509e7048 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:723 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-287102fe | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:727 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.mcbo_planner_changed

진입점: clbPlanner.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5e69a4e | clbPlanner.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4270 | if (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-a9635f86 | clbPlanner.SelectedIndexChanged | FP00600_PlanAmend_Model_Pack.cs:4272 | else of (!dtPlanner.Good()) | VALUE_SET | chk_allLine.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.onAlarmMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c2b76e9 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2954 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab2a37df | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2957 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd60abcb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2961 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15468e7b | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2965 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-f58b8146 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2965 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6541c3ef | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2967 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-8332886a | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2968 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-0e8103c5 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2968 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e0a4e12 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2969 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ba1404b2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2970 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-70793223 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2971 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d3cea869 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2975 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d37b904f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2977 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fb634a50 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:2982 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00600_PlanAmend_Model_Pack.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-028415df | memo_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2933 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a25b7791 | memo_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2936 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-374a7506 | memo_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2942 | if (calendar != null) | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00600_PlanAmend_Model_Pack.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-337f68e0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3053 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0ccfe88 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3056 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2fdc57d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3074 | if (day != null) | POPUP | new FP00601_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4c39c52d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3075 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | frm.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8d7c0526 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3075 | if (day != null) | DATA_OP | frm.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-16fbdd4d | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3076 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["FP_PLAN_ID"] = Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f9e3833c | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3076 | if (day != null) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-630923d2 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3077 | if (day != null) | DATA_OP | frm.Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ec1142fc | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3077 | if (day != null) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f2586a5c | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3078 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-57a8a0e0 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3079 | if (day != null) | DATA_OP | frm.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c0e6aef1 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3080 | if (day != null) | DATA_OP | frm.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-b99f6bbb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3081 | if (day != null) | DATA_OP | frm.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-29bd1f93 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3082 | if (day != null) | DATA_OP | frm.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-78b3fb73 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3083 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f00751fb | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3084 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ded6545 | bucke_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2829 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4206760d | bucke_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2832 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2413bbce | bucke_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2839 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1dd5b637 | bucke_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2879 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00600_PlanAmend_Model_Pack.onZeroMaterialMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1561cb8 | bucke_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2889 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b3e852f | bucke_menu.Click | FP00600_PlanAmend_Model_Pack.cs:2892 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.OpenAlarmMemo

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c2b4ad3 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5466 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-e104fa1c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5466 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-210eabed | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5468 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-2092500a | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5469 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f348f226 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5469 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-49ff1b5f | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5470 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-19a8da0a | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5471 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c7542f62 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5472 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bc9816b6 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5476 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1d4bc41e | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5478 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bf5e4a3b | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5483 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00600_PlanAmend_Model_Pack.OpenLineMemo

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d905cd1 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5426 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-e3a7be5b | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5427 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-af0f8083 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5428 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-a8f97495 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5428 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-223ecc26 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5429 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-1ba38163 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5430 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dbd0dd5c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5431 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5178eb64 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5435 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8f32dce0 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5437 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00600_PlanAmend_Model_Pack.OpenMaterialMemo

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cc9cf7a | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5443 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-70cbf5c9 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5444 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-856e9e02 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5445 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f6efc46a | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5445 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0b5f0252 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5446 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ae1198eb | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5447 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-74de835c | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5448 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-baf9dde3 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5452 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-785fbf89 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 1 | FP00600_PlanAmend_Model_Pack.cs:5454 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00600_PlanAmend_Model_Pack.planday_changed

진입점: cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-611f2b6f | cboInstance.SelectedIndexChanged 외 1 | FP00600_PlanAmend_Model_Pack.cs:4432 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00600_PlanAmend_Model_Pack.Query

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20c56186 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:630 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-037ebecc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:630 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2f5227eb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:631 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-68f52165 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:636 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-f4e7c69a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:659 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-b65b1c2f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:665 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-e2c898af | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:665 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1e1be1da | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:666 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-7b4701d8 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:666 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1f01c629 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:669 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9571fbce | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:676 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-f80a32f4 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:681 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f39e5a3 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:682 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c87ea42c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 10 | FP00600_PlanAmend_Model_Pack.cs:684 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00600_PlanAmend_Model_Pack.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed05e32d | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:461 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-4f75d10d | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:462 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-71fff38e | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:463 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a7baf8ea | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:464 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-7b82ef44 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:481 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6e1b496 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:484 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-1ee406a0 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:485 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94f3cb8f | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:486 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b920d72b | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:487 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c968243 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:490 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c8d01ce | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:491 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6aaa4668 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:493 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-adddf63c | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:496 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f44090ee | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:497 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3144a74c | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:535 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-42270192 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:554 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-15df4a6b | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:558 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-86005ee9 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:560 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7271fece | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:564 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-425fbdcc | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:587 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-4f0d7740 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:605 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-24e20b32 | this.Load [try ▸ else of (monthInfo == null)] 외 10 | FP00600_PlanAmend_Model_Pack.cs:613 | if (monthInfo != null) | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00600_PlanAmend_Model_Pack.RefreshHeaderOnly

진입점: this.Load [try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnBucket.Click …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-940877c6 | this.Load [try] 외 7 | FP00600_PlanAmend_Model_Pack.cs:744 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-fccf546d | this.Load [try] 외 7 | FP00600_PlanAmend_Model_Pack.cs:745 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-d25db802 | this.Load [try] 외 7 | FP00600_PlanAmend_Model_Pack.cs:746 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de513339 | this.Load [try] 외 7 | FP00600_PlanAmend_Model_Pack.cs:747 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8bb2ff69 | this.Load [try] 외 7 | FP00600_PlanAmend_Model_Pack.cs:748 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.RefreshSpreadSheet

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32a39b22 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1833 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-a8d7ed01 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1834 |  | LIST_CLEAR | dgShipment.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-d17bb6f8 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1838 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a9f1b18 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1844 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00600_PlanAmend_Model_Pack.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b1e178f | popSql.OnSql | FP00600_PlanAmend_Model_Pack.cs:2206 | if (programID == "PR_UI_FP00600_PLAN_AMEND_BY_MODEL_PACK") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-4ded7055 | popSql.OnSql | FP00600_PlanAmend_Model_Pack.cs:2208 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-636d0092 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1273 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5debbd74 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1294 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f3407fe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1295 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-01cacd51 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1301 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-df5a2e72 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1303 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b84ecb65 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1312 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-a6e73376 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1313 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ffada098 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1314 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f7ea5b0b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1329 | try ▸ if (editDs.Good()) ▸ if (dtShipment == null) | FLAG | dtShipment | CreateEditShipmentDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-9a84ceb9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1341 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a1427bb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1350 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7b498ba | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1351 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e11c6de1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1352 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8433bd8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1353 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a96a82fc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1354 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2fb30e23 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1355 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a086e572 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1356 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-99bba245 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1357 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-493c0b04 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1358 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcc6aa78 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1359 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-54f3639a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1360 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d769106b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1361 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-65263df8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1362 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e3cf5e0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1363 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-ada9762b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1364 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-14abe6d7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1365 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b76bae1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1366 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf7fb73e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1367 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-67717467 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1348 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-0666eb60 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1393 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c961ffd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1398 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-f2309ba1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1399 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-3f9bd81e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1400 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-8c6bf006 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1414 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33d3e7f5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1416 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab2dea44 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1417 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab463407 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1418 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e71d5022 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1419 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57802637 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1420 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a9567f1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1421 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a7d80ec | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1422 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a4bed816 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1423 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OPERATION_ID"] | enum_row_from_Saving["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3baccce | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1424 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PRODUCTION_TYPE"] | enum_row_from_Saving["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30cdff49 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1425 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-af59b47c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1426 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["FACTORY_ID"] | enum_row_from_Saving["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fb0c62ef | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1427 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LINE_ID"] | enum_row_from_Saving["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f926bedc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1428 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ELECTRODE_TYPE"] | enum_row_from_Saving["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-51549c8e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1429 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["LOCATION"] | enum_row_from_Saving["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6b721c11 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1430 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-f3ac3b46 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1431 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5eea89e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1432 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69ffbea3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1433 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_TYPE"] | enum_row_from_Saving["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80c5b6c2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1435 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["IN_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-5c3607e6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1436 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["OUT_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-aeb11b6f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1437 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_IN_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-1aafc37d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1438 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_OUT_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-eb2022d3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1440 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-1dbbaa55 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1442 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-fece4fe1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1454 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3bc4512 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1455 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c65b0fa9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1457 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8fdfd84 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1458 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0063202 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1459 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7690066 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1460 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-95418099 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1461 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3536e18 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1462 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-40022598 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1463 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9fc2d848 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1452 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("FP_PL… |  | 처리 중단/반환 |  |  |  |
| AC-579ca48c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1489 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditShipmentGrid.Count() … | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-e624b604 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1494 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditShipmentGrid.Count() … | DATA_OP | selected["SALES_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-b35d8e2d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1495 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditShipmentGrid.Count() … | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-beeb64e8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1509 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | dtShipment.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e5ac7a6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1511 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d1d8e7b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1512 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["FP_PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-02eb7f8e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1514 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["CATEGORY_ID"] | "SHIPMENT_SIMUL" | 행/컬럼 값 대입 |  |  |  |
| AC-f0af55fc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1515 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ffbd148 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1516 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57e63175 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1517 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6fcf0e3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1518 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b8f4045 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1519 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-afcd4c33 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1520 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["TOP_ITEM_ID"] | enum_row_from_Saving["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-53f411b4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1522 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["SALES_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-8d3a6daa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1524 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-09471079 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1526 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditShipmentGrid.Cou… | DATA_OP | dtShipment.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f5fdb5f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1541 | try ▸ if (objDs == null && objShipmentDs == null && Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-09a823bc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1542 | try ▸ if (objDs == null && objShipmentDs == null && Filter["PLAN_TYPE"] == "RELEASE") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7b0ff7ce | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1543 | try ▸ if (objDs == null && objShipmentDs == null && Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d980bce1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1553 | try ▸ if (cboPlanId.SelectedIndex >= 0) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-5eb19516 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1558 | try | DATA_OP | BohSet["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ec1c82e2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1559 | try | DATA_OP | BohSet["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-121e759a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1560 | try | DATA_OP | BohSet["PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-38a3859c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1561 | try | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-cec45a4f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1568 | try | UI_PROP | amend.ShopType | ShopType.PACK | 속성 ShopType 설정 |  |  |  |
| AC-cc0b497f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1569 | try | UI_PROP | amend.SaveType | SaveType.SAVE | 속성 SaveType 설정 |  |  |  |
| AC-7acc0f98 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1570 | try | UI_PROP | amend.ReCalFlag | true | 속성 ReCalFlag 설정 |  |  |  |
| AC-cea13df4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1571 | try | UI_PROP | amend.ReCalEtcFlag | false | 속성 ReCalEtcFlag 설정 |  |  |  |
| AC-2eb231df | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1572 | try | UI_PROP | amend.ValidationFlag | true | 속성 ValidationFlag 설정 |  |  |  |
| AC-b1ac76fe | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1573 | try | UI_PROP | amend.ValidationEtcFlag | false | 속성 ValidationEtcFlag 설정 |  |  |  |
| AC-37dcda86 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1574 | try | UI_PROP | amend.dtSaveData | objDs | 속성 dtSaveData 설정 |  |  |  |
| AC-d3921dba | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1575 | try | UI_PROP | amend.dtSaveDataEtc | objShipmentDs | 속성 dtSaveDataEtc 설정 |  |  |  |
| AC-8195fb37 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1576 | try | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-b1875dc4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1577 | try | UI_PROP | amend.Filter | Filter | 속성 Filter 설정 |  |  |  |
| AC-15e8e22d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1578 | try | UI_PROP | amend.PlanId | GetFilter("FP_PLAN_ID") | 속성 PlanId 설정 |  |  |  |
| AC-4913c155 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1579 | try | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3155c533 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1586 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-5135f7de | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1587 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b7e83750 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1591 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fe013b4b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00600_PlanAmend_Model_Pack.cs:1593 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d027ad3 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:1598 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81a53a75 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1261 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca9b4997 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1262 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4f202d24 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1265 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c3e11a4e | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1266 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetBohQty

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60b6c005 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1628 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b14ec87d | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1629 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c55b1e92 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1634 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-97548502 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1640 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-300b5eb8 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1641 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-40a321ad | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1642 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c4f5c50 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1643 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a71aa26 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1644 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a041153 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1645 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-33367d5e | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1646 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-56b25a97 | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1647 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9baf9aea | memo_menu.Click [if (calendar != null) ▸ if (day != null) ▸ … 외 9 | FP00600_PlanAmend_Model_Pack.cs:1651 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eda093d8 | this.Load | FP00600_PlanAmend_Model_Pack.cs:308 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-8f2fa431 | this.Load | FP00600_PlanAmend_Model_Pack.cs:308 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d761da33 | this.Load | FP00600_PlanAmend_Model_Pack.cs:310 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-404082d8 | this.Load | FP00600_PlanAmend_Model_Pack.cs:316 |  | FLAG | dtLine | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-5726aa55 | this.Load | FP00600_PlanAmend_Model_Pack.cs:316 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "LINE_CODE_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-831f2527 | this.Load | FP00600_PlanAmend_Model_Pack.cs:317 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-ce7670dd | this.Load | FP00600_PlanAmend_Model_Pack.cs:321 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-d7f79636 | this.Load | FP00600_PlanAmend_Model_Pack.cs:321 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a0084bde | this.Load | FP00600_PlanAmend_Model_Pack.cs:323 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0af686a8 | this.Load | FP00600_PlanAmend_Model_Pack.cs:327 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-f8f06f54 | this.Load | FP00600_PlanAmend_Model_Pack.cs:327 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2f4de08e | this.Load | FP00600_PlanAmend_Model_Pack.cs:329 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-240ee7af | this.Load | FP00600_PlanAmend_Model_Pack.cs:333 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-14cb3739 | this.Load | FP00600_PlanAmend_Model_Pack.cs:333 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-be1a1aa0 | this.Load | FP00600_PlanAmend_Model_Pack.cs:338 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-355882f7 | this.Load | FP00600_PlanAmend_Model_Pack.cs:342 |  | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-5ecce05c | this.Load | FP00600_PlanAmend_Model_Pack.cs:342 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "OPERATION_CODE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ab665601 | this.Load | FP00600_PlanAmend_Model_Pack.cs:343 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-4ef8c3e1 | this.Load | FP00600_PlanAmend_Model_Pack.cs:349 |  | FLAG | dtProdType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-4559c84a | this.Load | FP00600_PlanAmend_Model_Pack.cs:349 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PROD_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bf8a0b8f | this.Load | FP00600_PlanAmend_Model_Pack.cs:350 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0e7005a | this.Load | FP00600_PlanAmend_Model_Pack.cs:122 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c5f49d1 | this.Load | FP00600_PlanAmend_Model_Pack.cs:124 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a10d66a8 | this.Load | FP00600_PlanAmend_Model_Pack.cs:125 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fdb5f072 | this.Load | FP00600_PlanAmend_Model_Pack.cs:126 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0bcc5222 | this.Load | FP00600_PlanAmend_Model_Pack.cs:130 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-1a82709d | this.Load | FP00600_PlanAmend_Model_Pack.cs:131 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-71b99c0a | this.Load | FP00600_PlanAmend_Model_Pack.cs:132 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a5a15c80 | this.Load | FP00600_PlanAmend_Model_Pack.cs:134 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-9c6ab2b1 | this.Load | FP00600_PlanAmend_Model_Pack.cs:135 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-699f33bd | this.Load | FP00600_PlanAmend_Model_Pack.cs:137 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-92e466a8 | this.Load | FP00600_PlanAmend_Model_Pack.cs:138 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bce562bd | this.Load | FP00600_PlanAmend_Model_Pack.cs:139 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6713d134 | this.Load | FP00600_PlanAmend_Model_Pack.cs:143 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3838ddc3 | this.Load | FP00600_PlanAmend_Model_Pack.cs:144 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7f9b6fbe | this.Load | FP00600_PlanAmend_Model_Pack.cs:145 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].SafeString() == "M")] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null &&…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cf3903b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 11 | FP00600_PlanAmend_Model_Pack.cs:5235 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetFilter

진입점: this.Load / cboInstance.SelectedIndexChanged [if (dtInstance.Good())] / clbPlanner.SelectedIndexChanged / cboPlanId.SelectedIndexChanged [if (dtPlanId.Good())] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged / txtModel.TextChanged / txtItem.TextChanged / txtPjtGroup.TextChanged / clbProdType.SelectedIndexChanged / drpPeriod.ValueChanged / chk_allLine.CheckedChanged / cboShipment.SelectedIndexChanged / popSql.OnSql [if (programID == "PR_UI_FP0060…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df7f6a10 | this.Load 외 23 | FP00600_PlanAmend_Model_Pack.cs:1952 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetMemoCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09f44b10 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3006 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-621873dc | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3006 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-95f36cdc | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3010 | if (dlData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55579756 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3026 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-986ee576 | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3036 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-df3cb55f | (진입점 미연결) | FP00600_PlanAmend_Model_Pack.cs:3040 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetPlanOutCell

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].SafeString() == "M") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96ccfee5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3133 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-adcc2823 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3133 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0afaa634 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3137 | if (dsMain.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-5477ba8d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3137 | if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9812c06a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3141 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-0946bed4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3149 | try | FLAG | UOMRate | AmendService.FindCellRate( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-fadc6756 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3149 | try | CALL_EXT | AmendService.FindCellRate | ( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].ToString(), clicked_row["… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb034d1f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3155 | try | FLAG | YieldRate | AmendService.FindYieldInfo( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-5fed6b17 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3155 | try | CALL_EXT | AmendService.FindYieldInfo | ( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].ToString(), clicked_row["P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a4c8ddb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3167 | try ▸ if (dlData != null) | UI_PROP | dlData.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-4d532c1e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3168 | try ▸ if (dlData != null) | UI_PROP | dlData.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-9bfd455f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3172 | try ▸ if (dlView != null) | UI_PROP | dlView.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-e3d6a6da | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3173 | try ▸ if (dlView != null) | UI_PROP | dlView.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-1e69737c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3180 | if (dlData == null \|\| dlView == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f26b95e1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3206 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-edc679c6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3216 | if (dsMainFiltered.Good()) ▸ if (dlData._P_OUT != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._P_OUT, cCol].Value | new_value | 그리드 속성/값 설정 |  |  |  |
| AC-89cd4cc1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3224 | if (dsMainFiltered.Good()) ▸ if (dlData._P_IN != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._P_IN, cCol].Value | in_value | 그리드 속성/값 설정 |  |  |  |
| AC-ec8d5c27 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3232 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("PLANT_ID = '" + row["PLANT_ID"].ToString() + "'" + " AND TOP_ITEM_ID = '" + row["TOP_ITE… | 데이터 객체 조작/조회 |  |  |  |
| AC-02f50d33 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3236 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("PLANT_ID = '" + row["PLANT_ID"].ToString() + "'" + " AND TOP_ITEM_ID = '" + row["TOP_ITE… | 데이터 객체 조작/조회 |  |  |  |
| AC-86bb93a9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3265 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (dlView._I != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._I, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-97e833e5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3268 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (dlView._I != -1) ▸ if (dlView._I != -1) | GRID_SET | siMain.ActiveSheet.Cells[dlData._I, next_col].Value | (existing + delta) | 그리드 속성/값 설정 |  |  |  |
| AC-4e53c3cb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3278 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (dlView._I != -1) ▸ if (bShip) ▸ if (row… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingShip + delta | 그리드 속성/값 설정 |  |  |  |
| AC-1c60319b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3293 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (dlView._I != -1) ▸ if (bShipSimul) ▸ if… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingShipSimul + delta | 그리드 속성/값 설정 |  |  |  |
| AC-16d21cc9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3297 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) | CALL_EXT | dlView.DO_INC_P_RESULT_CELL | (cell_sum, next_col, siMain, dsMain, dlData, dlView) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ca4b8e5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3303 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_ssp") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf0a2b99 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3304 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_outqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-ffcf1e2a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3305 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_ssp_inventory") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd1e6567 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3311 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_sspSimul") | 데이터 객체 조작/조회 |  |  |  |
| AC-c990741a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3312 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_outqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-4404d5d4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3313 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) | DATA_OP | measure.Data.ContainsKey | ("chk_sspSimul_inventory") | 데이터 객체 조작/조회 |  |  |  |
| AC-69c9a1c1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3332 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_outqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2641f74 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3333 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_BOH_2nd") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ef453f1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3342 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | ocvlt.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbfe5e70 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3343 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | ocvlt.Field | ("KEEP_DAYS") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa9efa7d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3346 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | CALL_EXT | Convert.ToInt16 | (Ocv2Lt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0f7625a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3350 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sOcv + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-f68f524b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3355 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | DATA_OP | dsMainFiltered.Tables[0].Select | ("LINE_ID = '" + row["LINE_ID"].ToString() + "' AND CATEGORY_ID = 'BOH_2ND_EXPECT' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-71ec3845 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3362 | if (dsMainFiltered.Good()) ▸ if (row["OPERATION_ID"].ToString().Equals("P5200") && measure.Data.ContainsKey("chk_outqty") && measure.Data.Co… | GRID_SET | siMain.ActiveSheet.Cells[nRow, nColumn].Value | Convert.ToDouble(rowOcv[0][(sOcv)]) + delta | 그리드 속성/값 설정 |  |  |  |
| AC-1d020d57 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3369 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_inqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-40f568d7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3370 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_outqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cd7a23b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3371 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_BOH_2nd") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b56a5b5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3372 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_activated") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac40ad4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3380 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | ocvlt.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-afa7c10e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3381 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | ocvlt.Field | ("KEEP_DAYS") | 데이터 객체 조작/조회 |  |  |  |
| AC-4615b635 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3384 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | CALL_EXT | Convert.ToInt16 | (Ocv2Lt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-65db8067 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3388 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sOcv + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfa58f10 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3393 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | DATA_OP | dsMainFiltered.Tables[0].Select | ("LINE_ID = '" + row["LINE_ID"].ToString() + "' AND CATEGORY_ID = 'BOH_2ND_ACTIVATED' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-f68393de | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3431 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-6aaa52ff | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3435 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_inqty") && measure.Data.ContainsKey("chk_outqty") && measure.Data.ContainsKey… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | (existing + delta) | 그리드 속성/값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetShipmentOutCell

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString() == "P_OUT" && row_to_test["DATA_TYPE"].ToString() == "DATA" && row_to_test["ZERO_Y…) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].SafeString() == "M") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-557171f5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3473 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-40fc44b7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3481 | try | FLAG | UOMRate | AmendService.FindCellRate( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-bc7ca91d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3481 | try | CALL_EXT | AmendService.FindCellRate | ( clicked_row["PLANT_ID"].ToString(), clicked_row["TOP_ITEM_ID"].ToString(), clicked_row["… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e66d9b0c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3487 | try | FLAG | YieldRate | AmendService.FindYieldInfo( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].… | 화면 필드/플래그 변경 |  |  |  |
| AC-6696d714 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3487 | try | CALL_EXT | AmendService.FindYieldInfo | ( clicked_row["DIVISION_ID"].ToString(), clicked_row["SITE_ID"].ToString(), clicked_row["P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8b1e889 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3499 | try ▸ if (dlData != null) | UI_PROP | dlData.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-9192bf55 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3500 | try ▸ if (dlData != null) | UI_PROP | dlData.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-28ef73e2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3504 | try ▸ if (dlView != null) | UI_PROP | dlView.UOMRate | UOMRate | 속성 UOMRate 설정 |  |  |  |
| AC-5f0ac3b2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3505 | try ▸ if (dlView != null) | UI_PROP | dlView.YieldRate | YieldRate | 속성 YieldRate 설정 |  |  |  |
| AC-3a254688 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3514 |  | FLAG | EditingRow | cRow | 화면 필드/플래그 변경 |  |  |  |
| AC-3e0db1fc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3517 | if (dsMainFiltered.Good()) | FLAG | dlData | DataLines.CreateDataLine(siMain, calendar, cRow, cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-de7fc91d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3517 | if (dsMainFiltered.Good()) | CALL_EXT | DataLines.CreateDataLine | (siMain, calendar, cRow, cCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7bc63c85 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3521 | if (dsMain.Good()) | FLAG | dlView | DataLines.CreateDataLine(dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | 화면 필드/플래그 변경 |  |  |  |
| AC-4df792b1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3521 | if (dsMain.Good()) | CALL_EXT | DataLines.CreateDataLine | (dsMain, siMain, calendar, clicked_row, ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57a3caa7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3527 | if (dlData == null \|\| dlView == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-befacb9f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3554 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b36fbf0e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3563 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("PLANT_ID = '" + row["PLANT_ID"].ToString() + "'" + " AND TOP_ITEM_ID = '" + row["TOP_ITE… | 데이터 객체 조작/조회 |  |  |  |
| AC-b52489e3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3568 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_sspSimul") | 데이터 객체 조작/조회 |  |  |  |
| AC-af2e7176 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3569 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_outqty") | 데이터 객체 조작/조회 |  |  |  |
| AC-7dd33f68 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3570 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_sspSimul_inventory") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f51c146 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 3 | FP00600_PlanAmend_Model_Pack.cs:3603 | if (dsMainFiltered.Good()) ▸ while (!string.IsNullOrEmpty(n_col)) ▸ if (n_col.StartsWith("D")) ▸ if (bShip) ▸ if (rowShipSimul.Length > 0) | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existingShip - delta | 그리드 속성/값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SetSpreadInit

진입점: this.Load [try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnBucket.Click …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb489581 | this.Load [try] 외 6 | FP00600_PlanAmend_Model_Pack.cs:430 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b3a6427 | this.Load [try] 외 6 | FP00600_PlanAmend_Model_Pack.cs:431 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SheetChanged

진입점: dsdmAmend.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d23c671 | dsdmAmend.Changed | FP00600_PlanAmend_Model_Pack.cs:4887 | if (!this.CanModelChange \|\| e.Row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00600_PlanAmend_Model_Pack.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d7ac83b | this.spdMain.ButtonClicked | FP00600_PlanAmend_Model_Pack.cs:4893 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-022fff23 | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4151 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db921794 | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4152 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5496b0a | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4175 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-eca28b8c | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4176 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-2a6458d5 | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4178 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-610506da | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4187 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-f91924ca | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4188 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-aecd580e | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4190 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-8614c56f | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4196 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12eb8231 | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4201 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-1dffc79b | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4202 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-692614e6 | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4204 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c7e8ee4 | this.spdMain.CellClick | FP00600_PlanAmend_Model_Pack.cs:4212 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14b56420 | this.spdMain.CellDoubleClick | FP00600_PlanAmend_Model_Pack.cs:5261 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(e.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79ee0ebc | this.spdMain.CellDoubleClick | FP00600_PlanAmend_Model_Pack.cs:5277 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-e79a0f38 | this.spdMain.CellDoubleClick | FP00600_PlanAmend_Model_Pack.cs:5284 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00600_PlanAmend_Model_Pack.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a85ea4d | this.spdMain.ClipboardPasted | FP00600_PlanAmend_Model_Pack.cs:4690 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-615a7d99 | this.spdMain.ClipboardPasted | FP00600_PlanAmend_Model_Pack.cs:4698 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d0b4c5aa | this.spdMain.ClipboardPasted | FP00600_PlanAmend_Model_Pack.cs:4699 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8de167c7 | this.spdMain.ClipboardPasted | FP00600_PlanAmend_Model_Pack.cs:4701 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00600_PlanAmend_Model_Pack.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7843c21 | this.spdMain.ClipboardPasting | FP00600_PlanAmend_Model_Pack.cs:4670 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-e474682c | this.spdMain.ClipboardPasting | FP00600_PlanAmend_Model_Pack.cs:4671 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-e112fe24 | this.spdMain.ClipboardPasting | FP00600_PlanAmend_Model_Pack.cs:4671 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a88ec342 | this.spdMain.ClipboardPasting | FP00600_PlanAmend_Model_Pack.cs:4675 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-95f61ac9 | this.spdMain.ClipboardPasting | FP00600_PlanAmend_Model_Pack.cs:4675 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-caf54ce9 | this.spdMain.ClipboardPasting | FP00600_PlanAmend_Model_Pack.cs:4679 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-493e05a2 | this.spdMain.ClipboardPasting | FP00600_PlanAmend_Model_Pack.cs:4681 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00600_PlanAmend_Model_Pack.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fceb18f | this.spdMain.EditModeOn | FP00600_PlanAmend_Model_Pack.cs:4762 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00600_PlanAmend_Model_Pack.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9293fd8 | this.spdMain.KeyDown | FP00600_PlanAmend_Model_Pack.cs:4228 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-514d8412 | this.spdMain.KeyDown | FP00600_PlanAmend_Model_Pack.cs:4232 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3fe89a4a | this.spdMain.KeyDown | FP00600_PlanAmend_Model_Pack.cs:4233 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00600_PlanAmend_Model_Pack.SwitchMemo

진입점: memo_menu.Click [if (calendar != null) ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae28500 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5295 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03d6d834 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5312 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-ee2b7a27 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5337 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b32d902 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5363 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-9b1a6c27 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5365 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-99c82e19 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5368 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab60c202 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5370 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7450aafb | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5370 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-3eed6688 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5371 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-1e25cc78 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5373 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-17efba12 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5375 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b9612f29 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5387 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fe8d6a6 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5387 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-b60d7f3b | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5407 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3bb7ef0f | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5408 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-487ccbe3 | memo_menu.Click [if (calendar != null) ▸ if (day != null)] 외 1 | FP00600_PlanAmend_Model_Pack.cs:5410 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00600_PlanAmend_Model_Pack.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc056328 | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4511 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31fba671 | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4515 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb316952 | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4516 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 65) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba3852aa | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4517 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-729f55f6 | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4518 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 50) | 데이터 객체 조작/조회 |  |  |  |
| AC-77a38f54 | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4519 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 120) | 데이터 객체 조작/조회 |  |  |  |
| AC-681a4401 | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4520 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 10) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e70a4b7 | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4525 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-cc1550af | tbNickName.BeforeOpenSearch | FP00600_PlanAmend_Model_Pack.cs:4526 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00600_PlanAmend_Model_Pack.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73703cec | tbNickName.OnSearchConditionChanged | FP00600_PlanAmend_Model_Pack.cs:4535 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e35e56d9 | tbNickName.OnSearchConditionChanged | FP00600_PlanAmend_Model_Pack.cs:4536 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-62084bc7 | tbNickName.OnSearchConditionChanged | FP00600_PlanAmend_Model_Pack.cs:4542 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-563fb701 | tbNickName.OnSearchConditionChanged | FP00600_PlanAmend_Model_Pack.cs:4545 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-49639d39 | tbNickName.OnSearchConditionChanged | FP00600_PlanAmend_Model_Pack.cs:4547 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00600_PlanAmend_Model_Pack.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true)] / this.btnCreatePlan.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cboPlanId.SelectedIndex < 0)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-655ef4ea | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:803 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d45f34cb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:804 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94e327ed | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:807 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c2d24d65 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:811 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-41d11e8a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:811 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["FP_PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-3157dccd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:815 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-44fab6f5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:816 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b3263f1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:837 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84e3a13f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:838 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40af1b11 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:842 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-09e30e25 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:846 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1d88e0d2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:847 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f162c44f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:851 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c520da28 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:862 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-af2bbaf6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:864 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-75030bb0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:864 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e920bd48 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:871 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f540742 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:873 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | LastTotalRaw | FindTotalValue() | 화면 필드/플래그 변경 |  |  |  |
| AC-a923b04d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:876 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-90861c49 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:888 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1c89ec0f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:892 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d376df9d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:898 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-26643c92 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:902 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1cb0b4e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:910 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f33fe1a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:915 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-633087aa | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 5 | FP00600_PlanAmend_Model_Pack.cs:919 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00600_PlanAmend_Model_Pack.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee7ac9d0 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1886 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-f5cbf63d | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1887 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73a3be4d | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1895 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-8284b310 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1898 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8a1f0b35 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1900 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee311963 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1907 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-d2fc0e95 | SaveButton | FP00600_PlanAmend_Model_Pack.cs:1912 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

