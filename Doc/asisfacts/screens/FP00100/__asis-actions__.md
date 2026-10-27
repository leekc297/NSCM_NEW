# AS-IS 액션 대조표 — FP00100

> 원천: `Doc/asisfacts/screens/FP00100/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 843행 · 메서드 80 · 종류 DATA_OP 337 · RETURN 87 · FLAG 79 · UI_PROP 40 · GRID_SET 37 · ENDPOINT 35 · MESSAGE 32 · GRID_INIT 28 · GRID_STYLE 25 · POPUP 23 · UI_MISC 20 · COMBO_DATA 19 · GRID_LOCK 16 · CALL_EXT 10 · THROW 9 · STATE 9 · GRID_COMBO 9 · LIST_REBIND 8 · VALIDATE 6 · GRID_BIND 5 · CALL_BASE 3 · EXCEL 2 · STATE_RESET 1 · FOCUS 1 · LIST_BIND 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 13


## FP00100_Line.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da65f2a0 | this.btnFind.Click | FP00100_Line.cs:2587 |  | FLAG | _ReFind_Sub_Click | false | 화면 필드/플래그 변경 |  |  |  |

## FP00100_Line.btnImport_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ebee90d | this.btnSql.Click | FP00100_Line.cs:1975 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-003c327e | this.btnSql.Click | FP00100_Line.cs:1979 | try | POPUP | new FPC0100_ExcelImportPopup | ("FPC0100", "LineExcelPopup", "FP_Master.PR_UI_FP00100_LINE_EXCEL", sParamsFilter, sDbPara… | 팝업/폼 생성 |  |  |  |
| AC-dfb8e5fe | this.btnSql.Click | FP00100_Line.cs:1980 | try | UI_PROP | popComImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3e439e0a | this.btnSql.Click | FP00100_Line.cs:1981 | try | POPUP | popComImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-77459ffe | this.btnSql.Click | FP00100_Line.cs:1992 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_Line.btnImport_WIP_Click

진입점: this.btnImport_WIP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ef675b4 | this.btnImport_WIP.Click | FP00100_Line.cs:2732 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-2cf12065 | this.btnImport_WIP.Click | FP00100_Line.cs:2736 | try | POPUP | new FPC0100_ExcelImportPopup_WIP | ("FPC0100", "LineExcelPopup_WIP", "FP_Master.PR_UI_FP00100_LINE_EXCEL", sParamsFilter, sDb… | 팝업/폼 생성 |  |  |  |
| AC-b54087f5 | this.btnImport_WIP.Click | FP00100_Line.cs:2737 | try | UI_PROP | popComImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fb188994 | this.btnImport_WIP.Click | FP00100_Line.cs:2738 | try | POPUP | popComImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-59095638 | this.btnImport_WIP.Click | FP00100_Line.cs:2749 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_Line.btnSql_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49193ed3 | this.btnImport.Click | FP00100_Line.cs:1928 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-729c4e0b | this.btnImport.Click | FP00100_Line.cs:1929 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-57384b6f | this.btnImport.Click | FP00100_Line.cs:1931 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00100_LINE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0081627b | this.btnImport.Click | FP00100_Line.cs:1932 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00100_LINE_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ad43e90 | this.btnImport.Click | FP00100_Line.cs:1933 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00100_Line.btnSql2_Click

진입점: this.btnSql2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80fd9709 | this.btnSql2.Click | FP00100_Line.cs:2755 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c68ee3d8 | this.btnSql2.Click | FP00100_Line.cs:2756 |  | UI_PROP | popSql2.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-64881624 | this.btnSql2.Click | FP00100_Line.cs:2758 |  | DATA_OP | popSql2.Services.Add | ("PR_UI_FP00100_LINE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a3d7172 | this.btnSql2.Click | FP00100_Line.cs:2760 |  | POPUP | popSql2.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00100_Line.CheckValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f5e7b28 | (진입점 미연결) | FP00100_Line.cs:2532 | try ▸ if (spd.SpreadObject.DataSource == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ebb929ae | (진입점 미연결) | FP00100_Line.cs:2561 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sUserID)) ▸ if (sUserID == schkUserID) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0dd76d6a | (진입점 미연결) | FP00100_Line.cs:2562 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sUserID)) ▸ if (sUserID == schkUserID) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f5bdd39f | (진입점 미연결) | FP00100_Line.cs:2570 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-161a1e9e | (진입점 미연결) | FP00100_Line.cs:2572 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.ClbBuilding_SelectedIndexChanged

진입점: this.Load [try] / clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-615be1a1 | this.Load [try] 외 1 | FP00100_Line.cs:2030 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3f1f74a6 | this.Load [try] 외 1 | FP00100_Line.cs:2032 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00100_Line.ClbDivision_SelectedIndexChanged

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41ad02ab | this.Load [try] 외 1 | FP00100_Line.cs:2003 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-0eaca1e3 | this.Load [try] 외 1 | FP00100_Line.cs:2005 |  | UI_PROP | clbSite.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00100_Line.ClbOperation_SelectedIndexChanged

진입점: this.Load [try] / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dcd61eb | this.Load [try] 외 1 | FP00100_Line.cs:2038 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-75841538 | this.Load [try] 외 1 | FP00100_Line.cs:2040 |  | UI_PROP | clbLine.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00100_Line.ClbPlant_SelectedIndexChanged

진입점: this.Load [try] / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5462d0c1 | this.Load [try] 외 1 | FP00100_Line.cs:2021 |  | UI_PROP | clbBuilding.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3780b376 | this.Load [try] 외 1 | FP00100_Line.cs:2023 |  | UI_PROP | clbBuilding.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00100_Line.ClbSite_SelectedIndexChanged

진입점: this.Load [try] / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90e872f4 | this.Load [try] 외 1 | FP00100_Line.cs:2012 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-0ac1d6c3 | this.Load [try] 외 1 | FP00100_Line.cs:2014 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00100_Line.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f08345 | (진입점 미연결) | FP00100_Line.cs:492 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5a05d698 | (진입점 미연결) | FP00100_Line.cs:493 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00100_Line.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75478f7c | this.Load | FP00100_Line.cs:502 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6248989d | this.Load | FP00100_Line.cs:503 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f4cb859 | this.Load | FP00100_Line.cs:507 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-18cc767d | this.Load | FP00100_Line.cs:508 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP00100_Line.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2618d72 | this.Load | FP00100_Line.cs:281 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-5b7baf7d | this.Load | FP00100_Line.cs:283 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9ad7f124 | this.Load | FP00100_Line.cs:284 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-fd2429d1 | this.Load | FP00100_Line.cs:285 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00100_Line.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab2992b1 | DeleteButton | FP00100_Line.cs:840 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3b1ae6f | DeleteButton | FP00100_Line.cs:844 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e86d991a | DeleteButton | FP00100_Line.cs:864 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) ▸ if (siSub.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-876acd04 | DeleteButton | FP00100_Line.cs:868 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00100_Line.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dad4e52 | Dispose | FP00100_Line.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00100_Line.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a09187a | EditButton | FP00100_Line.cs:630 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-11310c31 | EditButton | FP00100_Line.cs:632 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4b863fdc | EditButton | FP00100_Line.cs:635 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.LINE_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7adf0a95 | EditButton | FP00100_Line.cs:636 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE), siMain.GetColumnIndex(DefColumns.ELECTR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a93ab3ad | EditButton | FP00100_Line.cs:637 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINE_TYPE), siMain.GetColumnIndex(DefColumns.LINE_TYPE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-427c6658 | EditButton | FP00100_Line.cs:639 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PROD_VERSION_TYPE), siMain.GetColumnIndex(DefColumns.EQU… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e1af3f9 | EditButton | FP00100_Line.cs:648 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (nowGroupID != "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.VIRTUAL_LINE_YN), siMain.GetColumnIndex(DefColumns.LINK_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-de8baaf4 | EditButton | FP00100_Line.cs:653 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-32bf78a9 | EditButton | FP00100_Line.cs:662 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-f6f230eb | EditButton | FP00100_Line.cs:666 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-d848c63f | EditButton | FP00100_Line.cs:670 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-c838c869 | EditButton | FP00100_Line.cs:677 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_NAME), i, siMain.GetColumnIndex(DefColumns.LINE_… | 그리드 표시 설정 |  |  |  |
| AC-80e6e868 | EditButton | FP00100_Line.cs:678 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_ATTRIBUTE1), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-f2877791 | EditButton | FP00100_Line.cs:679 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_MODEL_TYPE), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-80bc3ed9 | EditButton | FP00100_Line.cs:680 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MES_LINE_ID), i, siMain.GetColumnIndex(DefColumns.WOR… | 그리드 표시 설정 |  |  |  |
| AC-e55dd968 | EditButton | FP00100_Line.cs:681 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_GROUP_ID), i, siMain.GetColumnIndex(DefColumns.L… | 그리드 표시 설정 |  |  |  |
| AC-d46a9fd3 | EditButton | FP00100_Line.cs:687 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.VIRTUAL_LINE_YN), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-1a1d0e5c | EditButton | FP00100_Line.cs:688 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINK_LINE_ID), i, siMain.GetColumnIndex(DefColumns.LI… | 그리드 표시 설정 |  |  |  |
| AC-a12ad45d | EditButton | FP00100_Line.cs:694 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_NAME), i, siMain.GetColumnIndex(DefColumns.LINE_… | 그리드 표시 설정 |  |  |  |
| AC-a4c61d09 | EditButton | FP00100_Line.cs:695 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_ATTRIBUTE1), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-6f589875 | EditButton | FP00100_Line.cs:696 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_MODEL_TYPE), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-7ec87e39 | EditButton | FP00100_Line.cs:697 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MES_LINE_ID), i, siMain.GetColumnIndex(DefColumns.WOR… | 그리드 표시 설정 |  |  |  |
| AC-21cd1bfa | EditButton | FP00100_Line.cs:698 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINE_GROUP_ID), i, siMain.GetColumnIndex(DefColumns.L… | 그리드 표시 설정 |  |  |  |
| AC-7cf89873 | EditButton | FP00100_Line.cs:704 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.VIRTUAL_LINE_YN), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-46b53213 | EditButton | FP00100_Line.cs:705 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LINK_LINE_ID), i, siMain.GetColumnIndex(DefColumns.LI… | 그리드 표시 설정 |  |  |  |
| AC-30a60f11 | EditButton | FP00100_Line.cs:715 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_SET | siMain.ActiveSheet.Cells[i, nPseudo].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-1070a11b | EditButton | FP00100_Line.cs:720 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-f9ff34d0 | EditButton | FP00100_Line.cs:724 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-51d75b08 | EditButton | FP00100_Line.cs:731 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PSEUDO_FACTORY_ID), i, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-79a44025 | EditButton | FP00100_Line.cs:735 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PSEUDO_FACTORY_ID), i, siMain.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-1a2a30bf | EditButton | FP00100_Line.cs:751 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i <= siMain.GetMaxRowIn… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.ActiveSheet.Columns.Count - 1, ControlColor.AlternatingRow) | 그리드 표시 설정 |  |  |  |
| AC-cc4119b8 | EditButton | FP00100_Line.cs:757 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) ▸ if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i <= siMain.GetMaxRowIn… | GRID_STYLE | siMain.SetBGColor | (i, 0, i, siMain.ActiveSheet.Columns.Count - 1, ControlColor.LockColor) | 그리드 표시 설정 |  |  |  |
| AC-5e64dbdc | EditButton | FP00100_Line.cs:764 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (spdMain != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a4f0d65c | EditButton | FP00100_Line.cs:772 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce599e19 | EditButton | FP00100_Line.cs:773 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f7a57ce3 | EditButton | FP00100_Line.cs:775 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex("COMPANY_ID"), siSub.GetColumnIndex("WIP_UOM"), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b4bdf7d | EditButton | FP00100_Line.cs:776 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex("AS_WAS_WIP"), siSub.GetColumnIndex("UPDATE_ID"), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-41db286b | EditButton | FP00100_Line.cs:786 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ i… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex("AS_IS_WIP"), i, siSub.GetColumnIndex("AS_IS_WIP"), System.Drawin… | 그리드 표시 설정 |  |  |  |
| AC-7e7f2b22 | EditButton | FP00100_Line.cs:791 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ e… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex("AS_IS_WIP"), i, siSub.GetColumnIndex("AS_IS_WIP"), System.Drawin… | 그리드 표시 설정 |  |  |  |
| AC-7250c017 | EditButton | FP00100_Line.cs:806 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ i… | GRID_STYLE | siSub.SetBGColor | (i, 0, i, siSub.ActiveSheet.Columns.Count - 1, ControlColor.AlternatingRow) | 그리드 표시 설정 |  |  |  |
| AC-3f339052 | EditButton | FP00100_Line.cs:811 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null) ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ i… | GRID_STYLE | siSub.SetBGColor | (i, 0, i, siSub.ActiveSheet.Columns.Count - 1, ControlColor.LockColor) | 그리드 표시 설정 |  |  |  |

## FP00100_Line.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28be3fbf | ExcelButton | FP00100_Line.cs:1916 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00100_Line.Find_Data

진입점: FindButton [if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7967c3c | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:902 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ea0b6948 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:906 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f41a8f3 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:909 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1e2e6398 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:909 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e654911 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:917 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8acb01d4 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:920 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e530538b | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:926 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b9fbc0a5 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:929 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dab37f0c | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:936 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-a23569b8 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:938 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-48f72e58 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:940 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-21c416e2 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:943 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-95dcba6a | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:947 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf6f9916 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:955 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-cfa98185 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:961 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c4ced438 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:965 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c1cd9712 | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:967 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0eb72b5c | FindButton [if (fps.Name == "spdMain")] 외 1 | FP00100_Line.cs:967 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00100_Line.Find_Data_Line

진입점: popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] / FindButton [if (fps.Name == "spdMain") ▸ try ▸ lambda] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7346d90e | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1101 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0be3d3e | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1125 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00100_LINE") ⇒ FP_Master.PR_UI_FP00100_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-011a8b3f | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1127 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3c345b3e | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1128 | try | DATA_OP | request.Parameters["p_sys_flag"] | "S" | 행/컬럼 값 대입 |  |  |  |
| AC-7aff3bee | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1130 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-079aff52 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1131 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d5c6cbc6 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1133 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a23f931 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1134 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-ab7d780e | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1135 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-59821f8e | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1136 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-b6e3d233 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1137 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-cd012f20 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1138 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-e1d46891 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1139 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? "" : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-1686e8fe | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1140 | try | DATA_OP | request.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-197a56dc | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1141 | try | DATA_OP | request.Parameters["p_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8126f2b3 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1142 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e1de82ef | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1143 | try | DATA_OP | request.Parameters["p_line_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b9b4b900 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1144 | try | DATA_OP | request.Parameters["p_line_type_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3275818e | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1145 | try | DATA_OP | request.Parameters["p_model_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-76815d59 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1146 | try | DATA_OP | request.Parameters["p_line_attribute1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-90dee020 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1147 | try | DATA_OP | request.Parameters["p_line_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-50862b08 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1148 | try | DATA_OP | request.Parameters["p_active_flag"] | pActive_Flag.Equals("ALL") ? DBNull.Value : pActive_Flag | 행/컬럼 값 대입 |  |  |  |
| AC-a14261a6 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1149 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9d95d0b2 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1150 | try | DATA_OP | request.Parameters["p_scp_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a8b097c | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1151 | try | DATA_OP | request.Parameters["p_prod_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6da948fa | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1152 | try | DATA_OP | request.Parameters["p_equipment_count"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb798de3 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1153 | try | DATA_OP | request.Parameters["p_mes_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f86cc07 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1154 | try | DATA_OP | request.Parameters["p_work_center_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a873621 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1155 | try | DATA_OP | request.Parameters["p_line_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-60dac383 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1157 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e115140 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1159 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-def25374 | popSql.OnSql [if (programID == "PR_UI_FP00100_LINE")] 외 2 | FP00100_Line.cs:1164 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.Find_Data_Line_ALL

진입점: this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lambda] / popSql2.OnSql [if (programID == "PR_UI_FP00100_LINE") ▸ else of (_ReFind_Sub_Click)] / FindButton [else of (fps.Name == "spdMain") ▸ try ▸ lambda] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ else of (_ReFind_Sub_Click) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f2cd30b | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1283 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-412c4f59 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1307 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00100_LINE") ⇒ FP_Master.PR_UI_FP00100_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-bf20a9ef | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1309 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-39e68bbb | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1310 | try | DATA_OP | request.Parameters["p_sys_flag"] | "WIP_LEVEL" | 행/컬럼 값 대입 |  |  |  |
| AC-14cb49cd | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1312 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fc5ce931 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1313 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-32c0208f | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1315 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b92ee94 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1316 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-b7fbe0b3 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1317 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-ea0f70f8 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1318 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-783d7a34 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1319 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-4f5c3909 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1320 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-554c6e97 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1321 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? "" : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-5a9cb06b | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1322 | try | DATA_OP | request.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f778357 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1323 | try | DATA_OP | request.Parameters["p_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e9e1dbe6 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1324 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b35a4824 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1325 | try | DATA_OP | request.Parameters["p_line_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f951ec63 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1326 | try | DATA_OP | request.Parameters["p_line_type_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8c63afc | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1327 | try | DATA_OP | request.Parameters["p_model_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2275f1df | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1328 | try | DATA_OP | request.Parameters["p_line_attribute1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-85f6c6ec | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1329 | try | DATA_OP | request.Parameters["p_line_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c3af3976 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1330 | try | DATA_OP | request.Parameters["p_active_flag"] | pActive_Flag.Equals("ALL") ? DBNull.Value : pActive_Flag | 행/컬럼 값 대입 |  |  |  |
| AC-535a8c26 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1331 | try | DATA_OP | request.Parameters["p_description"] | ReMonthDate(_b_ToDay) | 행/컬럼 값 대입 |  |  |  |
| AC-90fbc744 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1332 | try | DATA_OP | request.Parameters["p_scp_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-912f4269 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1333 | try | DATA_OP | request.Parameters["p_prod_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-adf6aea0 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1334 | try | DATA_OP | request.Parameters["p_equipment_count"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-908324c0 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1336 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab0a6860 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1338 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9e280876 | this.btnFind.Click [else of (_ReFind_Sub_Click) ▸ try ▸ lamb… 외 3 | FP00100_Line.cs:1343 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.Find_Data_Line_Sub

진입점: this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] / spdMain.CellDoubleClick [if (!ableDoubleClick) ▸ lambda] / popSql2.OnSql [if (programID == "PR_UI_FP00100_LINE") ▸ if (_ReFind_Sub_Click)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (_ReFind_Sub_Click) ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd27ea60 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1185 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00100_LINE") ⇒ FP_Master.PR_UI_FP00100_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-0fca0116 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1187 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f98c85a | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1188 | try | DATA_OP | request.Parameters["p_sys_flag"] | SpdSheet.shtSub | 행/컬럼 값 대입 |  |  |  |
| AC-83d43815 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1190 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bce67396 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1191 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ca0abc71 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1193 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e2558ae | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1194 | try | DATA_OP | request.Parameters["p_division_id"] | Filter_Sub["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bddc342e | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1195 | try | DATA_OP | request.Parameters["p_site_id"] | Filter_Sub["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7578608f | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1196 | try | DATA_OP | request.Parameters["p_plant_id"] | Filter_Sub["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7eaf4470 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1197 | try | DATA_OP | request.Parameters["p_factory_id"] | Filter_Sub["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2896f6d3 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1198 | try | DATA_OP | request.Parameters["p_operation_id"] | Filter_Sub["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-94f6ec26 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1199 | try | DATA_OP | request.Parameters["p_line_id"] | Filter_Sub["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-07b25c84 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1200 | try | DATA_OP | request.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f059a43d | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1201 | try | DATA_OP | request.Parameters["p_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2503a7ca | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1202 | try | DATA_OP | request.Parameters["p_electrode_type"] | Filter_Sub["ELECTRODE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5d3ae18d | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1203 | try | DATA_OP | request.Parameters["p_line_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-99649f66 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1204 | try | DATA_OP | request.Parameters["p_line_type_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c9aeb0a | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1205 | try | DATA_OP | request.Parameters["p_model_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f66f294 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1206 | try | DATA_OP | request.Parameters["p_line_attribute1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-56a3e81f | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1207 | try | DATA_OP | request.Parameters["p_line_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0fd23fbc | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1208 | try | DATA_OP | request.Parameters["p_active_flag"] | Filter_Sub["ACTIVE_FLAG"] | 행/컬럼 값 대입 |  |  |  |
| AC-0b150418 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1210 | try | DATA_OP | request.Parameters["p_description"] | ReMonthDate(_b_ToDay) | 행/컬럼 값 대입 |  |  |  |
| AC-615bf329 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1211 | try | DATA_OP | request.Parameters["p_scp_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2777fb04 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1212 | try | DATA_OP | request.Parameters["p_prod_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d2c7d21 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1213 | try | DATA_OP | request.Parameters["p_equipment_count"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d2179a8 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1215 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-48d163a6 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1217 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8834c9d3 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda] 외 4 | FP00100_Line.cs:1222 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.FindData_Sub

진입점: this.btnFind.Click [if (_ReFind_Sub_Click)] / spdMain.CellDoubleClick [if (!ableDoubleClick)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (_ReFind_Sub_Click)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5673c21 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:981 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line_Sub(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f35bf30a | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:985 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a70fb712 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:989 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-023c335d | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:990 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-21df59ad | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:994 | if (ds == null) | FLAG | ableDoubleClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-72070ebe | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:995 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe47b396 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:997 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1d580cc4 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:1000 |  | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a1247ea8 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:1003 |  | FLAG | ableDoubleClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c891dd44 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:1011 |  | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-a8304bda | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 3 | FP00100_Line.cs:1013 |  | GRID_SET | siSub.ActiveSheet.Columns[idx_LANE_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |

## FP00100_Line.FindData_Sub_2

진입점: this.btnFind.Click [else of (_ReFind_Sub_Click)] / FindButton [else of (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ else of (_ReFind_Sub_Click)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a987bf5 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1023 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f5707a3 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1024 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-034539e5 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1027 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-010714d4 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1035 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line_ALL(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77f234ae | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1039 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc6a57eb | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1043 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f8086476 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1044 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e301a8a5 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1046 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-91792599 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1049 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-63b32ba5 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1052 | try | FLAG | ableDoubleClick | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9a5bef45 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1060 | try | UI_PROP | num.DecimalPlaces | Place | 속성 DecimalPlaces 설정 |  |  |  |
| AC-2e9fa805 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1062 | try | GRID_SET | siSub.ActiveSheet.Columns[idx_LANE_QTY].CellType | num | 그리드 속성/값 설정 |  |  |  |
| AC-68e4dc01 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1068 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7eea0049 | this.btnFind.Click [else of (_ReFind_Sub_Click)] 외 2 | FP00100_Line.cs:1072 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00100_Line.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a79237b5 | this.Load | FP00100_Line.cs:148 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00100_Line.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dfffae9 | (진입점 미연결) | FP00100_Line.cs:2492 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.GetToDay

진입점: this.Load [try] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ if (clbSite.GetComboBoxText == "ALL" \|\| clbSite.GetComboBoxText.Contains("(" + clbSite.Items.Count + ")"))] / clbSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ if (clbSite.GetComboBoxText == "ALL" \|\| clbSite.GetComboBoxText.Contains("(" + clbSite.Items.Count + ")"))] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ if (clbSite.GetCo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ff4a361 | this.Load [try] 외 6 | FP00100_Line.cs:274 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMM") | 화면 필드/플래그 변경 |  |  |  |
| AC-5c742425 | this.Load [try] 외 6 | FP00100_Line.cs:275 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9703f166 | this.Load | FP00100_Line.cs:189 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7cc8ee3c | this.Load | FP00100_Line.cs:195 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-074485a2 | this.Load | FP00100_Line.cs:196 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf8e6c5 | this.Load | FP00100_Line.cs:199 | try ▸ if (UserInfoContext.Current != null) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fbc3f644 | this.Load | FP00100_Line.cs:201 | try ▸ else of (UserInfoContext.Current != null) | DATA_OP | Filter["User_ID"] | "Unknown" | 행/컬럼 값 대입 |  |  |  |
| AC-6dc69af8 | this.Load | FP00100_Line.cs:205 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-4a99ef7f | this.Load | FP00100_Line.cs:207 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-5686ea4c | this.Load | FP00100_Line.cs:209 | try | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "findAmendIn… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d6cd3dc7 | this.Load | FP00100_Line.cs:209 | try | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "findAmendInstanceList_common", lv_amendInstance, … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9758d73 | this.Load | FP00100_Line.cs:210 | try | FLAG | dtAvailableInstance | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_instance", Filter.Dictionary, "MA… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] \| FP\MASTER\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-88d1d346 | this.Load | FP00100_Line.cs:210 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_instance", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] \| FP\MASTER\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d8604260 | this.Load | FP00100_Line.cs:211 | try | FLAG | dtLineOperationSetup | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_line_operation_group", Filter.Dic… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_operation_group] \| F… | 화면 필드/플래그 변경 |  |  |  |
| AC-10980916 | this.Load | FP00100_Line.cs:211 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_operation_group", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_operation_group] \| F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c4744f08 | this.Load | FP00100_Line.cs:213 | try | FLAG | dtLineAttribute | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00100_findLineLookup", "LINE_ATTRIBUTE… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-918996d1 | this.Load | FP00100_Line.cs:213 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00100_findLineLookup", "LINE_ATTRIBUTE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6fd1a478 | this.Load | FP00100_Line.cs:214 | try | FLAG | dtLineLocation | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00100_findLineLookup", "LINE_LOCATION"… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-60f256c8 | this.Load | FP00100_Line.cs:214 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00100_findLineLookup", "LINE_LOCATION") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-adfc0b51 | this.Load | FP00100_Line.cs:215 | try | FLAG | dtLineModelType | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00100_findLineLookup", "LINE_MODEL_TYP… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e61ff9b4 | this.Load | FP00100_Line.cs:215 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00100_findLineLookup", "LINE_MODEL_TYPE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a171dc7d | this.Load | FP00100_Line.cs:216 | try | FLAG | dtLineSetupGroup | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00100_findMatrix_linesetup") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-9929318b | this.Load | FP00100_Line.cs:216 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00100_findMatrix_linesetup") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8cab98eb | this.Load | FP00100_Line.cs:217 | try | FLAG | dtVIRTUAL_FACTORY | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00100_find_virtual_factory") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0e419b2d | this.Load | FP00100_Line.cs:217 | try | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00100_find_virtual_factory") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-86c785ce | this.Load | FP00100_Line.cs:230 | try | FLAG | dtYesOrNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-3675ec33 | this.Load | FP00100_Line.cs:230 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1d9129ea | this.Load | FP00100_Line.cs:231 | try | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2f0b5130 | this.Load | FP00100_Line.cs:234 | try | FLAG | dtELECTRODE_TYPE | Data_FP.Common_FP(Data_FP.Type.ELECTRODE_TYPE, false, UserInfoContext.Current.UserId, _sNo… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ELECTRODE_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-68e0e75f | this.Load | FP00100_Line.cs:234 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ELECTRODE_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ELECTRODE_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-407752e9 | this.Load | FP00100_Line.cs:236 | try | FLAG | dtELECTRODE_TYPE | dtELECTRODE_TYPE.Select().Where(c => c["CODE"].ToString() == "Anode" \|\| c["CODE"].ToStri… | 화면 필드/플래그 변경 |  |  |  |
| AC-952b6b8b | this.Load | FP00100_Line.cs:236 | try | DATA_OP | dtELECTRODE_TYPE.Select().Where(c => c["CODE"].ToString() == "Anode" \|\| c["CODE"].ToStri… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-05d0ac9e | this.Load | FP00100_Line.cs:236 | try | DATA_OP | dtELECTRODE_TYPE.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0fb2ece4 | this.Load | FP00100_Line.cs:246 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-32ae4221 | this.Load | FP00100_Line.cs:247 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-75b35905 | this.Load | FP00100_Line.cs:248 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f3de3e83 | this.Load | FP00100_Line.cs:250 | try ▸ if (adminAuth == false) | STATE | btnSql2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c467cec8 | this.Load | FP00100_Line.cs:251 | try ▸ if (adminAuth == false) | STATE | btnSql2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f2e9d7e5 | this.Load | FP00100_Line.cs:252 | try ▸ if (adminAuth == false) | STATE | btnSql2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0b2b1066 | this.Load | FP00100_Line.cs:257 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0772c954 | this.Load | FP00100_Line.cs:258 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-07f08d2b | this.Load | FP00100_Line.cs:259 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-46ea7b54 | this.Load | FP00100_Line.cs:267 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_Line.InitSpread_main

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19678100 | this.Load | FP00100_Line.cs:524 | try | CALL_EXT | siMain.SetColumnCombo | ("PSEUDO_FACTORY_ID", dtVIRTUAL_FACTORY) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6632dfb5 | this.Load | FP00100_Line.cs:529 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_Line.InitSpread_Sub

진입점: this.btnFind.Click [if (_ReFind_Sub_Click)] / this.Load / spdMain.CellDoubleClick [if (!ableDoubleClick)] / FindButton [else of (fps.Name == "spdMain") ▸ try] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (_ReFind_Sub_Click)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4be2be6 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 5 | FP00100_Line.cs:544 | try | GRID_INIT | siSub.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6d57e0e4 | this.btnFind.Click [if (_ReFind_Sub_Click)] 외 5 | FP00100_Line.cs:548 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_Line.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ed225e3 | InsertButton | FP00100_Line.cs:1358 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d80a0e7 | InsertButton | FP00100_Line.cs:1366 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.FACTORY_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a16a0881 | InsertButton | FP00100_Line.cs:1367 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.OPERATION_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c8e781c7 | InsertButton | FP00100_Line.cs:1370 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-98461777 | InsertButton | FP00100_Line.cs:1371 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | DATA_OP | defaultData.Add | (DefColumns.VIRTUAL_LINE_YN, "N") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6fb509a | InsertButton | FP00100_Line.cs:1373 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-eab9cb24 | InsertButton | FP00100_Line.cs:1375 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## FP00100_Line.ReMonthDate

진입점: this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda ▸ try] / spdMain.CellDoubleClick [if (!ableDoubleClick) ▸ lambda ▸ try] / popSql2.OnSql [if (programID == "PR_UI_FP00100_LINE") ▸ if (_ReFind_Sub_Click) ▸ try] / FindButton [else of (fps.Name == "spdMain") ▸ try ▸ lambda ▸ try] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (_ReFind_Sub_Click) ▸ lambda ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac8886ac | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda ▸ try] 외 5 | FP00100_Line.cs:1244 |  | DATA_OP | cntMonth.Add | (nowMonth) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1fc0c7d | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda ▸ try] 외 5 | FP00100_Line.cs:1252 | for (i < 12) ▸ if (strNowMonth.Substring(strNowMonth.Length - 2, 2) == "12") | DATA_OP | cntMonth.Add | (nowMonth) | 데이터 객체 조작/조회 |  |  |  |
| AC-f927a044 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda ▸ try] 외 5 | FP00100_Line.cs:1257 | for (i < 12) ▸ else of (strNowMonth.Substring(strNowMonth.Length - 2, 2) == "12") | DATA_OP | cntMonth.Add | (nowMonth) | 데이터 객체 조작/조회 |  |  |  |
| AC-78501bdb | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ lambda ▸ try] 외 5 | FP00100_Line.cs:1269 |  | RETURN | return arr_Month; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.RunSql2Source

진입점: popSql2.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbd4043f | popSql2.OnSql | FP00100_Line.cs:2771 | if (programID == "PR_UI_FP00100_LINE") ▸ if (_ReFind_Sub_Click) | RETURN | return Find_Data_Line_Sub(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-f11a3965 | popSql2.OnSql | FP00100_Line.cs:2776 | if (programID == "PR_UI_FP00100_LINE") ▸ else of (_ReFind_Sub_Click) | RETURN | return Find_Data_Line_ALL(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-5bf20ba8 | popSql2.OnSql | FP00100_Line.cs:2783 | else of (programID == "PR_UI_FP00100_LINE") ▸ if (programID == "PR_UI_FP00100_LINE_SAVE") | RETURN | return Save_Data_Line_Sub(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-ce754f10 | popSql2.OnSql | FP00100_Line.cs:2785 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff9d392 | popSql.OnSql | FP00100_Line.cs:2517 | if (programID == "PR_UI_FP00100_LINE") | RETURN | return Find_Data_Line(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-85389002 | popSql.OnSql | FP00100_Line.cs:2521 | else of (programID == "PR_UI_FP00100_LINE") ▸ if (programID == "PR_UI_FP00100_LINE_SAVE") | RETURN | return Save_Data_Line(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-66a84755 | popSql.OnSql | FP00100_Line.cs:2523 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13c6279c | SaveButton | FP00100_Line.cs:1420 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6e280e4 | SaveButton | FP00100_Line.cs:1422 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b6ef216 | SaveButton | FP00100_Line.cs:1427 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-882b3428 | SaveButton | FP00100_Line.cs:1428 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e503c1e7 | SaveButton | FP00100_Line.cs:1431 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-882f83c1 | SaveButton | FP00100_Line.cs:1438 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-ecdfaf99 | SaveButton | FP00100_Line.cs:1440 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain… | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7a196f26 | SaveButton | FP00100_Line.cs:1441 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71ba2cc1 | SaveButton | FP00100_Line.cs:1446 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-702dcd17 | SaveButton | FP00100_Line.cs:1451 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8afae38 | SaveButton | FP00100_Line.cs:1454 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == … | FLAG | dtLineOperationSetup | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_line_operation_group", Filter.Dic… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_operation_group] \| F… | 화면 필드/플래그 변경 |  |  |  |
| AC-e1c0546d | SaveButton | FP00100_Line.cs:1454 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == … | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_operation_group", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_operation_group] \| F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c69018b9 | SaveButton | FP00100_Line.cs:1462 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString(… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72083dea | SaveButton | FP00100_Line.cs:1466 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e76e8c7e | SaveButton | FP00100_Line.cs:1470 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9008d88a | SaveButton | FP00100_Line.cs:1471 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-575fd10e | SaveButton | FP00100_Line.cs:1475 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6fbbb564 | SaveButton | FP00100_Line.cs:1481 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7784bf0d | SaveButton | FP00100_Line.cs:1483 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e34882bd | SaveButton | FP00100_Line.cs:1488 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (blnWork2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ca9f176 | SaveButton | FP00100_Line.cs:1489 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (blnWork2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaa342ad | SaveButton | FP00100_Line.cs:1492 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | blnWork2 | true | 화면 필드/플래그 변경 |  |  |  |
| AC-66a6d38d | SaveButton | FP00100_Line.cs:1499 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-25ef245c | SaveButton | FP00100_Line.cs:1501 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | FLAG | blnWork2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-189a3002 | SaveButton | FP00100_Line.cs:1502 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbed615d | SaveButton | FP00100_Line.cs:1507 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b8239b73 | SaveButton | FP00100_Line.cs:1512 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "S… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds2.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bac7fb90 | SaveButton | FP00100_Line.cs:1514 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "S… | FLAG | ableDoubleClick | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3a85499d | SaveButton | FP00100_Line.cs:1532 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds2.Tables[0].Rows[0][0].ToString() … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97583f2d | SaveButton | FP00100_Line.cs:1536 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try | FLAG | blnWork2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4ebd54e9 | SaveButton | FP00100_Line.cs:1540 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ catch ((Exception ex)) | FLAG | blnWork2 | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2d756ab9 | SaveButton | FP00100_Line.cs:1541 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f050c827 | SaveButton | FP00100_Line.cs:1545 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ finally | FLAG | blnWork2 | false | 화면 필드/플래그 변경 |  |  |  |

## FP00100_Line.Save_Data_Line

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ if (programID == "PR_UI_FP00100_LINE_SAVE")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ebb9d05 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1735 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00100_LINE") ⇒ FP_Master.PR_UI_FP00100_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-a1ff31b0 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1736 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-84578c2d | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1738 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f7e5e6bb | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1739 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d8db6d30 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1740 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-821a7672 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1741 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1cd9b12 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1742 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c30b40a | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1743 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3abda86e | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1744 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d3438fa | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1745 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-141a30f2 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1746 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-3dcb308b | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1747 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-a3a43c40 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1748 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-19414e6f | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1749 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-02a70110 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1750 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_setup_group_id"] | p_line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-38c08291 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1751 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-630e1a6a | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1752 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-ed82c696 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1753 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type_name"] | p_line_type_name | 행/컬럼 값 대입 |  |  |  |
| AC-e6894d37 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1754 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_type"] | p_model_type | 행/컬럼 값 대입 |  |  |  |
| AC-be257e74 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1755 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_attribute1"] | p_line_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-171627d5 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1756 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_location"] | p_line_location | 행/컬럼 값 대입 |  |  |  |
| AC-48e45942 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1757 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f13b321f | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1758 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-311d320b | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1759 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_line_id"] | p_scp_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ea5610e | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1760 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_version_type"] | p_prod_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-fbb3b12c | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1761 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_count"] | p_equipment_count | 행/컬럼 값 대입 |  |  |  |
| AC-7d800668 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1762 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mes_line_id"] | p_mes_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-a9dc8b2d | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1763 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_work_center_id"] | p_work_center_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe336287 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1764 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_pseudo_factory_id"] | p_pseudo_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-fcccfc1d | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1765 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_group_id"] | p_line_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc192b28 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1766 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_virtual_line_yn"] | p_virtual_line_yn | 행/컬럼 값 대입 |  |  |  |
| AC-cb367214 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1767 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_link_line_id"] | p_link_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a732539 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1769 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-16f5e5f5 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1770 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9958ca0c | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1776 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e449dca2 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ … 외 1 | FP00100_Line.cs:1782 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.Save_Data_Line_New

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a72ab8c | (진입점 미연결) | FP00100_Line.cs:1571 | try | CALL_EXT | siMain.GetChangeDataSet | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-042ea889 | (진입점 미연결) | FP00100_Line.cs:1579 | try ▸ if (changed.Good()) ▸ foreach (DataColumn col in changed.Tables[0].Columns) | DATA_OP | param_values.Add | (col.ColumnName, value) | 데이터 객체 조작/조회 |  |  |  |
| AC-f13180a5 | (진입점 미연결) | FP00100_Line.cs:1607 | try ▸ if (changed.Good()) ▸ foreach (DataRow row in changed.Tables[0].Rows) ▸ foreach (DataColumn col in row.Table.Columns) | DATA_OP | param_values[col.ColumnName] | m | 행/컬럼 값 대입 |  |  |  |
| AC-3de7414d | (진입점 미연결) | FP00100_Line.cs:1615 | try ▸ if (changed.Good()) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00100_LINE") ⇒ FP_Master.PR_UI_FP00100_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-cabfa108 | (진입점 미연결) | FP00100_Line.cs:1616 | try ▸ if (changed.Good()) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4bf94766 | (진입점 미연결) | FP00100_Line.cs:1618 | try ▸ if (changed.Good()) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-2d117cf4 | (진입점 미연결) | FP00100_Line.cs:1619 | try ▸ if (changed.Good()) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-828cce68 | (진입점 미연결) | FP00100_Line.cs:1620 | try ▸ if (changed.Good()) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-9eb87c2e | (진입점 미연결) | FP00100_Line.cs:1621 | try ▸ if (changed.Good()) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4498f54f | (진입점 미연결) | FP00100_Line.cs:1626 | try ▸ if (changed.Good()) ▸ foreach (DataColumn col in changed.Tables[0].Columns) | DATA_OP | req.Parameters[param_key] | param_values[col.ColumnName] | 행/컬럼 값 대입 |  |  |  |
| AC-7274d168 | (진입점 미연결) | FP00100_Line.cs:1629 | try ▸ if (changed.Good()) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8fbc9a5 | (진입점 미연결) | FP00100_Line.cs:1630 | try ▸ if (changed.Good()) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ca3742e9 | (진입점 미연결) | FP00100_Line.cs:1636 | try ▸ else of (changed.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c4250c8a | (진입점 미연결) | FP00100_Line.cs:1642 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.Save_Data_Line_Sub

진입점: popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸ if (programID == "PR_UI_FP00100_LINE_SAVE")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a744b132 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1868 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00100_LINE") ⇒ FP_Master.PR_UI_FP00100_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-c4a02503 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1869 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0e3afbb8 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1871 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-62415d04 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1872 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-bd776b39 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1873 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-4dcd9ca1 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1874 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-30503896 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1875 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-5153e0d2 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1876 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0cd2067c | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1877 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-de160f53 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1878 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5f57c85 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1879 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d43b47e | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1880 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b4bd3f5 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1881 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-84a35d9c | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1882 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1dad185f | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1883 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05417ae2 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1884 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-7b00774f | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1885 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6aba790 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1886 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8c2b706 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1887 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b649c377 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1888 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_attribute1"] | p_line_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-e35e3005 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1889 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_location"] | p_LANE_QTY | 행/컬럼 값 대입 |  |  |  |
| AC-122b2ded | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1890 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b095f9b2 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1891 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-69835d89 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1892 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-adbdd52f | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1893 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b0d51474 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1894 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_count"] | p_equipment_count | 행/컬럼 값 대입 |  |  |  |
| AC-a2d2dde9 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1897 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c8af5fcb | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1898 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e848e448 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1904 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f753ccc8 | popSql2.OnSql [else of (programID == "PR_UI_FP00100_LINE") ▸… 외 1 | FP00100_Line.cs:1910 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6d64a70 | SaveButton | FP00100_Line.cs:884 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00100_Line.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbBuilding.SelectedIndexChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63e08d9a | this.Load [try] 외 6 | FP00100_Line.cs:298 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtMyDivision.Good()) | FLAG | dtMyDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-baf17631 | this.Load [try] 외 6 | FP00100_Line.cs:298 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtMyDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-eb4fd88b | this.Load [try] 외 6 | FP00100_Line.cs:304 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good()) | FLAG | dtSiteByDivision | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-413ff62a | this.Load [try] 외 6 | FP00100_Line.cs:304 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-07686ce1 | this.Load [try] 외 6 | FP00100_Line.cs:305 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b1d3903c | this.Load [try] 외 6 | FP00100_Line.cs:311 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSiteByDivision, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-62e3f435 | this.Load [try] 외 6 | FP00100_Line.cs:312 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | FLAG | dtPlantByDivision | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0da94fd2 | this.Load [try] 외 6 | FP00100_Line.cs:312 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-94ebf3c5 | this.Load [try] 외 6 | FP00100_Line.cs:313 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-32269f43 | this.Load [try] 외 6 | FP00100_Line.cs:314 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | DATA_OP | clbSite.GetComboBoxText.Contains | ("(" + clbSite.Items.Count + ")") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0288c93 | this.Load [try] 외 6 | FP00100_Line.cs:316 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ if (clbSite.GetComboBoxText == "ALL" \|\| clbSite.GetCombo… | FLAG | _b_ToDay | GetToDay() | 화면 필드/플래그 변경 |  |  |  |
| AC-b0dfb7f6 | this.Load [try] 외 6 | FP00100_Line.cs:325 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | CALL_EXT | _dicCountry.TryGetValue | (s_dtSite, out s_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e56a5c52 | this.Load [try] 외 6 | FP00100_Line.cs:328 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | CALL_EXT | dtInstance.Columns.Cast | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-499a548e | this.Load [try] 외 6 | FP00100_Line.cs:330 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | DATA_OP | row[col].ToString().Contains | (s_value) | 데이터 객체 조작/조회 |  |  |  |
| AC-e356a767 | this.Load [try] 외 6 | FP00100_Line.cs:333 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | DATA_OP | tt.Field<string>("CODE").Contains | (s_value + "_") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac8ecb1b | this.Load [try] 외 6 | FP00100_Line.cs:333 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | DATA_OP | tt.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-86ca18ca | this.Load [try] 외 6 | FP00100_Line.cs:337 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_find_CurrUTDate", rw[0].ToString()) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a201597d | this.Load [try] 외 6 | FP00100_Line.cs:340 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | FLAG | _b_ToDay | dt.Rows[0][0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c9d6ea64 | this.Load [try] 외 6 | FP00100_Line.cs:343 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | FLAG | _b_ToDay | tmpDtDate.Date.ToString("yyyyMM") | 화면 필드/플래그 변경 |  |  |  |
| AC-192964d3 | this.Load [try] 외 6 | FP00100_Line.cs:344 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) ▸ else of (clbSite.GetComboBoxText == "ALL" \|\| clbSite.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-352dc981 | this.Load [try] 외 6 | FP00100_Line.cs:350 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSiteByDivision.Good()) | FLAG | _b_ToDay | GetToDay() | 화면 필드/플래그 변경 |  |  |  |
| AC-36824355 | this.Load [try] 외 6 | FP00100_Line.cs:358 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlantByDivision, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-29a63b2d | this.Load [try] 외 6 | FP00100_Line.cs:359 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | FLAG | dtBuildingBySitePlant | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-c818d623 | this.Load [try] 외 6 | FP00100_Line.cs:359 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ca5cb1d3 | this.Load [try] 외 6 | FP00100_Line.cs:360 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-66c56b93 | this.Load [try] 외 6 | FP00100_Line.cs:367 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtBuildingBySitePlant, clbBuilding.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-653f883f | this.Load [try] 외 6 | FP00100_Line.cs:368 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | FLAG | dtOperationByBuilding | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-06101ad9 | this.Load [try] 외 6 | FP00100_Line.cs:368 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c27507fd | this.Load [try] 외 6 | FP00100_Line.cs:369 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingBySitePlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperationByBuilding, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f05dab91 | this.Load [try] 외 6 | FP00100_Line.cs:375 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperationByBuilding.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperationByBuilding, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-d332c3c8 | this.Load [try] 외 6 | FP00100_Line.cs:376 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperationByBuilding.Good()) | FLAG | dtLineByOperation | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef5d0f73 | this.Load [try] 외 6 | FP00100_Line.cs:376 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperationByBuilding.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-994aa815 | this.Load [try] 외 6 | FP00100_Line.cs:377 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperationByBuilding.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ade01b9a | this.Load [try] 외 6 | FP00100_Line.cs:383 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLineByOperation.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLineByOperation, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00100_Line.SetCountry

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cef76c59 | this.Load [try] | FP00100_Line.cs:163 |  | FLAG | _b_ToDay | GetToDay() | 화면 필드/플래그 변경 |  |  |  |
| AC-ccccba71 | this.Load [try] | FP00100_Line.cs:165 |  | FLAG | _dicCountry | new Dictionary<string, string>() | 화면 필드/플래그 변경 |  |  |  |
| AC-845946fe | this.Load [try] | FP00100_Line.cs:166 |  | FLAG | dtCountryID | Data_FP.Common_FP(Data_FP.Type.COUNTRY_ID, false, UserInfoContext.Current.UserId, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-16e9cb7c | this.Load [try] | FP00100_Line.cs:166 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.COUNTRY_ID, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9243417e | this.Load [try] | FP00100_Line.cs:172 | if (dtCountryID != null && dtCountryID.Rows.Count > 0) ▸ for (i < dtCountryID.Rows.Count) | DATA_OP | _dicCountry.ContainsKey | (dtCountryID.Rows[i][0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-db40c965 | this.Load [try] | FP00100_Line.cs:174 | if (dtCountryID != null && dtCountryID.Rows.Count > 0) ▸ for (i < dtCountryID.Rows.Count) ▸ if (_dicCountry.ContainsKey(dtCountryID.Rows[i][… | DATA_OP | _dicCountry.Add | (dtCountryID.Rows[i][0].ToString(), dtCountryID.Rows[i][1].ToString()) | 데이터 객체 조작/조회 |  |  |  |

## FP00100_Line.SetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81b524fd | this.Load [try] | FP00100_Line.cs:2498 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6d77addf | this.Load [try] | FP00100_Line.cs:2499 |  | FLAG | dtMyDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2948e6fe | this.Load [try] | FP00100_Line.cs:2499 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-028fdc68 | this.Load [try] | FP00100_Line.cs:2502 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-bf91f5df | this.Load [try] | FP00100_Line.cs:2505 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00100_Line.SetFilter

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbBuilding.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtMyDivision.Good())] / clbOperation.SelectedIndexChanged [swit…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5720a682 | this.Load [try ▸ switch (triggerControl) case DefColumns.DIV… 외 6 | FP00100_Line.cs:2482 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00100_Line.SetFilter_Sub

진입점: spdMain.CellDoubleClick [if (!ableDoubleClick)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71335498 | spdMain.CellDoubleClick [if (!ableDoubleClick)] | FP00100_Line.cs:2487 |  | DATA_OP | Filter_Sub[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00100_Line.SetSpreadInit

진입점: this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] / this.Load [try] / spdMain.CellDoubleClick [if (!ableDoubleClick) ▸ try] / FindButton [else of (fps.Name == "spdMain") ▸ try ▸ try] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds2.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ if (_ReFind_Sub_Click) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87af6009 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:557 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d28bf1d3 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:558 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (sheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8d7cf27a | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:560 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-d4354253 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:561 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.LINE_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7f719500 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:564 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cce47bd1 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:565 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.LINE_TYPE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d31e8a23 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:566 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a899798 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:567 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-96ff1aa3 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:571 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f01ceeb | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:572 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (sheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1d3e94af | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:575 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.SetSheetHeaderColumn_FP | (siSub, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-0323d55f | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:576 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.ColumnHeaderHeight | (0, 15) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-46e2e0fc | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:577 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siSub.ColumnHeaderHeight | (1, 15) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b9ec66c | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:585 | else of (sheetName.Equals(SpdSheet.shtMain)) | UI_PROP | cb.Items | cbstr | 속성 Items 설정 |  |  |  |
| AC-7c509724 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:586 | else of (sheetName.Equals(SpdSheet.shtMain)) | UI_PROP | cb.ItemData | strval | 속성 ItemData 설정 |  |  |  |
| AC-4e8f9d40 | this.btnFind.Click [if (_ReFind_Sub_Click) ▸ try] 외 5 | FP00100_Line.cs:588 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_SET | this.siSub.ActiveSheet.Columns["ELECTRODE_TYPE"].CellType | cb | 그리드 속성/값 설정 |  |  |  |

## FP00100_Line.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4db49035 | this.spdMain.CellClick | FP00100_Line.cs:2071 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b30a7d75 | this.spdMain.CellClick | FP00100_Line.cs:2073 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e921ae0 | this.spdMain.CellClick | FP00100_Line.cs:2094 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | POPUP | new FPC0001_BuildingPopup | (bFilterEnable, bMultiSelect, pDivision) | 팝업/폼 생성 |  |  |  |
| AC-6eab1db3 | this.spdMain.CellClick | FP00100_Line.cs:2095 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | UI_PROP | popLine.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0c566c01 | this.spdMain.CellClick | FP00100_Line.cs:2096 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | POPUP | popLine.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-16e4414e | this.spdMain.CellClick | FP00100_Line.cs:2108 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | DATA_OP | dsMain.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b13c95b6 | this.spdMain.CellClick | FP00100_Line.cs:2109 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | GRID_SET | siMain.ActiveSheet.Rows[e.Row].Tag | cRow | 그리드 속성/값 설정 |  |  |  |
| AC-0a226ef5 | this.spdMain.CellClick | FP00100_Line.cs:2113 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | DATA_OP | cRow[DefColumns.COMPANY_ID] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-fdd04284 | this.spdMain.CellClick | FP00100_Line.cs:2114 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | DATA_OP | cRow[DefColumns.DIVISION_ID] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1e6771e8 | this.spdMain.CellClick | FP00100_Line.cs:2115 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | DATA_OP | cRow[DefColumns.SITE_ID] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-1419250b | this.spdMain.CellClick | FP00100_Line.cs:2116 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | DATA_OP | cRow[DefColumns.PLANT_ID] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-898750e2 | this.spdMain.CellClick | FP00100_Line.cs:2117 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | DATA_OP | cRow[DefColumns.FACTORY_ID] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-82df79fc | this.spdMain.CellClick | FP00100_Line.cs:2120 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-d1cf6399 | this.spdMain.CellClick | FP00100_Line.cs:2121 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-a35f0981 | this.spdMain.CellClick | FP00100_Line.cs:2122 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-68894362 | this.spdMain.CellClick | FP00100_Line.cs:2123 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-2266c2c4 | this.spdMain.CellClick | FP00100_Line.cs:2124 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Colu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), sFactory) | 그리드 값 설정 |  |  |  |
| AC-b78cf975 | this.spdMain.CellClick | FP00100_Line.cs:2139 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad95c439 | this.spdMain.CellClick | FP00100_Line.cs:2145 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | POPUP | new FPC0002_OperationPopup | (bFilterEnable, bMultiSelect, sDivision, sSite) | 팝업/폼 생성 |  |  |  |
| AC-8c772134 | this.spdMain.CellClick | FP00100_Line.cs:2146 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-09c8b4ba | this.spdMain.CellClick | FP00100_Line.cs:2147 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fbacbb01 | this.spdMain.CellClick | FP00100_Line.cs:2159 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dsMain.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf2dff31 | this.spdMain.CellClick | FP00100_Line.cs:2160 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_SET | siMain.ActiveSheet.Rows[e.Row].Tag | cRow | 그리드 속성/값 설정 |  |  |  |
| AC-81568e4e | this.spdMain.CellClick | FP00100_Line.cs:2164 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | cRow[DefColumns.COMPANY_ID] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-10356bb5 | this.spdMain.CellClick | FP00100_Line.cs:2165 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | cRow[DefColumns.DIVISION_ID] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-82461184 | this.spdMain.CellClick | FP00100_Line.cs:2166 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | cRow[DefColumns.SITE_ID] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-bd93c23e | this.spdMain.CellClick | FP00100_Line.cs:2167 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | cRow[DefColumns.OPERATION_ID] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-ce534818 | this.spdMain.CellClick | FP00100_Line.cs:2169 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc[DefColumns.DIVISION_ID] | cRow[DefColumns.DIVISION_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-4268bf7c | this.spdMain.CellClick | FP00100_Line.cs:2170 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc[DefColumns.SITE_ID] | cRow[DefColumns.SITE_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-4eefafb5 | this.spdMain.CellClick | FP00100_Line.cs:2171 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc[DefColumns.COMPANY_ID] | cRow[DefColumns.COMPANY_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-245a5a3e | this.spdMain.CellClick | FP00100_Line.cs:2172 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc[DefColumns.OPERATION_ID] | cRow[DefColumns.OPERATION_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-2fcca8e9 | this.spdMain.CellClick | FP00100_Line.cs:2173 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc[DefColumns.FACTORY_ID] | cRow[DefColumns.FACTORY_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ea34298 | this.spdMain.CellClick | FP00100_Line.cs:2174 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_instance_from_tree", loc.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_from_tree] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-494f83f2 | this.spdMain.CellClick | FP00100_Line.cs:2177 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | cRow["INSTANCE_ID"] | dtInstanceTree.Rows[0]["INSTANCE_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-75084bf7 | this.spdMain.CellClick | FP00100_Line.cs:2181 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), sOperation) | 그리드 값 설정 |  |  |  |
| AC-528dce43 | this.spdMain.CellClick | FP00100_Line.cs:2188 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4775046e | this.spdMain.CellClick | FP00100_Line.cs:2189 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-36109a73 | this.spdMain.CellClick | FP00100_Line.cs:2195 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-82f53fae | this.spdMain.CellClick | FP00100_Line.cs:2201 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-921f5fce | this.spdMain.CellClick | FP00100_Line.cs:2202 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-221e0a53 | this.spdMain.CellClick | FP00100_Line.cs:2205 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc[DefColumns.OPERATION_ID] | cRow[DefColumns.OPERATION_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-caf018aa | this.spdMain.CellClick | FP00100_Line.cs:2206 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc["INSTANCE_ID"] | instance | 행/컬럼 값 대입 |  |  |  |
| AC-274dbcb6 | this.spdMain.CellClick | FP00100_Line.cs:2207 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_setup_group", loc.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dedcaa4d | this.spdMain.CellClick | FP00100_Line.cs:2210 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row["LINE_SETUP_GROUP_ID"].SafeString(), row["LINE_SETUP_GROUP_ID"].SafeString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f73e6cd | this.spdMain.CellClick | FP00100_Line.cs:2214 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-efcbc954 | this.spdMain.CellClick | FP00100_Line.cs:2219 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cb06c3b | this.spdMain.CellClick | FP00100_Line.cs:2220 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fac99eb | this.spdMain.CellClick | FP00100_Line.cs:2224 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c5d8126 | this.spdMain.CellClick | FP00100_Line.cs:2224 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-92d3ff10 | this.spdMain.CellClick | FP00100_Line.cs:2225 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-18cb96dd | this.spdMain.CellClick | FP00100_Line.cs:2225 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-15f4d901 | this.spdMain.CellClick | FP00100_Line.cs:2225 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-db4ed69a | this.spdMain.CellClick | FP00100_Line.cs:2230 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-10c47f15 | this.spdMain.CellClick | FP00100_Line.cs:2234 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b3a6d460 | this.spdMain.CellClick | FP00100_Line.cs:2262 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | row.Field | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-12be9e49 | this.spdMain.CellClick | FP00100_Line.cs:2268 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-707cfc12 | this.spdMain.CellClick | FP00100_Line.cs:2269 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0dec92b | this.spdMain.CellClick | FP00100_Line.cs:2272 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc[DefColumns.OPERATION_ID] | cRow[DefColumns.OPERATION_ID].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-18f1df86 | this.spdMain.CellClick | FP00100_Line.cs:2273 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | loc["INSTANCE_ID"] | instance | 행/컬럼 값 대입 |  |  |  |
| AC-b5728ebd | this.spdMain.CellClick | FP00100_Line.cs:2274 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_setup_group", loc.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2c285926 | this.spdMain.CellClick | FP00100_Line.cs:2277 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row["LINE_SETUP_GROUP_ID"].SafeString(), row["LINE_SETUP_GROUP_ID"].SafeString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-af1b42c3 | this.spdMain.CellClick | FP00100_Line.cs:2281 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d6d4287a | this.spdMain.CellClick | FP00100_Line.cs:2291 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-376de84e | this.spdMain.CellClick | FP00100_Line.cs:2292 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-357e073f | this.spdMain.CellClick | FP00100_Line.cs:2296 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d0349ee | this.spdMain.CellClick | FP00100_Line.cs:2296 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-38171e08 | this.spdMain.CellClick | FP00100_Line.cs:2297 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2bfa2644 | this.spdMain.CellClick | FP00100_Line.cs:2297 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a855171 | this.spdMain.CellClick | FP00100_Line.cs:2297 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8c61dbc | this.spdMain.CellClick | FP00100_Line.cs:2302 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-752b71f8 | this.spdMain.CellClick | FP00100_Line.cs:2306 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c117c533 | this.spdMain.CellClick | FP00100_Line.cs:2319 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb20d1a8 | this.spdMain.CellClick | FP00100_Line.cs:2320 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ea77a20 | this.spdMain.CellClick | FP00100_Line.cs:2324 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-986093e0 | this.spdMain.CellClick | FP00100_Line.cs:2324 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-405df9ca | this.spdMain.CellClick | FP00100_Line.cs:2325 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee89faa5 | this.spdMain.CellClick | FP00100_Line.cs:2325 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-69da7cb2 | this.spdMain.CellClick | FP00100_Line.cs:2330 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9ee1185 | this.spdMain.CellClick | FP00100_Line.cs:2333 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_MODEL_TYPE), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2103f12d | this.spdMain.CellClick | FP00100_Line.cs:2345 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-406331eb | this.spdMain.CellClick | FP00100_Line.cs:2346 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32be39a8 | this.spdMain.CellClick | FP00100_Line.cs:2350 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-32797ceb | this.spdMain.CellClick | FP00100_Line.cs:2350 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-70698138 | this.spdMain.CellClick | FP00100_Line.cs:2351 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b29ef939 | this.spdMain.CellClick | FP00100_Line.cs:2351 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d5e093f | this.spdMain.CellClick | FP00100_Line.cs:2356 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-7547f389 | this.spdMain.CellClick | FP00100_Line.cs:2360 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ATTRIBUTE1), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-22b466e9 | this.spdMain.CellClick | FP00100_Line.cs:2371 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d363eda | this.spdMain.CellClick | FP00100_Line.cs:2372 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-672986ca | this.spdMain.CellClick | FP00100_Line.cs:2375 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-77481241 | this.spdMain.CellClick | FP00100_Line.cs:2375 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4fbced8f | this.spdMain.CellClick | FP00100_Line.cs:2376 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ef0ab54 | this.spdMain.CellClick | FP00100_Line.cs:2376 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2add8aca | this.spdMain.CellClick | FP00100_Line.cs:2381 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-44991e91 | this.spdMain.CellClick | FP00100_Line.cs:2384 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_LOCATION), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d9ae8c4b | this.spdMain.CellClick | FP00100_Line.cs:2396 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e770218 | this.spdMain.CellClick | FP00100_Line.cs:2397 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b68d8c1c | this.spdMain.CellClick | FP00100_Line.cs:2400 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-40eddb29 | this.spdMain.CellClick | FP00100_Line.cs:2401 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd92f520 | this.spdMain.CellClick | FP00100_Line.cs:2402 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8026fce6 | this.spdMain.CellClick | FP00100_Line.cs:2403 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b3f3399 | this.spdMain.CellClick | FP00100_Line.cs:2404 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dRow.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-da07f244 | this.spdMain.CellClick | FP00100_Line.cs:2409 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-37dfcecd | this.spdMain.CellClick | FP00100_Line.cs:2412 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PSEUDO_FACTORY_ID), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f3a1b340 | this.spdMain.CellClick | FP00100_Line.cs:2420 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | FLAG | dtLinkLineId | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00100_find_link_line_id", sPlant, sOpe… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-b8907c0f | this.spdMain.CellClick | FP00100_Line.cs:2420 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00100_find_link_line_id", sPlant, sOperation) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3086489 | this.spdMain.CellClick | FP00100_Line.cs:2424 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_SET | dtLinkLineId.Rows[i]["NAME"] | dtLinkLineId.Rows[i]["CODE"] | 그리드 속성/값 설정 |  |  |  |
| AC-71202503 | this.spdMain.CellClick | FP00100_Line.cs:2427 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINK_LINE_ID), dtLinkLineId) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-40f5784c | this.spdMain.CellClick | FP00100_Line.cs:2434 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_Line.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecc3ff07 | spdMain.CellDoubleClick | FP00100_Line.cs:434 | if (!ableDoubleClick) ▸ if (!siMain.ActiveSheet.Columns[e.Column].Locked) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef74a769 | spdMain.CellDoubleClick | FP00100_Line.cs:477 | if (!ableDoubleClick) | FLAG | ableDoubleClick | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dc4eb49b | spdMain.CellDoubleClick | FP00100_Line.cs:478 | if (!ableDoubleClick) | FLAG | _ReFind_Sub_Click | true | 화면 필드/플래그 변경 |  |  |  |

## FP00100_Line.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ebae1e1 | this.spdMain.ClipboardPasted | FP00100_Line.cs:2447 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ab349d8 | this.spdMain.ClipboardPasted | FP00100_Line.cs:2456 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.CellRange.Co… | DATA_OP | dtOperationByBuilding.Select | ("DIVISION_ID = '" + sDivision + "' AND CODE = '" + sScmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-899e0ac9 | this.spdMain.ClipboardPasted | FP00100_Line.cs:2460 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.CellRange.Co… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), drArr[DefColumns.OPERATI… | 그리드 값 설정 |  |  |  |
| AC-844f1ffe | this.spdMain.ClipboardPasted | FP00100_Line.cs:2466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.CellRange.Co… | GRID_SET | siMain.SetValue | (e.CellRange.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), "") | 그리드 값 설정 |  |  |  |

## FP00100_Line.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c28f2a08 | this.spdSub.CellDoubleClick | FP00100_Line.cs:2594 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fa5699c | .ctor | FP00100_LineImportPopup.cs:114 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-31e6194f | .ctor | FP00100_LineImportPopup.cs:115 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-c882e7ec | .ctor | FP00100_LineImportPopup.cs:116 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-3d62028c | .ctor | FP00100_LineImportPopup.cs:117 |  | FLAG | this.sParamsFilter | pParamsFilter | 화면 필드/플래그 변경 |  |  |  |
| AC-7f119c45 | .ctor | FP00100_LineImportPopup.cs:118 |  | FLAG | this.sDbParamsList | pDbParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-17da08b3 | .ctor | FP00100_LineImportPopup.cs:124 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-358ac4bc | .ctor | FP00100_LineImportPopup.cs:125 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-864b750a | .ctor | FP00100_LineImportPopup.cs:130 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25db6d1e | .ctor | FP00100_LineImportPopup.cs:131 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-86d68308 | .ctor | FP00100_LineImportPopup.cs:138 |  | FLAG | iDbParmsCount | arrDbList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-398d7dcb | .ctor | FP00100_LineImportPopup.cs:140 |  | UI_PROP | structParam._sParamFilter | new string[iDbParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-20b29d1f | .ctor | FP00100_LineImportPopup.cs:141 |  | UI_PROP | structParam._sDbParamsList | new string[iDbParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-709ae023 | .ctor | FP00100_LineImportPopup.cs:145 | for (i < iDbParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrFilter[i] | 행/컬럼 값 대입 |  |  |  |
| AC-f67067cd | .ctor | FP00100_LineImportPopup.cs:146 | for (i < iDbParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrDbList[i] | 행/컬럼 값 대입 |  |  |  |
| AC-90c11943 | .ctor | FP00100_LineImportPopup.cs:149 |  | UI_PROP | SpdSheet.shtComExcel | this.sSheetName | 속성 shtComExcel 설정 |  |  |  |

## FP00100_LineImportPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c27dccb | this.btnClose.Click | FP00100_LineImportPopup.cs:1034 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00100_LineImportPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38eedee3 | this.btnExport.Click | FP00100_LineImportPopup.cs:899 |  | FOCUS | siComExcel.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-f7ded7a3 | this.btnExport.Click | FP00100_LineImportPopup.cs:900 |  | CALL_BASE | OnClickExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00100_LineImportPopup.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3cce9d8 | this.btnImport.Click | FP00100_LineImportPopup.cs:955 | try | CALL_EXT | siComExcel.GetSpdTitle | ("FP00100", UserInfoContext.Current.UserId, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffbec03c | this.btnImport.Click | FP00100_LineImportPopup.cs:958 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-27231fc5 | this.btnImport.Click | FP00100_LineImportPopup.cs:960 | try | UI_PROP | opd.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-90a7efa1 | this.btnImport.Click | FP00100_LineImportPopup.cs:962 | try | UI_PROP | opd.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-149381a5 | this.btnImport.Click | FP00100_LineImportPopup.cs:963 | try | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-95df783f | this.btnImport.Click | FP00100_LineImportPopup.cs:965 | try | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d3f140ef | this.btnImport.Click | FP00100_LineImportPopup.cs:968 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iColCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5bfd3f6c | this.btnImport.Click | FP00100_LineImportPopup.cs:974 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.RowCount > 0) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f0e7d7e | this.btnImport.Click | FP00100_LineImportPopup.cs:974 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.RowCount > 0) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3ce1b72f | this.btnImport.Click | FP00100_LineImportPopup.cs:978 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f062c49d | this.btnImport.Click | FP00100_LineImportPopup.cs:979 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca43c6ef | this.btnImport.Click | FP00100_LineImportPopup.cs:983 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-900746e8 | this.btnImport.Click | FP00100_LineImportPopup.cs:984 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dtExcel.AsEnumerable().CopyToDataTable | (dtData, LoadOption.Upsert) | 데이터 객체 조작/조회 |  |  |  |
| AC-20b92340 | this.btnImport.Click | FP00100_LineImportPopup.cs:986 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | LIST_BIND | spdComExcel.DataSource | dtData | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-5e8bc7e8 | this.btnImport.Click | FP00100_LineImportPopup.cs:989 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-956a994b | this.btnImport.Click | FP00100_LineImportPopup.cs:1003 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f3dc2cd | this.btnImport.Click | FP00100_LineImportPopup.cs:1003 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ced2c9c | this.btnImport.Click | FP00100_LineImportPopup.cs:1018 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ else of (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4defca66 | this.btnImport.Click | FP00100_LineImportPopup.cs:1028 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00035") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00100_LineImportPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f56e867 | this.btnSave.Click | FP00100_LineImportPopup.cs:921 | if (spdComExcel.ActiveSheet.RowCount > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { "Check Validation Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b2d8fa4 | this.btnSave.Click | FP00100_LineImportPopup.cs:922 | if (spdComExcel.ActiveSheet.RowCount > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08913875 | this.btnSave.Click | FP00100_LineImportPopup.cs:926 | if (spdComExcel.ActiveSheet.RowCount > 0) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3817b4ba | this.btnSave.Click | FP00100_LineImportPopup.cs:926 | if (spdComExcel.ActiveSheet.RowCount > 0) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-94a00e72 | this.btnSave.Click | FP00100_LineImportPopup.cs:930 | else of (spdComExcel.ActiveSheet.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69b1b5af | this.btnSave.Click | FP00100_LineImportPopup.cs:931 | else of (spdComExcel.ActiveSheet.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74df4ab8 | this.btnSave.Click | FP00100_LineImportPopup.cs:940 | else of (dtExcel != null && dtExcel.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00100_LineImportPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf5b1672 | this.btnSql.Click | FP00100_LineImportPopup.cs:1040 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2cc06f8b | this.btnSql.Click | FP00100_LineImportPopup.cs:1041 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d3dfb90 | this.btnSql.Click | FP00100_LineImportPopup.cs:1043 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00100_LINE_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e506d53 | this.btnSql.Click | FP00100_LineImportPopup.cs:1044 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00100_LINE_SAVE_IMPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-babd88c2 | this.btnSql.Click | FP00100_LineImportPopup.cs:1045 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00100_LINE_SELECT_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-298573c8 | this.btnSql.Click | FP00100_LineImportPopup.cs:1046 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00100_LINE_SAVE_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-5454e450 | this.btnSql.Click | FP00100_LineImportPopup.cs:1047 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00100_LineImportPopup.CheckNullSpreadValidation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72613b02 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1146 | try ▸ for (iRow <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siComExcel.ActiveSheet.Cells[iRow, siComExcel.GetColumnIndex(DefColumns.MESSAGE_ID)].Text | actionText + " Not Null" | 그리드 속성/값 설정 |  |  |  |
| AC-83ca0fec | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1147 | try ▸ for (iRow <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siComExcel.ActiveSheet.Cells[iRow, siComExcel.GetColumnIndex(DefColumns.VALID_YN)].Text | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-1645217a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1148 | try ▸ for (iRow <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siComExcel.ActiveSheet.Cells[iRow, 0, iRow, siComExcel.GetColumnIndex(DefColumns.EQUIPMENT… | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-5a5c6c12 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1153 | try ▸ for (iRow <= siComExcel.GetMaxRowIndex()) ▸ else of (!string.IsNullOrEmpty(actionText.Trim())) | GRID_SET | siComExcel.ActiveSheet.Cells[iRow, siComExcel.GetColumnIndex(DefColumns.VALID_YN)].Text | "Y" | 그리드 속성/값 설정 |  |  |  |
| AC-6bd04267 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1158 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-65c0e85c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1160 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.CheckValidationByDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0bc5a1b | (진입점 미연결) | FP00100_LineImportPopup.cs:1083 | try ▸ if (ds.Tables[0].Rows.Count > 0) | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |
| AC-dcdf6ac9 | (진입점 미연결) | FP00100_LineImportPopup.cs:1087 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2b8649df | (진입점 미연결) | FP00100_LineImportPopup.cs:1092 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02be6e2b | this.Load | FP00100_LineImportPopup.cs:204 |  | GRID_INIT | this.AddSheet | (spdComExcel, SpdSheet.shtComExcel, SpdSheet.shtComExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d644cc3f | this.Load | FP00100_LineImportPopup.cs:205 |  | FLAG | siComExcel | GetSheetInfo(spdComExcel.Name, spdComExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e372cb9 | this.Load | FP00100_LineImportPopup.cs:207 |  | GRID_INIT | siComExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00100_LineImportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ea5df76 | this.Load | FP00100_LineImportPopup.cs:197 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00100_LineImportPopup.Delete_Data_Buffer

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ else of (programID == "PR_UI_FP00100_LINE_SAVE_IMPORT") ▸ if (programID == "PR_UI_FP00100_LINE_SAVE_BUFFER")] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa0f2de4 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:834 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-0a6972f7 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:838 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0b484770 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:840 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-4a32fa6a | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:841 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-33d750ce | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:842 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b80bda76 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:843 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-03e60551 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:844 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c92f3b9d | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:845 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e87f8b69 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:846 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3005a819 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:847 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a639b3e4 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:848 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f31f1a4 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:849 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6839274b | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:850 | try | DATA_OP | req.Parameters["p_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e2040d5d | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:851 | try | DATA_OP | req.Parameters["p_line_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-915a16f7 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:852 | try | DATA_OP | req.Parameters["p_line_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b090eddc | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:853 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a76adc39 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:854 | try | DATA_OP | req.Parameters["p_line_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2328c5a0 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:855 | try | DATA_OP | req.Parameters["p_line_type_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb55cdeb | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:856 | try | DATA_OP | req.Parameters["p_model_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68053af9 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:857 | try | DATA_OP | req.Parameters["p_line_attribute1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f3b39f0 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:858 | try | DATA_OP | req.Parameters["p_line_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bdc31547 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:859 | try | DATA_OP | req.Parameters["p_active_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-db70327c | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:860 | try | DATA_OP | req.Parameters["p_scp_line_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f88919b8 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:861 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d80f6803 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:862 | try | DATA_OP | req.Parameters["p_prod_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c776d48f | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:863 | try | DATA_OP | req.Parameters["p_equipment_count"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97482960 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:865 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c738677 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:880 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f8f64097 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:883 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-94952dd4 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:887 | catch ((Exception ex)) | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f88a6ec9 | Dispose | FP00100_LineImportPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00100_LineImportPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e7dfb08 | EditButton | FP00100_LineImportPopup.cs:278 | if (spdComExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6be657eb | EditButton | FP00100_LineImportPopup.cs:279 | if (spdComExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d1d3f0 | ExcelButton | FP00100_LineImportPopup.cs:298 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00100_LineImportPopup.Find_Data

진입점: this.Load / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / FindButton / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a1436eb | this.Load 외 4 | FP00100_LineImportPopup.cs:309 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-addc5af8 | this.Load 외 4 | FP00100_LineImportPopup.cs:314 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b5e22a6d | this.Load 외 4 | FP00100_LineImportPopup.cs:317 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-782b3596 | this.Load 외 4 | FP00100_LineImportPopup.cs:317 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-149c2834 | this.Load 외 4 | FP00100_LineImportPopup.cs:323 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c3446163 | this.Load 외 4 | FP00100_LineImportPopup.cs:326 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e014c11 | this.Load 외 4 | FP00100_LineImportPopup.cs:337 | try | GRID_BIND | siComExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4a079ef0 | this.Load 외 4 | FP00100_LineImportPopup.cs:339 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcb86ca8 | this.Load 외 4 | FP00100_LineImportPopup.cs:342 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ca32ce9c | this.Load 외 4 | FP00100_LineImportPopup.cs:345 | try | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a29e2d4d | this.Load 외 4 | FP00100_LineImportPopup.cs:348 | try | GRID_INIT | siComExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-da8c8f09 | this.Load 외 4 | FP00100_LineImportPopup.cs:359 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-253db9d2 | this.Load 외 4 | FP00100_LineImportPopup.cs:364 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00100_LineImportPopup.Find_Data_Import

진입점: this.Load [try] / popSql.OnSql [if (programID == "PR_UI_FP00100_LINE_SELECT")] / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnFind.Click [try] / FindButton [try] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49dcfbcd | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:373 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d823bc67 | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:377 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-23febeee | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:379 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-07dbdc2e | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:380 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-a0ce6782 | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:381 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4f1cfcfc | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:382 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9238cab9 | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:386 | try ▸ for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-dcd6ba39 | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:390 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd030fa4 | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:394 | try | RETURN | return dsv; |  | 처리 중단/반환 |  |  |  |
| AC-fad36eb6 | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:396 | catch ((Exception ex)) | RETURN | return dsv; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.Find_Data_Validation

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ if (programID == "PR_UI_FP00100_LINE_SELECT_VALID")] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b995e942 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:404 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-65554977 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:411 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-9ecaf446 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:413 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-6c98f533 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:414 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID" | 행/컬럼 값 대입 |  |  |  |
| AC-0afeca09 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:415 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ae140fca | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:416 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d0f59591 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:420 | try ▸ for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ce2d242a | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:424 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aadfc1de | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:429 | try | RETURN | return dsv; |  | 처리 중단/반환 |  |  |  |
| AC-33328567 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:433 | catch ((Exception ex)) | RETURN | return dsv; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.Find_Save_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6afbd85e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:442 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dcab225e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:447 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ba0b5a7 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:450 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e401ec7a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:450 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d435a1f0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:456 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a3aae5e0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:459 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2ef728d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:475 | try | GRID_BIND | siComExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-200b6d21 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:481 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3e3e052 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:484 | try | UI_MISC | SetSearchCount | (dsv) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6874bfb8 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:495 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-f583f2aa | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:500 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb584fe5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:504 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00100_LineImportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8aa7f367 | this.Load | FP00100_LineImportPopup.cs:158 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b6984f1f | this.Load | FP00100_LineImportPopup.cs:160 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3d022921 | this.Load | FP00100_LineImportPopup.cs:171 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |

## FP00100_LineImportPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a97e20de | this.Load | FP00100_LineImportPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-46a849bb | this.Load | FP00100_LineImportPopup.cs:182 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtComExcel) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fbe6839 | this.Load | FP00100_LineImportPopup.cs:188 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-5abd23a1 | this.Load | FP00100_LineImportPopup.cs:189 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cfc53904 | this.Load | FP00100_LineImportPopup.cs:190 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00100_LineImportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2382296f | this.Load | FP00100_LineImportPopup.cs:220 | try | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3fa70c39 | this.Load | FP00100_LineImportPopup.cs:221 | try | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-caef44b4 | this.Load | FP00100_LineImportPopup.cs:226 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_LineImportPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f1d957d | popSql.OnSql | FP00100_LineImportPopup.cs:1192 | if (programID == "PR_UI_FP00100_LINE_SELECT") | RETURN | return Find_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-1536edb5 | popSql.OnSql | FP00100_LineImportPopup.cs:1196 | else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ if (programID == "PR_UI_FP00100_LINE_SELECT_VALID") | RETURN | return Find_Data_Validation("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-e19d94a3 | popSql.OnSql | FP00100_LineImportPopup.cs:1200 | else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ if (programID == "PR_UI_FP00… | RETURN | return Save_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-2ed33d48 | popSql.OnSql | FP00100_LineImportPopup.cs:1208 | else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ else of (programID == "PR_UI… | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4a7f791f | popSql.OnSql | FP00100_LineImportPopup.cs:1208 | else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ else of (programID == "PR_UI… | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2bd0728a | popSql.OnSql | FP00100_LineImportPopup.cs:1212 | else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ else of (programID == "PR_UI… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-22f7a8ee | popSql.OnSql | FP00100_LineImportPopup.cs:1216 | else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ else of (programID == "PR_UI… | RETURN | return Save_Data_Buffer(dtExcel, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-faa45ad7 | popSql.OnSql | FP00100_LineImportPopup.cs:1219 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.Save_Data

진입점: this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0)] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afab5023 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:515 | if (siComExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1d75d9d | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:517 | if (siComExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-027ef02d | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:522 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ccd3f0a | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:523 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-551526b4 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:526 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e21bb07f | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:535 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-31c9a300 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:542 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsv.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-076864a5 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:552 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ else of (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-7211ece8 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:558 | try ▸ else of (siComExcel.SheetName == SpdSheet.shtComExcel) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Check Sheet Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06bb0a15 | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:561 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b9131dee | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:565 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0c16839e | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:566 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-58da674b | this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Coun… 외 1 | FP00100_LineImportPopup.cs:570 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00100_LineImportPopup.Save_Data_Buffer

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ else of (programID == "PR_UI_FP00100_LINE_SAVE_IMPORT") ▸ if (programID == "PR_UI_FP00100_LINE_SAVE_BUFFER")] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-614481b2 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:709 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-53dd646e | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:774 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-23e9fc44 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:779 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8b479953 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:781 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-5c35ebf9 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:782 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ece760a7 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:783 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-c9903aa3 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:784 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-39640f72 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:785 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-330dfac5 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:786 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-37869329 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:787 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-1e050e46 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:788 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-44a236cb | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:789 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-bc7d8df9 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:790 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-d996f873 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:791 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c215a710 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:792 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-d9cdcb40 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:793 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_setup_group_id"] | p_line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-36551a7b | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:794 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-d6f2a02e | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:795 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-d46bacb0 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:796 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type_name"] | p_line_type_name | 행/컬럼 값 대입 |  |  |  |
| AC-85861dfe | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:797 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_type"] | p_model_type | 행/컬럼 값 대입 |  |  |  |
| AC-4a132aa6 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:798 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_attribute1"] | p_line_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-6767b122 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:799 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_location"] | p_line_location | 행/컬럼 값 대입 |  |  |  |
| AC-68f2817a | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:800 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cc46b462 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:801 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-69a09c65 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:802 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_line_id"] | p_scp_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-08d63fe1 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:803 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_version_type"] | p_prod_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-641ede02 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:804 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_count"] | p_equipment_count | 행/컬럼 값 대입 |  |  |  |
| AC-936656cf | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:806 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-847bf597 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:809 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d362cb69 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:815 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba32ebe4 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:816 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-dabcaaae | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:821 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4c6b0194 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 1 | FP00100_LineImportPopup.cs:822 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.Save_Data_Import

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELECT") ▸ else of (programID == "PR_UI_FP00100_LINE_SELECT_VALID") ▸ if (programID == "PR_UI_FP00100_LINE_SAVE_IMPORT")] / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7edd4431 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:616 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| string.IsNullOrEmpty(sValidYN)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00041", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d021b28 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:617 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| string.IsNullOrEmpty(sValidYN)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-ac5d737f | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:621 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { "Check Validation Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cabd7b01 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:622 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N")) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-6383e304 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:654 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-805bdfa6 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:658 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2eee813f | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:660 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-06f7f1d6 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:661 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-ac7cdb4f | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:662 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-bf742a55 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:663 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf8ca48e | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:664 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-5b6ab842 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:665 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c968e0e3 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:666 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a16074fa | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:667 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9431bc03 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:668 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-546c6291 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:669 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-cef55f8d | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:670 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-d27397db | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:671 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-219e2bfd | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:672 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_setup_group_id"] | p_line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-b8d54226 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:673 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-dfec942e | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:674 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type"] | p_line_type | 행/컬럼 값 대입 |  |  |  |
| AC-ba06265c | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:675 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_type_name"] | p_line_type_name | 행/컬럼 값 대입 |  |  |  |
| AC-81d71b57 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:676 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_model_type"] | p_model_type | 행/컬럼 값 대입 |  |  |  |
| AC-e1aa6eb2 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:677 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_attribute1"] | p_line_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-c55f7d2e | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:678 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_location"] | p_line_location | 행/컬럼 값 대입 |  |  |  |
| AC-d4ed557c | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:679 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-4d1f7307 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:680 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-754d4e58 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:681 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_line_id"] | p_scp_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-2946a9b8 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:682 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_prod_version_type"] | p_prod_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-f1144321 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:683 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_equipment_count"] | p_equipment_count | 행/컬럼 값 대입 |  |  |  |
| AC-6e871625 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:685 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ad7e0c57 | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:691 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Check Sheet Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2092c00d | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:694 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d0498efd | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:698 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f69dcc8b | popSql.OnSql [else of (programID == "PR_UI_FP00100_LINE_SELE… 외 2 | FP00100_LineImportPopup.cs:699 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aab8cd57 | SaveButton | FP00100_LineImportPopup.cs:286 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.SetSheetHeadColor

진입점: this.Load [try] / this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnSave.Click [if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnFind.Click [try] / FindButton [try] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b026f70 | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:1235 | try ▸ for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siComExcel.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-3c79d15c | this.Load [try] 외 5 | FP00100_LineImportPopup.cs:1243 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00100_LineImportPopup.SetSheetHeaderWidth

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5813732d | (진입점 미연결) | FP00100_LineImportPopup.cs:1105 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siComExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4db20580 | (진입점 미연결) | FP00100_LineImportPopup.cs:1106 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siComExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |

## FP00100_LineImportPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29993557 | this.Load [try] | FP00100_LineImportPopup.cs:234 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6cdf5a91 | this.Load [try] | FP00100_LineImportPopup.cs:235 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-584261eb | this.Load [try] | FP00100_LineImportPopup.cs:239 |  | GRID_INIT | siComExcel.SetSheetHeaderColumn_FP | (siComExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-8e1ad4a8 | this.Load [try] | FP00100_LineImportPopup.cs:240 |  | GRID_INIT | siComExcel.Freeze | (0, 7) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f5afe2c6 | this.Load [try] | FP00100_LineImportPopup.cs:242 |  | GRID_SET | siComExcel.ActiveSheet.Columns[siComExcel.GetColumnIndex(DefColumns.EQUIPMENT_COUNT)].Visi… | false | 그리드 속성/값 설정 |  |  |  |
| AC-55b3239f | this.Load [try] | FP00100_LineImportPopup.cs:243 |  | GRID_SET | siComExcel.ActiveSheet.Columns[siComExcel.GetColumnIndex(DefColumns.VALID_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00100_LineImportPopup.SetValidationResultSheetColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81419b97 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1177 | try ▸ for (iRow <= siComExcel.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(action) \|\| action.Equals("N")) | GRID_SET | siComExcel.ActiveSheet.Cells[iRow, 0, iRow, siComExcel.GetColumnIndex(DefColumns.EQUIPMENT… | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-d95faa51 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1182 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-ed7408b7 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00100_LineImportPopup.cs:1184 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00100_LineImportPopup.spdComExce_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efd37211 | (진입점 미연결) | FP00100_LineImportPopup.cs:1055 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

