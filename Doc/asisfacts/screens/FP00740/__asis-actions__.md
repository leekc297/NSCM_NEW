# AS-IS 액션 대조표 — FP00740

> 원천: `Doc/asisfacts/screens/FP00740/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 203행 · 메서드 37 · 종류 FLAG 38 · RETURN 30 · DATA_OP 20 · CALL_EXT 13 · UI_PROP 12 · GRID_SET 12 · LIST_REBIND 11 · COMBO_DATA 11 · GRID_INIT 10 · MESSAGE 9 · GRID_STYLE 9 · UI_MISC 8 · POPUP 4 · GRID_LOCK 3 · ENDPOINT 3 · THROW 3 · VALIDATE 2 · STATE 2 · STATE_RESET 1 · EXCEL 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 13


## FP00740_Theory_Stock.btnAdd_Click

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3ce8ea8 | InsertButton | FP00740_Theory_Stock.cs:644 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a7f2e32 | InsertButton | FP00740_Theory_Stock.cs:651 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-035e6f39 | InsertButton | FP00740_Theory_Stock.cs:652 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00740_Theory_Stock.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dc2f7ab | this.btnSql.Click | FP00740_Theory_Stock.cs:709 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e23c0973 | this.btnSql.Click | FP00740_Theory_Stock.cs:710 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-287e75a7 | this.btnSql.Click | FP00740_Theory_Stock.cs:712 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00740_Theory_Stock") | 데이터 객체 조작/조회 |  |  |  |
| AC-9731aaaf | this.btnSql.Click | FP00740_Theory_Stock.cs:714 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00740_Theory_Stock.CboFactory_SelectedIndexChanged

진입점: this.Load [try] / cboFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b2465c5 | this.Load [try] 외 1 | FP00740_Theory_Stock.cs:739 |  | UI_PROP | cboLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2c3c3453 | this.Load [try] 외 1 | FP00740_Theory_Stock.cs:741 |  | UI_PROP | cboLine.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00740_Theory_Stock.ClbInstance_SelectedIndexChanged

진입점: this.Load [try] / clbInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06871687 | this.Load [try] 외 1 | FP00740_Theory_Stock.cs:725 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-443b7082 | this.Load [try] 외 1 | FP00740_Theory_Stock.cs:727 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00740_Theory_Stock.ClbPlant_SelectedIndexChanged

진입점: this.Load [try] / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e64dc7c | this.Load [try] 외 1 | FP00740_Theory_Stock.cs:732 |  | UI_PROP | cboFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-48372ab6 | this.Load [try] 외 1 | FP00740_Theory_Stock.cs:734 |  | UI_PROP | cboFactory.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00740_Theory_Stock.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2269eb6 | (진입점 미연결) | FP00740_Theory_Stock.cs:218 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-280d37b8 | (진입점 미연결) | FP00740_Theory_Stock.cs:219 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00740_Theory_Stock.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-378dd4f0 | this.Load | FP00740_Theory_Stock.cs:228 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b4ec7c7f | this.Load | FP00740_Theory_Stock.cs:229 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b922fa6 | this.Load | FP00740_Theory_Stock.cs:231 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00740_Theory_Stock.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-171dbeac | this.Load | FP00740_Theory_Stock.cs:184 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f9ffdab7 | this.Load | FP00740_Theory_Stock.cs:186 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-5d2c5c2a | this.Load | FP00740_Theory_Stock.cs:187 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-a2d1666f | this.Load | FP00740_Theory_Stock.cs:188 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00740_Theory_Stock.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-241fec93 | DeleteButton | FP00740_Theory_Stock.cs:378 |  | MESSAGE | MessageBox.Show | ("Delete Button can't use.!") | 메시지 표시 |  |  |  |
| AC-d609bf2b | DeleteButton | FP00740_Theory_Stock.cs:379 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00740_Theory_Stock.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdbfd175 | Dispose | FP00740_Theory_Stock.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00740_Theory_Stock.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6defb0fb | EditButton | FP00740_Theory_Stock.cs:296 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a624651 | EditButton | FP00740_Theory_Stock.cs:298 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7a4260b5 | EditButton | FP00740_Theory_Stock.cs:300 | if (spdMain != null) | CALL_EXT | siMain.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-93ed0f88 | EditButton | FP00740_Theory_Stock.cs:302 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b9c3b348 | EditButton | FP00740_Theory_Stock.cs:306 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) | CALL_EXT | siMain.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e911c26 | EditButton | FP00740_Theory_Stock.cs:315 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain.GetM… | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-aef8274a | EditButton | FP00740_Theory_Stock.cs:319 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain.GetM… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-eb546eb2 | EditButton | FP00740_Theory_Stock.cs:323 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain.GetM… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-89734a33 | EditButton | FP00740_Theory_Stock.cs:331 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain.GetM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), i, siMain.GetColumnIndex(DefColumns.ACT… | 그리드 표시 설정 |  |  |  |
| AC-0a1dc90d | EditButton | FP00740_Theory_Stock.cs:332 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain.GetM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.THEORY_STOCK_QTY), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-915887b9 | EditButton | FP00740_Theory_Stock.cs:336 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain.GetM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), i, siMain.GetColumnIndex(DefColumns.ACT… | 그리드 표시 설정 |  |  |  |
| AC-f60b1884 | EditButton | FP00740_Theory_Stock.cs:337 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain.GetM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.THEORY_STOCK_QTY), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-c1443396 | EditButton | FP00740_Theory_Stock.cs:349 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), i, siMain.GetColumnIndex(DefColumns.ACT… | 그리드 표시 설정 |  |  |  |
| AC-cff2d4bb | EditButton | FP00740_Theory_Stock.cs:350 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.THEORY_STOCK_QTY), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-9f3646bb | EditButton | FP00740_Theory_Stock.cs:355 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), i, siMain.GetColumnIndex(DefColumns.ACT… | 그리드 표시 설정 |  |  |  |
| AC-d1e39794 | EditButton | FP00740_Theory_Stock.cs:356 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ else of (siMain.ActiveSheet.Columns.Get(xCol1).Visible == true) ▸ for (i <= siMain… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.THEORY_STOCK_QTY), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |

## FP00740_Theory_Stock.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25c81e0c | (진입점 미연결) | FP00740_Theory_Stock.cs:808 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9080b359 | (진입점 미연결) | FP00740_Theory_Stock.cs:812 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a730bef | (진입점 미연결) | FP00740_Theory_Stock.cs:820 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-4a14a868 | (진입점 미연결) | FP00740_Theory_Stock.cs:821 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af75a5e2 | (진입점 미연결) | FP00740_Theory_Stock.cs:826 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00740_Theory_Stock.EditByFunc

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc1f74c9 | (진입점 미연결) | FP00740_Theory_Stock.cs:915 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a6b54f4 | (진입점 미연결) | FP00740_Theory_Stock.cs:920 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df70fc2c | (진입점 미연결) | FP00740_Theory_Stock.cs:930 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a6ae87b | (진입점 미연결) | FP00740_Theory_Stock.cs:936 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6c71a6d | (진입점 미연결) | FP00740_Theory_Stock.cs:938 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00740_Theory_Stock.EditCommon

진입점: this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefColumns.THEORY_STOCK_QTY))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a274c54f | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:836 | if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | EditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-82f24134 | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:837 | if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a3e0286 | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:842 | if (new_value >= _MaxBatch) | MESSAGE | MessageBox.Show | ("Batch " + _MaxBatch.ToString() + " Over") | 메시지 표시 |  |  |  |
| AC-73cde210 | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:843 | if (new_value >= _MaxBatch) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | EditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-b0bb081d | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:844 | if (new_value >= _MaxBatch) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1d8d25f | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:847 |  | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | RoundValue(new_value) | 그리드 속성/값 설정 |  |  |  |

## FP00740_Theory_Stock.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ac78e41 | ExcelButton | FP00740_Theory_Stock.cs:635 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00740_Theory_Stock.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94e057df | FindButton 외 1 | FP00740_Theory_Stock.cs:402 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6a0cdede | FindButton 외 1 | FP00740_Theory_Stock.cs:407 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce308751 | FindButton 외 1 | FP00740_Theory_Stock.cs:408 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce5f7b8c | FindButton 외 1 | FP00740_Theory_Stock.cs:411 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f8454da3 | FindButton 외 1 | FP00740_Theory_Stock.cs:414 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa882d07 | FindButton 외 1 | FP00740_Theory_Stock.cs:417 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c35b4450 | FindButton 외 1 | FP00740_Theory_Stock.cs:417 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f2f7149 | FindButton 외 1 | FP00740_Theory_Stock.cs:423 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a397a6aa | FindButton 외 1 | FP00740_Theory_Stock.cs:426 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c31c476c | FindButton 외 1 | FP00740_Theory_Stock.cs:433 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a6397601 | FindButton 외 1 | FP00740_Theory_Stock.cs:434 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Line("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7d28a35 | FindButton 외 1 | FP00740_Theory_Stock.cs:434 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Line("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-260bcab9 | FindButton 외 1 | FP00740_Theory_Stock.cs:444 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-066c4674 | FindButton 외 1 | FP00740_Theory_Stock.cs:446 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0752814b | FindButton 외 1 | FP00740_Theory_Stock.cs:449 | try | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b09ec521 | FindButton 외 1 | FP00740_Theory_Stock.cs:453 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4fd9cb4a | FindButton 외 1 | FP00740_Theory_Stock.cs:461 | try | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-adf637d5 | FindButton 외 1 | FP00740_Theory_Stock.cs:467 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bcbc4e19 | FindButton 외 1 | FP00740_Theory_Stock.cs:468 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-99ab8c1b | FindButton 외 1 | FP00740_Theory_Stock.cs:469 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-465b8ca6 | FindButton 외 1 | FP00740_Theory_Stock.cs:470 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6a829c5f | FindButton 외 1 | FP00740_Theory_Stock.cs:470 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00740_Theory_Stock.Find_Data_Line

진입점: popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ee6731 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:479 | try | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, clbInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-2939f0d7 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:480 | try | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7a56c9d3 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:481 | try | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory, cboFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-bb6750fc | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:482 | try | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, cboLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8bd435b3 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:483 | try | DATA_OP | Filter["ITEM_ID"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8d504414 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:484 | try | DATA_OP | Filter["CHK_LINE_ASSIGN"] | (chk_lineAssign.Checked?"Y":"N") | 행/컬럼 값 대입 |  |  |  |
| AC-ca04df28 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:487 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-87463e03 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:488 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00740_FIND_FP00740", set, pSysType) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3edfad2d | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:490 | try | RETURN | return main; |  | 처리 중단/반환 |  |  |  |
| AC-ef82fae5 | popSql.OnSql [if (programID == "PR_UI_FP00740_Theory_Stock")… 외 2 | FP00740_Theory_Stock.cs:494 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00740_Theory_Stock.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bfc7314 | this.Load | FP00740_Theory_Stock.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00740_Theory_Stock.GetFactory

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36729d19 | this.Load [try] | FP00740_Theory_Stock.cs:1069 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e52f1d1d | this.Load [try] | FP00740_Theory_Stock.cs:1070 |  | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-deda981c | this.Load [try] | FP00740_Theory_Stock.cs:1070 |  | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1dd8ee39 | this.Load [try] | FP00740_Theory_Stock.cs:1071 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00740_Theory_Stock.GetInstance

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b9bcb55 | this.Load [try] | FP00740_Theory_Stock.cs:1056 |  | DATA_OP | Filter["AMEND_INSTANCE"] | "LINE_AMEND_E_PRE" | 행/컬럼 값 대입 |  |  |  |
| AC-e9270e14 | this.Load [try] | FP00740_Theory_Stock.cs:1057 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0c3b66ae | this.Load [try] | FP00740_Theory_Stock.cs:1058 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b8906f5 | this.Load [try] | FP00740_Theory_Stock.cs:1058 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0579008f | this.Load [try] | FP00740_Theory_Stock.cs:1059 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, clbInstance, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00740_Theory_Stock.GetLine

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fdc803c | this.Load [try] | FP00740_Theory_Stock.cs:1075 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-21d9407f | this.Load [try] | FP00740_Theory_Stock.cs:1076 |  | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ceb677b | this.Load [try] | FP00740_Theory_Stock.cs:1076 |  | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b7cc9ba0 | this.Load [try] | FP00740_Theory_Stock.cs:1077 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, cboLine, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00740_Theory_Stock.GetPlant

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-490bfd2d | this.Load [try] | FP00740_Theory_Stock.cs:1063 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ab3c347a | this.Load [try] | FP00740_Theory_Stock.cs:1064 |  | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c615a410 | this.Load [try] | FP00740_Theory_Stock.cs:1064 |  | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-081d9458 | this.Load [try] | FP00740_Theory_Stock.cs:1065 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00740_Theory_Stock.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7145573 | this.Load | FP00740_Theory_Stock.cs:125 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-70f65748 | this.Load | FP00740_Theory_Stock.cs:131 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a8145bdb | this.Load | FP00740_Theory_Stock.cs:132 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fd3cc84c | this.Load | FP00740_Theory_Stock.cs:137 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-6fb61445 | this.Load | FP00740_Theory_Stock.cs:139 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-a1e78ae2 | this.Load | FP00740_Theory_Stock.cs:164 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-38fe3797 | this.Load | FP00740_Theory_Stock.cs:165 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e3949165 | this.Load | FP00740_Theory_Stock.cs:166 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f7a3ea30 | this.Load | FP00740_Theory_Stock.cs:177 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00740_Theory_Stock.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1d5435d | this.Load | FP00740_Theory_Stock.cs:243 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c5c7294 | this.Load | FP00740_Theory_Stock.cs:244 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a619f19d | this.Load | FP00740_Theory_Stock.cs:248 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00740_Theory_Stock.Insert_Row

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06e6d189 | (진입점 미연결) | FP00740_Theory_Stock.cs:504 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d76d3243 | (진입점 미연결) | FP00740_Theory_Stock.cs:515 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP00740_Theory_Stock.RoundValue

진입점: this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefColumns.THEORY_STOCK_QTY))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf26704a | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:892 | if (_RoundPoint < 1 \|\| _RoundPoint > 11) | FLAG | _RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-e74e0901 | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:893 | if (_RoundPoint < 1 \|\| _RoundPoint > 11) | FLAG | _RoundTen | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-e0a4d5d9 | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:897 | try | CALL_EXT | Math.Truncate | ((double)((decimal)ori * (decimal)_RoundTen)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-569e76a2 | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:898 | try | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-7b7617c9 | this.spdMain.Change [if (nCol == siMain.GetColumnIndex(DefCo… 외 1 | FP00740_Theory_Stock.cs:901 |  | RETURN | return ori; |  | 처리 중단/반환 |  |  |  |

## FP00740_Theory_Stock.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-833dd91e | popSql.OnSql | FP00740_Theory_Stock.cs:954 | if (programID == "PR_UI_FP00740_Theory_Stock") | RETURN | return Find_Data_Line("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-460cb0ae | popSql.OnSql | FP00740_Theory_Stock.cs:958 | else of (programID == "PR_UI_FP00740_Theory_Stock") ▸ if (programID == "PR_UI_FP00740_Theory_Stock_SAVE") | RETURN | return Save_Data_Test("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-c9e2003e | popSql.OnSql | FP00740_Theory_Stock.cs:960 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00740_Theory_Stock.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc329798 | SaveButton | FP00740_Theory_Stock.cs:525 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5181dae | SaveButton | FP00740_Theory_Stock.cs:527 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2aadc65 | SaveButton | FP00740_Theory_Stock.cs:532 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd8519df | SaveButton | FP00740_Theory_Stock.cs:533 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54359b27 | SaveButton | FP00740_Theory_Stock.cs:536 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-22a15eb0 | SaveButton | FP00740_Theory_Stock.cs:543 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-825d07cc | SaveButton | FP00740_Theory_Stock.cs:545 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d1e92b33 | SaveButton | FP00740_Theory_Stock.cs:546 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d02e5673 | SaveButton | FP00740_Theory_Stock.cs:561 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(strQty)) | GRID_SET | siMain.SetValue | (iRow, colQty, 0) | 그리드 값 설정 |  |  |  |
| AC-b3f3a736 | SaveButton | FP00740_Theory_Stock.cs:562 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(strAct)) | GRID_SET | siMain.SetValue | (iRow, colAct, "Y") | 그리드 값 설정 |  |  |  |
| AC-1db664fe | SaveButton | FP00740_Theory_Stock.cs:566 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.GetChangeDataSet | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5b101e2 | SaveButton | FP00740_Theory_Stock.cs:573 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in changed.Tables[0].Rows) ▸ if (newVal >= _MaxBatch) | MESSAGE | MessageBox.Show | ("Batch " + _MaxBatch.ToString() + " Over") | 메시지 표시 |  |  |  |
| AC-9b788634 | SaveButton | FP00740_Theory_Stock.cs:574 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in changed.Tables[0].Rows) ▸ if (newVal >= _MaxBatch) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9b71dabe | SaveButton | FP00740_Theory_Stock.cs:575 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ foreach (DataRow row in changed.Tables[0].Rows) ▸ if (newVal >= _MaxBatch) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b615c84 | SaveButton | FP00740_Theory_Stock.cs:581 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-40997922 | SaveButton | FP00740_Theory_Stock.cs:586 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-165bfd06 | SaveButton | FP00740_Theory_Stock.cs:594 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-497672f1 | SaveButton | FP00740_Theory_Stock.cs:598 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a107c149 | SaveButton | FP00740_Theory_Stock.cs:602 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-232ec02b | SaveButton | FP00740_Theory_Stock.cs:603 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24f40d00 | SaveButton | FP00740_Theory_Stock.cs:608 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00740_Theory_Stock.Save_Data_Test

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00740_Theory_Stock") ▸ if (programID == "PR_UI_FP00740_Theory_Stock_SAVE")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1900b6d | popSql.OnSql [else of (programID == "PR_UI_FP00740_Theory_St… 외 1 | FP00740_Theory_Stock.cs:613 |  | CALL_EXT | siMain.GetChangeDataSet | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b5677a9 | popSql.OnSql [else of (programID == "PR_UI_FP00740_Theory_St… 외 1 | FP00740_Theory_Stock.cs:620 | if (changed.Good()) ▸ for (i<=changed.Tables[0].Rows.Count) | CALL_EXT | changed.setColumn | (i, "USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80fb9053 | popSql.OnSql [else of (programID == "PR_UI_FP00740_Theory_St… 외 1 | FP00740_Theory_Stock.cs:623 | if (changed.Good()) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00740_Theory_Stock", "merge_FP00740", changed, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00740] \| FP\Master\FP00… | 엔드포인트 호출 |  |  |  |
| AC-8387c802 | popSql.OnSql [else of (programID == "PR_UI_FP00740_Theory_St… 외 1 | FP00740_Theory_Stock.cs:625 | if (changed.Good()) | DATA_OP | newRes.Tables.Add | (res) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b4c3576 | popSql.OnSql [else of (programID == "PR_UI_FP00740_Theory_St… 외 1 | FP00740_Theory_Stock.cs:626 | if (changed.Good()) | RETURN | return newRes; |  | 처리 중단/반환 |  |  |  |
| AC-716e8769 | popSql.OnSql [else of (programID == "PR_UI_FP00740_Theory_St… 외 1 | FP00740_Theory_Stock.cs:629 | else of (changed.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00740_Theory_Stock.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4a086ae | SaveButton | FP00740_Theory_Stock.cs:385 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00740_Theory_Stock.SetChangeControl

진입점: this.Load [try] / clbInstance.SelectedIndexChanged / clbPlant.SelectedIndexChanged / cboFactory.SelectedIndexChanged / cboLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b91a97f9 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:976 | switch (triggerControl) case "INSTANCE_ID": ▸ if (dtInstance.Good()) ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a9db9ef | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:976 | switch (triggerControl) case "INSTANCE_ID": ▸ if (dtInstance.Good()) ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6c874f97 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:981 | switch (triggerControl) case "INSTANCE_ID": ▸ if (dtInstance.Good()) ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-3f75b4da | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:983 | switch (triggerControl) case "INSTANCE_ID": ▸ if (dtInstance.Good()) ▸ if (dtInstance.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-12ede4a8 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:983 | switch (triggerControl) case "INSTANCE_ID": ▸ if (dtInstance.Good()) ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0ad74c14 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:985 | switch (triggerControl) case "INSTANCE_ID": ▸ if (dtInstance.Good()) ▸ if (dtInstance.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0dc9981f | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:987 | switch (triggerControl) case "INSTANCE_ID": ▸ if (dtInstance.Good()) ▸ if (dtInstance.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if … | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b7022ddf | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:997 | switch (triggerControl) case "PLANT_ID": ▸ if (dtPlant.Good()) ▸ if (!dtPlant.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-08a6d99a | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:997 | switch (triggerControl) case "PLANT_ID": ▸ if (dtPlant.Good()) ▸ if (!dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-13ecc647 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1002 | switch (triggerControl) case "PLANT_ID": ▸ if (dtPlant.Good()) ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | sPlant_id | 행/컬럼 값 대입 |  |  |  |
| AC-e1c3dd02 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1004 | switch (triggerControl) case "PLANT_ID": ▸ if (dtPlant.Good()) ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-a95f0a24 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1004 | switch (triggerControl) case "PLANT_ID": ▸ if (dtPlant.Good()) ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-08aeab20 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1006 | switch (triggerControl) case "PLANT_ID": ▸ if (dtPlant.Good()) ▸ if (dtPlant.Good()) ▸ if ((object)cboFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)cboFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-41e6abd7 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1008 | switch (triggerControl) case "PLANT_ID": ▸ if (dtPlant.Good()) ▸ if (dtPlant.Good()) ▸ else of ((object)cboFactory is UsrCombo) ▸ if ((objec… | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)cboFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fb64338b | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1018 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (!dtFactory.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-310eb726 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1018 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (!dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-08f3d29e | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1023 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | sFactory_id | 행/컬럼 값 대입 |  |  |  |
| AC-48864335 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1024 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (dtFactory.Good()) | DATA_OP | Filter["OPERATION_ID"] | "E1000,E0430" | 행/컬럼 값 대입 |  |  |  |
| AC-352ee495 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1026 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (dtFactory.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-120d6799 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1026 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e68dafe7 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1028 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (dtFactory.Good()) ▸ if ((object)cboLine is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)cboLine as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c2431a2a | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1030 | switch (triggerControl) case "FACTORY_ID": ▸ if (dtFactory.Good()) ▸ if (dtFactory.Good()) ▸ else of ((object)cboLine is UsrCombo) ▸ if ((ob… | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)cboLine as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b8d77d98 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1040 | switch (triggerControl) case "LINE_ID": ▸ if (dtLine.Good()) ▸ if (!dtLine.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f293833 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1040 | switch (triggerControl) case "LINE_ID": ▸ if (dtLine.Good()) ▸ if (!dtLine.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-080a8a32 | this.Load [try] 외 4 | FP00740_Theory_Stock.cs:1045 | switch (triggerControl) case "LINE_ID": ▸ if (dtLine.Good()) ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | sLine_id | 행/컬럼 값 대입 |  |  |  |

## FP00740_Theory_Stock.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d95ddd3f | this.Load [try] | FP00740_Theory_Stock.cs:257 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1b83e91 | this.Load [try] | FP00740_Theory_Stock.cs:258 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-da6b6dd8 | this.Load [try] | FP00740_Theory_Stock.cs:263 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-fe47ee99 | this.Load [try] | FP00740_Theory_Stock.cs:264 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.NICK_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00740_Theory_Stock.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12bd23f5 | this.spdMain.CellClick | FP00740_Theory_Stock.cs:754 | if (siMain.GetMaxRowIndex() < 0) | FLAG | iClickRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-860339c8 | this.spdMain.CellClick | FP00740_Theory_Stock.cs:756 | else of (siMain.GetMaxRowIndex() < 0) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00740_Theory_Stock.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e84369b | this.spdMain.ClipboardPasted | FP00740_Theory_Stock.cs:791 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e414f545 | this.spdMain.ClipboardPasted | FP00740_Theory_Stock.cs:799 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-20149048 | this.spdMain.ClipboardPasted | FP00740_Theory_Stock.cs:800 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7fb2e772 | this.spdMain.ClipboardPasted | FP00740_Theory_Stock.cs:802 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00740_Theory_Stock.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78b676c9 | this.spdMain.ClipboardPasting | FP00740_Theory_Stock.cs:773 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-2eb6211f | this.spdMain.ClipboardPasting | FP00740_Theory_Stock.cs:774 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-a1605146 | this.spdMain.ClipboardPasting | FP00740_Theory_Stock.cs:774 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-89b68e11 | this.spdMain.ClipboardPasting | FP00740_Theory_Stock.cs:778 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-0718d784 | this.spdMain.ClipboardPasting | FP00740_Theory_Stock.cs:778 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5aaade97 | this.spdMain.ClipboardPasting | FP00740_Theory_Stock.cs:782 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6cfca3ef | this.spdMain.ClipboardPasting | FP00740_Theory_Stock.cs:784 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00740_Theory_Stock.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15e937ec | this.spdMain.EditModeOn | FP00740_Theory_Stock.cs:764 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00740_Theory_Stock.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc18bb1d | this.spdMain.KeyDown | FP00740_Theory_Stock.cs:908 | if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af32890b | this.spdMain.KeyDown | FP00740_Theory_Stock.cs:909 | if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

