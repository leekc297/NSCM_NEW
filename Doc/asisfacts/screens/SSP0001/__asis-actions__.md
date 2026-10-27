# AS-IS 액션 대조표 — SSP0001

> 원천: `Doc/asisfacts/screens/SSP0001/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 287행 · 메서드 35 · 종류 DATA_OP 89 · RETURN 27 · GRID_INIT 26 · FLAG 24 · ENDPOINT 18 · UI_PROP 17 · GRID_LOCK 13 · GRID_SET 12 · POPUP 11 · MESSAGE 10 · VALUE_SET 6 · LIST_REBIND 5 · UI_MISC 5 · COMBO_DATA 5 · GRID_BIND 4 · GRID_STYLE 4 · CALL_EXT 4 · VALIDATE 4 · STATE_RESET 3 · ⚠ 의미 확인 필요 4


## SSP0001_ShipmentPlanConfirm.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-752b95d3 | this.btnItemId.Click | SSP0001_ShipmentPlanConfirm.cs:608 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-71fedcbc | this.btnItemId.Click | SSP0001_ShipmentPlanConfirm.cs:610 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3ce89892 | this.btnItemId.Click | SSP0001_ShipmentPlanConfirm.cs:611 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c5f2fa59 | this.btnItemId.Click | SSP0001_ShipmentPlanConfirm.cs:612 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1a875d06 | this.btnItemId.Click | SSP0001_ShipmentPlanConfirm.cs:618 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5b37c1d | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:633 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d324544f | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:637 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22923f7c | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:638 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdDetail") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-612056e3 | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:642 | else of (fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6b8e17e | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:643 | else of (fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62ec9f9b | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:646 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0001", shtName, false) | 팝업/폼 생성 |  |  |  |
| AC-55646f45 | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:647 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-36d708d8 | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:648 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-02d564b4 | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:652 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-955753f9 | this.btnMeasure.Click | SSP0001_ShipmentPlanConfirm.cs:662 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.CalculateSum

진입점: FindButton [try] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74b3fca0 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1073 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-e37205d7 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1077 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-67b5075c | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1118 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count-1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ if (strMeasure == "FOR… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-f9351663 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1121 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count-1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) ▸ else of (strMeasure ==… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-25e2ebf7 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1135 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ if (strMeasure == "F… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-a63ace98 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1138 | for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) ▸ else of (strMeasure … | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-27bfe7c9 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1147 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1fe7d2d5 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1311 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-54a8c90d | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1315 | for (nCol < dt.Columns.Count) ▸ if (dt.Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0bcadfe | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1374 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum / nCntDayOfWeek | 행/컬럼 값 대입 |  |  |  |
| AC-031ad3ed | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1377 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("W_")… | DATA_OP | dr[nIdxWeek] | weekSum | 행/컬럼 값 대입 |  |  |  |
| AC-ff96136b | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1395 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum / nCntDayOfMonth | 행/컬럼 값 대입 |  |  |  |
| AC-b4095194 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1399 | for (nRow < dt.Rows.Count) ▸ for (nCol < dt.Columns.Count) ▸ if (nCol == dt.Columns.Count - 1 \|\| dt.Columns[nCol].ColumnName.IndexOf("M_")… | DATA_OP | dr[nIdxMonth] | monthSum | 행/컬럼 값 대입 |  |  |  |
| AC-bfe35f68 | FindButton [try] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1408 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0001_ShipmentPlanConfirm.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ea63921 | cboPlanDate.SelectedIndexChanged | SSP0001_ShipmentPlanConfirm.cs:1584 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca1aebd7 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:239 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-0ada2c8b | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:240 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0001_ShipmentPlanConfirm.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7d5e276 | this.Load | SSP0001_ShipmentPlanConfirm.cs:270 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7aff8ff1 | this.Load | SSP0001_ShipmentPlanConfirm.cs:271 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-df78357d | this.Load | SSP0001_ShipmentPlanConfirm.cs:273 |  | GRID_INIT | this.AddSheet | (spdDetail, SpdSheet.shtDetail, SpdSheet.shtDetail, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-776ab72d | this.Load | SSP0001_ShipmentPlanConfirm.cs:274 |  | FLAG | siDetail | GetSheetInfo(spdDetail.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-f28484a4 | this.Load | SSP0001_ShipmentPlanConfirm.cs:277 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0001_ShipmentPlanConfirm.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac0a5420 | this.Load | SSP0001_ShipmentPlanConfirm.cs:223 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-313d4214 | this.Load | SSP0001_ShipmentPlanConfirm.cs:225 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-22c0a15a | this.Load | SSP0001_ShipmentPlanConfirm.cs:226 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-44d80f89 | this.Load | SSP0001_ShipmentPlanConfirm.cs:227 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-7180f5a7 | this.Load | SSP0001_ShipmentPlanConfirm.cs:230 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38b6e42c | Dispose | SSP0001_ShipmentPlanConfirm.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0001_ShipmentPlanConfirm.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46960a15 | EditButton | SSP0001_ShipmentPlanConfirm.cs:536 | if (fps != null) ▸ if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ab94357 | EditButton | SSP0001_ShipmentPlanConfirm.cs:537 | if (fps != null) ▸ if (fps.Name == "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73bf45a6 | EditButton | SSP0001_ShipmentPlanConfirm.cs:544 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (cboPlanDate.SelectedIndex != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00170", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cbd8eb2b | EditButton | SSP0001_ShipmentPlanConfirm.cs:545 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (cboPlanDate.SelectedIndex != 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e22300a8 | EditButton | SSP0001_ShipmentPlanConfirm.cs:552 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (!isEditable) ▸ if (IsShipFrozenZero) | MESSAGE | MessageHelper.GMessageBox | ("MSG00228", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4675dd92 | EditButton | SSP0001_ShipmentPlanConfirm.cs:553 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (!isEditable) ▸ if (IsShipFrozenZero) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff5150bf | EditButton | SSP0001_ShipmentPlanConfirm.cs:559 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (!isEditable) ▸ else of (IsShipFrozenZero) | MESSAGE | MessageHelper.GMessageBox | ("MSG00169", new object[] { strMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e2f05f4b | EditButton | SSP0001_ShipmentPlanConfirm.cs:560 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (!isEditable) ▸ else of (IsShipFrozenZero) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03db60a0 | EditButton | SSP0001_ShipmentPlanConfirm.cs:564 | if (fps != null) ▸ if (fps.Name == "spdDetail") | FLAG | siDetail | GetSheetInfo(spdDetail.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-83326242 | EditButton | SSP0001_ShipmentPlanConfirm.cs:565 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8792c725 | EditButton | SSP0001_ShipmentPlanConfirm.cs:567 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.BIZ_TYPE_NAME), siDetail.GetColumnIndex(DefColumns.PLA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4039cf85 | EditButton | SSP0001_ShipmentPlanConfirm.cs:568 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.CONFIRM_FLAG), siDetail.GetColumnIndex(DefColumns.CONF… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1400ad67 | EditButton | SSP0001_ShipmentPlanConfirm.cs:569 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.CONFIRM_ID), siDetail.GetColumnIndex(DefColumns.CONFIR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9944ccf5 | EditButton | SSP0001_ShipmentPlanConfirm.cs:570 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.ERP_SO_NO), siDetail.GetColumnIndex(DefColumns.ERP_SO_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-45749739 | EditButton | SSP0001_ShipmentPlanConfirm.cs:571 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO), siDetail.GetColumnIndex(DefColumns.CHA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c386767b | EditButton | SSP0001_ShipmentPlanConfirm.cs:572 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siDetail.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-00cf9078 | EditButton | SSP0001_ShipmentPlanConfirm.cs:573 | if (fps != null) ▸ if (fps.Name == "spdDetail") | GRID_LOCK | siDetail.LockColumn | (siDetail.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siDetail.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f92604d | EditButton | SSP0001_ShipmentPlanConfirm.cs:582 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ for (i < siDetail.ActiveSheet.RowCount) ▸ if (strCONFIRM_FLAG == "Y") | GRID_LOCK | siDetail.LockRange | (i, siDetail.GetColumnIndex(DefColumns.CONFIRM_QTY), i, siDetail.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a1e29ba | EditButton | SSP0001_ShipmentPlanConfirm.cs:590 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (iCheckCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00207", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef8f7abf | EditButton | SSP0001_ShipmentPlanConfirm.cs:591 | if (fps != null) ▸ if (fps.Name == "spdDetail") ▸ if (iCheckCnt == 0) | GRID_LOCK | siDetail.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.FindData_Detail

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0)] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4823c168 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:972 | if (string.IsNullOrEmpty(strSrchDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8b70408 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:993 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-15214ab6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:996 | lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL") ⇒ SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-6d08089e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:998 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c9b5503f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:999 | lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-f5185494 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1000 | lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0aa21895 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1001 | lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-35ea375f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1002 | lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7ba96ad9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1003 | lambda | DATA_OP | req.Parameters["p_yyyymmdd"] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-48d9b877 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1004 | lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-447fd7b3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1005 | lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fe3bfde3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1006 | lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-1c696f2f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1007 | lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-da0f6105 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1008 | lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7359afcc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1010 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52253963 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1011 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8e218b6c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1018 |  | GRID_BIND | siDetail.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-802a42aa | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1019 |  | GRID_LOCK | siDetail.LockColumn | (0, siDetail.ActiveSheet.ColumnCount-1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac8ff3b8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1020 |  | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-72a23d8f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1031 | if (this.nSelRowOfLine >= 0 && isReload) | GRID_STYLE | siDetail.ActiveSheet.SetActiveCell | (this.nSelRowOfLine, this.nSelColOfLine) | 그리드 표시 설정 |  |  |  |
| AC-0b031db5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1032 | if (this.nSelRowOfLine >= 0 && isReload) | CALL_EXT | spdDetail.ShowCell | (0, 0, this.nSelRowOfLine, this.nSelColOfLine, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |

## SSP0001_ShipmentPlanConfirm.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6956a2d1 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:789 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ea4df28a | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:794 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-9ab020ee | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:794 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54ce1138 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:797 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6a18ba7b | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:798 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-63736974 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:798 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b86379f | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:824 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-91f0cfa5 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:825 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SSP.Plan.WSL/FoxDataService.s… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ebdd852 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:829 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM") ⇒ SSP.SSP0001_GET_SHIPMENT_PLAN_CONFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-6b582edc | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:831 | try ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5de16810 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:833 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-500fc081 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:834 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a6691f00 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:835 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-3fd94c71 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:836 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-37d22725 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:837 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-969669da | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:838 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b2f4a3ac | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:839 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b929ff37 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:840 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed248817 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:841 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-302d94c7 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:842 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-1af03245 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:843 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b0feac67 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:844 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-3628e720 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:846 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-107322de | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:847 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-90bf7274 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:854 | try | FLAG | dtPlanNonZero | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-9e65c5af | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:855 | try | FLAG | dtBalanceMinus | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-c00461c3 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:857 | try | FLAG | dtPlanNonZero | dsBinding.Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-f884b4e6 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:857 | try | DATA_OP | dsBinding.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a6078e63 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:858 | try | FLAG | dtBalanceMinus | dsBinding.Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-c08f7b32 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:858 | try | DATA_OP | dsBinding.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ce43bdee | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:860 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b619c630 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:874 | try ▸ if (chkPlanZero.Checked) | STATE_RESET | dsBinding.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-7b73c2d0 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:875 | try ▸ if (chkPlanZero.Checked) | DATA_OP | dsBinding.Tables.Add | (dtPlanNonZero) | 데이터 객체 조작/조회 |  |  |  |
| AC-781ba124 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:876 | try ▸ if (chkPlanZero.Checked) | GRID_SET | siMain.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-50c9e7b6 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:877 | try ▸ if (chkPlanZero.Checked) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3680fc49 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:884 | try ▸ if (chkBalance.Checked) | STATE_RESET | dsBinding.Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ff71777f | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:885 | try ▸ if (chkBalance.Checked) | DATA_OP | dsBinding.Tables.Add | (dtBalanceMinus) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f63a128 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:886 | try ▸ if (chkBalance.Checked) | GRID_SET | siMain.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-f8a1174b | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:887 | try ▸ if (chkBalance.Checked) | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-609346f7 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:890 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4f9d969 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:891 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ff0a3a5c | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:914 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (iShipFrozen > 0) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTa… | GRID_STYLE | siMain.SetBGColor | (iRow, iCol, iRow, iCol, ControlColor.EditColor) | 그리드 표시 설정 |  |  |  |
| AC-8f916984 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:920 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (iShipFrozen > 0) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (siMain.GetCol… | GRID_STYLE | siMain.SetBGColor | (iRow, iCol, iRow, iCol, ControlColor.InvalidFGColor) | 그리드 표시 설정 |  |  |  |
| AC-8b8b5333 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:935 | try ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sMeasure == "SHIP_CONFIRM") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |
| AC-1a43a863 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:942 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10a59b4c | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:949 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-06746365 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:950 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d497df92 | FindButton 외 1 | SSP0001_ShipmentPlanConfirm.cs:958 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0001_ShipmentPlanConfirm.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d882d8c | this.Load | SSP0001_ShipmentPlanConfirm.cs:206 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-28668a66 | this.Load | SSP0001_ShipmentPlanConfirm.cs:213 |  | VALUE_SET | chkPlanZero.Checked | true | 컨트롤 값 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9c39d8b | this.Load | SSP0001_ShipmentPlanConfirm.cs:745 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-8b92a5ba | this.Load | SSP0001_ShipmentPlanConfirm.cs:746 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-37c74766 | this.Load | SSP0001_ShipmentPlanConfirm.cs:749 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetDayRange

진입점: this.Load / clbDivision.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddb30e75 | this.Load 외 2 | SSP0001_ShipmentPlanConfirm.cs:1750 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-17f8545a | this.Load 외 2 | SSP0001_ShipmentPlanConfirm.cs:1751 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-247724be | this.Load 외 2 | SSP0001_ShipmentPlanConfirm.cs:1752 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-12b6457b | this.Load 외 2 | SSP0001_ShipmentPlanConfirm.cs:1753 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-fd1f60e8 | this.Load 외 2 | SSP0001_ShipmentPlanConfirm.cs:1754 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcf2045d | this.Load 외 2 | SSP0001_ShipmentPlanConfirm.cs:1757 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetDayRange__

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5499e335 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1790 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-e29b6431 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1791 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-055970f0 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1792 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-16779652 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1793 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-95476621 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1794 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76db4338 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1797 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f893f24 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1682 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3ae31891 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1683 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b1434f97 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1686 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetShipToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b118ccbf | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1717 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetShipType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47edff71 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1712 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetSoldToParty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b814967 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1722 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0001_ShipmentPlanConfirm.GetSpdTitle

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11c0d76f | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:1729 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-af5c48df | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:1734 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-08d075b7 | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:1735 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-45dfb33c | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:1737 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-bc8d9dd4 | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:1737 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0001_ShipmentPlanConfirm.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22acda85 | this.Load | SSP0001_ShipmentPlanConfirm.cs:246 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8a23cbf | this.Load | SSP0001_ShipmentPlanConfirm.cs:249 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-f130d516 | this.Load | SSP0001_ShipmentPlanConfirm.cs:252 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-b78baf09 | this.Load | SSP0001_ShipmentPlanConfirm.cs:255 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2bd89ebb | this.Load | SSP0001_ShipmentPlanConfirm.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-10560b6f | this.Load | SSP0001_ShipmentPlanConfirm.cs:262 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-8812822a | this.Load | SSP0001_ShipmentPlanConfirm.cs:264 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-1383eb2f | this.Load | SSP0001_ShipmentPlanConfirm.cs:265 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0001_ShipmentPlanConfirm.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain")] / FindButton [try] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd0a8e2c | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:289 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-712669f3 | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:291 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-b0b61542 | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:297 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c373f40 | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:299 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7d0399b4 | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:303 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtDetail) | 그리드 재구성/초기화 |  |  |  |
| AC-7e9bad2e | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:305 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-23adf6a8 | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:307 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColumns.CONFIRM_QTY),0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-09efb94d | this.Load 외 4 | SSP0001_ShipmentPlanConfirm.cs:309 | if (spdInfo.SheetName == SpdSheet.shtDetail) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0001_ShipmentPlanConfirm.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (spdInfo.SheetName…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd3af1fb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:427 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0a01dd5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:431 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09b369bd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:435 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-788705b8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:442 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2810a284 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:443 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a91502d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:448 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be11cd68 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:449 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbe7197d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:457 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e11c6331 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:458 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0697241f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:468 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6e87618 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:469 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a412fe14 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:470 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b2776d7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 4 | SSP0001_ShipmentPlanConfirm.cs:471 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SaveData_Detail

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07a7288f | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1420 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (siDetail.ActiveSheet.Rows.Count <= … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc14adaa | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1441 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siDetail) | 프레임워크 검증 |  |  |  |
| AC-8b042781 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1441 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e6f90f7 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1473 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ for (i < siDetail.ActiveSheet.RowCount)… | CALL_EXT | Convert.ToInt64 | (siDetail.GetValue(i, siDetail.GetColumnIndex(DefColumns.CONFIRM_QTY))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b1947c5 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1495 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL") ⇒ SSP.SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-190a8401 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1497 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag" ] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-eebea716 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1498 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id" ] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bac933d5 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1499 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_start_yyyymmdd" ] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3999ffbb | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1500 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_type" ] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-4d3d248f | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1501 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_seq" ] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-e1b3281c | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1502 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id" ] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e004444a | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1503 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_site" ] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-e57baba0 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1504 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_site" ] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-08182c8e | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1505 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure" ] | p_measure | 행/컬럼 값 대입 |  |  |  |
| AC-6385abf8 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1506 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd" ] | p_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bb412e30 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1507 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bod_id" ] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-22962fc3 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1508 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty" ] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d84c1661 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1509 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type" ] | p_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-fa097c96 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1510 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code" ] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-e0bd328d | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1511 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_Confirm_ID"] | p_Confirm_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1032dd0e | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1513 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id" ] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-320e33bc | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1514 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a4e6f2df | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1516 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e25908cd | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1521 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.Da… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae3578b5 | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1539 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ else of (respon… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-711f31ba | SaveButton | SSP0001_ShipmentPlanConfirm.cs:1549 | if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SSP0001_ShipmentPlanConfirm.SetBalanceMinus

진입점: FindButton [try ▸ if (chkBalance.Checked)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (chkBalance.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c10453b | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1231 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84c7e846 | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1234 |  | DATA_OP | dt.Columns.Add | ("DivisionID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd8c34fc | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1235 |  | DATA_OP | dt.Columns.Add | ("FromSite") | 데이터 객체 조작/조회 |  |  |  |
| AC-f02d6f98 | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1236 |  | DATA_OP | dt.Columns.Add | ("ItemID") | 데이터 객체 조작/조회 |  |  |  |
| AC-162e0b28 | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1264 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-929dcba5 | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1265 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["DivisionID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ba6e405 | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1266 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["FromSite"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-187a278f | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1267 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["ItemID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a08439fb | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1268 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-67108e38 | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1285 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c1fee32 | FindButton [try ▸ if (chkBalance.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1292 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) ▸ if (list.Count > 0) ▸ foreach (DataRow dr2 in list) | DATA_OP | dtBalanceMinus.ImportRow | (dr2) | 데이터 객체 조작/조회 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SetChangedControl

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c658a10c | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:767 |  | DATA_OP | pDivisionID.Contains | ("EE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae553664 | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:769 | if (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-f14809f1 | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:769 | if (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28195d02 | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:773 | else of (!pDivisionID.Contains("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-04476e2d | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:773 | else of (!pDivisionID.Contains("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShipmentPlanPlantSite, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fad3ee5 | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:777 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c587bc14 | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:780 |  | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-73f7e522 | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:780 |  | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-27247a5f | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:781 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-51993e94 | this.Load 외 1 | SSP0001_ShipmentPlanConfirm.cs:783 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a15753e | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1696 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70b1c244 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1699 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-617b3ee1 | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1702 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c22a30cf | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1705 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-b5752bec | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:1706 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SetImageCell

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0)] / FindButton [try ▸ if (this.nSelRowOfMain >= 0 && isReload)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (this.nSelRowOfMain >= 0 && isReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b484c36 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1040 | for (iRow < siDetail.ActiveSheet.RowCount) | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.INCOTERMS)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2b2fe0b2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=… 외 2 | SSP0001_ShipmentPlanConfirm.cs:1041 | for (iRow < siDetail.ActiveSheet.RowCount) | GRID_SET | siDetail.ActiveSheet.Cells[iRow, siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)].CellTy… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SetLockSumColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe20189a | (진입점 미연결) | SSP0001_ShipmentPlanConfirm.cs:758 | for (iCol <= spreadInfo.GetMaxColumnIndex()) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("W_") == 0 \|\| spreadInfo.GetColumnTag(iCol).Index… | GRID_LOCK | siDetail.LockColumn | (iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SetPlanQtyNon

진입점: FindButton [try ▸ if (chkPlanZero.Checked)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (chkPlanZero.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8118a601 | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1157 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b667dbc | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1160 |  | DATA_OP | dt.Columns.Add | ("DivisionID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8aa1d564 | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1161 |  | DATA_OP | dt.Columns.Add | ("FromSite") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e368a95 | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1162 |  | DATA_OP | dt.Columns.Add | ("ItemID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f8c9ee8 | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1191 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e4fa0f4e | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1192 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["DivisionID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e003f8aa | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1193 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["FromSite"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e7449913 | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1194 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dr["ItemID"] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-520683de | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1195 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ▸… | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3aa9df5 | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1215 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c0a5a276 | FindButton [try ▸ if (chkPlanZero.Checked)] 외 1 | SSP0001_ShipmentPlanConfirm.cs:1222 | if (dt.Rows.Count > 0) ▸ foreach (DataRow dr in dt.Rows) ▸ if (list.Count > 0) ▸ foreach (DataRow dr2 in list) | DATA_OP | dtPlanNonZero.ImportRow | (dr2) | 데이터 객체 조작/조회 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row>=0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (fps.Name == "spdMain") ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.cboBucketType.SelectedIndexChanged / this.chkSum.CheckedChanged / FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [if (fps.Name == "spdDetail") ▸ if (siDetail != null && siMain.IsLock(SpdSheet.shtDetail) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02c3f10c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0001_ShipmentPlanConfirm.cs:699 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-97aa5c06 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0001_ShipmentPlanConfirm.cs:704 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-864b114e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0001_ShipmentPlanConfirm.cs:711 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1f26b97d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0001_ShipmentPlanConfirm.cs:715 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d625cbcf | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0001_ShipmentPlanConfirm.cs:720 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c9fae526 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0001_ShipmentPlanConfirm.cs:727 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9392a67b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 6 | SSP0001_ShipmentPlanConfirm.cs:731 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SpdDetail_CellClick

진입점: this.spdDetail.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65b2d80c | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1646 | if (siDetail.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98120479 | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1660 | if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) | POPUP | new SCM0002_ShipmentPlanConfirmBODPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f8ac54de | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1661 | if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-77a43f43 | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1662 | if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) | UI_PROP | pop._sDivisionID | sDivisionIDPop | 속성 _sDivisionID 설정 |  |  |  |
| AC-cc3a3723 | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1663 | if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) | UI_PROP | pop._sBodID | sBodID | 속성 _sBodID 설정 |  |  |  |
| AC-148598b3 | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1664 | if (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-00c6309a | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1669 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9860137e | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1671 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | new SCM0002_ShipmentPlanRequestPopup | () | 팝업/폼 생성 |  |  |  |
| AC-68193da3 | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1672 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6e82293e | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1673 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | UI_PROP | pop._sRequestNo | sRequestNo | 속성 _sRequestNo 설정 |  |  |  |
| AC-8947aeb9 | this.spdDetail.CellClick | SSP0001_ShipmentPlanConfirm.cs:1674 | else of (e.Column == siDetail.GetColumnIndex(DefColumns.INCOTERMS)) ▸ if (e.Column == siDetail.GetColumnIndex(DefColumns.CHANGE_REQ_NO)) | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SpdDetail_TopChange

진입점: this.spdDetail.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60f11345 | this.spdDetail.TopChange | SSP0001_ShipmentPlanConfirm.cs:499 |  | GRID_INIT | siDetail.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dddb54c | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1604 | if (e.ColumnHeader) | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-061e2757 | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1608 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelRowOfMain | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4e2a8d82 | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1609 | if (!e.ColumnHeader && e.Row>=0) | FLAG | nSelColOfMain | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-ea7c674b | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1611 | if (!e.ColumnHeader && e.Row>=0) | FLAG | IsShipFrozenZero | false | 화면 필드/플래그 변경 |  |  |  |
| AC-03e2a706 | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1613 | if (!e.ColumnHeader && e.Row>=0) ▸ if (siMain.GetColumnTag(nSelColOfMain).ToString().IndexOf("D_") == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c632ae2b | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1614 | if (!e.ColumnHeader && e.Row>=0) | FLAG | strSrchDate | siMain.GetColumnTag(nSelColOfMain).ToString().Replace("D_", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-c49e68d7 | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1623 | if (!e.ColumnHeader && e.Row>=0) ▸ if (!(string.IsNullOrEmpty(strSrchDate) \|\| string.IsNullOrEmpty(editColName))) ▸ if (strSrchDate == edi… | FLAG | isEditable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-67436f49 | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1627 | if (!e.ColumnHeader && e.Row>=0) ▸ if (!(string.IsNullOrEmpty(strSrchDate) \|\| string.IsNullOrEmpty(editColName))) ▸ else of (strSrchDate =… | FLAG | isEditable | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3cf31ebf | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1628 | if (!e.ColumnHeader && e.Row>=0) ▸ if (!(string.IsNullOrEmpty(strSrchDate) \|\| string.IsNullOrEmpty(editColName))) ▸ else of (strSrchDate =… | FLAG | strEditDate | editColName | 화면 필드/플래그 변경 |  |  |  |
| AC-19e6ab24 | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1634 | if (!e.ColumnHeader && e.Row>=0) ▸ if (iShipFrozen == 0) | FLAG | isEditable | false | 화면 필드/플래그 변경 |  |  |  |
| AC-72b0be2b | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1635 | if (!e.ColumnHeader && e.Row>=0) ▸ if (iShipFrozen == 0) | FLAG | IsShipFrozenZero | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9dac3314 | this.spdMain.CellDoubleClick | SSP0001_ShipmentPlanConfirm.cs:1637 | if (!e.ColumnHeader && e.Row>=0) ▸ else of (iShipFrozen == 0) | FLAG | IsShipFrozenZero | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0001_ShipmentPlanConfirm.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0b1f29f | this.spdMain.TopChange | SSP0001_ShipmentPlanConfirm.cs:506 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

