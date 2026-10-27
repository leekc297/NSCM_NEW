# AS-IS 액션 대조표 — FDM0007

> 원천: `Doc/asisfacts/screens/FDM0007/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 503행 · 메서드 68 · 종류 DATA_OP 197 · FLAG 58 · RETURN 40 · GRID_SET 32 · GRID_INIT 28 · UI_PROP 21 · COMBO_DATA 19 · POPUP 14 · MESSAGE 13 · UI_MISC 12 · THROW 9 · VALUE_SET 8 · CALL_EXT 8 · ENDPOINT 8 · LIST_REBIND 8 · GRID_LOCK 7 · GRID_BIND 6 · STATE 4 · CALL_BASE 3 · GRID_STYLE 3 · EXCEL 2 · STATE_RESET 2 · VALIDATE 1 · ⚠ 의미 확인 필요 11


## FDM0007_Demand_WaterFall.ApplySearchCondition

진입점: this.btnMemoDown.Click / popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFALL_SELECT")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-572b7245 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:782 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //변수 데이타테이블 DataTable dtCurrWeek = null; DataTable dtWeek… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcb9ed48 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:797 | lambda | FLAG | _s_curr_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-289310ad | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:798 | lambda | FLAG | _s_bucket_from_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1a78eedb | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:799 | lambda | FLAG | _s_bucket_to_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2d2e30cb | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:800 | lambda | FLAG | _s_plan_from_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-89fbb1a6 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:801 | lambda | FLAG | _s_plan_to_week | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-0663d85c | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:804 | lambda | FLAG | _s_week_info | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-29f81048 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:805 | lambda | FLAG | _s_month_week_column | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1a2ed8e3 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:806 | lambda | FLAG | _s_month_column_info | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-be212d8c | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:807 | lambda | FLAG | _s_plan_week_Info | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1ab7d359 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:809 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FDM0007_find_currWeek") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33bd229e | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:810 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FDM0007_find_BucketWeekCnt", sStartDate, sEndDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6279eb0 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:815 | lambda ▸ if (dtCurrWeek.Rows.Count>0) | FLAG | _s_curr_week | dtCurrWeek.Rows[0]["CURR_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a73aa2aa | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:819 | lambda ▸ if (dtBukWeekInfo.Rows.Count > 0) | FLAG | _s_bucket_from_week | dtBukWeekInfo.Rows[0]["BUCKET_FROM_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-92f0eae8 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:820 | lambda ▸ if (dtBukWeekInfo.Rows.Count > 0) | FLAG | _s_bucket_to_week | dtBukWeekInfo.Rows[0]["BUCKET_TO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2f4f0243 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:823 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FDM0007_find_WeekCnt", sStartDate, sEndDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-df4250a9 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:825 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FDM0007_find_MonthColumn", sStartDate, sEndDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f0d5cc21 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:826 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FDM0007_find_PlanWeekCnt", sScpPlanID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4def4e67 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:828 | lambda | FLAG | _s_week_info | DataCommon.MakeDelimeterStringAsDataTable("WEEK", dtWeekInfo, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-3be95f9b | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:828 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK", dtWeekInfo, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56d26f5f | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:829 | lambda | FLAG | _s_month_week_column | DataCommon.MakeDelimeterStringAsDataTable("WEEK_COLUMN", dtMonthColumn, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-865265f0 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:829 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("WEEK_COLUMN", dtMonthColumn, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bbb2aacb | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:830 | lambda | FLAG | _s_month_column_info | DataCommon.MakeDelimeterStringAsDataTable("MONTH_COLUMN", dtMonthColumn, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-926450b7 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:830 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("MONTH_COLUMN", dtMonthColumn, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f7c5be5 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:831 | lambda | FLAG | _s_plan_week_Info | DataCommon.MakeDelimeterStringAsDataTable("PLAN_WEEK", dtPlanWeekInfo, "\|") | 화면 필드/플래그 변경 |  |  |  |
| AC-8beb64ea | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:831 | lambda | COMBO_DATA | DataCommon.MakeDelimeterStringAsDataTable | ("PLAN_WEEK", dtPlanWeekInfo, "\|") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18087351 | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:835 | lambda ▸ if (dtPlanWeekInfo.Rows.Count > 0) | FLAG | _s_plan_from_week | dtPlanWeekInfo.Rows[0]["PLAN_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-15d7586b | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:836 | lambda ▸ if (dtPlanWeekInfo.Rows.Count > 0) | FLAG | _s_plan_to_week | dtPlanWeekInfo.Rows[4]["PLAN_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ea7a65cd | this.btnMemoDown.Click 외 2 | FDM0007_Demand_WaterFall.cs:840 | lambda | FLAG | weekInfo | dtWeekInfo.DataSet | 화면 필드/플래그 변경 |  |  |  |

## FDM0007_Demand_WaterFall.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9372762d | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:405 | if (string.IsNullOrEmpty(p_instance_id)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "SCP Plan ID is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9311cd9e | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:406 | if (string.IsNullOrEmpty(p_instance_id)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-091d5358 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:412 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-298c0402 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:415 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-39dbd948 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:416 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-4be2c8af | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:417 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-0bfaec25 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:418 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8980d37e | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:419 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2e90e7f | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:420 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-577ace69 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:421 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-bec717c0 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:422 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a91cf9a | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:423 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-da209f48 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:424 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | p_bucket_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-c47b6f0b | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:425 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | p_bucket_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-837db19b | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:426 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | txtModel.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-50e24bec | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:427 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | txtItemID.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6fe16517 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:428 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-64989a1f | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:429 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-0c392c32 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:430 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-cca22dd8 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:432 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-0de7589a | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:433 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-2d179034 | this.btnMemo.Click | FDM0007_Demand_WaterFall.cs:434 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0007_Demand_WaterFall.btnMemoDowm_Click

진입점: this.btnMemoDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a449c2c5 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:460 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_instance_id = CString.GetCheckedListValue(dtInstance, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa288b0e | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:488 | if (string.IsNullOrEmpty(p_instance_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "SCP Plan ID is null.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d688a67b | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:489 | if (string.IsNullOrEmpty(p_instance_id.ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd3ca05c | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:495 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-568eff19 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:498 |  | POPUP | new FDM0007_MemoDownPopup | () | 팝업/폼 생성 |  |  |  |
| AC-92851953 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:500 |  | DATA_OP | DownPopup.Filter["p_instance_id"] | p_instance_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-82d55de5 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:501 |  | DATA_OP | DownPopup.Filter["p_site_id"] | p_site_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-908c7e26 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:502 |  | DATA_OP | DownPopup.Filter["p_plant_id"] | p_plant_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e3e1eb46 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:503 |  | DATA_OP | DownPopup.Filter["p_factory_id"] | p_factory_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-621b6d38 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:504 |  | DATA_OP | DownPopup.Filter["p_operation_id"] | p_operation_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b77518ee | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:505 |  | DATA_OP | DownPopup.Filter["p_line_id"] | p_line_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61841600 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:506 |  | DATA_OP | DownPopup.Filter["p_prod_type"] | p_prod_type.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3105c670 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:507 |  | DATA_OP | DownPopup.Filter["p_model_id"] | p_model_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06725f85 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:508 |  | DATA_OP | DownPopup.Filter["p_item_id"] | p_item_id.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00c6d156 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:509 |  | DATA_OP | DownPopup.Filter["p_nick_name"] | p_nick_name.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36c8b98e | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:510 |  | DATA_OP | DownPopup.Filter["p_chk_total_include"] | p_chk_total_include.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f81eb329 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:511 |  | DATA_OP | DownPopup.Filter["p_pp_option"] | p_pp_option.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd4a37c6 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:512 |  | DATA_OP | DownPopup.Filter["p_curr_week"] | _s_curr_week.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f430a472 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:513 |  | DATA_OP | DownPopup.Filter["p_bucket_from_date"] | p_bucket_from_date.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9cd8684b | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:514 |  | DATA_OP | DownPopup.Filter["p_bucket_to_date"] | p_bucket_to_date.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c7633383 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:515 |  | DATA_OP | DownPopup.Filter["p_bucket_from_week"] | _s_bucket_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-c3d5343f | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:516 |  | DATA_OP | DownPopup.Filter["p_bucket_to_week"] | _s_bucket_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-6228101c | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:517 |  | DATA_OP | DownPopup.Filter["p_plan_from_week"] | _s_plan_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-c15e6fef | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:518 |  | DATA_OP | DownPopup.Filter["p_plan_to_week"] | _s_plan_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-12cda4b7 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:519 |  | DATA_OP | DownPopup.Filter["p_week_info"] | _s_week_info | 행/컬럼 값 대입 |  |  |  |
| AC-45ae8c5a | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:520 |  | DATA_OP | DownPopup.Filter["p_month_week_column"] | _s_month_week_column | 행/컬럼 값 대입 |  |  |  |
| AC-1dae264e | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:521 |  | DATA_OP | DownPopup.Filter["p_month_column_info"] | _s_month_column_info | 행/컬럼 값 대입 |  |  |  |
| AC-e13f205f | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:522 |  | DATA_OP | DownPopup.Filter["p_plan_week_Info"] | _s_plan_week_Info | 행/컬럼 값 대입 |  |  |  |
| AC-9ddfe0cf | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:525 |  | UI_PROP | DownPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-656d2fd2 | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:526 |  | UI_PROP | DownPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-892ebcbc | this.btnMemoDown.Click | FDM0007_Demand_WaterFall.cs:527 |  | POPUP | DownPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0007_Demand_WaterFall.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af9d4725 | this.btnSql.Click | FDM0007_Demand_WaterFall.cs:537 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-acad669c | this.btnSql.Click | FDM0007_Demand_WaterFall.cs:538 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a0df5291 | this.btnSql.Click | FDM0007_Demand_WaterFall.cs:540 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FDM0007_DEMAND_WATERFALL_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2e6a40f | this.btnSql.Click | FDM0007_Demand_WaterFall.cs:541 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0007_Demand_WaterFall.CreateDataTable

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcee30b8 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:986 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-69684728 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:987 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-93ab6b56 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:988 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3257fba7 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:989 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_VALUE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fd9d7b6 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:990 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee0e42ef | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:991 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d11b07ed | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:992 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MENU_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8347402f | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:993 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-af26c25a | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:995 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.CreateFilterDataSet

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a86428c | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:639 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4d89e29f | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:647 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ef101e50 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:648 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a328e781 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:658 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "R_P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d13ac2cc | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:663 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PP_FP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ea6b531 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:667 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38de60ae | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:670 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53a458a3 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:674 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c81e590 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:679 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c8b6e852 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:683 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d9b0526 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:685 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aefd124a | this.Load | FDM0007_Demand_WaterFall.cs:273 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-576e61d5 | this.Load | FDM0007_Demand_WaterFall.cs:274 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5c17f34 | this.Load | FDM0007_Demand_WaterFall.cs:276 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FDM0007_Demand_WaterFall.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bc597b3 | DeleteButton | FDM0007_Demand_WaterFall.cs:370 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-873e527b | DeleteButton | FDM0007_Demand_WaterFall.cs:371 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6720074a | Dispose | FDM0007_Demand_WaterFall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FDM0007_Demand_WaterFall.dtpPlanDate_CloseUp

진입점: this.dtpPlanDate.CloseUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81cf9f1b | this.dtpPlanDate.CloseUp | FDM0007_Demand_WaterFall.cs:1015 | if (Convert.ToDecimal(sDate) > Convert.ToDecimal(sToDate)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Select Date can't more than Today." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cab25131 | this.dtpPlanDate.CloseUp | FDM0007_Demand_WaterFall.cs:1018 | if (Convert.ToDecimal(sDate) > Convert.ToDecimal(sToDate)) | VALUE_SET | dtpPlanDate.Value | dDate | 컨트롤 값 설정 |  |  |  |
| AC-7c1e3b23 | this.dtpPlanDate.CloseUp | FDM0007_Demand_WaterFall.cs:1019 | if (Convert.ToDecimal(sDate) > Convert.ToDecimal(sToDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d15be31f | EditButton | FDM0007_Demand_WaterFall.cs:362 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edec08bf | EditButton | FDM0007_Demand_WaterFall.cs:363 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcf6d003 | ExcelButton | FDM0007_Demand_WaterFall.cs:551 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FDM0007_Demand_WaterFall.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-891b54b9 | FindButton | FDM0007_Demand_WaterFall.cs:556 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b5183f92 | FindButton | FDM0007_Demand_WaterFall.cs:561 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea954165 | FindButton | FDM0007_Demand_WaterFall.cs:564 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-299b7f71 | FindButton | FDM0007_Demand_WaterFall.cs:564 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58871175 | FindButton | FDM0007_Demand_WaterFall.cs:571 | try ▸ if (string.IsNullOrEmpty(pPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "SCP Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5bca333f | FindButton | FDM0007_Demand_WaterFall.cs:572 | try ▸ if (string.IsNullOrEmpty(pPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-333236b0 | FindButton | FDM0007_Demand_WaterFall.cs:575 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5195f018 | FindButton | FDM0007_Demand_WaterFall.cs:576 | try | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f9bbf765 | FindButton | FDM0007_Demand_WaterFall.cs:579 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3475b36 | FindButton | FDM0007_Demand_WaterFall.cs:585 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Demend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-03e92a03 | FindButton | FDM0007_Demand_WaterFall.cs:585 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Demend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3aebde2 | FindButton | FDM0007_Demand_WaterFall.cs:593 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad6d747e | FindButton | FDM0007_Demand_WaterFall.cs:602 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a7d2d32 | FindButton | FDM0007_Demand_WaterFall.cs:608 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_STYLE | siMain.SetBGColor | (0, 0, siMain.GetMaxRowIndex(), siMain.GetColumnIndex(DefColumns.PLAN_WEEK_NAME), System.D… | 그리드 표시 설정 |  |  |  |
| AC-fe202788 | FindButton | FDM0007_Demand_WaterFall.cs:610 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | "SCP Plan ID: " + CString.GetCheckedListValue(dtPlanID, cboPlanID.ControlValues) | 컨트롤 값 설정 |  |  |  |
| AC-7b46d7c9 | FindButton | FDM0007_Demand_WaterFall.cs:615 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-15ce79d4 | FindButton | FDM0007_Demand_WaterFall.cs:617 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b3f8234c | FindButton | FDM0007_Demand_WaterFall.cs:619 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-15c94d33 | FindButton | FDM0007_Demand_WaterFall.cs:621 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | VALUE_SET | lblPlanID.Text | "SCP Plan ID: " | 컨트롤 값 설정 |  |  |  |
| AC-8604bc5b | FindButton | FDM0007_Demand_WaterFall.cs:628 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FDM0007_Demand_WaterFall.Find_Data_Demend

진입점: popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFALL_SELECT")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7ae71a1 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:708 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { p_instance_id = CString.GetCheckedListValue(dtInstance, c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c907d014 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:738 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL") ⇒ FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-f650e65e | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:739 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-429d692d | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:740 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-55e43caa | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:741 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-db421d20 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:742 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f71bdf8c | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:744 | try | DATA_OP | request.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-c8eb235d | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:745 | try | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7c9e8483 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:746 | try | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ebc51a5 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:747 | try | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-3ae26a63 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:748 | try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-a9b74dd6 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:749 | try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-1fd254eb | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:750 | try | DATA_OP | request.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-5c120323 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:751 | try | DATA_OP | request.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-477b5289 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:752 | try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb3d782b | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:753 | try | DATA_OP | request.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-fefd1565 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:754 | try | DATA_OP | request.Parameters["p_chk_total_include"] | p_chk_total_include | 행/컬럼 값 대입 |  |  |  |
| AC-f29f9f8e | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:755 | try | DATA_OP | request.Parameters["p_pp_option"] | p_pp_option | 행/컬럼 값 대입 |  |  |  |
| AC-3f1517be | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:756 | try | DATA_OP | request.Parameters["p_curr_week"] | _s_curr_week | 행/컬럼 값 대입 |  |  |  |
| AC-a604b410 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:757 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | p_bucket_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-8cc0b89d | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:758 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | p_bucket_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-43fc3710 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:759 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | _s_bucket_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-f3aaa04f | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:760 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | _s_bucket_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-032409f5 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:761 | try | DATA_OP | request.Parameters["p_plan_from_week"] | _s_plan_from_week | 행/컬럼 값 대입 |  |  |  |
| AC-43f284c4 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:762 | try | DATA_OP | request.Parameters["p_plan_to_week"] | _s_plan_to_week | 행/컬럼 값 대입 |  |  |  |
| AC-179c688a | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:763 | try | DATA_OP | request.Parameters["p_week_info"] | _s_week_info | 행/컬럼 값 대입 |  |  |  |
| AC-efae2b0c | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:764 | try | DATA_OP | request.Parameters["p_month_week_column"] | _s_month_week_column | 행/컬럼 값 대입 |  |  |  |
| AC-338ad9f3 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:765 | try | DATA_OP | request.Parameters["p_month_column_info"] | _s_month_column_info | 행/컬럼 값 대입 |  |  |  |
| AC-d7cfe972 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:766 | try | DATA_OP | request.Parameters["p_plan_week_Info"] | _s_plan_week_Info | 행/컬럼 값 대입 |  |  |  |
| AC-0df29e97 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:768 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5637dbb8 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:770 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-34406d71 | popSql.OnSql [if (programID == "PR_UI_FDM0007_DEMAND_WATERFA… 외 1 | FDM0007_Demand_WaterFall.cs:775 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9699bfe | FindButton | FDM0007_Demand_WaterFall.cs:344 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |

## FDM0007_Demand_WaterFall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e871219 | this.Load | FDM0007_Demand_WaterFall.cs:140 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FDM0007_Demand_WaterFall.GetMakeMeasure

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-205b3c76 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:950 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ee348487 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:952 |  | DATA_OP | newrow["MEA_ID"] | "chk_week" | 행/컬럼 값 대입 |  |  |  |
| AC-7694950f | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:953 |  | DATA_OP | newrow["MEA_NAME"] | "Week" | 행/컬럼 값 대입 |  |  |  |
| AC-0dc61f8d | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:954 |  | DATA_OP | newrow["MEA_VALUE"] | "true" | 행/컬럼 값 대입 |  |  |  |
| AC-3eb316c2 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:955 |  | DATA_OP | newrow["TYPE"] | "BUCKET" | 행/컬럼 값 대입 |  |  |  |
| AC-a8b13c5c | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:956 |  | DATA_OP | newrow["FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-081a5ef7 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:957 |  | DATA_OP | newrow["MENU_ID"] | "FDM0007" | 행/컬럼 값 대입 |  |  |  |
| AC-bcf34472 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:958 |  | DATA_OP | newrow["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-fb14424d | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:961 |  | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4c717a3 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:962 |  | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-56677720 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:963 |  | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-23cfe432 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:975 | foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | ret.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-a64743bb | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:978 |  | FLAG | measure | new MeasurePack(ret) | 화면 필드/플래그 변경 |  |  |  |
| AC-0992b935 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if … | FDM0007_Demand_WaterFall.cs:979 |  | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |

## FDM0007_Demand_WaterFall.GetToDay

진입점: this.dtpPlanDate.CloseUp / this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87cd5f40 | this.dtpPlanDate.CloseUp 외 1 | FDM0007_Demand_WaterFall.cs:1412 |  | RETURN | return sToDay; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19a1f614 | this.Load | FDM0007_Demand_WaterFall.cs:163 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f32d4ed5 | this.Load | FDM0007_Demand_WaterFall.cs:166 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d82a6a6 | this.Load | FDM0007_Demand_WaterFall.cs:169 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7f1b50d8 | this.Load | FDM0007_Demand_WaterFall.cs:170 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-92e17715 | this.Load | FDM0007_Demand_WaterFall.cs:177 | try ▸ for (i < itemValues.Length) | DATA_OP | rdoGroup1.Properties.Items.Add | (new RadioGroupItem(itemValues[i], itemDescriptions[i])) | 데이터 객체 조작/조회 |  |  |  |
| AC-43c74240 | this.Load | FDM0007_Demand_WaterFall.cs:180 | try | VALUE_SET | rdoGroup1.EditValue | 1 | 컨트롤 값 설정 |  |  |  |
| AC-a779a18c | this.Load | FDM0007_Demand_WaterFall.cs:199 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f7d66050 | this.Load | FDM0007_Demand_WaterFall.cs:200 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d44881a7 | this.Load | FDM0007_Demand_WaterFall.cs:201 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0676cb5a | this.Load | FDM0007_Demand_WaterFall.cs:207 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_Demand_WaterFall.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5943817 | this.Load | FDM0007_Demand_WaterFall.cs:288 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d322e14e | this.Load | FDM0007_Demand_WaterFall.cs:289 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0c9c109f | this.Load | FDM0007_Demand_WaterFall.cs:293 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_Demand_WaterFall.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-817218fb | InsertButton | FDM0007_Demand_WaterFall.cs:354 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-279e3ff0 | InsertButton | FDM0007_Demand_WaterFall.cs:355 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.rdoGroup1_SelectedIndexChanged

진입점: this.rdoGroup1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc79ec93 | this.rdoGroup1.SelectedIndexChanged | FDM0007_Demand_WaterFall.cs:1032 | if (radioGroup.SelectedIndex == 0) | FLAG | _sWDFlag | "WPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-2faa17ef | this.rdoGroup1.SelectedIndexChanged | FDM0007_Demand_WaterFall.cs:1036 | else of (radioGroup.SelectedIndex == 0) | FLAG | _sWDFlag | "DPP" | 화면 필드/플래그 변경 |  |  |  |

## FDM0007_Demand_WaterFall.RefreshHeader

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d55f2b1 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:888 | if (weekInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-44128121 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:889 | if (weekInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-3fa7f046 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:897 | if (weekInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, FPExtensions.DateColumnType.TYPEZERO, FPExt… | ⚠ 의미 확인 필요 |  |  |  |
| AC-92eed59a | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:901 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-14f0fac8 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:903 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-163d60ce | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:905 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78d85a1f | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:906 | if (weekInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20e6c421 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:909 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa04dd03 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:910 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14280584 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:913 | if (weekInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-c8b7dcfa | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:916 | if (weekInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-faadeba8 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:918 | if (weekInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1aae1912 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try… | FDM0007_Demand_WaterFall.cs:934 | if (weekInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_it… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |

## FDM0007_Demand_WaterFall.RefreshSpreadSheet

진입점: FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2386f692 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] | FDM0007_Demand_WaterFall.cs:856 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0e24fd3 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] | FDM0007_Demand_WaterFall.cs:863 | try ▸ if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c60d6e26 | FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] | FDM0007_Demand_WaterFall.cs:870 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_Demand_WaterFall.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8fa36d5 | popSql.OnSql | FDM0007_Demand_WaterFall.cs:1420 | if (programID == "PR_UI_FDM0007_DEMAND_WATERFALL_SELECT") | RETURN | return Find_Data_Demend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-eaa3343a | popSql.OnSql | FDM0007_Demand_WaterFall.cs:1422 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bea2245 | SaveButton | FDM0007_Demand_WaterFall.cs:378 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75cda2af | SaveButton | FDM0007_Demand_WaterFall.cs:379 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.SetChangedControl

진입점: this.Load [try] / cboPlanGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b7eb5fc | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:245 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_Demand_WaterFall.SetFactory

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try] / cboPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e7b731b | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1262 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cfe8ba4 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1264 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInsta… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-e8675624 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1264 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstance, "", "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dafef5b3 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1266 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## FDM0007_Demand_WaterFall.SetHiddenColmn

진입점: this.Load [try] / FindButton [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc759002 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:326 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f9c66aa6 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:327 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c76288e9 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:328 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-af1c9b7b | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:329 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c59d63f2 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:330 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f58aba82 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:331 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_WEEK_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5d551e64 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:332 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DATA_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-006afa81 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:333 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_DETAIL_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FDM0007_Demand_WaterFall.SetLine

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try] / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d7aac5a | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1316 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-34ffb1f1 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1320 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-6db205f1 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1324 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e507d8b | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1329 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b93e997 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1332 |  | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-984fc9d6 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1332 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", "", "", "" , "", "", p… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3fb20445 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1334 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## FDM0007_Demand_WaterFall.SetOperation

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try] / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6101a232 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1283 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-57dfc197 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1287 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d139cfa | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1291 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e798a586 | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1295 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-9ed244bb | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1295 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, _CurrentUser, _sNonAuth, _sSaveAuth, "", "", "", "" , "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-821fbfda | this.Load [try ▸ try] 외 2 | FDM0007_Demand_WaterFall.cs:1297 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## FDM0007_Demand_WaterFall.SetPlanDate

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-273ceaa5 | this.Load [try] | FDM0007_Demand_WaterFall.cs:1400 |  | VALUE_SET | dtpPlanDate.Value | dDate | 컨트롤 값 설정 |  |  |  |

## FDM0007_Demand_WaterFall.SetPlanGroup

진입점: this.Load [try] / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71bb55b8 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1212 |  | FLAG | dtInstance | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0007_findInstanceList_common", sDataI… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f927ff34 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1212 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0007_findInstanceList_common", sDataID) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-56a19c58 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1213 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FDM0007_Demand_WaterFall.SetPlanID

진입점: this.dtpPlanDate.CloseUp / this.Load [try] / cboPlanGroup.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a1665e0 | this.dtpPlanDate.CloseUp 외 2 | FDM0007_Demand_WaterFall.cs:1226 |  | FLAG | dtPlanID | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0007_find_SCP_Plan_List", pInstance, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-98a25f73 | this.dtpPlanDate.CloseUp 외 2 | FDM0007_Demand_WaterFall.cs:1226 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0007_find_SCP_Plan_List", pInstance, pPlanDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95cc9701 | this.dtpPlanDate.CloseUp 외 2 | FDM0007_Demand_WaterFall.cs:1227 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanID, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FDM0007_Demand_WaterFall.SetPlant

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d84f7b1e | this.Load [try ▸ try] 외 1 | FDM0007_Demand_WaterFall.cs:1244 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-7860357f | this.Load [try ▸ try] 외 1 | FDM0007_Demand_WaterFall.cs:1246 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstanc… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-ae04f69a | this.Load [try ▸ try] 외 1 | FDM0007_Demand_WaterFall.cs:1246 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth, pInstance, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-750086e0 | this.Load [try ▸ try] 외 1 | FDM0007_Demand_WaterFall.cs:1247 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FDM0007_Demand_WaterFall.SetProdType

진입점: this.Load [try ▸ try] / cboPlanGroup.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fded184e | this.Load [try ▸ try] 외 1 | FDM0007_Demand_WaterFall.cs:1345 |  | FLAG | dtProdType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0007_find_FPProdType", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-517d4e72 | this.Load [try ▸ try] 외 1 | FDM0007_Demand_WaterFall.cs:1345 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0007_find_FPProdType", pInstance) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16983093 | this.Load [try ▸ try] 외 1 | FDM0007_Demand_WaterFall.cs:1346 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, true) | 목록 컨트롤 재구성 |  |  |  |

## FDM0007_Demand_WaterFall.SetSite

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9164a545 | this.Load [try] | FDM0007_Demand_WaterFall.cs:1198 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-69d2f7af | this.Load [try] | FDM0007_Demand_WaterFall.cs:1198 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef5ca744 | this.Load [try] | FDM0007_Demand_WaterFall.cs:1199 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-019447cc | this.Load [try] | FDM0007_Demand_WaterFall.cs:1202 | if (dtSite.Rows.Count == 1) | VALUE_SET | cboSite.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FDM0007_Demand_WaterFall.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22059511 | this.Load [try] | FDM0007_Demand_WaterFall.cs:302 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12d1916b | this.Load [try] | FDM0007_Demand_WaterFall.cs:303 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e844e850 | this.Load [try] | FDM0007_Demand_WaterFall.cs:308 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-4201b9c9 | this.Load [try] | FDM0007_Demand_WaterFall.cs:309 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLAN_WEEK)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5eeb4cda | this.Load [try] | FDM0007_Demand_WaterFall.cs:320 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.DATA_TYPE)… | 그리드 편집 잠금/해제 |  |  |  |

## FDM0007_Demand_WaterFall.SetStartEndDate

진입점: this.Load [try] / cboPlanID.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b913451 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1358 |  | FLAG | dtStartEndDate | DataCommon.GetMasterFormCodeData(_FormProcedure, "FDM0007_find_SCP_Plan_List", sInstance, … ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-f0d61139 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1358 |  | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FDM0007_find_SCP_Plan_List", sInstance, sPlanDate) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf9603ab | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1371 | if (dtPlanID != null) ▸ if (dtStartEndDate.Rows.Count > 0) | DATA_OP | dtPlanID.Select | (string.Format("CODE = '{0}'", sPlanID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b10325 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1372 | if (dtPlanID != null) ▸ if (dtStartEndDate.Rows.Count > 0) | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4d172960 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1379 | if (dtPlanID != null) ▸ if (dtStartEndDate.Rows.Count > 0) ▸ if (dtResult.Rows.Count > 0) | VALUE_SET | drpPeriod.InitValue | sStartDate.ToString() + ":" + sEndDate.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5d03d65e | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1384 | if (dtPlanID != null) ▸ else of (dtStartEndDate.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-c6d0273e | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1385 | if (dtPlanID != null) ▸ else of (dtStartEndDate.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |
| AC-24b1752f | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1390 | else of (dtPlanID != null) | UI_PROP | drpPeriod.Text1 | "" | 속성 Text1 설정 |  |  |  |
| AC-3e566b48 | this.Load [try] 외 1 | FDM0007_Demand_WaterFall.cs:1391 | else of (dtPlanID != null) | UI_PROP | drpPeriod.Text2 | "" | 속성 Text2 설정 |  |  |  |

## FDM0007_Demand_WaterFall.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17c2f0ca | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1097 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d31210b | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1099 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d7c1ede | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1122 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | new FDM0005_ItemPopup | (bFilterEnable, bMultiSelect, pDivision, pSite, pPlant) | 팝업/폼 생성 |  |  |  |
| AC-0364d9c3 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1123 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0b5d2554 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1124 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5a8d213c | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1135 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), pCompany) | 그리드 값 설정 |  |  |  |
| AC-feb107e3 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1137 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), pDivision) | 그리드 값 설정 |  |  |  |
| AC-6c8ee1e1 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1138 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), pSite) | 그리드 값 설정 |  |  |  |
| AC-ae8ac20a | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1139 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), pPlant) | 그리드 값 설정 |  |  |  |
| AC-1b5649b2 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1140 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), pItem) | 그리드 값 설정 |  |  |  |
| AC-74a09145 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1141 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && actio… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), pItemName) | 그리드 값 설정 |  |  |  |
| AC-f66dc52e | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1154 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg2 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47f30fa2 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1155 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f9ee47d | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1158 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | POPUP | new FDM0005_TransportModePopup | (pPlant) | 팝업/폼 생성 |  |  |  |
| AC-ef9a95b6 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1159 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | UI_PROP | popTransMode.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-313d0eb0 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1160 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | POPUP | popTransMode.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5e222cab | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1167 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), pTransportMode) | 그리드 값 설정 |  |  |  |
| AC-ad05dd73 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1168 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), pShiptoSite) | 그리드 값 설정 |  |  |  |
| AC-dd45ba52 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1175 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID) && … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLAN_WEEK), pShipDate) | 그리드 값 설정 |  |  |  |
| AC-94e65d53 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1184 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-d11e19a1 | this.spdMain.CellClick | FDM0007_Demand_WaterFall.cs:1187 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FDM0007_MemoDownPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf64489b | .ctor | FDM0007_MemoDownPopup.cs:116 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |

## FDM0007_MemoDownPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c2afe79 | this.btnClose.Click | FDM0007_MemoDownPopup.cs:324 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FDM0007_MemoDownPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbb3fee4 | this.btnSql.Click | FDM0007_MemoDownPopup.cs:330 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5ce458d9 | this.btnSql.Click | FDM0007_MemoDownPopup.cs:331 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-67a9da83 | this.btnSql.Click | FDM0007_MemoDownPopup.cs:333 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FDM0007_MEMODOWN_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-c542dbbc | this.btnSql.Click | FDM0007_MemoDownPopup.cs:334 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FDM0007_MEMO_LIST") | 데이터 객체 조작/조회 |  |  |  |
| AC-243495b8 | this.btnSql.Click | FDM0007_MemoDownPopup.cs:335 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FDM0007_MemoDownPopup.CreateDataTable

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07b34b58 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:713 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-42ff20a0 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:714 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-930dd468 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:715 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_NAME", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-da10325d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:716 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MEA_VALUE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-455ef0cf | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:717 |  | DATA_OP | dt.Columns.Add | (new DataColumn("TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f00af7c8 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:718 |  | DATA_OP | dt.Columns.Add | (new DataColumn("FLAG", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-357607d8 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:719 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MENU_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d22740f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:720 |  | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d8629bd | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:722 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.CreateFilterDataSet

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06bb3a5b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:417 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-70a37cc9 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:425 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-86f12092 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:426 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-960b938b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:436 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "R_P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b6c608c | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:441 |  | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PP_FP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-90521845 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:447 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2f5045a | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:450 |  | CALL_EXT | MeasureService.SetRowsUnVisible | (MainGo, un_chks_measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-565fcb1f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:454 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d6ad052 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:459 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e682be63 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:463 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9d82be1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try] 외 1 | FDM0007_MemoDownPopup.cs:465 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2fd23e2 | this.Load | FDM0007_MemoDownPopup.cs:201 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3edf0660 | this.Load | FDM0007_MemoDownPopup.cs:202 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8f03bd1 | this.Load | FDM0007_MemoDownPopup.cs:204 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FDM0007_MemoDownPopup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3782e8d7 | DeleteButton | FDM0007_MemoDownPopup.cs:299 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cd07e295 | DeleteButton | FDM0007_MemoDownPopup.cs:300 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8a5c609 | Dispose | FDM0007_MemoDownPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FDM0007_MemoDownPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-159cec8b | EditButton | FDM0007_MemoDownPopup.cs:291 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41a2e378 | EditButton | FDM0007_MemoDownPopup.cs:292 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.Excel_Export

진입점: this.btnExport.Click / ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09d7ffc4 | this.btnExport.Click 외 1 | FDM0007_MemoDownPopup.cs:345 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FDM0007_MemoDownPopup.Find_Data

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de06fb3f | this.Load 외 1 | FDM0007_MemoDownPopup.cs:350 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-70177636 | this.Load 외 1 | FDM0007_MemoDownPopup.cs:355 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f3c4636a | this.Load 외 1 | FDM0007_MemoDownPopup.cs:358 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73fd46ed | this.Load 외 1 | FDM0007_MemoDownPopup.cs:361 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_MemoDown("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf03caec | this.Load 외 1 | FDM0007_MemoDownPopup.cs:361 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_MemoDown("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e3cf9294 | this.Load 외 1 | FDM0007_MemoDownPopup.cs:369 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a2826a4 | this.Load 외 1 | FDM0007_MemoDownPopup.cs:372 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dsMemo | Find_Data_Memo() | 화면 필드/플래그 변경 |  |  |  |
| AC-e5e8d37a | this.Load 외 1 | FDM0007_MemoDownPopup.cs:382 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f65ca6ac | this.Load 외 1 | FDM0007_MemoDownPopup.cs:389 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-027ae139 | this.Load 외 1 | FDM0007_MemoDownPopup.cs:394 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-83a6699a | this.Load 외 1 | FDM0007_MemoDownPopup.cs:396 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b12f422a | this.Load 외 1 | FDM0007_MemoDownPopup.cs:398 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7bdc9ddd | this.Load 외 1 | FDM0007_MemoDownPopup.cs:407 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FDM0007_MemoDownPopup.Find_Data_Memo

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / popSql.OnSql [else of (programID == "PR_UI_FDM0007_MEMODOWN_SELECT") ▸ if (programID == "PR_UI_FDM0007_MEMO_LIST")] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06e66c32 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:521 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL") ⇒ FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-44b9a817 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:522 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-3a01a9bb | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:523 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MEMO" | 행/컬럼 값 대입 |  |  |  |
| AC-84636b2f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:524 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-716b8d01 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:525 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ce390ec | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:527 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["p_instance_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-b8d6180c | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:528 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-6b571693 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:529 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-6710ccaf | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:530 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-0a5ba95f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:531 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-c6d10003 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:532 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-0500095a | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:533 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-099d3df6 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:534 | try | DATA_OP | request.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-27b107c3 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:535 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-a7bc3783 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:536 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["p_nick_name"] | 행/컬럼 값 대입 |  |  |  |
| AC-a04c8a41 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:537 | try | DATA_OP | request.Parameters["p_chk_total_include"] | Filter["p_chk_total_include"] | 행/컬럼 값 대입 |  |  |  |
| AC-2fb2d798 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:538 | try | DATA_OP | request.Parameters["p_pp_option"] | Filter["p_pp_option"] | 행/컬럼 값 대입 |  |  |  |
| AC-d0fe1b03 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:539 | try | DATA_OP | request.Parameters["p_curr_week"] | Filter["p_curr_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-c3bff666 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:540 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | Filter["p_bucket_from_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-68f7bc27 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:541 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | Filter["p_bucket_to_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-97a3d998 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:542 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | Filter["p_bucket_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-c3953fc4 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:543 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | Filter["p_bucket_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-98528c16 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:544 | try | DATA_OP | request.Parameters["p_plan_from_week"] | Filter["p_plan_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-fcf900d5 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:545 | try | DATA_OP | request.Parameters["p_plan_to_week"] | Filter["p_plan_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-cef4410a | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:546 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["p_week_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-6e62eb09 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:547 | try | DATA_OP | request.Parameters["p_month_week_column"] | Filter["p_month_week_column"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce3aa0a2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:548 | try | DATA_OP | request.Parameters["p_month_column_info"] | Filter["p_month_column_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1cc9379 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:549 | try | DATA_OP | request.Parameters["p_plan_week_Info"] | Filter["p_plan_week_Info"] | 행/컬럼 값 대입 |  |  |  |
| AC-6eee9ca1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:551 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77a24837 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:553 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-009a9981 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 2 | FDM0007_MemoDownPopup.cs:558 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.Find_Data_MemoDown

진입점: this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FDM0007_MEMODOWN_SELECT")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75b71b22 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:474 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL") ⇒ FP_Master.PR_UI_FDM0007_DEMAND_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-46b249a0 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:475 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-389f7979 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:476 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MEMO_DOWN" | 행/컬럼 값 대입 |  |  |  |
| AC-3cf303af | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:477 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2b054f01 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:478 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0075fe8e | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:480 | try | DATA_OP | request.Parameters["p_instance_id"] | Filter["p_instance_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-411d81ae | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:481 | try | DATA_OP | request.Parameters["p_site_id"] | Filter["p_site_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-502480d1 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:482 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter["p_plant_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-2422d44d | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:483 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter["p_factory_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-9215bc7b | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:484 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter["p_operation_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-e41fd336 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:485 | try | DATA_OP | request.Parameters["p_line_id"] | Filter["p_line_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-bee3525b | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:486 | try | DATA_OP | request.Parameters["p_prod_type"] | Filter["p_prod_type"] | 행/컬럼 값 대입 |  |  |  |
| AC-7739341d | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:487 | try | DATA_OP | request.Parameters["p_model_id"] | Filter["p_model_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-950ae0c7 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:488 | try | DATA_OP | request.Parameters["p_item_id"] | Filter["p_item_id"] | 행/컬럼 값 대입 |  |  |  |
| AC-caba601d | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:489 | try | DATA_OP | request.Parameters["p_nick_name"] | Filter["p_nick_name"] | 행/컬럼 값 대입 |  |  |  |
| AC-74a9c7aa | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:490 | try | DATA_OP | request.Parameters["p_chk_total_include"] | Filter["p_chk_total_include"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1635919 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:491 | try | DATA_OP | request.Parameters["p_pp_option"] | Filter["p_pp_option"] | 행/컬럼 값 대입 |  |  |  |
| AC-1439171e | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:492 | try | DATA_OP | request.Parameters["p_curr_week"] | Filter["p_curr_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-24fc701a | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:493 | try | DATA_OP | request.Parameters["p_bucket_from_date"] | Filter["p_bucket_from_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-8f250db3 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:494 | try | DATA_OP | request.Parameters["p_bucket_to_date"] | Filter["p_bucket_to_date"] | 행/컬럼 값 대입 |  |  |  |
| AC-f27a1032 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:495 | try | DATA_OP | request.Parameters["p_bucket_from_week"] | Filter["p_bucket_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-e4b61f88 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:496 | try | DATA_OP | request.Parameters["p_bucket_to_week"] | Filter["p_bucket_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-42df42c4 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:497 | try | DATA_OP | request.Parameters["p_plan_from_week"] | Filter["p_plan_from_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-afaa9c1a | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:498 | try | DATA_OP | request.Parameters["p_plan_to_week"] | Filter["p_plan_to_week"] | 행/컬럼 값 대입 |  |  |  |
| AC-30192c54 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:499 | try | DATA_OP | request.Parameters["p_week_info"] | Filter["p_week_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-55d3e922 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:500 | try | DATA_OP | request.Parameters["p_month_week_column"] | Filter["p_month_week_column"] | 행/컬럼 값 대입 |  |  |  |
| AC-24b252e4 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:501 | try | DATA_OP | request.Parameters["p_month_column_info"] | Filter["p_month_column_info"] | 행/컬럼 값 대입 |  |  |  |
| AC-54a80064 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:502 | try | DATA_OP | request.Parameters["p_plan_week_Info"] | Filter["p_plan_week_Info"] | 행/컬럼 값 대입 |  |  |  |
| AC-529726c2 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:504 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2dceb943 | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:506 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3fa7bd3a | this.Load [try ▸ lambda] 외 2 | FDM0007_MemoDownPopup.cs:511 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-defbc2c9 | FindButton | FDM0007_MemoDownPopup.cs:273 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |

## FDM0007_MemoDownPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-352613c6 | this.Load | FDM0007_MemoDownPopup.cs:126 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FDM0007_MemoDownPopup.GetMakeMeasure

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e1d8590 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:677 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-744389c2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:679 |  | DATA_OP | newrow["MEA_ID"] | "chk_week" | 행/컬럼 값 대입 |  |  |  |
| AC-0e900df1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:680 |  | DATA_OP | newrow["MEA_NAME"] | "Week" | 행/컬럼 값 대입 |  |  |  |
| AC-e667df61 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:681 |  | DATA_OP | newrow["MEA_VALUE"] | "true" | 행/컬럼 값 대입 |  |  |  |
| AC-dfb5b554 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:682 |  | DATA_OP | newrow["TYPE"] | "BUCKET" | 행/컬럼 값 대입 |  |  |  |
| AC-a7a13f5d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:683 |  | DATA_OP | newrow["FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0e35489e | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:684 |  | DATA_OP | newrow["MENU_ID"] | "FDM0007" | 행/컬럼 값 대입 |  |  |  |
| AC-f6258a03 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:685 |  | DATA_OP | newrow["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-c26db53c | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:688 |  | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-980fa1d4 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:689 |  | STATE_RESET | ds.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d00a60a8 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:690 |  | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fd20f18 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:702 | foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | ret.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa307086 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:705 |  | FLAG | measure | new MeasurePack(ret) | 화면 필드/플래그 변경 |  |  |  |
| AC-b105ab26 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (… 외 1 | FDM0007_MemoDownPopup.cs:706 |  | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |

## FDM0007_MemoDownPopup.GetToDay

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-428e94e8 | (진입점 미연결) | FDM0007_MemoDownPopup.cs:871 |  | RETURN | return sToDay; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d2b0a61 | this.Load | FDM0007_MemoDownPopup.cs:153 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-62c27e7f | this.Load | FDM0007_MemoDownPopup.cs:156 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-dddd14c5 | this.Load | FDM0007_MemoDownPopup.cs:160 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FDM0007_find_WeekCnt", Filter["p_bucket_from_date"], Filter["p_bucket_to… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f46a6326 | this.Load | FDM0007_MemoDownPopup.cs:162 | try | FLAG | weekInfo | dtWeekInfo.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-7adffbdf | this.Load | FDM0007_MemoDownPopup.cs:165 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-da738251 | this.Load | FDM0007_MemoDownPopup.cs:166 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a1f40d05 | this.Load | FDM0007_MemoDownPopup.cs:172 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-27adf9f3 | this.Load | FDM0007_MemoDownPopup.cs:173 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-62a10c65 | this.Load | FDM0007_MemoDownPopup.cs:174 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f50e7bf5 | this.Load | FDM0007_MemoDownPopup.cs:181 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_MemoDownPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7d66a4c | this.Load | FDM0007_MemoDownPopup.cs:216 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef657ba4 | this.Load | FDM0007_MemoDownPopup.cs:217 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-132356f3 | this.Load | FDM0007_MemoDownPopup.cs:221 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_MemoDownPopup.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21ca7ee4 | InsertButton | FDM0007_MemoDownPopup.cs:283 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f61f172 | InsertButton | FDM0007_MemoDownPopup.cs:284 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.RefreshHeader

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37fcc741 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:603 | if (weekInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-18334536 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:604 | if (weekInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-fc2efdec | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:612 | if (weekInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, FPExtensions.DateColumnType.TYPEZERO, FPExt… | ⚠ 의미 확인 필요 |  |  |  |
| AC-675a06ee | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:616 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-6dc442ad | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:621 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-58ba5257 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:626 | if (weekInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0088852f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:627 | if (weekInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-def756cb | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:630 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95d78714 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:631 | if (weekInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9da57f5d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:634 | if (weekInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-2c7c3eff | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:640 | if (weekInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c70b7ea2 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:659 | if (weekInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_it… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |

## FDM0007_MemoDownPopup.RefreshSpreadSheet

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26117d65 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:574 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-1aa57b06 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:585 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_MemoDownPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f52f1712 | popSql.OnSql | FDM0007_MemoDownPopup.cs:879 | if (programID == "PR_UI_FDM0007_MEMODOWN_SELECT") | RETURN | return Find_Data_MemoDown("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-446396e1 | popSql.OnSql | FDM0007_MemoDownPopup.cs:883 | else of (programID == "PR_UI_FDM0007_MEMODOWN_SELECT") ▸ if (programID == "PR_UI_FDM0007_MEMO_LIST") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-72360770 | popSql.OnSql | FDM0007_MemoDownPopup.cs:885 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3b81421 | SaveButton | FDM0007_MemoDownPopup.cs:307 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2b4de15 | SaveButton | FDM0007_MemoDownPopup.cs:308 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FDM0007_MemoDownPopup.SetColumnChangeByMemo

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ce11956 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:813 | try | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3ae7a12c | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:815 | try | FLAG | NumcellType | new FarPoint.Win.Spread.CellType.NumberCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-24eaa7ec | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:817 | try | UI_PROP | NumcellType.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-591f9e27 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:818 | try | UI_PROP | NumcellType.FixedPoint | false | 속성 FixedPoint 설정 |  |  |  |
| AC-ad36977d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:827 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, iColStartIndex, k, iColEndIndex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-d553fdb1 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:831 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ else of (sDataType == "DATA" && sCategoryDetail == "MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, iColStartIndex, k, iColEndIndex].CellType | NumcellType | 그리드 속성/값 설정 |  |  |  |
| AC-e81287ea | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:835 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f64e5783 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:842 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_MemoDownPopup.SetCombineMemo

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (weekInfo != null) ▸ if (added_columns_count == -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3842de74 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:730 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-d49ba515 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:731 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-86e5d124 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:742 | try ▸ foreach (AmendWeek a in calendar.Weeks.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-258068be | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:762 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1d34c98 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:763 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0820f1f | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:764 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1aa52029 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:765 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d5160d5 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:766 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a788e4fe | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:767 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-81e6bfce | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:768 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e692a155 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:769 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6bb3a6e | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:770 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6758100 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:771 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd7cf03 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:772 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ lambda | DATA_OP | each_row.Field | ("PLAN_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-de609bae | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:786 | try ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategoryDetail == "MEMO") ▸ if (result.Count() > 0) ▸ f… | DATA_OP | row[sColName] | result.First()[sChgColName] | 행/컬럼 값 대입 |  |  |  |
| AC-ffde7d9d | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try … 외 1 | FDM0007_MemoDownPopup.cs:798 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FDM0007_MemoDownPopup.SetHiddenColmn

진입점: this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c7e0129 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:254 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d421739b | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:255 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0ffae957 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:256 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f4040e6e | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:257 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d629a664 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:258 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-43eb5608 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:259 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_WEEK)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5b1b899c | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:260 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLAN_WEEK_ORDER)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a5bc231e | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:261 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DATA_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b397b978 | this.Load [try ▸ if (dsMain.Tables[0].Rows.Count > 0)] 외 1 | FDM0007_MemoDownPopup.cs:262 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_DETAIL_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FDM0007_MemoDownPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09fabfb8 | this.Load [try] | FDM0007_MemoDownPopup.cs:230 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c194606 | this.Load [try] | FDM0007_MemoDownPopup.cs:231 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-242fd73d | this.Load [try] | FDM0007_MemoDownPopup.cs:236 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-704e5fb4 | this.Load [try] | FDM0007_MemoDownPopup.cs:237 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLAN_WEEK)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7672ade | this.Load [try] | FDM0007_MemoDownPopup.cs:248 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.DATA_TYPE)… | 그리드 편집 잠금/해제 |  |  |  |

