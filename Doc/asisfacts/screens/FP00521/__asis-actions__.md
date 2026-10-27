# AS-IS 액션 대조표 — FP00521

> 원천: `Doc/asisfacts/screens/FP00521/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 868행 · 메서드 114 · 종류 DATA_OP 407 · FLAG 75 · RETURN 72 · UI_PROP 37 · GRID_INIT 37 · MESSAGE 32 · UI_MISC 25 · GRID_SET 25 · ENDPOINT 22 · COMBO_DATA 21 · POPUP 20 · CALL_EXT 14 · VALUE_SET 12 · GRID_LOCK 12 · STATE 11 · THROW 11 · GRID_STYLE 8 · LIST_REBIND 8 · GRID_BIND 7 · CALL_BASE 5 · EXCEL 3 · STATE_RESET 2 · VALIDATE 1 · FOCUS 1 · ⚠ 의미 확인 필요 19


## FP00521_Demand_WaterFall.ApplySearchCondition

진입점: this.btnMemoDown.Click / popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98018736 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:771 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //변수 데이타테이블 DataTable dtCurrWeek = null; DataTable dtWeek… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3d87e06 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:786 | lambda | FLAG | _s_curr_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-763689cd | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:787 | lambda | FLAG | _s_bucket_from_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2af47a95 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:788 | lambda | FLAG | _s_bucket_to_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-30255c4b | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:789 | lambda | FLAG | _s_plan_from_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ce8b6af7 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:790 | lambda | FLAG | _s_plan_to_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e7c5e368 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:793 | lambda | FLAG | _s_week_info | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-81df987d | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:794 | lambda | FLAG | _s_month_week_column | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ce5d915a | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:795 | lambda | FLAG | _s_month_column_info | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a07974ce | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:796 | lambda | FLAG | _s_plan_week_Info | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3d527e80 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:798 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_currWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28c6f034 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:799 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_BucketWeekCnt", sStartDate, sEndDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9da93d83 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:805 | lambda ▸ if (dtCurrWeek != null) ▸ if (dtCurrWeek.Rows.Count>0) | FLAG | _s_curr_week | dtCurrWeek.Rows[0]["CURR_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-74cee2fa | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:813 | lambda ▸ if (dtBukWeekInfo != null) ▸ if (dtBukWeekInfo.Rows.Count > 0) | FLAG | _s_bucket_from_week | dtBukWeekInfo.Rows[0]["BUCKET_FROM_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a0e50434 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:814 | lambda ▸ if (dtBukWeekInfo != null) ▸ if (dtBukWeekInfo.Rows.Count > 0) | FLAG | _s_bucket_to_week | dtBukWeekInfo.Rows[0]["BUCKET_TO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-61917d3a | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:818 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_WeekCnt", sStartDate, sEndDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b8dd878 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:820 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_MonthColumn", sStartDate, sEndDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-698f96dd | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:821 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_PlanWeekCnt", sScpPlanID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63b12b16 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:823 | lambda | FLAG | _s_week_info | DataCommon.MakeDelimeterStringAsDataTable("WEEK", dtWeekInfo, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-d4413a84 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:823 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeekInfo, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-feeee453 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:824 | lambda | FLAG | _s_month_week_column | DataCommon.MakeDelimeterStringAsDataTable("WEEK_COLUMN", dtMonthColumn, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-41f9fd59 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:824 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK_COLUMN", dtMonthColumn, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19719583 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:825 | lambda | FLAG | _s_month_column_info | DataCommon.MakeDelimeterStringAsDataTable("MONTH_COLUMN", dtMonthColumn, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-6f77b26a | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:825 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH_COLUMN", dtMonthColumn, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2ae2aa21 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:826 | lambda | FLAG | _s_plan_week_Info | DataCommon.MakeDelimeterStringAsDataTable("PLAN_WEEK", dtPlanWeekInfo, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-6e07393b | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:826 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("PLAN_WEEK", dtPlanWeekInfo, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-00fa9355 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:832 | lambda ▸ if (dtPlanWeekInfo != null) ▸ if (dtPlanWeekInfo.Rows.Count > 0) | FLAG | _s_plan_from_week | dtPlanWeekInfo.Rows[0]["PLAN_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-14baf14c | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:833 | lambda ▸ if (dtPlanWeekInfo != null) ▸ if (dtPlanWeekInfo.Rows.Count > 0) | FLAG | _s_plan_to_week | dtPlanWeekInfo.Rows[4]["PLAN_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a94ec93 | this.btnMemoDown.Click 외 2 | FP00521_Demand_WaterFall.cs:839 | lambda | FLAG | weekInfo | dtWeekInfo.DataSet | 화면 필드/플래그 변경 |  |  |  |

## FP00521_Demand_WaterFall.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f35e0d20 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1161 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { sScpPlanID = CString.GetCheckedListValue(dtPlanID, cboPla… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0083c80 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1181 | if (string.IsNullOrEmpty(p_plant_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Plant ID is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c09446b2 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1182 | if (string.IsNullOrEmpty(p_plant_id.ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a449766 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1187 | if (string.IsNullOrEmpty(p_factory_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Building ID is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-464b4656 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1188 | if (string.IsNullOrEmpty(p_factory_id.ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a223d56 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1193 | if (string.IsNullOrEmpty(p_operation_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Operation ID is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-981d72f9 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1194 | if (string.IsNullOrEmpty(p_operation_id.ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c64f0fb0 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1199 | if (string.IsNullOrEmpty(p_line_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Line ID is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d903e88d | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1200 | if (string.IsNullOrEmpty(p_line_id.ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48be4743 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1203 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_BucketWeekCnt", sStartDate, sEndDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fa134ff5 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1211 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_PlanWeekCnt", sScpPlanID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c7ea77b6 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1222 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-11238a78 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1225 |  | POPUP | new FP00521_MemoListPopup | () | 팝업/폼 생성 |  |  |  |
| AC-cde87c59 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1226 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-0144d95e | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1228 |  | DATA_OP | memoPopup.Filter["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-40fc218d | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1229 |  | DATA_OP | memoPopup.Filter["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e0165330 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1230 |  | DATA_OP | memoPopup.Filter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-565a0084 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1231 |  | DATA_OP | memoPopup.Filter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-197da774 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1232 |  | DATA_OP | memoPopup.Filter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cbcb10a0 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1233 |  | DATA_OP | memoPopup.Filter["p_operation_id"] | p_operation_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b35b3ae | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1234 |  | DATA_OP | memoPopup.Filter["p_line_id"] | p_line_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1dd19eba | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1235 |  | DATA_OP | memoPopup.Filter["p_prod_type"] | p_prod_type.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-42f9703e | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1236 |  | DATA_OP | memoPopup.Filter["p_item_id"] | p_item_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5f1ae5b | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1237 |  | DATA_OP | memoPopup.Filter["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66f6ab4b | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1238 |  | DATA_OP | memoPopup.Filter["p_market"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-86cfae4b | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1239 |  | DATA_OP | memoPopup.Filter["p_plan_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a2e6e7b7 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1240 |  | DATA_OP | memoPopup.Filter["p_mfg_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec398606 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1241 |  | DATA_OP | memoPopup.Filter["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f58795ab | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1242 |  | DATA_OP | memoPopup.Filter["p_bucket_from_week"] | sBucket_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-7b1bf52c | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1243 |  | DATA_OP | memoPopup.Filter["p_bucket_to_week"] | sBucket_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-b7cce773 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1244 |  | DATA_OP | memoPopup.Filter["p_plan_from_week"] | sPlan_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-0d2b84db | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1245 |  | DATA_OP | memoPopup.Filter["p_plan_to_week"] | sPlan_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-cb603459 | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1247 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-c4e426af | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1248 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-430c7cbd | this.btnMemo.Click | FP00521_Demand_WaterFall.cs:1249 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00521_Demand_WaterFall.btnMemoDowm_Click

진입점: this.btnMemoDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bcc93c7 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1275 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_instance_id = CString.GetCheckedListValue(dtInstance, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0deda39 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1303 | if (string.IsNullOrEmpty(p_instance_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "SCP Plan ID is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7673cc5 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1304 | if (string.IsNullOrEmpty(p_instance_id.ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c1798f1 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1310 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-0e2abbf3 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1313 |  | POPUP | new FP00521_MemoDownPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3fa9e29b | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1315 |  | DATA_OP | DownPopup.Filter["p_instance_id"] | p_instance_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f60efa4 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1316 |  | DATA_OP | DownPopup.Filter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6a0e1893 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1317 |  | DATA_OP | DownPopup.Filter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-232ac929 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1318 |  | DATA_OP | DownPopup.Filter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5570acc2 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1319 |  | DATA_OP | DownPopup.Filter["p_operation_id"] | p_operation_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0aaddd34 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1320 |  | DATA_OP | DownPopup.Filter["p_line_id"] | p_line_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a377ac4 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1321 |  | DATA_OP | DownPopup.Filter["p_prod_type"] | p_prod_type.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a75ccdf2 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1322 |  | DATA_OP | DownPopup.Filter["p_model_id"] | p_model_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7fa20d7c | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1323 |  | DATA_OP | DownPopup.Filter["p_item_id"] | p_item_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6eb77ce4 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1324 |  | DATA_OP | DownPopup.Filter["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-efb2fac5 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1325 |  | DATA_OP | DownPopup.Filter["p_chk_total_include"] | p_chk_total_include.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e49e1f50 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1326 |  | DATA_OP | DownPopup.Filter["p_pp_option"] | p_pp_option.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa48fa89 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1327 |  | DATA_OP | DownPopup.Filter["p_curr_week"] | _s_curr_week.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b158564a | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1328 |  | DATA_OP | DownPopup.Filter["p_bucket_from_date"] | p_bucket_from_date.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a257664d | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1329 |  | DATA_OP | DownPopup.Filter["p_bucket_to_date"] | p_bucket_to_date.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-24a252eb | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1330 |  | DATA_OP | DownPopup.Filter["p_bucket_from_week"] | _s_bucket_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-b4e2b370 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1331 |  | DATA_OP | DownPopup.Filter["p_bucket_to_week"] | _s_bucket_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-3e1056bf | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1332 |  | DATA_OP | DownPopup.Filter["p_plan_from_week"] | _s_plan_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-00656d5e | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1333 |  | DATA_OP | DownPopup.Filter["p_plan_to_week"] | _s_plan_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-39408535 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1334 |  | DATA_OP | DownPopup.Filter["p_week_info"] | _s_week_info | 행/컬럼 값 대입 |  |  |  |
| AC-c90eaf7a | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1335 |  | DATA_OP | DownPopup.Filter["p_month_week_column"] | _s_month_week_column | 행/컬럼 값 대입 |  |  |  |
| AC-88dd23bd | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1336 |  | DATA_OP | DownPopup.Filter["p_month_column_info"] | _s_month_column_info | 행/컬럼 값 대입 |  |  |  |
| AC-f843c8ea | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1337 |  | DATA_OP | DownPopup.Filter["p_plan_week_Info"] | _s_plan_week_Info | 행/컬럼 값 대입 |  |  |  |
| AC-5a3f7ca1 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1340 |  | UI_PROP | DownPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-de5b5f8d | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1341 |  | UI_PROP | DownPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-bb25d300 | this.btnMemoDown.Click | FP00521_Demand_WaterFall.cs:1342 |  | POPUP | DownPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00521_Demand_WaterFall.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-846d24fe | this.btnSql.Click | FP00521_Demand_WaterFall.cs:1352 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-30343af5 | this.btnSql.Click | FP00521_Demand_WaterFall.cs:1353 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7fdc7fb1 | this.btnSql.Click | FP00521_Demand_WaterFall.cs:1355 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MAIN_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1119ec11 | this.btnSql.Click | FP00521_Demand_WaterFall.cs:1356 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMO_POPUP_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6685f757 | this.btnSql.Click | FP00521_Demand_WaterFall.cs:1357 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMOINFO_POPUP_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-444a6291 | this.btnSql.Click | FP00521_Demand_WaterFall.cs:1358 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00521_Demand_WaterFall.CreateDataTable

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7889a0b7 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:989 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-558a9fc0 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:990 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6511f41b | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:991 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f291b78 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:992 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_VALUE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4adaac6 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:993 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6aee4ea8 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:994 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-83e42438 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:995 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MENU_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e650a50 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:996 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9569f6d6 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:998 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.CreateFilterDataSet

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90ed040a | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:628 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-55099781 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:636 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-f056c9b5 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:637 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-bffd9fea | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:647 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "R_P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d6e425a | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:652 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PP_FP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-346e3ca4 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:656 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-853e20a3 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:659 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ddb0c10e | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:663 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5ca6143 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:668 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-967104f7 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:672 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-1545cbc3 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:674 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c351228a | this.Load | FP00521_Demand_WaterFall.cs:292 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-158b2867 | this.Load | FP00521_Demand_WaterFall.cs:293 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9a19fa4 | this.Load | FP00521_Demand_WaterFall.cs:295 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00521_Demand_WaterFall.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5003bb8a | DeleteButton | FP00521_Demand_WaterFall.cs:389 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4ff6bb96 | DeleteButton | FP00521_Demand_WaterFall.cs:390 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c5a0360 | Dispose | FP00521_Demand_WaterFall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00521_Demand_WaterFall.drpPeriod_Click

진입점: drpPeriod.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a45e4e18 | drpPeriod.Click | FP00521_Demand_WaterFall.cs:1393 | if (Convert.ToDecimal(drpPeriod.Text1) > Convert.ToDecimal(drpPeriod.Text2)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Start Date can't more than End Data." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6b775d7 | drpPeriod.Click | FP00521_Demand_WaterFall.cs:1397 | if (Convert.ToDecimal(drpPeriod.Text1) > Convert.ToDecimal(drpPeriod.Text2)) | UI_PROP | drpPeriod.Text1 | sStartDate | 속성 Text1 설정 |  |  |  |
| AC-ca5f9610 | drpPeriod.Click | FP00521_Demand_WaterFall.cs:1398 | if (Convert.ToDecimal(drpPeriod.Text1) > Convert.ToDecimal(drpPeriod.Text2)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.dtpPlanDate_CloseUp

진입점: this.dtpPlanDate.CloseUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd18ca7b | this.dtpPlanDate.CloseUp | FP00521_Demand_WaterFall.cs:1376 | if (Convert.ToDecimal(sDate) > Convert.ToDecimal(sToDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Select Date can't more than Today." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2adb435 | this.dtpPlanDate.CloseUp | FP00521_Demand_WaterFall.cs:1379 | if (Convert.ToDecimal(sDate) > Convert.ToDecimal(sToDate)) | VALUE_SET | dtpPlanDate.Value | dDate | 컨트롤 값 설정 |  |  |  |
| AC-84dd9fb7 | this.dtpPlanDate.CloseUp | FP00521_Demand_WaterFall.cs:1380 | if (Convert.ToDecimal(sDate) > Convert.ToDecimal(sToDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96cb6949 | EditButton | FP00521_Demand_WaterFall.cs:381 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce67ba38 | EditButton | FP00521_Demand_WaterFall.cs:382 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94fe4856 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00521_Demand_WaterFall.cs:436 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00521_Demand_WaterFall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c482ba1 | ExcelButton | FP00521_Demand_WaterFall.cs:404 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-7e484f24 | ExcelButton | FP00521_Demand_WaterFall.cs:405 |  | VALUE_SET | select_popup.Text | "SELECT EXCEL TYPE" | 컨트롤 값 설정 |  |  |  |
| AC-5a8ada05 | ExcelButton | FP00521_Demand_WaterFall.cs:406 |  | CALL_EXT | select_popup.SetOption | (0, "Cascaded Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ada3f16 | ExcelButton | FP00521_Demand_WaterFall.cs:407 |  | CALL_EXT | select_popup.SetOption | (1, "Seperated Rows") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b98ffcc | ExcelButton | FP00521_Demand_WaterFall.cs:408 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-04e03c46 | ExcelButton | FP00521_Demand_WaterFall.cs:415 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | base.ExcelOption | ExcelExportOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |
| AC-a281463b | ExcelButton | FP00521_Demand_WaterFall.cs:421 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |

## FP00521_Demand_WaterFall.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18b90409 | FindButton | FP00521_Demand_WaterFall.cs:442 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0456e880 | FindButton | FP00521_Demand_WaterFall.cs:447 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ecf9fe1 | FindButton | FP00521_Demand_WaterFall.cs:448 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a68c4d6 | FindButton | FP00521_Demand_WaterFall.cs:451 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0cf7993c | FindButton | FP00521_Demand_WaterFall.cs:455 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca3daef9 | FindButton | FP00521_Demand_WaterFall.cs:458 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-dfdcd0f5 | FindButton | FP00521_Demand_WaterFall.cs:458 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbb9e92b | FindButton | FP00521_Demand_WaterFall.cs:465 | try ▸ if (string.IsNullOrEmpty(pPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "SCP Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ddc7e77 | FindButton | FP00521_Demand_WaterFall.cs:466 | try ▸ if (string.IsNullOrEmpty(pPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d2054ef | FindButton | FP00521_Demand_WaterFall.cs:469 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c827acf8 | FindButton | FP00521_Demand_WaterFall.cs:470 | try | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dc867340 | FindButton | FP00521_Demand_WaterFall.cs:473 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8daafb3e | FindButton | FP00521_Demand_WaterFall.cs:479 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_WaterFall("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-d892a58e | FindButton | FP00521_Demand_WaterFall.cs:479 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_WaterFall("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-664c5c26 | FindButton | FP00521_Demand_WaterFall.cs:487 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b8a6e12 | FindButton | FP00521_Demand_WaterFall.cs:496 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f639468 | FindButton | FP00521_Demand_WaterFall.cs:499 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dsMemoList | Find_Data_Memo("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-dc66b26c | FindButton | FP00521_Demand_WaterFall.cs:512 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_STYLE | siMain.SetBGColor | (0, 0, siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.PLAN_WEEK_NAME), System.D… | 그리드 표시 설정 |  |  |  |
| AC-5ad373b9 | FindButton | FP00521_Demand_WaterFall.cs:514 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | "SCP Plan ID: " + CString.GetCheckedListValue(dtPlanID, cboPlanID.ControlValues) | 컨트롤 값 설정 |  |  |  |
| AC-4b12230b | FindButton | FP00521_Demand_WaterFall.cs:519 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c1a909f9 | FindButton | FP00521_Demand_WaterFall.cs:521 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b7a2f22f | FindButton | FP00521_Demand_WaterFall.cs:523 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-360df8c1 | FindButton | FP00521_Demand_WaterFall.cs:525 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | "SCP Plan ID: " | 컨트롤 값 설정 |  |  |  |
| AC-fe0ba8f8 | FindButton | FP00521_Demand_WaterFall.cs:532 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5e9bc5db | FindButton | FP00521_Demand_WaterFall.cs:536 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00521_Demand_WaterFall.Find_Data_Memo

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMO_POPUP_SELECT")] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee892590 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1022 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_instance_id = CString.GetCheckedListValue(dtInstance, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f137cb2 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1052 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-0adbce91 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1054 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-9399c0d5 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1055 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MEMO_DATA" | 행/컬럼 값 대입 |  |  |  |
| AC-f09fe0af | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1056 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3dc18f36 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1057 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-051109fc | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1059 | try | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4e04498 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1060 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a4197f5d | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1061 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-f34859a8 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1062 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ded6667 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1063 | try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-38c1b6bf | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1064 | try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-87204263 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1065 | try | DATA_OP | request.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-8fe53f60 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1066 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-2ccebbd1 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1067 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-47aa43ec | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1068 | try | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-a5c6355b | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1069 | try | DATA_OP | request.Parameters["p_chk_total_include"] | p_chk_total_include | 행/컬럼 값 대입 |  |  |  |
| AC-8df43ec6 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1070 | try | DATA_OP | request.Parameters["p_pp_option"] | p_pp_option | 행/컬럼 값 대입 |  |  |  |
| AC-32f15c2c | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1071 | try | DATA_OP | request.Parameters["p_curr_week"] | _s_curr_week | 행/컬럼 값 대입 |  |  |  |
| AC-985097dd | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1072 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | p_bucket_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-dbca19b5 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1073 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | p_bucket_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-72a560dc | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1074 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | _s_bucket_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-e957f922 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1075 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | _s_bucket_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-278a491f | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1076 | try | DATA_OP | request.Parameters["p_plan_from_week"] | _s_plan_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-1f7332e2 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1077 | try | DATA_OP | request.Parameters["p_plan_to_week"] | _s_plan_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-3a850379 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1078 | try | DATA_OP | request.Parameters["p_week_info"] | _s_week_info | 행/컬럼 값 대입 |  |  |  |
| AC-8e94ffa8 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1079 | try | DATA_OP | request.Parameters["p_month_week_column"] | _s_month_week_column | 행/컬럼 값 대입 |  |  |  |
| AC-99f84939 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1080 | try | DATA_OP | request.Parameters["p_month_column_info"] | _s_month_column_info | 행/컬럼 값 대입 |  |  |  |
| AC-74eac247 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1081 | try | DATA_OP | request.Parameters["p_plan_week_Info"] | _s_plan_week_Info | 행/컬럼 값 대입 |  |  |  |
| AC-91d0cb13 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1083 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e0ade58 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1085 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4bddfcbe | popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELE… 외 1 | FP00521_Demand_WaterFall.cs:1090 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.Find_Data_Memo_Info

진입점: this.spdMain.CellDoubleClick / popSql.OnSql [else of (programID == "PR_UI_FP00521_MAIN_SELECT") ▸ else of (programID == "PR_UI_FP00521_MEMO_POPUP_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SELECT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0c78205 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1101 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-c9ea60de | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1103 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-f93dc589 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1104 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MEMOINFO" | 행/컬럼 값 대입 |  |  |  |
| AC-76680d8c | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1105 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3a852131 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1106 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-85f29faa | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1108 | try | DATA_OP | request.Parameters["p_company_id"] | Filter["p_company_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-63f26d4b | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1109 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-8cd9b54d | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1110 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-900ce28c | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1111 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e5541b1 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1112 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-056f1655 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1113 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-feeb50d9 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1114 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-c12dd422 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1115 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-36488275 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1116 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-b1a99b63 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1117 | try | DATA_OP | request.Parameters["p_category_id"] | Filter["p_category_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-121099d4 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1118 | try | DATA_OP | request.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-ecd2a4ea | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1119 | try | DATA_OP | request.Parameters["p_market"] | Filter["p_market"] | 행/컬럼 값 대입 |  |  |  |
| AC-d46ea42f | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1120 | try | DATA_OP | request.Parameters["p_plan_week"] | Filter["p_plan_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa59245c | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1121 | try | DATA_OP | request.Parameters["p_mfg_week"] | Filter["p_mfg_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-d5a744b9 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1122 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf85c268 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1124 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8ef749b | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1126 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c6b41df8 | this.spdMain.CellDoubleClick 외 1 | FP00521_Demand_WaterFall.cs:1131 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.Find_Data_WaterFall

진입점: popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffe50ebd | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:697 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_instance_id = CString.GetCheckedListValue(dtInstance, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5872f8ea | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:727 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-ef625d31 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:728 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-29de9d59 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:729 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-1c8aae4b | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:730 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-99877e30 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:731 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5346de60 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:733 | try | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-29112a92 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:734 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a605f393 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:735 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5f39397 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:736 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-5ecfc06d | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:737 | try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-480437c8 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:738 | try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-1d41fe2f | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:739 | try | DATA_OP | request.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-890bbb09 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:740 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-770ff8eb | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:741 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f3b99935 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:742 | try | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-455a883e | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:743 | try | DATA_OP | request.Parameters["p_chk_total_include"] | p_chk_total_include | 행/컬럼 값 대입 |  |  |  |
| AC-40c9e969 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:744 | try | DATA_OP | request.Parameters["p_pp_option"] | p_pp_option | 행/컬럼 값 대입 |  |  |  |
| AC-eafe188e | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:745 | try | DATA_OP | request.Parameters["p_curr_week"] | _s_curr_week | 행/컬럼 값 대입 |  |  |  |
| AC-8c27ecbc | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:746 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | p_bucket_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-8c809278 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:747 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | p_bucket_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-387908f1 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:748 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | _s_bucket_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-6609d73e | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:749 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | _s_bucket_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-e8bee007 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:750 | try | DATA_OP | request.Parameters["p_plan_from_week"] | _s_plan_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-a2e51efc | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:751 | try | DATA_OP | request.Parameters["p_plan_to_week"] | _s_plan_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-52a40010 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:752 | try | DATA_OP | request.Parameters["p_week_info"] | _s_week_info | 행/컬럼 값 대입 |  |  |  |
| AC-98bf2f24 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:753 | try | DATA_OP | request.Parameters["p_month_week_column"] | _s_month_week_column | 행/컬럼 값 대입 |  |  |  |
| AC-aa1ad715 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:754 | try | DATA_OP | request.Parameters["p_month_column_info"] | _s_month_column_info | 행/컬럼 값 대입 |  |  |  |
| AC-05b30a04 | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:755 | try | DATA_OP | request.Parameters["p_plan_week_Info"] | _s_plan_week_Info | 행/컬럼 값 대입 |  |  |  |
| AC-87a0aeaf | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:757 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b02298f | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:759 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e98af94e | popSql.OnSql [if (programID == "PR_UI_FP00521_MAIN_SELECT")] 외 1 | FP00521_Demand_WaterFall.cs:764 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dd11833 | FindButton | FP00521_Demand_WaterFall.cs:363 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00521_Demand_WaterFall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93193eea | this.Load | FP00521_Demand_WaterFall.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00521_Demand_WaterFall.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9a11e17 | (진입점 미연결) | FP00521_Demand_WaterFall.cs:1760 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.GetMakeMeasure

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba83c165 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:952 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0a759d7b | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:954 |  | DATA_OP | newrow["MEA_ID"] | "chk_week" | 행/컬럼 값 대입 |  |  |  |
| AC-5565edbf | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:955 |  | DATA_OP | newrow["MEA_NAME"] | "Week" | 행/컬럼 값 대입 |  |  |  |
| AC-216fbc1b | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:956 |  | DATA_OP | newrow["MEA_VALUE"] | "true" | 행/컬럼 값 대입 |  |  |  |
| AC-4f9052fa | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:957 |  | DATA_OP | newrow["TYPE"] | "BUCKET" | 행/컬럼 값 대입 |  |  |  |
| AC-222cba41 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:958 |  | DATA_OP | newrow["FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-33d8d4e8 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:959 |  | DATA_OP | newrow["MENU_ID"] | "FP00521" | 행/컬럼 값 대입 |  |  |  |
| AC-d3a88dfe | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:960 |  | DATA_OP | newrow["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-4d32fca0 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:963 |  | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9e27c97 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:964 |  | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1900d30f | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:965 |  | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0c9f380 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:978 | foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | ret.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fed4711 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:981 |  | FLAG | measure | new MeasurePack(ret) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb61ed1a | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:982 |  | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |

## FP00521_Demand_WaterFall.GetToDay

진입점: this.dtpPlanDate.CloseUp / this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fbdfe92 | this.dtpPlanDate.CloseUp 외 1 | FP00521_Demand_WaterFall.cs:1768 |  | RETURN | return sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-866efea9 | this.Load | FP00521_Demand_WaterFall.cs:170 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-77b2efdd | this.Load | FP00521_Demand_WaterFall.cs:173 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b702e1c | this.Load | FP00521_Demand_WaterFall.cs:176 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-21ca926a | this.Load | FP00521_Demand_WaterFall.cs:177 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a10744cd | this.Load | FP00521_Demand_WaterFall.cs:181 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-c655274b | this.Load | FP00521_Demand_WaterFall.cs:183 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-acd1cb99 | this.Load | FP00521_Demand_WaterFall.cs:190 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a95b861 | this.Load | FP00521_Demand_WaterFall.cs:193 | try | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-68c5d13e | this.Load | FP00521_Demand_WaterFall.cs:212 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-041842f6 | this.Load | FP00521_Demand_WaterFall.cs:213 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-97598052 | this.Load | FP00521_Demand_WaterFall.cs:214 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8c85f0aa | this.Load | FP00521_Demand_WaterFall.cs:220 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_Demand_WaterFall.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7d07cf4 | this.Load | FP00521_Demand_WaterFall.cs:266 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-24457cc1 | this.Load | FP00521_Demand_WaterFall.cs:267 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c2f9ee8f | this.Load | FP00521_Demand_WaterFall.cs:268 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-39350a76 | this.Load | FP00521_Demand_WaterFall.cs:269 |  | UI_PROP | clbProdType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00521_Demand_WaterFall.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bae099a | this.Load | FP00521_Demand_WaterFall.cs:307 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7f9085b | this.Load | FP00521_Demand_WaterFall.cs:308 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-216b19e2 | this.Load | FP00521_Demand_WaterFall.cs:312 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_Demand_WaterFall.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbb99518 | InsertButton | FP00521_Demand_WaterFall.cs:373 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df77fdc9 | InsertButton | FP00521_Demand_WaterFall.cs:374 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.rdoGroup1_SelectedIndexChanged

진입점: this.rdoGroup1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-243f4741 | this.rdoGroup1.SelectedIndexChanged | FP00521_Demand_WaterFall.cs:1409 | if (radioGroup.SelectedIndex == 0) | FLAG | _sWDFlag | "WPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-c8117319 | this.rdoGroup1.SelectedIndexChanged | FP00521_Demand_WaterFall.cs:1413 | else of (radioGroup.SelectedIndex == 0) | FLAG | _sWDFlag | "DPP" | 화면 필드/플래그 변경 |  |  |  |

## FP00521_Demand_WaterFall.RefreshHeader

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3febae4 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:887 | if (weekInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a6207be | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:888 | if (weekInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2dc4476e | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:896 | if (weekInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, DateColumnType.TYPEZERO, DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ae1fa77 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:900 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-5b8e8143 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:902 | if (weekInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.GetColumnIndex(DefColumns.PLAN_WEEK_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0dd62fac | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:904 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3a473265 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:906 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a0ed8d3 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:907 | if (weekInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4a06621 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:910 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-956c0856 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:911 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10fbf1a3 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:914 | if (weekInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-bf83f870 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:916 | if (weekInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f1d0646 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:918 | if (weekInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8aee2e53 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:920 | if (weekInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5a258d8 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FP00521_Demand_WaterFall.cs:936 | if (weekInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_it… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |

## FP00521_Demand_WaterFall.RefreshSpreadSheet

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87caa470 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] | FP00521_Demand_WaterFall.cs:855 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-831542c8 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] | FP00521_Demand_WaterFall.cs:862 | try ▸ if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-20525791 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] | FP00521_Demand_WaterFall.cs:869 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_Demand_WaterFall.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd6dc006 | popSql.OnSql | FP00521_Demand_WaterFall.cs:1776 | if (programID == "PR_UI_FP00521_MAIN_SELECT") | RETURN | return Find_Data_WaterFall("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-77d5dada | popSql.OnSql | FP00521_Demand_WaterFall.cs:1780 | else of (programID == "PR_UI_FP00521_MAIN_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMO_POPUP_SELECT") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-659449e2 | popSql.OnSql | FP00521_Demand_WaterFall.cs:1784 | else of (programID == "PR_UI_FP00521_MAIN_SELECT") ▸ else of (programID == "PR_UI_FP00521_MEMO_POPUP_SELECT") ▸ if (programID == "PR_UI_FP00… | RETURN | return Find_Data_Memo_Info("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-59d258fd | popSql.OnSql | FP00521_Demand_WaterFall.cs:1786 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-877ffa46 | SaveButton | FP00521_Demand_WaterFall.cs:397 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a052f62e | SaveButton | FP00521_Demand_WaterFall.cs:398 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.SetChangedControl

진입점: this.Load [try] / cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-282778e4 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:258 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_Demand_WaterFall.SetFactory

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try] / cboPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c8c6a42 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1603 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8aacad3 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1608 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f73025b | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1611 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInsta… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-19f76bf4 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1611 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstance, "", "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ebb73e0 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1613 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00521_Demand_WaterFall.SetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04e21091 | (진입점 미연결) | FP00521_Demand_WaterFall.cs:1755 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00521_Demand_WaterFall.SetHiddenColmn

진입점: this.Load [try] / FindButton [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d19622c2 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:345 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d5702371 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:346 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-48c2e371 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:347 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dfecce85 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:348 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9edb0b48 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:349 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b302b1ae | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:350 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_WEEK_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f321c15c | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:351 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DATA_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-17f9b055 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:352 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_DETAIL_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00521_Demand_WaterFall.SetLine

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try] / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da99787d | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1663 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f04fe65 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1667 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b3112fb | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1671 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ed162f0 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1676 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec43e10 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1679 |  | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-4c144c4b | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1679 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", "", "", "" , "", "", p… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75b75611 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1681 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00521_Demand_WaterFall.SetOperation

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try] / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-580bfb4b | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1630 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb8c6f78 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1634 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d3638c | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1638 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e83055e | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1642 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-425d4516 | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1642 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", "", "", "" , "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-84a9230a | this.Load [try ▸ try] 외 2 | FP00521_Demand_WaterFall.cs:1644 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00521_Demand_WaterFall.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37e31555 | this.Load [try] | FP00521_Demand_WaterFall.cs:1747 |  | VALUE_SET | dtpPlanDate.Value | dDate | 컨트롤 값 설정 |  |  |  |

## FP00521_Demand_WaterFall.SetPlanGroup

진입점: this.Load [try] / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97f26820 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1552 |  | FLAG | dtInstance | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00521_findInstanceList_common", sDataI… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-3cc729e4 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1552 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00521_findInstanceList_common", sDataID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87559559 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1553 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00521_Demand_WaterFall.SetPlanID

진입점: this.dtpPlanDate.CloseUp / this.Load [try] / cboPlanGroup.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f85d334d | this.dtpPlanDate.CloseUp 외 2 | FP00521_Demand_WaterFall.cs:1566 |  | FLAG | dtPlanID | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00521_find_SCP_Plan_List", pInstance, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ca760ef7 | this.dtpPlanDate.CloseUp 외 2 | FP00521_Demand_WaterFall.cs:1566 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00521_find_SCP_Plan_List", pInstance, pPlanDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16a98879 | this.dtpPlanDate.CloseUp 외 2 | FP00521_Demand_WaterFall.cs:1567 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanID, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00521_Demand_WaterFall.SetPlant

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-811d0cbe | this.Load [try ▸ try] 외 1 | FP00521_Demand_WaterFall.cs:1584 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-33f9966f | this.Load [try ▸ try] 외 1 | FP00521_Demand_WaterFall.cs:1586 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstanc… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-d483657c | this.Load [try ▸ try] 외 1 | FP00521_Demand_WaterFall.cs:1586 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstance, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40a6e735 | this.Load [try ▸ try] 외 1 | FP00521_Demand_WaterFall.cs:1587 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00521_Demand_WaterFall.SetProdType

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90ee0ca3 | this.Load [try ▸ try] 외 1 | FP00521_Demand_WaterFall.cs:1692 |  | FLAG | dtProdType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00521_find_FPProdType", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-804964a6 | this.Load [try ▸ try] 외 1 | FP00521_Demand_WaterFall.cs:1692 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00521_find_FPProdType", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae3d51b2 | this.Load [try ▸ try] 외 1 | FP00521_Demand_WaterFall.cs:1693 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00521_Demand_WaterFall.SetSheetFontBoldByMemo

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (dsMemoList != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50c2bef7 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:548 | try ▸ if (calendar == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6f4cbbd | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:564 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4db331d7 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:565 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9cd2ef68 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:566 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a48fe632 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:567 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c32351e4 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:568 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6513d5cb | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:569 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d0feb15 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:570 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cccb826e | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:571 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3a02fc6 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:572 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-254ebe0b | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:573 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7befc79b | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:574 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e990f1f | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:579 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ if (result.Any()) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-350b6408 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:602 | try ▸ foreach (DataRow row in dsSheet.Tables[0].Rows) ▸ if (dtMemo.Rows.Count > 0) ▸ foreach (AmendWeek a in calendar.Weeks.Values) ▸ if (a.… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].Font | new Font(FontFamily.GenericSansSerif, 11.0F, FontStyle.Bold) | 그리드 속성/값 설정 |  |  |  |
| AC-86102a08 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FP00521_Demand_WaterFall.cs:621 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_Demand_WaterFall.SetSite

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-496d8f2f | this.Load [try] | FP00521_Demand_WaterFall.cs:1538 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b781f6cc | this.Load [try] | FP00521_Demand_WaterFall.cs:1538 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2702842 | this.Load [try] | FP00521_Demand_WaterFall.cs:1539 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6b51ca64 | this.Load [try] | FP00521_Demand_WaterFall.cs:1542 | if (dtSite.Rows.Count == 1) | VALUE_SET | cboSite.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00521_Demand_WaterFall.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a04f24f1 | this.Load [try] | FP00521_Demand_WaterFall.cs:321 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e07f32ed | this.Load [try] | FP00521_Demand_WaterFall.cs:322 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-85d075c9 | this.Load [try] | FP00521_Demand_WaterFall.cs:327 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-4258af7e | this.Load [try] | FP00521_Demand_WaterFall.cs:328 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLAN_WEEK)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6f68105e | this.Load [try] | FP00521_Demand_WaterFall.cs:339 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.DATA_TYPE)… | 그리드 편집 잠금/해제 |  |  |  |

## FP00521_Demand_WaterFall.SetStartEndDate

진입점: this.Load [try] / cboPlanID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c247baf | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1705 |  | FLAG | dtStartEndDate | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00521_find_SCP_Plan_List", sInstance, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-2e34831e | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1705 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00521_find_SCP_Plan_List", sInstance, sPlanDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a9989f7 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1718 | if (dtPlanID != null) ▸ if (dtStartEndDate.Rows.Count > 0) | DATA_OP | dtPlanID.Select | (string.Format("CODE = '{0}'", sPlanID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-761533b3 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1719 | if (dtPlanID != null) ▸ if (dtStartEndDate.Rows.Count > 0) | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d46559ee | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1726 | if (dtPlanID != null) ▸ if (dtStartEndDate.Rows.Count > 0) ▸ if (dtResult.Rows.Count > 0) | VALUE_SET | drpPeriod.InitValue | sStartDate.ToString() + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-76b03ada | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1731 | if (dtPlanID != null) ▸ else of (dtStartEndDate.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-a73e49bb | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1732 | if (dtPlanID != null) ▸ else of (dtStartEndDate.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-b6998b0f | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1737 | else of (dtPlanID != null) | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-4dc9d266 | this.Load [try] 외 1 | FP00521_Demand_WaterFall.cs:1738 | else of (dtPlanID != null) | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |

## FP00521_Demand_WaterFall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-248dbd29 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1457 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1898346c | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1479 | if (string.IsNullOrEmpty(sHeadKey)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fb485e4 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1481 |  | POPUP | new FP00521_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3b17c27b | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1483 |  | DATA_OP | Filter["p_company_id"] | MemoPopup.Filter["p_company_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns… | 행/컬럼 값 대입 |  |  |  |
| AC-81856cf2 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1483 |  | DATA_OP | MemoPopup.Filter["p_company_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5984146a | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1484 |  | DATA_OP | Filter["p_division_id"] | MemoPopup.Filter["p_division_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumn… | 행/컬럼 값 대입 |  |  |  |
| AC-add04ef3 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1484 |  | DATA_OP | MemoPopup.Filter["p_division_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e38087d7 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1485 |  | DATA_OP | Filter["p_site_id"] | MemoPopup.Filter["p_site_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SI… | 행/컬럼 값 대입 |  |  |  |
| AC-6bed8fa4 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1485 |  | DATA_OP | MemoPopup.Filter["p_site_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c8c2f5a1 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1486 |  | DATA_OP | Filter["p_plant_id"] | MemoPopup.Filter["p_plant_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.P… | 행/컬럼 값 대입 |  |  |  |
| AC-105fbb37 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1486 |  | DATA_OP | MemoPopup.Filter["p_plant_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d6f5522 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1487 |  | DATA_OP | Filter["p_factory_id"] | MemoPopup.Filter["p_factory_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns… | 행/컬럼 값 대입 |  |  |  |
| AC-d8552f73 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1487 |  | DATA_OP | MemoPopup.Filter["p_factory_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-139f7eda | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1488 |  | DATA_OP | Filter["p_operation_id"] | MemoPopup.Filter["p_operation_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColum… | 행/컬럼 값 대입 |  |  |  |
| AC-2f5e38d7 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1488 |  | DATA_OP | MemoPopup.Filter["p_operation_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e4e54a58 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1489 |  | DATA_OP | Filter["p_line_id"] | MemoPopup.Filter["p_line_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LI… | 행/컬럼 값 대입 |  |  |  |
| AC-a3ce8d87 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1489 |  | DATA_OP | MemoPopup.Filter["p_line_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c92036ab | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1490 |  | DATA_OP | Filter["p_prod_type"] | MemoPopup.Filter["p_prod_type"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.… | 행/컬럼 값 대입 |  |  |  |
| AC-305faabd | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1490 |  | DATA_OP | MemoPopup.Filter["p_prod_type"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56bb7d54 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1491 |  | DATA_OP | Filter["p_category_id"] | MemoPopup.Filter["p_category_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumn… | 행/컬럼 값 대입 |  |  |  |
| AC-97cf297c | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1491 |  | DATA_OP | MemoPopup.Filter["p_category_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17faa960 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1492 |  | DATA_OP | Filter["p_market"] | MemoPopup.Filter["p_market"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MAR… | 행/컬럼 값 대입 |  |  |  |
| AC-5a649b27 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1492 |  | DATA_OP | MemoPopup.Filter["p_market"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MARKET)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d9d900c | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1493 |  | DATA_OP | Filter["p_model_id"] | MemoPopup.Filter["p_model_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.M… | 행/컬럼 값 대입 |  |  |  |
| AC-ea022f15 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1493 |  | DATA_OP | MemoPopup.Filter["p_model_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MODEL)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cdc734a8 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1494 |  | DATA_OP | Filter["p_item_id"] | MemoPopup.Filter["p_item_id"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.IT… | 행/컬럼 값 대입 |  |  |  |
| AC-dd9b88a7 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1494 |  | DATA_OP | MemoPopup.Filter["p_item_id"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e384b8ac | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1495 |  | DATA_OP | Filter["p_plan_week"] | MemoPopup.Filter["p_plan_week"] = siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.… | 행/컬럼 값 대입 |  |  |  |
| AC-b970e2c0 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1495 |  | DATA_OP | MemoPopup.Filter["p_plan_week"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_WEEK)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3da50905 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1496 |  | DATA_OP | Filter["p_mfg_week"] | MemoPopup.Filter["p_mfg_week"] = sHeadKey | 행/컬럼 값 대입 |  |  |  |
| AC-9e9a4bb6 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1496 |  | DATA_OP | MemoPopup.Filter["p_mfg_week"] | sHeadKey | 행/컬럼 값 대입 |  |  |  |
| AC-163addf8 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1505 | if (dsMemo != null) ▸ if (dsMemo.Tables[0].Rows.Count > 0) | DATA_OP | MemoPopup.Filter["p_description"] | dsMemo.Tables[0].Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-56aa7466 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1506 | if (dsMemo != null) ▸ if (dsMemo.Tables[0].Rows.Count > 0) | DATA_OP | MemoPopup.Filter["p_creator"] | dsMemo.Tables[0].Rows[0]["UPDATE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3e2b91e | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1507 | if (dsMemo != null) ▸ if (dsMemo.Tables[0].Rows.Count > 0) | DATA_OP | MemoPopup.Filter["p_creation_date"] | dsMemo.Tables[0].Rows[0]["UPDATE_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1a210058 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1511 | if (dsMemo != null) ▸ else of (dsMemo.Tables[0].Rows.Count > 0) | DATA_OP | MemoPopup.Filter["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c97703dc | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1512 | if (dsMemo != null) ▸ else of (dsMemo.Tables[0].Rows.Count > 0) | DATA_OP | MemoPopup.Filter["p_creator"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-df7a926a | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1513 | if (dsMemo != null) ▸ else of (dsMemo.Tables[0].Rows.Count > 0) | DATA_OP | MemoPopup.Filter["p_creation_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa32d720 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1518 | else of (dsMemo != null) | DATA_OP | MemoPopup.Filter["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8b55621e | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1519 | else of (dsMemo != null) | DATA_OP | MemoPopup.Filter["p_creator"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97ed5120 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1520 | else of (dsMemo != null) | DATA_OP | MemoPopup.Filter["p_creation_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa71cd03 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1523 |  | UI_PROP | MemoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-1db36e8c | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1524 |  | UI_PROP | MemoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-52cf1e60 | this.spdMain.CellDoubleClick | FP00521_Demand_WaterFall.cs:1525 |  | POPUP | MemoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00521_MemoDownPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33968502 | .ctor | FP00521_MemoDownPopup.cs:117 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |

## FP00521_MemoDownPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-303cd461 | this.btnClose.Click | FP00521_MemoDownPopup.cs:328 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoDownPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f76d5a82 | this.btnExport.Click | FP00521_MemoDownPopup.cs:322 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |

## FP00521_MemoDownPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e9cc25b | this.btnSql.Click | FP00521_MemoDownPopup.cs:334 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c0ee5df6 | this.btnSql.Click | FP00521_MemoDownPopup.cs:335 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cd5d65c0 | this.btnSql.Click | FP00521_MemoDownPopup.cs:337 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMODOWN_POPUP_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b6d2344 | this.btnSql.Click | FP00521_MemoDownPopup.cs:338 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMODATA_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-7549ce04 | this.btnSql.Click | FP00521_MemoDownPopup.cs:339 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00521_MemoDownPopup.CreateDataTable

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b714c174 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:745 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-5c0c4bf7 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:746 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-568d2fe7 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:747 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb186f10 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:748 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_VALUE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fafd4d5 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:749 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c5a2721 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:750 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-095cb0b8 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:751 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MENU_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6aa33e3a | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:752 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6144753 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:754 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.CreateFilterDataSet

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b6d911b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:447 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4df42779 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:455 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ba9b3fb0 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:456 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-85151508 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:466 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "R_P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cbbf491 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:471 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PP_FP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce700816 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:477 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c8035c9 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:480 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54eb0d45 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:484 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-86fcb3b2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:489 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-70a9f84f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:493 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcf85aaa | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FP00521_MemoDownPopup.cs:495 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baa5ff1c | this.Load | FP00521_MemoDownPopup.cs:204 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-706662f3 | this.Load | FP00521_MemoDownPopup.cs:205 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7bb1cd8 | this.Load | FP00521_MemoDownPopup.cs:207 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00521_MemoDownPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4232f1bb | this.Load | FP00521_MemoDownPopup.cs:189 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00521_MemoDownPopup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-101f036a | DeleteButton | FP00521_MemoDownPopup.cs:302 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b34be0e | DeleteButton | FP00521_MemoDownPopup.cs:303 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d222e622 | Dispose | FP00521_MemoDownPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoDownPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc3d1594 | EditButton | FP00521_MemoDownPopup.cs:294 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ddc1be7 | EditButton | FP00521_MemoDownPopup.cs:295 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.Excel_Export

진입점: this.btnExport.Click / ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-329e36a4 | this.btnExport.Click 외 1 | FP00521_MemoDownPopup.cs:349 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00521_MemoDownPopup.Find_Data

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11554f8f | this.Load 외 1 | FP00521_MemoDownPopup.cs:355 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5dfed9c4 | this.Load 외 1 | FP00521_MemoDownPopup.cs:360 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c0dd9a3d | this.Load 외 1 | FP00521_MemoDownPopup.cs:363 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8180a38 | this.Load 외 1 | FP00521_MemoDownPopup.cs:369 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dcaf2545 | this.Load 외 1 | FP00521_MemoDownPopup.cs:370 | try | FLAG | dsMain | Find_Data_MemoDown("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-f8923fcb | this.Load 외 1 | FP00521_MemoDownPopup.cs:375 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a4a1c01 | this.Load 외 1 | FP00521_MemoDownPopup.cs:378 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dsMemo | Find_Data_MemoData() | 화면 필드/플래그 변경 |  |  |  |
| AC-900595ab | this.Load 외 1 | FP00521_MemoDownPopup.cs:388 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-82babad9 | this.Load 외 1 | FP00521_MemoDownPopup.cs:397 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6a2dd6a | this.Load 외 1 | FP00521_MemoDownPopup.cs:402 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8fd790d7 | this.Load 외 1 | FP00521_MemoDownPopup.cs:404 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b386fe6c | this.Load 외 1 | FP00521_MemoDownPopup.cs:406 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-2213bcb8 | this.Load 외 1 | FP00521_MemoDownPopup.cs:415 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1ffef4b0 | this.Load 외 1 | FP00521_MemoDownPopup.cs:419 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoDownPopup.Find_Data_MemoData

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMODOWN_POPUP_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMODATA_SELECT")] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e98725d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:551 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-3ee644a1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:552 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-fa0adffc | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:553 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MEMO_DATA" | 행/컬럼 값 대입 |  |  |  |
| AC-9aa097a0 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:554 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-cbd0c898 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:555 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-106d0166 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:557 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["p_instance_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-428942e1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:558 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-c47c56e8 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:559 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-fef70b79 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:560 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-39802eeb | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:561 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-576c81a2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:562 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-96f78839 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:563 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-e1763650 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:564 | try | DATA_OP | request.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-e5d39b8b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:565 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-f8baeb85 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:566 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["p_nick_name"] | 행/컬럼 값 대입 |  |  |  |
| AC-181a5177 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:567 | try | DATA_OP | request.Parameters["p_chk_total_include"] | Filter["p_chk_total_include"] | 행/컬럼 값 대입 |  |  |  |
| AC-dc5206d6 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:568 | try | DATA_OP | request.Parameters["p_pp_option"] | Filter["p_pp_option"] | 행/컬럼 값 대입 |  |  |  |
| AC-d36fec6a | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:569 | try | DATA_OP | request.Parameters["p_curr_week"] | Filter["p_curr_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a2c7cce | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:570 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | Filter["p_bucket_from_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-df675334 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:571 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | Filter["p_bucket_to_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-28686110 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:572 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | Filter["p_bucket_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-64593c37 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:573 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | Filter["p_bucket_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-7915a318 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:574 | try | DATA_OP | request.Parameters["p_plan_from_week"] | Filter["p_plan_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-b8b8cc4b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:575 | try | DATA_OP | request.Parameters["p_plan_to_week"] | Filter["p_plan_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f053887 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:576 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["p_week_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4b0d52b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:577 | try | DATA_OP | request.Parameters["p_month_week_column"] | Filter["p_month_week_column"] | 행/컬럼 값 대입 |  |  |  |
| AC-cafc84f2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:578 | try | DATA_OP | request.Parameters["p_month_column_info"] | Filter["p_month_column_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-e39d0a32 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:579 | try | DATA_OP | request.Parameters["p_plan_week_Info"] | Filter["p_plan_week_Info"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f4a5c73 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:581 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-427f838f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:583 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6a992ae0 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FP00521_MemoDownPopup.cs:588 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.Find_Data_MemoDown

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00521_MEMODOWN_POPUP_SELECT")] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14d524da | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:504 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-45b900b9 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:505 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-3799c343 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:506 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MEMO_DOWN_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-37adcdea | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:507 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-714d1996 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:508 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b7a706ab | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:510 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["p_instance_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-dec9e5db | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:511 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-27b133d8 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:512 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a6ee8b6 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:513 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-c28a1a8f | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:514 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-e68ef486 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:515 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-8f3c14e6 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:516 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-d23d7cd1 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:517 | try | DATA_OP | request.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ad31483 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:518 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-d0efb111 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:519 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["p_nick_name"] | 행/컬럼 값 대입 |  |  |  |
| AC-b65b0a10 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:520 | try | DATA_OP | request.Parameters["p_chk_total_include"] | Filter["p_chk_total_include"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce4f5264 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:521 | try | DATA_OP | request.Parameters["p_pp_option"] | Filter["p_pp_option"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c89c0c1 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:522 | try | DATA_OP | request.Parameters["p_curr_week"] | Filter["p_curr_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-a525bd8c | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:523 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | Filter["p_bucket_from_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-f07920b0 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:524 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | Filter["p_bucket_to_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f49b6e8 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:525 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | Filter["p_bucket_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-0561b43c | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:526 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | Filter["p_bucket_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-b27e2d14 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:527 | try | DATA_OP | request.Parameters["p_plan_from_week"] | Filter["p_plan_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-72e67e69 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:528 | try | DATA_OP | request.Parameters["p_plan_to_week"] | Filter["p_plan_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-869aa2f6 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:529 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["p_week_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-9b034ab3 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:530 | try | DATA_OP | request.Parameters["p_month_week_column"] | Filter["p_month_week_column"] | 행/컬럼 값 대입 |  |  |  |
| AC-d66c7ac2 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:531 | try | DATA_OP | request.Parameters["p_month_column_info"] | Filter["p_month_column_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-63140af3 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:532 | try | DATA_OP | request.Parameters["p_plan_week_Info"] | Filter["p_plan_week_Info"] | 행/컬럼 값 대입 |  |  |  |
| AC-e05f351b | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:534 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fca927d0 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:536 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4baa0003 | this.Load [try] 외 2 | FP00521_MemoDownPopup.cs:541 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30c0e99c | FindButton | FP00521_MemoDownPopup.cs:276 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00521_MemoDownPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f61513a4 | this.Load | FP00521_MemoDownPopup.cs:127 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00521_MemoDownPopup.GetMakeMeasure

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-312ac3c0 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:709 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-689390a5 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:711 |  | DATA_OP | newrow["MEA_ID"] | "chk_week" | 행/컬럼 값 대입 |  |  |  |
| AC-2792b958 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:712 |  | DATA_OP | newrow["MEA_NAME"] | "Week" | 행/컬럼 값 대입 |  |  |  |
| AC-9b005218 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:713 |  | DATA_OP | newrow["MEA_VALUE"] | "true" | 행/컬럼 값 대입 |  |  |  |
| AC-ad74247a | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:714 |  | DATA_OP | newrow["TYPE"] | "BUCKET" | 행/컬럼 값 대입 |  |  |  |
| AC-28e7c4cb | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:715 |  | DATA_OP | newrow["FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c6bbba7b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:716 |  | DATA_OP | newrow["MENU_ID"] | "FP00521" | 행/컬럼 값 대입 |  |  |  |
| AC-88186fcb | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:717 |  | DATA_OP | newrow["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-5820159b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:720 |  | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-8eb775b7 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:721 |  | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cc20bfea | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:722 |  | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-4019caec | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:734 | foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | ret.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-6aedb10e | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:737 |  | FLAG | measure | new MeasurePack(ret) | 화면 필드/플래그 변경 |  |  |  |
| AC-f598bd09 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FP00521_MemoDownPopup.cs:738 |  | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |

## FP00521_MemoDownPopup.GetToDay

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c9e9052 | (진입점 미연결) | FP00521_MemoDownPopup.cs:937 |  | RETURN | return sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7ac862a | this.Load | FP00521_MemoDownPopup.cs:154 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-18a428ab | this.Load | FP00521_MemoDownPopup.cs:157 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-44584de5 | this.Load | FP00521_MemoDownPopup.cs:161 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00521_find_WeekCnt", Filter["p_bucket_from_date"], Filter["p_bucket_to… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ccd8b68 | this.Load | FP00521_MemoDownPopup.cs:163 | try | FLAG | weekInfo | dtWeekInfo.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4cba4fc1 | this.Load | FP00521_MemoDownPopup.cs:166 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e9970760 | this.Load | FP00521_MemoDownPopup.cs:167 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-495c129d | this.Load | FP00521_MemoDownPopup.cs:173 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4bf07f8a | this.Load | FP00521_MemoDownPopup.cs:174 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fe638605 | this.Load | FP00521_MemoDownPopup.cs:175 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-713bab30 | this.Load | FP00521_MemoDownPopup.cs:182 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_MemoDownPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3aa12a5e | this.Load | FP00521_MemoDownPopup.cs:219 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d95a3086 | this.Load | FP00521_MemoDownPopup.cs:220 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-98dfb371 | this.Load | FP00521_MemoDownPopup.cs:224 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_MemoDownPopup.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-543d90b7 | InsertButton | FP00521_MemoDownPopup.cs:286 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecd5585f | InsertButton | FP00521_MemoDownPopup.cs:287 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.RefreshHeader

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce615d25 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:633 | if (weekInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-748f4451 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:634 | if (weekInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-749be04d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:642 | if (weekInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, DateColumnType.TYPEZERO, DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1af9c60 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:646 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-0a34bea4 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:651 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6c6b23e3 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:656 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-345ba4e1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:657 | if (weekInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28411413 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:660 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da933fd2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:661 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-459f1cde | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:664 | if (weekInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-18a18ea4 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:670 | if (weekInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-95b42de7 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:690 | if (weekInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_it… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |

## FP00521_MemoDownPopup.RefreshSpreadSheet

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0031c9d1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:604 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-850faac6 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:615 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_MemoDownPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f33227da | popSql.OnSql | FP00521_MemoDownPopup.cs:945 | if (programID == "PR_UI_FP00521_MEMODOWN_POPUP_SELECT") | RETURN | return Find_Data_MemoDown("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-591411c1 | popSql.OnSql | FP00521_MemoDownPopup.cs:949 | else of (programID == "PR_UI_FP00521_MEMODOWN_POPUP_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMODATA_SELECT") | RETURN | return Find_Data_MemoData("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-572e4269 | popSql.OnSql | FP00521_MemoDownPopup.cs:951 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64d3e231 | SaveButton | FP00521_MemoDownPopup.cs:310 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4979f5fb | SaveButton | FP00521_MemoDownPopup.cs:311 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoDownPopup.SetColumnChangeByMemo

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-348f922d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:879 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-31fd98f2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:881 | try | FLAG | NumcellType | new FarPoint.Win.Spread.CellType.NumberCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b9265363 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:883 | try | UI_PROP | NumcellType.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-ccefa37e | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:884 | try | UI_PROP | NumcellType.FixedPoint | false | 속성 FixedPoint 설정 |  |  |  |
| AC-902fd4a7 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:893 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, iColStartIndex, k, iColEndIndex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-be33cca7 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:897 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ else of (sDataType == "DATA" && sCategoryDetail == "MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, iColStartIndex, k, iColEndIndex].CellType | NumcellType | 그리드 속성/값 설정 |  |  |  |
| AC-aa1f51a9 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:901 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a48bfdfd | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:908 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_MemoDownPopup.SetCombineMemo

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a0bc215 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:762 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f8ec420 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:763 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-d485afab | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:774 | try ▸ foreach (AmendWeek a in calendar.Weeks.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1195ee67 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:794 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-417cef0d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:795 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bdc38083 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:796 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9aa63e76 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:797 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5d43cce | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:798 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e82c0704 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:799 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4ff9a317 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:800 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-05b7d5ea | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:801 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-59f71164 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:802 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc73091b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:803 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee97c636 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:804 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-08aca2d2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:826 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ if (result.Any()) | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0c475c27 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:848 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ if (dtMemo.Rows.Count > 0) … | DATA_OP | row[sColName] | dtMemo.Rows[i][sChgColName] | 행/컬럼 값 대입 |  |  |  |
| AC-2e549b97 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FP00521_MemoDownPopup.cs:864 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_MemoDownPopup.SetHiddenColmn

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43871a44 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:257 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-02bf02ff | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:258 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3551375a | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:259 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ef9470d9 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:260 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4badf722 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:261 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1dd22b86 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:262 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_WEEK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a795fd4 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:263 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_WEEK_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6db0c769 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:264 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DATA_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-24f7cd2f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:265 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_DETAIL_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00521_MemoDownPopup.SetSheetColor

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2011ab3 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:426 |  | GRID_STYLE | siMain.SetBGColor | (0, 0, siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.PLAN_WEEK_NAME), System.D… | 그리드 표시 설정 |  |  |  |
| AC-b74a8491 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:435 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PLAN_WEEK_ORDER)+1, i, siMain.GetMaxColumnIndex(), Sy… | 그리드 표시 설정 |  |  |  |
| AC-2e7e9f66 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FP00521_MemoDownPopup.cs:439 | if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PLAN_WEEK_ORDER)+1, i, siMain.GetMaxColumnIndex(), Sy… | 그리드 표시 설정 |  |  |  |

## FP00521_MemoDownPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed2dc144 | this.Load [try] | FP00521_MemoDownPopup.cs:233 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49f6614e | this.Load [try] | FP00521_MemoDownPopup.cs:234 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-8e64fcd1 | this.Load [try] | FP00521_MemoDownPopup.cs:239 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-b62f0f5b | this.Load [try] | FP00521_MemoDownPopup.cs:240 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7174ccc7 | this.Load [try] | FP00521_MemoDownPopup.cs:251 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.DATA_TYPE)… | 그리드 편집 잠금/해제 |  |  |  |

## FP00521_MemoListPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48ef73ee | .ctor | FP00521_MemoListPopup.cs:102 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |

## FP00521_MemoListPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9351763 | this.btnClose.Click | FP00521_MemoListPopup.cs:576 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoListPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf6ef309 | this.btnSql.Click | FP00521_MemoListPopup.cs:582 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-14d2f780 | this.btnSql.Click | FP00521_MemoListPopup.cs:583 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18d60ddd | this.btnSql.Click | FP00521_MemoListPopup.cs:585 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMOPOPUP_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ab9617a | this.btnSql.Click | FP00521_MemoListPopup.cs:586 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMOPOPUP_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcafd2b6 | this.btnSql.Click | FP00521_MemoListPopup.cs:587 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00521_MemoListPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64af9450 | this.Load | FP00521_MemoListPopup.cs:185 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a00019c9 | this.Load | FP00521_MemoListPopup.cs:186 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b740e968 | this.Load | FP00521_MemoListPopup.cs:188 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00521_MemoListPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-159309fe | this.Load | FP00521_MemoListPopup.cs:170 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00521_MemoListPopup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33e8be58 | DeleteButton | FP00521_MemoListPopup.cs:297 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4d64815 | DeleteButton | FP00521_MemoListPopup.cs:298 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoListPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e18d45a | Dispose | FP00521_MemoListPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoListPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95fbaf37 | EditButton | FP00521_MemoListPopup.cs:268 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f6966db | EditButton | FP00521_MemoListPopup.cs:270 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-49a81484 | EditButton | FP00521_MemoListPopup.cs:272 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.MFG_WEEK),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abe25132 | EditButton | FP00521_MemoListPopup.cs:273 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UPDATE_ID), siMain.GetColumnIndex(DefColumns.UPDATE_TIME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f54d07a4 | EditButton | FP00521_MemoListPopup.cs:279 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |
| AC-9db033fd | EditButton | FP00521_MemoListPopup.cs:283 | if (spdMain != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (i % 2 == 1) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DESCRIPTION), i, siMain.GetColumnIndex(DefColumns.DES… | 그리드 표시 설정 |  |  |  |

## FP00521_MemoListPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2d20375 | ExcelButton | FP00521_MemoListPopup.cs:322 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00521_MemoListPopup.Find_Data

진입점: this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / this.Load / FindButton / SaveButton [try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9752051e | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:328 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3704c843 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:333 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1c37ed64 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:336 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13fb9501 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:339 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Memo("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d95dc20 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:339 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Memo("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69acc378 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:343 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c3e67d71 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:345 | try | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-93b89489 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:353 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6a5a71a5 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:357 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoListPopup.Find_Data_Memo

진입점: this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOPOPUP_SELECT")] / FindButton [try ▸ lambda] / SaveButton [try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-447dc27c | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:367 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | 엔드포인트 요청 생성 |  |  |  |
| AC-6bded744 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:368 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-af02ee83 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:369 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MEMO_POPUP" | 행/컬럼 값 대입 |  |  |  |
| AC-a1b2f125 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:370 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e9b77723 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:371 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9044e0f1 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:373 | try | DATA_OP | request.Parameters["p_company_id"] | Filter["p_company_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac4f27ca | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:374 | try | DATA_OP | request.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-047f6548 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:375 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-81fed037 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:376 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-9b010b36 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:377 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-ee2bcddd | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:378 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-9c64cbed | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:379 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-a26ac81c | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:380 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-f680c732 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:381 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-46461c73 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:382 | try | DATA_OP | request.Parameters["p_category_id"] | Filter["p_category_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-e74b1f99 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:383 | try | DATA_OP | request.Parameters["p_market"] | Filter["p_market"] | 행/컬럼 값 대입 |  |  |  |
| AC-4eee0782 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:384 | try | DATA_OP | request.Parameters["p_plan_week"] | Filter["p_plan_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-3d6aa935 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:385 | try | DATA_OP | request.Parameters["p_mfg_week"] | Filter["p_mfg_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-824a0c54 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:386 | try | DATA_OP | request.Parameters["p_description"] | Filter["p_description"] | 행/컬럼 값 대입 |  |  |  |
| AC-776ef1c4 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:387 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | Filter["p_bucket_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-10052133 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:388 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | Filter["p_bucket_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-21f16d9d | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:389 | try | DATA_OP | request.Parameters["p_plan_from_week"] | Filter["p_plan_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-1c2355d7 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:390 | try | DATA_OP | request.Parameters["p_plan_to_week"] | Filter["p_plan_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-17d456bd | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:392 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a318e834 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:394 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-35da6d03 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 5 | FP00521_MemoListPopup.cs:399 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoListPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-834b9165 | FindButton | FP00521_MemoListPopup.cs:249 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00521_MemoListPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f30964e | this.Load | FP00521_MemoListPopup.cs:112 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00521_MemoListPopup.GetToDay

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cb3a2ce | (진입점 미연결) | FP00521_MemoListPopup.cs:609 |  | RETURN | return sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoListPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9207eef4 | this.Load | FP00521_MemoListPopup.cs:139 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4ce6073 | this.Load | FP00521_MemoListPopup.cs:145 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b14b3953 | this.Load | FP00521_MemoListPopup.cs:146 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4d29d850 | this.Load | FP00521_MemoListPopup.cs:152 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-89702fcb | this.Load | FP00521_MemoListPopup.cs:153 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c6a2e747 | this.Load | FP00521_MemoListPopup.cs:154 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2b19fc80 | this.Load | FP00521_MemoListPopup.cs:156 | try | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f14589bb | this.Load | FP00521_MemoListPopup.cs:158 | try ▸ if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e93a2a9a | this.Load | FP00521_MemoListPopup.cs:163 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_MemoListPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-876ed571 | this.Load | FP00521_MemoListPopup.cs:200 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5892382 | this.Load | FP00521_MemoListPopup.cs:201 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4b68b10 | this.Load | FP00521_MemoListPopup.cs:205 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00521_MemoListPopup.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bdabad2 | InsertButton | FP00521_MemoListPopup.cs:259 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f5787826 | InsertButton | FP00521_MemoListPopup.cs:260 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoListPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81dc71ce | popSql.OnSql | FP00521_MemoListPopup.cs:617 | if (programID == "PR_UI_FP00521_MEMOPOPUP_SELECT") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-c342c39d | popSql.OnSql | FP00521_MemoListPopup.cs:621 | else of (programID == "PR_UI_FP00521_MEMOPOPUP_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMOPOPUP_SAVE") | RETURN | return Save_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-85ee82b3 | popSql.OnSql | FP00521_MemoListPopup.cs:623 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoListPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d13abedc | this.btnSave.Click 외 1 | FP00521_MemoListPopup.cs:421 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b7ed4ae | this.btnSave.Click 외 1 | FP00521_MemoListPopup.cs:431 | try ▸ else of (dsResult == null) ▸ else of (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-317c98bb | this.btnSave.Click 외 1 | FP00521_MemoListPopup.cs:436 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP00521_MemoListPopup.Save_Data_Memo

진입점: this.btnSave.Click [try] / popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOPOPUP_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMOPOPUP_SAVE")] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f6f325c | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:509 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMO | 엔드포인트 요청 생성 |  |  |  |
| AC-c712082a | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:510 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b439d411 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:512 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-0bb1d2c2 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:513 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e8a6d2fc | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:514 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-304ea220 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:515 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-796a8b41 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:516 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-17781504 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:517 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f1731f1 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:518 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4a5e46a7 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:519 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-6132df32 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:520 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-5ac11b01 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:521 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a44a83f | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:522 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8e2b737 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:523 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-b963b87f | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:524 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c76f7cac | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:525 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-65e25a1b | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:526 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-a6c2da12 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:527 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_week"] | p_plan_week | 행/컬럼 값 대입 |  |  |  |
| AC-0c0e8048 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:528 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-e510b759 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:529 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-2f4db053 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:530 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bucket_from_week"] | p_bucket_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-e56e5a73 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:531 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bucket_to_week"] | p_bucket_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-2ba9b8b4 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:532 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_from_week"] | p_plan_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-5325a597 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:533 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plan_to_week"] | p_plan_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-643bd0aa | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:535 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d8cf613 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:538 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b9b9cb34 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:543 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-54f02457 | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:549 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ad1a66be | this.btnSave.Click [try] 외 2 | FP00521_MemoListPopup.cs:550 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoListPopup.SetHiddenColmn

진입점: this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnFind.Click [try] / this.Load [try] / FindButton [try] / SaveButton [try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e42088c8 | this.btnSave.Click [try ▸ else of (dsResult == null) ▸ if (d… 외 4 | FP00521_MemoListPopup.cs:238 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00521_MemoListPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b83f9577 | this.Load [try] | FP00521_MemoListPopup.cs:214 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-057b3c52 | this.Load [try] | FP00521_MemoListPopup.cs:215 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-3062f39b | this.Load [try] | FP00521_MemoListPopup.cs:220 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-de816d0b | this.Load [try] | FP00521_MemoListPopup.cs:221 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-98484154 | this.Load [try] | FP00521_MemoListPopup.cs:232 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.UPDATE_TIM… | 그리드 편집 잠금/해제 |  |  |  |

## FP00521_MemoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c98b877 | .ctor | FP00521_MemoPopup.cs:58 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |

## FP00521_MemoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23cb370a | this.btnClose.Click | FP00521_MemoPopup.cs:354 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5cce50b | this.btnSql.Click | FP00521_MemoPopup.cs:370 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b77dcb18 | this.btnSql.Click | FP00521_MemoPopup.cs:371 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-478bd3b3 | this.btnSql.Click | FP00521_MemoPopup.cs:373 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMOINFO_POPUP_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-83d05190 | this.btnSql.Click | FP00521_MemoPopup.cs:374 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMOINFO_POPUP_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f14d40e | this.btnSql.Click | FP00521_MemoPopup.cs:375 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00521_MEMOINFO_POPUP_DELETE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6356f2ab | this.btnSql.Click | FP00521_MemoPopup.cs:376 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00521_MemoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91d0dfbb | this.Load | FP00521_MemoPopup.cs:112 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00521_MemoPopup.Delete_Data

진입점: this.btnDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cb41136 | this.btnDelete.Click | FP00521_MemoPopup.cs:280 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b86850e2 | this.btnDelete.Click | FP00521_MemoPopup.cs:282 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e89f6c01 | this.btnDelete.Click | FP00521_MemoPopup.cs:289 | try ▸ else of (dsResult == null) ▸ else of (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-49c3f5f6 | this.btnDelete.Click | FP00521_MemoPopup.cs:294 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP00521_MemoPopup.Delete_Data_Memo

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SELECT") ▸ else of (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SAVE") ▸ if (programID == "PR_UI_FP00521_MEMOINFO_POPUP_DELETE")] / this.btnDelete.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34381c80 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:304 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-a1e8df90 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:308 | try | UI_PROP | req2.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ed5038d2 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:310 | try | DATA_OP | req2.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-977bbca7 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:311 | try | DATA_OP | req2.Parameters["p_sys_flag"] | "DELETE_MEMOINFO" | 행/컬럼 값 대입 |  |  |  |
| AC-d1de526a | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:312 | try | DATA_OP | req2.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-293d5314 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:313 | try | DATA_OP | req2.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-231ab881 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:314 | try | DATA_OP | req2.Parameters["p_company_id"] | Filter["p_company_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-45f5a481 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:315 | try | DATA_OP | req2.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-eecf5d21 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:316 | try | DATA_OP | req2.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-32571c10 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:317 | try | DATA_OP | req2.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-8914afaa | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:318 | try | DATA_OP | req2.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-2764231b | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:319 | try | DATA_OP | req2.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-79f097ae | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:320 | try | DATA_OP | req2.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-347f74ae | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:321 | try | DATA_OP | req2.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-fc2c6363 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:322 | try | DATA_OP | req2.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-7056b0ce | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:323 | try | DATA_OP | req2.Parameters["p_category_id"] | Filter["p_category_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-15e983da | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:324 | try | DATA_OP | req2.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-f409bcb4 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:325 | try | DATA_OP | req2.Parameters["p_market"] | Filter["p_market"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a874f04 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:326 | try | DATA_OP | req2.Parameters["p_plan_week"] | Filter["p_plan_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-f0270ef1 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:327 | try | DATA_OP | req2.Parameters["p_mfg_week"] | Filter["p_mfg_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-f33de46f | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:328 | try | DATA_OP | req2.Parameters["p_description"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-497363f2 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:330 | try | ENDPOINT | client.ExecuteDataSet | (req2) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f5120789 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:333 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-580e7ce2 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:338 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-0cf99046 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 1 | FP00521_MemoPopup.cs:339 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cab6ebb | Dispose | FP00521_MemoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00521_MemoPopup.Find_Data_Memo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SELECT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2586e3cb | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:139 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-d14b9787 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:143 | try | UI_PROP | req2.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-279df47e | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:145 | try | DATA_OP | req2.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-10280d96 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:146 | try | DATA_OP | req2.Parameters["p_sys_flag"] | "SELECT_MEMOINFO" | 행/컬럼 값 대입 |  |  |  |
| AC-c5d150a5 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:147 | try | DATA_OP | req2.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c01656fe | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:148 | try | DATA_OP | req2.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c065563e | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:149 | try | DATA_OP | req2.Parameters["p_company_id"] | Filter["p_company_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-7accdecf | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:150 | try | DATA_OP | req2.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-ee7aa88f | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:151 | try | DATA_OP | req2.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-4d249100 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:152 | try | DATA_OP | req2.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-bff18e30 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:153 | try | DATA_OP | req2.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-b42bb24b | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:154 | try | DATA_OP | req2.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-cce1a1d1 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:155 | try | DATA_OP | req2.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-49750160 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:156 | try | DATA_OP | req2.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-65efd9b7 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:157 | try | DATA_OP | req2.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-eb23684e | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:158 | try | DATA_OP | req2.Parameters["p_category_id"] | Filter["p_category_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1370d9d | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:159 | try | DATA_OP | req2.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-f1ea7463 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:160 | try | DATA_OP | req2.Parameters["p_market"] | Filter["p_market"] | 행/컬럼 값 대입 |  |  |  |
| AC-81e1329a | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:161 | try | DATA_OP | req2.Parameters["p_plan_week"] | Filter["p_plan_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-9b3f35e8 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:162 | try | DATA_OP | req2.Parameters["p_mfg_week"] | Filter["p_mfg_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-4eec3187 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:163 | try | DATA_OP | req2.Parameters["p_description"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-07a32733 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:165 | try | ENDPOINT | client.ExecuteDataSet | (req2) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a2cb06b | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:168 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c623cae4 | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:173 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-76d08ebd | popSql.OnSql [if (programID == "PR_UI_FP00521_MEMOINFO_POPUP… | FP00521_MemoPopup.cs:174 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf2d0aa5 | this.Load | FP00521_MemoPopup.cs:68 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3a6f591 | this.Load | FP00521_MemoPopup.cs:70 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00521_MemoPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-841941e4 | this.Load | FP00521_MemoPopup.cs:85 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6185146d | this.Load | FP00521_MemoPopup.cs:89 |  | VALUE_SET | txtCreator.Text | this.Filter["p_creator"] | 컨트롤 값 설정 |  |  |  |
| AC-0b30129c | this.Load | FP00521_MemoPopup.cs:90 |  | VALUE_SET | txtCreationDate.Text | this.Filter["p_creation_date"] | 컨트롤 값 설정 |  |  |  |
| AC-632c6922 | this.Load | FP00521_MemoPopup.cs:91 |  | VALUE_SET | txtMemo.Text | this.Filter["p_description"] | 컨트롤 값 설정 |  |  |  |
| AC-f5f7fd61 | this.Load | FP00521_MemoPopup.cs:97 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-01f3a4c1 | this.Load | FP00521_MemoPopup.cs:98 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d4ffc6d4 | this.Load | FP00521_MemoPopup.cs:99 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2cb693ea | this.Load | FP00521_MemoPopup.cs:102 |  | CALL_EXT | UserService.HasMemoAuthority | (UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9dbd2769 | this.Load | FP00521_MemoPopup.cs:104 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8266dbf0 | this.Load | FP00521_MemoPopup.cs:105 | if (UserInfoContext.Current != null && !UserService.HasMemoAuthority(UserInfoContext.Current.UserId)) | STATE | btnDelete.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00521_MemoPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a4eddad | popSql.OnSql | FP00521_MemoPopup.cs:393 | if (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SELECT") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e4c80934 | popSql.OnSql | FP00521_MemoPopup.cs:397 | else of (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SAVE") | RETURN | return Save_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-0d0e857c | popSql.OnSql | FP00521_MemoPopup.cs:401 | else of (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SELECT") ▸ else of (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SAVE") ▸ if (programID ==… | RETURN | return Delete_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-448c7829 | popSql.OnSql | FP00521_MemoPopup.cs:403 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00521_MemoPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74a3bc58 | this.btnSave.Click 외 1 | FP00521_MemoPopup.cs:198 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59e43e10 | this.btnSave.Click 외 1 | FP00521_MemoPopup.cs:200 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-332647af | this.btnSave.Click 외 1 | FP00521_MemoPopup.cs:207 | try ▸ else of (dsResult == null) ▸ else of (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b04d2208 | this.btnSave.Click 외 1 | FP00521_MemoPopup.cs:212 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP00521_MemoPopup.Save_Data_Memo

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SELECT") ▸ if (programID == "PR_UI_FP00521_MEMOINFO_POPUP_SAVE")] / this.btnSave.Click [try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-979db04c | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:222 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO") ⇒ FP_Master.PR_UI_FP00521_DEMAND_WATERFALL_MEMOINFO | 엔드포인트 요청 생성 |  |  |  |
| AC-259f62c2 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:226 | try | UI_PROP | req2.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-42177152 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:228 | try | DATA_OP | req2.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-94b8a90b | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:229 | try | DATA_OP | req2.Parameters["p_sys_flag"] | "SAVE_MEMOINFO" | 행/컬럼 값 대입 |  |  |  |
| AC-a7f12b72 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:230 | try | DATA_OP | req2.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-243ac61d | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:231 | try | DATA_OP | req2.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2a8a210d | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:232 | try | DATA_OP | req2.Parameters["p_company_id"] | Filter["p_company_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-21d15003 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:233 | try | DATA_OP | req2.Parameters["p_division_id"] | Filter["p_division_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-7e1b0188 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:234 | try | DATA_OP | req2.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-44cb08e9 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:235 | try | DATA_OP | req2.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-28549f91 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:236 | try | DATA_OP | req2.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba82fe2c | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:237 | try | DATA_OP | req2.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-46cd0a98 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:238 | try | DATA_OP | req2.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-b44a0f9c | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:239 | try | DATA_OP | req2.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-0d03e855 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:240 | try | DATA_OP | req2.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-df27cf78 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:241 | try | DATA_OP | req2.Parameters["p_category_id"] | Filter["p_category_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-a7cb9aa6 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:242 | try | DATA_OP | req2.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c7846cc | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:243 | try | DATA_OP | req2.Parameters["p_market"] | Filter["p_market"] | 행/컬럼 값 대입 |  |  |  |
| AC-152aa095 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:244 | try | DATA_OP | req2.Parameters["p_plan_week"] | Filter["p_plan_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-e899a7fd | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:245 | try | DATA_OP | req2.Parameters["p_mfg_week"] | Filter["p_mfg_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-e02d38b6 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:246 | try | DATA_OP | req2.Parameters["p_description"] | txtMemo.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6f1d56b4 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:248 | try | ENDPOINT | client.ExecuteDataSet | (req2) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9df1c0e2 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:251 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-8986321c | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:256 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-11a0a795 | popSql.OnSql [else of (programID == "PR_UI_FP00521_MEMOINFO_… 외 2 | FP00521_MemoPopup.cs:257 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

