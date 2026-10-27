# AS-IS 액션 대조표 — SCP0024

> 원천: `Doc/asisfacts/screens/SCP0024/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 280행 · 메서드 43 · 종류 DATA_OP 110 · RETURN 26 · GRID_INIT 21 · ENDPOINT 19 · MESSAGE 16 · GRID_SET 15 · UI_PROP 14 · FLAG 12 · VALUE_SET 9 · UI_MISC 8 · POPUP 6 · CALL_EXT 6 · LIST_REBIND 6 · VALIDATE 4 · COMBO_DATA 2 · STATE 2 · THROW 1 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 6


## SCP0024_ProductionPlanFix.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d431084 | this.btnItemId.Click | SCP0024_ProductionPlanFix.cs:650 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1e0980e9 | this.btnItemId.Click | SCP0024_ProductionPlanFix.cs:652 |  | POPUP | pop.Form_Load | (true, _division, _operation_group, _item_id, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-45dfee50 | this.btnItemId.Click | SCP0024_ProductionPlanFix.cs:653 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25dadfd9 | this.btnItemId.Click | SCP0024_ProductionPlanFix.cs:654 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ef3e8d1d | this.btnItemId.Click | SCP0024_ProductionPlanFix.cs:660 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.BtnUnfix_Click

진입점: btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-785ccb44 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1207 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0180f47 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1208 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c72b0f5e | this.btnW26.Click | SCP0024_ProductionPlanFix.cs:1218 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-624c5c64 | this.btnW52.Click | SCP0024_ProductionPlanFix.cs:1223 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95264df2 | this.btnWLast.Click | SCP0024_ProductionPlanFix.cs:1235 | if (success) | VALUE_SET | dCalendar.InitValue | GetDayRange(WkNum.ToString()) | 컨트롤 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce8081d1 | cboDivision.SelectedIndexChanged | SCP0024_ProductionPlanFix.cs:1116 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e818eeb9 | this.Load | SCP0024_ProductionPlanFix.cs:449 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3b3b7f7f | this.Load | SCP0024_ProductionPlanFix.cs:450 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7c9775e | this.Load | SCP0024_ProductionPlanFix.cs:452 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0024_ProductionPlanFix.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78f438f4 | this.Load | SCP0024_ProductionPlanFix.cs:408 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-94ab6ab0 | this.Load | SCP0024_ProductionPlanFix.cs:409 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-640d07d0 | Dispose | SCP0024_ProductionPlanFix.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0024_ProductionPlanFix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de4e89c0 | EditButton | SCP0024_ProductionPlanFix.cs:623 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03f28e8b | EditButton | SCP0024_ProductionPlanFix.cs:624 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7b5b465 | ExcelButton | SCP0024_ProductionPlanFix.cs:671 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-cedbbd57 | ExcelButton | SCP0024_ProductionPlanFix.cs:672 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-4781d625 | ExcelButton | SCP0024_ProductionPlanFix.cs:673 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-48c84c00 | ExcelButton | SCP0024_ProductionPlanFix.cs:674 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-ad755578 | ExcelButton | SCP0024_ProductionPlanFix.cs:675 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-a43b9e9d | ExcelButton | SCP0024_ProductionPlanFix.cs:676 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-c5a91070 | ExcelButton | SCP0024_ProductionPlanFix.cs:678 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-11ac05b7 | ExcelButton | SCP0024_ProductionPlanFix.cs:679 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-52152df4 | ExcelButton | SCP0024_ProductionPlanFix.cs:681 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-2df7a0ce | ExcelButton | SCP0024_ProductionPlanFix.cs:686 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e650533 | ExcelButton | SCP0024_ProductionPlanFix.cs:691 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4946cb88 | ExcelButton | SCP0024_ProductionPlanFix.cs:695 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0024_ProductionPlanFix.FindData_Main

진입점: btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4021a883 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:846 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cb3f9885 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:850 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0eab63b9 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:851 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99f91a9f | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:855 | try | VALIDATE | DateUtil.Check_PeriodDate_New | (dCalendar, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-a59bcbcd | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:856 | try ▸ if (!DateUtil.Check_PeriodDate_New(dCalendar, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66eaeffb | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:860 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f50c8bb1 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:871 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-aa85ddfc | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:872 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SCP.Analy… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-723a3b27 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:876 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_GET_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_GET_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-4dccd855 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:877 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5f33d93d | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:878 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | _division | 행/컬럼 값 대입 |  |  |  |
| AC-ed4a4782 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:879 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | _operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-22be6cb6 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:880 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | _plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-82c51bc1 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:881 | try ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | _line | 행/컬럼 값 대입 |  |  |  |
| AC-34fba10b | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:882 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | _item_id | 행/컬럼 값 대입 |  |  |  |
| AC-34d2ad1b | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:883 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | _from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-332286c5 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:884 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | _to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-aecd1d01 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:885 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | _electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-f047c857 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:886 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-415353db | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:887 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8577e097 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:888 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-472941f8 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:895 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e39b13c3 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:897 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-de227d06 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:898 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6c298b9e | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:910 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].HorizontalAlignment | CellHorizontalAlignment.Right | 그리드 속성/값 설정 |  |  |  |
| AC-2e1556f8 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:911 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].VerticalAlignment | CellVerticalAlignment.Center | 그리드 속성/값 설정 |  |  |  |
| AC-82ff3914 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:925 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a4937fb | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… 외 2 | SCP0024_ProductionPlanFix.cs:936 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0024_ProductionPlanFix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb82f98a | this.Load | SCP0024_ProductionPlanFix.cs:393 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0024_ProductionPlanFix.getBucketType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a4a915e | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:259 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-503a8adb | this.Load | SCP0024_ProductionPlanFix.cs:765 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-900c56ee | this.Load | SCP0024_ProductionPlanFix.cs:766 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ab52a09 | this.Load | SCP0024_ProductionPlanFix.cs:769 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.GetDayRange

진입점: this.Load / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click [if (success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e8495b4 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1166 |  | CALL_EXT | DateUtil.GetDayRange | (_division, _bucket_type, "", "12") | ⚠ 의미 확인 필요 |  |  |  |
| AC-99d63cc6 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1168 |  | RETURN | return dayRange; |  | 처리 중단/반환 |  |  |  |
| AC-c49af9b2 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1190 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-9b2f25fd | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1191 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-da045e4a | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1192 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-c77f44e7 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1193 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-662382f4 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1194 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-59b5772d | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1196 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0841b7e2 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:64 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9262d36e | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:235 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18473fb7 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:185 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ceb5d1e | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:161 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.GetLastRange

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ea481e6 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:1177 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-37f5de69 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:1178 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-7887bf1b | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:1179 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7de72d5e | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:1181 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41fa9da3 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:137 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.getOperationGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0963464 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:88 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.getPlantSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9789cc6c | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:112 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.GetSpdTitle

진입점: this.Load / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0abf3674 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1151 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-335c097b | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1156 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | _from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3767f9f2 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1157 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | _to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-62f3970a | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1159 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4f91d83b | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:1159 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0024_ProductionPlanFix.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e58ae426 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:209 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0024_ProductionPlanFix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d371555 | this.Load | SCP0024_ProductionPlanFix.cs:415 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-274f3ac1 | this.Load | SCP0024_ProductionPlanFix.cs:417 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5168191 | this.Load | SCP0024_ProductionPlanFix.cs:423 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-a5b8aa87 | this.Load | SCP0024_ProductionPlanFix.cs:426 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-f4d2fec9 | this.Load | SCP0024_ProductionPlanFix.cs:430 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-4f3bb7a2 | this.Load | SCP0024_ProductionPlanFix.cs:441 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem12.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9a73524e | this.Load | SCP0024_ProductionPlanFix.cs:444 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.InitSpread

진입점: this.Load / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcb3612a | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:463 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-e5c2e6d0 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:465 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-b1c0dc6d | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:470 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50988a0c | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:471 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a082d5ec | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:475 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!_division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c4782135 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:476 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!_division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-115c7520 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:480 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!_division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d2a66d8b | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:481 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!_division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd1f9beb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:520 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15ff0e67 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:524 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-167e1ea6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:528 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-62169639 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:535 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e644f54 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:536 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c953a65f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:541 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f07394c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:542 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c0b6dd5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:550 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-860e6053 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:551 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e87ec24f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:561 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d0056c6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:562 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a8aa670 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:563 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e490bce | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0024_ProductionPlanFix.cs:564 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0024_ProductionPlanFix.InitSpreadFixReason

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b8a16d9 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1085 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_INIT | siMain.SetCellTypeText | (iRow, iCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4a977357 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1087 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | DATA_OP | dtFixReason.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2515057e | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1097 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_SET | siMain.SetValue | (iRow, iCol, dr[DefColumns.FIX_REASON].ToString()) | 그리드 값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.RefreshBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68b708e9 | this.Load | SCP0024_ProductionPlanFix.cs:821 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe60efd5 | this.Load | SCP0024_ProductionPlanFix.cs:822 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0024_ProductionPlanFix.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78663d3c | this.Load | SCP0024_ProductionPlanFix.cs:774 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0024_ProductionPlanFix.RefreshLine

진입점: this.Load / cboOperationGroup.SelectedIndexChanged / cboDivision.SelectedIndexChanged / clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d12d2833 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:807 | if (_division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "OPERATION_GROUP", "SITE_ID" }, new List<string>() { … | ⚠ 의미 확인 필요 |  |  |  |
| AC-46e0a43c | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:808 | if (_division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineEEAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbc1a027 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:808 | if (_division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineEEAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-98ac1c24 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:812 | else of (_division.Substring(0, 2).Equals("EE")) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "SITE_ID" }, new List<string>() { _division, _plant_s… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6145d58a | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:813 | else of (_division.Substring(0, 2).Equals("EE")) | FLAG | dtLine | DBUtils.Filter(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c5869ed0 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:813 | else of (_division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtLineAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-db9fb1d9 | this.Load 외 3 | SCP0024_ProductionPlanFix.cs:816 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0024_ProductionPlanFix.RefreshOperationGroup

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a86eca7 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:780 | if (_division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-52b8dd33 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:780 | if (_division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a7fabb65 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:782 | else of (_division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3ced91d | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:782 | else of (_division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-abb7b322 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:784 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0024_ProductionPlanFix.RefreshPlantSite

진입점: this.Load / cboOperationGroup.SelectedIndexChanged / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d213bc71 | this.Load 외 2 | SCP0024_ProductionPlanFix.cs:791 | if (_division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteEEAll, "DIVISION_ID = '" + _division + "' AND OPERATION_GROUP = … | 화면 필드/플래그 변경 |  |  |  |
| AC-c2e1c7e1 | this.Load 외 2 | SCP0024_ProductionPlanFix.cs:791 | if (_division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteEEAll, "DIVISION_ID = '" + _division + "' AND OPERATION_GROUP = '" + _operatio… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3e3feb33 | this.Load 외 2 | SCP0024_ProductionPlanFix.cs:795 | else of (_division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteAll, "DIVISION_ID = '" + _division + "' AND OPERATION_GROUP = '"… | 화면 필드/플래그 변경 |  |  |  |
| AC-9a267690 | this.Load 외 2 | SCP0024_ProductionPlanFix.cs:795 | else of (_division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, "DIVISION_ID = '" + _division + "' AND OPERATION_GROUP = '" + _operation_… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6b83831a | this.Load 외 2 | SCP0024_ProductionPlanFix.cs:798 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0024_ProductionPlanFix.SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74295c22 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:961 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-302a4712 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:961 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c9ef520 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1012 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-825e04a7 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1017 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eef09241 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1021 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-32ca5f90 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1022 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2b9f6710 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-d303dc24 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5cd67e32 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1025 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-f8933325 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1026 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-124ec4d6 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1027 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-b053b335 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1028 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-3949d67d | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-31b2380f | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1030 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-046fea0a | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1031 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fix_reason"] | p_fix_reason | 행/컬럼 값 대입 |  |  |  |
| AC-7f6f21f7 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1032 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-346670e6 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c6c9c1e | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-54f68ce4 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1043 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToSt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa5d9b00 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1052 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0]… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0024_ProductionPlanFix.SaveData_FixInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29a08a6f | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1577 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbfbdcb6 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1601 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4bd4ed8 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1602 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da3f9377 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1676 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67dcc7d7 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1676 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (MessageHelper.GMe… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9d3ebbb | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1684 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX") ⇒ SCP.SCP0024_SAVE_PRODUCTION_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-22084149 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1686 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 60 * 15 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9342e364 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1688 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e8f828e8 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1689 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-abbabb39 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1690 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-51b2ea89 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1691 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-784d8585 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1692 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d946b891 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1693 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0607e66 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1694 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-76467a3d | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1695 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3d1c9e8f | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1696 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-2cb07814 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1697 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-5f9b4b24 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1698 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d4c0d41f | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1699 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_origin_division_id"] | p_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d72f981a | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1700 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-8eb9f1b0 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1701 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-1dd0ccfd | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1703 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0583733c | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1708 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd2b4155 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1721 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d68d161e | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1729 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d9dcbc4 | (진입점 미연결) | SCP0024_ProductionPlanFix.cs:1740 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0024_ProductionPlanFix.SaveData_FixInfo_U

진입점: btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5816d6c4 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1253 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e88137ac | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1259 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddcbc4a2 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1263 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b059fba | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1264 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-28f2b362 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1265 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ebafaf9 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1266 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-7eb996df | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1267 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4df6541 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1268 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-8752f583 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1269 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-70404bdc | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1270 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d33076f3 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1271 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6ff7aff | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1272 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-231966c4 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1273 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8976d589 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1274 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-1066cc53 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1275 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-f939d33e | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1276 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fa8f5c0 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1277 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_fix_reason") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ca3be32 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1278 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-10509dea | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1279 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_fix") | 데이터 객체 조작/조회 |  |  |  |
| AC-52678a49 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1280 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_loc_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f406cc0 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1281 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_program_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-2dc30987 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1282 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("debug_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-3516e1d9 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1283 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8fa0045 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1284 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-6701cb6b | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1285 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bucket_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-af247d9f | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1286 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_from_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-e33c412d | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1287 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_to_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7ed2dc6 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1289 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-21aebf4e | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1314 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-014dc30f | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1315 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af0b7826 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1319 | if (fps.Name == "spdMain") ▸ if (siMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d96dddd | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1319 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (MessageHelper.GMessageBox("MSG00016") != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef7e51ea | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1392 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f62b899 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1393 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-621b7d84 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1394 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b5a1333a | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1395 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-a458cb4f | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1396 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-4885f76e | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1397 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd5f7560 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1398 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-89f8dcdc | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1399 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-008c6815 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1400 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-7b89ed00 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1401 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0cddf436 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1402 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-26c89d6f | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1403 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ccf372f8 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1404 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-eba52c10 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1405 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b6e297e2 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1406 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-146b8a7b | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1444 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2a88a97b | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1445 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-ad583d88 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1446 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0c37a08e | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1447 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-3b2c3a84 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1448 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_scm_site_id"] | str_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-10ff374d | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1449 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_line_id"] | str_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-bbb29de0 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1450 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d0b399d6 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1451 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_id"] | str_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-058292d5 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1452 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-1aec18fe | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1453 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j + nDayCntOfWeek).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-960c6221 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1454 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_fix_reason"] | strReason | 행/컬럼 값 대입 |  |  |  |
| AC-24d74d5f | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1455 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_division_id"] | str_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bc409ab9 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1456 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-be7a8d25 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1457 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-af0dee66 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1458 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5be2ac7c | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1478 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb39157b | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1493 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0013", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc5d22ff | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1494 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveProductionPlanFix") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveProductionPlanFix] … | 엔드포인트 호출 |  |  |  |
| AC-269b5c1a | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1497 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0e61e4ba | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1502 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad329e2b | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1511 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1935e905 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1520 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-23290e0e | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1521 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-608beae7 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1527 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9accf422 | btnUnfix.Click | SCP0024_ProductionPlanFix.cs:1537 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0024_ProductionPlanFix.SCM_SYS_LOG_BATCH

진입점: btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71557ca5 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1553 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-68628551 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1554 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-87fc0ad9 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1555 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-74e2cb56 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1556 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-ed49d6ca | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1557 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-9f98b0b9 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1558 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-8e977f61 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1559 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-42cdec39 | btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != n… | SCP0024_ProductionPlanFix.cs:1561 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0024_ProductionPlanFix.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9a1cb05 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:835 | if (!_division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-14c3cf75 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:836 | if (!_division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-741c8736 | this.Load 외 1 | SCP0024_ProductionPlanFix.cs:840 | else of (!_division.Substring(0, 2).Equals("EE")) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0024_ProductionPlanFix.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / btnUnfix.Click [if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2ff9b40 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0024_ProductionPlanFix.cs:719 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (_bucket_type == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siObj… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-da692216 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0024_ProductionPlanFix.cs:724 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (_bucket_type == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siObj… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c16e8043 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0024_ProductionPlanFix.cs:731 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (_bucket_type == BucketType.Daily) ▸ if (_bucket_type == BucketType.Weekly) ▸ if (siObj.Ge… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6196b418 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0024_ProductionPlanFix.cs:735 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (_bucket_type == BucketType.Daily) ▸ if (_bucket_type == BucketType.Weekly) ▸ else of (siO… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7cc5bd7a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0024_ProductionPlanFix.cs:740 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (_bucket_type == BucketType.Daily) ▸ if (_bucket_type == BucketType.Weekly) ▸ if (siObj.Ge… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-99a5524a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0024_ProductionPlanFix.cs:747 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (_bucket_type == BucketType.Daily) ▸ else of (_bucket_type == BucketType.Weekly) ▸ if (_bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-19966974 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0024_ProductionPlanFix.cs:751 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (_bucket_type == BucketType.Daily) ▸ else of (_bucket_type == BucketType.Weekly) ▸ if (_bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0024_ProductionPlanFix.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02ae87dc | this.spdMain.CellDoubleClick | SCP0024_ProductionPlanFix.cs:1135 | if (e.ColumnHeader) | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b6974b9 | this.spdMain.CellDoubleClick | SCP0024_ProductionPlanFix.cs:1140 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a576567c | this.spdMain.CellDoubleClick | SCP0024_ProductionPlanFix.cs:1141 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0024_ProductionPlanFix.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c0b8ff4 | this.spdMain.TopChange | SCP0024_ProductionPlanFix.cs:597 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

