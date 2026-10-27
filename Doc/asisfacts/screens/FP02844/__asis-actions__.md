# AS-IS 액션 대조표 — FP02844

> 원천: `Doc/asisfacts/screens/FP02844/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 831행 · 메서드 89 · 종류 DATA_OP 302 · UI_PROP 95 · RETURN 77 · CALL_EXT 67 · FLAG 62 · UI_MISC 45 · GRID_SET 38 · VALUE_SET 29 · MESSAGE 21 · POPUP 20 · ENDPOINT 16 · GRID_INIT 15 · VALUE_CLEAR 10 · THROW 9 · LIST_REBIND 8 · COMBO_DATA 7 · GRID_LOCK 3 · FOCUS 2 · LIST_BIND 2 · CALL_BASE 2 · EXCEL 1 · ⚠ 의미 확인 필요 69


## FP02844_Plan_Elec_Post_WH_Load..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-594e1f6b | .ctor | FP02844_Plan_Elec_Post_WH_Load.cs:140 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-d086fcde | .ctor | FP02844_Plan_Elec_Post_WH_Load.cs:141 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844") ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecffe800 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2009 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-da29d7a5 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2010 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9f4b6e24 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2011 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dfa7ab1d | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2012 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-73e35d36 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2013 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-52676af1 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2014 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-934e0f2b | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2014 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d4658155 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2015 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-babd3c84 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2015 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b54582ee | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2016 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-0de885df | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2016 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-87744071 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2017 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-7d91c4be | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2017 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f63667a4 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2029 | if (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-e3259c83 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2031 | else of (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f62f4f13 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2032 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-a5f53124 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2033 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-37d0ff0b | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2034 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844") ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e6ae82c | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2046 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | LocalFilter["BUCKET_FROM"] | dCalendar_cutoff.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-256e8ce9 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2048 | else of (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | LocalFilter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9722c368 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2049 |  | DATA_OP | LocalFilter["BUCKET_TO"] | dCalendar_cutoff.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-7b4295a4 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:2054 |  | DATA_OP | LocalFilter["MASTER_ID"] | LocalFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.btnCatagory_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c31d8cff | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4394 |  | POPUP | new FP02844_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-cda40139 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4395 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-73401b09 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4396 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c5b96335 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4397 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0207a06b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4401 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-299fb7c2 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4413 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f322297a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4422 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4e04a11 | this.btn_column.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4372 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-96aab3ef | this.btn_column.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4373 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9b652d5b | this.btn_column.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4374 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50e9d287 | this.btn_column.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4381 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-fea0dd69 | this.btn_column.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4381 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab94284a | this.btn_column.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4382 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-a0f6f3ac | this.btn_column.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4388 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.btnMenu_Click

진입점: this.btnSetting.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-491f88ec | this.btnSetting.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4757 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnSetting, refPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-103212fb | this.btnSetting.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4757 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnSetting, refPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.btnMRP_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6069ab09 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4722 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-49a6eb43 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4724 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f0e98910 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4725 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0884f85f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4728 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-3e949b88 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4729 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c82f6b3d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4734 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-07cc813b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4735 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1290e5f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4740 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-0532e7d3 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4741 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9f12d04 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4745 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-15c91cd7 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4746 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f376dab0 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4747 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-45ab26af | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4748 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-2f064d8a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4750 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-174d598d | this.btnSql.Click | FP02844_Plan_Elec_Post_WH_Load.cs:1415 | if (true) | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4666145f | this.btnSql.Click | FP02844_Plan_Elec_Post_WH_Load.cs:1416 | if (true) | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-83a94956 | this.btnSql.Click | FP02844_Plan_Elec_Post_WH_Load.cs:1418 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP02844_FIND_FP02844") | 데이터 객체 조작/조회 |  |  |  |
| AC-68ba0584 | this.btnSql.Click | FP02844_Plan_Elec_Post_WH_Load.cs:1419 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP02844_FIND_FP02844B") | 데이터 객체 조작/조회 |  |  |  |
| AC-381cfa6c | this.btnSql.Click | FP02844_Plan_Elec_Post_WH_Load.cs:1420 | if (true) | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-661c2b8e | this.btnToggleSave.Click | FP02844_Plan_Elec_Post_WH_Load.cs:4431 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.button1_Click_1

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07b2df4f | this.button1.Click | FP02844_Plan_Elec_Post_WH_Load.cs:5277 |  | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.cbo_fpplanid_changed

진입점: cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ba63253 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4210 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-26b7680e | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4213 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-70673eb1 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4214 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3c6b8845 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4215 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2f0b32e3 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4216 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3f7e76d1 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4217 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-90367a8f | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4220 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b659ffd0 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4254 | if (dtPlanId.Good()) | UI_PROP | dCalendar_cutoff.Text2 | sUIEndTime | 속성 Text2 설정 |  |  |  |
| AC-fd9b7de8 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4273 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-f782a5b4 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4274 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-bad27918 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4275 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-db8d2290 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4276 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-8726f65f | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4277 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-e3e7ca65 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4284 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4e7acaf1 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4285 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-51341ca5 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4286 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b5ac6ca5 | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4287 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0faa1b8e | cbo_fpplanid.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4288 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.cbo_plan_group_changed

진입점: cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe80a2cb | cbo_plan_group.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4767 | if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | Filter["MASTER_ID"] = instance_id = CString.GetCheckedListValue(dtInstance, cbo_plan_group… | 행/컬럼 값 대입 |  |  |  |
| AC-b89d3704 | cbo_plan_group.SelectedIndexChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4767 | if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | instance_id = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-196130b3 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:532 | switch (measureId) default: ▸ if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad98de9a | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:532 | switch (measureId) default: ▸ if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.chk_info_CheckedChanged

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-748d4765 | this.chk_Info.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5263 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-f1cffc45 | this.chk_Info.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5263 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ae9c68f | this.chk_Info.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5269 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-64e2de61 | this.chk_Info.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5270 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.chk_omit_zero_CheckedChanged

진입점: chk_show_ref_data.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c1fb3f5 | chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4979 |  | FLAG | GRAPH_ROW_HEIGHT | (int)updownRow.Value | 화면 필드/플래그 변경 |  |  |  |
| AC-0ef3f4cc | chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4980 |  | FLAG | ShowLegend | cbShowLegend.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-62343c0a | chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4981 |  | FLAG | HorizontalLegend | cbHorizonalLegend.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-8d3534dc | chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4990 | if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7595f57d | chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4999 | else of (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.chk_show_ref_data_CheckedChanged

진입점: this.chk_show_ref_data.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f24a215 | this.chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5284 | if (chk_show_ref_data.Checked) | FLAG | flo | MenuFloater.GoPanel(this, chk_show_ref_data, refPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-517fd6df | this.chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5284 | if (chk_show_ref_data.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_show_ref_data, refPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4da6b2cf | this.chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5290 | else of (chk_show_ref_data.Checked) ▸ if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-2e401ecf | this.chk_show_ref_data.CheckedChanged | FP02844_Plan_Elec_Post_WH_Load.cs:5291 | else of (chk_show_ref_data.Checked) ▸ if (flo != null) | FOCUS | chk_show_ref_data.Focus | () | 포커스 이동 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1e3fd38 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3944 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-005484e0 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3946 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6c7951f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3947 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b590b181 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3948 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16efcdb6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3949 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-071e2d09 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3950 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d454f324 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3951 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b18eefc | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3952 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88dde3e8 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3953 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4d3afa9 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3954 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d0dd01a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3955 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9930dccb | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3956 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d361f1f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3957 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-81d6014f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3958 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1809f5e8 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3959 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d19ca3c8 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3960 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22a1a302 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3961 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-54ec63c0 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3962 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-55242afa | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3963 |  | DATA_OP | dt.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3154fb80 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3964 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d95461f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3965 |  | DATA_OP | dt.Columns.SafeAdd | ("BOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8d3d421 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3966 |  | DATA_OP | dt.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eece51ac | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3967 |  | DATA_OP | dt.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cf3b023 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3968 |  | DATA_OP | dt.Columns.SafeAdd | ("SALES_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-71c5f886 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3969 |  | DATA_OP | dt.Columns.SafeAdd | ("EOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ca6fe50 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3970 |  | DATA_OP | dt.Columns.SafeAdd | ("YIELD", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdb7ccb2 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3973 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f378b9f1 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3974 |  | DATA_OP | dt.Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf24a0ef | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3975 |  | DATA_OP | dt.Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-15a49b37 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3977 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bd3c047 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3978 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-620240ea | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3979 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6fd4e55 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3980 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef94996d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3982 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14fe839d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3983 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de318e03 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3984 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eb965e9 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3985 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a337a1d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3987 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-172367ae | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3988 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-562a40df | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3989 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eadfc43e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3990 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ec9d37a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3992 |  | DATA_OP | dt.Columns.SafeAdd | ("EIDX", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f30e6a29 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3993 |  | DATA_OP | dt.Columns.SafeAdd | ("EQTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5e94b98 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3994 |  | DATA_OP | dt.Columns.SafeAdd | ("EDATE", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18c19d9f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3996 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3325d77a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3997 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4e01e96 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4002 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a13fe9cd | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:4005 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.CreateEditDataGridDataSetTmp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39ea7565 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3829 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-1b79b16b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3831 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-338e670e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3832 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ac1c6e0 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3833 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-edd69366 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3834 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2ed23a2 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3835 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b8395c5 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3837 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a1eff67 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3839 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-23f38833 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3840 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-465b4be5 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3841 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cb4a4f6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3842 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1dfde2a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3843 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad16b644 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3844 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4aeb9615 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3845 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-01928113 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3846 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d31e2c93 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3848 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a924c1be | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3849 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-286cd558 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3850 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4339d8ee | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3851 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a79dfee3 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3852 |  | DATA_OP | dt.Columns.SafeAdd | ("IS_PREV_SCHEDULE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3241679a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3855 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca6424ca | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3856 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c49406e8 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3857 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d22881a5 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3858 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdbc3bb9 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3860 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-663e30a6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3861 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec68065 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3862 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-906978c0 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3863 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dfbe1e0 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3866 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b360063b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3867 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fb422b6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3868 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd1d2a2d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3869 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-796fac7a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3870 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e888ca8f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3872 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-feb05942 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3873 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1629c2b5 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3874 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e29ad27 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3875 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc919d58 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3876 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-245f9143 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3878 |  | DATA_OP | dt.Columns.SafeAdd | ("TOTAL_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae95497e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3880 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4720906 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3881 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d8bd7a9 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3882 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68bf60f4 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3883 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac9e03fe | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3884 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-48dc5471 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3886 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5db9a508 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3887 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a890d850 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3888 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e51fe1d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3889 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8464aeb | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3890 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18b2123d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3892 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e14a1f06 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3893 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22497811 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3894 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-92af6bca | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3895 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-96a0ee03 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3896 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fcd94d1 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3898 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-444c9314 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3899 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d757f2f5 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3900 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-299d512d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3901 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-831ee7ca | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3902 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec383d35 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3904 |  | DATA_OP | dt.Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fb3e7d6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3930 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ee78d9e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3931 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f0151b9 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3936 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-e68eacc3 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3939 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.CreateFilterDataSet

진입점: chk_show_ref_data.CheckedChanged [if (dsMain != null)] / cbHorizonalLegend.CheckedChanged [if (dsMain != null)] / cbShowLegend.CheckedChanged [if (dsMain != null)] / updownRow.ValueChanged [if (dsMain != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1701005e | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1435 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-25c3b50d | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1687 | if (calendar != null && dsMain.Tables[0].Rows.Count == 12) | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b929a80 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1694 | if (!ShowReference) ▸ lambda | DATA_OP | x.Field | ("ROW_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-72e7670a | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1698 | if (!ShowReference) ▸ if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0d858c5e | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1701 | if (!ShowReference) ▸ if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-45a4df3a | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1703 | if (!ShowReference) ▸ else of (t != null) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7c1fda49 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1703 | if (!ShowReference) ▸ else of (t != null) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-c627c0f8 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1704 | if (!ShowReference) | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |
| AC-6dd346d3 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1707 |  | DATA_OP | dsResult.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b752d8a8 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1708 |  | RETURN | return dsReturn; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee57f83d | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:486 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-308e6a69 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:487 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-681f485b | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:488 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.dCalendar_changed

진입점: dCalendar_cutoff.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a56db9b6 | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4319 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ab375c0 | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4325 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-736ed4ce | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4338 | if (arrRetStart != startDay) | CALL_EXT | DateTime.TryParseExact | (Filter["PLAN_DATE"],"yyyyMMdd",null, System.Globalization.DateTimeStyles.None, out sday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-128070fe | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4341 | if (arrRetStart != startDay) ▸ if (DateTime.TryParseExact(Filter["PLAN_DATE"],"yyyyMMdd",null, System.Globalization.DateTimeStyles.None, out… | UI_PROP | dCalendar_cutoff.Value1 | sday | 속성 Value1 설정 |  |  |  |
| AC-5d3314bf | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4342 | if (arrRetStart != startDay) ▸ if (DateTime.TryParseExact(Filter["PLAN_DATE"],"yyyyMMdd",null, System.Globalization.DateTimeStyles.None, out… | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fdd52b0b | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4346 |  | CALL_EXT | DateTime.TryParseExact | (maxEndDay, "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dEndDay) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25405189 | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4351 | if (DateTime.TryParseExact(maxEndDay, "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dEndDay)) ▸ if (dCalendar_cutoff.Value… | UI_PROP | dCalendar_cutoff.Value2 | dEndDay | 속성 Value2 설정 |  |  |  |
| AC-9047bd2a | dCalendar_cutoff.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4352 | if (DateTime.TryParseExact(maxEndDay, "yyyyMMdd", null, System.Globalization.DateTimeStyles.None, out dEndDay)) ▸ if (dCalendar_cutoff.Value… | DATA_OP | Filter["BUCKET_TO"] | maxEndDay | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0c8942b | Dispose | FP02844_Plan_Elec_Post_WH_Load.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.DrawHeader

진입점: this.Load / chk_show_ref_data.CheckedChanged [else of (dsMain != null)] / cbHorizonalLegend.CheckedChanged [else of (dsMain != null)] / cbShowLegend.CheckedChanged [else of (dsMain != null)] / updownRow.ValueChanged [else of (dsMain != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / FindButton […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-205d0713 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:611 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c6f193ce | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:615 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-6902be2a | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:616 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4eae45e0 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:617 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fcb1c4c8 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:618 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-848790ab | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:619 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6640f220 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:623 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-d2117364 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:624 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b8605b9a | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:625 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-1583c1b0 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:626 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-4566087f | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:632 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6d7433d | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:633 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c31d465 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:635 | else of (with_day_part == false) | UI_PROP | measure.Day.On | true | 속성 On 설정 |  |  |  |
| AC-f0dbe211 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:636 | else of (with_day_part == false) | UI_PROP | measure.Week.On | false | 속성 On 설정 |  |  |  |
| AC-47e42709 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:637 | else of (with_day_part == false) | UI_PROP | measure.Month.On | false | 속성 On 설정 |  |  |  |
| AC-d762efa7 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:643 | else of (with_day_part == false) ▸ if (sdate != measure.StartDate) | VALUE_SET | measure.StartDate | sdate | 컨트롤 값 설정 |  |  |  |
| AC-1178aab8 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:670 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-589daa18 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:676 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e49faab6 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:679 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf1fc461 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:680 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a6fead0 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:681 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-6852d3da | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:684 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ if (last_col > DayColumnCount) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-74b2f262 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:688 | else of (with_day_part == false) ▸ if (refreshColumn) ▸ else of (last_col > DayColumnCount) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-8988a55d | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:690 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-1d7508cb | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:691 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.DrawSheet

진입점: chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / cbHorizonalLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / cbShowLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / updownRow.ValueChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogRes…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0df0e056 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:700 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-77de0ab7 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:710 | if (!do_data) ▸ try | CALL_EXT | this.siMain.SpreadObject.Open | (xmlFile) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e67bde9e | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:722 | if (do_data) ▸ foreach (FarPoint.Win.Spread.Chart.SpreadChart achart in ChartBuffer) ▸ if (achart != null) | UI_MISC | achart.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-13bed134 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:725 | if (do_data) ▸ if (ChartBuffer.Count > 0) | CALL_EXT | ChartBuffer.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6dccae33 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:757 | if (do_data) ▸ if (!in_Dataset.Good()) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bc363e3 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:767 | if (do_data) ▸ if (!in_Dataset.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is string &… | UI_PROP | row.Height | GRAPH_ROW_HEIGHT + graph_margin * 2 | 속성 Height 설정 |  |  |  |
| AC-59ec7bea | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:772 | if (do_data) ▸ if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51a86c11 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:781 | if (do_data) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2b0e237 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:783 | if (do_data) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0840acef | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:795 | if (do_data) ▸ if (dsMainFiltered.Good()) | FLAG | bottom_margin_of_inner_graph | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-9187865c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:798 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ if (ShowLegend == false) | FLAG | bottom_margin_of_inner_graph | 40 | 화면 필드/플래그 변경 |  |  |  |
| AC-3307a36e | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:802 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ else of (ShowLegend == false) ▸ if (HorizontalLegend == true) | FLAG | bottom_margin_of_inner_graph | 60 | 화면 필드/플래그 변경 |  |  |  |
| AC-62e43a5e | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:815 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ if (draw_same_as_data) ▸ while (roop > 0) | CALL_EXT | siMain.ActiveSheet.GetColumnWidth | (roop--) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e898632c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:820 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ if (draw_same_as_data) ▸ while (roop > lastcol) | CALL_EXT | siMain.ActiveSheet.GetColumnWidth | (roop--) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3d664e4 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:834 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ else of (draw_same_as_data) ▸ while (roop > 0) | CALL_EXT | siMain.ActiveSheet.GetColumnWidth | (roop--) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41ebc34d | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:840 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ else of (draw_same_as_data) ▸ while (roop > 0) | CALL_EXT | siMain.ActiveSheet.GetColumnWidth | (roop--) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d315430c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:864 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | row.Resizable | true | 속성 Resizable 설정 |  |  |  |
| AC-bcd54aac | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:865 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | row.Height | GRAPH_ROW_HEIGHT + graph_margin * 2 | 속성 Height 설정 |  |  |  |
| AC-7872538c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:882 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | dsMain.Tables[0].Select | (query) | 데이터 객체 조작/조회 |  |  |  |
| AC-02c97234 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:894 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | cate.ToUpper().Contains | ("CAPA") | 데이터 객체 조작/조회 |  |  |  |
| AC-63e71ecc | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:897 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | stackBar.Series.Add | (_LineSerires) | 데이터 객체 조작/조회 |  |  |  |
| AC-40347c33 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:898 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.SeriesName | cate | 속성 SeriesName 설정 |  |  |  |
| AC-4f8f6eec | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:931 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | _LineSerires.Values.Add | (val) | 데이터 객체 조작/조회 |  |  |  |
| AC-e621fa01 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:934 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | CALL_EXT | day.Date.MonthDayString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ff4560c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:940 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | _LineSerires.CategoryNames.Add | (day_txt) | 데이터 객체 조작/조회 |  |  |  |
| AC-89454233 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:955 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | CALL_EXT | siMain.GetExcelColumnName | (index_start + 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42b9ab43 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:957 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | CALL_EXT | siMain.GetExcelColumnName | (index_end + 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13514d08 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:960 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | LIST_BIND | _LineSerires.Values.DataSource | new FarPoint.Win.Spread.Chart.SeriesDataField(siMain.SpreadObject, "Data", formula) | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-b7ce691d | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:964 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.LabelVisible | false | 속성 LabelVisible 설정 |  |  |  |
| AC-db593970 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:973 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | lines.Add | (_LineSerires) | 데이터 객체 조작/조회 |  |  |  |
| AC-e320a54c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:974 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.SeriesName | cate | 속성 SeriesName 설정 |  |  |  |
| AC-0affd4f6 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1007 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | _LineSerires.Values.Add | (val) | 데이터 객체 조작/조회 |  |  |  |
| AC-e80a7230 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1010 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | CALL_EXT | day.Date.MonthDayString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-19cffbf1 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1016 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | _LineSerires.CategoryNames.Add | (day_txt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cbe6cb0 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1031 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | CALL_EXT | siMain.GetExcelColumnName | (index_start + 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0783d16 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1033 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | CALL_EXT | siMain.GetExcelColumnName | (index_end + 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef726e22 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1036 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | LIST_BIND | _LineSerires.Values.DataSource | new FarPoint.Win.Spread.Chart.SeriesDataField(siMain.SpreadObject, "Data", formula) | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-96526493 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1040 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.LabelVisible | false | 속성 LabelVisible 설정 |  |  |  |
| AC-1b14a69e | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1041 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.SmoothedLine | false | 속성 SmoothedLine 설정 |  |  |  |
| AC-519e0516 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1042 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.PointMarker | new FarPoint.Win.Chart.NoMarker() | 속성 PointMarker 설정 |  |  |  |
| AC-b02f8ad7 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1043 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.DropLinesLine | new FarPoint.Win.Chart.NoLine() | 속성 DropLinesLine 설정 |  |  |  |
| AC-099ce2eb | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1044 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | _LineSerires.DropLinesVisible | true | 속성 DropLinesVisible 설정 |  |  |  |
| AC-1dfe279d | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1051 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | plotArea.Location | new PointF(0.2f, 0.2f) | 속성 Location 설정 |  |  |  |
| AC-11d9bcee | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1052 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | plotArea.Size | new SizeF(0.6f, 0.6f) | 속성 Size 설정 |  |  |  |
| AC-e4ac243b | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1058 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | plotArea.Series.Add | (eline) | 데이터 객체 조작/조회 |  |  |  |
| AC-7949d23b | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1061 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | plotArea.Series.Add | (stackBar) | 데이터 객체 조작/조회 |  |  |  |
| AC-445b43a5 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1074 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | dsMainFiltered.Tables[0].Columns.Contains | ("GRAPH_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1240f1c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1075 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | VALUE_SET | label.Text | arow["GRAPH_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-180efa59 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1077 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | VALUE_SET | label.Text | arow["CATEGORY_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9b42bdf1 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1078 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | label.Location | new PointF(0.5f, 0.02f) | 속성 Location 설정 |  |  |  |
| AC-6fb5a4f1 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1079 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | label.AlignmentX | 0.5f | 속성 AlignmentX 설정 |  |  |  |
| AC-f5b3998a | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1080 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | label.AlignmentY | 0.0f | 속성 AlignmentY 설정 |  |  |  |
| AC-984c7f69 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1082 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.Location | new PointF(0.98f, 0.5f) | 속성 Location 설정 |  |  |  |
| AC-0cefc7db | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1083 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.AlignmentX | 1.0f | 속성 AlignmentX 설정 |  |  |  |
| AC-1371525c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1084 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.AlignmentY | 0.0f | 속성 AlignmentY 설정 |  |  |  |
| AC-8d1a5d1a | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1085 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.LegendPos | FarPoint.Win.Chart.LegendPos.Bottom | 속성 LegendPos 설정 |  |  |  |
| AC-a6921401 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1093 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | CALL_EXT | siMain.SpreadObject.ActiveSheet.AddChart | (range, typeof(FarPoint.Win.Chart.XYLineSeries), graphwidth, GRAPH_ROW_HEIGHT, startleft +… | ⚠ 의미 확인 필요 |  |  |  |
| AC-73ef6ae7 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1094 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | ChartBuffer.Add | (added_chart) | 데이터 객체 조작/조회 |  |  |  |
| AC-626dedef | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1097 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | added_chart.ViewType | FarPoint.Win.Chart.ChartViewType.View2D | 속성 ViewType 설정 |  |  |  |
| AC-5e3fa040 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1098 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | added_chart.DynamicMove | true | 속성 DynamicMove 설정 |  |  |  |
| AC-ee3991bf | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1099 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | added_chart.DynamicSize | true | 속성 DynamicSize 설정 |  |  |  |
| AC-51bfda23 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1100 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | added_chart.AllowShowIndicator | true | 속성 AllowShowIndicator 설정 |  |  |  |
| AC-65af9003 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1121 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.TextFont | new System.Drawing.Font("Tahoma", 9) | 속성 TextFont 설정 |  |  |  |
| AC-637c45da | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1129 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.LegendPos | FarPoint.Win.Chart.LegendPos.Bottom | 속성 LegendPos 설정 |  |  |  |
| AC-466deb16 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1131 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | model.PlotAreas.Add | (plotArea) | 데이터 객체 조작/조회 |  |  |  |
| AC-ecace609 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1132 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | model.LabelAreas.Add | (label) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7cd2ee3 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1136 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.Vertical | false | 속성 Vertical 설정 |  |  |  |
| AC-e46f031b | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1138 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | legend.Vertical | true | 속성 Vertical 설정 |  |  |  |
| AC-d63fb029 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1139 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | DATA_OP | model.LegendAreas.Add | (legend) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b69450 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1142 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | label.TextFont | new System.Drawing.Font("Tahoma", 13) | 속성 TextFont 설정 |  |  |  |
| AC-5be3da36 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1144 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | plotArea.Location | new PointF(location_ratio, location_top_ratio) | 속성 Location 설정 |  |  |  |
| AC-caa24d68 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1145 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | plotArea.Size | new SizeF(width_ratio, height_ratio) | 속성 Size 설정 |  |  |  |
| AC-d790dd7a | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1148 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | added_chart.Model | model | 속성 Model 설정 |  |  |  |
| AC-732a5f6a | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1149 | if (do_data) ▸ if (dsMainFiltered.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (arow["ROW_TYPE"] is strin… | UI_PROP | added_chart.AllowShowIndicator | true | 속성 AllowShowIndicator 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.ds_List01_cancolumnchange

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if (!Clipboard)] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ae9ca0d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2910 | if (clicked_row == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f0cbb614 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2912 | if (clicked_row["CATEGORY_ID"].ToString() == "SIM_SETUP") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-83747d09 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2919 | if (bM != -1 && bC != -1 && bJ != -1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5cd18c7c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2921 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c13ee4e | ExcelButton | FP02844_Plan_Elec_Post_WH_Load.cs:1757 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43271412 | ExcelButton | FP02844_Plan_Elec_Post_WH_Load.cs:1747 |  | FLAG | base.ExcelOption | ExcelExportOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.Find_YieldInfo_All

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f92e5667 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2866 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9365e34b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2867 |  | DATA_OP | Filter2["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-fbf1a07b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2868 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_yieldInfo_ALL", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-148f8650 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2869 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.findLineCode_List

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1345feee | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:407 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-16cc768c | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:408 |  | DATA_OP | LocalFilter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-c9f38a87 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:424 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-acb611a8 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:442 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-e2c6368a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:447 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b0214738 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:460 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-e14c3cb6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:463 |  | DATA_OP | LocalFilter["CTRL_LINE_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-53437a70 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:477 | if (LocalFilter["ALL_LINE"] != "Y") | DATA_OP | LocalFilter["CTRL_LINE_LT"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-e24674df | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:480 |  | FLAG | dtLine | DataService.FP_ExecuteQuery2("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-ff09b877 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:480 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1b49dba5 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:481 |  | RETURN | return dtLine; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4da3e055 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:1953 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP02844_FIND_FP02844", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b56f0b2 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:1961 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-67410bf4 | popSql.OnSql [if (programID == "PR_UI_FP02844_FIND_FP02844")… 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:1967 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.FindMainData2

진입점: popSql.OnSql [else of (programID == "PR_UI_FP02844_FIND_FP02844") ▸ if (programID == "PR_UI_FP02844_FIND_FP02844B")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94a80d6d | popSql.OnSql [else of (programID == "PR_UI_FP02844_FIND_FP02… | FP02844_Plan_Elec_Post_WH_Load.cs:1989 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP02844_FIND_FP02844B", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-191a3134 | popSql.OnSql [else of (programID == "PR_UI_FP02844_FIND_FP02… | FP02844_Plan_Elec_Post_WH_Load.cs:1997 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-95e71d5f | popSql.OnSql [else of (programID == "PR_UI_FP02844_FIND_FP02… | FP02844_Plan_Elec_Post_WH_Load.cs:2003 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.FindYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH"))] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ecbeeb6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2874 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dbe01962 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2876 |  | DATA_OP | Filter2["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e63e16be | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2877 |  | DATA_OP | Filter2["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f138e257 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2878 |  | DATA_OP | Filter2["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed4f7c22 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2879 |  | DATA_OP | Filter2["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f0cf129 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2880 |  | DATA_OP | Filter2["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ada664aa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2881 |  | DATA_OP | Filter2["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3a35cacb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2882 |  | DATA_OP | Filter2["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-887c9818 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2883 |  | DATA_OP | Filter2["PLAN_DATE"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8ce850be | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2884 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_yieldInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-275d2e5b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2890 | if (ret.Good()) ▸ if (cell_rate > 0) | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |
| AC-eaec88d5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2892 |  | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2961d78f | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:183 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c2fc2f8 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:1801 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-1fcc3196 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:1801 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc92c4c8 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:1803 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetFactory

진입점: this.Load / mcbo_plant.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-800f0100 | this.Load 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:1825 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-c7bf589b | this.Load 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:1825 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b094746f | this.Load 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:1830 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetFilter

진입점: FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-167704b2 | FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1796 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetFpPlanId

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.ValueChanged / this.cbo_fpplanid.DropDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0dd999eb | this.Load 외 3 | FP02844_Plan_Elec_Post_WH_Load.cs:4801 |  | FLAG | dtPlanId | DataService.FP_ExecuteProcedure2(("PR_UI_" + "FP00602" + "_" + "findFpPlan_info").ToUpper(… | 화면 필드/플래그 변경 |  |  |  |
| AC-6c73106d | this.Load 외 3 | FP02844_Plan_Elec_Post_WH_Load.cs:4801 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00602" + "_" + "findFpPlan_info").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-baf7c89b | this.Load 외 3 | FP02844_Plan_Elec_Post_WH_Load.cs:4803 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetOperation

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb8766dd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5582 |  | FLAG | dtOperation | DataService.FP_ExecuteProcedure2(("PR_UI_" + "FP00599" + "_" + "findOperationCode_common")… | 화면 필드/플래그 변경 |  |  |  |
| AC-6283b573 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5582 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-45d2e5d8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5590 |  | DATA_OP | Filter["OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4710400 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:4787 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth ,… | 화면 필드/플래그 변경 |  |  |  |
| AC-6e349caf | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:4788 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8dc958bb | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:4793 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-1348040e | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:4795 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetPlant

진입점: this.Load / mcbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfac0a96 | this.Load 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1816 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-34377ac1 | this.Load 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1816 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f109b0a | this.Load 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1818 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d89ccc9 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3821 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-6dbeb5cc | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:3822 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.GetSite

진입점: this.Load / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17320038 | this.Load 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1809 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-725df631 | this.Load 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1809 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69d1b54c | this.Load 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1811 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80b5af3c | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:1882 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.InitAmendLineELec

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7644970e | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:197 |  | DATA_OP | Filter["AMEND_INSTANCE"] | lv_amendInstance | 행/컬럼 값 대입 |  |  |  |
| AC-69a153c3 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:198 |  | DATA_OP | Filter["PLAN_DATE"] | DateUtil_FP.gfn_today() | 행/컬럼 값 대입 |  |  |  |
| AC-a326f36e | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:198 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-09a59e5d | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:199 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.InitControlFilter

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57e5da49 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:252 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-781f575f | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:253 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-8fd01811 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:253 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-75c71ad8 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:254 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-93cb7ea4 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:255 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-26485231 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:256 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-353b2c1e | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:260 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-8a3de992 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:265 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_cutoff.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-d139d396 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:266 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_cutoff.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-1bf33a84 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:269 |  | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-e4732b52 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:269 |  | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-95468005 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:292 |  | FLAG | dtUnit | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02844_Plan_ELEC_POST_WH_LOAD", "U… | 화면 필드/플래그 변경 |  |  |  |
| AC-b0be34f2 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:292 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02844_Plan_ELEC_POST_WH_LOAD", "UNIT_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c0a565f | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:301 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnit, cboUnit, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-21b7008d | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:305 |  | FLAG | dtRoundPoint | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02844_Plan_ELEC_POST_WH_LOAD", "R… | 화면 필드/플래그 변경 |  |  |  |
| AC-1d5fbb4c | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:305 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02844_Plan_ELEC_POST_WH_LOAD", "ROUND_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b798d25b | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:314 |  | LIST_REBIND | clsCtrl.setListBox | (dtRoundPoint, cboRoundPoint, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8d3ecbc9 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:315 |  | VALUE_SET | cboRoundPoint.SelectedValue | 2 | 컨트롤 값 설정 |  |  |  |
| AC-8729a145 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:318 |  | VALUE_SET | chk_show_ref_data.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbbf9155 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:205 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e403bd00 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:210 | try | VALUE_SET | sCalendar_planday.Value | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-5b801809 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:212 | try | UI_PROP | dCalendar_cutoff.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-c3cc0c23 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:213 | try | UI_PROP | dCalendar_cutoff.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-b99babdd | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:216 | try | VALUE_SET | updownRow.Value | GRAPH_ROW_HEIGHT | 컨트롤 값 설정 |  |  |  |
| AC-9fe9741b | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:217 | try | VALUE_SET | cbHorizonalLegend.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-da609981 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:218 | try | VALUE_SET | cbShowLegend.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-7ff37c51 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:219 | try | FLAG | ShowLegend | cbShowLegend.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-20a97ad8 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:220 | try | FLAG | HorizontalLegend | cbHorizonalLegend.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-d5d2198e | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:224 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0779f35d | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:225 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-bc696dd3 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:229 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3739745f | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:323 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ea612ecb | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:324 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e02effd1 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:325 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-aa219656 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:326 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.InitSpread

진입점: this.Load / chk_show_ref_data.CheckedChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / cbHorizonalLegend.CheckedChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / cbShowLegend.CheckedChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / updownRow.ValueChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6a619fb | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:501 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42eb5196 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:502 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d514a91 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:504 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-165300d3 | this.Load 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:508 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c32ca3a | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:1767 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.IsEmpty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0722a7d7 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2253 | if (value == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-afd00579 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2255 | if (value is string && string.IsNullOrWhiteSpace((string)value)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-dcfdc027 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2257 | if (value is DBNull) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-78a2c4dc | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2258 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.IsNumber

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32f1307b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2263 | if (value == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d813246f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2265 | if (value is decimal) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-1067f6fd | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2267 | if (value is double) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-be054ccf | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2269 | if (value is Int16) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-3704a541 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2271 | if (value is Int32) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-9d1c5bb2 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2273 | if (value is Int64) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b081620c | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2275 | if (value is float) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-cb993b4b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2279 | if (value is string) ▸ if (string.IsNullOrWhiteSpace((string)value)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4ef4ec84 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2282 | if (value is string) | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-db731e54 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2284 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.lfn_getExchangeBatch_Validation

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if (!Clipboard)] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd925b7c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3772 | switch (cate) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-1b14fcae | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3781 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb736a96 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3782 | lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-000c4892 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3783 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-12558ccd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3784 | lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-226e7de9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3785 | lambda | DATA_OP | x.Field | ("PROD_VERSION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed643283 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3779 | lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-711561f5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3794 | if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-87178797 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3795 | if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-b3f9283d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3797 |  | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.lfn_getYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH"))] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d6623cc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2897 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f1b837b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2898 |  | DATA_OP | yf["LINE_ID"] | clicked_row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c95f34b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2899 |  | DATA_OP | yf["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff7f6ef9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2900 |  | DATA_OP | yf["FACTORY_ID"] | clicked_row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa0dee04 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2901 |  | FLAG | YieldRate | FindYieldInfo(yf, yyyymmdd) | 화면 필드/플래그 변경 |  |  |  |
| AC-90f443fb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2901 |  | RETURN | return YieldRate = FindYieldInfo(yf, yyyymmdd); |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.lfn_setExchangeBatch

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH"))] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab9f0e74 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3599 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-bbf0328a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3605 |  | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", clicked_row["PRODUCTION_TYPE"].ToString(), "VERSION_TYPE_1") | ⚠ 의미 확인 필요 |  |  |  |
| AC-84742632 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3640 |  | CALL_EXT | dsYieldChild.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-099932a3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3645 | else of (nExcRow == -1) | DATA_OP | dsYieldChild.Tables[0].getColumn | (nExcRow, "CHILD_YIELD") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-94771e5a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3652 |  | RETURN | return (int)nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.lfn_setExchangeBatch_Detail

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH"))] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5196dd2a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3684 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de02902b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3685 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9038395b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3686 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f935bdd8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3687 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a26f699 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3688 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cb2fa69 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3689 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7daebc0f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3690 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2292390 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3722 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", sProdType, sTxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-917690b8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3733 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a184d3fb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3752 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1538c64 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3755 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.ManualSetPlanOutCell

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32fecf93 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2926 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b5403e3 | memo_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2606 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54d65ca1 | memo_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2609 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52378afb | memo_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2613 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.onNLFAmendMenu

진입점: nlfamend_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3650fbae | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2797 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c65230e | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2800 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95e4eac5 | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2818 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-f64693f8 | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2819 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-780e08e7 | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2819 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-16c4bb46 | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2820 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8d421180 | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2821 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c528f6d | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2822 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-16531c1d | nlfamend_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2823 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e01da07c | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2290 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef072c95 | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2293 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-142f64cb | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2310 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-881fd149 | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2311 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f4bbdf73 | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2322 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") &&… | DATA_OP | row_to_test["CATEGORY_ID"].ToString().Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-928a83f2 | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2348 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e0fdaa93 | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2349 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fc462024 | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2350 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f6bbea4 | bucke_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2353 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.onZeroLineMenu

진입점: zero_line_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fb3e4e8 | zero_line_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2475 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6aa56ec3 | zero_line_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2478 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-051be46c | zero_line_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2482 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-80395870 | zero_line_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2504 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-5643546e | zero_line_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2559 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-597efe06 | zero_line_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2587 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7aa1912 | zero_line_menu.Click | FP02844_Plan_Elec_Post_WH_Load.cs:2590 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.onZeroMaterialMenu

진입점: zero_mat_menu.Click / bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca3e6ba6 | zero_mat_menu.Click 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:2365 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a0dd2b8 | zero_mat_menu.Click 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:2368 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd8bd8f2 | zero_mat_menu.Click 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:2372 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-043d2a8c | zero_mat_menu.Click 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:2393 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-d054cf94 | zero_mat_menu.Click 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:2437 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4c7e978 | zero_mat_menu.Click 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:2465 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3e955190 | zero_mat_menu.Click 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:2469 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a65538de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5557 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac30d2a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5557 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3829a1f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5559 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-464ff25f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5560 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-02666647 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5560 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1bcf200e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5561 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-09a2fb4a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5562 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fc7ee5fc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5563 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0984c641 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5567 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3fb687f7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5569 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-09d3f66b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5574 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd0f4202 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5517 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-292ef77a | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5518 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-85eaaa7b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5519 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-33739a35 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5519 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-be653c9f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5520 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-31692559 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5521 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6b665385 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5522 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f79ead4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5526 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f42e3b71 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5528 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d5f5a9b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5534 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-c2329949 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5535 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-2a7185b6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5536 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-12c62895 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5536 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0395addb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5537 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-1d6fe1a7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5538 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-57548b88 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5539 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d1dd2598 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5543 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-63802b03 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… | FP02844_Plan_Elec_Post_WH_Load.cs:5545 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.PasteAuto

진입점: this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b77c51a1 | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP02844_Plan_Elec_Post_WH_Load.cs:4548 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c298b1a0 | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP02844_Plan_Elec_Post_WH_Load.cs:4549 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e456b7f5 | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP02844_Plan_Elec_Post_WH_Load.cs:4603 | if (ClipData != null) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.planday_changed

진입점: sCalendar_planday.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1da6b78e | sCalendar_planday.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4201 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-ce69089b | sCalendar_planday.ValueChanged | FP02844_Plan_Elec_Post_WH_Load.cs:4202 |  | UI_PROP | dCalendar_cutoff.Value1 | sCalendar_planday.Value | 속성 Value1 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.RefreshHeadAndBody

진입점: chk_show_ref_data.CheckedChanged [if (dsMain != null)] / cbHorizonalLegend.CheckedChanged [if (dsMain != null)] / cbShowLegend.CheckedChanged [if (dsMain != null)] / updownRow.ValueChanged [if (dsMain != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6addfa7e | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:541 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ab59a74f | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:557 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-e6460e27 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:561 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.RefreshSpreadSheet

진입점: chk_show_ref_data.CheckedChanged [if (dsMain != null)] / cbHorizonalLegend.CheckedChanged [if (dsMain != null)] / cbShowLegend.CheckedChanged [if (dsMain != null)] / updownRow.ValueChanged [if (dsMain != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e200b70 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1726 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e15654e | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1733 | if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) | DATA_OP | row["_VI_"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-4befaeb8 | chk_show_ref_data.CheckedChanged [if (dsMain != null)] 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:1741 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a30bf58 | popSql.OnSql | FP02844_Plan_Elec_Post_WH_Load.cs:1913 | if (programID == "PR_UI_FP02844_FIND_FP02844") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-ad1ce82e | popSql.OnSql | FP02844_Plan_Elec_Post_WH_Load.cs:1917 | else of (programID == "PR_UI_FP02844_FIND_FP02844") ▸ if (programID == "PR_UI_FP02844_FIND_FP02844B") | RETURN | return FindMainData2(false); |  | 처리 중단/반환 |  |  |  |
| AC-ec0db4e1 | popSql.OnSql | FP02844_Plan_Elec_Post_WH_Load.cs:1919 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SaveSimplexcel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c336be94 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5041 | for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (i == 0) | DATA_OP | xSheet.ColumnWidths[j] | 20 | 행/컬럼 값 대입 |  |  |  |
| AC-de497aca | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5043 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j] | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-2539ec34 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5066 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-50d7333b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5073 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Left | 그리드 속성/값 설정 |  |  |  |
| AC-2b0cad3b | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5094 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Border | Simplexcel.CellBorder.All | 그리드 속성/값 설정 |  |  |  |
| AC-8b506c69 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5096 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-8b93bc23 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5108 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Fill.BackgroundColor | Simplexcel.Color.FromArgb(0, 240, 240, 240) | 그리드 속성/값 설정 |  |  |  |
| AC-ce992741 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5134 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ if (sp.Columns[j].HeaderText == "PLAN_DATE") | GRID_SET | xSheet.Cells[id, jd] | "'" + inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-51f811cc | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5146 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-926cb3bf | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5147 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-99e6fbd0 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5155 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-62cbdf95 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5156 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-609d1ade | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5161 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-e5a4181c | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5162 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-1cc81f36 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5168 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Value | ss | 그리드 속성/값 설정 |  |  |  |
| AC-a854c9ef | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5174 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-86c06b94 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5184 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-d19b9de9 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5185 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-28871ee2 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5191 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7a746041 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5192 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-24552043 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5197 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-3ee83e95 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5201 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-12e91694 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5218 | for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-516021f3 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5230 | for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-df9ff098 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5232 | for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-abe86a07 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5237 |  | GRID_INIT | xSheet.FreezeTopLeft | (1, froz) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b199fb16 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5238 |  | DATA_OP | workbook.Add | (xSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-13234e0e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5252 |  | UI_PROP | workbook.Title | name | 속성 Title 설정 |  |  |  |
| AC-85efafa8 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5253 |  | UI_PROP | workbook.Author | "GSCM,FP, logged as " + this.UserInfo.UserId | 속성 Author 설정 |  |  |  |
| AC-14c140a6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5255 |  | CALL_EXT | workbook.Save | (fileName) | ⚠ 의미 확인 필요 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetCalendarFormat

진입점: chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (siMain != null)] / cbHorizonalLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (siMain != null)] / cbShowLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (siMain != null)] / updownRow.ValueChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (siMain != null)] / memo_menu.Click…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b62999e | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4901 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExcel… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-060cc143 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4903 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (for… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-06ee5972 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4906 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-253a0be4 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4930 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExc… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78979d26 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4932 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (f… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94188be8 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4935 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54574f06 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4961 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forE… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8406e7c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4963 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of … | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe04d6b7 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4966 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.###", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetCalenderColor

진입점: chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (dsMainFiltered.Good())] / cbHorizonalLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (dsMainFiltered.Good())] / cbShowLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (dsMainFiltered.Good())] / updownRow.ValueChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data) ▸ if (dsMainFiltere…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faea2b74 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:580 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba8335dd | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:584 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (date… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-22f7523c | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:586 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-498aa78e | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:590 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetColumnsFormat

진입점: chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data)] / cbHorizonalLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data)] / cbShowLegend.CheckedChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data)] / updownRow.ValueChanged [if (dsMain != null) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (do_data)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbe9fca8 | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:4841 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-353b9efc | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:4847 | if (siMain != null) ▸ if (colIndex > -1) ▸ if (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,###.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd0fb65b | chk_show_ref_data.CheckedChanged [if (dsMain != null) ▸ try … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:4851 | if (siMain != null) ▸ if (colIndex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,##0.###", "0", false) | ⚠ 의미 확인 필요 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9421dfd | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:152 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2aef661 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:154 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1a9f21af | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:158 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-baa11e10 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:160 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-4a265490 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:161 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4058a28 | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:163 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3c13f3de | this.Load | FP02844_Plan_Elec_Post_WH_Load.cs:167 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b976b8a9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:4826 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetFilter

진입점: this.Load / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / cboUnit.SelectedIndexChanged / cboRoundPoint.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged [if (dtPlanId.Good())] / dCalendar_cutoff.ValueChanged / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d75642a | this.Load 외 10 | FP02844_Plan_Elec_Post_WH_Load.cs:1791 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetMemoCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93abab28 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2673 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-fdc18365 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2693 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-f52b38ab | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2695 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | bcell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-80642d42 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2713 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-a090b69e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2738 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(siMain.SP.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-f792129f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2740 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(System.Drawing.SystemFonts.DefaultFont, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-4f45ed6e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:2744 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(memo_cell.Font.Name, memo_cell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetPlanOutCell

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1e88599 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2931 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-f935594d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2948 | if (!Clipboard) ▸ if (!can_change) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-864ddc88 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2949 | if (!Clipboard) ▸ if (!can_change) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-df5a5295 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2950 | if (!Clipboard) ▸ if (!can_change) | THROW | throw new Exception("error"); |  | 예외 발생 |  |  |  |
| AC-ef7c1def | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2957 | if (!Clipboard) ▸ if (o_new == null && CurrentInputValue == null) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-260f7de5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2958 | if (!Clipboard) ▸ if (o_new == null && CurrentInputValue == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e7771ee | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2967 | if (!Clipboard) ▸ if (new_value != x) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | x | 그리드 속성/값 설정 |  |  |  |
| AC-5425703f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2969 | if (!Clipboard) ▸ if (new_value != x) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0e6ea8c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2977 | if (!Clipboard) ▸ if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-f76fa458 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2978 | if (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45df2bf3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2987 | else of (!Clipboard) ▸ if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-8bed196f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2988 | else of (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b697ae0f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:2995 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad68b4eb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3000 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-8ee03330 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3007 | if (Clipboard && org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b865912 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3012 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-5904c8f8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3054 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6939f6ce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3055 | lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-8227240b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3056 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-816fd71a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3057 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-56631378 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3059 | lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-906a9216 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3060 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-567cc1a8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3062 | lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-58d42766 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3063 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8314d271 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3065 | lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa68388d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3066 | lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-95f4428b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3068 | lambda | DATA_OP | x.Field | ("RELEASE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-050e93a8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3069 | lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-8673bf38 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3085 | else of (m.Count() > 0) | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-fba11b1b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3094 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) ▸ if (Clipboard) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-3734e681 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3097 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) ▸ else of (Clipboard) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-7ea356c0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3099 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-8152f166 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3103 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cdad74d7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3105 | else of (m.Count() > 0) | DATA_OP | newRow["INSTANCE_ID"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d354a048 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3106 | else of (m.Count() > 0) | DATA_OP | newRow["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce4eca9e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3107 | else of (m.Count() > 0) | DATA_OP | newRow["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-f71d08f7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3108 | else of (m.Count() > 0) | DATA_OP | newRow["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-dc07fd4f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3109 | else of (m.Count() > 0) | DATA_OP | newRow["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-0ac7dd2c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3110 | else of (m.Count() > 0) | DATA_OP | newRow["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-f8808217 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3111 | else of (m.Count() > 0) | DATA_OP | newRow["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-72c80b94 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3112 | else of (m.Count() > 0) | DATA_OP | newRow["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-a1d30b3f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3113 | else of (m.Count() > 0) | DATA_OP | newRow["EQUIPMENT_ID"] | sEqup | 행/컬럼 값 대입 |  |  |  |
| AC-d41e7028 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3114 | else of (m.Count() > 0) | DATA_OP | newRow["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-fc38fc33 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3115 | else of (m.Count() > 0) | DATA_OP | newRow["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-f59cfdba | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3116 | else of (m.Count() > 0) | DATA_OP | newRow["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-803c95cc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3117 | else of (m.Count() > 0) | DATA_OP | newRow["ITEM_ID"] | sItem | 행/컬럼 값 대입 |  |  |  |
| AC-b6edc4f8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3119 | else of (m.Count() > 0) | DATA_OP | newRow["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-63595d29 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3120 | else of (m.Count() > 0) | DATA_OP | newRow["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-ea1a6268 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3121 | else of (m.Count() > 0) | DATA_OP | newRow["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-bf67c4cd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3122 | else of (m.Count() > 0) | DATA_OP | newRow["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-f7dc6220 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3125 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.Rows.Add | (newRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6aef9ca | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3137 | if (sCate == "P_SEQ") ▸ if (o_new == null) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-850b627d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3138 | if (sCate == "P_SEQ") ▸ if (o_new == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cbe2688 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3140 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-e5812c05 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3141 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["SEQ"] | o_new | 행/컬럼 값 대입 |  |  |  |
| AC-315bf39f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3146 | else of (sCate == "P_SEQ") | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-4db0ead3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3153 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) ▸ if (Clipboard) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-9084666c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3156 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) ▸ else of (Clipboard) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-0e2be54e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3158 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-9f545e3b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3159 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e861eb74 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3215 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-36de7528 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3216 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-6fa0c1fd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3217 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-ffaa574b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3219 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-0b390ce2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3220 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-c713734d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3231 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sOut_M] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-14d525b5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3237 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sOut_CELL] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-f7fae61b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3243 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) | DATA_OP | ds_ListDataR[sOut_JR] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-53b00e63 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3272 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-6a0d775c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3287 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_jr"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-143bf35d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3300 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-a8a7df3d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3318 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_pc"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-79212946 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3326 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-b8a7ed85 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3343 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_cell"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-7258fce2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3355 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-0d012223 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3371 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) ▸ if (res != null … | DATA_OP | res[0][ColumnName_Buf] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-30d1cbc0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3378 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-6c0f8729 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3394 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) ▸ if (res != null … | DATA_OP | res[0][ColumnName_Buf] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-c4ab972b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3401 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-6d521392 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3418 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) ▸ if (res != nul… | DATA_OP | res[0][ColumnName_Buf] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-c08c11da | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3425 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-a94c90f7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3441 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) ▸ if (res != nu… | DATA_OP | res[0][ColumnName_Buf] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-209cd15f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3450 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-d056f8ad | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3480 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) ▸ if (Filter["PLAN_TYPE"] != "RELEASE") ▸ if (res… | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-62fbff2b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3489 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) | CALL_EXT | dsMainFiltered.Tables[0].Rows[idx]["SEQ"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d10ea63 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 7 | FP02844_Plan_Elec_Post_WH_Load.cs:3498 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) ▸ if ((nInValue > 0) && oldseq == 0) ▸ if (res !=… | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SetSpreadInit

진입점: this.Load [try] / chk_show_ref_data.CheckedChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / cbHorizonalLegend.CheckedChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / cbShowLegend.CheckedChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / updownRow.ValueChanged [else of (dsMain != null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d3c0a80 | this.Load [try] 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:516 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e31f9914 | this.Load [try] 외 8 | FP02844_Plan_Elec_Post_WH_Load.cs:517 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4922275c | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5454 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-dd9e58ea | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5455 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-e571b506 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5457 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ffc1c7f | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5463 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-139e8576 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5464 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-8e1ffccb | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5466 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef4b5c67 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5477 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-856019c6 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5478 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-4fb80e58 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5480 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-f59de67e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5489 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | bucke_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-fa7b9e1d | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5490 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-9712596c | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5492 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4a0bb50 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5496 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | nlfamend_menu.Text | "NLF Amend" | 컨트롤 값 설정 |  |  |  |
| AC-2dfecb0e | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5497 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | nlfamend_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-1a3a7d91 | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5499 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (nlfamend_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd701f4c | (진입점 미연결) | FP02844_Plan_Elec_Post_WH_Load.cs:5507 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.spdMain_CellClick2

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74d7ae78 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4010 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-fe7c974d | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4030 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-a3030559 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4031 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-f42dd7c2 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4033 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-680fead0 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4040 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-1067933a | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4041 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-4bdec181 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4043 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-72943d82 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4052 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab166760 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4057 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_line_menu.Text | "Zero Setting(Line)" | 컨트롤 값 설정 |  |  |  |
| AC-ae927332 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4058 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_line_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-2a7e5f16 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4060 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_line_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eda3029 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4064 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_mat_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-0618f49b | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4065 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_mat_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-3401ba24 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4067 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_mat_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea0b4668 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4071 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | line_change_menu.Text | "Line Change" | 컨트롤 값 설정 |  |  |  |
| AC-9c1497db | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4072 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | line_change_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-8a2a2e04 | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4074 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (line_change_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d5dd05c | spdMain.CellClick | FP02844_Plan_Elec_Post_WH_Load.cs:4082 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82158842 | this.spdMain.Change | FP02844_Plan_Elec_Post_WH_Load.cs:4697 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cc4ebfe9 | this.spdMain.Change | FP02844_Plan_Elec_Post_WH_Load.cs:4701 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ee)) | MESSAGE | MessageBox.Show | (ee.ToString()) | 메시지 표시 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba3ad2eb | this.spdMain.ClipboardPasted | FP02844_Plan_Elec_Post_WH_Load.cs:4609 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38c16f88 | this.spdMain.ClipboardPasted | FP02844_Plan_Elec_Post_WH_Load.cs:4619 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0ef09eb1 | this.spdMain.ClipboardPasted | FP02844_Plan_Elec_Post_WH_Load.cs:4628 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2663e526 | this.spdMain.ClipboardPasted | FP02844_Plan_Elec_Post_WH_Load.cs:4629 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c1c7031 | this.spdMain.ClipboardPasted | FP02844_Plan_Elec_Post_WH_Load.cs:4632 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7baf256 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4439 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-8f83e8ff | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4440 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-473b157e | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4442 |  | COMBO_DATA | data.GetFormats | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a002f348 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4445 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41398116 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4447 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6580ec26 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4451 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | src_string.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-06353404 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4466 | if (data.GetDataPresent(typeof(System.String))) ▸ if (ClipRowCount == 0 && ClipColCount == 0) | FLAG | ClipData | new string[1, 1] | 화면 필드/플래그 변경 |  |  |  |
| AC-191b5639 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4467 | if (data.GetDataPresent(typeof(System.String))) ▸ if (ClipRowCount == 0 && ClipColCount == 0) | DATA_OP | ClipData[0, 0] | src_string | 행/컬럼 값 대입 |  |  |  |
| AC-29b66563 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4471 | if (data.GetDataPresent(typeof(System.String))) ▸ else of (ClipRowCount == 0 && ClipColCount == 0) ▸ if (MaxColCount > 0 && ClipRowCount > 0… | FLAG | ClipData | new string[ClipRowCount, MaxColCount] | 화면 필드/플래그 변경 |  |  |  |
| AC-25d0b3d2 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4482 | if (data.GetDataPresent(typeof(System.String))) ▸ else of (ClipRowCount == 0 && ClipColCount == 0) ▸ if (MaxColCount > 0 && ClipRowCount > 0… | DATA_OP | ClipData[i, j] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-bf391714 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4494 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-61449462 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4495 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b3deb52 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4500 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-aea68618 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4522 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | MESSAGE | MessageBox.Show | (ee.ToString()) | 메시지 표시 |  |  |  |
| AC-39fd7b6b | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4526 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9820940 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4529 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-82906305 | this.spdMain.ClipboardPasting | FP02844_Plan_Elec_Post_WH_Load.cs:4531 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b61a764a | this.spdMain.EditModeOn | FP02844_Plan_Elec_Post_WH_Load.cs:4682 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8eaa66d3 | this.spdMain.KeyDown | FP02844_Plan_Elec_Post_WH_Load.cs:4094 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-ffed5f22 | this.spdMain.KeyDown | FP02844_Plan_Elec_Post_WH_Load.cs:4118 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dd46c23a | this.spdMain.KeyDown | FP02844_Plan_Elec_Post_WH_Load.cs:4145 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55af2465 | this.spdMain.KeyDown | FP02844_Plan_Elec_Post_WH_Load.cs:4149 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) ▸ for (x < 1) ▸ finally ▸ if (error != null… | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-ac43c498 | this.spdMain.KeyDown | FP02844_Plan_Elec_Post_WH_Load.cs:4154 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (ranges != null) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.SwitchMemo

진입점: memo_menu.Click [if (day != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e76708c | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5303 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7e774eb | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5320 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-04f35bd4 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5345 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6262abe6 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5349 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-edf9c08d | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5349 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-") | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-f42a50e4 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5371 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-66b91bb9 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5373 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-5a6527df | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5376 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a90e9e31 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5378 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2e4cc9d | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5378 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c09c2a9 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5379 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-bc377baa | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5381 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-7fc922bd | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5383 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-129d5437 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5395 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbaf9b88 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5395 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8bddcb0 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5415 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-11f8c596 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5416 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-e51abff4 | memo_menu.Click [if (day != null)] | FP02844_Plan_Elec_Post_WH_Load.cs:5418 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.UIFindData

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e087cc58 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1240 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b50ab323 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1241 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9a73049 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1244 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2bb2840a | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1251 | try ▸ if (string.IsNullOrWhiteSpace(Filter["FACTORY_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one factory to proceed") | 메시지 표시 |  |  |  |
| AC-64d0d592 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1252 | try ▸ if (string.IsNullOrWhiteSpace(Filter["FACTORY_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99e63976 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1258 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c12323ad | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1274 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c2c1cb0 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1275 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89f9b98e | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1282 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d9cc8db | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1283 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1ab3ea8 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1286 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0e9c090a | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1290 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7a4bd6c5 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1291 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e4561a75 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1293 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36a98d25 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1303 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | FindMainData(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-337e4ede | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1307 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("_MM_", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9f7a72c | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1308 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("_VI_", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9a38583 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1315 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fa0c1219 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1316 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c173762c | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1329 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c016e1f | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1342 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0ac0bdae | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1343 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f2907dda | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1352 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ec7b6e93 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1360 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce81af85 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1365 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-80f7630e | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1366 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-12719bb7 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1373 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ef24566 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1376 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-99a58426 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1380 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-a15046a3 | FindButton 외 1 | FP02844_Plan_Elec_Post_WH_Load.cs:1384 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02844_Plan_Elec_Post_WH_Load.UIRedraw

진입점: cbHorizonalLegend.CheckedChanged / cbShowLegend.CheckedChanged / updownRow.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ecdd332 | cbHorizonalLegend.CheckedChanged 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:361 |  | FLAG | GRAPH_ROW_HEIGHT | (int)updownRow.Value | 화면 필드/플래그 변경 |  |  |  |
| AC-0e833049 | cbHorizonalLegend.CheckedChanged 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:362 |  | FLAG | ShowLegend | cbShowLegend.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-57c573ea | cbHorizonalLegend.CheckedChanged 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:363 |  | FLAG | HorizontalLegend | cbHorizonalLegend.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-93da5927 | cbHorizonalLegend.CheckedChanged 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:372 | if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ba8a1c51 | cbHorizonalLegend.CheckedChanged 외 2 | FP02844_Plan_Elec_Post_WH_Load.cs:381 | else of (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

