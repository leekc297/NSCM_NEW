# AS-IS 액션 대조표 — FP00626

> 원천: `Doc/asisfacts/screens/FP00626/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 313행 · 메서드 52 · 종류 DATA_OP 70 · FLAG 46 · RETURN 27 · GRID_INIT 22 · GRID_SET 22 · UI_PROP 19 · COMBO_DATA 16 · STATE 13 · MESSAGE 12 · UI_MISC 11 · CALL_EXT 10 · VALUE_SET 9 · THROW 9 · LIST_REBIND 5 · GRID_BIND 4 · POPUP 3 · GRID_LOCK 3 · GRID_STYLE 3 · VALUE_CLEAR 2 · ENDPOINT 2 · STATE_RESET 2 · CALL_BASE 1 · FOCUS 1 · EXCEL 1 · ⚠ 의미 확인 필요 11


## FP00626_PancakeSimulation_Assy..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8219e540 | .ctor | FP00626_PancakeSimulation_Assy.cs:182 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00626_PancakeSimulation_Assy.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULATION_ASSY_SELECT") ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a65370d | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:614 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-18aa938a | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:615 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8c713954 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:616 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2f9f49d6 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:617 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1702f1be | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:618 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-674afee5 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:619 |  | FLAG | cateInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-54450522 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:621 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_DateMap", Filter["PLAN_DATE"].ToString(), Filter["BUCKET_FROM"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-710fd02e | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:622 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-66d5fa8b | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:624 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-878568ba | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:625 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-f4433b55 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:627 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_MonthCnt", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].To… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c422e59 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:628 |  | FLAG | monthInfo | dtMonth.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a69ad681 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:630 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_bukInfo", Filter["BUCKET_FROM"].ToString(), Filter["BUCKET_TO"].ToS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5b9880a0 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:631 |  | FLAG | bukInfo | dtBuk.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a1bee58f | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:634 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_measure", "FP00626_Main", UserInfoContext.Current.UserId) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3292b00 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:635 |  | FLAG | cateInfo | dtCategory.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b033aeec | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:648 |  | DATA_OP | Filter["DAY_INFO"] | s_date_info | 행/컬럼 값 대입 |  |  |  |
| AC-a6a96506 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:649 |  | DATA_OP | Filter["WEEK_INFO"] | s_week_info | 행/컬럼 값 대입 |  |  |  |
| AC-4915f33c | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:650 |  | DATA_OP | Filter["MONTH_INFO"] | s_month_info | 행/컬럼 값 대입 |  |  |  |
| AC-59a965ba | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:651 |  | DATA_OP | Filter["BUCKET"] | s_bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-caf61c39 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:652 |  | DATA_OP | Filter["CATE_INFO"] | s_cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00626_PancakeSimulation_Assy.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULATION_ASSY_SELECT") ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4983ff90 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:658 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; SetFilter("PLAN_ID", CString.GetChec… | ⚠ 의미 확인 필요 |  |  |  |
| AC-926baaca | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:667 | lambda | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b1da0f67 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:668 | lambda | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-144842f6 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:670 | lambda | DATA_OP | Filter["TOP_ITEM_ID"] | txtModel.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a81eed4d | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:671 | lambda | DATA_OP | Filter["MODEL_NICK_NAME"] | txtModelNickName.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9a55e974 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:672 | lambda | DATA_OP | Filter["ITEM_ID"] | txtItem.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-19974a08 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:673 | lambda | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8e25a75 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:686 | lambda ▸ if (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-8704b35a | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:688 | lambda ▸ else of (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-580918df | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:691 | lambda ▸ if (chktotalinclude.Checked == true) | DATA_OP | Filter["TOTAL_INCLUDE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f3f81cae | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:693 | lambda ▸ else of (chktotalinclude.Checked == true) | DATA_OP | Filter["TOTAL_INCLUDE"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b60d1c29 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:695 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00626_PancakeSimulation_Assy.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-642f3836 | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1763 |  | STATE | infoPanel.Visible | !infoPanel.Visible | 컨트롤 상태 Visible |  |  |  |
| AC-f1c7c984 | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1767 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-e3a99d4d | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1768 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e68b492f | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1772 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_planInfo_P", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filt… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd20f67a | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1778 | if (dtPlanInfo != null) | GRID_INIT | siSub.ColumnHeaderHeight | (0, 30) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddc11f6c | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1779 | if (dtPlanInfo != null) | CALL_EXT | siSub.SetRightMerge | (siSub.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8687055 | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1781 | if (dtPlanInfo != null) | GRID_BIND | siSub.Query | (dtPlanInfo.DataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b9159810 | this.btnPlanInfo.Click | FP00626_PancakeSimulation_Assy.cs:1786 |  | UI_PROP | infoPanel.Location | new Point((this.ClientSize.Width / 2 - infoPanel.Size.Width / 2) + 200, btnPlanInfo.Locati… | 속성 Location 설정 |  |  |  |

## FP00626_PancakeSimulation_Assy.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18862445 | this.btnSql.Click | FP00626_PancakeSimulation_Assy.cs:1799 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-4f20c995 | this.btnSql.Click | FP00626_PancakeSimulation_Assy.cs:1802 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fc2c8303 | this.btnSql.Click | FP00626_PancakeSimulation_Assy.cs:1803 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-214ab3fc | this.btnSql.Click | FP00626_PancakeSimulation_Assy.cs:1805 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00626_PANCAKESIMULATION_ASSY_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b512c508 | this.btnSql.Click | FP00626_PancakeSimulation_Assy.cs:1807 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00626_PancakeSimulation_Assy.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1e41475 | this.button1.Click | FP00626_PancakeSimulation_Assy.cs:1791 |  | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00626_PancakeSimulation_Assy.cbo_plan_group_changed

진입점: cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca91d505 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1520 |  | STATE | chk_release.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8113e699 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1521 |  | STATE | cbo_planid.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1468a163 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1523 |  | FLAG | dtIsPast | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00626_find_isPast", sInstance_id… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-7c9f17cf | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1523 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_isPast", sInstance_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1171a905 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1542 | if (chk_release.Checked == true) | VALUE_CLEAR | cbo_planid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-969b8dab | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1543 | if (chk_release.Checked == true) | STATE | cbo_planid.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ee8d6a07 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1545 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-94c0832c | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1546 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42b382d8 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1547 | if (chk_release.Checked == true) | DATA_OP | Filter["DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fb95ba9e | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1548 | if (chk_release.Checked == true) | DATA_OP | Filter["READ_ONLY"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8ffaad61 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1549 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c2b1a7c | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1551 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_DATE"] | dtIsPast.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c179c779 | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1552 | if (chk_release.Checked == true) | DATA_OP | Filter["BUCKET_FROM"] | dtIsPast.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5c2f8a0f | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1560 | if (chk_release.Checked == true) | VALUE_SET | sCalendar_planday.DateTime | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-42d7bcbd | cbo_plan_group.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1561 | if (chk_release.Checked == true) | STATE | sCalendar_planday.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00626_PancakeSimulation_Assy.cbo_planid_changed

진입점: cbo_planid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6772b32c | cbo_planid.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1609 |  | FLAG | _sCurrPlanId | sPlan_id | 화면 필드/플래그 변경 |  |  |  |
| AC-73f65ec7 | cbo_planid.SelectedIndexChanged | FP00626_PancakeSimulation_Assy.cs:1615 | if (dtPlanId != null) ▸ if (dtPlanId.Rows.Count > 0) ▸ if (chk_release.Checked == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.CheckAndGetMeasure

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9dba304 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1038 |  | FLAG | measure | GetMeasure_Local(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-2986fb0d | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1042 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-91645951 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1043 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f1a7c1b8 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1044 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-87133409 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1045 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-e9e96bd8 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1046 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-cec0d02a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1047 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00626_PancakeSimulation_Assy.chk_release_CheckedChanged

진입점: this.chk_release.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1c3733f | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1646 | if (chk_release.Checked == true) | VALUE_SET | sCalendar_planday.DateTime | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-2574910a | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1647 | if (chk_release.Checked == true) | STATE | sCalendar_planday.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6277d3ee | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1649 | if (chk_release.Checked == true) | VALUE_CLEAR | cbo_planid.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-b63df190 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1650 | if (chk_release.Checked == true) | STATE | cbo_planid.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e49546be | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1652 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51a248cb | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1653 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c1f5330e | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1654 | if (chk_release.Checked == true) | DATA_OP | Filter["DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-586ba0f8 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1655 | if (chk_release.Checked == true) | DATA_OP | Filter["READ_ONLY"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bf76ff22 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1656 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fa8fb23d | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1661 | if (chk_release.Checked == true) | DATA_OP | Filter["CURR_DATE"] | dtIsPast.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-174d1bf7 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1662 | if (chk_release.Checked == true) | DATA_OP | Filter["PLAN_DATE"] | dtIsPast.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a76f9b5f | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1663 | if (chk_release.Checked == true) | DATA_OP | Filter["BUCKET_FROM"] | dtIsPast.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3df95288 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1664 | if (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-ddceedb4 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1667 | if (chk_release.Checked == true) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-2013d5dc | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1669 | if (chk_release.Checked == true) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-3459caf5 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1675 | else of (chk_release.Checked == true) | DATA_OP | Filter["RELEASE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-9fe11837 | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1676 | else of (chk_release.Checked == true) | STATE | cbo_planid.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c58b76bd | this.chk_release.CheckedChanged | FP00626_PancakeSimulation_Assy.cs:1677 | else of (chk_release.Checked == true) | STATE | sCalendar_planday.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00626_PancakeSimulation_Assy.CreateFilterDataSet

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ded171b2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:954 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-078d9ff0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:966 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-75b7d73d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:967 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-83d2b166 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:978 | if (measure["chk_assy"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "ASSY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-40f68be2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:982 | if (measure["chk_post"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "POST")) | 데이터 객체 조작/조회 |  |  |  |
| AC-36be5609 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:986 | if (measure["chk_coater"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "COATER")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac33f8e8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:990 | if (measure["chk_shipment"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e16eac8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:994 | if (measure["chk_shipmentIn"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SHIP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-430c0802 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:998 | if (measure["chk_inv"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "INV")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7601fe82 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1004 | if (chktotalinclude.Checked == true) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "ASSY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4223514 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1005 | if (chktotalinclude.Checked == true) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "POST")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5ea261b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1006 | if (chktotalinclude.Checked == true) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "COATER")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d6521a5 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1007 | if (chktotalinclude.Checked == true) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8832f46b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1008 | if (chktotalinclude.Checked == true) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SHIP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-003c87f4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1009 | if (chktotalinclude.Checked == true) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "INV")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3beba168 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1013 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5561794 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1020 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-cdb705fc | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1025 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f7854bba | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1029 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-886f29e2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1031 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3bc5f31 | this.Load | FP00626_PancakeSimulation_Assy.cs:296 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e417fc45 | this.Load | FP00626_PancakeSimulation_Assy.cs:297 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1fbb7c8 | this.Load | FP00626_PancakeSimulation_Assy.cs:298 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-144b7e0a | this.Load | FP00626_PancakeSimulation_Assy.cs:302 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3cd122ac | this.Load | FP00626_PancakeSimulation_Assy.cs:303 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-3274b0d8 | this.Load | FP00626_PancakeSimulation_Assy.cs:304 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00626_PancakeSimulation_Assy.dCalendarPlanrange_changed

진입점: dCalendar_planrange.ValueChanged / this.dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1843366a | dCalendar_planrange.ValueChanged 외 1 | FP00626_PancakeSimulation_Assy.cs:1708 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bda38395 | dCalendar_planrange.ValueChanged 외 1 | FP00626_PancakeSimulation_Assy.cs:1712 | try ▸ if (Convert.ToDecimal(arrRetStart) < Convert.ToDecimal("20100101") \|\| Convert.ToDecimal(arrRetEnd) < Convert.ToDecimal("2010…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f098a7b6 | dCalendar_planrange.ValueChanged 외 1 | FP00626_PancakeSimulation_Assy.cs:1716 | try ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date.") | 메시지 표시 |  |  |  |
| AC-fd3648a8 | dCalendar_planrange.ValueChanged 외 1 | FP00626_PancakeSimulation_Assy.cs:1717 | try ▸ if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-6c21e4dd | dCalendar_planrange.ValueChanged 외 1 | FP00626_PancakeSimulation_Assy.cs:1723 | try ▸ if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-a34db151 | dCalendar_planrange.ValueChanged 외 1 | FP00626_PancakeSimulation_Assy.cs:1724 | try ▸ if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-80c1bf2c | dCalendar_planrange.ValueChanged 외 1 | FP00626_PancakeSimulation_Assy.cs:1731 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00626_PancakeSimulation_Assy.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65e7b300 | DeleteButton | FP00626_PancakeSimulation_Assy.cs:429 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-580b6011 | DeleteButton | FP00626_PancakeSimulation_Assy.cs:430 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10d6fab6 | Dispose | FP00626_PancakeSimulation_Assy.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00626_PancakeSimulation_Assy.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62af9773 | EditButton | FP00626_PancakeSimulation_Assy.cs:436 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd969070 | EditButton | FP00626_PancakeSimulation_Assy.cs:437 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-692a4970 | ExcelButton | FP00626_PancakeSimulation_Assy.cs:455 |  | FOCUS | siMain.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-c19311a0 | ExcelButton | FP00626_PancakeSimulation_Assy.cs:456 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00626_PancakeSimulation_Assy.Find_Data

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9902dcb | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:467 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9dcbc6c0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:473 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-09d633df | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:474 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b464fdc | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:477 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-64155b3c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:481 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-33ba5d9b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:482 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c436fd1a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:485 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-10261c03 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:490 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-635e530d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:497 | try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-25396479 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:497 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2baf4736 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:506 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b74020f0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:517 | try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-84881e09 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:521 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-04d3f436 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:523 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-810480f8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:525 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-dd6c2e76 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:528 | try ▸ if (dsMain != null) | VALUE_SET | lblPlanID.Text | "Coater Plan : " + Filter["PLAN_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-57bd0558 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:537 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc0a1e42 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:542 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7f0f813c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:543 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7675af1a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:544 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00626_PancakeSimulation_Assy.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULATION_ASSY_SELECT")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0c003f8 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:565 | try ▸ if (chk_release.Checked == false) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_chk_PlanId", Filter["INSTANCE_ID"], Filter["PLAN_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d31138f | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:569 | try ▸ if (chk_release.Checked == false) ▸ if (dtChkPlan.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Coater Plan release version exists.\nDo you want to include it?", "Question", MessageBox… | 메시지 표시 |  |  |  |
| AC-75ffdf49 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:571 | try ▸ if (chk_release.Checked == false) ▸ if (dtChkPlan.Rows.Count > 0) ▸ if (MessageBox.Show("Coater Plan release version exists.\nDo you w… | DATA_OP | Filter["CHK_PLANID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0d6c3ea2 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:575 | try ▸ if (chk_release.Checked == false) ▸ if (dtChkPlan.Rows.Count > 0) ▸ else of (MessageBox.Show("Coater Plan release version exists.\nDo … | DATA_OP | Filter["CHK_PLANID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-ab101696 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:580 | try ▸ if (chk_release.Checked == false) ▸ else of (dtChkPlan.Rows.Count > 0) | DATA_OP | Filter["CHK_PLANID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-41cfd43b | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:585 | try ▸ else of (chk_release.Checked == false) | DATA_OP | Filter["CHK_PLANID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-41b3ec1f | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:597 | try ▸ if (chk_release.Checked == false) ▸ if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "PLAN ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-87a685a2 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:598 | try ▸ if (chk_release.Checked == false) ▸ if (string.IsNullOrEmpty(Filter["PLAN_ID"].ToString())) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-cbc8c8f1 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:602 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00626_PANCAKESIMULATION_ASSY", Filter, _CurrentUser, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bbc12138 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:604 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-e3a8e7b2 | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:608 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b739a8bd | FindButton | FP00626_PancakeSimulation_Assy.cs:410 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00626_PancakeSimulation_Assy.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0dfe7d8 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 1 | FP00626_PancakeSimulation_Assy.cs:948 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-545868fd | this.Load | FP00626_PancakeSimulation_Assy.cs:193 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00626_PancakeSimulation_Assy.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULATION_ASSY_SELECT") ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-774a3e8d | popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULAT… 외 1 | FP00626_PancakeSimulation_Assy.cs:1851 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.GetFpPlanInfo

진입점: cbo_plan_group.SelectedIndexChanged / this.chk_release.CheckedChanged [else of (chk_release.Checked == true)] / this.sCalendar_planday.EditValueChanged [try ▸ else of (Convert.ToDecimal(sChangeDate) > Convert.ToDecimal(GetToDay())) ▸ else of (chk_release.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47d2d34a | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:1879 |  | FLAG | dtPlanId | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00626_findFpPlan_info", sInstanc… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-166acca9 | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:1879 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_findFpPlan_info", sInstance, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2915bde | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:1880 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_planid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-36de7942 | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:1895 | if (dtPlanId != null) ▸ if (!string.IsNullOrEmpty(_sCurrPlanId)) ▸ if (dtPlanId.Rows.Count > 0) ▸ for (i < dtPlanId.Rows.Count) ▸ if (_sCurr… | VALUE_SET | cbo_planid.SelectedValue | dtPlanId.Rows[idx]["PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9eb5d185 | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:1905 | if (dtPlanId != null) ▸ else of (!string.IsNullOrEmpty(_sCurrPlanId)) ▸ if (dtPlanId.Rows.Count > 0) | VALUE_SET | cbo_planid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00626_PancakeSimulation_Assy.GetMeasure_Local

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ if (measure == null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80cbc52a | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1064 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_measure", menu_id, user_id) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf464fe3 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1067 | try ▸ if (measure == null \|\| measure.Tables == null \|\| measure.Tables.Count < 1 \|\| measure.Tables[0].Rows.Count < 1) | RETURN | return new MeasurePack(ret); |  | 처리 중단/반환 |  |  |  |
| AC-20df1e6c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1080 | try ▸ foreach (DataRow row in measure.Tables[0].Rows) | DATA_OP | ret.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cf913d1 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1082 | try | RETURN | return new MeasurePack(ret); |  | 처리 중단/반환 |  |  |  |
| AC-9733c049 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 2 | FP00626_PancakeSimulation_Assy.cs:1086 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00626_PancakeSimulation_Assy.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd79813d | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:2189 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-f357ba81 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:2190 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.GetToDay

진입점: this.sCalendar_planday.EditValueChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c52e2df | this.sCalendar_planday.EditValueChanged [try] | FP00626_PancakeSimulation_Assy.cs:2150 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-3e94b3bc | this.sCalendar_planday.EditValueChanged [try] | FP00626_PancakeSimulation_Assy.cs:2151 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-471261c9 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1093 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-252e6854 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1095 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f53933d1 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1158 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-549cc7ed | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1159 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-f5ff130c | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1235 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00626_PancakeSimulation_Assy.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf564cf7 | this.Load | FP00626_PancakeSimulation_Assy.cs:233 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5dd2f6c2 | this.Load | FP00626_PancakeSimulation_Assy.cs:236 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanAmendMA) | 데이터 객체 조작/조회 |  |  |  |
| AC-71822cbe | this.Load | FP00626_PancakeSimulation_Assy.cs:238 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e79464be | this.Load | FP00626_PancakeSimulation_Assy.cs:239 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a4200114 | this.Load | FP00626_PancakeSimulation_Assy.cs:242 | try | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fc38ef8 | this.Load | FP00626_PancakeSimulation_Assy.cs:244 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6387323b | this.Load | FP00626_PancakeSimulation_Assy.cs:250 | try ▸ if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-5841d278 | this.Load | FP00626_PancakeSimulation_Assy.cs:259 | try | VALUE_SET | cbo_unit.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-17060e1d | this.Load | FP00626_PancakeSimulation_Assy.cs:267 | try | STATE | infoPanel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2b95896b | this.Load | FP00626_PancakeSimulation_Assy.cs:272 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-adf74550 | this.Load | FP00626_PancakeSimulation_Assy.cs:273 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9e41f0bb | this.Load | FP00626_PancakeSimulation_Assy.cs:274 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-cd9267db | this.Load | FP00626_PancakeSimulation_Assy.cs:280 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00626_PancakeSimulation_Assy.InitEditingBuf

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a1462f6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:2156 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9d6ce2d0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:2157 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-e53e07b8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:2158 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2935f5c5 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:2159 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f5abae88 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:2160 |  | FLAG | UOMRate | 1 | 화면 필드/플래그 변경 |  |  |  |

## FP00626_PancakeSimulation_Assy.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d68e691f | this.Load | FP00626_PancakeSimulation_Assy.cs:316 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d711c1cc | this.Load | FP00626_PancakeSimulation_Assy.cs:317 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8dc6628d | this.Load | FP00626_PancakeSimulation_Assy.cs:325 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-8070e409 | this.Load | FP00626_PancakeSimulation_Assy.cs:334 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c7e6fe31 | this.Load | FP00626_PancakeSimulation_Assy.cs:337 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-055bc3ff | this.Load | FP00626_PancakeSimulation_Assy.cs:339 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6b607dfc | this.Load | FP00626_PancakeSimulation_Assy.cs:345 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00626_PancakeSimulation_Assy.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1f0efc6 | InsertButton | FP00626_PancakeSimulation_Assy.cs:421 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a450fc8 | InsertButton | FP00626_PancakeSimulation_Assy.cs:422 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ca49e92 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:767 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-bb9b0db5 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:768 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6cca29d5 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:769 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a59e2c7a | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:770 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-0df6dc0b | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:783 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, DateColumnType.TYPEZERO, DateColumnType.TYP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bda6f698 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:786 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-cbb77517 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:790 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-671f82ef | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:792 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39cc4640 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:794 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-206b43d4 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:799 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d2ad5fa | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:800 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8414ef62 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:802 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b7f52c5 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:803 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ff16e18 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:805 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5de5f8cf | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:807 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f87eb570 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:812 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9251d4fe | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:833 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if ((CATEGORY_ID == "INV" \|\… | GRID_STYLE | siMain.SetBGColor3 | (line, iFixCol, line, end, System.Drawing.Color.FromArgb(230, 250, 190)) | 그리드 표시 설정 |  |  |  |
| AC-7ed6c680 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:861 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, end, tmp) | 그리드 표시 설정 |  |  |  |
| AC-1f738d49 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:882 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3fd8740 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:886 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-06bf52f0 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:888 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-29350b57 | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:892 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ddd54f5f | this.Load [try ▸ else of (monthInfo == null)] 외 1 | FP00626_PancakeSimulation_Assy.cs:930 | if (monthInfo != null) | UI_MISC | spdMain.Refresh | () | 화면 갱신/대기창 |  |  |  |

## FP00626_PancakeSimulation_Assy.RefreshHeaderOnly

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fe21f90 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:386 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-d7911cc8 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:387 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("CATEGORY_NAME") | 그리드 속성/값 설정 |  |  |  |
| AC-7f62f673 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:388 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a046d22 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:389 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e89479a | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:390 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20471975 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:397 |  | UI_PROP | spdMain.HorizontalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-8818c0ff | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:398 |  | UI_PROP | spdMain.VerticalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 VerticalScrollBarPolicy 설정 |  |  |  |

## FP00626_PancakeSimulation_Assy.RefreshSpreadSheet

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93a2cac8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:712 | if (measure == null) | FLAG | measure | GetMeasure_Local(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9ed7f8a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:721 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb012e99 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:728 | try ▸ if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e5d6b754 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:748 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00626_PancakeSimulation_Assy.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57aea440 | popSql.OnSql | FP00626_PancakeSimulation_Assy.cs:2168 | if (programID == "PR_UI_FP00626_PANCAKESIMULATION_ASSY_SELECT") | RETURN | return Find_Data_Amend("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-199ef7e6 | popSql.OnSql | FP00626_PancakeSimulation_Assy.cs:2171 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f71b7ce | SaveButton | FP00626_PancakeSimulation_Assy.cs:443 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0ce983d | SaveButton | FP00626_PancakeSimulation_Assy.cs:444 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00626_PancakeSimulation_Assy.sCalendar_planday_EditValueChanged

진입점: this.sCalendar_planday.EditValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e742c1c3 | this.sCalendar_planday.EditValueChanged | FP00626_PancakeSimulation_Assy.cs:1578 | try ▸ if (Convert.ToDecimal(sChangeDate) > Convert.ToDecimal(GetToDay())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5fd480c4 | this.sCalendar_planday.EditValueChanged | FP00626_PancakeSimulation_Assy.cs:1580 | try ▸ if (Convert.ToDecimal(sChangeDate) > Convert.ToDecimal(GetToDay())) | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-7ae28050 | this.sCalendar_planday.EditValueChanged | FP00626_PancakeSimulation_Assy.cs:1599 | catch ((Exception)) | THROW | throw ; |  | 예외 발생 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetCalcInventory

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good()) ▸ while (nRow < dsMain.Tables[0].Rows.Count) ▸ if (bIsCurr)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1de304d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1431 | if (sStartDate == sStartDate_Area) ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1cc6aab | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1457 | if (sStartDate == sStartDate_Area) | GRID_SET | siMain.SetValue | (nRow_Invt, siMain.GetColumnIndex(sColTmp), nInvt) | 그리드 값 설정 |  |  |  |
| AC-612c7e27 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1476 | while (nColTmp <= nEndTmp) ▸ lambda | DATA_OP | each_row.Field | ("D_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1eacd7d6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1503 | while (nColTmp <= nEndTmp) | GRID_SET | siMain.SetValue | (nRow_Invt, siMain.GetColumnIndex(sColTmp), nInvt) | 그리드 값 설정 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetCellType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e91c7391 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2066 |  | FLAG | dtCellType | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00626_find_cellType") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d2cb1ecb | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2066 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_cellType") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1890e772 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2067 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellType, cbo_celltype, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetColumnChangeByMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53a2302c | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1252 | try ▸ if (iColStartIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e58c8565 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1270 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") | FLAG | GnlcellType | new FarPoint.Win.Spread.CellType.GeneralCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e91668b | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1273 | try ▸ for (k < dsResult.Tables[0].Rows.Count) ▸ if (sDataType == "DATA" && sCategory == "P_MEMO") | GRID_SET | siMain.ActiveSheet.Cells[k, iColStartIndex, k, iColEndIndex].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |
| AC-ad65f124 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1278 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d3be2b55 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:1285 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetColumnHidden

진입점: this.Load [try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25eefa1c | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:365 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-00a81919 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:366 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-09564b92 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:367 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.CATEGORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-94bb28e6 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:368 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ITEM_UOM)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3c5b4045 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:369 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DATA_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-319e08b2 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:371 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PREV_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7115ad66 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:372 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.POST_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-24eaffe6 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:373 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a67e209c | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:374 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-db5d8f76 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:375 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_BOH_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8063d4c6 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:376 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.HOLD_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-94c0cf6b | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:377 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PC_HOLD_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cbba8ecc | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:378 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.JR_HOLD_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetCurrPlanDate_Default

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97001854 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:2033 | try | FLAG | dtIsPast | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00626_find_isPast", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-25405dd8 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:2033 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_isPast", sInstance) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d79e0e4a | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:2046 | try ▸ if (dtIsPast != null) ▸ if (dtIsPast.Rows.Count > 0) | VALUE_SET | sCalendar_planday.DateTime | dPlanDate | 컨트롤 값 설정 |  |  |  |
| AC-1e498511 | this.Load [try] 외 1 | FP00626_PancakeSimulation_Assy.cs:2060 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetFilter

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (dtIsPast != null)] / cbo_planid.SelectedIndexChanged [if (dtPlanId != null) ▸ if (dtPlanId.Rows.Count > 0)] / cbo_celltype.SelectedIndexChanged / cbo_pancaketype.SelectedIndexChanged / cbo_unit.SelectedIndexChanged / txtModel.TextChanged / txtModelNickName.TextChanged / txtNickName.TextChanged / txtItem.TextChanged / chktotalinclude.CheckedChanged / popSql.OnSql [if (programID == "PR_UI_FP00626_PANCAKESIMULATION_ASSY_SELECT") ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.chk_release.CheckedChanged [else of (chk_release.Checked ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e546d04 | this.Load [try] 외 17 | FP00626_PancakeSimulation_Assy.cs:1846 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetFpPlanFilterInit

진입점: cbo_plan_group.SelectedIndexChanged / this.chk_release.CheckedChanged [else of (chk_release.Checked == true)] / this.sCalendar_planday.EditValueChanged [try ▸ else of (Convert.ToDecimal(sChangeDate) > Convert.ToDecimal(GetToDay())) ▸ else of (chk_release.Checked == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bc9ccac | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:2003 |  | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-41847c7b | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:2010 | if (string.IsNullOrEmpty(sEnd)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-e277b659 | cbo_plan_group.SelectedIndexChanged 외 2 | FP00626_PancakeSimulation_Assy.cs:2018 | else of (string.IsNullOrEmpty(sEnd)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetPancakeType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1c9b9be | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2075 |  | FLAG | dtPancakeType | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00626_find_pancakeType") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-18cbba3e | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2075 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_pancakeType") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c730234 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2076 |  | LIST_REBIND | clsCtrl.setListBox | (dtPancakeType, cbo_pancaketype, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f68ed7e5 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:1856 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00626_findInstanceList_common", … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d419345c | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:1856 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_findInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4d1fb68 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:1857 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetPlanPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d24b303d | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:2118 | if (string.IsNullOrEmpty(sStart)) | DATA_OP | Filter["SITE_ID"] | "A001" | 행/컬럼 값 대입 |  |  |  |
| AC-e188a309 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:2119 | if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-4d7e6a57 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:2120 | if (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-3101575b | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:2130 | else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-1b4bce34 | (진입점 미연결) | FP00626_PancakeSimulation_Assy.cs:2131 | else of (string.IsNullOrEmpty(sStart)) | UI_PROP | dCalendar_planrange.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4393185b | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:355 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77110566 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:356 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetUnit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3983d044 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2137 |  | FLAG | dtUnit | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00626_find_Unit") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-159bf632 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2137 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00626_find_Unit") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-705fa7f9 | this.Load [try] | FP00626_PancakeSimulation_Assy.cs:2138 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnit, cbo_unit, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00626_PancakeSimulation_Assy.SetUpdateTotalValue

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null) ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ try ▸ if (dsMainFiltered.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9245cc6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1304 | if (dateMap.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("IS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b85dddd | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1306 | if (dateMap.Tables[0].Rows.Count > 0) | FLAG | dsDataMap | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-f670771a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1310 | if (dateMap.Tables[0].Rows.Count > 0) ▸ if (result1.Count() > 0) | DATA_OP | result1.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f0c68458 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1312 | if (dateMap.Tables[0].Rows.Count > 0) ▸ if (result1.Count() > 0) | STATE_RESET | dsDataMap.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-23f516e6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1313 | if (dateMap.Tables[0].Rows.Count > 0) ▸ if (result1.Count() > 0) | DATA_OP | dsDataMap.Tables.Add | (dtResult1) | 데이터 객체 조작/조회 |  |  |  |
| AC-837848c6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1322 | if (dateMap.Tables[0].Rows.Count > 0) ▸ lambda | DATA_OP | each_row.Field | ("IS_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-59e12c2a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1327 | if (dateMap.Tables[0].Rows.Count > 0) ▸ if (result2.Count() > 0) | DATA_OP | result2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-69aaf70a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1329 | if (dateMap.Tables[0].Rows.Count > 0) ▸ if (result2.Count() > 0) | STATE_RESET | dsDataMap.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-56515008 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00626_PancakeSimulation_Assy.cs:1330 | if (dateMap.Tables[0].Rows.Count > 0) ▸ if (result2.Count() > 0) | DATA_OP | dsDataMap.Tables.Add | (dtResult2) | 데이터 객체 조작/조회 |  |  |  |

## FP00626_PancakeSimulation_Assy.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31851eff | this.spdMain.CellDoubleClick | FP00626_PancakeSimulation_Assy.cs:1822 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07f332d0 | this.spdMain.CellDoubleClick | FP00626_PancakeSimulation_Assy.cs:1827 | try ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-e149ab95 | this.spdMain.CellDoubleClick | FP00626_PancakeSimulation_Assy.cs:1834 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

