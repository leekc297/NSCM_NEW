# AS-IS 액션 대조표 — DMF0052

> 원천: `Doc/asisfacts/screens/DMF0052/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 237행 · 메서드 29 · 종류 DATA_OP 47 · GRID_INIT 38 · UI_PROP 24 · FLAG 21 · ENDPOINT 20 · UI_MISC 17 · GRID_SET 14 · POPUP 12 · RETURN 11 · STATE 8 · GRID_BIND 6 · GRID_LOCK 6 · VALUE_SET 3 · MESSAGE 3 · CALL_EXT 3 · THROW 1 · GRID_STYLE 1 · LIST_REBIND 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 4


## DMF0052_EDISummary.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7aae997 | this.btnItemId.Click | DMF0052_EDISummary.cs:738 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c10b25df | this.btnItemId.Click | DMF0052_EDISummary.cs:740 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-26800742 | this.btnItemId.Click | DMF0052_EDISummary.cs:741 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4ff2ad2a | this.btnItemId.Click | DMF0052_EDISummary.cs:742 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fddbb30b | this.btnItemId.Click | DMF0052_EDISummary.cs:748 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0052_EDISummary.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6bc2e18 | this.btnProject.Click | DMF0052_EDISummary.cs:716 |  | POPUP | new DMF000_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-6d3d2ab7 | this.btnProject.Click | DMF0052_EDISummary.cs:717 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-59c3e601 | this.btnProject.Click | DMF0052_EDISummary.cs:718 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-409fbc7b | this.btnProject.Click | DMF0052_EDISummary.cs:719 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d6f92ee1 | this.btnProject.Click | DMF0052_EDISummary.cs:725 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0052_EDISummary.btnRefresh_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882214a8 | (진입점 미연결) | DMF0052_EDISummary.Designer.cs:758 |  | THROW | throw new NotImplementedException(); |  | 예외 발생 |  |  |  |

## DMF0052_EDISummary.chkToday_CheckedChanged

진입점: this.chkToday.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-630b510e | this.chkToday.CheckedChanged | DMF0052_EDISummary.cs:678 | if (chkToday.Checked) | UI_PROP | drpPeriod.Text1 | DateTime.Now.ToString("yyyyMMdd") | 속성 Text1 설정 |  |  |  |
| AC-141d998e | this.chkToday.CheckedChanged | DMF0052_EDISummary.cs:679 | if (chkToday.Checked) | UI_PROP | drpPeriod.Text2 | DateTime.Now.ToString("yyyyMMdd") | 속성 Text2 설정 |  |  |  |
| AC-30ddbecb | this.chkToday.CheckedChanged | DMF0052_EDISummary.cs:683 | else of (chkToday.Checked) | UI_PROP | drpPeriod.Text1 | DateTime.Now.AddDays(-90).ToString("yyyyMMdd") | 속성 Text1 설정 |  |  |  |
| AC-b37b9e6c | this.chkToday.CheckedChanged | DMF0052_EDISummary.cs:684 | else of (chkToday.Checked) | UI_PROP | drpPeriod.Text2 | DateTime.Now.ToString("yyyyMMdd") | 속성 Text2 설정 |  |  |  |

## DMF0052_EDISummary.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d3b6611 | this.Load | DMF0052_EDISummary.cs:158 |  | GRID_INIT | this.AddSheet | (spdSummary, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-543fa2d4 | this.Load | DMF0052_EDISummary.cs:159 |  | FLAG | siMain | GetSheetInfo(spdSummary.Name, spdSummary.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cfe5701e | this.Load | DMF0052_EDISummary.cs:162 |  | GRID_INIT | this.AddSheet | (spdSummaryPJT, SpdSheet.shtPjt, SpdSheet.shtPjt, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4a7b67ad | this.Load | DMF0052_EDISummary.cs:163 |  | FLAG | siPjt | GetSheetInfo(spdSummaryPJT.Name, spdSummaryPJT.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d5b5d99 | this.Load | DMF0052_EDISummary.cs:166 |  | GRID_INIT | this.AddSheet | (spdSummaryStatus, SpdSheet.shtStatus, SpdSheet.shtStatus, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c5a45268 | this.Load | DMF0052_EDISummary.cs:167 |  | FLAG | siStatus | GetSheetInfo(spdSummaryStatus.Name, spdSummaryStatus.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-01e82039 | this.Load | DMF0052_EDISummary.cs:170 |  | GRID_INIT | this.AddSheet | (spdData, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-377ee1f3 | this.Load | DMF0052_EDISummary.cs:171 |  | GRID_INIT | this.AddSheet | (spdData, SpdSheet.shtErp, SpdSheet.shtErp, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ceab5d79 | this.Load | DMF0052_EDISummary.cs:173 |  | FLAG | siData | GetSheetInfo(spdData.Name, SpdSheet.shtDetail) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e1c1cf2 | this.Load | DMF0052_EDISummary.cs:174 |  | FLAG | siData | GetSheetInfo(spdData.Name, SpdSheet.shtErp) | 화면 필드/플래그 변경 |  |  |  |
| AC-51ce9f23 | this.Load | DMF0052_EDISummary.cs:176 |  | GRID_INIT | siData.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b1fb8b2 | this.Load | DMF0052_EDISummary.cs:179 |  | GRID_INIT | siData.ChangeSheet | (SpdSheet.shtErp) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98500ef2 | this.Load | DMF0052_EDISummary.cs:182 |  | GRID_INIT | siData.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f64bcde0 | this.Load | DMF0052_EDISummary.cs:186 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0052_EDISummary.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0dd6ff62 | this.Load | DMF0052_EDISummary.cs:152 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |
| AC-bb632c3b | this.Load | DMF0052_EDISummary.cs:153 |  | VALUE_SET | chkToday.Checked | false | 컨트롤 값 설정 |  |  |  |

## DMF0052_EDISummary.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c95ec15 | Dispose | DMF0052_EDISummary.Designer.cs:20 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0052_EDISummary.FindData_ERPData

진입점: this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGSCM)) && siPjt.GetText(e.Row, …) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtErp)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c25dede | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:515 |  | UI_MISC | siData.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0aa09994 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:529 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0052_GET_ERP_DATA") ⇒ DM.DMF0052_GET_ERP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-05445d8f | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:531 |  | DATA_OP | request.Parameters["p_PROJECT_CODE"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-678392f4 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:532 |  | DATA_OP | request.Parameters["p_ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e3af2dc6 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:533 |  | DATA_OP | request.Parameters["p_FROM_YYYYMMDD"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-97191657 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:534 |  | DATA_OP | request.Parameters["p_TO_YYYYMMDD"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-4de39115 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:535 |  | DATA_OP | request.Parameters["p_GRID_SENDER_CODE"] | sEDISender | 행/컬럼 값 대입 |  |  |  |
| AC-76887b47 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:536 |  | DATA_OP | request.Parameters["p_GRID_PROJECT_CODE"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-3ef7e403 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:538 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d3fd625 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:546 |  | GRID_BIND | siData.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5528a23b | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:547 |  | GRID_LOCK | siData.LockColumn | (0, siData.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d29eab1 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… | DMF0052_EDISummary.cs:554 |  | UI_MISC | siData.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0052_EDISummary.FindData_GSCMData

진입점: this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGSCM)) && siPjt.GetText(e.Row, …) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail)] / this.btnRefresh.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3808c0d0 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:446 |  | UI_MISC | siData.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9bf75ad2 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:460 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0052_GET_DETAIL_DATA") ⇒ DM.DMF0052_GET_DETAIL_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c1e4a751 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:462 |  | DATA_OP | request.Parameters["p_PROJECT_CODE"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-36cfd6a0 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:463 |  | DATA_OP | request.Parameters["p_ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7f0f8937 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:464 |  | DATA_OP | request.Parameters["p_FROM_YYYYMMDD"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-1a23aadc | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:465 |  | DATA_OP | request.Parameters["p_TO_YYYYMMDD"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-16eba089 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:466 |  | DATA_OP | request.Parameters["p_GRID_SENDER_CODE"] | sEDISender | 행/컬럼 값 대입 |  |  |  |
| AC-527cf5b3 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:467 |  | DATA_OP | request.Parameters["p_GRID_PROJECT_CODE"] | sPjtCode | 행/컬럼 값 대입 |  |  |  |
| AC-58089e91 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:469 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6041997 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:478 |  | GRID_BIND | siData.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d4c4b334 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:479 |  | GRID_LOCK | siData.LockColumn | (0, siData.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-20ec1c3b | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:486 |  | UI_MISC | siData.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0dc9161c | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:494 | if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow <= siData.GetMaxRowIndex()) ▸ if (siData.ActiveSheet.GetText(iRow, siDat… | GRID_SET | siData.ActiveSheet.Cells[iRow, siData.GetColumnIndex(DefColumns.CheckSalesSite)].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-97a43fb4 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:495 | if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow <= siData.GetMaxRowIndex()) ▸ if (siData.ActiveSheet.GetText(iRow, siDat… | GRID_SET | siData.ActiveSheet.Cells[iRow, siData.GetColumnIndex(DefColumns.CheckSalesSite)].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Underline, System.Drawing.Graph… | 그리드 속성/값 설정 |  |  |  |
| AC-fd301e77 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:499 | if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow <= siData.GetMaxRowIndex()) ▸ else of (siData.ActiveSheet.GetText(iRow, … | GRID_SET | siData.ActiveSheet.Cells[iRow, siData.GetColumnIndex(DefColumns.CheckSalesYN)].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-e4ff9c1b | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:500 | if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow <= siData.GetMaxRowIndex()) ▸ else of (siData.ActiveSheet.GetText(iRow, … | GRID_SET | siData.ActiveSheet.Cells[iRow, siData.GetColumnIndex(DefColumns.CheckSalesYN)].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Underline, System.Drawing.Graph… | 그리드 속성/값 설정 |  |  |  |
| AC-be1f4899 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:504 | if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow <= siData.GetMaxRowIndex()) ▸ else of (siData.ActiveSheet.GetText(iRow, … | GRID_SET | siData.ActiveSheet.Cells[iRow, siData.GetColumnIndex(DefColumns.CheckSSPM)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-35eb5c9c | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 1 | DMF0052_EDISummary.cs:505 | if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ for (iRow <= siData.GetMaxRowIndex()) ▸ else of (siData.ActiveSheet.GetText(iRow, … | GRID_SET | siData.ActiveSheet.Cells[iRow, siData.GetColumnIndex(DefColumns.CheckSSPM)].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |

## DMF0052_EDISummary.FindData_Main

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" \|\| fps.Name == "spdSummaryPJT" \|\| fps.Name == "spdSummaryStatus")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0098fa5a | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:269 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-767d6054 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:272 |  | GRID_INIT | siData.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a795d06 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:275 |  | GRID_INIT | siData.ChangeSheet | (SpdSheet.shtErp) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-908823e9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:283 | if (sEDISender == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a525e851 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:285 | if (sEDISender == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da0f117e | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:292 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3fc62dad | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:293 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4eac0a5a | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:298 | if (Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd")) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("당일이후의 날짜를 선택하실 수 없습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc1032f2 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:300 | if (Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd")) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-05c23e98 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:302 | if (Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd")) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14b251b4 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:308 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70a288be | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:312 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0052_GET_SUMMARY_DATA") ⇒ DM.DMF0052_GET_SUMMARY_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0ba93a5f | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:313 | lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4d413263 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:314 | lambda | DATA_OP | request.Parameters["p_SENDER_CODE"] | sEDISender | 행/컬럼 값 대입 |  |  |  |
| AC-ab1f133b | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:315 | lambda | DATA_OP | request.Parameters["p_ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-019c9b43 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:316 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-82f9d0e4 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:317 | lambda | DATA_OP | request.Parameters["p_FROM_YYYYMMDD"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-afc54311 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:318 | lambda | DATA_OP | request.Parameters["p_TO_YYYYMMDD"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-84d3af24 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:320 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-744f5809 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:322 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2e7247a7 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:326 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-76601733 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:327 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3bae893 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:329 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f073df27 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:333 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0052_EDISummary.FindData_Pjt

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" \|\| fps.Name == "spdSummaryPJT" \|\| fps.Name == "spdSummaryStatus")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86fc2977 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:340 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-32679053 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:351 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4de0ec20 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:355 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0052_GET_PJT_DATA") ⇒ DM.DMF0052_GET_PJT_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-12192ea9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:356 | lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b3291d9f | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:357 | lambda | DATA_OP | request.Parameters["p_SENDER_CODE"] | sEDISender | 행/컬럼 값 대입 |  |  |  |
| AC-6fd166ff | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:358 | lambda | DATA_OP | request.Parameters["p_ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d5527bb8 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:359 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-cbe4d67f | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:360 | lambda | DATA_OP | request.Parameters["p_FROM_YYYYMMDD"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-54c70683 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:361 | lambda | DATA_OP | request.Parameters["p_TO_YYYYMMDD"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-1e1dd34d | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:363 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e456aa20 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:365 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-250ae1c7 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:369 |  | GRID_BIND | siPjt.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6ecd9181 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:370 |  | GRID_LOCK | siPjt.LockColumn | (0, siPjt.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7698020a | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:372 |  | GRID_INIT | siPjt.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de6bba1b | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:376 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-78ad0f87 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:382 | for (iRow <= siPjt.GetMaxRowIndex()) ▸ if (siPjt.GetText(iRow, siPjt.GetColumnIndex(DefColumns.CheckGSCM)) != "0") | GRID_SET | siPjt.Sheet().Cells[iRow, siPjt.GetColumnIndex(DefColumns.CheckGSCM)].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-06a5b45a | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:383 | for (iRow <= siPjt.GetMaxRowIndex()) ▸ if (siPjt.GetText(iRow, siPjt.GetColumnIndex(DefColumns.CheckGSCM)) != "0") | GRID_SET | siPjt.Sheet().Cells[iRow, siPjt.GetColumnIndex(DefColumns.CheckGSCM)].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Underline, System.Drawing.Graph… | 그리드 속성/값 설정 |  |  |  |
| AC-f98e48b9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:388 | for (iRow <= siPjt.GetMaxRowIndex()) ▸ if (siPjt.GetText(iRow, siPjt.GetColumnIndex(DefColumns.CheckERP)) != "0") | GRID_SET | siPjt.Sheet().Cells[iRow, siPjt.GetColumnIndex(DefColumns.CheckERP)].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-1fc2f7ea | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:389 | for (iRow <= siPjt.GetMaxRowIndex()) ▸ if (siPjt.GetText(iRow, siPjt.GetColumnIndex(DefColumns.CheckERP)) != "0") | GRID_SET | siPjt.Sheet().Cells[iRow, siPjt.GetColumnIndex(DefColumns.CheckERP)].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Underline, System.Drawing.Graph… | 그리드 속성/값 설정 |  |  |  |
| AC-25d052cd | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:394 | for (iRow <= siPjt.GetMaxRowIndex()) ▸ if (siPjt.GetText(iRow, siPjt.GetColumnIndex(DefColumns.PjtCode)) == "Total") | GRID_STYLE | siPjt.SetBGColor | (iRow, siPjt.GetColumnIndex(DefColumns.PjtCode), iRow, siPjt.GetColumnIndex(DefColumns.Che… | 그리드 표시 설정 |  |  |  |

## DMF0052_EDISummary.FindData_Status

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" \|\| fps.Name == "spdSummaryPJT" \|\| fps.Name == "spdSummaryStatus")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9578af38 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:403 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7166eaa7 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:414 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ad0057b4 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:418 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0052_GET_STATUS_DATA") ⇒ DM.DMF0052_GET_STATUS_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c6e2473b | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:419 | lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ee6da2be | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:420 | lambda | DATA_OP | request.Parameters["p_SENDER_CODE"] | sEDISender | 행/컬럼 값 대입 |  |  |  |
| AC-17cb8c22 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:421 | lambda | DATA_OP | request.Parameters["p_ITEM_ID"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d9bce5cf | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:422 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8f37a55e | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:423 | lambda | DATA_OP | request.Parameters["p_FROM_YYYYMMDD"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-772e79fb | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:424 | lambda | DATA_OP | request.Parameters["p_TO_YYYYMMDD"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-f5b72797 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:426 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1aeb03ff | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:428 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c5eaf8d0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:432 |  | GRID_BIND | siStatus.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5165c62e | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:433 |  | GRID_LOCK | siStatus.LockColumn | (0, siStatus.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d0346578 | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:435 |  | GRID_INIT | siStatus.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e244e81f | FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" … | DMF0052_EDISummary.cs:439 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0052_EDISummary.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-858ffafb | this.Load | DMF0052_EDISummary.cs:129 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9cbdfe40 | this.Load | DMF0052_EDISummary.cs:130 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0052_EDISummary.GetEdiSender

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a81ad6e | this.Load | DMF0052_EDISummary.cs:783 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-081bfc09 | this.Load | DMF0052_EDISummary.cs:784 |  | DATA_OP | request.Parameters["CODE"] | "EDI_SENDER_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-15369faa | this.Load | DMF0052_EDISummary.cs:785 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1646e321 | this.Load | DMF0052_EDISummary.cs:786 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03f510a3 | this.Load | DMF0052_EDISummary.cs:787 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ca9fded0 | this.Load | DMF0052_EDISummary.cs:788 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b0a11ec4 | this.Load | DMF0052_EDISummary.cs:789 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ecb848b5 | this.Load | DMF0052_EDISummary.cs:790 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee07b8ac | this.Load | DMF0052_EDISummary.cs:792 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0052_EDISummary.GetSpdTitle

진입점: this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGSCM)) && siPjt.GetText(e.Row, …) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail)] / this.btnRefresh.Click / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" \|\| fps.Name == "spdSummaryPJT" \|\| fps.Name == "spdSummaryStatus")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7476fe1f | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:696 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0052_GET_SPREAD_TITLE") ⇒ DM.DMF0052_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-d726f466 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:697 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d43bfa5d | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:698 |  | DATA_OP | request.Parameters["p_division_id"] | "81" | 행/컬럼 값 대입 |  |  |  |
| AC-a3023aaa | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:699 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-91e0459c | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:701 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f686e508 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:703 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0052_EDISummary.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-024a8043 | this.Load | DMF0052_EDISummary.cs:141 |  | FLAG | dtEdiSender | GetEdiSender() | 화면 필드/플래그 변경 |  |  |  |
| AC-fb560a63 | this.Load | DMF0052_EDISummary.cs:142 |  | LIST_REBIND | clsCtrl.setListBox | (dtEdiSender, clbEDISender, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dd13a060 | this.Load | DMF0052_EDISummary.cs:146 |  | UI_PROP | drpPeriod.Text1 | DateTime.Now.AddDays(-90).ToString("yyyyMMdd") | 속성 Text1 설정 |  |  |  |
| AC-ca6ef1e0 | this.Load | DMF0052_EDISummary.cs:147 |  | UI_PROP | drpPeriod.Text2 | DateTime.Now.ToString("yyyyMMdd") | 속성 Text2 설정 |  |  |  |

## DMF0052_EDISummary.InitSpread

진입점: this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGSCM)) && siPjt.GetText(e.Row, …) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail)] / this.btnRefresh.Click / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" \|\| fps.Name == "spdSummaryPJT" \|\| fps.Name == "spdSummaryStatus")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-311724b3 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:191 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ff82c4e | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:192 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0052_EDISummary.InitSpreadFooterSum

진입점: this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGSCM)) && siPjt.GetText(e.Row, …) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail) ▸ if (spreadInfo.ActiveSheet.SheetName == "Summary Status")] / this.btnRefresh.Click [if (spreadInfo.ActiveSheet.SheetName == "Summary Status")] / this.Load [if (spreadInfo.ActiveSheet.SheetName == "Summary Status")] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSummary" \|\| fps.Name == "spdSummaryPJT" \|\| fps.Name == "spdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2953183c | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:201 |  | GRID_SET | siStatus.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0cc8390b | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:202 |  | GRID_SET | siStatus.ActiveSheet.ColumnFooter.Cells[0, 2].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-1480e689 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:209 | for (iCol <= siStatus.GetMaxColumnIndex()) ▸ if (siStatus.GetColumnTag(iCol) == DefColumns.Qty) | CALL_EXT | siStatus.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a260399b | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:210 | for (iCol <= siStatus.GetMaxColumnIndex()) ▸ if (siStatus.GetColumnTag(iCol) == DefColumns.Qty) | CALL_EXT | siStatus.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1981b73b | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:211 | for (iCol <= siStatus.GetMaxColumnIndex()) ▸ if (siStatus.GetColumnTag(iCol) == DefColumns.Qty) | GRID_SET | siStatus.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-e5c8eea2 | this.spdSummaryPJT.CellDoubleClick [if (siPjt.IsLock(siPjt.S… 외 3 | DMF0052_EDISummary.cs:212 | for (iCol <= siStatus.GetMaxColumnIndex()) ▸ if (siStatus.GetColumnTag(iCol) == DefColumns.Qty) | GRID_SET | siStatus.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0052_EDISummary.spdData_ActiveSheetChanging

진입점: this.spdData.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a51d778b | this.spdData.ActiveSheetChanging | DMF0052_EDISummary.cs:761 | if (siData.ActiveSheetIndex == 0) | STATE | btnRefresh.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e72f638 | this.spdData.ActiveSheetChanging | DMF0052_EDISummary.cs:762 | if (siData.ActiveSheetIndex == 0) | STATE | btnRefresh.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-22ce90bd | this.spdData.ActiveSheetChanging | DMF0052_EDISummary.cs:763 | if (siData.ActiveSheetIndex == 0) | UI_PROP | layoutControlItem2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-90b18c7c | this.spdData.ActiveSheetChanging | DMF0052_EDISummary.cs:767 | else of (siData.ActiveSheetIndex == 0) ▸ if (siData.ActiveSheetIndex == 1) | STATE | btnRefresh.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-89c2b342 | this.spdData.ActiveSheetChanging | DMF0052_EDISummary.cs:768 | else of (siData.ActiveSheetIndex == 0) ▸ if (siData.ActiveSheetIndex == 1) | STATE | btnRefresh.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-5bfcc101 | this.spdData.ActiveSheetChanging | DMF0052_EDISummary.cs:769 | else of (siData.ActiveSheetIndex == 0) ▸ if (siData.ActiveSheetIndex == 1) | UI_PROP | layoutControlItem2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## DMF0052_EDISummary.spdData_CellDoubleClick

진입점: this.spdData.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e9e49ce | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:635 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1bb0564e | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:639 | if (siPjt.IsLock(siPjt.SheetName)) | GRID_INIT | siData.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80f9de82 | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:657 | if (siPjt.IsLock(siPjt.SheetName)) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.GetCo… | POPUP | new DMF0052_GSCMDataPopup | () | 팝업/폼 생성 |  |  |  |
| AC-940f1f9a | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:658 | if (siPjt.IsLock(siPjt.SheetName)) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.GetCo… | POPUP | popup.Form_Load | (_EDISender, _ItemCode, _PjtCode, _fromDate, _toDate, _popupType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f93c61f5 | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:659 | if (siPjt.IsLock(siPjt.SheetName)) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.GetCo… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c6dab3ea | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:660 | if (siPjt.IsLock(siPjt.SheetName)) ▸ if (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.GetCo… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0a827764 | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:666 | if (siPjt.IsLock(siPjt.SheetName)) ▸ else of (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.… | POPUP | new DMF0052_GSCMDataPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c62f2926 | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:667 | if (siPjt.IsLock(siPjt.SheetName)) ▸ else of (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.… | POPUP | popup.Form_Load | (_EDISender, _ItemCode, _PjtCode, _fromDate, _toDate, _popupType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e8a4abc7 | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:668 | if (siPjt.IsLock(siPjt.SheetName)) ▸ else of (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d2451e2c | this.spdData.CellDoubleClick | DMF0052_EDISummary.cs:669 | if (siPjt.IsLock(siPjt.SheetName)) ▸ else of (siData.ActiveSheet.SheetName == SpdSheet.shtDetail && siData.GetColumnTag(e.Column) == siData.… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0052_EDISummary.spdPjt_CellDoubleClick

진입점: this.spdSummaryPJT.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccb7a739 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:573 | if (siPjt.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ede51033 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:580 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | FLAG | sEDISenderPjt | siPjt.GetText(e.Row, siPjt.GetColumnIndex(DefColumns.EDISenderCode)) | 화면 필드/플래그 변경 |  |  |  |
| AC-3df1607d | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:581 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | FLAG | sItemdIdPjt | txtItemId.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-d8ecc92b | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:582 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | FLAG | sProjectPjt | siPjt.GetText(e.Row, siPjt.GetColumnIndex(DefColumns.PjtCode)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8a26ad0 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:588 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | FLAG | _sActiveSheetName | SpdSheet.shtDetail | 화면 필드/플래그 변경 |  |  |  |
| AC-4ff94fc0 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:592 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | FLAG | _sActiveSheetName | SpdSheet.shtErp | 화면 필드/플래그 변경 |  |  |  |
| AC-5461333b | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:596 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | GRID_INIT | siData.ChangeSheet | (SpdSheet.shtDetail) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb52b94d | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:597 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | GRID_INIT | siData.ChangeActiveSheet | (SpdSheet.shtDetail) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cb41fb4b | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:603 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | GRID_INIT | siData.ChangeSheet | (SpdSheet.shtErp) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40fb790f | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:604 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | GRID_INIT | siData.ChangeActiveSheet | (SpdSheet.shtErp) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a5e1cc05 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:611 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | GRID_INIT | siData.ChangeSheet | (_sActiveSheetName) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a435b74 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:612 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | GRID_INIT | siData.ChangeActiveSheet | (_sActiveSheetName) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6d805622 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:616 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | STATE | btnRefresh.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5f2333ee | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:617 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | STATE | btnRefresh.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4dd2ebf4 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:618 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | UI_PROP | siData.ActiveSheetIndex | 0 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-5869a319 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:619 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | UI_PROP | layoutControlItem2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1ab58412 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:623 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | STATE | btnRefresh.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7235419e | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:624 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | STATE | btnRefresh.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-cfabaa8b | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:625 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | UI_PROP | siData.ActiveSheetIndex | 1 | 속성 ActiveSheetIndex 설정 |  |  |  |
| AC-3e6c9e06 | this.spdSummaryPJT.CellDoubleClick | DMF0052_EDISummary.cs:626 | if (siPjt.IsLock(siPjt.SheetName) == true) ▸ if ((siPjt.GetColumnTag(e.Column) == siPjt.GetColumnTag(siPjt.GetColumnIndex(DefColumns.CheckGS… | UI_PROP | layoutControlItem2.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0052_GSCMDataPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea8fab6c | this.btnButtonList.UsrButtonList_Click_Detected | DMF0052_GSCMDataPopup.cs:248 | switch (buttonItem.UserType) case ButtonListType.Excel: | CALL_BASE | ExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0875c47 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0052_GSCMDataPopup.cs:251 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0052_GSCMDataPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95d0bfbc | this.Load | DMF0052_GSCMDataPopup.cs:129 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07a5613c | this.Load | DMF0052_GSCMDataPopup.cs:130 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9248cff | this.Load | DMF0052_GSCMDataPopup.cs:132 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0052_GSCMDataPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ebe9251 | this.Load | DMF0052_GSCMDataPopup.cs:112 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-06e25d34 | this.Load | DMF0052_GSCMDataPopup.cs:115 |  | DATA_OP | list.Add | (ButtonListType.Edit) | 데이터 객체 조작/조회 |  |  |  |
| AC-47b4ad8a | this.Load | DMF0052_GSCMDataPopup.cs:116 |  | DATA_OP | list.Add | (ButtonListType.Insert) | 데이터 객체 조작/조회 |  |  |  |
| AC-275798c2 | this.Load | DMF0052_GSCMDataPopup.cs:117 |  | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-56196009 | this.Load | DMF0052_GSCMDataPopup.cs:118 |  | DATA_OP | list.Add | (ButtonListType.Find) | 데이터 객체 조작/조회 |  |  |  |
| AC-67d9ae40 | this.Load | DMF0052_GSCMDataPopup.cs:119 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-23568a97 | this.Load | DMF0052_GSCMDataPopup.cs:122 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0052_GSCMDataPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b111a79b | Dispose | DMF0052_GSCMDataPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0052_GSCMDataPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-432b4e3d | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:202 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5c6c09a7 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:205 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-216db501 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:207 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da52ac25 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:211 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0052_GET_SITE_POPUP") ⇒ DM.DMF0052_GET_SITE_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-8816fbc2 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:213 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-66dab4a8 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:215 | lambda | DATA_OP | request.Parameters["p_SENDER_CODE"] | EDISender | 행/컬럼 값 대입 |  |  |  |
| AC-ff63dcf1 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:216 | lambda | DATA_OP | request.Parameters["p_ITEM_ID"] | ItemCode | 행/컬럼 값 대입 |  |  |  |
| AC-9367809b | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:217 | lambda | DATA_OP | request.Parameters["p_PROJECT_CODE"] | PjtCode | 행/컬럼 값 대입 |  |  |  |
| AC-b273be9a | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:218 | lambda | DATA_OP | request.Parameters["p_FROM_YYYYMMDD"] | FromDate | 행/컬럼 값 대입 |  |  |  |
| AC-85e8cde6 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:219 | lambda | DATA_OP | request.Parameters["p_TO_YYYYMMDD"] | ToDate | 행/컬럼 값 대입 |  |  |  |
| AC-b74c72bb | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:220 | lambda | DATA_OP | request.Parameters["p_POPUP_TYPE"] | PopupType | 행/컬럼 값 대입 |  |  |  |
| AC-4b6db8d9 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:221 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-395d1c99 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:223 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9c990db4 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:227 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-77216332 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:228 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f91184c4 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:230 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31a7c1c6 | this.Load 외 1 | DMF0052_GSCMDataPopup.cs:234 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0052_GSCMDataPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9efbee6 | this.Load | DMF0052_GSCMDataPopup.cs:81 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-64345355 | this.Load | DMF0052_GSCMDataPopup.cs:83 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-19c186be | this.Load | DMF0052_GSCMDataPopup.cs:93 |  | FLAG | EDISender | _EDISender | 화면 필드/플래그 변경 |  |  |  |
| AC-88c25ca0 | this.Load | DMF0052_GSCMDataPopup.cs:94 |  | FLAG | ItemCode | _ItemCode | 화면 필드/플래그 변경 |  |  |  |
| AC-bfcd14c8 | this.Load | DMF0052_GSCMDataPopup.cs:95 |  | FLAG | PjtCode | _ProjectCode | 화면 필드/플래그 변경 |  |  |  |
| AC-b1355337 | this.Load | DMF0052_GSCMDataPopup.cs:96 |  | FLAG | FromDate | _FromDate | 화면 필드/플래그 변경 |  |  |  |
| AC-2e58c729 | this.Load | DMF0052_GSCMDataPopup.cs:97 |  | FLAG | ToDate | _ToDate | 화면 필드/플래그 변경 |  |  |  |
| AC-53775a26 | this.Load | DMF0052_GSCMDataPopup.cs:98 |  | FLAG | PopupType | _PopupType | 화면 필드/플래그 변경 |  |  |  |

## DMF0052_GSCMDataPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42990a99 | this.Load | DMF0052_GSCMDataPopup.cs:140 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d6383dd5 | this.Load | DMF0052_GSCMDataPopup.cs:142 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-902d6f99 | this.Load | DMF0052_GSCMDataPopup.cs:144 |  | GRID_INIT | siMain.AddTextColumn | ("(ERP) EDI Sender", DefColumns.EDISender, FPMerge.Restricted, 100, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-efd1fe42 | this.Load | DMF0052_GSCMDataPopup.cs:145 |  | GRID_INIT | siMain.AddTextColumn | ("(ERP) Company", DefColumns.Company, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8348bd7e | this.Load | DMF0052_GSCMDataPopup.cs:146 |  | GRID_INIT | siMain.AddTextColumn | ("(ERP) Sold to", DefColumns.SoldTo, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f0cfc70 | this.Load | DMF0052_GSCMDataPopup.cs:147 |  | GRID_INIT | siMain.AddTextColumn | ("(ERP) Ship to", DefColumns.ShipTo, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-548275e3 | this.Load | DMF0052_GSCMDataPopup.cs:150 | if (PopupType != "CHECK_SALES_SITE") | GRID_INIT | siMain.AddTextColumn | ("(GSCM) Sales Site", DefColumns.SalesSite, FPMerge.Restricted, 100, true, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d80dc0d3 | this.Load | DMF0052_GSCMDataPopup.cs:151 | if (PopupType != "CHECK_SALES_SITE") | GRID_INIT | siMain.AddTextColumn | ("Active", DefColumns.Active, FPMerge.Restricted, 50, true, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c056d581 | this.Load | DMF0052_GSCMDataPopup.cs:152 | if (PopupType != "CHECK_SALES_SITE") | GRID_INIT | siMain.AddTextColumn | ("(GSCM) Sold to / Ship to", DefColumns.GscmCode, FPMerge.Restricted, 150, true, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a11fd2a6 | this.Load | DMF0052_GSCMDataPopup.cs:153 | if (PopupType != "CHECK_SALES_SITE") | GRID_INIT | siMain.AddTextColumn | ("Active", DefColumns.CodeActive, FPMerge.Restricted, 50, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ac81425 | this.Load | DMF0052_GSCMDataPopup.cs:155 |  | GRID_INIT | siMain.AddTextColumn | ("Message", DefColumns.Message, FPMerge.Restricted, 350, true, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e079ffb | this.Load | DMF0052_GSCMDataPopup.cs:157 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0052_GSCMDataPopup.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-082e137d | this.spdMain.TopChange | DMF0052_GSCMDataPopup.cs:260 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

