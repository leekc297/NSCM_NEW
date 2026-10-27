# AS-IS 액션 대조표 — SCP0079

> 원천: `Doc/asisfacts/screens/SCP0079/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 284행 · 메서드 38 · 종류 DATA_OP 61 · GRID_INIT 39 · UI_PROP 31 · FLAG 23 · LIST_REBIND 21 · COMBO_DATA 17 · POPUP 14 · ENDPOINT 13 · GRID_SET 13 · UI_MISC 11 · RETURN 11 · VALUE_SET 10 · MESSAGE 4 · GRID_CLEAR 3 · VALIDATE 3 · GRID_BIND 2 · CALL_EXT 2 · THROW 2 · STATE 2 · GRID_LOCK 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 2


## SCP0079_RTF_Analysis_Report_DetailPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-834b7d9a | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:126 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-df6c56f4 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:127 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-93de1d4b | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:129 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b8295c8 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:121 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edc05707 | Dispose | SCP0079_RTF_Analysis_Report_DetailPopup.designer.cs:20 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba5ef44e | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:164 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e2f83c62 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:168 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL") ⇒ SCP.SCP0079_GET_RTF_ANALYSIS_REPORT_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-a074f189 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:169 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-15f25aff | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:170 | lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd_A"] | PLAN_START_YYYYMMDD_A | 행/컬럼 값 대입 |  |  |  |
| AC-c1d918f3 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:171 | lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd_B"] | PLAN_START_YYYYMMDD_B | 행/컬럼 값 대입 |  |  |  |
| AC-ad3e22dc | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:172 | lambda | DATA_OP | request.Parameters["p_plan_type_A"] | PLAN_TYPE_A | 행/컬럼 값 대입 |  |  |  |
| AC-3be99d05 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:173 | lambda | DATA_OP | request.Parameters["p_plan_type_B"] | PLAN_TYPE_B | 행/컬럼 값 대입 |  |  |  |
| AC-42da5387 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:174 | lambda | DATA_OP | request.Parameters["p_seq_A"] | SEQ_A | 행/컬럼 값 대입 |  |  |  |
| AC-689662b0 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:175 | lambda | DATA_OP | request.Parameters["p_seq_B"] | SEQ_B | 행/컬럼 값 대입 |  |  |  |
| AC-0a3aa28d | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:176 | lambda | DATA_OP | request.Parameters["p_division_id"] | DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-73d250c2 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:177 | lambda | DATA_OP | request.Parameters["p_biz_type"] | BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-bb7079e4 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:178 | lambda | DATA_OP | request.Parameters["p_project_code"] | PROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-e7eb056c | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:179 | lambda | DATA_OP | request.Parameters["p_item_id"] | ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-009b3a22 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:180 | lambda | DATA_OP | request.Parameters["p_measure_list"] | MEASURE_LIST | 행/컬럼 값 대입 |  |  |  |
| AC-9656a6ab | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:181 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | FROM_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-fa10072b | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:182 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | TO_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-4ca9eb05 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:183 | lambda | DATA_OP | request.Parameters["p_version_id"] | VERSION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-355d5486 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:184 | lambda | DATA_OP | request.Parameters["p_user_id"] | USER_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1db747b6 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:185 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9c379b7d | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:186 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b7759935 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:188 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0c090626 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:192 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f7735914 | this.Load 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:199 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff6daf72 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.GetSpdTitle

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71ccf990 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:359 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-c422d1fe | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:360 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4f56cdf4 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:361 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ab874fef | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:363 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0faf54a5 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:363 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e5c38ce | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:136 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ae29b228 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:140 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.InitSpreadDateColumn

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5a30d79 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:236 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f66ae9af | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:240 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e56e8a35 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:241 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0d16ef50 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:245 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-0db8323b | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:252 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-077c8df7 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:253 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cebe5cab | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:258 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f22941c6 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:259 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6df101b | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:267 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de6f271c | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:268 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-442e2968 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:278 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a682e46e | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:279 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91fce218 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:280 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8be42f73 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:281 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.Set_backgroupColor

진입점: this.Load [if (ds.Tables[0].Rows.Count > 0)] / FindButton [if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2eb330e0 | this.Load [if (ds.Tables[0].Rows.Count > 0)] 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:316 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d0d3478e | this.Load [if (ds.Tables[0].Rows.Count > 0)] 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:334 | for (i < rowcnt) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-8b81c9d6 | this.Load [if (ds.Tables[0].Rows.Count > 0)] 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:342 | for (i < rowcnt) ▸ if (siMain.GetValue(i, iCol_VERSION_ID).Equals("GAP")) | GRID_SET | this.siMain.ActiveSheet.Cells[i, iCol_VERSION_ID, i, iCol_MEASURE_LABEL - 1].BackColor | Color.FromArgb(196, 189, 151) | 그리드 속성/값 설정 |  |  |  |
| AC-311c354e | this.Load [if (ds.Tables[0].Rows.Count > 0)] 외 1 | SCP0079_RTF_Analysis_Report_DetailPopup.cs:345 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0079_RTF_Analysis_Report_DetailPopup.SetSpreadColumn

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc949f5a | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:293 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-aa9b4d9a | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:297 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (siObj.GetColumnTag(iCol).IndexOf("D_") == 0) ▸ if (siObj.GetColumnTag(iCol).IndexOf… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-32431d99 | this.Load | SCP0079_RTF_Analysis_Report_DetailPopup.cs:302 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report.BtnColumn_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fdb922a | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:499 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0079", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-8fd613c6 | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:500 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-055c72af | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:501 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0079_RTF_Analysis_Report.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c2acea5 | this.btnItem_Id.Click | SCP0079_RTF_Analysis_Report.cs:941 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-99516bcf | this.btnItem_Id.Click | SCP0079_RTF_Analysis_Report.cs:943 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ba72272a | this.btnItem_Id.Click | SCP0079_RTF_Analysis_Report.cs:944 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bc3254e4 | this.btnItem_Id.Click | SCP0079_RTF_Analysis_Report.cs:945 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1aef21ea | this.btnItem_Id.Click | SCP0079_RTF_Analysis_Report.cs:950 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17faa5a4 | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:974 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0079", measure, false) | 팝업/폼 생성 |  |  |  |
| AC-913a191c | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:975 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-952fb83e | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:976 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a92527be | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:979 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-1624ee5f | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:981 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report.BtnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a2d34e5 | this.btnProject.Click | SCP0079_RTF_Analysis_Report.cs:959 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-af82c1cc | this.btnProject.Click | SCP0079_RTF_Analysis_Report.cs:961 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2290ee8f | this.btnProject.Click | SCP0079_RTF_Analysis_Report.cs:962 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1c6a4ba8 | this.btnProject.Click | SCP0079_RTF_Analysis_Report.cs:963 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-935dc271 | this.btnProject.Click | SCP0079_RTF_Analysis_Report.cs:968 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21fb5558 | cboPlanDate.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:526 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-89e13605 | cboPlanDate.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:526 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bad4c50e | cboPlanDate.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:527 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f12f1eac | cboPlanDate.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:531 | if (ScpUtils.CheckDataEmpty(pPlanType)) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-c487f65a | cboPlanDate.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:533 | else of (ScpUtils.CheckDataEmpty(pPlanType)) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, pPlanType) | 목록 컨트롤 재구성 |  |  |  |
| AC-8ce958d3 | cboPlanDate.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:536 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-11cf0aba | cboPlanDate.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:537 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0079_RTF_Analysis_Report.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de476c17 | cboPlanSeq.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:552 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0079_RTF_Analysis_Report.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-071cd4ef | cboPlanType.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:546 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d7d3af49 | cboPlanType.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:547 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0079_RTF_Analysis_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86d964fe | this.Load | SCP0079_RTF_Analysis_Report.cs:246 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-427d66da | this.Load | SCP0079_RTF_Analysis_Report.cs:247 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bf669096 | this.Load | SCP0079_RTF_Analysis_Report.cs:248 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0079_RTF_Analysis_Report.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0199b03 | this.Load | SCP0079_RTF_Analysis_Report.cs:150 |  | UI_PROP | usrConditionPanel1.Height | 125 | 속성 Height 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ff49a3e | Dispose | SCP0079_RTF_Analysis_Report.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0079_RTF_Analysis_Report.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-006e7b57 | EditButton | SCP0079_RTF_Analysis_Report.cs:588 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4366949 | EditButton | SCP0079_RTF_Analysis_Report.cs:589 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0079_RTF_Analysis_Report.FindData_Main

진입점: cboBucketType.SelectedIndexChanged / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dae863e | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:617 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-43a75784 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:620 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b528d0d4 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:620 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff2e5b0a | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:621 | try | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-3c876f23 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:621 | try ▸ if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01faa19a | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:650 | try ▸ if (DateTime.Compare(dtMain, dtGap) < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00345") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e5e55c37 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:651 | try ▸ if (DateTime.Compare(dtMain, dtGap) < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57197879 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:656 | try ▸ if (DateTime.Compare(dtMain, dtGap) == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00348") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a7e3149 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:657 | try ▸ if (DateTime.Compare(dtMain, dtGap) == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73ed662d | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:660 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8f89cab2 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:666 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-67bef524 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:667 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e59053a | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:671 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0079_GET_RTF_ANALYSIS_REPORT") ⇒ SCP.SCP0079_GET_RTF_ANALYSIS_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-2114cc11 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:672 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fcb64d34 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:673 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd_A"] | p_plan_start_yyyymmdd_A | 행/컬럼 값 대입 |  |  |  |
| AC-06c00766 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:674 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd_B"] | p_plan_start_yyyymmdd_B | 행/컬럼 값 대입 |  |  |  |
| AC-0d1e5e7a | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:675 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type_A"] | p_plan_type_A | 행/컬럼 값 대입 |  |  |  |
| AC-4cb82dc0 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:676 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type_B"] | p_plan_type_B | 행/컬럼 값 대입 |  |  |  |
| AC-bdcff80b | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:677 | try ▸ lambda | DATA_OP | request.Parameters["p_seq_A"] | p_seq_A | 행/컬럼 값 대입 |  |  |  |
| AC-c7da16be | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:678 | try ▸ lambda | DATA_OP | request.Parameters["p_seq_B"] | p_seq_B | 행/컬럼 값 대입 |  |  |  |
| AC-d3c9d6ba | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:679 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-011088ce | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:680 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-e2838c35 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:681 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | p_team_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa715ea0 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:682 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-54f992e4 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:683 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ccf3e01 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:684 | try ▸ lambda | DATA_OP | request.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-d452c998 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:685 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bf3f19aa | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:686 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c4361bd2 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:687 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket_type"] | p_bucket_type | 행/컬럼 값 대입 |  |  |  |
| AC-2fbe9779 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:688 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-eae8436a | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:689 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7c5062f4 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:691 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d619356c | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:693 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9d9c8835 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:700 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6ee42c3f | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:701 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3fbfecaa | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:704 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1bbce0cb | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:711 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-791a9ac7 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:719 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c596a812 | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:720 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01efa4be | cboBucketType.SelectedIndexChanged 외 1 | SCP0079_RTF_Analysis_Report.cs:724 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0079_RTF_Analysis_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fca1314a | this.Load | SCP0079_RTF_Analysis_Report.cs:138 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0079_RTF_Analysis_Report.GetDataTableTempFN

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afade2c3 | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:396 |  | DATA_OP | tmpDataTable.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd0e7462 | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:397 |  | DATA_OP | tmpDataTable.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-14e76a38 | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:398 |  | DATA_OP | tmpDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26698ccc | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:399 |  | DATA_OP | drRow["CODE"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-5480f565 | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:400 |  | DATA_OP | drRow["NAME"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-6ce7e46c | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:401 |  | DATA_OP | tmpDataTable.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-bce1b39e | (진입점 미연결) | SCP0079_RTF_Analysis_Report.cs:403 |  | RETURN | return tmpDataTable; |  | 처리 중단/반환 |  |  |  |

## SCP0079_RTF_Analysis_Report.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c4f1e83 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:825 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-94ade238 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:826 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-9a477afe | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:827 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-d89509b1 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:828 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-622ddc85 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:829 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-336df2ea | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:833 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0079_RTF_Analysis_Report.GetSpdTitle

진입점: this.Load / cboBucketType.SelectedIndexChanged [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca0652b5 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:810 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-17ec40e0 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:811 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1a6c3fdc | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:812 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e15cb1d1 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:814 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-40c4bd3c | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:814 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0079_RTF_Analysis_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3721a01d | this.Load | SCP0079_RTF_Analysis_Report.cs:157 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-f70ac0f7 | this.Load | SCP0079_RTF_Analysis_Report.cs:160 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-7c83f8f7 | this.Load | SCP0079_RTF_Analysis_Report.cs:162 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9816af32 | this.Load | SCP0079_RTF_Analysis_Report.cs:165 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-76fbfce4 | this.Load | SCP0079_RTF_Analysis_Report.cs:168 |  | VALUE_SET | cboDivision.SelectedValue | "82" | 컨트롤 값 설정 |  |  |  |
| AC-8aba7bf1 | this.Load | SCP0079_RTF_Analysis_Report.cs:169 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-2b92b664 | this.Load | SCP0079_RTF_Analysis_Report.cs:172 |  | FLAG | dtBizType | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-43f81f24 | this.Load | SCP0079_RTF_Analysis_Report.cs:172 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f455e582 | this.Load | SCP0079_RTF_Analysis_Report.cs:173 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4a255c1a | this.Load | SCP0079_RTF_Analysis_Report.cs:176 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb8cbd54 | this.Load | SCP0079_RTF_Analysis_Report.cs:176 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3656f7d5 | this.Load | SCP0079_RTF_Analysis_Report.cs:177 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e81c4f81 | this.Load | SCP0079_RTF_Analysis_Report.cs:179 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-ae21347e | this.Load | SCP0079_RTF_Analysis_Report.cs:179 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d524d730 | this.Load | SCP0079_RTF_Analysis_Report.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-524b7d4e | this.Load | SCP0079_RTF_Analysis_Report.cs:184 |  | FLAG | dtBucketType | ScpUtils.GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-7a1380ff | this.Load | SCP0079_RTF_Analysis_Report.cs:184 |  | CALL_EXT | ScpUtils.GetBucketType | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-387d462d | this.Load | SCP0079_RTF_Analysis_Report.cs:185 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ec4b1a44 | this.Load | SCP0079_RTF_Analysis_Report.cs:187 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report.InitSpread

진입점: this.Load / cboBucketType.SelectedIndexChanged [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a9a0d10 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:254 |  | GRID_INIT | siMain.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3760771b | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:258 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-990437d9 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:263 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0079_RTF_Analysis_Report.InitSpreadDateColumn

진입점: this.Load / cboBucketType.SelectedIndexChanged [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3a57fd0 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:437 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6867a726 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:438 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a31b280c | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:441 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed64a87e | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:442 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4b2814e5 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:445 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-fd574ad0 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:451 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a7f6512 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:452 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7c5e54f | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:457 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ca8e40f | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:458 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2986cae3 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:465 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d11009e | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:466 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbb7292f | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:476 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5747744c | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:477 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd772f08 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:478 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45dfbc0d | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:479 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0079_RTF_Analysis_Report.Set_backgroupColor

진입점: cboBucketType.SelectedIndexChanged [try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c44ec98 | cboBucketType.SelectedIndexChanged [try ▸ if (ds.Tables[0].R… 외 1 | SCP0079_RTF_Analysis_Report.cs:903 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-64779289 | cboBucketType.SelectedIndexChanged [try ▸ if (ds.Tables[0].R… 외 1 | SCP0079_RTF_Analysis_Report.cs:921 | for (i < rowcnt) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-f15cfb59 | cboBucketType.SelectedIndexChanged [try ▸ if (ds.Tables[0].R… 외 1 | SCP0079_RTF_Analysis_Report.cs:929 | for (i < rowcnt) ▸ if (siMain.GetValue(i, iCol_VERSION_ID).Equals("GAP")) | GRID_SET | this.siMain.ActiveSheet.Cells[i, iCol_VERSION_ID, i, iCol_MEASURE_LABEL - 1].BackColor | Color.FromArgb(196, 189, 151) | 그리드 속성/값 설정 |  |  |  |
| AC-c6d61862 | cboBucketType.SelectedIndexChanged [try ▸ if (ds.Tables[0].R… 외 1 | SCP0079_RTF_Analysis_Report.cs:932 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0079_RTF_Analysis_Report.Set_GapDate

진입점: this.Load [try] / cboDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9469978d | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:321 | try | FLAG | dtGapDate | Data.Common(Data.Type.DATE_WEEKLY, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-f04e703f | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:321 | try | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-278cf737 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:322 | try | LIST_REBIND | clsCtrl.setListBox | (dtGapDate, cboGapDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1a0ef25f | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:331 | try ▸ foreach (DataRow row in dtGapDate.Rows) | CALL_EXT | ScpUtils.CheckDateFast | (gapDate, planDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df3d7d7b | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:333 | try ▸ foreach (DataRow row in dtGapDate.Rows) ▸ if (ScpUtils.CheckDateFast(gapDate, planDate)) | LIST_REBIND | clsCtrl.setListBox | (dtGapDate, cboGapDate, false, gapDate) | 목록 컨트롤 재구성 |  |  |  |
| AC-add8f743 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:343 | try | FLAG | dtGapType | Data.Common(Data.Type.PlanType, false, pDivisionID, pGapDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-cd77af22 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:343 | try | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, pDivisionID, pGapDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9b18bb0 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:346 | try | ENDPOINT | ScpUtils.FindData | (dtGapType, "code", "FN") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03085949 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:350 | try ▸ if (ScpUtils.CheckDataEmpty(findRow)) | DATA_OP | dtGapType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6e87387 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:351 | try ▸ if (ScpUtils.CheckDataEmpty(findRow)) | DATA_OP | drType["code"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-b2dbf7d2 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:352 | try ▸ if (ScpUtils.CheckDataEmpty(findRow)) | DATA_OP | drType["name"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-7fbbc3d2 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:353 | try ▸ if (ScpUtils.CheckDataEmpty(findRow)) | DATA_OP | dtGapType.Rows.Add | (drType) | 데이터 객체 조작/조회 |  |  |  |
| AC-21d216cc | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:355 | try | LIST_REBIND | clsCtrl.setListBox | (dtGapType, cboGapType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f75d8044 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:358 | try ▸ if (ScpUtils.CheckDataEmpty(dtGapType) == false) | VALUE_SET | cboGapType.SelectedIndex | dtGapType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-46dc0b0b | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:359 | try ▸ if (ScpUtils.CheckDataEmpty(dtGapType) == false) | LIST_REBIND | clsCtrl.setListBox | (dtGapType, cboGapType, false, "FN") | 목록 컨트롤 재구성 |  |  |  |
| AC-d9ff3358 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:365 | try | FLAG | dtGapSeq | Data.Common(Data.Type.PlanSeq, false, pDivisionID, pGapDate, pGapType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-03e59baa | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:365 | try | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, pDivisionID, pGapDate, pGapType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f3b91f49 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:370 | try ▸ if (ScpUtils.CheckDataEmpty(dtGapSeq)) | DATA_OP | dtGapSeq.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dc28f331 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:371 | try ▸ if (ScpUtils.CheckDataEmpty(dtGapSeq)) | DATA_OP | drSeq["CODE"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-735e88a5 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:372 | try ▸ if (ScpUtils.CheckDataEmpty(dtGapSeq)) | DATA_OP | drSeq["NAME"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-c0690130 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:373 | try ▸ if (ScpUtils.CheckDataEmpty(dtGapSeq)) | DATA_OP | dtGapSeq.Rows.Add | (drSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-a771119a | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:376 | try | LIST_REBIND | clsCtrl.setListBox | (dtGapSeq, cboGapSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c2fe789f | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:383 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0079_RTF_Analysis_Report.Set_PlanDate

진입점: this.Load [try] / cboDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-616b4819 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:277 | try | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.PlanDate_FN, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-187b3ffa | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:277 | try | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanDate_FN, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b148af5b | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:278 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3fdef0ab | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:286 | try | DATA_OP | tmpDataTable.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f86db00 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:287 | try | DATA_OP | tmpDataTable.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-780df787 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:289 | try | DATA_OP | tmpDataTable.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-30035ec1 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:290 | try | DATA_OP | drRow["CODE"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-f6a0292e | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:291 | try | DATA_OP | drRow["NAME"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-5a6b19b0 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:292 | try | DATA_OP | tmpDataTable.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e23118b | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:294 | try | LIST_REBIND | clsCtrl.setListBox | (tmpDataTable, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8ee1a188 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:298 | try ▸ if (tmpDataTable.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | tmpDataTable.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-3bf98da5 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:299 | try ▸ if (tmpDataTable.Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (tmpDataTable, cboPlanType, false, "FN") | 목록 컨트롤 재구성 |  |  |  |
| AC-f6d1d158 | this.Load [try] 외 1 | SCP0079_RTF_Analysis_Report.cs:310 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0079_RTF_Analysis_Report.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c81b38fe | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:197 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5ca65440 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:201 | try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtVersion | Data_SCP.Common(Data_SCP.Type.WaterfallVer_FG, false, division, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-4420c4fa | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:201 | try ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.WaterfallVer_FG, false, division, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2af4a016 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:211 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-8c9e897c | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:212 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e453f5b3 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:216 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-87cde351 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:221 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6bfd42a0 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:221 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-98781239 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:222 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtBizType | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-92959417 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:222 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1df96647 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:226 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtBizType | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-880b41f1 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:226 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd8af5df | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:227 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-c1f6105d | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:227 | try ▸ if (string.IsNullOrWhiteSpace(division) == false) ▸ else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "40,81,82") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-100f63a8 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:231 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a7fd8ab1 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:232 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-278589d4 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:234 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-caf2f9b8 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:234 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bbda9554 | this.Load 외 1 | SCP0079_RTF_Analysis_Report.cs:235 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0079_RTF_Analysis_Report.SetOperationGroupByDivision

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f31f16b | cboDivision.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:732 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtBizType | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae7908da | cboDivision.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:732 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-119e4bd7 | cboDivision.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:735 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtBizType | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc8ed47b | cboDivision.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:735 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-868a595d | cboDivision.SelectedIndexChanged | SCP0079_RTF_Analysis_Report.cs:738 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0079_RTF_Analysis_Report.SetPlanSeq

진입점: this.Load [try ▸ try] / cboDivision.SelectedIndexChanged [try ▸ try] / cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15e86309 | this.Load [try ▸ try] 외 3 | SCP0079_RTF_Analysis_Report.cs:608 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-d5c490d1 | this.Load [try ▸ try] 외 3 | SCP0079_RTF_Analysis_Report.cs:608 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6c1999b3 | this.Load [try ▸ try] 외 3 | SCP0079_RTF_Analysis_Report.cs:609 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0079_RTF_Analysis_Report.SetSpreadColumn

진입점: this.Load / cboBucketType.SelectedIndexChanged [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe0ed1bb | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:847 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf(… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-18dfd64c | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:851 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (siObj.GetColumnTag(iCol).Ind… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ca3886ec | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:858 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fccfdcab | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:862 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3f7dddec | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:869 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlVa… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4f9bc930 | this.Load 외 3 | SCP0079_RTF_Analysis_Report.cs:873 | for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlVa… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0079_RTF_Analysis_Report.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9de3787f | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:747 | if (e.ColumnHeader) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8dfbd7d | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:753 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") ▸ if (p_measure == DefMeasure.PACK_INV_EOH) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6aed8484 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:755 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | POPUP | new SCP0079_RTF_Analysis_Report_DetailPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9a9227c3 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:779 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.Width | 1300 | 속성 Width 설정 |  |  |  |
| AC-aa39f37c | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:780 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-bc8f1afe | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:781 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-049f01b9 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:783 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.PLAN_START_YYYYMMDD_A | p_plan_start_yyyymmdd_A | 속성 PLAN_START_YYYYMMDD_A 설정 |  |  |  |
| AC-ad3fb179 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:784 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.PLAN_START_YYYYMMDD_B | p_plan_start_yyyymmdd_B | 속성 PLAN_START_YYYYMMDD_B 설정 |  |  |  |
| AC-a80b777c | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:785 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.PLAN_TYPE_A | p_plan_type_A | 속성 PLAN_TYPE_A 설정 |  |  |  |
| AC-6d9fbb64 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:786 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.PLAN_TYPE_B | p_plan_type_B | 속성 PLAN_TYPE_B 설정 |  |  |  |
| AC-1f5b930a | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:787 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.SEQ_A | p_seq_A | 속성 SEQ_A 설정 |  |  |  |
| AC-f74276e2 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:788 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.SEQ_B | p_seq_B | 속성 SEQ_B 설정 |  |  |  |
| AC-77525e91 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:789 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.DIVISION_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 속성 DIVISION_ID 설정 |  |  |  |
| AC-2a636346 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:790 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.BIZ_TYPE | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.BIZ_TYPE)).ToString() | 속성 BIZ_TYPE 설정 |  |  |  |
| AC-5f28edcf | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:791 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.ITEM_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 속성 ITEM_ID 설정 |  |  |  |
| AC-ee7b0ed4 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:792 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.PROJECT_CODE | p_project_code | 속성 PROJECT_CODE 설정 |  |  |  |
| AC-815b82c9 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:793 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.FROM_YYYYMMDD | p_from_yyyymmdd | 속성 FROM_YYYYMMDD 설정 |  |  |  |
| AC-a3d3d6ca | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:794 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.TO_YYYYMMDD | p_to_yyyymmdd | 속성 TO_YYYYMMDD 설정 |  |  |  |
| AC-92aa531e | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:795 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.MEASURE_LIST | p_measure_lsit | 속성 MEASURE_LIST 설정 |  |  |  |
| AC-3fc80cb3 | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:796 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.VERSION_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefMain.VERSION_ID)).ToString() | 속성 VERSION_ID 설정 |  |  |  |
| AC-bec465ca | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:797 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | UI_PROP | popup.USER_ID | UserInfo.UserId | 속성 USER_ID 설정 |  |  |  |
| AC-78c7594f | this.spdMain.CellDoubleClick | SCP0079_RTF_Analysis_Report.cs:800 | if (siMain.GetColumnTag(e.Column).ToUpper() == "MEASURE_LABEL") | POPUP | popup.Show | () | 팝업/폼 열기 |  |  |  |

## SCP0079_RTF_Analysis_Report.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5be71165 | this.spdMain.TopChange | SCP0079_RTF_Analysis_Report.cs:511 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

