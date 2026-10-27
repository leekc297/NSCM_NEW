# AS-IS 액션 대조표 — FPC0102

> 원천: `Doc/asisfacts/screens/FPC0102/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 106행 · 메서드 19 · 종류 DATA_OP 26 · UI_PROP 18 · GRID_SET 11 · FLAG 9 · ENDPOINT 7 · GRID_INIT 6 · RETURN 6 · MESSAGE 5 · UI_MISC 4 · VALUE_SET 4 · CALL_EXT 3 · POPUP 2 · GRID_LOCK 2 · LIST_REBIND 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 3


## FPC0102_MWPPCopy..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cde7740 | .ctor | FPC0102_MWPPCopy.cs:118 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-34b96703 | .ctor | FPC0102_MWPPCopy.cs:119 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a0ade68f | .ctor | FPC0102_MWPPCopy.cs:128 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-3e8cbe3f | .ctor | FPC0102_MWPPCopy.cs:129 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |

## FPC0102_MWPPCopy.btnOK_Click_1

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6251bdf5 | this.btnOK.Click | FPC0102_MWPPCopy.cs:585 | if (this.DialogResult == DialogResult.OK) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0102_MWPPCopy.clbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cd41a2b | clbLine.SelectedIndexChanged | FPC0102_MWPPCopy.cs:464 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FPC0102_MWPPCopy.clbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ccad761 | clbOperation.SelectedIndexChanged | FPC0102_MWPPCopy.cs:458 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FPC0102_MWPPCopy.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3bb1974 | this.Load | FPC0102_MWPPCopy.cs:235 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bd49fd4a | this.Load | FPC0102_MWPPCopy.cs:236 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-14da77be | this.Load | FPC0102_MWPPCopy.cs:237 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0102_MWPPCopy.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09795cf4 | this.Load | FPC0102_MWPPCopy.cs:224 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0102_MWPPCopy.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60df020d | Dispose | FPC0102_MWPPCopy.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0102_MWPPCopy.FindData

진입점: this.Load / drPeriod.ValueChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf6e7c23 | this.Load 외 4 | FPC0102_MWPPCopy.cs:287 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e4fb0a1b | this.Load 외 4 | FPC0102_MWPPCopy.cs:288 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d4a535ca | this.Load 외 4 | FPC0102_MWPPCopy.cs:295 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5f5a56eb | this.Load 외 4 | FPC0102_MWPPCopy.cs:296 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8c690c16 | this.Load 외 4 | FPC0102_MWPPCopy.cs:297 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-96c88d21 | this.Load 외 4 | FPC0102_MWPPCopy.cs:298 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5d4162cb | this.Load 외 4 | FPC0102_MWPPCopy.cs:301 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e6a47383 | this.Load 외 4 | FPC0102_MWPPCopy.cs:303 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { string bulk_info = DataService.ToLoopParam("", bukInfo); Filter["BUCKET"] = bulk_… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ab25d0e | this.Load 외 4 | FPC0102_MWPPCopy.cs:306 | lambda | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-e4dbd41b | this.Load 외 4 | FPC0102_MWPPCopy.cs:308 | lambda | CALL_EXT | AmendService.FindWppCopy | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-24d0c809 | this.Load 외 4 | FPC0102_MWPPCopy.cs:308 | lambda | RETURN | return AmendService.FindWppCopy(Filter); |  | 처리 중단/반환 |  |  |  |
| AC-4328be4d | this.Load 외 4 | FPC0102_MWPPCopy.cs:313 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-7964c792 | this.Load 외 4 | FPC0102_MWPPCopy.cs:314 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-99fc8674 | this.Load 외 4 | FPC0102_MWPPCopy.cs:315 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-5dc5c945 | this.Load 외 4 | FPC0102_MWPPCopy.cs:318 |  | GRID_INIT | siMain.SetSheetHeaderDateColumn_FP | (calendar, false, false, true, 2, DateColumnType.DMPP) | 그리드 재구성/초기화 |  |  |  |
| AC-02fb4f23 | this.Load 외 4 | FPC0102_MWPPCopy.cs:321 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-9674eba6 | this.Load 외 4 | FPC0102_MWPPCopy.cs:322 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-ac102331 | this.Load 외 4 | FPC0102_MWPPCopy.cs:323 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-41793f5e | this.Load 외 4 | FPC0102_MWPPCopy.cs:332 | if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | row["_CHK"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-5d1e2e6f | this.Load 외 4 | FPC0102_MWPPCopy.cs:336 |  | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-7df23bd0 | this.Load 외 4 | FPC0102_MWPPCopy.cs:337 |  | CALL_EXT | siMain.SetMergeRange | (2,siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaf926af | this.Load 외 4 | FPC0102_MWPPCopy.cs:338 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-37fd57e9 | this.Load 외 4 | FPC0102_MWPPCopy.cs:339 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f472ae6a | this.Load 외 4 | FPC0102_MWPPCopy.cs:341 |  | GRID_LOCK | siMain.LockColumn | (0, max_col - added, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98022603 | this.Load 외 4 | FPC0102_MWPPCopy.cs:342 |  | GRID_LOCK | siMain.LockColumn | (0,0,false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3dfb7abe | this.Load 외 4 | FPC0102_MWPPCopy.cs:347 | foreach (FarPoint.Win.Spread.Row viewRow in siMain.ActiveSheet.Rows) | GRID_SET | siMain.ActiveSheet.Cells[index, 1].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-897d3865 | this.Load 외 4 | FPC0102_MWPPCopy.cs:351 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-0726b41e | this.Load 외 4 | FPC0102_MWPPCopy.cs:355 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0102_MWPPCopy.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abd2cced | this.Load | FPC0102_MWPPCopy.cs:141 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-06b99b4a | this.Load | FPC0102_MWPPCopy.cs:143 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0102_MWPPCopy.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-147cdb08 | this.Load | FPC0102_MWPPCopy.cs:166 |  | FLAG | dtOperation | Data_FP.CallGeneralProcedure2(("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").To… | 화면 필드/플래그 변경 |  |  |  |
| AC-d888e0a9 | this.Load | FPC0102_MWPPCopy.cs:166 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_" + "FP00599" + "_" + "findOperationCode_common").ToUpper(), Filter, UserInfoCont… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e746befe | this.Load | FPC0102_MWPPCopy.cs:167 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e3f41b12 | this.Load | FPC0102_MWPPCopy.cs:168 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-775c0db5 | this.Load | FPC0102_MWPPCopy.cs:170 |  | DATA_OP | Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-717631f0 | this.Load | FPC0102_MWPPCopy.cs:171 |  | FLAG | dtLine | DataService.FP_ExecuteProcedure2("PR_UI_XPCOMMON_AMEND_FINDLINECODE_AMEND", Filter, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-6bd14009 | this.Load | FPC0102_MWPPCopy.cs:171 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_XPCOMMON_AMEND_FINDLINECODE_AMEND", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e13433dc | this.Load | FPC0102_MWPPCopy.cs:172 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-35d1674a | this.Load | FPC0102_MWPPCopy.cs:173 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3c02ce50 | this.Load | FPC0102_MWPPCopy.cs:179 | if (Filter["BUCKET_FROM"] ==string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-6eef8ad4 | this.Load | FPC0102_MWPPCopy.cs:180 | if (Filter["BUCKET_FROM"] ==string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-e1cef36b | this.Load | FPC0102_MWPPCopy.cs:184 | else of (Filter["BUCKET_FROM"] ==string.Empty) | UI_PROP | drPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-64214f87 | this.Load | FPC0102_MWPPCopy.cs:187 | else of (Filter["BUCKET_FROM"] ==string.Empty) ▸ if (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-87c236d9 | this.Load | FPC0102_MWPPCopy.cs:190 | else of (Filter["BUCKET_FROM"] ==string.Empty) ▸ else of (Filter["BUCKET_TO"] == string.Empty) | UI_PROP | drPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-6951b3e5 | this.Load | FPC0102_MWPPCopy.cs:203 | else of (drPeriod.Value1.Date > DateTime.Now.Date) | UI_PROP | drPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-c1b65164 | this.Load | FPC0102_MWPPCopy.cs:204 | else of (drPeriod.Value1.Date > DateTime.Now.Date) | DATA_OP | Filter["BUCKET_FROM"] | drPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0d0627c6 | this.Load | FPC0102_MWPPCopy.cs:213 | else of (drPeriod.Value2.Date > DateTime.Now.Date) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-82a370a7 | this.Load | FPC0102_MWPPCopy.cs:214 | else of (drPeriod.Value2.Date > DateTime.Now.Date) | DATA_OP | Filter["BUCKET_TO"] | drPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e7385673 | this.Load | FPC0102_MWPPCopy.cs:216 |  | VALUE_SET | cbWpp.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-fa51389c | this.Load | FPC0102_MWPPCopy.cs:217 |  | VALUE_SET | cbMpp.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-a3fbb136 | this.Load | FPC0102_MWPPCopy.cs:218 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FPC0102_MWPPCopy.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed43ebc0 | this.Load | FPC0102_MWPPCopy.cs:229 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-91bd980b | this.Load | FPC0102_MWPPCopy.cs:230 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FPC0102_MWPPCopy.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c099c921 | this.Load | FPC0102_MWPPCopy.cs:244 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-67ce158e | this.Load | FPC0102_MWPPCopy.cs:246 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

## FPC0102_MWPPCopy.Mpp_CheckedChanged

진입점: cbMpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd68233e | cbMpp.CheckedChanged | FPC0102_MWPPCopy.cs:553 | if (chk) | DATA_OP | Filter["MPP_WPP"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a13e4c59 | cbMpp.CheckedChanged | FPC0102_MWPPCopy.cs:555 | else of (chk) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-fe9c1e6c | cbMpp.CheckedChanged | FPC0102_MWPPCopy.cs:556 |  | VALUE_SET | cbWpp.Checked | !chk | 컨트롤 값 설정 |  |  |  |

## FPC0102_MWPPCopy.panel1_Resize

진입점: this.panel1.Resize

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7134903b | this.panel1.Resize | FPC0102_MWPPCopy.cs:576 | try | UI_PROP | btnOK.Left | (int)((panel1.Size.Width - btnOK.Width) / 2) | 속성 Left 설정 |  |  |  |

## FPC0102_MWPPCopy.period_ValueChanged

진입점: drPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64923f2d | drPeriod.ValueChanged | FPC0102_MWPPCopy.cs:563 | if (drPeriod.Value1 < DateTime.Now) | UI_PROP | drPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-40d44921 | drPeriod.ValueChanged | FPC0102_MWPPCopy.cs:565 | if (drPeriod.Value2 < DateTime.Now) | UI_PROP | drPeriod.Value2 | DateTime.Now | 속성 Value2 설정 |  |  |  |
| AC-7bdb3a01 | drPeriod.ValueChanged | FPC0102_MWPPCopy.cs:566 |  | DATA_OP | Filter["BUCKET_FROM"] | drPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a0447fd6 | drPeriod.ValueChanged | FPC0102_MWPPCopy.cs:567 |  | DATA_OP | Filter["BUCKET_TO"] | drPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FPC0102_MWPPCopy.SaveData

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4649ed1e | this.btnOK.Click | FPC0102_MWPPCopy.cs:369 | if (!dtFindData.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-31a824c4 | this.btnOK.Click | FPC0102_MWPPCopy.cs:370 | if (!dtFindData.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e868394 | this.btnOK.Click | FPC0102_MWPPCopy.cs:373 |  | DATA_OP | dtFindData.Columns.Contains | ("_CHK") | 데이터 객체 조작/조회 |  |  |  |
| AC-caf3728d | this.btnOK.Click | FPC0102_MWPPCopy.cs:375 | if (!dtFindData.Columns.Contains("_CHK")) | DATA_OP | dtFindData.Columns.Add | (new DataColumn("_CHK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-03585e4f | this.btnOK.Click | FPC0102_MWPPCopy.cs:388 | foreach (FarPoint.Win.Spread.Row viewRow in siMain.ActiveSheet.Rows) ▸ if (v != null && row!=null) ▸ if (ok) | DATA_OP | row["_CHK"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-765f89b6 | this.btnOK.Click | FPC0102_MWPPCopy.cs:392 | foreach (FarPoint.Win.Spread.Row viewRow in siMain.ActiveSheet.Rows) ▸ if (v != null && row!=null) ▸ else of (ok) | DATA_OP | row["_CHK"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-9d7e3f0b | this.btnOK.Click | FPC0102_MWPPCopy.cs:404 | try | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d7e448c | this.btnOK.Click | FPC0102_MWPPCopy.cs:406 | try ▸ if (dtFindData.Select("_CHK='Y'")==null) | MESSAGE | MessageBox.Show | ("You need to select data") | 메시지 표시 |  |  |  |
| AC-49ded950 | this.btnOK.Click | FPC0102_MWPPCopy.cs:407 | try ▸ if (dtFindData.Select("_CHK='Y'")==null) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-d31b4d68 | this.btnOK.Click | FPC0102_MWPPCopy.cs:409 | try ▸ else of (dtFindData.Select("_CHK='Y'")==null) | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9e382ec | this.btnOK.Click | FPC0102_MWPPCopy.cs:411 | try ▸ else of (dtFindData.Select("_CHK='Y'")==null) ▸ if (dtFindData.Select("_CHK='Y'").Count() == 0) | MESSAGE | MessageBox.Show | ("You need to select data") | 메시지 표시 |  |  |  |
| AC-35929498 | this.btnOK.Click | FPC0102_MWPPCopy.cs:412 | try ▸ else of (dtFindData.Select("_CHK='Y'")==null) ▸ if (dtFindData.Select("_CHK='Y'").Count() == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0211d2e | this.btnOK.Click | FPC0102_MWPPCopy.cs:414 | try ▸ else of (dtFindData.Select("_CHK='Y'")==null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) | DATA_OP | dtFindData.Select("_CHK='Y'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3b2f74ac | this.btnOK.Click | FPC0102_MWPPCopy.cs:414 | try ▸ else of (dtFindData.Select("_CHK='Y'")==null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ff20c6c | this.btnOK.Click | FPC0102_MWPPCopy.cs:416 | try ▸ else of (dtFindData.Select("_CHK='Y'")==null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) ▸ if (!dtFindData.Select("_CHK='Y… | MESSAGE | MessageBox.Show | ("You need to select data") | 메시지 표시 |  |  |  |
| AC-6ad9c2f4 | this.btnOK.Click | FPC0102_MWPPCopy.cs:417 | try ▸ else of (dtFindData.Select("_CHK='Y'")==null) ▸ else of (dtFindData.Select("_CHK='Y'").Count() == 0) ▸ if (!dtFindData.Select("_CHK='Y… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eadd5459 | this.btnOK.Click | FPC0102_MWPPCopy.cs:420 | try | CALL_EXT | AmendService.UpdateWppCopy | (Filter, dtFindData.Select("_CHK='Y'").CopyToDataTable()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c6d427c | this.btnOK.Click | FPC0102_MWPPCopy.cs:420 | try | DATA_OP | dtFindData.Select("_CHK='Y'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e43235d4 | this.btnOK.Click | FPC0102_MWPPCopy.cs:420 | try | DATA_OP | dtFindData.Select | ("_CHK='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0913c1d0 | this.btnOK.Click | FPC0102_MWPPCopy.cs:421 | try | MESSAGE | MessageBox.Show | ("Data Saved ...") | 메시지 표시 |  |  |  |
| AC-3a965b75 | this.btnOK.Click | FPC0102_MWPPCopy.cs:422 | try | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## FPC0102_MWPPCopy.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ad3d391 | this.spdMain.CellClick | FPC0102_MWPPCopy.cs:484 | if (e.Column == chk && e.ColumnHeader) ▸ if (head != null) | GRID_SET | spdMain.ActiveSheet.ColumnHeader.Cells[0, chk].Value | headtf | 그리드 속성/값 설정 |  |  |  |
| AC-8881d7f9 | this.spdMain.CellClick | FPC0102_MWPPCopy.cs:488 | if (e.Column == chk && e.ColumnHeader) ▸ else of (head != null) | GRID_SET | spdMain.ActiveSheet.ColumnHeader.Cells[0, chk].Value | headtf | 그리드 속성/값 설정 |  |  |  |
| AC-83ca8dc3 | this.spdMain.CellClick | FPC0102_MWPPCopy.cs:491 | if (e.Column == chk && e.ColumnHeader) | GRID_SET | spdMain.ActiveSheet.Cells[0, chk, rowcount-1, 1].Value | headtf | 그리드 속성/값 설정 |  |  |  |
| AC-8d31bbe3 | this.spdMain.CellClick | FPC0102_MWPPCopy.cs:499 | else of (e.Column == chk && e.ColumnHeader) ▸ if (e.Column == chk && e.ColumnHeader==false && e.RowHeader==false) ▸ if (val == null) | GRID_SET | spdMain.ActiveSheet.Cells[e.Row, e.Column].Value | tf | 그리드 속성/값 설정 |  |  |  |
| AC-dfce25d4 | this.spdMain.CellClick | FPC0102_MWPPCopy.cs:505 | else of (e.Column == chk && e.ColumnHeader) ▸ if (e.Column == chk && e.ColumnHeader==false && e.RowHeader==false) ▸ else of (val == null) | GRID_SET | spdMain.ActiveSheet.Cells[e.Row, e.Column].Value | tf | 그리드 속성/값 설정 |  |  |  |
| AC-b77ae599 | this.spdMain.CellClick | FPC0102_MWPPCopy.cs:514 | else of (e.Column == chk && e.ColumnHeader) ▸ if (e.Column == chk && e.ColumnHeader==false && e.RowHeader==false) ▸ if (head!=null) ▸ if (he… | GRID_SET | spdMain.ActiveSheet.ColumnHeader.Cells[0, chk].Value | null | 그리드 속성/값 설정 |  |  |  |

## FPC0102_MWPPCopy.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c62bf2cb | this.spdMain.CellDoubleClick | FPC0102_MWPPCopy.cs:522 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0102_MWPPCopy.Wpp_CheckedChanged

진입점: cbWpp.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c646b673 | cbWpp.CheckedChanged | FPC0102_MWPPCopy.cs:543 | if (chk) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-3b4f374a | cbWpp.CheckedChanged | FPC0102_MWPPCopy.cs:545 | else of (chk) | DATA_OP | Filter["MPP_WPP"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-d40e9fde | cbWpp.CheckedChanged | FPC0102_MWPPCopy.cs:546 |  | VALUE_SET | cbMpp.Checked | !chk | 컨트롤 값 설정 |  |  |  |

