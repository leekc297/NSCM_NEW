# AS-IS 액션 대조표 — SCP0011

> 원천: `Doc/asisfacts/screens/SCP0011/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 479행 · 메서드 63 · 종류 DATA_OP 160 · RETURN 37 · ENDPOINT 30 · CALL_EXT 28 · GRID_INIT 28 · UI_PROP 27 · GRID_SET 27 · FLAG 25 · UI_MISC 23 · POPUP 17 · MESSAGE 14 · VALUE_SET 11 · LIST_REBIND 9 · GRID_LOCK 8 · VALIDATE 7 · GRID_STYLE 7 · GRID_CLEAR 6 · THROW 4 · COMBO_DATA 4 · GRID_BIND 3 · STATE 2 · VALUE_CLEAR 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 28


## SCP0011_ProductionPlan.btnCal_Click

진입점: this.btnCal.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-370e26bd | this.btnCal.Click | SCP0011_ProductionPlan.cs:3337 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c8505dd | this.btnCal.Click | SCP0011_ProductionPlan.cs:3338 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d6f8a1a | this.btnCal.Click | SCP0011_ProductionPlan.cs:3342 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f77f09b9 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3342 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae7e79b7 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3345 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00206") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c56d988 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3347 | if (MessageHelper.GMessageBox("MSG00206") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40be4260 | this.btnItemId.Click | SCP0011_ProductionPlan.cs:756 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d49577f | this.btnItemId.Click | SCP0011_ProductionPlan.cs:763 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-92e8863b | this.btnItemId.Click | SCP0011_ProductionPlan.cs:765 |  | POPUP | pop.Form_Load | (true, this._division, this._operationGroup, sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-959037e2 | this.btnItemId.Click | SCP0011_ProductionPlan.cs:766 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ab50b51c | this.btnItemId.Click | SCP0011_ProductionPlan.cs:767 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2a8185d4 | this.btnItemId.Click | SCP0011_ProductionPlan.cs:773 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0011_ProductionPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-616eca70 | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:792 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33547e71 | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:793 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdLine") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdfe612a | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:798 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-549dac49 | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:799 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f37bc3d | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:802 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0011", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-6b9e423e | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:803 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bd0caa7d | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:804 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bd43de01 | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:808 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-0fb17d73 | this.btnMeasure.Click | SCP0011_ProductionPlan.cs:818 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0011_ProductionPlan.CalculateSum

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (p_bucket.Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all))] / dsdmLine.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD")] / FindButton [try ▸ if (p_bucket.Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all))] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58fd3a52 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2479 | if (strMeasure == "ONHAND_EOH") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7027a4e4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2487 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d139c8a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2491 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-323f18da | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2536 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-e1cdb2c3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2540 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-96a41dbc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2554 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-c6eb73a1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2558 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-41fcae96 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2567 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a1508a23 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2589 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-b088a2be | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2593 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-33fc8903 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2654 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-f688efdd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2676 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-6f09dea7 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2692 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-400e7097 | this.cboBucketType.SelectedIndexChanged | SCP0011_ProductionPlan.cs:842 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-dc0a4215 | this.cboBucketType.SelectedIndexChanged | SCP0011_ProductionPlan.cs:843 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0011_ProductionPlan.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63efe915 | cboPlanDate.SelectedIndexChanged | SCP0011_ProductionPlan.cs:3103 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0011_ProductionPlan.ClbPlantSite_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged / cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ab1c5bf | this.Load 외 2 | SCP0011_ProductionPlan.cs:3080 | if (siMain != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-6a23b530 | this.Load 외 2 | SCP0011_ProductionPlan.cs:3081 | if (siLine != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |
| AC-5e94363a | this.Load 외 2 | SCP0011_ProductionPlan.cs:3085 | if (!this._isEE) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-7056e6aa | this.Load 외 2 | SCP0011_ProductionPlan.cs:3086 | if (!this._isEE) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a432a8fa | this.Load 외 2 | SCP0011_ProductionPlan.cs:3090 | else of (!this._isEE) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0011_ProductionPlan.ClearAllSheets

진입점: cboPlanDate.SelectedIndexChanged / cboPlanType.SelectedIndexChanged / cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5972442 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0011_ProductionPlan.cs:3096 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-d8517b16 | cboPlanDate.SelectedIndexChanged 외 2 | SCP0011_ProductionPlan.cs:3097 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdLine) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0011_ProductionPlan.ClearEventInvocations

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a4cdc96 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3166 | if (fi == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-080e124e | (진입점 미연결) | SCP0011_ProductionPlan.cs:3167 |  | GRID_SET | fi.SetValue | (obj, null) | 그리드 값 설정 |  |  |  |

## SCP0011_ProductionPlan.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b76c681 | (진입점 미연결) | SCP0011_ProductionPlan.cs:208 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-2d5ce8ef | (진입점 미연결) | SCP0011_ProductionPlan.cs:209 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0011_ProductionPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0281c24e | this.Load | SCP0011_ProductionPlan.cs:259 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bd4d7dd4 | this.Load | SCP0011_ProductionPlan.cs:260 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-00a13489 | this.Load | SCP0011_ProductionPlan.cs:262 |  | GRID_INIT | this.AddSheet | (spdLine, SpdSheet.shtLine, SpdSheet.shtLine, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9658f420 | this.Load | SCP0011_ProductionPlan.cs:263 |  | FLAG | siLine | GetSheetInfo(spdLine.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-6dc851e0 | this.Load | SCP0011_ProductionPlan.cs:266 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0011_ProductionPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af9cb940 | this.Load | SCP0011_ProductionPlan.cs:196 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-302802ec | this.Load | SCP0011_ProductionPlan.cs:197 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-d558efeb | this.Load | SCP0011_ProductionPlan.cs:198 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0011_ProductionPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b7dbc2a | Dispose | SCP0011_ProductionPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0011_ProductionPlan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dea60ed | EditButton | SCP0011_ProductionPlan.cs:638 | if (fps != null) ▸ if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10e6efaa | EditButton | SCP0011_ProductionPlan.cs:639 | if (fps != null) ▸ if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79b6d496 | EditButton | SCP0011_ProductionPlan.cs:647 | if (fps != null) ▸ if (fps.Name == "spdLine") | FLAG | siLine | GetSheetInfo(spdLine.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d391ec2 | EditButton | SCP0011_ProductionPlan.cs:648 | if (fps != null) ▸ if (fps.Name == "spdLine") | GRID_LOCK | siLine.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-dfbaf024 | EditButton | SCP0011_ProductionPlan.cs:652 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c497f6c | EditButton | SCP0011_ProductionPlan.cs:653 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12af0ba4 | EditButton | SCP0011_ProductionPlan.cs:655 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-831b45fb | EditButton | SCP0011_ProductionPlan.cs:658 | if (fps != null) ▸ if (fps.Name == "spdLine") | GRID_LOCK | siLine.LockRange | (0, 0, siLine.ActiveSheet.RowCount - 1, siLine.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ba9b8482 | EditButton | SCP0011_ProductionPlan.cs:661 | if (fps != null) ▸ if (fps.Name == "spdLine") | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e473d080 | EditButton | SCP0011_ProductionPlan.cs:665 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46d14c0b | EditButton | SCP0011_ProductionPlan.cs:704 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumn… | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-07ba7ae0 | EditButton | SCP0011_ProductionPlan.cs:738 | if (fps != null) ▸ if (fps.Name == "spdLine") ▸ for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, siLine.GetColumn… | GRID_LOCK | siLine.LockRange | (nEditableRow, nStartEditIdx, nEditableRow, siLine.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0011_ProductionPlan.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e536cde | ExcelButton | SCP0011_ProductionPlan.cs:866 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-7d3f0673 | ExcelButton | SCP0011_ProductionPlan.cs:867 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-7013fc8e | ExcelButton | SCP0011_ProductionPlan.cs:868 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.ShowZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-54aa0159 | ExcelButton | SCP0011_ProductionPlan.cs:869 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-61aae0af | ExcelButton | SCP0011_ProductionPlan.cs:870 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-089beb00 | ExcelButton | SCP0011_ProductionPlan.cs:871 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-28ed5fd1 | ExcelButton | SCP0011_ProductionPlan.cs:873 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-f1423db7 | ExcelButton | SCP0011_ProductionPlan.cs:874 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-13d0a7c6 | ExcelButton | SCP0011_ProductionPlan.cs:876 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-829893b6 | ExcelButton | SCP0011_ProductionPlan.cs:881 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10ac3f2b | ExcelButton | SCP0011_ProductionPlan.cs:886 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d838903e | ExcelButton | SCP0011_ProductionPlan.cs:890 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0011_ProductionPlan.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fef28446 | FindButton | SCP0011_ProductionPlan.cs:616 |  | FLAG | this.nSelColOfMain | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-5e5cf245 | FindButton | SCP0011_ProductionPlan.cs:617 |  | FLAG | this.nSelRowOfMain | -1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0011_ProductionPlan.FindData_Line

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea30ec92 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1598 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bb696772 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1634 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-669eade8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1635 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c66ab28f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1636 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fe4ca673 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1639 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_LINE") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-b8f408c0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1640 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9e66e7a9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1641 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9f683be | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1642 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-c551515b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1643 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a22da131 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1644 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c526c65e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1645 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-243ede9c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1646 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-af8597ef | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1647 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2f84797c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1648 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-26b6428c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1649 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-77cfa4ab | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1650 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3dba363 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1651 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-a4708bc7 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1652 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6efd4ae | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1653 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-a71fa1a4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1654 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-1414c48c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1655 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eb46af5a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1656 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-32d96c01 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1669 | try | GRID_BIND | siLine.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6b3e960e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1671 | try | GRID_LOCK | siLine.LockColumn | (0, siLine.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-df12131c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1673 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4a12fdd3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1678 | try | GRID_INIT | siLine.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-656246ff | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1689 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") | CALL_EXT | siLine.SetDecimal | (i, nIdxStart, i, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4cac1a91 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1702 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") ▸ for (nCol < siMain.ActiveSheet.ColumnCount) ▸ if (siLine.Ge… | GRID_STYLE | siLine.SetFGColor2 | (i, nCol, i, nCol, ControlColor.MarkedForeColor) | 그리드 표시 설정 |  |  |  |
| AC-450e3530 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1706 | try ▸ for (i < siLine.ActiveSheet.RowCount) ▸ if (mesure == "LINE_TOTAL_LOAD") | UI_MISC | spdLine.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0c4582e5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1730 | try ▸ if (this.nSelRowOfLine >= 0 && isReload) | GRID_STYLE | siLine.ActiveSheet.SetActiveCell | (this.nSelRowOfLine, this.nSelColOfLine) | 그리드 표시 설정 |  |  |  |
| AC-2fd1b731 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1731 | try ▸ if (this.nSelRowOfLine >= 0 && isReload) | CALL_EXT | spdLine.ShowCell | (0, 0, this.nSelRowOfLine, this.nSelColOfLine, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5c625cd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1734 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d9bdc998 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1739 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68daaca5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 4 | SCP0011_ProductionPlan.cs:1744 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0011_ProductionPlan.FindData_Model

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3d8193c | (진입점 미연결) | SCP0011_ProductionPlan.cs:1175 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3ba40ac7 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1179 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-9c3afedc | (진입점 미연결) | SCP0011_ProductionPlan.cs:1179 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3fc7797 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1180 | try | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-81f83814 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1180 | try ▸ if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a63f12fb | (진입점 미연결) | SCP0011_ProductionPlan.cs:1184 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b649e434 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1212 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5eee5eba | (진입점 미연결) | SCP0011_ProductionPlan.cs:1214 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b19825f | (진입점 미연결) | SCP0011_ProductionPlan.cs:1217 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-98c6f119 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1219 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d1581cd2 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1220 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d286048 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1221 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-e49375ad | (진입점 미연결) | SCP0011_ProductionPlan.cs:1222 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d92f2184 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1223 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-26ea1164 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1224 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f1a1babd | (진입점 미연결) | SCP0011_ProductionPlan.cs:1225 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-49f0eb4c | (진입점 미연결) | SCP0011_ProductionPlan.cs:1226 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e16c1897 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1227 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-cc15f136 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1228 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b4785114 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1229 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-a7d798c2 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1230 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-a267458c | (진입점 미연결) | SCP0011_ProductionPlan.cs:1231 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-81672abd | (진입점 미연결) | SCP0011_ProductionPlan.cs:1232 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-105c5cb0 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1233 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4534dc7 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1234 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-111e77a0 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1241 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9494d210 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1243 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-abb1b13d | (진입점 미연결) | SCP0011_ProductionPlan.cs:1244 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-99bd5199 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1254 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af77c01f | (진입점 미연결) | SCP0011_ProductionPlan.cs:1267 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-5bb1efef | (진입점 미연결) | SCP0011_ProductionPlan.cs:1268 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1923d51d | (진입점 미연결) | SCP0011_ProductionPlan.cs:1274 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-06150ae8 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1279 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a3a6f5a | (진입점 미연결) | SCP0011_ProductionPlan.cs:1284 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0011_ProductionPlan.FindData_Model_Parallel

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg)] / FindButton / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fa5cdd2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1293 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-61278a8d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1298 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2c7009f4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1298 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59e1eb5e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1299 | try | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-ca1ad106 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1299 | try ▸ if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1c3831e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1303 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-77238aa3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1337 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | CALL_EXT | DateUtil.MonthDiff | (p_to_yyyymmdd.ToString(), p_from_yyyymmdd.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d422508 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1352 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | CALL_EXT | Parallel.For | (0, (nCnt), (i) => { //for(int i = 0; i < 6; i++) { if (i != nCnt - 1) { string strStartDa… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f41be0d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1375 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54bb9d6b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1378 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-cef7ee5c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1380 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-19a5b4df | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1381 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-19c1f615 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1382 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-035c15e1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1383 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-079e0461 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1384 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-eab731a9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1385 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-843700a2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1386 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | strStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-a4cb0ff0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1387 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | strEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-45f55aeb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1388 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b56d38bd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1389 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-ed75e41d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1390 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-5ec48e13 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1391 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-c7b0228b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1392 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-783932c0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1393 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-93954130 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1394 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-8c2b7e70 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1395 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-7f0b2343 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1396 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-e524acc2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1397 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e50b86dd | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1398 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-bf66e9d4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1399 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e3c2d7f2 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1404 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ if (i == 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9c2b3284 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1408 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ if (i … | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5f3eade | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1412 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ if (i != nCnt - 1) ▸ else of (i == 0) ▸ else o… | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f336fef8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1422 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-150d6fbc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1425 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | 엔드포인트 요청 생성 |  |  |  |
| AC-3ab73b1d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1427 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-890c2a8f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1428 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb4e8752 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1429 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-273fa785 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1430 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-01610aaf | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1431 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c3f8b3d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1432 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-66cb7db3 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1433 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-72699f44 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1434 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5ce2592b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1435 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-402b5918 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1436 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7631d665 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1437 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-bab816e7 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1438 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-e2a92f0e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1439 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-58cb9d06 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1440 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-42adc743 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1441 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-bcf4c391 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1442 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-876cc5d4 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1443 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-bc229aec | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1444 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-840b64ff | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1445 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-01dc5c1a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1449 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ lambda ▸ else of (i != nCnt - 1) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d802066 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1460 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | dsTitle.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6795168c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1461 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | UI_MISC | dsTitle.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-d559e4b0 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1469 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null) | UI_MISC | dsBinding1.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-0a05eee9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1474 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding2 != null) | UI_MISC | dsBinding2.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-47288e0a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1479 | try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding3 != null) | UI_MISC | dsBinding3.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-8a837570 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1491 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04a505f8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1494 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL") ⇒ SCP.SCP0011_GET_PRODUCTION_PLAN_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-70342997 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1496 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2131c0b8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1497 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f06ab0b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1498 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-00f02e62 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1499 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e7c1228 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1500 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_model_id"] | p_model_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a2dcb93 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1501 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ef3f5aa | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1502 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-61e97cb1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1503 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-34f630c1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1504 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cb1b33e5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1505 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-e93bfffc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1506 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-ab375f37 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1507 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-730a4b25 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1508 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-35fdb2c9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1509 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-82865604 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1510 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-22fe2474 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1511 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-a1e7159d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1512 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-1da83ad8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1513 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_to_period"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-eac0d587 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1514 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-3e175ccf | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1515 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8aa4b92f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1517 | try ▸ else of (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3f8e742e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1526 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7d8bc60d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1530 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee997f83 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1531 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e3d3889c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1541 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50da6563 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1572 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-5da67fdb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1573 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-3cc0935f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1583 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a9f77690 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:1590 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0011_ProductionPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0c7d74d | this.Load | SCP0011_ProductionPlan.cs:181 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0011_ProductionPlan.Get_IsEditInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4023b85 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1767 |  | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3e8695e7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1768 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-146a2dc8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1771 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_PLAN_EDIT_INFO") ⇒ SCP.SCP0011_GET_PLAN_EDIT_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-13899e87 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1773 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7b9f5551 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1774 | lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-312eb1d9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1775 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cd3a9a65 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1776 | lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-4f4d81ef | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1777 | lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-89cd0847 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1778 | lambda | DATA_OP | req.Parameters["p_origin_division_id"] | p_origin_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9baa1fcc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1779 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-3d5e3186 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1780 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0ed40567 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1781 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d1735fbe | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0011_ProductionPlan.cs:1787 | if (dsBinding.Tables.Count > 0) | FLAG | dtIsEditInfo | dsBinding.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0011_ProductionPlan.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bdfd417 | this.Load | SCP0011_ProductionPlan.cs:979 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-c1cf1e82 | this.Load | SCP0011_ProductionPlan.cs:980 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-758b29f2 | this.Load | SCP0011_ProductionPlan.cs:983 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2559adc | this.Load 외 1 | SCP0011_ProductionPlan.cs:3325 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed5a466c | this.Load 외 1 | SCP0011_ProductionPlan.cs:3327 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3ec6656 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3256 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d7e50be1 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3257 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3f4efc7c | (진입점 미연결) | SCP0011_ProductionPlan.cs:3260 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.GetEventField

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-948764b8 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3176 | while (type != null) | CALL_EXT | type.GetField | (eventName, BindingFlags.Static \| BindingFlags.Instance \| BindingFlags.NonPublic) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ed6c083 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3177 | while (type != null) | CALL_EXT | field.FieldType.IsSubclassOf | (typeof(MulticastDelegate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-52b556a3 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3181 | while (type != null) | CALL_EXT | type.GetField | ("EVENT_" + eventName.ToUpper(), BindingFlags.Static \| BindingFlags.Instance \| BindingFl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c379cf54 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3186 |  | RETURN | return field; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-030a949a | (진입점 미연결) | SCP0011_ProductionPlan.cs:1134 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-786739fb | (진입점 미연결) | SCP0011_ProductionPlan.cs:1136 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f690435a | (진입점 미연결) | SCP0011_ProductionPlan.cs:1137 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cabf77da | (진입점 미연결) | SCP0011_ProductionPlan.cs:1151 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-509a577f | (진입점 미연결) | SCP0011_ProductionPlan.cs:1152 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-8b72c089 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1153 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0011_ProductionPlan.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be2fa497 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3296 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-559321e9 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3290 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38ef47ef | (진입점 미연결) | SCP0011_ProductionPlan.cs:3302 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0011_ProductionPlan.GetSpdTitle

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4945250 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:3311 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-39328048 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:3316 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-e039f51e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:3317 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-26c91b43 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:3319 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-03d82598 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:3319 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0011_ProductionPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15129d93 | this.Load | SCP0011_ProductionPlan.cs:215 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-66f26df1 | this.Load | SCP0011_ProductionPlan.cs:216 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-915f81cc | this.Load | SCP0011_ProductionPlan.cs:217 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-44679012 | this.Load | SCP0011_ProductionPlan.cs:220 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5b49ede | this.Load | SCP0011_ProductionPlan.cs:223 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-240b6800 | this.Load | SCP0011_ProductionPlan.cs:228 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-633fd7e5 | this.Load | SCP0011_ProductionPlan.cs:240 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0747c849 | this.Load | SCP0011_ProductionPlan.cs:241 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f8c251f7 | this.Load | SCP0011_ProductionPlan.cs:243 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0011_ProductionPlan.InitSpread

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd62b841 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:323 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-acf2809a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:337 | if (spdInfo.SheetName == SpdSheet.shtMain) | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-818aee57 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:343 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e577db5c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:345 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fce9fcc9 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:349 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a0d2685 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:350 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c7afcbbc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:354 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ebbbf071 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:355 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bf3b55fe | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:399 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-a0dfcf03 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:402 | if (spdInfo.SheetName == SpdSheet.shtLine) | UI_PROP | spdInfo.nIdxData | nIdxDataLine | 속성 nIdxData 설정 |  |  |  |
| AC-3ce7b91b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:408 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e27f952 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:409 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.Freeze | (0, spdInfo.GetColumnIndex(DefColumns.MEASURE_NAME) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c9247e90 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:410 | if (spdInfo.SheetName == SpdSheet.shtLine) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f890afa1 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:414 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ if (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-063892a8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:415 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ if (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a6eaaf4a | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:419 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ else of (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ORIGIN_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-17cd1a84 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:420 | if (spdInfo.SheetName == SpdSheet.shtLine) ▸ else of (!this._isEE) | GRID_SET | spdInfo.ActiveSheet.Columns[siLine.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0011_ProductionPlan.InitSpreadDateColumn

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cafe98aa | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:462 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-200b9784 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:466 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21dd2ec8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:467 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), 0, 0, 99999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0ae05219 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:470 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-daeaac90 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:477 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1cbec761 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:478 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4024c32 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:483 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2098c17f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:484 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cad147da | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:492 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3417d0b8 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:493 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b006c652 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:503 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5fa4356 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:504 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd2884bb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:505 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e76ad544 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 6 | SCP0011_ProductionPlan.cs:506 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0011_ProductionPlan.RefreshDivsion

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a1bc556 | this.Load | SCP0011_ProductionPlan.cs:1065 |  | FLAG | dtMyDivision | BLUtils.GetDivision(false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-9ea6c752 | this.Load | SCP0011_ProductionPlan.cs:1065 |  | CALL_EXT | BLUtils.GetDivision | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-58f09ac4 | this.Load | SCP0011_ProductionPlan.cs:1066 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0011_ProductionPlan.RefreshElectrodeType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e25b2b85 | this.Load | SCP0011_ProductionPlan.cs:1070 |  | FLAG | dtElectrodeType | DBUtils.Filter(dtElectrodeTypeAll, "LOOKUP_TYPE = '" + CConstVariable.ElectrodeType + "'",… | 화면 필드/플래그 변경 |  |  |  |
| AC-dcc7eb4d | this.Load | SCP0011_ProductionPlan.cs:1070 |  | DATA_OP | DBUtils.Filter | (dtElectrodeTypeAll, "LOOKUP_TYPE = '" + CConstVariable.ElectrodeType + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-92fd7063 | this.Load | SCP0011_ProductionPlan.cs:1071 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0011_ProductionPlan.RefreshOperationGroup

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ec782f1 | this.Load 외 1 | SCP0011_ProductionPlan.cs:1077 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0011_ProductionPlan.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboOperationGroup.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd243554 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0011_ProductionPlan.cs:1087 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + this._division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cac6cb8b | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0011_ProductionPlan.cs:1087 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + this._division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3a9f3d01 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0011_ProductionPlan.cs:1088 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0011_ProductionPlan.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboOperationGroup.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7e88636 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1103 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + t… | 화면 필드/플래그 변경 |  |  |  |
| AC-3bef26e2 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1103 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + this._planDate … | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-890319e8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1104 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-230d36b5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1108 | if (dtPlanSeq.Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0011_ProductionPlan.RefreshPlantSite

진입점: this.Load / cboDivision.SelectedIndexChanged / cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-866fb80b | this.Load 외 2 | SCP0011_ProductionPlan.cs:1082 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0011_ProductionPlan.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboOperationGroup.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da9a0a46 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1092 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + … | 화면 필드/플래그 변경 |  |  |  |
| AC-2bb64da3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1092 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + this._division + "' AND PLANDATE = '" + this._planDate… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e54f41cc | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1093 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0dcf19b6 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 3 | SCP0011_ProductionPlan.cs:1097 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0011_ProductionPlan.SaveChage_CalData

진입점: this.btnCal.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9440fdd | this.btnCal.Click | SCP0011_ProductionPlan.cs:3357 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3bc87516 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3358 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9a6ce9a0 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3372 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND") ⇒ SCP.PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND | 엔드포인트 요청 생성 |  |  |  |
| AC-1d75dece | this.btnCal.Click | SCP0011_ProductionPlan.cs:3375 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-390e99f8 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3377 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70434906 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3381 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a4db0732 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3382 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dda2d6b6 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3383 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-fcefb07b | this.btnCal.Click | SCP0011_ProductionPlan.cs:3384 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3a72230e | this.btnCal.Click | SCP0011_ProductionPlan.cs:3385 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-4383d828 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3386 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-09070801 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3388 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8cd1075 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3388 | try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-dd38465f | this.btnCal.Click | SCP0011_ProductionPlan.cs:3398 | try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-03d08f6c | this.btnCal.Click | SCP0011_ProductionPlan.cs:3417 | try ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40a416bd | this.btnCal.Click | SCP0011_ProductionPlan.cs:3424 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f831bd09 | this.btnCal.Click | SCP0011_ProductionPlan.cs:3428 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0011_ProductionPlan.SaveData_Line

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-816de2db | SaveButton | SCP0011_ProductionPlan.cs:2701 | if (fps.Name == "spdLine") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a530a6e4 | SaveButton | SCP0011_ProductionPlan.cs:2706 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (siLine.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb4ab3a6 | SaveButton | SCP0011_ProductionPlan.cs:2726 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siLine) | 프레임워크 검증 |  |  |  |
| AC-ded888c6 | SaveButton | SCP0011_ProductionPlan.cs:2726 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siLine)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f020af2b | SaveButton | SCP0011_ProductionPlan.cs:2757 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | GRID_STYLE | siLine.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-dde47ccb | SaveButton | SCP0011_ProductionPlan.cs:2758 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-330a7f33 | SaveButton | SCP0011_ProductionPlan.cs:2759 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ for (i <= siLine.GetMaxRowIndex()) ▸ for (j <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2927a9d6 | SaveButton | SCP0011_ProductionPlan.cs:2795 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b6a5f929 | SaveButton | SCP0011_ProductionPlan.cs:2806 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE") ⇒ SCP.SCP0011_SAVE_PRODUCTION_PLAN_LINE | 엔드포인트 요청 생성 |  |  |  |
| AC-fd2227f2 | SaveButton | SCP0011_ProductionPlan.cs:2810 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | strACTIVE_FLAG | 행/컬럼 값 대입 |  |  |  |
| AC-3e22ed11 | SaveButton | SCP0011_ProductionPlan.cs:2811 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | strDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-512fc76b | SaveButton | SCP0011_ProductionPlan.cs:2812 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | strPLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-0c7240ee | SaveButton | SCP0011_ProductionPlan.cs:2813 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type"] | strPLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-422db22a | SaveButton | SCP0011_ProductionPlan.cs:2814 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq"] | strSEQ | 행/컬럼 값 대입 |  |  |  |
| AC-4d395148 | SaveButton | SCP0011_ProductionPlan.cs:2815 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_group"] | strOPERATION_GROUP | 행/컬럼 값 대입 |  |  |  |
| AC-e9b6615f | SaveButton | SCP0011_ProductionPlan.cs:2816 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | strSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b1bbaed8 | SaveButton | SCP0011_ProductionPlan.cs:2817 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | strITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7edf1d96 | SaveButton | SCP0011_ProductionPlan.cs:2818 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | strLINE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4182c3b6 | SaveButton | SCP0011_ProductionPlan.cs:2819 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | strOPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-276c68a8 | SaveButton | SCP0011_ProductionPlan.cs:2820 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | strMEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-9b73a00f | SaveButton | SCP0011_ProductionPlan.cs:2821 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-dccb7669 | SaveButton | SCP0011_ProductionPlan.cs:2822 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | strQTY | 행/컬럼 값 대입 |  |  |  |
| AC-9513409e | SaveButton | SCP0011_ProductionPlan.cs:2823 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | strUSER_ID | 행/컬럼 값 대입 |  |  |  |
| AC-eb973f51 | SaveButton | SCP0011_ProductionPlan.cs:2824 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fix"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a1adc1bf | SaveButton | SCP0011_ProductionPlan.cs:2825 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_electrode_type"] | strELECTRODE_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-9c9e5445 | SaveButton | SCP0011_ProductionPlan.cs:2826 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_origin_division_id"] | strORIGIN_DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7bfae404 | SaveButton | SCP0011_ProductionPlan.cs:2828 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_program_id"] | "SCP0011" | 행/컬럼 값 대입 |  |  |  |
| AC-1b51a86c | SaveButton | SCP0011_ProductionPlan.cs:2829 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-f06903aa | SaveButton | SCP0011_ProductionPlan.cs:2831 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4a6f902 | SaveButton | SCP0011_ProductionPlan.cs:2834 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-62dceacd | SaveButton | SCP0011_ProductionPlan.cs:2839 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b5edf87 | SaveButton | SCP0011_ProductionPlan.cs:2859 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08f80a78 | SaveButton | SCP0011_ProductionPlan.cs:2866 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-315a4d2e | SaveButton | SCP0011_ProductionPlan.cs:2868 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e832f478 | SaveButton | SCP0011_ProductionPlan.cs:2872 | if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0011_ProductionPlan.Set_FPOperationColor

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload) ▸ try] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload) ▸ try] / EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88b9364e | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2896 | if (siLine.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3286e5d6 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2897 |  | FLAG | siLine | GetSheetInfo(spdLine.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-63d66025 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2940 | for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, intColIdxMEASURE).ToString() == "PROD_PLAN_AMEND") | DATA_OP | dtPlanType.Select | ("CODE='FN'") | 데이터 객체 조작/조회 |  |  |  |
| AC-47aae875 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2977 | for (i < spdLine.ActiveSheet.RowCount) ▸ if (spdLine.ActiveSheet.GetText(i, intColIdxMEASURE).ToString() == "PROD_PLAN_AMEND") ▸ if (strIS_E… | GRID_STYLE | siLine.SetBGColor2 | (nEditableRow, nStartEditIdx, nEditableRow, siLine.ActiveSheet.ColumnCount - 1, Color.From… | 그리드 표시 설정 |  |  |  |
| AC-7d71ccac | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2988 | for (i < spdLine.ActiveSheet.RowCount) ▸ for (j < siLine.ActiveSheet.ColumnCount) ▸ if (siLine.GetColumnTag(j).IndexOf("M_") == 0) | GRID_LOCK | siLine.LockRange | (0, j, siLine.ActiveSheet.RowCount - 1, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-68f8a5cc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:2994 |  | UI_MISC | spdLine.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0011_ProductionPlan.Set_OnHandEOH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-709b03ec | (진입점 미연결) | SCP0011_ProductionPlan.cs:1888 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34cedba8 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1898 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0aee5789 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1912 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1056f778 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1916 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-db0d6862 | (진입점 미연결) | SCP0011_ProductionPlan.cs:1992 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxWeek] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-e9ebe6d7 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2004 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxMonth] | objBOH | 그리드 속성/값 설정 |  |  |  |
| AC-47e457f3 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2018 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-901294ce | (진입점 미연결) | SCP0011_ProductionPlan.cs:2019 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (viewRow, nIdxStart, viewRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ee18692 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2025 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-0c6b0073 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2029 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.Set_OnHandEOH_Parallel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-110f3773 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2038 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-deb6537f | (진입점 미연결) | SCP0011_ProductionPlan.cs:2048 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8c53f27 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2062 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1241c943 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2066 | try ▸ for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-f37617bc | (진입점 미연결) | SCP0011_ProductionPlan.cs:2220 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (dt.Columns… | DATA_OP | dt.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-94c984a0 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2249 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (dt.Columns… | GRID_SET | dt.Rows[i][ColName] | result | 그리드 속성/값 설정 |  |  |  |
| AC-34bc0fc9 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2259 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxWeek] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-383beba4 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2270 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "ONHAND_EOH") ▸ for (j < dt.Columns.Count) ▸ if (j == dt.Co… | GRID_SET | dt.Rows[i][nIdxMonth] | boh | 그리드 속성/값 설정 |  |  |  |
| AC-1a0d9cce | (진입점 미연결) | SCP0011_ProductionPlan.cs:2284 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.ActiveSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0ec17c0 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2285 | try ▸ for (i < dt.Rows.Count) ▸ if (dt.Rows[i][DefColumns.MEASURE].ToString() == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (viewRow, nIdxStart, viewRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53bf97d4 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2292 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-357177c8 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2296 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.Set_ProductResult

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / FindButton [try] / EditButton [if (fps != null) ▸ if (fps.Name == "spdLine") ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5e897fc | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 5 | SCP0011_ProductionPlan.cs:3011 | if (int.Parse(p_from_yyyymmdd.ToString()) < int.Parse(p_plan_start_yyyymmdd.ToString())) ▸ if (resultIdx != -1) | GRID_STYLE | spdInfo.SetBGColor2 | (0, spdInfo.nIdxData + 1, spdInfo.ActiveSheet.RowCount - 1, resultIdx, Color.FromArgb(234,… | 그리드 표시 설정 |  |  |  |

## SCP0011_ProductionPlan.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e34e679 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3271 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d7ee454 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3275 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a4f89b37 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3278 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33d1e911 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3282 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-5c74d1e9 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3283 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0011_ProductionPlan.SetColumnModelVisible

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88603422 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3042 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-aba203a7 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3043 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-97e54ea2 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3053 | try ▸ switch (pOperationGroup) case "A": | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c9ea29a6 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3056 | try ▸ switch (pOperationGroup) case "P": | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f4d883c3 | (진입점 미연결) | SCP0011_ProductionPlan.cs:3064 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0011_ProductionPlan.SetDataTableDateColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2ece0ca | (진입점 미연결) | SCP0011_ProductionPlan.cs:522 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | DATA_OP | dt.Columns.Add | (column) | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.SetDataTableQtyData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be75258b | (진입점 미연결) | SCP0011_ProductionPlan.cs:540 | for (i < source.Rows.Count) ▸ for (j < source.Columns.Count) ▸ if (columnName.IndexOf("D_") == 0) | GRID_SET | target.Rows[i][columnName] | source.Rows[i][columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-a26b614b | (진입점 미연결) | SCP0011_ProductionPlan.cs:563 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.SetFormationYield

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ef2dabf | (진입점 미연결) | SCP0011_ProductionPlan.cs:2349 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6ec1c06 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2353 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-99defb43 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2411 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-8d01b544 | (진입점 미연결) | SCP0011_ProductionPlan.cs:2425 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-e3b58bdd | (진입점 미연결) | SCP0011_ProductionPlan.cs:2433 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") ▸ for (nCol < dt.Columns.Count) | CALL_EXT | siMain.SetDecimal | (nRow, nIdxStart, nRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-943a19db | (진입점 미연결) | SCP0011_ProductionPlan.cs:2442 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.SetFormationYield1

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try] / FindButton [try] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d370f9b | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:2322 | for (nRow < dt.Rows.Count) ▸ if (strMeasure == "FORMATION_YIELD") | CALL_EXT | siMain.SetDecimal | (nRow, nIdxStart, nRow, nIdxEnd, 2, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1affa148 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:2326 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.SetLockSumColumn

진입점: EditButton [if (fps != null) ▸ if (fps.Name == "spdLine")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f07d97a9 | EditButton [if (fps != null) ▸ if (fps.Name == "spdLine")] | SCP0011_ProductionPlan.cs:994 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0011_ProductionPlan.SetOperationGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f52b2e8 | this.Load 외 1 | SCP0011_ProductionPlan.cs:1041 | if (this._isEE) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-5699f82f | this.Load 외 1 | SCP0011_ProductionPlan.cs:1041 | if (this._isEE) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca8777be | this.Load 외 1 | SCP0011_ProductionPlan.cs:1045 | else of (this._isEE) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-e4962e52 | this.Load 외 1 | SCP0011_ProductionPlan.cs:1045 | else of (this._isEE) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0011_ProductionPlan.SetPlanDataTableQtyData

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null)] / FindButton [try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|\| "Y".Equals(p_chk_all)) ▸ if (dsBinding1 != null)] / SaveButton [if (fps.Name == "spdLine") ▸ if (siLine != null && siMain.IsLock(SpdSheet.shtLine) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (p_bucket.ToString().Equals(BucketType.Daily) \|…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-855c5250 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:3488 | for (i < target.Rows.Count) | DATA_OP | source.Select | (strFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-a549a299 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:3506 | for (i < target.Rows.Count) ▸ foreach (DataRow row in dataRows) ▸ for (j < source.Columns.Count) ▸ if (columnNameStart == ("M_") \|\| column… | GRID_SET | target.Rows[i][columnName] | dTaraget + dSource | 그리드 속성/값 설정 |  |  |  |
| AC-ac22695c | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:3510 | for (i < target.Rows.Count) ▸ foreach (DataRow row in dataRows) ▸ for (j < source.Columns.Count) ▸ if (columnNameStart == ("M_") \|\| column… | GRID_SET | target.Rows[i][columnName] | row[columnName] | 그리드 속성/값 설정 |  |  |  |
| AC-e7ba8a77 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 2 | SCP0011_ProductionPlan.cs:3517 |  | DATA_OP | target.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0011_ProductionPlan.SetPlantSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c712259 | this.Load 외 2 | SCP0011_ProductionPlan.cs:1050 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "OPERATION_GROUP" }, new List<string>() { this._divis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6616481f | this.Load 외 2 | SCP0011_ProductionPlan.cs:1054 | if (this._isEE) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionEEAll, fitler, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-a132ec73 | this.Load 외 2 | SCP0011_ProductionPlan.cs:1054 | if (this._isEE) | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionEEAll, fitler, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8025ab1a | this.Load 외 2 | SCP0011_ProductionPlan.cs:1058 | else of (this._isEE) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, fitler, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-708b4e58 | this.Load 외 2 | SCP0011_ProductionPlan.cs:1058 | else of (this._isEE) | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, fitler, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0011_ProductionPlan.SetSpreadColumn

진입점: this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (showMsg) ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)] / this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (chkAll.Checked) ▸ if (siMain != null)] / this.chkSum.CheckedChanged [if (fps != null) ▸ if (fps.Name == "spdMain")] / FindBut…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3c25221 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0011_ProductionPlan.cs:933 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-835d7435 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0011_ProductionPlan.cs:938 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-6e277853 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0011_ProductionPlan.cs:945 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1bbdd46d | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0011_ProductionPlan.cs:949 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6575e4cb | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0011_ProductionPlan.cs:954 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-b9f5532f | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0011_ProductionPlan.cs:961 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-875465f5 | this.btnCal.Click [try ▸ if (t.Success) ▸ if (t.DataSet.Tabl… 외 8 | SCP0011_ProductionPlan.cs:965 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0011_ProductionPlan.spdLine_CellDoubleClick

진입점: this.spdLine.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db21f922 | this.spdLine.CellDoubleClick | SCP0011_ProductionPlan.cs:3158 |  | CALL_EXT | siLine.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0011_ProductionPlan.SpdLine_Changed

진입점: dsdmLine.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7bc2b86 | dsdmLine.Changed | SCP0011_ProductionPlan.cs:3206 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-112e8641 | dsdmLine.Changed | SCP0011_ProductionPlan.cs:3215 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f13b665 | dsdmLine.Changed | SCP0011_ProductionPlan.cs:3223 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c0b2f92 | dsdmLine.Changed | SCP0011_ProductionPlan.cs:3236 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |

## SCP0011_ProductionPlan.SpdLine_SelectionChanged

진입점: spdLine.SelectionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d381086 | spdLine.SelectionChanged | SCP0011_ProductionPlan.cs:3194 | try | FLAG | nSelRowOfLine | spdLine.ActiveSheet.ActiveRow.Index | 화면 필드/플래그 변경 |  |  |  |
| AC-4bc49284 | spdLine.SelectionChanged | SCP0011_ProductionPlan.cs:3195 | try | FLAG | nSelColOfLine | spdLine.ActiveSheet.ActiveColumn.Index | 화면 필드/플래그 변경 |  |  |  |
| AC-2441dcdf | spdLine.SelectionChanged | SCP0011_ProductionPlan.cs:3199 | catch ((Exception ex)) | FLAG | nSelRowOfLine | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2447a7a1 | spdLine.SelectionChanged | SCP0011_ProductionPlan.cs:3200 | catch ((Exception ex)) | FLAG | nSelColOfLine | -1 | 화면 필드/플래그 변경 |  |  |  |

## SCP0011_ProductionPlan.SpdLine_TopChange

진입점: this.spdLine.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b267536 | this.spdLine.TopChange | SCP0011_ProductionPlan.cs:598 |  | GRID_INIT | siLine.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0011_ProductionPlan.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d20441fc | this.spdMain.CellDoubleClick | SCP0011_ProductionPlan.cs:3140 | if (!chkAll.Checked && e.ColumnHeader) ▸ if ((siMain.GetColumnTag(e.Column).IndexOf("M_") == 0 && BucketType.Monthly == sBucketType) \|\| (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0284d39a | this.spdMain.CellDoubleClick | SCP0011_ProductionPlan.cs:3143 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e351f5eb | this.spdMain.CellDoubleClick | SCP0011_ProductionPlan.cs:3147 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-18061b45 | this.spdMain.CellDoubleClick | SCP0011_ProductionPlan.cs:3148 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0011_ProductionPlan.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45e02957 | this.spdMain.TopChange | SCP0011_ProductionPlan.cs:605 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

