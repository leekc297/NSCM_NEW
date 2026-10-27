# AS-IS 액션 대조표 — FP00627

> 원천: `Doc/asisfacts/screens/FP00627/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 312행 · 메서드 55 · 종류 DATA_OP 73 · FLAG 43 · UI_PROP 32 · VALUE_SET 28 · CALL_EXT 21 · RETURN 20 · GRID_INIT 16 · POPUP 13 · ENDPOINT 12 · MESSAGE 11 · UI_MISC 10 · STATE 7 · THROW 5 · GRID_STYLE 4 · GRID_SET 4 · LIST_REBIND 3 · GRID_LOCK 3 · COMBO_DATA 2 · GRID_BIND 2 · VALUE_CLEAR 1 · EXCEL 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 21


## FP00627_Cell_Simulation_Pack..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b41b64c | .ctor | FP00627_Cell_Simulation_Pack.cs:102 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00627_Cell_Simulation_Pack.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42b7322f | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1447 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-18044396 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1448 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c3a71998 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1449 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fc57eae8 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1450 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f5fa54e1 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1451 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a259333b | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1453 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b448a06 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1453 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2b9bb706 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1454 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-711c7604 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1454 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e8d98e95 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1455 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-41a2a433 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1455 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-07726e8b | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1456 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00600_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-da18cdf3 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1456 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00600_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8567aca7 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1469 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-e66dbe2c | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1470 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-506e2648 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1471 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f20c758f | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1472 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00627_Cell_Simulation_Pack.ApplySearchCondition

진입점: popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c40c55f7 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1483 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-11fe8793 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1484 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5653a0ac | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1486 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "FORMATION_INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ff8f0752 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1489 |  | DATA_OP | Filter["FORM_INS"] | dtFormInstance.Rows[0]["FORMATION_INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f68d2f2a | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1491 |  | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2e2d6d28 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1495 | if (Filter["RELEASE_FLAG"] == "Y" \|\| Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-f9771fdd | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1499 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00627_Cell_Simulation_Pack.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93db5adb | this.btn_bucket.Click | FP00627_Cell_Simulation_Pack.cs:1627 |  | POPUP | new FP00599_BucketSetForm_Popup | ("FP00627", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-b7c679b1 | this.btn_bucket.Click | FP00627_Cell_Simulation_Pack.cs:1629 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-f2a33172 | this.btn_bucket.Click | FP00627_Cell_Simulation_Pack.cs:1630 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a7632456 | this.btn_bucket.Click | FP00627_Cell_Simulation_Pack.cs:1631 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e3b4a774 | this.btn_bucket.Click | FP00627_Cell_Simulation_Pack.cs:1635 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00627_Cell_Simulation_Pack.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ddadbab | this.btn_category.Click | FP00627_Cell_Simulation_Pack.cs:1594 |  | POPUP | new FP00627_MeasureSetForm_Popup | ("FP00627", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-12aaf9d0 | this.btn_category.Click | FP00627_Cell_Simulation_Pack.cs:1596 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-abdea619 | this.btn_category.Click | FP00627_Cell_Simulation_Pack.cs:1597 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b9f4b72d | this.btn_category.Click | FP00627_Cell_Simulation_Pack.cs:1598 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ad825cd1 | this.btn_category.Click | FP00627_Cell_Simulation_Pack.cs:1602 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00627_Cell_Simulation_Pack.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a9c9e35 | this.btn_column.Click | FP00627_Cell_Simulation_Pack.cs:1576 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00627", SpdSheet.shtPlanAmendMA, true, cboPlanId.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-2dda2777 | this.btn_column.Click | FP00627_Cell_Simulation_Pack.cs:1577 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-62afd04c | this.btn_column.Click | FP00627_Cell_Simulation_Pack.cs:1578 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00627_Cell_Simulation_Pack.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be95ff1a | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1736 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-5e775841 | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1737 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66c9f829 | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1740 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3af9a1f5 | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1741 |  | UI_PROP | planInfoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-dcb7fbdd | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1741 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7290d5a0 | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1742 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f09e32ea | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1742 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-299502e8 | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1743 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-d8f6b549 | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1744 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f3d6d8fb | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1746 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3047fcb3 | this.btnPlanInfo.Click | FP00627_Cell_Simulation_Pack.cs:1747 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00627_Cell_Simulation_Pack.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41dd12b9 | this.btnSql.Click | FP00627_Cell_Simulation_Pack.cs:1131 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-97926b10 | this.btnSql.Click | FP00627_Cell_Simulation_Pack.cs:1132 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-38129658 | this.btnSql.Click | FP00627_Cell_Simulation_Pack.cs:1134 |  | DATA_OP | popSql.Services.Add | (_FormSearchProcedure) | 데이터 객체 조작/조회 |  |  |  |
| AC-acff7464 | this.btnSql.Click | FP00627_Cell_Simulation_Pack.cs:1135 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00627_Cell_Simulation_Pack.btnToggleSave_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51412d4e | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:1660 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00627_Cell_Simulation_Pack.cboInstance_changed

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d228971 | cboInstance.SelectedIndexChanged | FP00627_Cell_Simulation_Pack.cs:401 |  | STATE | chk_release.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e389726d | cboInstance.SelectedIndexChanged | FP00627_Cell_Simulation_Pack.cs:402 |  | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00627_Cell_Simulation_Pack.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d094e0c2 | this.Load | FP00627_Cell_Simulation_Pack.cs:593 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-71386b1a | this.Load | FP00627_Cell_Simulation_Pack.cs:593 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-34af7d37 | this.Load | FP00627_Cell_Simulation_Pack.cs:595 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00627_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9f7aad2 | this.Load | FP00627_Cell_Simulation_Pack.cs:595 |  | POPUP | new FP00627_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-de56575f | this.Load | FP00627_Cell_Simulation_Pack.cs:596 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41b75701 | this.Load | FP00627_Cell_Simulation_Pack.cs:596 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-12172cbc | this.Load | FP00627_Cell_Simulation_Pack.cs:599 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-c5d5b2a3 | this.Load | FP00627_Cell_Simulation_Pack.cs:600 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-b50337f7 | this.Load | FP00627_Cell_Simulation_Pack.cs:601 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f836de6 | this.Load | FP00627_Cell_Simulation_Pack.cs:602 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-1337e37b | this.Load | FP00627_Cell_Simulation_Pack.cs:603 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-1bbcb0ab | this.Load | FP00627_Cell_Simulation_Pack.cs:604 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00627_Cell_Simulation_Pack.chk_release_CheckedChanged

진입점: chk_release.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba0d704b | chk_release.CheckedChanged | FP00627_Cell_Simulation_Pack.cs:455 | if (chk_release.Checked) | STATE | cboPlanId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-55e12de1 | chk_release.CheckedChanged | FP00627_Cell_Simulation_Pack.cs:456 | if (chk_release.Checked) | STATE | drpPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-94bffe68 | chk_release.CheckedChanged | FP00627_Cell_Simulation_Pack.cs:465 | if (chk_release.Checked) ▸ if (cboPlanId.Items.Count > 0) | VALUE_CLEAR | cboPlanId.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-d88548aa | chk_release.CheckedChanged | FP00627_Cell_Simulation_Pack.cs:483 | else of (chk_release.Checked) | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3ccb439b | chk_release.CheckedChanged | FP00627_Cell_Simulation_Pack.cs:484 | else of (chk_release.Checked) | STATE | drpPlanDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00627_Cell_Simulation_Pack.CreateFilterDataSet

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4efdf816 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1151 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2763fc4a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1162 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-64783025 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1163 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-73a2cafe | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1192 | if (measure["chk_plan"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-67b2fa3d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1196 | if (measure["chk_planSum"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PLAN_TOT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-32d24568 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1200 | if (measure["chk_rec_inHouse"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "INHOUSE")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a078d91a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1204 | if (measure["chk_rec_CWA"].Value == "true") | CALL_EXT | HardCodeService.GetCodeFp | ("FP00627_CELL_SIMULATION_PACK", "CHK_REC_CWA") | ⚠ 의미 확인 필요 |  |  |  |
| AC-48785b54 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1207 | if (measure["chk_rec_CWA"].Value == "true") ▸ foreach (string code in codes) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4109548 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1212 | if (measure["chk_rec_CMI"].Value == "true") | CALL_EXT | HardCodeService.GetCodeFp | ("FP00627_CELL_SIMULATION_PACK", "CHK_REC_CWA") | ⚠ 의미 확인 필요 |  |  |  |
| AC-21de377d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1215 | if (measure["chk_rec_CMI"].Value == "true") ▸ foreach (string code in codes) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e29bf5ae | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1217 | if (measure["chk_rec_CMI"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "A003")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cceb811 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1221 | if (measure["chk_rec_CNA"].Value == "true") | CALL_EXT | HardCodeService.GetCodeFp | ("FP00627_CELL_SIMULATION_PACK", "chk_rec_CNA") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffbaa23b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1224 | if (measure["chk_rec_CNA"].Value == "true") ▸ foreach (string code in codes) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eba1f119 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1230 | if (measure["chk_rec_CNB"].Value == "true") | CALL_EXT | HardCodeService.GetCodeFp | ("FP00627_CELL_SIMULATION_PACK", "chk_rec_CNB") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9cc47627 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1233 | if (measure["chk_rec_CNB"].Value == "true") ▸ foreach (string code in codes) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e3a830d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1239 | if (measure["chk_rec_OC"].Value == "true") | CALL_EXT | HardCodeService.GetCodeFp | ("FP00627_CELL_SIMULATION_PACK", "chk_rec_OC") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6dee4ce | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1242 | if (measure["chk_rec_OC"].Value == "true") ▸ foreach (string code in codes) | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b0bce97 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1248 | if (measure["chk_shipmentResult"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SHIPMENT_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-91d06678 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1252 | if (measure["chk_EOL"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOL_PLAN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2499006c | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1256 | if (measure["chk_productionResult"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "PRODUCTION_RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-09752a41 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1260 | if (measure["chk_eoh_moving"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_MOVING")) | 데이터 객체 조작/조회 |  |  |  |
| AC-da31e865 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1264 | if (measure["chk_eoh_moving_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_MOVING_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc023a43 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1268 | if (measure["chk_eoh_eol"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_EOL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-66a8c0a2 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1272 | if (measure["chk_eoh_uninspection"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_EOL_UNINSPECTION_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9f6327b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1276 | if (measure["chk_eoh_eol_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_EOL_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4271f2fa | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1280 | if (measure["chk_eoh_cell_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_CELL_TOTAL")) | 데이터 객체 조작/조회 |  |  |  |
| AC-27a4858a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1284 | if (measure["chk_eoh_cell_total_hold"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "EOH_CELL_TOTAL_HOLD")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf7424bb | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1287 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e06f667e | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1291 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b20997e | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1295 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aaf9af35 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1298 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef59e48d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1300 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e411a734 | this.Load | FP00627_Cell_Simulation_Pack.cs:551 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2e502b39 | this.Load | FP00627_Cell_Simulation_Pack.cs:552 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-002362d5 | this.Load | FP00627_Cell_Simulation_Pack.cs:553 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00627_Cell_Simulation_Pack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5ac47ee | DeleteButton | FP00627_Cell_Simulation_Pack.cs:964 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00627_Cell_Simulation_Pack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93515ba3 | Dispose | FP00627_Cell_Simulation_Pack.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00627_Cell_Simulation_Pack.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fc56a0e | drpPeriod.ValueChanged | FP00627_Cell_Simulation_Pack.cs:527 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9f7dc7d | drpPeriod.ValueChanged | FP00627_Cell_Simulation_Pack.cs:534 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-d7748c0c | drpPeriod.ValueChanged | FP00627_Cell_Simulation_Pack.cs:535 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00627_Cell_Simulation_Pack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfba3dd2 | EditButton | FP00627_Cell_Simulation_Pack.cs:972 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00627_Cell_Simulation_Pack.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ce9143b | ExcelButton | FP00627_Cell_Simulation_Pack.cs:822 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00627_Cell_Simulation_Pack.FindMainData

진입점: popSql.OnSql [if (programID == _FormSearchProcedure)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cc57124 | popSql.OnSql [if (programID == _FormSearchProcedure)] 외 3 | FP00627_Cell_Simulation_Pack.cs:1429 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-a348c11d | popSql.OnSql [if (programID == _FormSearchProcedure)] 외 3 | FP00627_Cell_Simulation_Pack.cs:1434 | try | ENDPOINT | Data_FP.CallGeneralProcedure | (_FormSearchProcedure, Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ddef2d83 | popSql.OnSql [if (programID == _FormSearchProcedure)] 외 3 | FP00627_Cell_Simulation_Pack.cs:1436 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-5ebacf4c | popSql.OnSql [if (programID == _FormSearchProcedure)] 외 3 | FP00627_Cell_Simulation_Pack.cs:1440 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-fb6a6315 | popSql.OnSql [if (programID == _FormSearchProcedure)] 외 3 | FP00627_Cell_Simulation_Pack.cs:1442 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btn_category.Click [if (frm.DialogResult == DialogResul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2e94748 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 4 | FP00627_Cell_Simulation_Pack.cs:799 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77e066d8 | this.Load | FP00627_Cell_Simulation_Pack.cs:138 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00627_Cell_Simulation_Pack.GetFilter

진입점: popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51aa3e75 | popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try] 외 3 | FP00627_Cell_Simulation_Pack.cs:1360 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.GetIsPast

진입점: this.Load / cboInstance.SelectedIndexChanged / chk_release.CheckedChanged [if (chk_release.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0731ce1 | this.Load 외 2 | FP00627_Cell_Simulation_Pack.cs:335 |  | FLAG | dtIsPast | Data_FP.CallGeneralProcedure2(("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-2b688c49 | this.Load 외 2 | FP00627_Cell_Simulation_Pack.cs:335 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "ISPAST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00627_Cell_Simulation_Pack.GetPlanGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6830cd8d | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:329 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-5990c3fd | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:329 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1006a3d2 | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:330 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00627_Cell_Simulation_Pack.GetPlanId

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.ValueChanged / chk_release.CheckedChanged [else of (chk_release.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b7d499f | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:291 | if (Filter["POPUP_OPEN"].ToString().Equals("Y")) | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b31e041a | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:291 | if (Filter["POPUP_OPEN"].ToString().Equals("Y")) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "SIM_PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7f9f3fa7 | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:294 | else of (Filter["POPUP_OPEN"].ToString().Equals("Y")) | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-8ffe0aa6 | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:294 | else of (Filter["POPUP_OPEN"].ToString().Equals("Y")) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7ce1d3ef | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:296 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bc4a96ca | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:299 | if (cboPlanId.Items.Count > 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00627_Cell_Simulation_Pack.GetPlanPeriod

진입점: this.Load / drpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5557707d | this.Load 외 1 | FP00627_Cell_Simulation_Pack.cs:346 | if (!dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-08a05c50 | this.Load 외 1 | FP00627_Cell_Simulation_Pack.cs:347 | if (!dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(7) | 속성 Value2 설정 |  |  |  |
| AC-c329e935 | this.Load 외 1 | FP00627_Cell_Simulation_Pack.cs:363 | else of (!dtPlanId.Good()) | UI_PROP | drpPeriod.Text1 | sStart | 속성 Text1 설정 |  |  |  |
| AC-66dd9db8 | this.Load 외 1 | FP00627_Cell_Simulation_Pack.cs:365 | else of (!dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(7) | 속성 Value2 설정 |  |  |  |
| AC-b40f1b0b | this.Load 외 1 | FP00627_Cell_Simulation_Pack.cs:369 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-68bc40e1 | this.Load 외 1 | FP00627_Cell_Simulation_Pack.cs:370 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00627_Cell_Simulation_Pack.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16a7c1d6 | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:1376 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00627_Cell_Simulation_Pack.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16518548 | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:979 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ede0834 | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:981 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cfe25a6d | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:1044 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3490b1aa | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:1045 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-b355f144 | (진입점 미연결) | FP00627_Cell_Simulation_Pack.cs:1121 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00627_Cell_Simulation_Pack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ec687b4 | this.Load | FP00627_Cell_Simulation_Pack.cs:153 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c131a89d | this.Load | FP00627_Cell_Simulation_Pack.cs:157 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7f7ad72d | this.Load | FP00627_Cell_Simulation_Pack.cs:158 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fd68d489 | this.Load | FP00627_Cell_Simulation_Pack.cs:162 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-e5e8b140 | this.Load | FP00627_Cell_Simulation_Pack.cs:174 | if (IgnoreSearchCondition == true) | DATA_OP | ManualSearchCondition.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a93e375c | this.Load | FP00627_Cell_Simulation_Pack.cs:177 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | CALL_EXT | ManualSearchCondition.Tables[0].AsEnumerable().Where(a => a.Field<string>("ControlName").E… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e55dee7 | this.Load | FP00627_Cell_Simulation_Pack.cs:177 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | DATA_OP | ManualSearchCondition.Tables[0].AsEnumerable().Where(a => a.Field<string>("ControlName").E… | (a => a.Field<string>("ControlValue")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e1d1d65 | this.Load | FP00627_Cell_Simulation_Pack.cs:177 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | DATA_OP | a.Field | ("ControlName") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ad6c699 | this.Load | FP00627_Cell_Simulation_Pack.cs:177 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | DATA_OP | a.Field | ("ControlValue") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cc237d4 | this.Load | FP00627_Cell_Simulation_Pack.cs:182 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | FLAG | _FormSearchProcedure | "PR_UI_FP00627_CELL_SIMULATION_PACK_SIMPOPUP" | 화면 필드/플래그 변경 |  |  |  |
| AC-2e457c49 | this.Load | FP00627_Cell_Simulation_Pack.cs:184 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | VALUE_SET | lblPlanId.Text | "Simulation ID" | 컨트롤 값 설정 |  |  |  |
| AC-d1c3bd86 | this.Load | FP00627_Cell_Simulation_Pack.cs:185 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | STATE | chk_release.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-104d0c52 | this.Load | FP00627_Cell_Simulation_Pack.cs:186 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "SIM_PLAN_ID").T… | UI_PROP | lblRelease.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e651c3ae | this.Load | FP00627_Cell_Simulation_Pack.cs:192 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-88694e2f | this.Load | FP00627_Cell_Simulation_Pack.cs:197 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-84b3b887 | this.Load | FP00627_Cell_Simulation_Pack.cs:199 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-95052c3b | this.Load | FP00627_Cell_Simulation_Pack.cs:199 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00627_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ef4696f2 | this.Load | FP00627_Cell_Simulation_Pack.cs:201 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-b7780b4c | this.Load | FP00627_Cell_Simulation_Pack.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-449e7454 | this.Load | FP00627_Cell_Simulation_Pack.cs:206 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-29c3c92a | this.Load | FP00627_Cell_Simulation_Pack.cs:208 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fb3ea297 | this.Load | FP00627_Cell_Simulation_Pack.cs:208 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00627_Cell_Simulation_Pack.InitSpread

진입점: this.Load / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02da339b | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:565 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a20d0e52 | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:566 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a6012719 | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:568 | try | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-e87dbb6e | this.Load 외 3 | FP00627_Cell_Simulation_Pack.cs:572 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00627_Cell_Simulation_Pack.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3eee1520 | InsertButton | FP00627_Cell_Simulation_Pack.cs:956 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00627_Cell_Simulation_Pack.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltere…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0663a0c8 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:611 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-21953ae9 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:612 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-82a299ea | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:613 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-bf549002 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:614 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-3dc7fdbc | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:629 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d77ad814 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:632 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-74aa7110 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:633 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fedf60b5 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:637 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9a7910b | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:638 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05137159 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:640 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5630fe2 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:641 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-268dc1ca | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:643 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-2498757a | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:651 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33057446 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:656 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d510c9b6 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:658 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fdf717a1 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:694 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-1ef1f691 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:713 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b4f0ad2 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:717 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-db4c3061 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:719 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-55ac46c7 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:723 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-028e5cd1 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:738 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-a4de9e52 | this.Load [try ▸ else of (monthInfo == null)] 외 4 | FP00627_Cell_Simulation_Pack.cs:753 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00627_Cell_Simulation_Pack.RefreshHeaderOnly

진입점: this.Load [try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc70e859 | this.Load [try] 외 4 | FP00627_Cell_Simulation_Pack.cs:766 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-83ae8b87 | this.Load [try] 외 4 | FP00627_Cell_Simulation_Pack.cs:767 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-7bba423f | this.Load [try] 외 4 | FP00627_Cell_Simulation_Pack.cs:768 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6236421 | this.Load [try] 외 4 | FP00627_Cell_Simulation_Pack.cs:769 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35e3151c | this.Load [try] 외 4 | FP00627_Cell_Simulation_Pack.cs:770 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00627_Cell_Simulation_Pack.RefreshSpreadSheet

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-051d2b53 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1315 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-06123d12 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 3 | FP00627_Cell_Simulation_Pack.cs:1321 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00627_Cell_Simulation_Pack.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ec90098 | popSql.OnSql | FP00627_Cell_Simulation_Pack.cs:1406 | if (programID == _FormSearchProcedure) | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-0686300d | popSql.OnSql | FP00627_Cell_Simulation_Pack.cs:1408 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.SetCurrentDate

진입점: this.Load / cboInstance.SelectedIndexChanged / chk_release.CheckedChanged [if (chk_release.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff5bf0ea | this.Load 외 2 | FP00627_Cell_Simulation_Pack.cs:384 |  | VALUE_SET | drpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |

## FP00627_Cell_Simulation_Pack.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ab6d06b | this.Load | FP00627_Cell_Simulation_Pack.cs:112 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6a32f47 | this.Load | FP00627_Cell_Simulation_Pack.cs:114 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a635c238 | this.Load | FP00627_Cell_Simulation_Pack.cs:118 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7c9e6f30 | this.Load | FP00627_Cell_Simulation_Pack.cs:120 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00627_Cell_Simulation_Pack.SetFilter

진입점: this.Load / cboInstance.SelectedIndexChanged [if (dtInstance.Good())] / cboPlanId.SelectedIndexChanged [if (cboPlanId.SelectedIndex > -1)] / edtTopItemId.TextChanged / edtItem.TextChanged / edtNickName.TextChanged / edtModelNickName.TextChanged / edtCellGroup.TextChanged / drpPeriod.ValueChanged / drpPlanDate.ValueChanged / chk_release.CheckedChanged [if (chk_release.Checked)] / popSql.OnSql [if (programID == _FormSearchProcedure) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-594f73df | this.Load 외 14 | FP00627_Cell_Simulation_Pack.cs:1355 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00627_Cell_Simulation_Pack.SetSpreadInit

진입점: this.Load [try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d1581e9 | this.Load [try] 외 3 | FP00627_Cell_Simulation_Pack.cs:580 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82beec2b | this.Load [try] 외 3 | FP00627_Cell_Simulation_Pack.cs:581 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00627_Cell_Simulation_Pack.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd309426 | this.spdMain.CellClick | FP00627_Cell_Simulation_Pack.cs:1557 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e44d9c13 | this.spdMain.CellDoubleClick | FP00627_Cell_Simulation_Pack.cs:1550 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e3dd92e | this.spdMain.EditModeOn | FP00627_Cell_Simulation_Pack.cs:1720 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00627_Cell_Simulation_Pack.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af283885 | this.spdMain.TableChanged | FP00627_Cell_Simulation_Pack.cs:1532 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f3c6792 | this.spdMain.TableChanged | FP00627_Cell_Simulation_Pack.cs:1534 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3f7b53d | this.spdMain.TextChanged | FP00627_Cell_Simulation_Pack.cs:1515 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6422b2e | this.spdMain.TextChanged | FP00627_Cell_Simulation_Pack.cs:1517 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00627_Cell_Simulation_Pack.UIFindData

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b45d381 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:834 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0337bc7 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:835 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e64460d1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:838 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-42b1a08d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:841 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-c8cacfe8 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:847 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) ▸ if (!Filter["POPUP_OPEN"].ToString().Equals("Y")) | VALUE_SET | chk_release.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-36b047ac | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:854 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]) && !Filter["RELEASE_FLAG"].ToString().Equals("Y")) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-aba8b8ed | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:856 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]) && !Filter["RELEASE_FLAG"].ToString().Equals("Y")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a78af3b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:860 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7aae143a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:867 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-43812d64 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:877 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sInstance == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a89adc38 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:878 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sInstance == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8621fdd2 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:885 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-daf90162 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:886 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-eba7b4c4 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:889 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f6bf231f | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:900 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-f74a0ad7 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:900 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99ae4e19 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:905 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8eddfec | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:909 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b65edb8b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:919 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3d4100d1 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:923 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f4bc7a42 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:929 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a7bb5d7d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:931 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f29942f8 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:937 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-52bd87d0 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:943 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-dccc2918 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00627_Cell_Simulation_Pack.cs:947 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00627_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78dee493 | .ctor | FP00627_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-f70aff82 | .ctor | FP00627_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f2356a2e | .ctor | FP00627_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-0bba5ee1 | .ctor | FP00627_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00627_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6d5e81d | Dispose | FP00627_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00627_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9663e1ee | this.Load | FP00627_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00627_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-723eb3f7 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:174 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-f73d60ed | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:181 |  | DATA_OP | ctrls.Add | (chk_plan) | 데이터 객체 조작/조회 |  |  |  |
| AC-d52bdb50 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:182 |  | DATA_OP | ctrls.Add | (chk_eoh_moving) | 데이터 객체 조작/조회 |  |  |  |
| AC-820b585c | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:184 |  | DATA_OP | ctrls.Add | (chk_planSum) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c58ff7c | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:185 |  | DATA_OP | ctrls.Add | (chk_eoh_moving_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-9707b53b | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:187 |  | DATA_OP | ctrls.Add | (chk_rec_inHouse) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcf93448 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:188 |  | DATA_OP | ctrls.Add | (chk_eoh_eol) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcc6d2df | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:190 |  | DATA_OP | ctrls.Add | (chk_shipmentResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-6945efe1 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:191 |  | DATA_OP | ctrls.Add | (chk_eoh_uninspection) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a935f5b | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:193 |  | DATA_OP | ctrls.Add | (chk_EOL) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9c4a561 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:194 |  | DATA_OP | ctrls.Add | (chk_eoh_eol_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-34c94b7c | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:196 |  | DATA_OP | ctrls.Add | (chk_productionResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-896ebc53 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:197 |  | DATA_OP | ctrls.Add | (chk_eoh_cell_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ab494fc | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:199 |  | DATA_OP | ctrls.Add | (chk_eoh_cell_total_hold) | 데이터 객체 조작/조회 |  |  |  |
| AC-7505a821 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:201 |  | DATA_OP | ctrls.Add | (chk_rec_CMI) | 데이터 객체 조작/조회 |  |  |  |
| AC-50f4691f | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:202 |  | DATA_OP | ctrls.Add | (chk_rec_CWA) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e251897 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:204 |  | DATA_OP | ctrls.Add | (chk_rec_CNA) | 데이터 객체 조작/조회 |  |  |  |
| AC-88163f96 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:205 |  | DATA_OP | ctrls.Add | (chk_rec_OC) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff2e85c6 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:207 |  | DATA_OP | ctrls.Add | (chk_rec_CNB) | 데이터 객체 조작/조회 |  |  |  |
| AC-680d0555 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:208 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-48b66f28 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:213 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-05e42aab | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:213 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-9295c3ce | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:220 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-b811d6cb | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:224 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00627_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcfe9b31 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:127 |  | VALUE_SET | chk_plan.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ce03edd9 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:128 |  | VALUE_SET | chk_eoh_moving.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b5ed7acf | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_planSum.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-461b5b06 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_eoh_moving_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e2f109af | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:133 |  | VALUE_SET | chk_rec_inHouse.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-51ae301e | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_eoh_eol.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ad4cd5ac | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_shipmentResult.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6870df6c | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_eoh_uninspection.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bdc49669 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_EOL.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1d07c7ae | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_eoh_eol_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d2309a93 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_productionResult.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d1138c97 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_eoh_cell_total.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-44c850ce | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_eoh_cell_total_hold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0ef43f6a | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_rec_CMI.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-afb97863 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_rec_CWA.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1b68c27b | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_rec_CNA.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bc56251c | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_rec_OC.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1869eaf2 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_rec_CNB.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a6129dc8 | this.Load 외 1 | FP00627_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_total.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00627_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8f8b4be | (진입점 미연결) | FP00627_MeasureSetForm_Popup.cs:287 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-1cefb7bb | (진입점 미연결) | FP00627_MeasureSetForm_Popup.cs:298 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad248fad | (진입점 미연결) | FP00627_MeasureSetForm_Popup.cs:309 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00627_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d41d9d8 | this.Load | FP00627_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-dab38033 | this.Load | FP00627_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00627_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5de169ae | this.usrButton1.Click | FP00627_MeasureSetForm_Popup.cs:271 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-d2369ce3 | this.usrButton1.Click | FP00627_MeasureSetForm_Popup.cs:271 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-93e92eca | this.usrButton1.Click | FP00627_MeasureSetForm_Popup.cs:273 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-720d5649 | this.usrButton1.Click | FP00627_MeasureSetForm_Popup.cs:277 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-9d59d0a4 | this.usrButton1.Click | FP00627_MeasureSetForm_Popup.cs:278 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-4da1e0aa | this.usrButton1.Click | FP00627_MeasureSetForm_Popup.cs:280 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-14dd9146 | this.usrButton1.Click | FP00627_MeasureSetForm_Popup.cs:282 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00627_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d9be376 | this.usrButton2.Click | FP00627_MeasureSetForm_Popup.cs:245 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-e7dd3fce | this.usrButton2.Click | FP00627_MeasureSetForm_Popup.cs:245 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-e4dba4c4 | this.usrButton2.Click | FP00627_MeasureSetForm_Popup.cs:247 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-0ded14f0 | this.usrButton2.Click | FP00627_MeasureSetForm_Popup.cs:251 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-37757a7f | this.usrButton2.Click | FP00627_MeasureSetForm_Popup.cs:252 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-a9cc20e8 | this.usrButton2.Click | FP00627_MeasureSetForm_Popup.cs:253 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-bf982bac | this.usrButton2.Click | FP00627_MeasureSetForm_Popup.cs:254 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

