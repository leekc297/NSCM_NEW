# AS-IS 액션 대조표 — SCP0021

> 원천: `Doc/asisfacts/screens/SCP0021/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 250행 · 메서드 32 · 종류 DATA_OP 79 · RETURN 30 · MESSAGE 26 · FLAG 21 · ENDPOINT 14 · LIST_REBIND 11 · GRID_LOCK 11 · COMBO_DATA 10 · GRID_INIT 10 · GRID_SET 8 · GRID_STYLE 8 · UI_MISC 6 · CALL_EXT 5 · UI_PROP 3 · VALIDATE 3 · GRID_BIND 2 · POPUP 2 · STATE_RESET 1 · ⚠ 의미 확인 필요 5


## SCP0021_LossTime.BtnLoosTimeApply_Click

진입점: this.btnLoosTimeApply.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c4a5545 | this.btnLoosTimeApply.Click | SCP0021_LossTime.cs:1407 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea969c24 | this.btnLoosTimeApply.Click | SCP0021_LossTime.cs:1408 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3577ee0 | this.btnLoosTimeApply.Click | SCP0021_LossTime.cs:1413 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5f78531 | this.btnLoosTimeApply.Click | SCP0021_LossTime.cs:1416 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (ValidateUserInput("NO_DATA")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6da4945a | this.btnLoosTimeApply.Click | SCP0021_LossTime.cs:1441 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ for (nRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(nRow, siMain.Get… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefMain.LOSS_TIME), loss == "" \|\| loss == null ? 0 : loss) | 그리드 값 설정 |  |  |  |
| AC-4a7f645e | this.btnLoosTimeApply.Click | SCP0021_LossTime.cs:1451 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (iCount <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.BtnSetupLoosTime_Click

진입점: this.btnSetupLoosTime.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5733b0f2 | this.btnSetupLoosTime.Click | SCP0021_LossTime.cs:395 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e2442e49 | this.btnSetupLoosTime.Click | SCP0021_LossTime.cs:396 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50d817cb | this.btnSetupLoosTime.Click | SCP0021_LossTime.cs:401 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fad4882d | this.btnSetupLoosTime.Click | SCP0021_LossTime.cs:404 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (ValidateUserInput("NO_DATA")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-077f0e83 | this.btnSetupLoosTime.Click | SCP0021_LossTime.cs:417 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ for (nRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(nRow, siMain.Get… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefMain.SETUP_LOSS_TIME), setup_loss == "" \|\| setup_loss ==… | 그리드 값 설정 |  |  |  |
| AC-9ef4cdbc | this.btnSetupLoosTime.Click | SCP0021_LossTime.cs:426 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (iCount <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.CheckDigitValueEntered

진입점: this.spdMain.EditModeOff / this.spdExcept.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c7fd36a | this.spdMain.EditModeOff 외 1 | SCP0021_LossTime.cs:509 | if (val.Equals("")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-395d8356 | this.spdMain.EditModeOff 외 1 | SCP0021_LossTime.cs:521 | if (nVal < 0) | GRID_SET | spread.SetValue | (nRow, nColumn, 1) | 그리드 값 설정 |  |  |  |
| AC-2a266d8a | this.spdMain.EditModeOff 외 1 | SCP0021_LossTime.cs:523 | if (nVal < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76170d3e | this.spdMain.EditModeOff 외 1 | SCP0021_LossTime.cs:528 | else of (nVal < 0) ▸ if (nVal > 1440) | GRID_SET | spread.SetValue | (nRow, nColumn, 1) | 그리드 값 설정 |  |  |  |
| AC-768ccae7 | this.spdMain.EditModeOff 외 1 | SCP0021_LossTime.cs:529 | else of (nVal < 0) ▸ if (nVal > 1440) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.checkValidN0

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f620397d | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1087 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefExcept.LOSS_START_DATE)).To… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c2eb3dd | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1098 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefExcept.LOSS_END_DATE)).ToSt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6548952 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1104 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (Int64.Parse(strStartDate) < 17530101 \|\| Int64.Parse(strEndDate) < 17530101) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048", new object[] { strStartDate + "~" + strEndDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-514d0fdf | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1110 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.checkValidN5

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc044d79 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1127 | for (i < dt.Rows.Count) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5860d7fc | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1130 | for (i < dt.Rows.Count) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-cd36f470 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1136 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefExcept.LOSS_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef63a199 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1137 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefExcept.LOSS_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dc224ec | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1156 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.LOSS_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e59259a | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1157 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.LOSS_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-a549419d | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1167 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a38face | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1168 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-88af9952 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1170 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-7858626a | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1171 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | GRID_STYLE | siExcept.SetBGColor | (changeCpRowIdx, iColIdx1, changeCpRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-25939a89 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1181 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00105", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aea96481 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1184 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.checkValidN8

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a21bc13 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1200 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5eb57f6b | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1201 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-d5caa8f5 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1211 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.LOSS_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-793c09c3 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1212 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefExcept.LOSS_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9937f72 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1216 | for (i < dt.Rows.Count) ▸ if (strLOSS_START_DATE == string.Empty \|\| strLOSS_END_DATE == string.Empty) | GRID_STYLE | siExcept.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-c95da009 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1217 | for (i < dt.Rows.Count) ▸ if (strLOSS_START_DATE == string.Empty \|\| strLOSS_END_DATE == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-41f67837 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1226 | for (i < dt.Rows.Count) ▸ if (intLOSS_START_DATE > intLOSS_END_DATE) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-229cf14c | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1229 | for (i < dt.Rows.Count) ▸ if (intLOSS_START_DATE > intLOSS_END_DATE) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-95dbd8ac | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1239 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc0131ee | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1242 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9144ced | clbBuilding.SelectedIndexChanged | SCP0021_LossTime.cs:451 |  | FLAG | dtOperation | Data.Common(Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 화면 필드/플래그 변경 |  |  |  |
| AC-5cdd0928 | clbBuilding.SelectedIndexChanged | SCP0021_LossTime.cs:451 |  | COMBO_DATA | Data.Common | (Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4a6df713 | clbBuilding.SelectedIndexChanged | SCP0021_LossTime.cs:452 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-77f91ffc | clbBuilding.SelectedIndexChanged | SCP0021_LossTime.cs:457 |  | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-373f1009 | clbBuilding.SelectedIndexChanged | SCP0021_LossTime.cs:457 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d449938 | clbBuilding.SelectedIndexChanged | SCP0021_LossTime.cs:458 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0021_LossTime.ClbOperation_SelectedIndexChanged

진입점: clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f5ed2fb | clbOperation.SelectedIndexChanged | SCP0021_LossTime.cs:441 |  | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-126f8485 | clbOperation.SelectedIndexChanged | SCP0021_LossTime.cs:441 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57014193 | clbOperation.SelectedIndexChanged | SCP0021_LossTime.cs:442 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0021_LossTime.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e35a1cf | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:464 |  | FLAG | dtBuilding | Data.Common(Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-e65212a1 | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:464 |  | COMBO_DATA | Data.Common | (Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-efdb0b7f | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:465 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-12c2c160 | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:468 |  | FLAG | dtOperation | Data.Common(Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 화면 필드/플래그 변경 |  |  |  |
| AC-d7820868 | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:468 |  | COMBO_DATA | Data.Common | (Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33cfb4b3 | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:469 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ea1f7ffd | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:475 |  | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-74b24075 | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:475 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72906056 | clbPlantSite.SelectedIndexChanged | SCP0021_LossTime.cs:476 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0021_LossTime.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c2ed359 | this.Load | SCP0021_LossTime.cs:260 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f078411d | this.Load | SCP0021_LossTime.cs:261 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1af0b64 | this.Load | SCP0021_LossTime.cs:263 |  | GRID_INIT | this.AddSheet | (spdExcept, SpdSheet.shtExcept , SpdSheet.shtExcept, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-20a5e9e7 | this.Load | SCP0021_LossTime.cs:264 |  | FLAG | siExcept | GetSheetInfo(spdExcept.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-783ad7c7 | this.Load | SCP0021_LossTime.cs:266 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0021_LossTime.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7e5bb1a | this.Load | SCP0021_LossTime.cs:240 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0021_LossTime.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46d255cc | DeleteButton | SCP0021_LossTime.cs:777 | if (fps.Name == spdExcept.Name) ▸ if (siExcept.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eafe2386 | DeleteButton | SCP0021_LossTime.cs:782 | if (fps.Name == spdExcept.Name) | DATA_OP | siExcept.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0021_LossTime.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47fc29ca | Dispose | SCP0021_LossTime.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0021_LossTime.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7413d5f4 | EditButton | SCP0021_LossTime.cs:792 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7c5a756 | EditButton | SCP0021_LossTime.cs:793 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46af6df7 | EditButton | SCP0021_LossTime.cs:803 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-92bf2980 | EditButton | SCP0021_LossTime.cs:804 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a7f88aaa | EditButton | SCP0021_LossTime.cs:805 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-65f1eabd | EditButton | SCP0021_LossTime.cs:806 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.GetColumnIndex(DefMain.LINE_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-33aa1393 | EditButton | SCP0021_LossTime.cs:807 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.LOSS_TIME_BIG), siMain.GetColumnIndex(DefMain.BIG_LAST_UPDA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a0db1e45 | EditButton | SCP0021_LossTime.cs:811 | if (spdMain != null) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) | FLAG | siExcept | GetSheetInfo(spdExcept.Name, spdExcept.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf05ce90 | EditButton | SCP0021_LossTime.cs:813 | if (spdMain != null) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) | GRID_LOCK | siExcept.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a7a69e45 | EditButton | SCP0021_LossTime.cs:814 | if (spdMain != null) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) | GRID_LOCK | siExcept.LockColumn | (0, siExcept.GetColumnIndex(DefExcept.LINE_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-db7515a6 | EditButton | SCP0021_LossTime.cs:815 | if (spdMain != null) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefExcept.CREATED_BY), siExcept.GetColumnIndex(DefExcept.LAST_UPD… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0021_LossTime.FindData_Except

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name)) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")] / this.s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-046261f6 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:686 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30da6cc5 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:688 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0021_GET_LOSS_TIME_EXCEPT") ⇒ SCP.SCP0021_GET_LOSS_TIME_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-c53eb6fd | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:689 | lambda | DATA_OP | request.Parameters["p_Division_Id"] | p_Division_Id | 행/컬럼 값 대입 |  |  |  |
| AC-e9a29e64 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:690 | lambda | DATA_OP | request.Parameters["p_Plant_Site"] | p_Plant_Site | 행/컬럼 값 대입 |  |  |  |
| AC-dd9c3b83 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:691 | lambda | DATA_OP | request.Parameters["p_Building"] | p_Building | 행/컬럼 값 대입 |  |  |  |
| AC-73ced590 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:692 | lambda | DATA_OP | request.Parameters["p_Operation"] | p_Operation | 행/컬럼 값 대입 |  |  |  |
| AC-1185e495 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:693 | lambda | DATA_OP | request.Parameters["p_Line"] | p_Line | 행/컬럼 값 대입 |  |  |  |
| AC-0e646379 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:694 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41feea23 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:696 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2c195705 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:702 |  | GRID_BIND | siExcept.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3612a5fe | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:705 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siExcept.LockColumn | (0, siExcept.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0021_LossTime.FindData_Main

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (iCount > 0) ▸ if (tran.Success)] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (iCount > 0) ▸ if (tran.Success)] / FindButton / SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-697377be | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:610 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-af61f905 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:610 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-217d12f5 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:626 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2755cb87 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:628 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-22c279d9 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:631 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-28b85453 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:633 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SCP.Maste… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be48d8bc | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:635 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0021_GET_LOSS_TIME") ⇒ SCP.SCP0021_GET_LOSS_TIME | 엔드포인트 요청 생성 |  |  |  |
| AC-7e2e70be | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:636 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-343e288a | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:637 | try ▸ lambda | DATA_OP | req.Parameters["p_Division_Id"] | p_Division_Id | 행/컬럼 값 대입 |  |  |  |
| AC-4888e34c | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:638 | try ▸ lambda | DATA_OP | req.Parameters["p_Plant_Site"] | p_Plant_Site | 행/컬럼 값 대입 |  |  |  |
| AC-9a0011bf | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:639 | try ▸ lambda | DATA_OP | req.Parameters["p_Building"] | p_Building | 행/컬럼 값 대입 |  |  |  |
| AC-3d46d95f | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:640 | try ▸ lambda | DATA_OP | req.Parameters["p_Operation"] | p_Operation | 행/컬럼 값 대입 |  |  |  |
| AC-449ea4bf | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:641 | try ▸ lambda | DATA_OP | req.Parameters["p_Line"] | p_Line | 행/컬럼 값 대입 |  |  |  |
| AC-877a4320 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:642 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e4d67352 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:643 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7619ae0c | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:650 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-54d17771 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:651 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c404cfe9 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:654 | try ▸ if (ds.Tables[0].Rows.Count>0) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a5892d57 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:659 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c2feb0e8 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:661 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2fa03f10 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:663 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7004aac2 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 3 | SCP0021_LossTime.cs:664 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0021_LossTime.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-360aeb9d | this.Load | SCP0021_LossTime.cs:227 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0021_LossTime.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3326268 | (진입점 미연결) | SCP0021_LossTime.cs:1395 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-314f6c00 | (진입점 미연결) | SCP0021_LossTime.cs:1396 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4a15af9e | (진입점 미연결) | SCP0021_LossTime.cs:1399 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b577bd0 | this.Load | SCP0021_LossTime.cs:246 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-cee851f3 | this.Load | SCP0021_LossTime.cs:248 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-337b8491 | this.Load | SCP0021_LossTime.cs:250 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-57b0a9fd | this.Load | SCP0021_LossTime.cs:254 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5c4d3aa | this.Load | SCP0021_LossTime.cs:255 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtExcept) | 데이터 객체 조작/조회 |  |  |  |

## SCP0021_LossTime.InitSpread

진입점: this.Load / this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (iCount > 0) ▸ if (tran.Success)] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ if (iCount > 0) ▸ if (tran.Success)] / this.spdMain.CellDoubleClick [if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader)] / FindButton / SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3af0ac6 | this.Load 외 5 | SCP0021_LossTime.cs:273 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-54c4a660 | this.Load 외 5 | SCP0021_LossTime.cs:275 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-7c80bdb5 | this.Load 외 5 | SCP0021_LossTime.cs:277 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1700ddc3 | this.Load 외 5 | SCP0021_LossTime.cs:278 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c88b0d8a | this.Load 외 5 | SCP0021_LossTime.cs:287 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefMain.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-8afc2a9d | this.Load 외 5 | SCP0021_LossTime.cs:288 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefMain.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-c2aee7e4 | this.Load 외 5 | SCP0021_LossTime.cs:289 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefMain.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-2d813f51 | this.Load 외 5 | SCP0021_LossTime.cs:331 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtExcept) | 그리드 재구성/초기화 |  |  |  |
| AC-60f7013e | this.Load 외 5 | SCP0021_LossTime.cs:333 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-69097ce3 | this.Load 외 5 | SCP0021_LossTime.cs:335 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0021_LossTime.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-495953ed | InsertButton | SCP0021_LossTime.cs:764 | if (fps != null) ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (dicSelectedLossTime.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00161", new object[] { "Loss Time" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-122193fb | InsertButton | SCP0021_LossTime.cs:765 | if (fps != null) ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if (dicSelectedLossTime.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.InsertRow

진입점: InsertButton [if (fps != null) ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c4289b8 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:715 |  | DATA_OP | siExcept.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-819bf523 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:725 |  | DATA_OP | dicData.Add | (DefExcept.DIVISION_ID, dicSelectedLossTime[DefExcept.DIVISION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfcbd4e3 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:726 |  | DATA_OP | dicData.Add | (DefExcept.DIVISION_NAME , dicSelectedLossTime[DefExcept.DIVISION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ac70878 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:727 |  | DATA_OP | dicData.Add | (DefExcept.PLANT_SITE_ID, dicSelectedLossTime[DefExcept.PLANT_SITE_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-07c66143 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:728 |  | DATA_OP | dicData.Add | (DefExcept.PLANT_SITE_NAME, dicSelectedLossTime[DefExcept.PLANT_SITE_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ce909ce | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:729 |  | DATA_OP | dicData.Add | (DefExcept.FACTORY_ID, dicSelectedLossTime[DefExcept.FACTORY_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca305837 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:730 |  | DATA_OP | dicData.Add | (DefExcept.FACTORY_NAME, dicSelectedLossTime[DefExcept.FACTORY_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-80ccbf6a | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:731 |  | DATA_OP | dicData.Add | (DefExcept.OPERATION_ID, dicSelectedLossTime[DefExcept.OPERATION_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-79f17d96 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:732 |  | DATA_OP | dicData.Add | (DefExcept.OPERATION_NAME, dicSelectedLossTime[DefExcept.OPERATION_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4048c184 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:733 |  | DATA_OP | dicData.Add | (DefExcept.LINE_ID, dicSelectedLossTime[DefExcept.LINE_ID]) | 데이터 객체 조작/조회 |  |  |  |
| AC-565ae469 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:734 |  | DATA_OP | dicData.Add | (DefExcept.LINE_NAME, dicSelectedLossTime[DefExcept.LINE_NAME]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b52aee3c | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:737 |  | DATA_OP | dicData.Add | (DefExcept.LOSS_TIME_MIN, strLostTimeMin) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a238a07 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:738 |  | DATA_OP | dicData.Add | (DefExcept.SETUP_LOSS_TIME_MIN, strSetupLossTimeMin) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ef3a170 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:744 |  | GRID_SET | siExcept.SetValue | (insCell, dicData) | 그리드 값 설정 |  |  |  |
| AC-a94320eb | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:746 |  | GRID_LOCK | siExcept.LockRange | (insCell,siExcept.GetColumnIndex(DefExcept.DIVISION_ID), siExcept.GetColumnIndex(DefExcept… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abf49fb5 | InsertButton [if (fps != null) ▸ if (siExcept != null && siE… | SCP0021_LossTime.cs:747 |  | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefExcept.CREATED_BY), siExcept.GetColumnIndex(DefExcept… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0021_LossTime.SaveExcept

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))] / SaveButton [if (this.fps != null) ▸ else of (fps.Name.Equals(spdMain.Name)) ▸ if (fps.Name.Equals(spdExcept.Name))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eb91ab1 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:941 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siExcept) | 프레임워크 검증 |  |  |  |
| AC-6b9ef672 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:941 | if (!DataUtil.checkRequiredOfSpread(siExcept)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f6a24c5 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:942 | if (!checkValidN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3ce27a3 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:943 | if (!checkValidN5(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7453e024 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:944 | if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2258c6d | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:982 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0021_SAVE_LOSS_TIME_EXCEPT") ⇒ SCP.SCP0021_SAVE_LOSS_TIME_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-e922a98f | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:984 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5740b5b4 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:986 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-bca4f71f | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:987 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-67aec7f1 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:988 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-93e3b2be | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:989 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-50d9be5c | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:990 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-32984ad5 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:991 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-1b7637a3 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:992 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_loss_start_date"] | p_loss_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-2b6196e3 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:993 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_loss_end_date"] | p_loss_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-1b23dfd8 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:994 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_loss_time_min"] | p_loss_time_min | 행/컬럼 값 대입 |  |  |  |
| AC-64c46606 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:995 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_setup_loss_time_min"] | p_setup_loss_time_min | 행/컬럼 값 대입 |  |  |  |
| AC-3615c35f | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:996 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_comment"] | p_comment | 행/컬럼 값 대입 |  |  |  |
| AC-744815a9 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:997 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-fa1aaed6 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:998 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-275967cd | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1001 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-18783385 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1002 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_plant_site_id"] | p_org_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-924feefb | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1003 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_factory_id"] | p_org_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-8c03e15d | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1004 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_operation_id"] | p_org_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-b4cb754d | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1005 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_line_id"] | p_org_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-38df4c6c | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1006 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_loss_start_date"] | p_org_loss_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-b567cb80 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1007 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_loss_end_date"] | p_org_loss_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-6079e699 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1009 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-02f4a1b9 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1011 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-adf232c6 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1011 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-5c81a949 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1017 | if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd4e33ea | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1026 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (errCode == "2627") | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad79f86e | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1037 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (errCode == "2627") ▸ for (i < siEx… | GRID_STYLE | siExcept.SetBGColor | (i, siExcept.GetColumnIndex(DefExcept.LOSS_START_DATE), i, siExcept.GetColumnIndex(DefExce… | 그리드 표시 설정 |  |  |  |
| AC-eb0316e9 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:1045 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (errCode == "2627") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0021_LossTime.SaveLossTime

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name))] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name))] / SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c282784c | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:881 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0021_SAVE_LOSS_TIME") ⇒ SCP.SCP0021_SAVE_LOSS_TIME | 엔드포인트 요청 생성 |  |  |  |
| AC-e8bf2110 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:883 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b1a2ec8 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:885 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-164fd29b | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:886 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea8f403f | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:887 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6810a3b | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:888 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-6f7d4da5 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:889 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-9215ffa3 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:890 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-4f406523 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:891 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_loss_time_min"] | p_loss_time_min_big | 행/컬럼 값 대입 |  |  |  |
| AC-89184200 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:892 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_setup_loss_time_min"] | p_setup_loss_time_min_big | 행/컬럼 값 대입 |  |  |  |
| AC-96e1ad85 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:893 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-882c79db | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:894 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-a99cbdb1 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:895 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f18d5da | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:895 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-fe1cea41 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 2 | SCP0021_LossTime.cs:900 | if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0021_LossTime.SetCellFocus_ERROR

진입점: this.spdMain.EditModeOff [if (nVal < 0)] / this.spdExcept.EditModeOff [if (nVal < 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33446bb7 | this.spdMain.EditModeOff [if (nVal < 0)] 외 1 | SCP0021_LossTime.cs:1335 |  | GRID_STYLE | spread.ActiveSheet.SetActiveCell | (this.siMainCellRowIdx, this.siMainCellColumnIdx) | 그리드 표시 설정 |  |  |  |

## SCP0021_LossTime.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc821960 | this.Load 외 1 | SCP0021_LossTime.cs:1252 |  | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperNonOsp, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-b51c49c6 | this.Load 외 1 | SCP0021_LossTime.cs:1252 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperNonOsp, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0875908 | this.Load 외 1 | SCP0021_LossTime.cs:1253 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-da7813cf | this.Load 외 1 | SCP0021_LossTime.cs:1257 |  | FLAG | dtBuilding | Data.Common(Data.Type.BuildingByDivision, false, division, "") ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-4bfc8172 | this.Load 외 1 | SCP0021_LossTime.cs:1257 |  | COMBO_DATA | Data.Common | (Data.Type.BuildingByDivision, false, division, "") ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9276b2c2 | this.Load 외 1 | SCP0021_LossTime.cs:1258 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-11fc8ae0 | this.Load 외 1 | SCP0021_LossTime.cs:1263 |  | FLAG | dtOperation | Data.Common(Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 화면 필드/플래그 변경 |  |  |  |
| AC-a524c4a3 | this.Load 외 1 | SCP0021_LossTime.cs:1263 |  | COMBO_DATA | Data.Common | (Data.Type.LocationGroupByCapa, false) ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-332997d7 | this.Load 외 1 | SCP0021_LossTime.cs:1264 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0b580116 | this.Load 외 1 | SCP0021_LossTime.cs:1267 |  | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, "", pBuilding, pOperation, pPlantS… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-f3fb9dbb | this.Load 외 1 | SCP0021_LossTime.cs:1267 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pBuilding, pOperation, pPlantSite) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-12512308 | this.Load 외 1 | SCP0021_LossTime.cs:1268 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0021_LossTime.SpdExcept_EditChange

진입점: this.spdExcept.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-917343db | this.spdExcept.EditChange | SCP0021_LossTime.cs:488 |  | FLAG | this.siExceptCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d1c00786 | this.spdExcept.EditChange | SCP0021_LossTime.cs:489 |  | FLAG | this.siExceptCellColumnIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0021_LossTime.SpdExcept_EditModeOff

진입점: this.spdExcept.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f5a5f0a | this.spdExcept.EditModeOff | SCP0021_LossTime.cs:481 | if (this.siExceptCellRowIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-659ee68f | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:537 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5eea6e10 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:541 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | STATE_RESET | dicSelectedLossTime.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d89637f6 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:544 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | FLAG | this.spdMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-04c51403 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:545 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | FLAG | this.spdMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-31d736aa | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:547 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.DIVISION_ID, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.DIVISION_ID))) | 데이터 객체 조작/조회 |  |  |  |
| AC-13715c20 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:548 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.DIVISION_NAME, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.DIVISION_NAM… | 데이터 객체 조작/조회 |  |  |  |
| AC-53c7da7c | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:549 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.PLANT_SITE_ID, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.PLANT_SITE_I… | 데이터 객체 조작/조회 |  |  |  |
| AC-beb303d4 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:550 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.PLANT_SITE_NAME, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.PLANT_SITE… | 데이터 객체 조작/조회 |  |  |  |
| AC-ed1510e1 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:551 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.FACTORY_ID, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.FACTORY_ID))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d067573 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:552 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.FACTORY_NAME, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.FACTORY_NAME)… | 데이터 객체 조작/조회 |  |  |  |
| AC-082a9bd3 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:553 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.OPERATION_ID, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.OPERATION_ID)… | 데이터 객체 조작/조회 |  |  |  |
| AC-80e14064 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:554 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.OPERATION_NAME, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.OPERATION_N… | 데이터 객체 조작/조회 |  |  |  |
| AC-a6d1c37d | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:555 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.LINE_ID, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.LINE_ID))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3993cf1a | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:556 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.LINE_NAME, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.LINE_NAME))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a16388a | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:557 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.LOSS_TIME_MIN , siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.LOSS_TIME))… | 데이터 객체 조작/조회 |  |  |  |
| AC-cacf7118 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:558 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.SETUP_LOSS_TIME_MIN , siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.SETUP… | 데이터 객체 조작/조회 |  |  |  |
| AC-c68c396f | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:559 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.CREATED_BY, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.CREATED_BY))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6f624f3 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:560 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.CREATION_DATE, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.CREATION_DAT… | 데이터 객체 조작/조회 |  |  |  |
| AC-3ba09914 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:561 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.LAST_UPDATED_BY, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.LAST_UPDAT… | 데이터 객체 조작/조회 |  |  |  |
| AC-5ae9ddc3 | this.spdMain.CellDoubleClick | SCP0021_LossTime.cs:562 | if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible && !e.ColumnHeader) | DATA_OP | dicSelectedLossTime.Add | (DefExcept.LAST_UPDATE_DATE, siMain.GetText(e.Row, siMain.GetColumnIndex(DefMain.LAST_UPDA… | 데이터 객체 조작/조회 |  |  |  |

## SCP0021_LossTime.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-045e1d16 | this.spdMain.EditChange | SCP0021_LossTime.cs:494 |  | FLAG | this.siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-7c9b4a44 | this.spdMain.EditChange | SCP0021_LossTime.cs:495 |  | FLAG | this.siMainCellColumnIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0021_LossTime.SpdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee4e2fc3 | this.spdMain.EditModeOff | SCP0021_LossTime.cs:500 | if (this.siMainCellRowIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0021_LossTime.ValidateUserInput

진입점: this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)] / this.btnSetupLoosTime.Click [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)] / this.spdMain.EditModeOff [if (nVal < 0)] / this.spdExcept.EditModeOff [if (nVal < 0)] / SaveButton [if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) ▸ else of (iCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83a7bde0 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1279 | if (action_name.Equals("NO_DATA")) ▸ if (siMain.ActiveSheet.RowCount <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00059") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d433dcd6 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1286 | else of (action_name.Equals("NO_DATA")) ▸ if (action_name.Equals("NO_CHECKED")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69397fff | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1292 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ if (action_name.Equals("NO_LOSS_TIME")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-219800cc | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1297 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("NO_LOSS_TIME")) ▸ if (ac… | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71623e30 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1303 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("NO_LOSS_TIME")) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d7ae4d8 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1308 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("NO_LOSS_TIME")) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f7d93e6c | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1313 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("NO_LOSS_TIME")) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15ddeee6 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1318 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("NO_LOSS_TIME")) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b6ba0f1 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1322 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("NO_LOSS_TIME")) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { 0 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40fecae3 | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1327 | else of (action_name.Equals("NO_DATA")) ▸ else of (action_name.Equals("NO_CHECKED")) ▸ else of (action_name.Equals("NO_LOSS_TIME")) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00160", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4dea8fad | this.btnLoosTimeApply.Click [if (MessageHelper.GMessageBox("… 외 4 | SCP0021_LossTime.cs:1331 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

