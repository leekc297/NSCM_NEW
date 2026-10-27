# AS-IS 액션 대조표 — DMF0069

> 원천: `Doc/asisfacts/screens/DMF0069/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 211행 · 메서드 18 · 종류 DATA_OP 39 · GRID_SET 35 · FLAG 33 · GRID_INIT 32 · UI_PROP 19 · ENDPOINT 17 · UI_MISC 6 · POPUP 6 · GRID_BIND 5 · GRID_LOCK 5 · RETURN 4 · CALL_EXT 3 · GRID_STYLE 3 · MESSAGE 2 · THROW 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 3


## DMF0069_HistoryDataManagingBoard.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0435b52a | this.Load | DMF0069_HistoryDataManagingBoard.cs:231 |  | GRID_INIT | this.AddSheet | (spd1, SpdSheet.sht1, SpdSheet.sht1, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2435111c | this.Load | DMF0069_HistoryDataManagingBoard.cs:232 |  | FLAG | si1 | GetSheetInfo(spd1.Name, spd1.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-26634547 | this.Load | DMF0069_HistoryDataManagingBoard.cs:233 |  | GRID_INIT | si1.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2af2a735 | this.Load | DMF0069_HistoryDataManagingBoard.cs:235 |  | GRID_INIT | this.AddSheet | (spd3, SpdSheet.sht3, SpdSheet.sht3, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6eb5851f | this.Load | DMF0069_HistoryDataManagingBoard.cs:236 |  | FLAG | si3 | GetSheetInfo(spd3.Name, spd3.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-faeae5e1 | this.Load | DMF0069_HistoryDataManagingBoard.cs:237 |  | GRID_INIT | si3.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7756fafa | this.Load | DMF0069_HistoryDataManagingBoard.cs:240 |  | GRID_INIT | this.AddSheet | (spd2, SpdSheet.sht2, SpdSheet.sht2, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9c4b1e66 | this.Load | DMF0069_HistoryDataManagingBoard.cs:241 |  | FLAG | si2 | GetSheetInfo(spd2.Name, spd2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-aaba61d4 | this.Load | DMF0069_HistoryDataManagingBoard.cs:242 |  | GRID_INIT | si2.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0069_HistoryDataManagingBoard.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e3ec099 | this.Load | DMF0069_HistoryDataManagingBoard.cs:221 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c818c50f | this.Load | DMF0069_HistoryDataManagingBoard.cs:222 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(si1.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-4c146eeb | this.Load | DMF0069_HistoryDataManagingBoard.cs:223 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-8ec2a271 | this.Load | DMF0069_HistoryDataManagingBoard.cs:224 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0069_HistoryDataManagingBoard.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a88c9310 | Dispose | DMF0069_HistoryDataManagingBoard.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0069_HistoryDataManagingBoard.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46d8ef41 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:534 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-498f6214 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:535 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-d5125857 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:536 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-317a3c53 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:537 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-d5232332 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:538 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-2bac9835 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:539 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-ce9b2f1e | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:541 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-0427dd99 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:542 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-43a8b804 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:544 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-4979a367 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:548 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f1f0630 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:552 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ace52f55 | ExcelButton | DMF0069_HistoryDataManagingBoard.cs:556 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0069_HistoryDataManagingBoard.FindData

진입점: this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e44af217 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:569 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-06c3e1cc | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:579 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8f29a1f | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:580 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8ac022d | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:584 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-18d2edc9 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:593 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0cdb4848 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:595 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f634584d | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:599 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0069_GET_DM_ANL_MKT_STATUSBOARD") ⇒ DM.DMF0069_GET_DM_ANL_MKT_STATUSBOARD | 엔드포인트 요청 생성 |  |  |  |
| AC-79dbd1ea | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:601 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-60c88d47 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:603 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-78b205fe | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:604 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-94581348 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:606 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1a5f269c | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:608 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2ff3cdee | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:616 | try | UI_MISC | si1.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ac6d1f80 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:620 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | si1.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-63a932c6 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:622 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | si1.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5484b81d | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:624 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | si1.LockColumn | (0, 4, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-105c5959 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:637 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76b5fcb4 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:641 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d35ea95b | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:643 | finally | UI_MISC | si1.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5d845f38 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:647 |  | GRID_STYLE | spd1.SetViewportTopRow | (0, si1.GetMaxRowIndex()) | 그리드 표시 설정 |  |  |  |
| AC-48bcdb3d | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:651 | for (i <= si1.GetMaxRowIndex()) | GRID_SET | si1.ActiveSheet.Cells[i, si1.GetColumnIndex(DefColumns.Completed_Cnt)].BackColor | Color.Azure | 그리드 속성/값 설정 |  |  |  |
| AC-2a093e58 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:652 | for (i <= si1.GetMaxRowIndex()) | GRID_SET | si1.ActiveSheet.Cells[i, si1.GetColumnIndex(DefColumns.Check_Cnt)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-6baa4a44 | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:653 | for (i <= si1.GetMaxRowIndex()) | GRID_SET | si1.ActiveSheet.Cells[i, si1.GetColumnIndex(DefColumns.Completed_Cnt)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-5b1a655a | this.btnFind.Click 외 1 | DMF0069_HistoryDataManagingBoard.cs:654 | for (i <= si1.GetMaxRowIndex()) | GRID_SET | si1.ActiveSheet.Cells[i, si1.GetColumnIndex(DefColumns.Check_Cnt)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## DMF0069_HistoryDataManagingBoard.FirstWeeked

진입점: this.spd2.CellDoubleClick [else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex())] / this.spd3.CellClick [if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29f44692 | this.spd2.CellDoubleClick [else of (e.ColumnHeader) ▸ for (i… 외 1 | DMF0069_HistoryDataManagingBoard.cs:1108 |  | RETURN | return (startofFirstWeek.Day >= today.Day) && (today.Day <= endofFirstWeek.Day); |  | 처리 중단/반환 |  |  |  |

## DMF0069_HistoryDataManagingBoard.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-027186b3 | this.Load | DMF0069_HistoryDataManagingBoard.cs:184 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-986cd563 | this.Load | DMF0069_HistoryDataManagingBoard.cs:185 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0069_HistoryDataManagingBoard.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f00f5f34 | (진입점 미연결) | DMF0069_HistoryDataManagingBoard.cs:1228 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-071989a0 | (진입점 미연결) | DMF0069_HistoryDataManagingBoard.cs:1229 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1e497035 | (진입점 미연결) | DMF0069_HistoryDataManagingBoard.cs:1230 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-967e6cb2 | (진입점 미연결) | DMF0069_HistoryDataManagingBoard.cs:1232 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77499c9d | (진입점 미연결) | DMF0069_HistoryDataManagingBoard.cs:1235 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0069_HistoryDataManagingBoard.GetSpdTitle

진입점: this.btnFind.Click [try] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cad6c0eb | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1190 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0069_GET_SPREAD_TITLE") ⇒ DM.DMF0069_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-37d93133 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1192 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-9c53d0be | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1193 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-f219f657 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1194 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a141f4e0 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1195 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-790e9283 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1196 |  | DATA_OP | request.Parameters["p_program_id"] | sProgram_Id | 행/컬럼 값 대입 |  |  |  |
| AC-8c5b29ee | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1197 |  | DATA_OP | request.Parameters["p_sheet_name"] | sSheet_Name | 행/컬럼 값 대입 |  |  |  |
| AC-ee634b85 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1199 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-e7483621 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1199 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0069_HistoryDataManagingBoard.GetSpdTitle_PSI

진입점: this.btnFind.Click [try] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-538ba044 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1210 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_SPREAD_TITLE_PSI") ⇒ DM.DMF0003_GET_SPREAD_TITLE_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-8d01779d | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1212 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-312b52fa | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1213 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-9a4c779a | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1214 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3e312fc2 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1215 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-935228ea | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1217 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-f2db05a3 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:1217 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0069_HistoryDataManagingBoard.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-073b8aa8 | this.Load | DMF0069_HistoryDataManagingBoard.cs:212 |  | UI_PROP | drpPeriod.MonthText1 | DateTime.Now.AddMonths(-3).ToString("yyyy-MM") | 속성 MonthText1 설정 |  |  |  |
| AC-02f8a9a5 | this.Load | DMF0069_HistoryDataManagingBoard.cs:213 |  | UI_PROP | drpPeriod.MonthText2 | DateTime.Now.ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-5336c798 | this.Load | DMF0069_HistoryDataManagingBoard.cs:216 |  | UI_PROP | splitContainer2.SplitterDistance | (int)(splitContainer2.ClientSize.Height * 0.42) | 속성 SplitterDistance 설정 |  |  |  |

## DMF0069_HistoryDataManagingBoard.InitSpread

진입점: this.btnFind.Click [try] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83ec0058 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:249 |  | FLAG | sProgram_Id | "DMF0069" | 화면 필드/플래그 변경 |  |  |  |
| AC-1157df8b | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:250 |  | FLAG | sSheet_Name | "Status Board" | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf6913c | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:251 |  | FLAG | sDivision_ID | "81" | 화면 필드/플래그 변경 |  |  |  |
| AC-a7313585 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:254 |  | GRID_INIT | si1.CreateSheetHeaderColumn | (si1, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-6891ef51 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:260 | if (dtTitle != null && dtTitle.Rows.Count > 0) | FLAG | dtTitle | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9b53a83f | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:264 |  | FLAG | sProgram_Id | "DMF0069" | 화면 필드/플래그 변경 |  |  |  |
| AC-767d0d70 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:265 |  | FLAG | sSheet_Name | "Status List" | 화면 필드/플래그 변경 |  |  |  |
| AC-b98585bd | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:266 |  | FLAG | sDivision_ID | "81" | 화면 필드/플래그 변경 |  |  |  |
| AC-df1b11c6 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:268 |  | GRID_INIT | si2.CreateSheetHeaderColumn | (si2, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-42e391ac | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:274 | if (dtTitle != null && dtTitle.Rows.Count > 0) | FLAG | dtTitle | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c90854de | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:280 |  | GRID_INIT | si3.CreateSheetHeaderColumn | (si3, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-c6d54eb6 | this.btnFind.Click [try] 외 2 | DMF0069_HistoryDataManagingBoard.cs:285 | if (dtTitle != null && dtTitle.Rows.Count > 0) | FLAG | dtTitle | null | 화면 필드/플래그 변경 |  |  |  |

## DMF0069_HistoryDataManagingBoard.SetSpreadHeaderSpan_SP1

진입점: this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c001db1 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:316 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | si1.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2824d4ab | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:324 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | si1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e604247 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:391 |  | GRID_INIT | si1.Freeze | (0, si1.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f640d687 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:393 |  | GRID_INIT | si1.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0069_HistoryDataManagingBoard.SetSpreadHeaderSpan_SP3

진입점: this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-269dbabb | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:432 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 8) | GRID_INIT | si3.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e43dac7f | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:440 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 8) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | si3.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-17a56f0a | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:459 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 8) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | si3.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de16e5ed | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:464 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 8) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | si3.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b1f08d9 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:471 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 8) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelN… | GRID_INIT | si3.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f68fc7b | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:483 |  | GRID_INIT | si3.ColumnHeaderSpan | (1, 8, 2, 1, 20, "ⓑ(SUM)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1492a545 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:484 |  | GRID_INIT | si3.ColumnHeaderSpan | (1, 9, 1, 3, 20, "Customer", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72b2a0a4 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:485 |  | GRID_INIT | si3.ColumnHeaderSpan | (1, 12, 1, 3, 20, "LGES", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4422f00 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:486 |  | GRID_INIT | si3.ColumnHeaderSpan | (0, 8, 1, 7, 20, "Analysis of demand changes by factors", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b10dd714 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:487 |  | GRID_INIT | si3.ColumnHeaderSpan | (0, 15, 3, 1, 20, "ⓒResult (ⓐ+ⓑ)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4b2f2f3 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:488 |  | GRID_INIT | si3.ColumnHeaderSpan | (0, 16, 3, 1, 20, "ⓓMKT.FCST (DP)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dde43048 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:489 |  | GRID_INIT | si3.ColumnHeaderSpan | (0, 17, 3, 1, 20, "GAP (ⓒ-ⓓ)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb6a2652 | this.btnFind.Click [try ▸ if (dtTitle != null && dtTitle.Row… 외 2 | DMF0069_HistoryDataManagingBoard.cs:492 |  | GRID_INIT | si3.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0069_HistoryDataManagingBoard.spd1_CellClick

진입점: this.spd1.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00de24df | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:666 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | FLAG | cDivision_ID | si1.GetValue(e.Row, si1.GetColumnIndex(DefColumns.Division)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2de2ea67 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:670 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) ▸ if (e.Column == si… | FLAG | cCompleted_Yn | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-28f6afaa | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:674 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) ▸ if (e.Column == si… | FLAG | cCompleted_Yn | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-2ae236d1 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:678 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | GRID_CLEAR | si3.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-939dc8e5 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:684 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | ENDPOINT | new FoxDataRequest | ("DM.DMF0069_GET_DM_ANL_MKT_STATUSLIST") ⇒ DM.DMF0069_GET_DM_ANL_MKT_STATUSLIST | 엔드포인트 요청 생성 |  |  |  |
| AC-2f50bc13 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:686 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | DATA_OP | request.Parameters["p_division_id"] | cDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f5de3591 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:687 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | DATA_OP | request.Parameters["p_completed_yn"] | cCompleted_Yn | 행/컬럼 값 대입 |  |  |  |
| AC-bcbfbb92 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:688 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-a4585eb9 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:689 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-15b96620 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:691 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-939a93f3 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:693 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | FLAG | dtList | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2c62e600 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:694 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | GRID_BIND | si2.Query | (dtList) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ab932b56 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:695 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | GRID_LOCK | si2.LockColumn | (0, 6, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0e767b9e | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:696 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | GRID_INIT | si2.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0308512c | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:703 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) | GRID_STYLE | spd2.SetViewportTopRow | (0, si2.GetMaxRowIndex()) | 그리드 표시 설정 |  |  |  |
| AC-f18878d8 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:707 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) ▸ for (i <= si2.GetM… | GRID_SET | si2.ActiveSheet.Cells[i, si2.GetColumnIndex(DefColumns.Check_Cnt)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-a0f02974 | this.spd1.CellClick | DMF0069_HistoryDataManagingBoard.cs:708 | if (e.Column == si1.GetColumnIndex(DefColumns.Completed_Cnt) \|\| e.Column == si1.GetColumnIndex(DefColumns.Check_Cnt)) ▸ for (i <= si2.GetM… | GRID_SET | si2.ActiveSheet.Cells[i, si2.GetColumnIndex(DefColumns.Check_Cnt)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## DMF0069_HistoryDataManagingBoard.spd2_CellDoubleClick

진입점: this.spd2.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f3a4ad4 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:730 | else of (e.ColumnHeader) | FLAG | cDivision_ID | si2.GetValue(e.Row, si2.GetColumnIndex(DefColumns.Division)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5cc9ebb1 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:731 | else of (e.ColumnHeader) | FLAG | cProject_Code | si2.GetValue(e.Row, si2.GetColumnIndex(DefColumns.Project)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b1e52f25 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:732 | else of (e.ColumnHeader) | FLAG | cProject_Name | si2.GetValue(e.Row, si2.GetColumnIndex(DefColumns.Project_Name)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-44d1bff2 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:733 | else of (e.ColumnHeader) | FLAG | cEnd_Customer | si2.GetValue(e.Row, si2.GetColumnIndex(DefColumns.Customer)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ed79c97e | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:737 | else of (e.ColumnHeader) | FLAG | cYYYYMM | DateTime.Now.ToString("yyyyMM") | 화면 필드/플래그 변경 |  |  |  |
| AC-06f8b8ab | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:738 | else of (e.ColumnHeader) | FLAG | cPJT_CD | cProject_Code | 화면 필드/플래그 변경 |  |  |  |
| AC-831f22a4 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:739 | else of (e.ColumnHeader) | FLAG | cPJT_NM | cProject_Name | 화면 필드/플래그 변경 |  |  |  |
| AC-662d6d5f | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:740 | else of (e.ColumnHeader) | FLAG | cEnd_Customer1 | cEnd_Customer | 화면 필드/플래그 변경 |  |  |  |
| AC-6ab2af8e | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:744 | else of (e.ColumnHeader) | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA") ⇒ DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-5c9ef340 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:751 | else of (e.ColumnHeader) | DATA_OP | request.Parameters["p_division_id"] | cDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-de075d6a | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:752 | else of (e.ColumnHeader) | DATA_OP | request.Parameters["p_end_customer"] | cEnd_Customer | 행/컬럼 값 대입 |  |  |  |
| AC-0724a021 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:753 | else of (e.ColumnHeader) | DATA_OP | request.Parameters["p_project_code"] | cProject_Code | 행/컬럼 값 대입 |  |  |  |
| AC-d264ebcf | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:754 | else of (e.ColumnHeader) | DATA_OP | request.Parameters["p_project_name"] | cProject_Name | 행/컬럼 값 대입 |  |  |  |
| AC-dc05be00 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:755 | else of (e.ColumnHeader) | DATA_OP | request.Parameters["p_yyyymm"] | cYYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-e9854eba | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:756 | else of (e.ColumnHeader) | DATA_OP | request.Parameters["p_created_by"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a6172d98 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:757 | else of (e.ColumnHeader) | DATA_OP | request.Parameters["p_scm_site_id"] | cScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-21e180e5 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:759 | else of (e.ColumnHeader) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6789e177 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:761 | else of (e.ColumnHeader) | FLAG | dtPSI | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-aa8c580b | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:762 | else of (e.ColumnHeader) | GRID_BIND | si3.Query | (dtPSI) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f386bfba | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:763 | else of (e.ColumnHeader) | GRID_LOCK | si3.LockColumn | (0, 12, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-01a027bd | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:764 | else of (e.ColumnHeader) | GRID_INIT | si3.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf37824f | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:770 | else of (e.ColumnHeader) | GRID_STYLE | spd3.SetViewportTopRow | (0, si3.GetMaxRowIndex()) | 그리드 표시 설정 |  |  |  |
| AC-5a12de86 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:782 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (i != si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColum… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.Measure) + 1].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-8c1fce6e | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:786 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (i != si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColum… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.Measure) + 1].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-486bd760 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:796 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) == "Demand Plan (1st… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.Measure) + 1].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-6ed61f20 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:800 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) == "Demand Plan (1st… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.Measure) + 1].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-5ebf6f65 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:808 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) == "Average impact(%… | GRID_SET | si3.ActiveSheet.Cells[i, j].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-9d6f8cfe | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:815 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) == "Simulation (Impa… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.MKT_DP), "" + (int.Parse(si3.GetText(i, si3.GetColumnInd… | 그리드 값 설정 |  |  |  |
| AC-59109796 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:816 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) == "Simulation (Impa… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.MKT_DP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-eb82e1e2 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:825 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) != "Average impact(%… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.RESULT), "" + (int.Parse(si3.GetText(i, si3.GetColumnInd… | 그리드 값 설정 |  |  |  |
| AC-785ecfa9 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:841 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) != "Average impact(%… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-3b9addfe | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:842 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) != "Average impact(%… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-854fb672 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:846 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) != "Average impact(%… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-830168ad | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:847 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) != "Average impact(%… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-3ade99a4 | this.spd2.CellDoubleClick | DMF0069_HistoryDataManagingBoard.cs:853 | else of (e.ColumnHeader) ▸ for (i <= si3.GetMaxRowIndex()) ▸ if (si3.GetText(i, si3.GetColumnIndex(DefColumns.Measure)) != "Average impact(%… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.RESULT)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |

## DMF0069_HistoryDataManagingBoard.spd3_CellClick_1

진입점: this.spd3.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc225654 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:869 |  | CALL_EXT | si3.GetBGColor | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-872e5e31 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:890 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) | POPUP | popup.Form_Load | (pDivision, pEndCustomer, pProjectCode, pYYYYMM, pEdiQty, pMeasure, pMktFcst, FirstWeeked(… | 팝업 초기화(인자 전달) |  |  |  |
| AC-9e5edf0c | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:891 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-69036c99 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:892 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8661efe9 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:903 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | FLAG | cYYYYMM | DateTime.Now.ToString("yyyyMM") | 화면 필드/플래그 변경 |  |  |  |
| AC-4b9b0999 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:907 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA") ⇒ DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-a5db8af8 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:914 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | DATA_OP | request.Parameters["p_division_id"] | cDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1897992f | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:915 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | DATA_OP | request.Parameters["p_end_customer"] | cEnd_Customer1 | 행/컬럼 값 대입 |  |  |  |
| AC-62cacef9 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:916 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | DATA_OP | request.Parameters["p_project_code"] | cPJT_CD | 행/컬럼 값 대입 |  |  |  |
| AC-4c6ebeb9 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:917 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | DATA_OP | request.Parameters["p_project_name"] | cPJT_NM | 행/컬럼 값 대입 |  |  |  |
| AC-bc63d8e9 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:918 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | DATA_OP | request.Parameters["p_yyyymm"] | cYYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-9c09a6ea | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:919 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | DATA_OP | request.Parameters["p_scm_site_id"] | cScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-67f47334 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:920 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | DATA_OP | request.Parameters["p_created_by"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-73d1ec4e | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:923 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5cfe6c25 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:927 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | FLAG | dtPSI | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-7b7c9449 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:928 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | GRID_BIND | si3.Query | (dtPSI) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e8652dd3 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:929 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | GRID_LOCK | si3.LockColumn | (0, 11, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-860d9414 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:930 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) | GRID_INIT | si3.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e103694 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:940 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.MKT_DP), "" + (int.Parse(si3.GetText(i, si3.GetColumnInd… | 그리드 값 설정 |  |  |  |
| AC-79f34c09 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:941 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.MKT_DP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-a5db8d1e | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:945 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.RESULT), "" + (int.Parse(si3.GetText(i, si3.GetColumnInd… | 그리드 값 설정 |  |  |  |
| AC-2ab1e324 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:961 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-8ac48479 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:962 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-76aa65b4 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:966 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-4f7778da | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:967 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-8438a3b1 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:973 | if (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popup.DialogResult == DialogResult.Cancel) ▸ for… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.RESULT)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-1618ab27 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:981 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) | CALL_EXT | si3.GetBGColor | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1737297 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:993 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | POPUP | popup.Form_Load | (pDivision, pEndCustomer, pProjectCode, pYYYYMM, pEdiQty, pMeasure, pMktFcst) | 팝업 초기화(인자 전달) |  |  |  |
| AC-193671ac | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:995 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a9ac1fb4 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:996 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-184e50ee | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1007 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | FLAG | cYYYYMM | DateTime.Now.ToString("yyyyMM") | 화면 필드/플래그 변경 |  |  |  |
| AC-2d69a7ba | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1011 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA") ⇒ DM.DMF0003_GET_DM_ANL_MKT_PSI_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-d0940b7d | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1018 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | DATA_OP | request.Parameters["p_division_id"] | cDivision_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e7d110cb | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1019 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | DATA_OP | request.Parameters["p_end_customer"] | cEnd_Customer1 | 행/컬럼 값 대입 |  |  |  |
| AC-7eba028e | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1020 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | DATA_OP | request.Parameters["p_project_code"] | cPJT_CD | 행/컬럼 값 대입 |  |  |  |
| AC-3e21efd0 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1021 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | DATA_OP | request.Parameters["p_project_name"] | cPJT_NM | 행/컬럼 값 대입 |  |  |  |
| AC-e2a9bcd0 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1022 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | DATA_OP | request.Parameters["p_yyyymm"] | cYYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-7a8fe872 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1023 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | DATA_OP | request.Parameters["p_scm_site_id"] | cScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-adf7a95c | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1024 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | DATA_OP | request.Parameters["p_created_by"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-499a9bf1 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1026 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-487df41a | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1028 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | FLAG | dtPSI | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-abb68a07 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1029 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_BIND | si3.Query | (dtPSI) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-912d32be | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1030 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_LOCK | si3.LockColumn | (0, 11, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4fcb6c05 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1031 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_INIT | si3.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ccc9527b | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1039 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.MKT_DP), "" + (int.Parse(si3.GetText(i, si3.GetColumnInd… | 그리드 값 설정 |  |  |  |
| AC-5e4dee5f | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1040 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.MKT_DP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-a79d3e41 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1044 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.RESULT), "" + (int.Parse(si3.GetText(i, si3.GetColumnInd… | 그리드 값 설정 |  |  |  |
| AC-b4ebbfa1 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1060 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-0d03d678 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1061 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-f24d2271 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1065 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.SetText | (i, si3.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-24cb1cf6 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1066 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-cd231ea9 | this.spd3.CellClick | DMF0069_HistoryDataManagingBoard.cs:1072 | else of (popText == "Demand Plan (1st)" && si3.GetBGColor(e.Row, e.Column) != Color.Empty) ▸ if (popText == "Demand Plan (final)" && si3.Get… | GRID_SET | si3.ActiveSheet.Cells[i, si3.GetColumnIndex(DefColumns.RESULT)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |

## DMF0069_HistoryDataManagingBoard.spd3_TopChange

진입점: this.spd3.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97cc3426 | this.spd3.TopChange | DMF0069_HistoryDataManagingBoard.cs:1088 |  | GRID_INIT | si3.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

