# AS-IS 액션 대조표 — FPC0125

> 원천: `Doc/asisfacts/screens/FPC0125/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 155행 · 메서드 19 · 종류 DATA_OP 40 · UI_PROP 24 · ENDPOINT 14 · FLAG 11 · GRID_SET 11 · MESSAGE 11 · RETURN 10 · UI_MISC 8 · CALL_EXT 7 · GRID_INIT 6 · VALUE_SET 4 · POPUP 2 · GRID_LOCK 2 · LIST_REBIND 2 · GRID_BIND 1 · COMBO_DATA 1 · THROW 1 · ⚠ 의미 확인 필요 7


## FPC0125_MWPPCopyDWSubmitPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-635fbf03 | .ctor | FPC0125_MWPPCopyDWSubmitPopup.cs:119 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-73d32029 | .ctor | FPC0125_MWPPCopyDWSubmitPopup.cs:120 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-409907f4 | .ctor | FPC0125_MWPPCopyDWSubmitPopup.cs:129 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-96ce6e39 | .ctor | FPC0125_MWPPCopyDWSubmitPopup.cs:130 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c2506ab | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:566 | if (this.DialogResult == DialogResult.OK) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.clbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fca7bcdd | clbLine.SelectedIndexChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:558 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.clbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ea9b5a4 | clbOperation.SelectedIndexChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:552 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c310070 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:285 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-423de616 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:286 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1201c7a6 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:287 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-055aecc9 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:274 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc4616fd | Dispose | FPC0125_MWPPCopyDWSubmitPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.FindData

진입점: this.Load / drPeriod.ValueChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c9c7232 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:333 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-46ab4382 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:334 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2df0243a | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:336 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a1e70c2a | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:337 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cdff79ff | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:338 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6f6e87d5 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:339 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-299c80dd | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:342 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b67e4862 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:344 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { string bulk_info = DataService.ToLoopParam("", bukInfo); Filter["BUCKET"] = bulk_… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-591d1805 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:347 | lambda | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-2a49fca0 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:349 | lambda | CALL_EXT | AmendService.FindWppCopy | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5fa595b | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:349 | lambda | RETURN | return AmendService.FindWppCopy(Filter); |  | 처리 중단/반환 |  |  |  |
| AC-ad45eeba | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:353 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-b86af18e | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:354 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-b40c1a50 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:355 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-af943aa2 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:357 |  | GRID_INIT | siMain.SetSheetHeaderDateColumn_FP | (calendar, false, false, true, 2, DateColumnType.DMPP) | 그리드 재구성/초기화 |  |  |  |
| AC-f986c877 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:360 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-f06b32d4 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:361 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-bece3eb9 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:362 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-779ea5fe | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:368 | if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | row["_CHK"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-4ef9364a | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:372 |  | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-8e6b7c8c | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:373 |  | CALL_EXT | siMain.SetMergeRange | (2, siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22fd90f2 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:374 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4d5d59ed | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:375 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-783c2f65 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:377 |  | GRID_LOCK | siMain.LockColumn | (0, max_col, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-109532ee | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:378 |  | GRID_LOCK | siMain.LockColumn | (0, 0, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a4db5f40 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:383 | foreach (FarPoint.Win.Spread.Row viewRow in siMain.ActiveSheet.Rows) | GRID_SET | siMain.ActiveSheet.Cells[index, 1].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-fcb658d2 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:387 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c8e9b197 | this.Load 외 4 | FPC0125_MWPPCopyDWSubmitPopup.cs:391 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7b11bb2 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:139 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0ffc3e5 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:141 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80737bf5 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:166 |  | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").To… | 화면 필드/플래그 변경 |  |  |  |
| AC-986da16b | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:166 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").ToUpper(), Filter, UserInfoCont… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f981c702 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:167 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e6138d7c | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:168 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e70197b4 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:170 |  | DATA_OP | Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3cfd1d87 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:171 |  | FLAG | dtLine | DataService.FP_ExecuteProcedure2("PR_UI_XPCOMMON_AMEND_FINDLINECODE_AMEND", Filter, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-0b18abc2 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:171 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_XPCOMMON_AMEND_FINDLINECODE_AMEND", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-545998b1 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:172 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1e564cb3 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:173 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cab07862 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:179 | if (Filter["BUCKET_FROM"] == string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-6f44dc4a | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:180 | if (Filter["BUCKET_FROM"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-805c2d89 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:184 | else of (Filter["BUCKET_FROM"] == string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-a474cb38 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:187 | else of (Filter["BUCKET_FROM"] == string.Empty) ▸ if (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-6f8faeda | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:190 | else of (Filter["BUCKET_FROM"] == string.Empty) ▸ else of (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-64bb1451 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:203 | else of (drPeriod.Value1.Date > DateTime.Now.Date) | UI_PROP | drPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-4a5b41d7 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:204 | else of (drPeriod.Value1.Date > DateTime.Now.Date) | DATA_OP | Filter["BUCKET_FROM"] | drPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a0be5a78 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:213 | else of (drPeriod.Value2.Date > DateTime.Now.Date) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-c96b8791 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:214 | else of (drPeriod.Value2.Date > DateTime.Now.Date) | DATA_OP | Filter["BUCKET_TO"] | drPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cd4fb0c3 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:218 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE", Filter[… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b3d8edd1 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:225 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) | FLAG | _AMEND_LIMIT_DATE2 | dtControl.Rows[0]["AMEND_LIMIT_DATE2"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f3f3dfe0 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:229 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_AMEND_LIMIT_YN == "Y") | FLAG | bControl | true | 화면 필드/플래그 변경 |  |  |  |
| AC-eac756e8 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:230 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_AMEND_LIMIT_YN == "Y") | DATA_OP | Filter["BUCKET_FROM"] | _AMEND_LIMIT_DATE2 | 행/컬럼 값 대입 |  |  |  |
| AC-af67142b | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:231 | if (dtControl != null) ▸ if (dtControl.Rows.Count > 0) ▸ if (_AMEND_LIMIT_YN == "Y") | UI_PROP | drPeriod.Value1 | DateTime.ParseExact(_AMEND_LIMIT_DATE2, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-489c0ec3 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:237 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-939796ba | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:238 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XPCommonAmend", "findPeriod_DWSubmit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPeriod_DWSubmit] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4745bd66 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:241 | if (dtListPeriod.Good()) | DATA_OP | Filter["START_DATE"] | dtListPeriod.GetFirst("START_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-9c6a6f4a | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:241 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("START_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffd414e6 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:243 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["START_DATE"])) | DATA_OP | Filter["BUCKET_FROM"] | Filter["START_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ceebcf92 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:244 | if (dtListPeriod.Good()) | DATA_OP | Filter["END_DATE"] | dtListPeriod.GetFirst("END_DATE") | 행/컬럼 값 대입 |  |  |  |
| AC-a6ca8e0e | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:244 | if (dtListPeriod.Good()) | CALL_EXT | dtListPeriod.GetFirst | ("END_DATE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-74f673d8 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:246 | if (dtListPeriod.Good()) ▸ if (!string.IsNullOrWhiteSpace(Filter["END_DATE"])) | DATA_OP | Filter["BUCKET_TO"] | Filter["END_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-798e3c78 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:251 | if (Filter["BUCKET_FROM"] == string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-93fe8356 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:252 | if (Filter["BUCKET_FROM"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-af2c331f | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:256 | else of (Filter["BUCKET_FROM"] == string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-f8f02a1c | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:259 | else of (Filter["BUCKET_FROM"] == string.Empty) ▸ if (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-af47580e | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:262 | else of (Filter["BUCKET_FROM"] == string.Empty) ▸ else of (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-32cb0aee | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:266 |  | VALUE_SET | cbWpp.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-805f0f52 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:267 |  | VALUE_SET | cbMpp.Checked | false | 컨트롤 값 설정 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34cb7f95 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:279 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-87542ff1 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:280 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f8539c9 | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:294 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-aaa46edd | this.Load | FPC0125_MWPPCopyDWSubmitPopup.cs:296 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.Mpp_CheckedChanged

진입점: cbMpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5797da0f | cbMpp.CheckedChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:640 | if (chk) | DATA_OP | Filter["MPP_WPP"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-eed436c2 | cbMpp.CheckedChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:642 | else of (chk) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-1d0a6284 | cbMpp.CheckedChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:643 |  | VALUE_SET | cbWpp.Checked | !chk | 컨트롤 값 설정 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.panel1_Resize

진입점: this.panel1.Resize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f656ecb | this.panel1.Resize | FPC0125_MWPPCopyDWSubmitPopup.cs:680 | try | UI_PROP | btnOK.Left | (int)((panel1.Size.Width - btnOK.Width) / 2) | 속성 Left 설정 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.period_ValueChanged

진입점: drPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d46410ec | drPeriod.ValueChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:658 | if (val1 < startDt) | UI_PROP | drPeriod.Value1 | startDt | 속성 Value1 설정 |  |  |  |
| AC-3eb108d3 | drPeriod.ValueChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:666 | if (bControl) ▸ if (drPeriod.Value1 < _fromDate) | UI_PROP | drPeriod.Value1 | _fromDate | 속성 Value1 설정 |  |  |  |
| AC-de8ef84c | drPeriod.ValueChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:670 |  | DATA_OP | Filter["BUCKET_FROM"] | drPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-47398eee | drPeriod.ValueChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:671 |  | DATA_OP | Filter["BUCKET_TO"] | drPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.SaveData

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08960d06 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:400 | if (!dtFindData.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-7f450aa7 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:401 | if (!dtFindData.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24a19182 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:404 |  | DATA_OP | dtFindData.Columns.Contains | ("_CHK") | 데이터 객체 조작/조회 |  |  |  |
| AC-49c847a6 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:406 | if (!dtFindData.Columns.Contains("_CHK")) | DATA_OP | dtFindData.Columns.Add | (new DataColumn("_CHK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6e91adc | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:419 | foreach (FarPoint.Win.Spread.Row viewRow in siMain.ActiveSheet.Rows) ▸ if (v != null && row != null) ▸ if (ok) | DATA_OP | row["_CHK"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-ffd5a178 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:423 | foreach (FarPoint.Win.Spread.Row viewRow in siMain.ActiveSheet.Rows) ▸ if (v != null && row != null) ▸ else of (ok) | DATA_OP | row["_CHK"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-752af7e2 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:429 | try | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b559311 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:431 | try ▸ if (dtFindData.Select("_CHK='Y'") == null) | MESSAGE | MessageBox.Show | ("You need to select data") | 메시지 표시 |  |  |  |
| AC-a5473c19 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:432 | try ▸ if (dtFindData.Select("_CHK='Y'") == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e31ded22 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:434 | try ▸ else of (dtFindData.Select("_CHK='Y'") == null) | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2801a64b | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:436 | try ▸ else of (dtFindData.Select("_CHK='Y'") == null) ▸ if (dtFindData.Select("_CHK='Y'").Count() == 0) | MESSAGE | MessageBox.Show | ("You need to select data") | 메시지 표시 |  |  |  |
| AC-a1fde341 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:437 | try ▸ else of (dtFindData.Select("_CHK='Y'") == null) ▸ if (dtFindData.Select("_CHK='Y'").Count() == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0a40751 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:439 | try ▸ else of (dtFindData.Select("_CHK='Y'") == null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) | DATA_OP | dtFindData.Select("_CHK='Y'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76634b1a | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:439 | try ▸ else of (dtFindData.Select("_CHK='Y'") == null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad17e3ff | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:441 | try ▸ else of (dtFindData.Select("_CHK='Y'") == null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) ▸ if (!dtFindData.Select("_CHK=… | MESSAGE | MessageBox.Show | ("You need to select data") | 메시지 표시 |  |  |  |
| AC-87934c04 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:442 | try ▸ else of (dtFindData.Select("_CHK='Y'") == null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) ▸ if (!dtFindData.Select("_CHK=… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-884e62f7 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:447 | try ▸ if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-07faa122 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:448 | try ▸ if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9493aba | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:451 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0e465b59 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:452 | try | DATA_OP | ds_isCurrWeek.Tables[0].getColumn | (0, "IS_LATEST_PLAN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-87ae6589 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:456 | try ▸ if (ds_isCurrWeek.Tables[0].getColumn(0, "IS_LATEST_PLAN").ToString() != "Y") | DATA_OP | ds_isCurrWeek.Tables[0].getColumn | (0, "RELEASE_PLAN_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-58f3d974 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:457 | try ▸ if (ds_isCurrWeek.Tables[0].getColumn(0, "IS_LATEST_PLAN").ToString() != "Y") | DATA_OP | ds_isCurrWeek.Tables[0].getColumn | (0, "RELEASE_VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d512844c | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:458 | try ▸ if (ds_isCurrWeek.Tables[0].getColumn(0, "IS_LATEST_PLAN").ToString() != "Y") | MESSAGE | MessageBox.Show | (sMsg) | 메시지 표시 |  |  |  |
| AC-93e7a629 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:459 | try ▸ if (ds_isCurrWeek.Tables[0].getColumn(0, "IS_LATEST_PLAN").ToString() != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dcd6b697 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:462 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_saveAuth", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_saveAuth] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9704eb20 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:463 | try | DATA_OP | ds_saveChk.getColumn | (0, "_VALUE") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-09226a32 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:465 | try ▸ if (string.IsNullOrEmpty(ds_saveChk.getColumn(0, "_VALUE").ToString())) | MESSAGE | MessageBox.Show | ("No save permission.") | 메시지 표시 |  |  |  |
| AC-b68fa5bc | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:466 | try ▸ if (string.IsNullOrEmpty(ds_saveChk.getColumn(0, "_VALUE").ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5806d109 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:470 | try | MESSAGE | MessageBox.Show | ("All data which is shown in Release version will be sent to DW for " + sType + ".", "Wari… | 메시지 표시 |  |  |  |
| AC-6891efac | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:473 | try ▸ if (MessageBox.Show("All data which is shown in Release version will be sent to DW for " + sType + ".", "Warinng", MessageBo…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-505b621f | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:476 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1484d12c | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:479 | try | CALL_EXT | AmendService.UpdateWppCopy | (Filter, dtFindData.Select("_CHK='Y'").CopyToDataTable()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9386a375 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:479 | try | DATA_OP | dtFindData.Select("_CHK='Y'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a7b896c | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:479 | try | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c4ac059 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:489 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FPC0103_DWSUBMIT").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fd1cd810 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:492 | try | DATA_OP | Filter["_SEQ"] | Filter["CALL_SEQUENCE"] = AmendService.FindNewSeq(Filter) | 행/컬럼 값 대입 |  |  |  |
| AC-43da1057 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:492 | try | DATA_OP | Filter["CALL_SEQUENCE"] | AmendService.FindNewSeq(Filter) | 행/컬럼 값 대입 |  |  |  |
| AC-62f020c4 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:492 | try | CALL_EXT | AmendService.FindNewSeq | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60447582 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:494 | try | DATA_OP | dtDWSubmitData.Columns.Add | ("CALL_SEQUENCE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f2c4a7f | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:498 | try ▸ foreach (DataRow row in dtDWSubmitData.Rows) | DATA_OP | row["CALL_SEQUENCE"] | Filter["_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-345e3b38 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:501 | try ▸ foreach (DataRow row in dtDWSubmitData.Rows) ▸ if (row.RowState == DataRowState.Unchanged) | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-93f451d1 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:505 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("XpCommonAmend", "insert_DWSubmit", dtDWSubmitData) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_DWSubmit] \| FP\Common\Xp… | 엔드포인트 호출 |  |  |  |
| AC-a12e018f | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:508 | try | DATA_OP | Filter["FP_SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4b6656de | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:510 | try | ENDPOINT | DataService.FP_RunProcedure | ("XpCommonAmend", "executeSubmit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=executeSubmit] \| FP\Common\X… | 엔드포인트 호출 |  |  |  |
| AC-060b896d | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:514 | try ▸ try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "update_Submit_Flag", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_Submit_Flag] \| FP\Co… | 엔드포인트 호출 |  |  |  |
| AC-45b1a5bd | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:516 | try ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aab89918 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:520 | try ▸ try ▸ if (res.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { res.Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c16633b | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:523 | try ▸ try ▸ else of (res.Good()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edcd3ce2 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:526 | try ▸ try | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e0cd3616 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:530 | try ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Save Fail :" + e.Message) | 메시지 표시 |  |  |  |
| AC-fb37af4f | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:533 | try | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-ea09cf0e | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:537 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |
| AC-77245733 | this.btnOK.Click | FPC0125_MWPPCopyDWSubmitPopup.cs:541 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6800ef17 | this.spdMain.CellClick | FPC0125_MWPPCopyDWSubmitPopup.cs:584 | if (e.Column == chk && e.ColumnHeader) ▸ if (head != null) | GRID_SET | spdMain.ActiveSheet.ColumnHeader.Cells[0, chk].Value | headtf | 그리드 속성/값 설정 |  |  |  |
| AC-8f0a14bd | this.spdMain.CellClick | FPC0125_MWPPCopyDWSubmitPopup.cs:588 | if (e.Column == chk && e.ColumnHeader) ▸ else of (head != null) | GRID_SET | spdMain.ActiveSheet.ColumnHeader.Cells[0, chk].Value | headtf | 그리드 속성/값 설정 |  |  |  |
| AC-b940e55e | this.spdMain.CellClick | FPC0125_MWPPCopyDWSubmitPopup.cs:591 | if (e.Column == chk && e.ColumnHeader) | GRID_SET | spdMain.ActiveSheet.Cells[0, chk, rowcount - 1, 1].Value | headtf | 그리드 속성/값 설정 |  |  |  |
| AC-42a29a40 | this.spdMain.CellClick | FPC0125_MWPPCopyDWSubmitPopup.cs:599 | else of (e.Column == chk && e.ColumnHeader) ▸ if (e.Column == chk && e.ColumnHeader == false && e.RowHeader == false) ▸ if (val == null) | GRID_SET | spdMain.ActiveSheet.Cells[e.Row, e.Column].Value | tf | 그리드 속성/값 설정 |  |  |  |
| AC-02ea3639 | this.spdMain.CellClick | FPC0125_MWPPCopyDWSubmitPopup.cs:605 | else of (e.Column == chk && e.ColumnHeader) ▸ if (e.Column == chk && e.ColumnHeader == false && e.RowHeader == false) ▸ else of (val == null… | GRID_SET | spdMain.ActiveSheet.Cells[e.Row, e.Column].Value | tf | 그리드 속성/값 설정 |  |  |  |
| AC-0d4254e9 | this.spdMain.CellClick | FPC0125_MWPPCopyDWSubmitPopup.cs:614 | else of (e.Column == chk && e.ColumnHeader) ▸ if (e.Column == chk && e.ColumnHeader == false && e.RowHeader == false) ▸ if (head != null) ▸ … | GRID_SET | spdMain.ActiveSheet.ColumnHeader.Cells[0, chk].Value | null | 그리드 속성/값 설정 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a47ae753 | this.spdMain.CellDoubleClick | FPC0125_MWPPCopyDWSubmitPopup.cs:622 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0125_MWPPCopyDWSubmitPopup.Wpp_CheckedChanged

진입점: cbWpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c6fd6dc | cbWpp.CheckedChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:630 | if (chk) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-104beb05 | cbWpp.CheckedChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:632 | else of (chk) | DATA_OP | Filter["MPP_WPP"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-01a644de | cbWpp.CheckedChanged | FPC0125_MWPPCopyDWSubmitPopup.cs:633 |  | VALUE_SET | cbMpp.Checked | !chk | 컨트롤 값 설정 |  |  |  |

