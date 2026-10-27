# AS-IS 액션 대조표 — FP01559

> 원천: `Doc/asisfacts/screens/FP01559/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 702행 · 메서드 124 · 종류 DATA_OP 233 · FLAG 93 · RETURN 55 · UI_PROP 54 · VALUE_SET 49 · MESSAGE 37 · UI_MISC 29 · ENDPOINT 27 · CALL_EXT 23 · GRID_INIT 23 · POPUP 15 · STATE 12 · GRID_SET 11 · LIST_REBIND 10 · GRID_LOCK 8 · GRID_STYLE 8 · COMBO_DATA 6 · THROW 5 · LIST_CLEAR 2 · EXCEL 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 23


## FP01559_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b8db11c | .ctor | FP01559_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-c9b615ed | .ctor | FP01559_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-5bb1f1fc | .ctor | FP01559_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-7118a90b | .ctor | FP01559_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP01559_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-189d3aa9 | Dispose | FP01559_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01559_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-208e1553 | this.Load | FP01559_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP01559_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb0eaec | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:137 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-ed2d8900 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:143 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-44f740f3 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3dc5935 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-54089435 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f86b373 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-80a306c5 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-32bb847b | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-25302c5e | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP01559_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e049fb2 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3d9e0ab1 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-54232ba5 | this.Load 외 1 | FP01559_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP01559_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-404ad83b | (진입점 미연결) | FP01559_BucketSetForm_Popup.cs:225 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-7093f345 | (진입점 미연결) | FP01559_BucketSetForm_Popup.cs:236 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24bbee42 | (진입점 미연결) | FP01559_BucketSetForm_Popup.cs:247 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP01559_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39c25c93 | this.Load | FP01559_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8c603f60 | this.Load | FP01559_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01559_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7fde772 | this.usrButton1.Click | FP01559_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-e387ee9f | this.usrButton1.Click | FP01559_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-5834071c | this.usrButton1.Click | FP01559_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-542294fc | this.usrButton1.Click | FP01559_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-07335da5 | this.usrButton1.Click | FP01559_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-41fdc48c | this.usrButton1.Click | FP01559_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09203944 | this.usrButton1.Click | FP01559_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP01559_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdf68b32 | this.usrButton2.Click | FP01559_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-4461e73c | this.usrButton2.Click | FP01559_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-1e88dfa9 | this.usrButton2.Click | FP01559_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-13a1b106 | this.usrButton2.Click | FP01559_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-ad17d332 | this.usrButton2.Click | FP01559_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-aa421a9d | this.usrButton2.Click | FP01559_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-22bc5223 | this.usrButton2.Click | FP01559_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01559_In_House_Request_Moving_Plan..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ca3ca95 | .ctor | FP01559_In_House_Request_Moving_Plan.cs:110 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN") ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d2abe5e | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1807 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-54b962ad | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1808 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c7c64ebf | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1809 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e7260af9 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1810 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0766242a | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1811 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f92ee350 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1814 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_WeekCnt", Filter… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-6b1662a3 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1814 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-46c0d8a6 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1815 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_DateMap", Filter… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-4f61f3df | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1815 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0fc94126 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1816 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_MonthCnt", Filte… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-f20551e2 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1816 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0fd35844 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1817 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_BukInfo", Filter… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-6668595d | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1817 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-36dd420a | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1829 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-963b17b4 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1830 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-ee49c0f3 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1831 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-f0e53fd0 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1832 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN") ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / SaveButton [if (save_success == true) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6483171f | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1842 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e9c6831d | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1843 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-89b4218a | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1844 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-090e1b2b | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1849 | if (cboPlanId.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-6d8fab5c | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1852 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8ae3ea4 | this.btnBucket.Click | FP01559_In_House_Request_Moving_Plan.cs:2824 |  | POPUP | new FP01559_BucketSetForm_Popup | ("FP01559", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-862eedf7 | this.btnBucket.Click | FP01559_In_House_Request_Moving_Plan.cs:2825 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1d48127d | this.btnBucket.Click | FP01559_In_House_Request_Moving_Plan.cs:2826 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ba733a5f | this.btnBucket.Click | FP01559_In_House_Request_Moving_Plan.cs:2832 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.btnCatagory_Click

진입점: this.btnCategory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-544b316b | this.btnCategory.Click | FP01559_In_House_Request_Moving_Plan.cs:2804 |  | POPUP | new FP01559_MeasureSetForm_Popup | ("FP01559", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-5d023b74 | this.btnCategory.Click | FP01559_In_House_Request_Moving_Plan.cs:2805 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6a042913 | this.btnCategory.Click | FP01559_In_House_Request_Moving_Plan.cs:2806 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-30f2a868 | this.btnCategory.Click | FP01559_In_House_Request_Moving_Plan.cs:2812 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed860a5f | this.btnColumn.Click | FP01559_In_House_Request_Moving_Plan.cs:2786 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP01559", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-5ae24aed | this.btnColumn.Click | FP01559_In_House_Request_Moving_Plan.cs:2787 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-31cef53c | this.btnColumn.Click | FP01559_In_House_Request_Moving_Plan.cs:2788 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ef91192 | this.btnSql.Click | FP01559_In_House_Request_Moving_Plan.cs:1177 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6a43c96a | this.btnSql.Click | FP01559_In_House_Request_Moving_Plan.cs:1178 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8209afed | this.btnSql.Click | FP01559_In_House_Request_Moving_Plan.cs:1180 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ff7f4e7 | this.btnSql.Click | FP01559_In_House_Request_Moving_Plan.cs:1181 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d631b4bb | this.btnToggleSave.Click | FP01559_In_House_Request_Moving_Plan.cs:2844 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.cboPlanId_changed

진입점: cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ebd0615 | cboPlanId.SelectedIndexChanged | FP01559_In_House_Request_Moving_Plan.cs:2435 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-9a1fda74 | cboPlanId.SelectedIndexChanged | FP01559_In_House_Request_Moving_Plan.cs:2436 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72ef713e | cboPlanId.SelectedIndexChanged | FP01559_In_House_Request_Moving_Plan.cs:2463 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-3714e656 | cboPlanId.SelectedIndexChanged | FP01559_In_House_Request_Moving_Plan.cs:2464 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(55) | 속성 Value2 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.Check_Data

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4927139a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1397 | if (GetFilter("PLAN_DATE") == "") | MESSAGE | MessageBox.Show | ("Select Plan Date") | 메시지 표시 |  |  |  |
| AC-d30c1e3a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1398 | if (GetFilter("PLAN_DATE") == "") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c8db371b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1403 | if (GetFilter("INSTANCE_ID") == "") | MESSAGE | MessageBox.Show | ("Select Plan Group(Pack)") | 메시지 표시 |  |  |  |
| AC-491a1bb1 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1404 | if (GetFilter("INSTANCE_ID") == "") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eedfa543 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1409 | if (GetFilter("FORM_INSTANCE_ID") == "") | MESSAGE | MessageBox.Show | ("Select Plan Group(Form)") | 메시지 표시 |  |  |  |
| AC-2d6a1996 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1410 | if (GetFilter("FORM_INSTANCE_ID") == "") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0264f4f9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1417 | if (GetFilter("PLAN_ID") == "") ▸ if (GetFilter("REL_PACK") != "Y") | MESSAGE | MessageBox.Show | ("Select Plan ID(Pack)") | 메시지 표시 |  |  |  |
| AC-d1d4a8ff | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1418 | if (GetFilter("PLAN_ID") == "") ▸ if (GetFilter("REL_PACK") != "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e29b9390 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1426 | if (GetFilter("FORM_PLAN_ID") == "") ▸ if (GetFilter("REL_FORM") != "Y") | MESSAGE | MessageBox.Show | ("Select Plan ID(Form)") | 메시지 표시 |  |  |  |
| AC-0d75c279 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1427 | if (GetFilter("FORM_PLAN_ID") == "") ▸ if (GetFilter("REL_FORM") != "Y") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b79df73c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1433 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.CheckAndGetMeasure

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN") ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff3f13e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:327 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-becb11f3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:327 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-e69db3f8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:329 |  | CALL_EXT | MeasureService.MakeDefault | (new FP01559_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c60c22ae | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:329 |  | POPUP | new FP01559_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-729da767 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:330 |  | CALL_EXT | MeasureService.MakeDefault | (new FP01559_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c607b899 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:330 |  | POPUP | new FP01559_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-a5ec5d50 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:333 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-555725bb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:334 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-be4da5d8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:335 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-923b654c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:336 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee6581d6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:337 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-962cae23 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01559_In_House_Request_Moving_Plan.cs:338 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.chkRelForm_CheckedChanged

진입점: chkRelForm.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c97f49a6 | chkRelForm.CheckedChanged | FP01559_In_House_Request_Moving_Plan.cs:2614 | if (chkRelForm.Checked) | STATE | cboFormPlanId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c3342d35 | chkRelForm.CheckedChanged | FP01559_In_House_Request_Moving_Plan.cs:2620 | else of (chkRelForm.Checked) | STATE | cboFormPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01559_In_House_Request_Moving_Plan.chkRelPack_CheckedChanged

진입점: chkRelPack.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adb95ed8 | chkRelPack.CheckedChanged | FP01559_In_House_Request_Moving_Plan.cs:2596 | if (chkRelPack.Checked) | STATE | cboPlanId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-06ec6cf5 | chkRelPack.CheckedChanged | FP01559_In_House_Request_Moving_Plan.cs:2602 | else of (chkRelPack.Checked) | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01559_In_House_Request_Moving_Plan.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc9ac272 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2369 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-2368a35e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2371 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-806d02d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2372 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e6e4518 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2373 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-353e9904 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2374 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b295a091 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2375 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6fb5770 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2376 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b64f2f2d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2377 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5198868e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2378 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-47a67e97 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2379 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d9ad178 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2380 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PACK_FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-664f029c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2381 |  | DATA_OP | dt.Columns.Add | (new DataColumn("QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a1a7927 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2382 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-df87b989 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2383 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-209af8a4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2386 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8348ea68 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2392 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-c46ff582 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:2395 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.CreateFilterDataSet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-908a1632 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1290 | if (dsResult == null && dsTotal == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6321a6dd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1301 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-68227098 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1302 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-2a2d7306 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1314 | if (measure["chk_request_p"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "REQUEST_S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4852984c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1318 | if (measure["chk_request_r"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "REQUEST_P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cdd893c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1322 | if (measure["chk_request_eoh"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "REQUEST_I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-901ce16d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1326 | if (measure["chk_moving_p"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-02d0d123 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1330 | if (measure["chk_moving_do"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-de9c46d0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1334 | if (measure["chk_moving_ship"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_S_SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ef6b201 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1338 | if (measure["chk_moving_eoh"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MOVING_I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e79f5642 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1344 | if (measure["chk_total_r"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_R_CELL_REQ")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b42820e0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1348 | if (measure["chk_total_do"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_DO_CELL_DELI")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea11466f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1352 | if (measure["chk_total_meet"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_MEET_QTY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0e4a914 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1356 | if (measure["chk_total_eoh"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "TOTAL_EOH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2513e6fa | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1371 |  | CALL_EXT | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | (MainGo, chks_measure_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7bf7045 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1372 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-accc81b0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1376 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-e5ea12bf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1380 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4c674159 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1383 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-64d42bb8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1385 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66f71454 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:272 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-54196196 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:273 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-fcf85474 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:274 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3876ef9 | DeleteButton | FP01559_In_House_Request_Moving_Plan.cs:630 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01559_In_House_Request_Moving_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb9543a8 | Dispose | FP01559_In_House_Request_Moving_Plan.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.drpPlanDate_changed

진입점: cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fac49b1c | cboInstance.SelectedIndexChanged 외 1 | FP01559_In_House_Request_Moving_Plan.cs:2567 |  | FLAG | dtPlanDate | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d7d189 | cboInstance.SelectedIndexChanged 외 1 | FP01559_In_House_Request_Moving_Plan.cs:2567 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "DATE_TEMP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5aabbf8b | cboInstance.SelectedIndexChanged 외 1 | FP01559_In_House_Request_Moving_Plan.cs:2574 |  | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-d94a8c3c | cboInstance.SelectedIndexChanged 외 1 | FP01559_In_House_Request_Moving_Plan.cs:2575 |  | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6827a80c | EditButton | FP01559_In_House_Request_Moving_Plan.cs:638 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-849d0db0 | ExcelButton | FP01559_In_House_Request_Moving_Plan.cs:1541 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-967f171b | FindButton | FP01559_In_House_Request_Moving_Plan.cs:552 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-63fcfd87 | FindButton | FP01559_In_House_Request_Moving_Plan.cs:556 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df2fa87b | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1788 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-136b567b | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1793 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7dd6eb3f | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1795 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-aada1463 | popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUE… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:1800 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.FindTotalColorStart

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnColumn.Click [if (frm.Dialog…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fd00a40 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:523 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2a0a829 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1764 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01559_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c160f22d | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1765 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-cc53052a | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1769 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.fn_columnChange

진입점: this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64336725 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:1882 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d589dcd | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:1887 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-0d9453a2 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:1893 | if (EditingCol != cCol) | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-0fa0c36d | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:1941 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf7b2ce6 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2044 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_request_eoh") | 데이터 객체 조작/조회 |  |  |  |
| AC-357a1286 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2053 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_request_eoh") && current_type.Equals("REQUEST")) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-55deec60 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2058 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_request_eoh") && current_type.Equals("REQUEST")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'DATA' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PACK_FACTOR… | 데이터 객체 조작/조회 |  |  |  |
| AC-a87c6318 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2064 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_request_eoh") && current_type.Equals("REQUEST")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'TOTAL' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + //" PACK_FAC… | 데이터 객체 조작/조회 |  |  |  |
| AC-d6978c2f | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2070 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_request_eoh") && current_type.Equals("REQUEST")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'TOTAL' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PACK_FACTO… | 데이터 객체 조작/조회 |  |  |  |
| AC-f3ec3c62 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2102 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_request_eoh") && current_type.Equals("REQUEST")) ▸ if (rowDay.Length > 0) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-03ebced2 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2142 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_request_eoh") && current_type.Equals("REQUEST")) ▸ if (rowDay.Length > 0) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-fc26183c | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2168 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_request_eoh") && current_type.Equals("REQUEST")) ▸ if (rowDay.Length > 0) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing - delta | 그리드 속성/값 설정 |  |  |  |
| AC-52f77d8d | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2175 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_moving_eoh") | 데이터 객체 조작/조회 |  |  |  |
| AC-560a2578 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2184 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-16423179 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2189 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'DATA' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " CELL_FACTOR… | 데이터 객체 조작/조회 |  |  |  |
| AC-4d1565fa | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2195 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'TOTAL' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + //" PACK_FAC… | 데이터 객체 조작/조회 |  |  |  |
| AC-eebeedc7 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2201 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'TOTAL' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PACK_FACTO… | 데이터 객체 조작/조회 |  |  |  |
| AC-69e2a0bf | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2207 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'TOTAL' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + //" CELL_FAC… | 데이터 객체 조작/조회 |  |  |  |
| AC-5fb14740 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2240 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing - delta | 그리드 속성/값 설정 |  |  |  |
| AC-538206f4 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2280 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-0858d4d8 | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2307 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-ec0c696a | this.spdMain.Change [if (this.IsEditMode == true) ▸ if (siMa… | FP01559_In_House_Request_Moving_Plan.cs:2339 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_moving_eoh") && current_type.Equals("MOVING")) ▸ if (rowDay.Length > 0) ▸ if … | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing - delta | 그리드 속성/값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7982fab0 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:152 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.FP01559_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae06922e | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1857 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetBasisTime

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25adb349 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:2766 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter… | 화면 필드/플래그 변경 |  |  |  |
| AC-605262eb | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:2766 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetCurrDate

진입점: this.Load / cboInstance.SelectedIndexChanged / cboFormInstance.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efceda48 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2704 |  | FLAG | dtCurrDate | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1786eb1 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2704 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CURR_DATE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-68436302 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2708 | if (dtCurrDate.Good()) | DATA_OP | Filter["PLAN_DATE"] | Filter["CURR_DATE"] = dtCurrDate.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-be3ce67c | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2708 | if (dtCurrDate.Good()) | DATA_OP | Filter["CURR_DATE"] | dtCurrDate.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d14f8f7 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2709 | if (dtCurrDate.Good()) | DATA_OP | Filter["BUCKET_FROM"] | Filter["PLAN_START_DATE"] = dtCurrDate.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b20b9a02 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2709 | if (dtCurrDate.Good()) | DATA_OP | Filter["PLAN_START_DATE"] | dtCurrDate.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52fe29dc | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2710 | if (dtCurrDate.Good()) | DATA_OP | Filter["BUCKET_TO"] | Filter["PLAN_END_DATE"] = dtCurrDate.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d44bbc7c | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2710 | if (dtCurrDate.Good()) | DATA_OP | Filter["PLAN_END_DATE"] | dtCurrDate.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetDivision

진입점: this.Load / cboInstance.SelectedIndexChanged / cboFormInstance.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95e8b5d3 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2746 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-e71ce5c9 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2746 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28e99efe | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:2748 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetFilter

진입점: cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN") ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-758a3bf0 | cboInstance.SelectedIndexChanged 외 6 | FP01559_In_House_Request_Moving_Plan.cs:2999 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetFormPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40a8a2eb | this.Load | FP01559_In_House_Request_Moving_Plan.cs:2672 |  | FLAG | dtFormInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b790a5cd | this.Load | FP01559_In_House_Request_Moving_Plan.cs:2672 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d05486ba | this.Load | FP01559_In_House_Request_Moving_Plan.cs:2674 |  | LIST_REBIND | clsCtrl.setListBox | (dtFormInstance, cboFormInstance, false, "INSTANCE_ID", "INSTANCE_NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetFpPlanId

진입점: this.cboFormPlanId.DropDown / this.cboPlanId.DropDown / this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46422637 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2718 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-7977d21f | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2718 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-76125544 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2719 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b91fdd68 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2722 | if (dtPlanId.Good() && dtPlanId.Rows.Count > 0) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e7cb6190 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2726 | else of (dtPlanId.Good() && dtPlanId.Rows.Count > 0) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d7d77c39 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2730 |  | FLAG | dtFormPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb709535 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2730 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a0d4cda0 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2731 |  | LIST_REBIND | clsCtrl.setListBox | (dtFormPlanId, cboFormPlanId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-37c7e0f6 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2735 | if (dtFormPlanId.Good() && dtFormPlanId.Rows.Count > 0) | DATA_OP | Filter["FORM_PLAN_ID"] | dtFormPlanId.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e08664f7 | this.cboFormPlanId.DropDown 외 5 | FP01559_In_House_Request_Moving_Plan.cs:2739 | else of (dtFormPlanId.Good() && dtFormPlanId.Rows.Count > 0) | DATA_OP | Filter["FORM_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetPlanGroup

진입점: this.Load / SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30cc2d76 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2665 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-d57f3bc0 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2665 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1b5058cd | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2667 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "PACK_INSTANCE_ID", "PACK_INSTANCE_NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetPlantFactory

진입점: this.Load / cboInstance.SelectedIndexChanged / cboFormInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ac30479 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2682 |  | FLAG | dtPlant | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-33a3eb40 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2682 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLANT_FACTORY") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-14960828 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2685 |  | FLAG | dtFormPlant | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-2bd3a529 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2685 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLANT_FACTORY") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7c73d924 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2690 |  | FLAG | dtFactory | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-6855a3a2 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2690 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLANT_FACTORY") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8dc39156 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2693 |  | FLAG | dtFormFactory | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-0bb05c47 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2693 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PLANT_FACTORY") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2d6306f1 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2695 |  | DATA_OP | Filter["PACK_PLANT_ID"] | dtPlant.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aff687e9 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2696 |  | DATA_OP | Filter["FORM_PLANT_ID"] | dtFormPlant.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ab2e83a | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2697 |  | DATA_OP | Filter["PACK_FACTORY_ID"] | dtFactory.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79f93ea5 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2698 |  | DATA_OP | Filter["FORM_FACTORY_ID"] | dtFormFactory.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GetSite

진입점: this.Load / clbDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d2a9c41 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2754 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ce2ad61f | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2754 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-592cd9c4 | this.Load 외 2 | FP01559_In_House_Request_Moving_Plan.cs:2756 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1858b1d | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1651 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b9339bd | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:645 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f003b96b | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:647 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cb5ad8fe | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:689 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0dfe75f4 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:690 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-a4f18f00 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:719 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b205a88f | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:720 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-c5f812a5 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:749 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d67f2e32 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:750 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-0a280c26 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:765 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.GoEditMode

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / SaveButton [if (save_s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d708e326 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:771 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-d311586a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:788 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e65de583 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:798 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-02840237 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:799 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-25da1426 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:827 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-217aaa4d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:857 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3eb1c81e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:869 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41daf6e3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:870 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-69eb1857 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:886 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-5ac5a8d3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:903 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beac5cb6 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:167 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a4017a75 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:171 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-9e4dc38f | this.Load | FP01559_In_House_Request_Moving_Plan.cs:172 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5fc19096 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:176 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-db8165ce | this.Load | FP01559_In_House_Request_Moving_Plan.cs:180 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0b4c996 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:187 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-08e9ef31 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:190 | if (cboFormInstance.Items.Count > 0) | VALUE_SET | cboFormInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-dee3ccbc | this.Load | FP01559_In_House_Request_Moving_Plan.cs:192 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = dtInstance.Rows[cboInstance.SelectedIndex]["PACK_INSTANCE_ID"].ToS… | 행/컬럼 값 대입 |  |  |  |
| AC-09c1d5b1 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:192 |  | DATA_OP | Filter["INSTANCE_ID"] | dtInstance.Rows[cboInstance.SelectedIndex]["PACK_INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b291130b | this.Load | FP01559_In_House_Request_Moving_Plan.cs:197 |  | DATA_OP | Filter["FORM_INSTANCE_ID"] | dtFormInstance.Rows[cboFormInstance.SelectedIndex]["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a9942eb | this.Load | FP01559_In_House_Request_Moving_Plan.cs:213 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-3a10882a | this.Load | FP01559_In_House_Request_Moving_Plan.cs:215 |  | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-1f61640d | this.Load | FP01559_In_House_Request_Moving_Plan.cs:216 |  | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(Filter["BUCKET_TO"], "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.InitEditingBuf

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-118080ae | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1869 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0afbc9d7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1870 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-c7fb100a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1871 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d48fe5bb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1872 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db637279 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:239 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e92f4402 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:284 | try | DATA_OP | Filter["PROGRAM_ID"] | "FP01559" | 행/컬럼 값 대입 |  |  |  |
| AC-1a15ef60 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:285 | try | DATA_OP | Filter["SHEET_NAME"] | "AMEND" | 행/컬럼 값 대입 |  |  |  |
| AC-1018d41d | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:300 | try | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-30092364 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:301 | try | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-9893fab4 | this.Load 외 3 | FP01559_In_House_Request_Moving_Plan.cs:306 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55920d3a | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:593 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-54bf099d | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:601 | if (row != null) | POPUP | new FP01559_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-91aee824 | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:602 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-81a4ef98 | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:602 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-36b5bdc0 | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:603 | if (row != null) | UI_PROP | popup.FilterDateMap | dateMap | 속성 FilterDateMap 설정 |  |  |  |
| AC-1b8861ee | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:604 | if (row != null) | DATA_OP | popup.Filter["FORM_INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ba4bdf1 | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:605 | if (row != null) | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b13776cd | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:607 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-37722038 | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:608 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2a8d5425 | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:612 | if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c2f0bdd | InsertButton | FP01559_In_House_Request_Moving_Plan.cs:622 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74bff135 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1611 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01559_In_House_Request_Moving_Plan.RefreshHeader

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (dsMainFiltered.Good())] / SaveButton [if (save_s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a3af34d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:345 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-2e77fac7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:346 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-5edac649 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:347 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-a99981e6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:348 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-0309efa8 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:364 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1576c37 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:367 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-673976dc | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:368 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-922dd9a6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:369 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df9f7b30 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:370 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb4b3278 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:373 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53f7b969 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:374 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f89eb66 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:376 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-468bf362 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:378 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f654a881 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:381 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (22) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7434715 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:382 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3cb48f36 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:418 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-ca295b38 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:437 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-db0b46ea | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:441 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-ccb1cc01 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:443 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4a5d3f1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:447 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-1aef2c24 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:462 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-c3cfc27a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01559_In_House_Request_Moving_Plan.cs:477 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.RefreshHeaderOnly

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6240076b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:490 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-e1afdc49 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:491 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-af434ac5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:492 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b61d9a5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:493 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aabf0899 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01559_In_House_Request_Moving_Plan.cs:494 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.RefreshSpreadSheet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a18ad60 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1513 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-1547b828 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1513 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-8cf1c47e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1517 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-1f2ecf5f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1522 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-9004426c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1528 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d38dcb93 | popSql.OnSql | FP01559_In_House_Request_Moving_Plan.cs:1747 | if (programID == "PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-23506c92 | popSql.OnSql | FP01559_In_House_Request_Moving_Plan.cs:1749 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.Save_Confirm

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f7b55bc | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1126 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57355ac0 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1127 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-03e6f9f2 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1133 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5685a267 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1150 | try ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "execute_confirm", Filter.Dictionary,null, "Plann… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] \| FP\Planni… | 엔드포인트 호출 |  |  |  |
| AC-337cd8a9 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1154 | try ▸ catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-92b5a87b | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1157 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "execute_planSend", Filter.Dictionary, null, "Pla… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-84e6a2fe | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1163 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-26595b93 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1164 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b1796596 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1168 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-71f75e84 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1171 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a49f24e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:927 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1bb4eb2c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:937 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f989a250 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:938 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c2ec44b6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:944 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a566af99 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:947 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e24f0dbc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:952 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-9c0802ae | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:953 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9e08c320 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:954 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f718c5de | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:976 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7ee46991 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:984 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-013a677d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:985 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-de7407a2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:986 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2735a096 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:987 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-85954591 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:988 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cfd072d5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:989 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fe6a0d0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:990 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-515ef204 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:991 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CELL_FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2492e46b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:992 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PACK_FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-18dc980c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:982 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("CATEGORY_TYPE") == enum_row_from_Saving["CATEGORY_TYPE… |  | 처리 중단/반환 |  |  |  |
| AC-f1fec593 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1017 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-c30b4e03 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1022 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-f394400f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1023 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-aab98cee | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1035 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33447faa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1037 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_TYPE"] | enum_row_from_Saving["CATEGORY_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2867f9c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1038 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d87cdec3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1039 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8111c556 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1040 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7e7cec79 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1041 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b38c14de | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1042 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CELL_ITEM_ID"] | enum_row_from_Saving["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ced1651b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1043 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-b83428c8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1044 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CELL_FACTORY_ID"] | enum_row_from_Saving["CELL_FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e3ffa881 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1045 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PACK_FACTORY_ID"] | enum_row_from_Saving["PACK_FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-42cffb76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1046 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DESCRIPTION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-10bb583f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1047 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-4b09e27c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1051 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-331a686d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1052 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORG_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-fe70e751 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1054 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-978dbad3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1056 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ffe08ba | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1075 | try | DATA_OP | objDs.Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-737ea7d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1077 | try ▸ if (!objDs.Columns.Contains("USER_ID")) | DATA_OP | objDs.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-75daea2a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1080 | try ▸ if (!objDs.Columns.Contains("USER_ID")) ▸ foreach (DataRow dr in objDs.Rows) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e409d895 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1084 | try | ENDPOINT | DataService.FP_UpdateBatch | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "merge_data", objDs.DataSet, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] \| FP\Planning\FP015… | 엔드포인트 호출 |  |  |  |
| AC-6843809b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1106 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-538fd1c5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1107 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-aafb71e1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1111 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f5899026 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01559_In_House_Request_Moving_Plan.cs:1113 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfa55c45 | SaveButton | FP01559_In_House_Request_Moving_Plan.cs:916 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a0bc63f | SaveButton | FP01559_In_House_Request_Moving_Plan.cs:918 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f077be51 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1201 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f2012741 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1202 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc5ca187 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1207 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-78dc69db | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1213 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-eeffd676 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1214 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e3f230b | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1215 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b057d14c | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1216 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8276a24a | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1217 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c45dc3b0 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1218 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0db6331 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1219 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-03a8e510 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1220 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a1efc48 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1224 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a00a910 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:120 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c7da7b0 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:122 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-a5f39de4 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:123 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6c0bded2 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:124 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6e62f057 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:128 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-fe3dee51 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:129 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6134fb88 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:130 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-94673370 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:132 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-ae1bb730 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:133 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5cd420a | this.Load | FP01559_In_House_Request_Moving_Plan.cs:135 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-6973f5f6 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:136 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8e40c633 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:137 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a8ff53b7 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:141 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-247510d8 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:142 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-02124675 | this.Load | FP01559_In_House_Request_Moving_Plan.cs:143 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.SetFilter

진입점: this.cboFormPlanId.DropDown / this.cboPlanId.DropDown / this.Load / cboInstance.SelectedIndexChanged [if (dtInstance.Good())] / drpPlanDate.DateTimeChanged / cboPlanId.SelectedIndexChanged [else of (dtPlanId.Good())] / cboFormInstance.SelectedIndexChanged [if (dtInstance.Good())] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / txtGroupName.TextChanged / txtCellCode.TextChanged / txtNickName.TextChanged / chkRelPack.CheckedChanged / chkRelForm.CheckedChanged / chkLineAssign.CheckedChanged / popSql.OnSql [if (programID == "PR_UI_FP01559_IN_HOUSE_REQUEST_MOVING_PLAN") ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51f1023e | this.cboFormPlanId.DropDown 외 19 | FP01559_In_House_Request_Moving_Plan.cs:2994 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cecf33e7 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:314 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1538560 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:315 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.SetTotalValue

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try] / SaveButton [if (save_success == true) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f33069d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1235 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-cfdcf327 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1236 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-d0b011e0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1237 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-22900ee3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1238 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-f02d3740 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1240 |  | DATA_OP | dsResult.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f4d034 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1259 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9713bc3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1260 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c5c81103 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1261 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-238b298b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1262 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b3250aa | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1263 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ lambda | DATA_OP | each_row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-392eb426 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1264 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ lambda | DATA_OP | each_row.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4552b9e3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1274 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ if (result.Count() > 0) ▸ foreach… | DATA_OP | result.CopyToDataTable().Compute | ("Sum("+ sColName +")", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-6cdacb28 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1274 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ if (result.Count() > 0) ▸ foreach… | DATA_OP | result.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a69cde7b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP01559_In_House_Request_Moving_Plan.cs:1277 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "TOTAL_EOH") ▸ if (result.Count() > 0) ▸ foreach… | DATA_OP | row[sColName] | Convert.ToDecimal(resultSum) | 행/컬럼 값 대입 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0fb3eec | this.spdMain.ButtonClicked | FP01559_In_House_Request_Moving_Plan.cs:2978 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-657bd487 | this.spdMain.CellClick | FP01559_In_House_Request_Moving_Plan.cs:2894 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40bac9f3 | this.spdMain.CellDoubleClick | FP01559_In_House_Request_Moving_Plan.cs:3024 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63e3412a | this.spdMain.Change | FP01559_In_House_Request_Moving_Plan.cs:2972 |  | VALUE_SET | tbLog.Text | "spdMain_Change" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-784519c1 | this.spdMain.ChildControlDeactivated | FP01559_In_House_Request_Moving_Plan.cs:2924 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0d5781b | this.spdMain.DragFillBlockCompleted | FP01559_In_House_Request_Moving_Plan.cs:2934 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cef46ebf | this.spdMain.EditChange | FP01559_In_House_Request_Moving_Plan.cs:2889 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79c2feee | this.spdMain.EditModeOff | FP01559_In_House_Request_Moving_Plan.cs:2952 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af6a0163 | this.spdMain.EditModeOn | FP01559_In_House_Request_Moving_Plan.cs:2958 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-5ecb3254 | this.spdMain.EditModeOn | FP01559_In_House_Request_Moving_Plan.cs:2959 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e1469f9 | this.spdMain.EditorFocused | FP01559_In_House_Request_Moving_Plan.cs:2946 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d291b09 | this.spdMain.Enter | FP01559_In_House_Request_Moving_Plan.cs:2909 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15a2497e | this.spdMain.Leave | FP01559_In_House_Request_Moving_Plan.cs:2904 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b76e5a7 | this.spdMain.SubEditorClosed | FP01559_In_House_Request_Moving_Plan.cs:2940 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2398febc | this.spdMain.SubEditorOpening | FP01559_In_House_Request_Moving_Plan.cs:2929 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c7127ae | this.spdMain.TableChanged | FP01559_In_House_Request_Moving_Plan.cs:2877 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8507fc41 | this.spdMain.TableChanged | FP01559_In_House_Request_Moving_Plan.cs:2879 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68cab21c | this.spdMain.TextChanged | FP01559_In_House_Request_Moving_Plan.cs:2860 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d81039b7 | this.spdMain.TextChanged | FP01559_In_House_Request_Moving_Plan.cs:2862 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37a95e44 | this.spdMain.Validated | FP01559_In_House_Request_Moving_Plan.cs:2914 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9f248ef | this.spdMain.Validating | FP01559_In_House_Request_Moving_Plan.cs:2919 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.UIFindData

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)] / SaveButton [if (save_success == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52712f82 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1445 | try ▸ if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d74f64f9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1457 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7b268e9d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1460 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-928fb167 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1461 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5c16bed1 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1465 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-21f206ea | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1473 | try | FLAG | dsMain | FindMainData(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-59dc8b0f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1477 | try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eca739f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1488 | try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-30e0a809 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1492 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de42e277 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1498 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-68ca6674 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 2 | FP01559_In_House_Request_Moving_Plan.cs:1501 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.UISaveConfirm

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad74e69f | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1583 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-042c0e40 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1586 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6749069c | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1588 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a92a1386 | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1595 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-fbb68e1c | (진입점 미연결) | FP01559_In_House_Request_Moving_Plan.cs:1600 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01559_In_House_Request_Moving_Plan.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8de8427 | SaveButton | FP01559_In_House_Request_Moving_Plan.cs:1551 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-93039ed3 | SaveButton | FP01559_In_House_Request_Moving_Plan.cs:1556 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f2eae1a | SaveButton | FP01559_In_House_Request_Moving_Plan.cs:1563 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |

## FP01559_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14612db4 | this.btnButtonList.UsrButtonList_Click_Detected | FP01559_ItemPopup.cs:264 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-0291a2c9 | this.btnButtonList.UsrButtonList_Click_Detected | FP01559_ItemPopup.cs:267 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7c0504c0 | this.btnButtonList.UsrButtonList_Click_Detected | FP01559_ItemPopup.cs:268 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01559_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25f8dde | this.Load | FP01559_ItemPopup.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ba0b101f | this.Load | FP01559_ItemPopup.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d6d75562 | this.Load | FP01559_ItemPopup.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01559_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64814d3a | this.Load | FP01559_ItemPopup.cs:131 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01559_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cba082c | Dispose | FP01559_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01559_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ec29bac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:207 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2ea5d9fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:211 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0586f33e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:213 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { Filter["ITEM_ID"] = txtItem.Text; Filter["CELL_ITEM_ID"] = txtItem.Text; Filter["… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e95e670 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:215 | lambda | DATA_OP | Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e6dc1763 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:216 | lambda | DATA_OP | Filter["CELL_ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-025da1a7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:217 | lambda | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-50d12fe3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:221 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01559_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "ADD_ITEM") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-08b0f5cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:223 | lambda | RETURN | return itemList; |  | 처리 중단/반환 |  |  |  |
| AC-e7498a80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:227 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8ace4144 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:230 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a7a1621 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01559_ItemPopup.cs:232 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01559_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a9cc88 | this.Load | FP01559_ItemPopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec31f181 | this.Load | FP01559_ItemPopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01559_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa955873 | this.Load | FP01559_ItemPopup.cs:148 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89af4501 | this.Load | FP01559_ItemPopup.cs:149 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01559_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19d53917 | (진입점 미연결) | FP01559_ItemPopup.cs:168 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01559_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c0f4246 | this.Load | FP01559_ItemPopup.cs:155 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a9a2a96 | this.Load | FP01559_ItemPopup.cs:156 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-1b24099c | this.Load | FP01559_ItemPopup.cs:160 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01559_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05641af5 | this.spdMain.CellClick | FP01559_ItemPopup.cs:279 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1a26b103 | this.spdMain.CellClick | FP01559_ItemPopup.cs:280 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9b5e88b4 | this.spdMain.CellClick | FP01559_ItemPopup.cs:283 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01559_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db972250 | this.spdMain.CellDoubleClick | FP01559_ItemPopup.cs:289 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-323f6b89 | this.spdMain.CellDoubleClick | FP01559_ItemPopup.cs:290 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1d019ee5 | this.spdMain.CellDoubleClick | FP01559_ItemPopup.cs:293 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-9f0eb621 | this.spdMain.CellDoubleClick | FP01559_ItemPopup.cs:296 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b45d4afa | this.spdMain.CellDoubleClick | FP01559_ItemPopup.cs:306 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01559_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd46a2ed | .ctor | FP01559_LineAddPopup.cs:103 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-cb08370c | .ctor | FP01559_LineAddPopup.cs:104 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP01559_LineAddPopup.btnCellItem_Click

진입점: this.btnCellItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cadab69 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:508 |  | POPUP | new FP01559_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-972ff81b | this.btnCellItem.Click | FP01559_LineAddPopup.cs:509 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-2de81769 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:511 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-85737f12 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:512 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-df665418 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:513 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c8a1364d | this.btnCellItem.Click | FP01559_LineAddPopup.cs:514 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-87334e5e | this.btnCellItem.Click | FP01559_LineAddPopup.cs:515 |  | DATA_OP | popup.Filter["CELL_ITEM_ID"] | Filter["CELL_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aad44235 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:516 |  | DATA_OP | popup.Filter["ITEM_ID"] | Filter["CELL_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1121c972 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:517 |  | DATA_OP | popup.Filter["NICK_NAME"] | Filter["CELL_NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-8d7c83f7 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:518 |  | DATA_OP | popup.Filter["FORM_INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5b835a84 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:520 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-df5e500f | this.btnCellItem.Click | FP01559_LineAddPopup.cs:522 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-00fa41fc | this.btnCellItem.Click | FP01559_LineAddPopup.cs:527 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["COMPANY_ID"] | data["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72459a35 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:528 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["DIVISION_ID"] | data["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-09200098 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:529 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["SITE_ID"] | data["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04fdfc41 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:530 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLANT_ID"] | data["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-db21fd37 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:531 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["CELL_NICK_NAME"] | txtNickName.Text = data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b4d7cb9 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:531 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtNickName.Text | data["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d4f37eb6 | this.btnCellItem.Click | FP01559_LineAddPopup.cs:533 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["CELL_ITEM_ID"] | txtItem.Text = data["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e90fc6db | this.btnCellItem.Click | FP01559_LineAddPopup.cs:533 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP01559_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-779f9db0 | this.btnClose.Click | FP01559_LineAddPopup.cs:277 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01559_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8000a12d | this.btnSave.Click | FP01559_LineAddPopup.cs:270 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01559_LineAddPopup.cboCellFactory_changed

진입점: cboCellFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba3e2aed | cboCellFactory.SelectedIndexChanged | FP01559_LineAddPopup.cs:260 |  | DATA_OP | Filter["CELL_FACTORY_ID"] | CString.GetCheckedListValue(dtCellFactory, cboCellFactory.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP01559_LineAddPopup.cboPackFactory_changed

진입점: cboPackFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7ef7a34 | cboPackFactory.SelectedIndexChanged | FP01559_LineAddPopup.cs:255 |  | DATA_OP | Filter["PACK_FACTORY_ID"] | CString.GetCheckedListValue(dtPackFactory, cboPackFactory.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP01559_LineAddPopup.cboType_changed

진입점: cboType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-630fe078 | cboType.SelectedIndexChanged | FP01559_LineAddPopup.cs:240 |  | DATA_OP | Filter["CATEGORY_TYPE"] | CString.GetCheckedListValue(dtCategoryType, cboType.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-9770bddd | cboType.SelectedIndexChanged | FP01559_LineAddPopup.cs:244 | if (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) | FLAG | dtCellFactory | dtCellFactory_temp2.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4366c189 | cboType.SelectedIndexChanged | FP01559_LineAddPopup.cs:244 | if (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) | DATA_OP | dtCellFactory_temp2.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3d702e96 | cboType.SelectedIndexChanged | FP01559_LineAddPopup.cs:247 | else of (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) | FLAG | dtCellFactory | dtCellFactory_temp1.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-34b2b07d | cboType.SelectedIndexChanged | FP01559_LineAddPopup.cs:247 | else of (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) | DATA_OP | dtCellFactory_temp1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-de99e5c0 | cboType.SelectedIndexChanged | FP01559_LineAddPopup.cs:249 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellFactory, cboCellFactory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01559_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3009e440 | this.btnSave.Click | FP01559_LineAddPopup.cs:299 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Select Cell Code") | 메시지 표시 |  |  |  |
| AC-155f75c9 | this.btnSave.Click | FP01559_LineAddPopup.cs:300 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-61f9fa5d | this.btnSave.Click | FP01559_LineAddPopup.cs:305 | if (GetFilter("PLAN_DATE") == "") | MESSAGE | MessageBox.Show | ("Select Plan Date") | 메시지 표시 |  |  |  |
| AC-e3422e2a | this.btnSave.Click | FP01559_LineAddPopup.cs:306 | if (GetFilter("PLAN_DATE") == "") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9d6b0555 | this.btnSave.Click | FP01559_LineAddPopup.cs:311 | if (GetFilter("PACK_FACTORY_ID") == "") | MESSAGE | MessageBox.Show | ("Select Bld.(Pack)") | 메시지 표시 |  |  |  |
| AC-e23666af | this.btnSave.Click | FP01559_LineAddPopup.cs:312 | if (GetFilter("PACK_FACTORY_ID") == "") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-15ad5372 | this.btnSave.Click | FP01559_LineAddPopup.cs:317 | if (GetFilter("CELL_FACTORY_ID") == "") | MESSAGE | MessageBox.Show | ("Select Bld.(Cell)") | 메시지 표시 |  |  |  |
| AC-65516d5b | this.btnSave.Click | FP01559_LineAddPopup.cs:318 | if (GetFilter("CELL_FACTORY_ID") == "") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ed5fedde | this.btnSave.Click | FP01559_LineAddPopup.cs:323 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-5b4e714b | this.btnSave.Click | FP01559_LineAddPopup.cs:324 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-accafea6 | this.btnSave.Click | FP01559_LineAddPopup.cs:332 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-5d652696 | this.btnSave.Click | FP01559_LineAddPopup.cs:333 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e30dc9c4 | this.btnSave.Click | FP01559_LineAddPopup.cs:338 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01559_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7208f82 | Dispose | FP01559_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01559_LineAddPopup.dpPlanDate_ValueChanged

진입점: drpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a5a0255 | drpPlanDate.ValueChanged | FP01559_LineAddPopup.cs:476 | try ▸ if (int.Parse(drpPlanDate.Value.ToString("yyyMMdd")) < int.Parse(Filter["PLAN_DATE"].ToString())) | MESSAGE | MessageBox.Show | ("Out of plan period ") | 메시지 표시 |  |  |  |
| AC-07e305db | drpPlanDate.ValueChanged | FP01559_LineAddPopup.cs:477 | try ▸ if (int.Parse(drpPlanDate.Value.ToString("yyyMMdd")) < int.Parse(Filter["PLAN_DATE"].ToString())) | VALUE_SET | drpPlanDate.Text | Filter["PLAN_DATE"] | 컨트롤 값 설정 |  |  |  |
| AC-ee640aee | drpPlanDate.ValueChanged | FP01559_LineAddPopup.cs:485 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01559_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8769a70 | this.Load | FP01559_LineAddPopup.cs:117 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d44a3d1 | this.Load | FP01559_LineAddPopup.cs:119 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0d7040f2 | this.Load | FP01559_LineAddPopup.cs:126 |  | FLAG | dtSave | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-4ffa7898 | this.Load | FP01559_LineAddPopup.cs:128 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CATEGORY_TYPE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e32818 | this.Load | FP01559_LineAddPopup.cs:129 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-18bd74ee | this.Load | FP01559_LineAddPopup.cs:130 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e367c7c7 | this.Load | FP01559_LineAddPopup.cs:131 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3d27cfe | this.Load | FP01559_LineAddPopup.cs:132 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-282a346d | this.Load | FP01559_LineAddPopup.cs:133 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3151ce06 | this.Load | FP01559_LineAddPopup.cs:134 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f41f565 | this.Load | FP01559_LineAddPopup.cs:135 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-54ad105c | this.Load | FP01559_LineAddPopup.cs:136 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PACK_FACTORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d791c86e | this.Load | FP01559_LineAddPopup.cs:137 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fc1395c | this.Load | FP01559_LineAddPopup.cs:138 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e395ee2 | this.Load | FP01559_LineAddPopup.cs:139 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb18307f | this.Load | FP01559_LineAddPopup.cs:141 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e22f9c50 | this.Load | FP01559_LineAddPopup.cs:141 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP01559_LineAddPopup.GetFilter

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d4a57f2 | this.btnSave.Click | FP01559_LineAddPopup.cs:288 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01559_LineAddPopup.GetPlantFactory

진입점: this.Load / this.btnCellItem.Click [if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-205f64eb | this.Load 외 1 | FP01559_LineAddPopup.cs:217 |  | DATA_OP | Filter["SEL_INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0e2a662a | this.Load 외 1 | FP01559_LineAddPopup.cs:218 |  | FLAG | dtPackFactory | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-df3b43bc | this.Load 외 1 | FP01559_LineAddPopup.cs:218 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "ADD_FACTORY") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4c7f0be0 | this.Load 외 1 | FP01559_LineAddPopup.cs:219 |  | LIST_REBIND | clsCtrl.setListBox | (dtPackFactory, cboPackFactory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c06290e1 | this.Load 외 1 | FP01559_LineAddPopup.cs:221 |  | DATA_OP | Filter["SEL_INSTANCE_ID"] | Filter["FORM_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0121d035 | this.Load 외 1 | FP01559_LineAddPopup.cs:222 |  | FLAG | dtCellFactory | Data_FP.CallGeneralProcedure2(("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-03317ae2 | this.Load 외 1 | FP01559_LineAddPopup.cs:222 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01559_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "ADD_FACTORY") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-25dbe650 | this.Load 외 1 | FP01559_LineAddPopup.cs:224 |  | FLAG | dtCellFactory_temp1 | dtCellFactory.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ea8810b2 | this.Load 외 1 | FP01559_LineAddPopup.cs:224 |  | DATA_OP | dtCellFactory.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-14156af0 | this.Load 외 1 | FP01559_LineAddPopup.cs:228 | if (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) | FLAG | dtCellFactory | dtCellFactory_temp2.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6d4a825a | this.Load 외 1 | FP01559_LineAddPopup.cs:228 | if (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) | DATA_OP | dtCellFactory_temp2.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34ae9a40 | this.Load 외 1 | FP01559_LineAddPopup.cs:231 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellFactory, cboCellFactory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e9d26fa8 | this.Load 외 1 | FP01559_LineAddPopup.cs:233 |  | DATA_OP | Filter["PACK_FACTORY_ID"] | CString.GetCheckedListValue(dtPackFactory, cboPackFactory.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-36740868 | this.Load 외 1 | FP01559_LineAddPopup.cs:234 |  | DATA_OP | Filter["CELL_FACTORY_ID"] | CString.GetCheckedListValue(dtCellFactory, cboCellFactory.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP01559_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-337d9044 | this.Load | FP01559_LineAddPopup.cs:151 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-556484a3 | this.Load | FP01559_LineAddPopup.cs:155 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-6e951b5e | this.Load | FP01559_LineAddPopup.cs:156 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-ad7c9659 | this.Load | FP01559_LineAddPopup.cs:157 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0daacf0e | this.Load | FP01559_LineAddPopup.cs:161 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0b677f11 | this.Load | FP01559_LineAddPopup.cs:163 |  | DATA_OP | Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f44432b6 | this.Load | FP01559_LineAddPopup.cs:164 |  | VALUE_SET | drpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-a8f89cf7 | this.Load | FP01559_LineAddPopup.cs:167 |  | DATA_OP | dtDateMap.Select("IS_PLAN = 'Y' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c200f1ce | this.Load | FP01559_LineAddPopup.cs:167 |  | DATA_OP | dtDateMap.Select | ("IS_PLAN = 'Y' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-c19bbdc6 | this.Load | FP01559_LineAddPopup.cs:169 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-b28c60be | this.Load | FP01559_LineAddPopup.cs:173 |  | FLAG | dtCategoryType | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-d28468fb | this.Load | FP01559_LineAddPopup.cs:174 |  | DATA_OP | dtCategoryType.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-764bbbc7 | this.Load | FP01559_LineAddPopup.cs:175 |  | DATA_OP | dtCategoryType.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1bb3b95 | this.Load | FP01559_LineAddPopup.cs:176 |  | DATA_OP | dtCategoryType.Rows.Add | ("REQUEST", "REQUEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b7354e0 | this.Load | FP01559_LineAddPopup.cs:177 |  | DATA_OP | dtCategoryType.Rows.Add | ("MOVING", "MOVING") | 데이터 객체 조작/조회 |  |  |  |
| AC-50b96d93 | this.Load | FP01559_LineAddPopup.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategoryType, cboType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1ef85305 | this.Load | FP01559_LineAddPopup.cs:179 |  | DATA_OP | Filter["CATEGORY_TYPE"] | CString.GetCheckedListValue(dtCategoryType, cboType.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-629788fc | this.Load | FP01559_LineAddPopup.cs:181 |  | FLAG | dtCellFactory_temp1 | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-27d78115 | this.Load | FP01559_LineAddPopup.cs:182 |  | DATA_OP | dtCellFactory_temp1.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ec5e744 | this.Load | FP01559_LineAddPopup.cs:183 |  | DATA_OP | dtCellFactory_temp1.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-9424bcdf | this.Load | FP01559_LineAddPopup.cs:184 |  | DATA_OP | dtCellFactory_temp1.Columns.Add | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-50509ad9 | this.Load | FP01559_LineAddPopup.cs:185 |  | DATA_OP | dtCellFactory_temp1.Rows.Add | ("-", "-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-d356111a | this.Load | FP01559_LineAddPopup.cs:187 |  | FLAG | dtCellFactory_temp2 | dtCellFactory_temp1.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0739c400 | this.Load | FP01559_LineAddPopup.cs:187 |  | DATA_OP | dtCellFactory_temp1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-45527d6e | this.Load | FP01559_LineAddPopup.cs:189 |  | VALUE_SET | txtItem.Text | Filter["CELL_ITEM_ID"] = InitRow["CELL_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-668275e6 | this.Load | FP01559_LineAddPopup.cs:189 |  | DATA_OP | Filter["CELL_ITEM_ID"] | InitRow["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-25895e15 | this.Load | FP01559_LineAddPopup.cs:190 |  | VALUE_SET | txtNickName.Text | Filter["CELL_NICK_NAME"] = InitRow["CELL_NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fef45d9f | this.Load | FP01559_LineAddPopup.cs:190 |  | DATA_OP | Filter["CELL_NICK_NAME"] | InitRow["CELL_NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec4d75d7 | this.Load | FP01559_LineAddPopup.cs:192 |  | DATA_OP | Filter["COMPANY_ID"] | InitRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5d770033 | this.Load | FP01559_LineAddPopup.cs:193 |  | DATA_OP | Filter["DIVISION_ID"] | InitRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6f63d0c3 | this.Load | FP01559_LineAddPopup.cs:194 |  | DATA_OP | Filter["SITE_ID"] | InitRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6c258b8 | this.Load | FP01559_LineAddPopup.cs:195 |  | DATA_OP | Filter["PLANT_ID"] | InitRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94b0fec6 | this.Load | FP01559_LineAddPopup.cs:196 |  | DATA_OP | Filter["CELL_ITEM_ID"] | InitRow["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-777dc470 | this.Load | FP01559_LineAddPopup.cs:198 |  | DATA_OP | Filter["PACK_INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP01559_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f3f72aa | this.btnSave.Click | FP01559_LineAddPopup.cs:347 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cf947ef8 | this.btnSave.Click | FP01559_LineAddPopup.cs:348 |  | DATA_OP | Filter["ITEM_ID"] | Filter["CELL_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cab1ab32 | this.btnSave.Click | FP01559_LineAddPopup.cs:349 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-000f0ded | this.btnSave.Click | FP01559_LineAddPopup.cs:351 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | ("PR_UI_FP01559_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "ADD_DUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b7b3d69 | this.btnSave.Click | FP01559_LineAddPopup.cs:355 | if (dtDup.Good() && dtDup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Cell Code or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-75ca49ca | this.btnSave.Click | FP01559_LineAddPopup.cs:356 | if (dtDup.Good() && dtDup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-865e2e95 | this.btnSave.Click | FP01559_LineAddPopup.cs:359 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | ("PR_UI_FP01559_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "ADD_AUTH") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c4194abb | this.btnSave.Click | FP01559_LineAddPopup.cs:365 | if (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) ▸ if (dtAuth.Good() && string.IsNullOrEmpty(dtAuth.Rows[0]["PACK_FAC"].ToString())… | MESSAGE | MessageBox.Show | ("No authority to save pack.") | 메시지 표시 |  |  |  |
| AC-9c777f12 | this.btnSave.Click | FP01559_LineAddPopup.cs:366 | if (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) ▸ if (dtAuth.Good() && string.IsNullOrEmpty(dtAuth.Rows[0]["PACK_FAC"].ToString())… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db9aa4be | this.btnSave.Click | FP01559_LineAddPopup.cs:373 | else of (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) ▸ if (dtAuth.Good() && string.IsNullOrEmpty(dtAuth.Rows[0]["FORM_FAC"].ToStri… | MESSAGE | MessageBox.Show | ("No authority to save formation.") | 메시지 표시 |  |  |  |
| AC-0367b779 | this.btnSave.Click | FP01559_LineAddPopup.cs:374 | else of (Filter["CATEGORY_TYPE"].ToString().Equals("REQUEST")) ▸ if (dtAuth.Good() && string.IsNullOrEmpty(dtAuth.Rows[0]["FORM_FAC"].ToStri… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba1e247d | this.btnSave.Click | FP01559_LineAddPopup.cs:378 |  | DATA_OP | dtSave.SetFirst | ("COMPANY_ID", Filter["COMPANY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-20342327 | this.btnSave.Click | FP01559_LineAddPopup.cs:379 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3008516b | this.btnSave.Click | FP01559_LineAddPopup.cs:380 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e7613377 | this.btnSave.Click | FP01559_LineAddPopup.cs:381 |  | DATA_OP | dtSave.SetFirst | ("COMPANY_ID", Filter["COMPANY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1be818a7 | this.btnSave.Click | FP01559_LineAddPopup.cs:382 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-61b472cd | this.btnSave.Click | FP01559_LineAddPopup.cs:383 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bff50c03 | this.btnSave.Click | FP01559_LineAddPopup.cs:384 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-33fb6e7f | this.btnSave.Click | FP01559_LineAddPopup.cs:385 |  | DATA_OP | dtSave.SetFirst | ("CELL_ITEM_ID", txtItem.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a5cc2d47 | this.btnSave.Click | FP01559_LineAddPopup.cs:386 |  | DATA_OP | dtSave.SetFirst | ("CELL_FACTORY_ID", Filter["CELL_FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cf453e74 | this.btnSave.Click | FP01559_LineAddPopup.cs:387 |  | DATA_OP | dtSave.SetFirst | ("PACK_FACTORY_ID", Filter["PACK_FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-462d6a2d | this.btnSave.Click | FP01559_LineAddPopup.cs:388 |  | DATA_OP | dtSave.SetFirst | ("CATEGORY_TYPE", Filter["CATEGORY_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cc79fef0 | this.btnSave.Click | FP01559_LineAddPopup.cs:389 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", Filter["PLAN_DATE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8b85cac0 | this.btnSave.Click | FP01559_LineAddPopup.cs:390 |  | DATA_OP | dtSave.SetFirst | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ba3ef148 | this.btnSave.Click | FP01559_LineAddPopup.cs:399 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-4aa66bcb | this.btnSave.Click | FP01559_LineAddPopup.cs:400 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f287274 | this.btnSave.Click | FP01559_LineAddPopup.cs:402 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cafb5ec5 | this.btnSave.Click | FP01559_LineAddPopup.cs:411 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01559_IN_HOUSE_REQUEST_MOVING_PLAN", "merge_add", dtSave, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_add] \| FP\Planning\FP0155… | 엔드포인트 호출 |  |  |  |
| AC-85f4a86c | this.btnSave.Click | FP01559_LineAddPopup.cs:420 | try ▸ else of (dtResult == null) ▸ if (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce3641c8 | this.btnSave.Click | FP01559_LineAddPopup.cs:424 | try ▸ else of (dtResult == null) ▸ if (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-6fc03e77 | this.btnSave.Click | FP01559_LineAddPopup.cs:431 | try ▸ else of (dtResult == null) ▸ else of (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7c41b35 | this.btnSave.Click | FP01559_LineAddPopup.cs:436 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01559_LineAddPopup.SetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d695e47e | (진입점 미연결) | FP01559_LineAddPopup.cs:283 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP01559_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80412855 | .ctor | FP01559_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-ad556d02 | .ctor | FP01559_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-58ccd8d1 | .ctor | FP01559_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-1ccaf093 | .ctor | FP01559_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP01559_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8f50b04 | Dispose | FP01559_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01559_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e8dfc7c | this.Load | FP01559_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP01559_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2187e4f7 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:159 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-39320fc5 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:160 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-cbc5d326 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:166 |  | DATA_OP | ctrls.Add | (chk_request_p) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9499b6c | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:167 |  | DATA_OP | ctrls.Add | (chk_request_r) | 데이터 객체 조작/조회 |  |  |  |
| AC-963fd168 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:168 |  | DATA_OP | ctrls.Add | (chk_request_eoh) | 데이터 객체 조작/조회 |  |  |  |
| AC-92d8121c | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:170 |  | DATA_OP | ctrls.Add | (chk_moving_p) | 데이터 객체 조작/조회 |  |  |  |
| AC-09de5c44 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:171 |  | DATA_OP | ctrls.Add | (chk_moving_do) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cd7aed5 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:172 |  | DATA_OP | ctrls.Add | (chk_moving_ship) | 데이터 객체 조작/조회 |  |  |  |
| AC-44764416 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:173 |  | DATA_OP | ctrls.Add | (chk_moving_eoh) | 데이터 객체 조작/조회 |  |  |  |
| AC-43863296 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:176 |  | DATA_OP | ctrls.Add | (chk_total_r) | 데이터 객체 조작/조회 |  |  |  |
| AC-709b0697 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:177 |  | DATA_OP | ctrls.Add | (chk_total_do) | 데이터 객체 조작/조회 |  |  |  |
| AC-71945057 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:178 |  | DATA_OP | ctrls.Add | (chk_total_meet) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f6a449d | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:179 |  | DATA_OP | ctrls.Add | (chk_total_eoh) | 데이터 객체 조작/조회 |  |  |  |
| AC-d13fdac7 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:182 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-6227ca17 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:182 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-403e3672 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:189 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-3a1a8567 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:193 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-9e65fec5 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:197 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP01559_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-190079a8 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:124 |  | VALUE_SET | chk_request_p.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-55cebf53 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:125 |  | VALUE_SET | chk_request_r.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-95644acd | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:126 |  | VALUE_SET | chk_request_eoh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fda01303 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:128 |  | VALUE_SET | chk_moving_p.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f86ac7e9 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:129 |  | VALUE_SET | chk_moving_do.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-26ffbc39 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_moving_ship.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cff9ce35 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_moving_eoh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-63bc7f14 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_total_r.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8bbee3f1 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_total_do.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2c3b9657 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_total_meet.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-75085b99 | this.Load 외 1 | FP01559_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_total_eoh.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP01559_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-393135ab | (진입점 미연결) | FP01559_MeasureSetForm_Popup.cs:257 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-bda4b31b | (진입점 미연결) | FP01559_MeasureSetForm_Popup.cs:268 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bad94ca4 | (진입점 미연결) | FP01559_MeasureSetForm_Popup.cs:279 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP01559_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7de61d65 | this.Load | FP01559_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa961f83 | this.Load | FP01559_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01559_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d10a8435 | this.usrButton1.Click | FP01559_MeasureSetForm_Popup.cs:241 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-9e7f9e3f | this.usrButton1.Click | FP01559_MeasureSetForm_Popup.cs:241 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-2ed196d2 | this.usrButton1.Click | FP01559_MeasureSetForm_Popup.cs:243 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-6566e496 | this.usrButton1.Click | FP01559_MeasureSetForm_Popup.cs:247 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-1e7b08d8 | this.usrButton1.Click | FP01559_MeasureSetForm_Popup.cs:248 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-4f32a86a | this.usrButton1.Click | FP01559_MeasureSetForm_Popup.cs:250 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-598bddc4 | this.usrButton1.Click | FP01559_MeasureSetForm_Popup.cs:252 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP01559_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7309bd18 | this.usrButton2.Click | FP01559_MeasureSetForm_Popup.cs:215 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-a382708c | this.usrButton2.Click | FP01559_MeasureSetForm_Popup.cs:215 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-0bf0b463 | this.usrButton2.Click | FP01559_MeasureSetForm_Popup.cs:217 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-d74f99f7 | this.usrButton2.Click | FP01559_MeasureSetForm_Popup.cs:221 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-0277a7d7 | this.usrButton2.Click | FP01559_MeasureSetForm_Popup.cs:222 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-d613ea90 | this.usrButton2.Click | FP01559_MeasureSetForm_Popup.cs:223 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-f34c745a | this.usrButton2.Click | FP01559_MeasureSetForm_Popup.cs:224 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

