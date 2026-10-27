# AS-IS 액션 대조표 — FPC0103

> 원천: `Doc/asisfacts/screens/FPC0103/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 141행 · 메서드 17 · 종류 DATA_OP 40 · UI_PROP 24 · ENDPOINT 17 · UI_MISC 13 · FLAG 10 · CALL_EXT 10 · MESSAGE 9 · RETURN 5 · VALUE_SET 4 · POPUP 2 · LIST_REBIND 2 · GRID_INIT 2 · COMBO_DATA 1 · GRID_SET 1 · THROW 1 · ⚠ 의미 확인 필요 10


## FPC0103_DWSubmit..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b04eb6f2 | .ctor | FPC0103_DWSubmit.cs:118 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-11c869e0 | .ctor | FPC0103_DWSubmit.cs:119 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f7cdbd19 | .ctor | FPC0103_DWSubmit.cs:128 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-21b14bc6 | .ctor | FPC0103_DWSubmit.cs:129 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |

## FPC0103_DWSubmit.btnOK_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2798ed0c | (진입점 미연결) | FPC0103_DWSubmit.cs:564 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-2661f8fc | (진입점 미연결) | FPC0103_DWSubmit.cs:565 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0103_DWSubmit.btnOK_Click_1

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02893830 | this.btnOK.Click | FPC0103_DWSubmit.cs:666 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-7f56f3dd | this.btnOK.Click | FPC0103_DWSubmit.cs:667 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0103_DWSubmit.clbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5351be6f | clbOperation.SelectedIndexChanged | FPC0103_DWSubmit.cs:534 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FPC0103_DWSubmit.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07bd1ac1 | this.Load | FPC0103_DWSubmit.cs:265 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0103_DWSubmit.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5fb3833 | Dispose | FPC0103_DWSubmit.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0103_DWSubmit.FindData

진입점: this.Load / drPeriod.ValueChanged [if (!error)] / cbWpp.CheckedChanged [if (dtListPeriod.Good())] / cbMpp.CheckedChanged [if (dtListPeriod.Good())] / clbOperation.SelectedIndexChanged / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19462eff | this.Load 외 5 | FPC0103_DWSubmit.cs:323 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-75a89d33 | this.Load 외 5 | FPC0103_DWSubmit.cs:324 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-250887f8 | this.Load 외 5 | FPC0103_DWSubmit.cs:331 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-125721c3 | this.Load 외 5 | FPC0103_DWSubmit.cs:332 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-98711ecc | this.Load 외 5 | FPC0103_DWSubmit.cs:333 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-798ec8d8 | this.Load 외 5 | FPC0103_DWSubmit.cs:334 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9159c750 | this.Load 외 5 | FPC0103_DWSubmit.cs:337 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7d320576 | this.Load 외 5 | FPC0103_DWSubmit.cs:342 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-7612449f | this.Load 외 5 | FPC0103_DWSubmit.cs:344 |  | CALL_EXT | AmendService.FindDwpSubmit | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d9b1a97 | this.Load 외 5 | FPC0103_DWSubmit.cs:349 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-31e6c108 | this.Load 외 5 | FPC0103_DWSubmit.cs:350 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-e3070c17 | this.Load 외 5 | FPC0103_DWSubmit.cs:351 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-9bab53c5 | this.Load 외 5 | FPC0103_DWSubmit.cs:373 | if (ds.Good()) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-3f5abf57 | this.Load 외 5 | FPC0103_DWSubmit.cs:375 | if (ds.Good()) | FLAG | dtDWSubmitData | Data_FP.CallGeneralProcedure2(("PR_UI_FPC0103_DWSUBMIT").ToUpper(), Filter, UserInfoContex… | 화면 필드/플래그 변경 |  |  |  |
| AC-561cd425 | this.Load 외 5 | FPC0103_DWSubmit.cs:375 | if (ds.Good()) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FPC0103_DWSUBMIT").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b7441d47 | this.Load 외 5 | FPC0103_DWSubmit.cs:379 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0103_DWSubmit.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9943b2d6 | this.Load | FPC0103_DWSubmit.cs:141 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-db7da88f | this.Load | FPC0103_DWSubmit.cs:143 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0103_DWSubmit.GetLine

진입점: this.Load / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9b20c22 | this.Load 외 1 | FPC0103_DWSubmit.cs:540 |  | DATA_OP | Filter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-535cf265 | this.Load 외 1 | FPC0103_DWSubmit.cs:542 |  | FLAG | dtLine | Data_FP.CallGeneralProcedure2(("PR_UI_FPC0103_DWSUBMIT").ToUpper(), Filter, UserInfoContex… | 화면 필드/플래그 변경 |  |  |  |
| AC-269f8807 | this.Load 외 1 | FPC0103_DWSubmit.cs:542 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FPC0103_DWSUBMIT").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-eb73d6a1 | this.Load 외 1 | FPC0103_DWSubmit.cs:543 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0bc46041 | this.Load 외 1 | FPC0103_DWSubmit.cs:544 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FPC0103_DWSubmit.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b9d0ee8 | this.Load | FPC0103_DWSubmit.cs:163 |  | UI_PROP | this.Height | 220 | 속성 Height 설정 |  |  |  |
| AC-6b289376 | this.Load | FPC0103_DWSubmit.cs:164 |  | UI_PROP | this.Width | 800 | 속성 Width 설정 |  |  |  |
| AC-f424fec1 | this.Load | FPC0103_DWSubmit.cs:168 | if (Filter["SUBMIT_TYPE"] == "PACK") | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_FP00600_ETC").ToUpper(), Filter, UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-c82727bd | this.Load | FPC0103_DWSubmit.cs:168 | if (Filter["SUBMIT_TYPE"] == "PACK") | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00600_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "OPERA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-10093083 | this.Load | FPC0103_DWSubmit.cs:172 | else of (Filter["SUBMIT_TYPE"] == "PACK") | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").To… | 화면 필드/플래그 변경 |  |  |  |
| AC-9930bb31 | this.Load | FPC0103_DWSubmit.cs:172 | else of (Filter["SUBMIT_TYPE"] == "PACK") | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").ToUpper(), Filter, UserInfoCont… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-54437717 | this.Load | FPC0103_DWSubmit.cs:175 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3f68e591 | this.Load | FPC0103_DWSubmit.cs:176 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7f1bfabd | this.Load | FPC0103_DWSubmit.cs:178 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-84e2eaff | this.Load | FPC0103_DWSubmit.cs:181 | if (ds_isCurrWeek.Good()) | DATA_OP | Filter["CURR_DATE"] | ds_isCurrWeek.Tables[0].Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5dabad08 | this.Load | FPC0103_DWSubmit.cs:185 | else of (ds_isCurrWeek.Good()) | DATA_OP | Filter["CURR_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-56d98c92 | this.Load | FPC0103_DWSubmit.cs:190 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-122eaadd | this.Load | FPC0103_DWSubmit.cs:201 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_AMEND_LIMIT_YN == "Y") | DATA_OP | Filter["CURR_DATE"] | _AMEND_LIMIT_DATE2 | 행/컬럼 값 대입 |  |  |  |
| AC-9a0dfad2 | this.Load | FPC0103_DWSubmit.cs:206 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-5b8a2fed | this.Load | FPC0103_DWSubmit.cs:207 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XPCommonAmend", "findPeriod_DWSubmit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c71ca6fd | this.Load | FPC0103_DWSubmit.cs:210 | if (dtListPeriod.Good()) | DATA_OP | Filter["START_DATE"] | dtListPeriod.GetFirst("START_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-fa6e4927 | this.Load | FPC0103_DWSubmit.cs:210 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("START_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b65ec3ac | this.Load | FPC0103_DWSubmit.cs:212 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["START_DATE"])) | DATA_OP | Filter["BUCKET_FROM"] | Filter["START_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-558941d4 | this.Load | FPC0103_DWSubmit.cs:213 | if (dtListPeriod.Good()) | DATA_OP | Filter["END_DATE"] | dtListPeriod.GetFirst("END_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-e83f1f20 | this.Load | FPC0103_DWSubmit.cs:213 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("END_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6416bb7 | this.Load | FPC0103_DWSubmit.cs:215 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["END_DATE"])) | DATA_OP | Filter["BUCKET_TO"] | Filter["END_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-34b7c718 | this.Load | FPC0103_DWSubmit.cs:220 | if (Filter["BUCKET_FROM"] ==string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-611b30d2 | this.Load | FPC0103_DWSubmit.cs:221 | if (Filter["BUCKET_FROM"] ==string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-4b3cfbba | this.Load | FPC0103_DWSubmit.cs:225 | else of (Filter["BUCKET_FROM"] ==string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-1dee47f1 | this.Load | FPC0103_DWSubmit.cs:228 | else of (Filter["BUCKET_FROM"] ==string.Empty) ▸ if (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-099b3367 | this.Load | FPC0103_DWSubmit.cs:231 | else of (Filter["BUCKET_FROM"] ==string.Empty) ▸ else of (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-8cde0e0a | this.Load | FPC0103_DWSubmit.cs:255 | else of (drPeriod.Value2.Date > DateTime.Now.Date) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-00823b08 | this.Load | FPC0103_DWSubmit.cs:256 | else of (drPeriod.Value2.Date > DateTime.Now.Date) | DATA_OP | Filter["BUCKET_TO"] | drPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7f3ca45d | this.Load | FPC0103_DWSubmit.cs:258 |  | VALUE_SET | cbWpp.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-562cff93 | this.Load | FPC0103_DWSubmit.cs:259 |  | VALUE_SET | cbMpp.Checked | false | 컨트롤 값 설정 |  |  |  |

## FPC0103_DWSubmit.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9c40eb5 | this.Load | FPC0103_DWSubmit.cs:270 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1352509e | this.Load | FPC0103_DWSubmit.cs:271 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FPC0103_DWSubmit.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e07eee3 | (진입점 미연결) | FPC0103_DWSubmit.cs:280 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-cbe46f78 | (진입점 미연결) | FPC0103_DWSubmit.cs:282 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

## FPC0103_DWSubmit.Mpp_CheckedChanged

진입점: cbMpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95263112 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:599 | if (chk) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-057c1bd6 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:601 | else of (chk) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-5fce5005 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:603 |  | VALUE_SET | cbWpp.Checked | !chk | 컨트롤 값 설정 |  |  |  |
| AC-33924fce | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:605 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XPCommonAmend", "findPeriod_DWSubmit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2cf9fb42 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:609 | if (dtListPeriod.Good()) | DATA_OP | Filter["START_DATE"] | dtListPeriod.GetFirst("START_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-d475b10d | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:609 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("START_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0b78a4b | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:611 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["START_DATE"])) | DATA_OP | Filter["BUCKET_FROM"] | Filter["START_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d42bb332 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:612 | if (dtListPeriod.Good()) | DATA_OP | Filter["END_DATE"] | dtListPeriod.GetFirst("END_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-846d2305 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:612 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("END_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-db332624 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:614 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["END_DATE"])) | DATA_OP | Filter["BUCKET_TO"] | Filter["END_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-40f7b2fb | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:616 | if (dtListPeriod.Good()) | UI_PROP | drPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-af13cc35 | cbMpp.CheckedChanged | FPC0103_DWSubmit.cs:617 | if (dtListPeriod.Good()) | UI_PROP | drPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FPC0103_DWSubmit.ParamDictionaryToTable

진입점: this.btnOK.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f3b7d7f | this.btnOK.Click [try] | FPC0103_DWSubmit.cs:498 |  | UI_PROP | paramTable.TableName | "param" | 속성 TableName 설정 |  |  |  |
| AC-1a698b25 | this.btnOK.Click [try] | FPC0103_DWSubmit.cs:501 | foreach (KeyValuePair<string, object> eachParam in dictParam) | DATA_OP | paramTable.Columns.Add | (new DataColumn(AttachPrefix + eachParam.Key, typeof(System.String))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3f4f2a3 | this.btnOK.Click [try] | FPC0103_DWSubmit.cs:503 |  | DATA_OP | paramTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d6e33f6 | this.btnOK.Click [try] | FPC0103_DWSubmit.cs:506 | foreach (KeyValuePair<string, object> eachParam in dictParam) | DATA_OP | row[AttachPrefix + eachParam.Key] | eachParam.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f638c5f1 | this.btnOK.Click [try] | FPC0103_DWSubmit.cs:508 |  | DATA_OP | paramTable.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-16229836 | this.btnOK.Click [try] | FPC0103_DWSubmit.cs:509 |  | RETURN | return paramTable; |  | 처리 중단/반환 |  |  |  |

## FPC0103_DWSubmit.period_ValueChanged

진입점: drPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1da89e12 | drPeriod.ValueChanged | FPC0103_DWSubmit.cs:627 |  | CALL_EXT | DateTime.TryParseExact | (Filter["CURR_DATE"], "yyyyMMdd", null, System.Globalization.DateTimeStyles.None,out currD… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a80a439 | drPeriod.ValueChanged | FPC0103_DWSubmit.cs:634 | if (drPeriod.Value1 < currDate) | MESSAGE | MessageBox.Show | ("Out of plan period") | 메시지 표시 |  |  |  |
| AC-2251f096 | drPeriod.ValueChanged | FPC0103_DWSubmit.cs:635 | if (drPeriod.Value1 < currDate) | UI_PROP | drPeriod.Text1 | Filter["BUCKET_FROM"] | 속성 Text1 설정 |  |  |  |
| AC-87fc2278 | drPeriod.ValueChanged | FPC0103_DWSubmit.cs:640 | else of (drPeriod.Value1 < currDate) ▸ if (drPeriod.Value2.ToString("yyyyMMdd") != Filter["BUCKET_TO"]) | MESSAGE | MessageBox.Show | ("The end date can not be changed") | 메시지 표시 |  |  |  |
| AC-a51e4f4d | drPeriod.ValueChanged | FPC0103_DWSubmit.cs:641 | else of (drPeriod.Value1 < currDate) ▸ if (drPeriod.Value2.ToString("yyyyMMdd") != Filter["BUCKET_TO"]) | UI_PROP | drPeriod.Text2 | Filter["BUCKET_TO"] | 속성 Text2 설정 |  |  |  |
| AC-68733c32 | drPeriod.ValueChanged | FPC0103_DWSubmit.cs:647 | if (!error) | DATA_OP | Filter["BUCKET_FROM"] | drPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-89f35f34 | drPeriod.ValueChanged | FPC0103_DWSubmit.cs:648 | if (!error) | DATA_OP | Filter["BUCKET_TO"] | drPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FPC0103_DWSubmit.SaveData

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa73e8a1 | this.btnOK.Click | FPC0103_DWSubmit.cs:394 | try ▸ if (!dtDWSubmitData.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-0433189d | this.btnOK.Click | FPC0103_DWSubmit.cs:395 | try ▸ if (!dtDWSubmitData.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e081af5 | this.btnOK.Click | FPC0103_DWSubmit.cs:398 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-540bc9d2 | this.btnOK.Click | FPC0103_DWSubmit.cs:401 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4330d118 | this.btnOK.Click | FPC0103_DWSubmit.cs:403 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | ds_isCurrWeek.Tables[0].getColumn | (0, "IS_LATEST_PLAN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c4a55143 | this.btnOK.Click | FPC0103_DWSubmit.cs:408 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (sIsLatestPlan != "Y") | DATA_OP | ds_isCurrWeek.Tables[0].getColumn | (0, "RELEASE_PLAN_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-25e00e59 | this.btnOK.Click | FPC0103_DWSubmit.cs:409 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (sIsLatestPlan != "Y") | DATA_OP | ds_isCurrWeek.Tables[0].getColumn | (0, "RELEASE_VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f39f0c48 | this.btnOK.Click | FPC0103_DWSubmit.cs:410 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (sIsLatestPlan != "Y") | MESSAGE | MessageBox.Show | (sMsg) | 메시지 표시 |  |  |  |
| AC-2041a05f | this.btnOK.Click | FPC0103_DWSubmit.cs:411 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (sIsLatestPlan != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43b05515 | this.btnOK.Click | FPC0103_DWSubmit.cs:415 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d4c000d0 | this.btnOK.Click | FPC0103_DWSubmit.cs:416 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5154cd15 | this.btnOK.Click | FPC0103_DWSubmit.cs:418 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_saveAuth", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveAuth] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0cc1f948 | this.btnOK.Click | FPC0103_DWSubmit.cs:419 | try | DATA_OP | ds_saveChk.getColumn | (0, "_VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0dda870f | this.btnOK.Click | FPC0103_DWSubmit.cs:422 | try ▸ if (string.IsNullOrEmpty(sAuthYN)) | MESSAGE | MessageBox.Show | ("No save permission.") | 메시지 표시 |  |  |  |
| AC-3379275a | this.btnOK.Click | FPC0103_DWSubmit.cs:423 | try ▸ if (string.IsNullOrEmpty(sAuthYN)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f03422b6 | this.btnOK.Click | FPC0103_DWSubmit.cs:426 | try | MESSAGE | MessageBox.Show | ("All data which is shown in Release version will be sent to DW for " + sType + ".", "Wari… | 메시지 표시 |  |  |  |
| AC-4c34a832 | this.btnOK.Click | FPC0103_DWSubmit.cs:429 | try ▸ if (MessageBox.Show("All data which is shown in Release version will be sent to DW for " + sType + ".", "Warinng", MessageBo…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-776a9dfc | this.btnOK.Click | FPC0103_DWSubmit.cs:433 | try | DATA_OP | Filter["_SEQ"] | Filter["CALL_SEQUENCE"] = AmendService.FindNewSeq(Filter) | 행/컬럼 값 대입 |  |  |  |
| AC-9183469c | this.btnOK.Click | FPC0103_DWSubmit.cs:433 | try | DATA_OP | Filter["CALL_SEQUENCE"] | AmendService.FindNewSeq(Filter) | 행/컬럼 값 대입 |  |  |  |
| AC-17aa8609 | this.btnOK.Click | FPC0103_DWSubmit.cs:433 | try | CALL_EXT | AmendService.FindNewSeq | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df2fa866 | this.btnOK.Click | FPC0103_DWSubmit.cs:435 | try | DATA_OP | dtDWSubmitData.Columns.Add | ("CALL_SEQUENCE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d214151d | this.btnOK.Click | FPC0103_DWSubmit.cs:440 | try ▸ foreach (DataRow row in dtDWSubmitData.Rows) | GRID_SET | dtDWSubmitData.Rows[i]["CALL_SEQUENCE"] | Filter["_SEQ"] | 그리드 속성/값 설정 |  |  |  |
| AC-57e2ba57 | this.btnOK.Click | FPC0103_DWSubmit.cs:443 | try ▸ foreach (DataRow row in dtDWSubmitData.Rows) ▸ if (row.RowState == DataRowState.Unchanged) | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe8909a2 | this.btnOK.Click | FPC0103_DWSubmit.cs:449 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("XpCommonAmend", "insert_DWSubmit", dtDWSubmitData) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_DWSubmit] \| FP\Common\Xp… | 엔드포인트 호출 |  |  |  |
| AC-e9efac2f | this.btnOK.Click | FPC0103_DWSubmit.cs:452 | try | DATA_OP | Filter["FP_SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d925691 | this.btnOK.Click | FPC0103_DWSubmit.cs:453 | try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-16871dca | this.btnOK.Click | FPC0103_DWSubmit.cs:454 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-17cb8060 | this.btnOK.Click | FPC0103_DWSubmit.cs:458 | try | ENDPOINT | DataService.FP_RunProcedure | ("XpCommonAmend", "executeSubmit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSubmit] \| FP\Common\X… | 엔드포인트 호출 |  |  |  |
| AC-0262624c | this.btnOK.Click | FPC0103_DWSubmit.cs:466 | try ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-13ab83b2 | this.btnOK.Click | FPC0103_DWSubmit.cs:467 | try ▸ try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "update_Submit_Flag", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_Submit_Flag] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-fc7ab5b1 | this.btnOK.Click | FPC0103_DWSubmit.cs:470 | try ▸ try ▸ if (res.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { res.Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73cba98c | this.btnOK.Click | FPC0103_DWSubmit.cs:473 | try ▸ try ▸ else of (res.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65a7cbce | this.btnOK.Click | FPC0103_DWSubmit.cs:477 | try ▸ try | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-470764e1 | this.btnOK.Click | FPC0103_DWSubmit.cs:481 | try ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Save Fail :" + e.Message) | 메시지 표시 |  |  |  |
| AC-4c28328d | this.btnOK.Click | FPC0103_DWSubmit.cs:486 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |
| AC-64a781f1 | this.btnOK.Click | FPC0103_DWSubmit.cs:490 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0103_DWSubmit.Wpp_CheckedChanged

진입점: cbWpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ade6fe6e | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:572 | if (chk) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-93addf3a | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:574 | else of (chk) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-571eb856 | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:576 |  | VALUE_SET | cbMpp.Checked | !chk | 컨트롤 값 설정 |  |  |  |
| AC-fd2503da | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:578 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XPCommonAmend", "findPeriod_DWSubmit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b1654461 | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:582 | if (dtListPeriod.Good()) | DATA_OP | Filter["START_DATE"] | dtListPeriod.GetFirst("START_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-11906ffd | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:582 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("START_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90533ce3 | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:584 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["START_DATE"])) | DATA_OP | Filter["BUCKET_FROM"] | Filter["START_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-182e633d | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:585 | if (dtListPeriod.Good()) | DATA_OP | Filter["END_DATE"] | dtListPeriod.GetFirst("END_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-9b51a95d | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:585 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("END_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae94aa21 | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:587 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["END_DATE"])) | DATA_OP | Filter["BUCKET_TO"] | Filter["END_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d9871948 | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:589 | if (dtListPeriod.Good()) | UI_PROP | drPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-9b275caf | cbWpp.CheckedChanged | FPC0103_DWSubmit.cs:590 | if (dtListPeriod.Good()) | UI_PROP | drPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

