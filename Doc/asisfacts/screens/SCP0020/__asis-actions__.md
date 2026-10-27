# AS-IS 액션 대조표 — SCP0020

> 원천: `Doc/asisfacts/screens/SCP0020/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 527행 · 메서드 45 · 종류 DATA_OP 144 · RETURN 67 · MESSAGE 47 · GRID_SET 43 · FLAG 37 · GRID_LOCK 35 · GRID_INIT 33 · ENDPOINT 24 · UI_MISC 20 · POPUP 15 · LIST_REBIND 12 · GRID_STYLE 10 · UI_PROP 9 · VALIDATE 9 · CALL_EXT 7 · COMBO_DATA 5 · GRID_COMBO 4 · GRID_BIND 4 · VALUE_SET 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 7


## SCP0020_TactTime.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c567df54 | this.btnItemId.Click | SCP0020_TactTime.cs:2550 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-46ab628f | this.btnItemId.Click | SCP0020_TactTime.cs:2552 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-298321a1 | this.btnItemId.Click | SCP0020_TactTime.cs:2553 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-943f4373 | this.btnItemId.Click | SCP0020_TactTime.cs:2554 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-71d66404 | this.btnItemId.Click | SCP0020_TactTime.cs:2560 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0020_TactTime.CheckDigitValueEntered

진입점: dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / dsdmExcept.Changed [if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExcept)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fac7bce0 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | SCP0020_TactTime.cs:2879 | if (fps.Name == spdMain.Name) ▸ if (nCol == spread.GetColumnIndex(DefColumns.TACT_TIME)) ▸ if (nVal > checkMaxValue \|\| nVal < nMinTactTime… | GRID_SET | spread.SetValue | (nRow, nCol, nMinTactTime) | 그리드 값 설정 |  |  |  |
| AC-62a09fc2 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | SCP0020_TactTime.cs:2880 | if (fps.Name == spdMain.Name) ▸ if (nCol == spread.GetColumnIndex(DefColumns.TACT_TIME)) ▸ if (nVal > checkMaxValue \|\| nVal < nMinTactTime… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { nMinTactTime, checkMaxValue }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-953bfe78 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | SCP0020_TactTime.cs:2895 | else of (fps.Name == spdMain.Name) ▸ if (nCol == spread.GetColumnIndex(DefColumns.TACT_TIME)) ▸ if (nVal > checkMaxValue \|\| nVal < nMinTac… | GRID_SET | spread.SetValue | (nRow, nCol, nMinTactTime) | 그리드 값 설정 |  |  |  |
| AC-f47019a6 | dsdmMain.Changed [if (siMain.ActiveSheet.SheetName == SpdShe… 외 1 | SCP0020_TactTime.cs:2896 | else of (fps.Name == spdMain.Name) ▸ if (nCol == spread.GetColumnIndex(DefColumns.TACT_TIME)) ▸ if (nVal > checkMaxValue \|\| nVal < nMinTac… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { nMinTactTime, checkMaxValue }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0020_TactTime.checkValidN0

진입점: SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdExcept") ▸ if (this.mainsheetNm== SpdSheet.shtMain) ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0ebda86 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2341 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefColumns.TACT_TIME_START_DAT… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01113779 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2352 | for (i <= siExcept.GetMaxRowIndex()) ▸ else of (DateTime.TryParse(siExcept.GetText(i, siExcept.GetColumnIndex(DefColumns.TACT_TIME_END_DATE)… | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2c6d6c12 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2358 | for (i <= siExcept.GetMaxRowIndex()) ▸ if (Int64.Parse(strStartDate) <17530101 \|\| Int64.Parse(strEndDate) < 17530101) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048", new object[] { strStartDate+"~"+strEndDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dff3dbb0 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2371 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0020_TactTime.checkValidN5

진입점: SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdExcept") ▸ if (this.mainsheetNm== SpdSheet.shtMain) ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d1f32ed | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2387 | for (i < dt.Rows.Count) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3f53b40 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2390 | for (i < dt.Rows.Count) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-c3399af2 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2396 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TACT_TIME_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-476fde84 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2397 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TACT_TIME_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6326928 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2422 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-64ab1a30 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2423 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-aeb7f42a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2433 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6957920c | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2434 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb36af1a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2436 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-62a3e2de | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2437 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | GRID_STYLE | siExcept.SetBGColor | (changeCpRowIdx, iColIdx1, changeCpRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-65085097 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2447 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00105", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1dd26724 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2450 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0020_TactTime.checkValidN8

진입점: SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdExcept") ▸ if (this.mainsheetNm== SpdSheet.shtMain) ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d757f960 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2466 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1afb91cb | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2467 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-eb31ff07 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2477 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-490d943b | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2478 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6a4bfb4 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2482 | for (i < dt.Rows.Count) ▸ if (str_START_DATE == string.Empty \|\| str_END_DATE == string.Empty) | GRID_STYLE | siExcept.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-25b996dd | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2483 | for (i < dt.Rows.Count) ▸ if (str_START_DATE == string.Empty \|\| str_END_DATE == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b5b9c328 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2492 | for (i < dt.Rows.Count) ▸ if (intLOSS_START_DATE > intLOSS_END_DATE) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa32e4d9 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2495 | for (i < dt.Rows.Count) ▸ if (intLOSS_START_DATE > intLOSS_END_DATE) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-0d6d58f4 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2505 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b355d163 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2508 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0020_TactTime.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d805a494 | (진입점 미연결) | SCP0020_TactTime.cs:285 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c52056b8 | (진입점 미연결) | SCP0020_TactTime.cs:286 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0020_TactTime.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3758f4a | this.Load | SCP0020_TactTime.cs:374 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a461a3c8 | this.Load | SCP0020_TactTime.cs:375 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ec03b6a | this.Load | SCP0020_TactTime.cs:377 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPacker, SpdSheet.shtPacker, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ac741f79 | this.Load | SCP0020_TactTime.cs:378 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9a8563c | this.Load | SCP0020_TactTime.cs:380 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12b17022 | this.Load | SCP0020_TactTime.cs:384 |  | GRID_INIT | this.AddSheet | (spdExcept, SpdSheet.shtExcept, SpdSheet.shtExcept, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9c10dd37 | this.Load | SCP0020_TactTime.cs:385 |  | FLAG | siExcept | GetSheetInfo(spdExcept.Name, spdExcept.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-752dd85d | this.Load | SCP0020_TactTime.cs:386 |  | GRID_INIT | siExcept.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0020_TactTime.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f337102 | this.Load | SCP0020_TactTime.cs:199 |  | FLAG | dtLineByOperationOfSpdAll | Data.Common(Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-096c73d9 | this.Load | SCP0020_TactTime.cs:199 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4044a91a | this.Load | SCP0020_TactTime.cs:202 |  | FLAG | dtPlantSiteByDivisionPacker | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperOsp3, false, "40,81,82", "P", "Y") | 화면 필드/플래그 변경 |  |  |  |
| AC-38dcf7bc | this.Load | SCP0020_TactTime.cs:202 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperOsp3, false, "40,81,82", "P", "Y") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87c4b5e9 | this.Load | SCP0020_TactTime.cs:204 |  | FLAG | dtLineByOperationOsp | Data_SCP.Common(Data_SCP.Type.LineByPlantPacker, false, "40,81,82", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-804d7fbc | this.Load | SCP0020_TactTime.cs:204 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByPlantPacker, false, "40,81,82", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-788dbf46 | this.Load | SCP0020_TactTime.cs:206 |  | DATA_OP | dtPlantSiteOspIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7e5e406 | this.Load | SCP0020_TactTime.cs:207 |  | DATA_OP | dtPlantSiteOspIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |

## SCP0020_TactTime.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15dfd145 | DeleteButton | SCP0020_TactTime.cs:717 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dd289d7 | DeleteButton | SCP0020_TactTime.cs:726 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f128b95c | DeleteButton | SCP0020_TactTime.cs:733 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ else of (action == CAppSetting.FlagI) ▸ i… | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9bb50ad8 | DeleteButton | SCP0020_TactTime.cs:742 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87686020 | DeleteButton | SCP0020_TactTime.cs:746 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") | DATA_OP | siExcept.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0020_TactTime.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07f3479c | Dispose | SCP0020_TactTime.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0020_TactTime.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53ba14b3 | EditButton | SCP0020_TactTime.cs:559 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de0dec60 | EditButton | SCP0020_TactTime.cs:560 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (spdMain.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30bb2f29 | EditButton | SCP0020_TactTime.cs:563 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-40c66a89 | EditButton | SCP0020_TactTime.cs:564 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-af50a049 | EditButton | SCP0020_TactTime.cs:568 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ecc36a3 | EditButton | SCP0020_TactTime.cs:569 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.JUMBO_MIN), siMain.GetColumnIndex(DefColumns.BIG_LAST_UP… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ef5bd95 | EditButton | SCP0020_TactTime.cs:573 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (division=="42" \|\| division == "44") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_UOM), siMain.GetColumnIndex(DefColumns.TACT_TIME), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-a46863fd | EditButton | SCP0020_TactTime.cs:577 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (division=="42" \|\| division == "44") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DAILY_CAPACITY), siMain.GetColumnIndex(DefColumns.UOM_CO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce4f4294 | EditButton | SCP0020_TactTime.cs:583 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i < siMain.ActiveSheet.RowCount) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_ID), i, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-439f35d5 | EditButton | SCP0020_TactTime.cs:588 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSh… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LINE_ID), i, siMain.GetColumnIndex(DefColumns.LINE_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-25009b04 | EditButton | SCP0020_TactTime.cs:593 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOr… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LINE_ID), i, siMain.GetColumnIndex(DefColumns.LANE_QT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e495718b | EditButton | SCP0020_TactTime.cs:598 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSh… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LANE_QTY), i, siMain.GetColumnIndex(DefColumns.LANE_Q… | 그리드 편집 잠금/해제 |  |  |  |
| AC-67ccb2cb | EditButton | SCP0020_TactTime.cs:607 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-616f2eb6 | EditButton | SCP0020_TactTime.cs:608 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2595766d | EditButton | SCP0020_TactTime.cs:610 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e66aaac7 | EditButton | SCP0020_TactTime.cs:611 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TACT_TIME), siMain.GetColumnIndex(DefColumns.OSP_YN), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b59606f4 | EditButton | SCP0020_TactTime.cs:621 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LINE_ID), i, siMain.GetColumnIndex(DefColumns.LINE_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-31299ea4 | EditButton | SCP0020_TactTime.cs:629 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | DATA_OP | dtComboIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3b8dde4 | EditButton | SCP0020_TactTime.cs:630 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | DATA_OP | dtComboIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ffc2413 | EditButton | SCP0020_TactTime.cs:632 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | DATA_OP | dtLineByOperationOsp.Select | ("DIVISION_ID = '" + divisionId + "' AND SCM_SITE_ID='" + plantId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e94b352 | EditButton | SCP0020_TactTime.cs:635 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | DATA_OP | dtComboIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-108554ee | EditButton | SCP0020_TactTime.cs:636 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-97fe8e0b | EditButton | SCP0020_TactTime.cs:637 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b2bee08 | EditButton | SCP0020_TactTime.cs:638 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | DATA_OP | dtComboIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-213ad86a | EditButton | SCP0020_TactTime.cs:641 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex … | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.LINE_ID), dtComboIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-48ca4efb | EditButton | SCP0020_TactTime.cs:653 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f277097a | EditButton | SCP0020_TactTime.cs:654 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e363d6a | EditButton | SCP0020_TactTime.cs:659 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | MESSAGE | MessageHelper.GMessageBox | ("MSG00199", new object[] { "Tact Time" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a666ea3 | EditButton | SCP0020_TactTime.cs:660 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c52f94d2 | EditButton | SCP0020_TactTime.cs:669 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8379044a | EditButton | SCP0020_TactTime.cs:673 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | FLAG | siExcept | GetSheetInfo(spdExcept.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c403c410 | EditButton | SCP0020_TactTime.cs:674 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | GRID_LOCK | siExcept.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d07f7721 | EditButton | SCP0020_TactTime.cs:676 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefColumns.DIVISION_ID), siExcept.GetColumnIndex(DefColumns.LINE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a15d4c8f | EditButton | SCP0020_TactTime.cs:677 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefColumns.CREATED_BY), siExcept.GetColumnIndex(DefColumns.LAST_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aab5eb31 | EditButton | SCP0020_TactTime.cs:681 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefColumns.DAILY_CAPACITY), siExcept.GetColumnIndex(DefColumns.DA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b72e870 | EditButton | SCP0020_TactTime.cs:684 | if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetI… | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefColumns.TACT_TIME), siExcept.GetColumnIndex(DefColumns.TACT_TI… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0020_TactTime.Find_Packer

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)] / SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3260b84f | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:950 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e6639dc3 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:954 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1eeb5810 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:954 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a19e2eac | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:956 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b245e55e | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:961 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPacker) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76875c20 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:974 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e7fcb3e3 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:976 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a52a3459 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:980 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_GET_TACT_TIME_OSP") ⇒ SCP.SCP0020_GET_TACT_TIME_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-7f79a923 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:981 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-950d9429 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:982 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-de708304 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:983 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-5d9320ea | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:984 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-d1a55ea8 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:985 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group_id"] | p_operation_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-57a44006 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:986 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e5ff8a52 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:987 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-1cc31d2b | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:989 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d46c791 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:991 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-273dc9ba | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:999 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6161ac95 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:1000 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c2cdb4f | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:1005 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b2244d9 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:1008 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aee274fa | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:1014 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ce60b5b6 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:1018 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9730af12 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCP0020_TactTime.cs:1023 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0020_TactTime.FindData_Except

진입점: spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdExcept") ▸ if (this.mainsheetNm== SpdSheet.shtMain) ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7ac516a | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1374 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3619c426 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1391 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7061ebb6 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1392 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-68398d12 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1393 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-53a3dbae | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1397 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_GET_TACT_TIME_EXCEPT") ⇒ SCP.SCP0020_GET_TACT_TIME_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-1d0b69ac | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1398 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-731f6947 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1399 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-e97a9a42 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1400 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-3821771b | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1401 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e9298fb6 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1402 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-dfadb97b | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1403 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7ce34425 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1405 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55475c92 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1407 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-61c9a974 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1415 | try | GRID_BIND | siExcept.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f6f467cb | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1416 | try | GRID_LOCK | siExcept.LockColumn | (0, siExcept.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-18cc6e2a | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1418 | try | GRID_INIT | siExcept.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30883020 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1421 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-26cb0267 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1430 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-eae964e6 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1435 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b300a6fe | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1440 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0020_TactTime.FindData_Except_Packer

진입점: spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdExcept") ▸ else of (this.mainsheetNm== SpdSheet.shtMain) ▸ if (this.mainsheetNm == SpdSheet.shtPacker) ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7444dd9 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1298 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c9f7cf48 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1315 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b5b52e8d | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1316 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0ed95a35 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1317 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-370134da | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1321 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP") ⇒ SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-d63cf7b5 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1322 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-68495e88 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1323 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-cd863aaf | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1324 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-2e9b27b0 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1325 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-106f5c8b | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1326 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce3d6c72 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1327 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-964dfc8d | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1329 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4586fb8d | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1331 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-404beccd | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1339 | try | GRID_BIND | siExcept.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2c3f9644 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1340 | try | GRID_LOCK | siExcept.LockColumn | (0, siExcept.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f02904bd | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1342 | try | GRID_INIT | siExcept.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-809334a4 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1345 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6a72b735 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1354 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c4dba623 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1359 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7565c5ed | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) … 외 1 | SCP0020_TactTime.cs:1364 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0020_TactTime.FindData_Main

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a4511a0 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1030 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a3e5eec1 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1034 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d32e710e | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1034 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec48d846 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1036 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5d8dec2b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1041 | try | FLAG | dtLineByOperationOfSpd | Data.Common(Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-ccd778dc | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1041 | try | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f389126d | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1045 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0fe8949 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1052 | try | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a10b7b6b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1061 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f8e1caaa | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1063 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3d1a7617 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1067 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_GET_TACT_TIME") ⇒ SCP.SCP0020_GET_TACT_TIME | 엔드포인트 요청 생성 |  |  |  |
| AC-fc8e60a1 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1068 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9bdfa6fa | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1069 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-a9c305f9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1070 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-8f949abd | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1071 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-9854d2f4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1072 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group_id"] | p_operation_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-328e88fa | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1073 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b9491c0 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1074 | try ▸ lambda | DATA_OP | request.Parameters["p_valid"] | pValid.Equals("ALL") ? DBNull.Value : pValid | 행/컬럼 값 대입 |  |  |  |
| AC-ae929b95 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1075 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ccfeb4c3 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1077 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a44c7996 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1079 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1876bc29 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1087 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-695787d6 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1088 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a4c436b5 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1095 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd699560 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1098 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7a64abd1 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1107 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0b53c12a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1112 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93e3998c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:1117 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0020_TactTime.FindData_Main_MaxValue

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4850adbe | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1127 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0f10b88c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1131 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1e28c73d | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1131 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d67085f9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1133 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-16ac0b31 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1181 | try | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d464095b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1184 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | nTactTimeMax_Plant | 0.0F | 화면 필드/플래그 변경 |  |  |  |
| AC-9520db33 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1188 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (boolConvStatus == false) | FLAG | nTactTimeMax_Plant | nMaxTactTime | 화면 필드/플래그 변경 |  |  |  |
| AC-b481dba4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1193 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | FLAG | nTactTimeMax_Plant | nMaxTactTime | 화면 필드/플래그 변경 |  |  |  |
| AC-81469a0d | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1196 | try | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-78fa8347 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1203 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c24522b4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1208 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f5897fd3 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1209 | catch ((Exception ex)) | FLAG | nTactTimeMax_Plant | nDefaultTactTimeMax | 화면 필드/플래그 변경 |  |  |  |
| AC-906222e4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… | SCP0020_TactTime.cs:1214 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0020_TactTime.FindData_Packer_MaxValue

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4193fa00 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1222 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d0e75dca | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1226 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-021a7547 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1226 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e98d9bc5 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1228 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-22683983 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1256 | try | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e36b196 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1259 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | nTactTimeMax_Packer | 0.0F | 화면 필드/플래그 변경 |  |  |  |
| AC-828af306 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1263 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (boolConvStatus == false) | FLAG | nTactTimeMax_Packer | nMaxTactTime | 화면 필드/플래그 변경 |  |  |  |
| AC-8e41b442 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1268 | try ▸ else of (ds.Tables[0].Rows.Count > 0) | FLAG | nTactTimeMax_Packer | nMaxTactTime | 화면 필드/플래그 변경 |  |  |  |
| AC-2fbad2ea | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1271 | try | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-2d3318a4 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1278 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f5a076ec | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1283 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2c946f4d | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1284 | catch ((Exception ex)) | FLAG | nTactTimeMax_Packer | nDefaultTactTimeMax | 화면 필드/플래그 변경 |  |  |  |
| AC-681e13ec | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… | SCP0020_TactTime.cs:1289 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0020_TactTime.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b6a835 | this.Load | SCP0020_TactTime.cs:184 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0020_TactTime.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e9fe199 | this.Load | SCP0020_TactTime.cs:212 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5725aee | this.Load | SCP0020_TactTime.cs:215 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-92f05af4 | this.Load | SCP0020_TactTime.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cb89e341 | this.Load | SCP0020_TactTime.cs:218 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-032ce258 | this.Load | SCP0020_TactTime.cs:220 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-976514e2 | this.Load | SCP0020_TactTime.cs:220 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f55fec50 | this.Load | SCP0020_TactTime.cs:221 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0020_TactTime.InitSpread

진입점: this.Load / spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f042598d | this.Load 외 3 | SCP0020_TactTime.cs:395 | if (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-56beaea9 | this.Load 외 3 | SCP0020_TactTime.cs:399 | if (spreadInfo.SheetName == SpdSheet.shtExcept) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineByOperation", dtLineByOperationOfSpd) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f57c76f | this.Load 외 3 | SCP0020_TactTime.cs:403 | if (spreadInfo.SheetName == SpdSheet.shtExcept) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineByOperation", dtLineByOperationOsp) | 목록 컨트롤 재구성 |  |  |  |
| AC-6629195c | this.Load 외 3 | SCP0020_TactTime.cs:406 | if (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6c9b059a | this.Load 외 3 | SCP0020_TactTime.cs:410 | if (spreadInfo.SheetName == SpdSheet.shtExcept) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex("DAILY_CAPACITY")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-dcbad2d1 | this.Load 외 3 | SCP0020_TactTime.cs:411 | if (spreadInfo.SheetName == SpdSheet.shtExcept) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex("OPERATION_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1f8e86dc | this.Load 외 3 | SCP0020_TactTime.cs:415 | if (spreadInfo.SheetName == SpdSheet.shtExcept) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex("DAILY_CAPACITY")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3b3c42ef | this.Load 외 3 | SCP0020_TactTime.cs:416 | if (spreadInfo.SheetName == SpdSheet.shtExcept) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_SET | spreadInfo.ActiveSheet.Columns[spreadInfo.GetColumnIndex("OPERATION_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9db6b1af | this.Load 외 3 | SCP0020_TactTime.cs:419 | if (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09f21c3e | this.Load 외 3 | SCP0020_TactTime.cs:425 | else of (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | siMain.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ae17560 | this.Load 외 3 | SCP0020_TactTime.cs:426 | else of (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPacker) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0020_TactTime.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38a6f0ab | InsertButton | SCP0020_TactTime.cs:752 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec2dfff1 | InsertButton | SCP0020_TactTime.cs:760 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77f24b71 | InsertButton | SCP0020_TactTime.cs:762 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8b4e2819 | InsertButton | SCP0020_TactTime.cs:781 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), strDIVISION_ID) | 그리드 값 설정 |  |  |  |
| AC-13e907b3 | InsertButton | SCP0020_TactTime.cs:782 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), strPLANT_SITE_ID) | 그리드 값 설정 |  |  |  |
| AC-cb546434 | InsertButton | SCP0020_TactTime.cs:783 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_NAME), strPLANT_SITE_N… | 그리드 값 설정 |  |  |  |
| AC-a93dbe0b | InsertButton | SCP0020_TactTime.cs:784 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), strITEM_ID) | 그리드 값 설정 |  |  |  |
| AC-aa7a6c62 | InsertButton | SCP0020_TactTime.cs:785 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_ID), strOPERATION_ID) | 그리드 값 설정 |  |  |  |
| AC-7ac0d665 | InsertButton | SCP0020_TactTime.cs:786 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_NAME), strOPERATION_NAM… | 그리드 값 설정 |  |  |  |
| AC-76f48fc2 | InsertButton | SCP0020_TactTime.cs:788 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), strNICK_NAME) | 그리드 값 설정 |  |  |  |
| AC-6de2fe57 | InsertButton | SCP0020_TactTime.cs:789 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-fe952452 | InsertButton | SCP0020_TactTime.cs:791 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa320c48 | InsertButton | SCP0020_TactTime.cs:792 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.JUMBO_MIN), siMain.GetColumnIndex(DefColumns.BI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb733d25 | InsertButton | SCP0020_TactTime.cs:795 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_ID), strOPERATION… | 그리드 값 설정 |  |  |  |
| AC-7da65e03 | InsertButton | SCP0020_TactTime.cs:796 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_ID), siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-410ec201 | InsertButton | SCP0020_TactTime.cs:802 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.ITEM_UOM), siMain.GetColumnIndex(DefColumns.TAC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-86b921ac | InsertButton | SCP0020_TactTime.cs:806 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DAILY_CAPACITY), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-63522477 | InsertButton | SCP0020_TactTime.cs:811 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.LANE_QTY), siMain.GetColumnIndex(DefColumns.LAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9463819d | InsertButton | SCP0020_TactTime.cs:817 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b2d315d | InsertButton | SCP0020_TactTime.cs:819 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0c30ef65 | InsertButton | SCP0020_TactTime.cs:837 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), strDIVISION_ID) | 그리드 값 설정 |  |  |  |
| AC-a048c0c3 | InsertButton | SCP0020_TactTime.cs:838 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SITE_DESCRIPTION), strSiteDescrip… | 그리드 값 설정 |  |  |  |
| AC-c59fbe9b | InsertButton | SCP0020_TactTime.cs:839 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), strITEM_ID) | 그리드 값 설정 |  |  |  |
| AC-b7eba106 | InsertButton | SCP0020_TactTime.cs:840 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), strNICK_NAME) | 그리드 값 설정 |  |  |  |
| AC-c3fabc0f | InsertButton | SCP0020_TactTime.cs:841 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), strPLANT_SITE_ID) | 그리드 값 설정 |  |  |  |
| AC-78cb12f4 | InsertButton | SCP0020_TactTime.cs:842 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_ID), strOPERATION_ID) | 그리드 값 설정 |  |  |  |
| AC-82cb30f7 | InsertButton | SCP0020_TactTime.cs:843 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INPUT_STATUS), "I") | 그리드 값 설정 |  |  |  |
| AC-5ee0e922 | InsertButton | SCP0020_TactTime.cs:844 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EXCEPT_YN), "N") | 그리드 값 설정 |  |  |  |
| AC-388204f8 | InsertButton | SCP0020_TactTime.cs:845 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OSP_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-b833207b | InsertButton | SCP0020_TactTime.cs:847 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3cbac30b | InsertButton | SCP0020_TactTime.cs:848 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TACT_TIME), siMain.GetColumnIndex(DefColumns.EX… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f715460e | InsertButton | SCP0020_TactTime.cs:849 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.OSP_YN), siMain.GetColumnIndex(DefColumns.OSP_Y… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d34b62e | InsertButton | SCP0020_TactTime.cs:852 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | dtComboIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec678497 | InsertButton | SCP0020_TactTime.cs:853 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | dtComboIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-970dd592 | InsertButton | SCP0020_TactTime.cs:855 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | dtLineByOperationOsp.Select | ("DIVISION_ID = '" + strDIVISION_ID + "' AND SCM_SITE_ID='" + strPLANT_SITE_ID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-81e7d9f4 | InsertButton | SCP0020_TactTime.cs:858 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | dtComboIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c30a38c7 | InsertButton | SCP0020_TactTime.cs:859 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b081fae | InsertButton | SCP0020_TactTime.cs:860 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-441b3637 | InsertButton | SCP0020_TactTime.cs:861 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | DATA_OP | dtComboIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-95774aee | InsertButton | SCP0020_TactTime.cs:864 | if (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (siMain != null && siMain.IsLock(siMai… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LINE_ID), dtComboIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f8894434 | InsertButton | SCP0020_TactTime.cs:875 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00161", new object[] { "Tact Time" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a320381e | InsertButton | SCP0020_TactTime.cs:876 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82387729 | InsertButton | SCP0020_TactTime.cs:910 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Line" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f113493 | InsertButton | SCP0020_TactTime.cs:911 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3bbc3909 | InsertButton | SCP0020_TactTime.cs:914 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | DATA_OP | siExcept.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8c1f3ed8 | InsertButton | SCP0020_TactTime.cs:917 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.DIVISION_ID), strDIVISION_ID) | 그리드 값 설정 |  |  |  |
| AC-5a84e964 | InsertButton | SCP0020_TactTime.cs:918 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.PLANT_SITE_ID), strPLANT_SITE… | 그리드 값 설정 |  |  |  |
| AC-a6c33fee | InsertButton | SCP0020_TactTime.cs:919 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.PLANT_SITE_NAME), strPLANT_SI… | 그리드 값 설정 |  |  |  |
| AC-15a91e40 | InsertButton | SCP0020_TactTime.cs:920 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.ITEM_ID), strITEM_ID) | 그리드 값 설정 |  |  |  |
| AC-dde82722 | InsertButton | SCP0020_TactTime.cs:921 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.OPERATION_ID), strOPERATION_I… | 그리드 값 설정 |  |  |  |
| AC-c414ec47 | InsertButton | SCP0020_TactTime.cs:922 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.OPERATION_NAME), strOPERATION… | 그리드 값 설정 |  |  |  |
| AC-fb9a4b37 | InsertButton | SCP0020_TactTime.cs:923 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.LINE_ID), strLINE_ID) | 그리드 값 설정 |  |  |  |
| AC-eebc3521 | InsertButton | SCP0020_TactTime.cs:924 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.NICK_NAME), strNICK_NAME) | 그리드 값 설정 |  |  |  |
| AC-92128f14 | InsertButton | SCP0020_TactTime.cs:925 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.USE_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-36cd1cab | InsertButton | SCP0020_TactTime.cs:928 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefColumns.DIVISION_ID), siExcept.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-39bf5462 | InsertButton | SCP0020_TactTime.cs:929 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefColumns.CREATED_BY), siExcept.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b838f760 | InsertButton | SCP0020_TactTime.cs:933 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefColumns.DAILY_CAPACITY), siExcept.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d604f353 | InsertButton | SCP0020_TactTime.cs:937 | else of (fps.Name == "spdMain" && (spdMain.ActiveSheetIndex == 0 \|\| spdMain.ActiveSheetIndex == 1)) ▸ if (fps.Name == "spdExcept") ▸ if (s… | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefColumns.TACT_TIME), siExcept.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0020_TactTime.RefreshLineByOperation

진입점: cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / clbPlantSite.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73a6c5d9 | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 2 | SCP0020_TactTime.cs:308 |  | FLAG | dtLineByOperation | DBUtils.Filter(dtLineByOperationAll, "DIVISION_ID = '" + division + "' AND FACTORY_ID = '"… | 화면 필드/플래그 변경 |  |  |  |
| AC-974c2b02 | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 2 | SCP0020_TactTime.cs:308 |  | DATA_OP | DBUtils.Filter | (dtLineByOperationAll, "DIVISION_ID = '" + division + "' AND FACTORY_ID = '" + pFactoryID … | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9c3ff756 | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 2 | SCP0020_TactTime.cs:310 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0020_TactTime.RefreshLineByOperationOfSpd

진입점: cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccc174b0 | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 1 | SCP0020_TactTime.cs:322 |  | FLAG | dtLineByOperationOfSpd | DBUtils.Filter(dtLineByOperationOfSpdAll, "DIVISION_ID = '" + division + "' AND FACTORY_ID… | 화면 필드/플래그 변경 |  |  |  |
| AC-5be15301 | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 1 | SCP0020_TactTime.cs:322 |  | DATA_OP | DBUtils.Filter | (dtLineByOperationOfSpdAll, "DIVISION_ID = '" + division + "' AND FACTORY_ID = '" + pFacto… | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0020_TactTime.RefreshLineByPlantPacker

진입점: this.Load / cboDivision.SelectedIndexChanged [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / clbPlantSite.SelectedIndexChanged [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtPacker)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64d30954 | this.Load 외 3 | SCP0020_TactTime.cs:332 |  | FLAG | dtLineByPlantPacker | DBUtils.Filter(dtLineByPlantPackerAll, "DIVISION_ID = '" + division + "' AND " + filterExp… | 화면 필드/플래그 변경 |  |  |  |
| AC-584d0d70 | this.Load 외 3 | SCP0020_TactTime.cs:332 |  | DATA_OP | DBUtils.Filter | (dtLineByPlantPackerAll, "DIVISION_ID = '" + division + "' AND " + filterExpression, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0bcd2c41 | this.Load 외 3 | SCP0020_TactTime.cs:334 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByPlantPacker, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0020_TactTime.RefreshPlantSiteByDivision

진입점: cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81b8bf38 | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 1 | SCP0020_TactTime.cs:294 |  | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1ea091d | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 1 | SCP0020_TactTime.cs:294 |  | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-177c11a7 | cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.She… 외 1 | SCP0020_TactTime.cs:296 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0020_TactTime.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39020c07 | SaveButton | SCP0020_TactTime.cs:524 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0020_TactTime.SaveData_Except

진입점: SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdExcept") ▸ if (this.mainsheetNm== SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34e398f5 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2117 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (siExcept.ActiveSheet.Rows.Count <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f40488e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2151 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siExcept) | 프레임워크 검증 |  |  |  |
| AC-12ec80fa | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2151 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!DataUtil.checkRequiredOfSpread(s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25526b69 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2152 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf4ecb8e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2153 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN5(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9961b3bc | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2154 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1390c66a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2168 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Tact Time : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40fac9ae | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2169 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b3e9abf | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2174 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "Yield : 1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5edd4821 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2175 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fda054b | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2180 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Yield : 100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5afee2e6 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2181 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaa34408 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2227 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_SAVE_TACT_TIME_EXCEPT") ⇒ SCP.SCP0020_SAVE_TACT_TIME_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-75edd2ff | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2229 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ecd545b1 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2232 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag" ] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-9357cdf7 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2233 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6c031fd2 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2234 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-832797bd | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2235 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-500f1448 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2236 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc4db47f | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2237 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-f5acd9c8 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2238 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time_start_date"] | p_tact_time_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-c62437af | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2239 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time_end_date"] | p_tact_time_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-0dc71c19 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2240 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time"] | p_tact_time | 행/컬럼 값 대입 |  |  |  |
| AC-eaca57dc | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2241 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_yield"] | p_yield | 행/컬럼 값 대입 |  |  |  |
| AC-158b5ce1 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2242 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_except_comment"] | p_except_comment | 행/컬럼 값 대입 |  |  |  |
| AC-31ff148c | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2243 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_use_yn"] | p_use_yn | 행/컬럼 값 대입 |  |  |  |
| AC-70938f5a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2244 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2335837a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2245 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d9341fdf | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2246 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_plant_site_id"] | p_org_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-418de29d | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2247 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_item_id"] | p_org_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0aa637b | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2248 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_operation_id"] | p_org_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-874e1c61 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2249 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_line_id"] | p_org_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-a25826de | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2250 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_tact_time_start_date"] | p_org_tact_time_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-24a1e618 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2251 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_tact_time_end_date"] | p_org_tact_time_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-e6bb1480 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2253 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-58b536c0 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2255 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2ec8ccc5 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2255 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-14b3e16f | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2263 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba509a7a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2275 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b11f636a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2289 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | GRID_STYLE | siExcept.SetBGColor | (i, siExcept.GetColumnIndex(DefColumns.TACT_TIME_START_DATE), i, siExcept.GetColumnIndex(D… | 그리드 표시 설정 |  |  |  |
| AC-89038d8a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2299 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0020_TactTime.SaveData_Except_Packer

진입점: SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1) ▸ if (fps.Name == "spdExcept") ▸ else of (this.mainsheetNm== SpdSheet.shtMain) ▸ if (this.mainsheetNm == SpdSheet.shtPacker)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5fb07e1 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1911 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (siExcept.ActiveSheet.Rows.Count <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a4820a7 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1946 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siExcept) | 프레임워크 검증 |  |  |  |
| AC-485148c5 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1946 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!DataUtil.checkRequiredOfSpread(s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7586fb83 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1947 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee37822b | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1948 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN5(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d87436a4 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1949 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a2985c9 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1963 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Tact Time : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19c83d49 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1964 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b64e601 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1969 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "Yield : 1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c66240e6 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1970 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5ae0e95 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1975 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Yield : 100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-562af251 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1976 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb4b6ee3 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2023 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP") ⇒ SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-58a783d1 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2025 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e2cb44a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2028 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e5ffd42c | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2029 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1d412eed | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2030 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d545daeb | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2031 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5624b81c | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2032 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-df737c7c | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2033 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ee46700 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2034 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time_start_date"] | p_tact_time_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-4cdae26e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2035 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time_end_date"] | p_tact_time_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-b400cdb9 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2036 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time"] | p_tact_time | 행/컬럼 값 대입 |  |  |  |
| AC-341d5c50 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2037 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_yield"] | p_yield | 행/컬럼 값 대입 |  |  |  |
| AC-4d326f35 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2038 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_except_comment"] | p_except_comment | 행/컬럼 값 대입 |  |  |  |
| AC-b0118de3 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2039 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_daily_capacity"] | p_daily_capacity | 행/컬럼 값 대입 |  |  |  |
| AC-415423f4 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2040 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_use_yn"] | p_use_yn | 행/컬럼 값 대입 |  |  |  |
| AC-bf5505ba | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2041 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9ecc12d | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2042 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8bf0d087 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2043 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_plant_site_id"] | p_org_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-847cdd27 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2044 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_item_id"] | p_org_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc1cda57 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2045 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_operation_id"] | p_org_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-66934a17 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2046 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_line_id"] | p_org_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-73d5fbc5 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2047 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_tact_time_start_date"] | p_org_tact_time_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-b3fe5489 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2048 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_tact_time_end_date"] | p_org_tact_time_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-8beb87d0 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2050 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-26dfbe8e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2052 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-156c4456 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2052 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-80d236c9 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2060 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8618e21 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2072 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-455a88b3 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2086 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | GRID_STYLE | siExcept.SetBGColor | (i, siExcept.GetColumnIndex(DefColumns.TACT_TIME_START_DATE), i, siExcept.GetColumnIndex(D… | 그리드 표시 설정 |  |  |  |
| AC-0f8a8364 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:2096 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0020_TactTime.SaveData_Main

진입점: SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b36a47be | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1658 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbd16da3 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1687 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-9eecc3aa | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1687 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14585b64 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1704 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Priority : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d37ea13d | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1705 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d89f2382 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1711 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Tact Time : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30390bc6 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1712 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7a76bd8 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1717 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "Yield : 1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b633b90a | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1718 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d23a1517 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1722 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Yield : 100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dac063d2 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1723 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-018b65cb | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1750 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (acti… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Slitting Lane" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0583e973 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1751 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f67fc99 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1797 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_SAVE_TACT_TIME") ⇒ SCP.SCP0020_SAVE_TACT_TIME | 엔드포인트 요청 생성 |  |  |  |
| AC-0cdfdb8d | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1801 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d913e47d | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1802 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-972612a3 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1803 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-912f0aca | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1804 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-64a1c408 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1805 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-52c9dee8 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1806 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-3085edac | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1807 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-fabfbd41 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1808 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_tact_time"] | p_tact_time | 행/컬럼 값 대입 |  |  |  |
| AC-4d363945 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1809 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yield"] | p_yield | 행/컬럼 값 대입 |  |  |  |
| AC-ec2477c8 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1810 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-3c2e1130 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1817 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_input_status"] | p_input_status | 행/컬럼 값 대입 |  |  |  |
| AC-55262e48 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1818 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_uom"] | p_item_uom | 행/컬럼 값 대입 |  |  |  |
| AC-8463fece | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1819 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_uom_convert_value"] | p_uom_convert_value | 행/컬럼 값 대입 |  |  |  |
| AC-a9b7747f | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1820 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_lane_qty"] | p_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-f1c2a143 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1822 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4390500c | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1823 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9ae80353 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1825 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2444a4f | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1830 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e57ecdb8 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1844 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ab82378 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1866 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.LIN… | 그리드 표시 설정 |  |  |  |
| AC-2086908f | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1876 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0721ecd3 | SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheet… | SCP0020_TactTime.cs:1886 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0020_TactTime.SaveData_Packer

진입점: SaveButton [else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7687e192 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1454 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2ae24c9 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1472 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-e8fb210a | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1472 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95c9753e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1491 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Priority : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65bd7af5 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1492 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77fbc407 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1498 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Tact Time : 0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82624575 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1499 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69a312b3 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1504 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "Yield : 1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f655fa72 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1505 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42c4f5f9 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1509 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Yield : 100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b55937c | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1510 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (De… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1cb5e30 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1560 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_SAVE_TACT_TIME_OSP") ⇒ SCP.SCP0020_SAVE_TACT_TIME_OSP | 엔드포인트 요청 생성 |  |  |  |
| AC-04b6187e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1562 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 60 * 15 | 속성 CommandTimeout 설정 |  |  |  |
| AC-273e4d9b | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1564 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-44fefe07 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1565 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-36e28caa | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1566 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea30b815 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1567 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-32fb939f | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1568 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-1753efb2 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1569 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2ad43a1 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1570 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-619fed55 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1571 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_tact_time"] | p_tact_time | 행/컬럼 값 대입 |  |  |  |
| AC-6f27e82f | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1572 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yield"] | p_yield | 행/컬럼 값 대입 |  |  |  |
| AC-e45d3edf | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1573 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-9148edb8 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1574 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_daily_capacity"] | p_daily_capacity | 행/컬럼 값 대입 |  |  |  |
| AC-71db3044 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1575 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9182f808 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1576 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2b1b62e4 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1578 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4217c4e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1583 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSe… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2602bf06 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1602 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.D… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { errStr }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e4f8cf6 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1615 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.D… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.LIN… | 그리드 표시 설정 |  |  |  |
| AC-1515604e | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1624 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.D… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f691ad3 | SaveButton [else of (fps.Name == "spdMain" && spdMain.Active… | SCP0020_TactTime.cs:1634 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtPacker) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0020_TactTime.SetChangedControl_Osp

진입점: this.Load / cboDivision.SelectedIndexChanged [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtPacker)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f6be21f | this.Load 외 2 | SCP0020_TactTime.cs:350 | if (cboDivision.ControlValues == null \|\| cboDivision.ControlValues.Equals("ALL")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d08c861 | this.Load 외 2 | SCP0020_TactTime.cs:354 |  | DATA_OP | dtPlantSiteByDivisionPacker.Select | ("DIVISION_ID = '" + division + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-13966499 | this.Load 외 2 | SCP0020_TactTime.cs:361 | foreach (DataRow dr in drArr) | DATA_OP | dtPlantSiteOspIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3dd2aae4 | this.Load 외 2 | SCP0020_TactTime.cs:362 | foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d0e65848 | this.Load 외 2 | SCP0020_TactTime.cs:363 | foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d23e8fdf | this.Load 외 2 | SCP0020_TactTime.cs:364 | foreach (DataRow dr in drArr) | DATA_OP | dtPlantSiteOspIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-94286f70 | this.Load 외 2 | SCP0020_TactTime.cs:366 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteOspIns, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0020_TactTime.setExceptYnColor

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47a93d1c | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCP0020_TactTime.cs:2599 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sExceptYn == "Y") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |

## SCP0020_TactTime.SetSpreadInit

진입점: this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExcept)] / spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ else of (spreadInfo.SheetName == SpdSheet.shtExcept)] / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) ▸ try] / SaveButton [if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0663d297 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:435 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e546493 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:436 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-7eff1b51 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:437 | if (sheetName.Equals(SpdSheet.shtMain)) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineByOperation", dtLineByOperationOfSpd) | 목록 컨트롤 재구성 |  |  |  |
| AC-f2b97b8f | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:438 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b773e00c | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:439 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.PRIORITY), 0, 0, 99) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f864d864 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:440 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-916d667d | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:442 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_SET | siMain.ActiveSheet.Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-747247d6 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:446 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63268417 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:447 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-d45e46ed | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:448 | else of (sheetName.Equals(SpdSheet.shtMain)) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineByOperationOsp", dtLineByOperationOsp) | 목록 컨트롤 재구성 |  |  |  |
| AC-21133435 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:449 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f5a0bd51 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:450 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.PRIORITY), 0, 0, 99) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-58a4dd51 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:451 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3153b0f9 | this.Load [else of (spreadInfo.SheetName == SpdSheet.shtExce… 외 3 | SCP0020_TactTime.cs:452 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0020_TactTime.SpdExcept_Changed

진입점: dsdmExcept.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b28ec87a | dsdmExcept.Changed | SCP0020_TactTime.cs:2654 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e4e028f | dsdmExcept.Changed | SCP0020_TactTime.cs:2655 | if (siExcept == null \|\| siExcept.IsLock(siExcept.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b37d6c9 | dsdmExcept.Changed | SCP0020_TactTime.cs:2667 | if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExcept) | FLAG | this._siExceptCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-db284b6b | dsdmExcept.Changed | SCP0020_TactTime.cs:2668 | if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExcept) | FLAG | this._siExceptCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-efdc8cfc | dsdmExcept.Changed | SCP0020_TactTime.cs:2673 | if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExcept) ▸ if (siExcept.GetColumnIndex(DefColumns.DAILY_CAPACITY) != nCol) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76a4140b | dsdmExcept.Changed | SCP0020_TactTime.cs:2680 | if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExcept) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated) ▸ … | GRID_SET | siExcept.SetValue | (nRow, siExcept.GetColumnIndex(DefColumns.TACT_TIME), 0) | 그리드 값 설정 |  |  |  |
| AC-1d9a1d5e | dsdmExcept.Changed | SCP0020_TactTime.cs:2685 | if (siExcept.ActiveSheet.SheetName == SpdSheet.shtExcept) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated) ▸ … | GRID_SET | siExcept.SetValue | (nRow, siExcept.GetColumnIndex(DefColumns.TACT_TIME), tactTime) | 그리드 값 설정 |  |  |  |

## SCP0020_TactTime.spdExcept_EditChange

진입점: this.spdExcept.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-468bd35d | this.spdExcept.EditChange | SCP0020_TactTime.cs:2830 |  | FLAG | this._siExceptCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-3100b65e | this.spdExcept.EditChange | SCP0020_TactTime.cs:2831 |  | FLAG | this._siExceptCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0020_TactTime.SpdExcept_TopChange

진입점: spdExcept.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f238ce91 | spdExcept.TopChange | SCP0020_TactTime.cs:242 |  | GRID_INIT | siExcept.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0020_TactTime.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-906fd411 | this.spdMain.ActiveSheetChanged | SCP0020_TactTime.cs:2792 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25773837 | this.spdMain.ActiveSheetChanged | SCP0020_TactTime.cs:2793 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d650fb34 | this.spdMain.ActiveSheetChanged | SCP0020_TactTime.cs:2799 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPacker) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e107fd07 | this.spdMain.ActiveSheetChanged | SCP0020_TactTime.cs:2800 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPacker) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0020_TactTime.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f34bbfbc | spdMain.CellClick | SCP0020_TactTime.cs:2567 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1f19623 | spdMain.CellClick | SCP0020_TactTime.cs:2581 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false && siMain.ActiveS…) ▸ if (e.Colum… | FLAG | dtLineByOperationOfSpd | DBUtils.Filter(dtLineByOperationOfSpdAll, "DIVISION_ID = '" + division + "' AND FACTORY_ID… | 화면 필드/플래그 변경 |  |  |  |
| AC-1961c215 | spdMain.CellClick | SCP0020_TactTime.cs:2581 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false && siMain.ActiveS…) ▸ if (e.Colum… | DATA_OP | DBUtils.Filter | (dtLineByOperationOfSpdAll, "DIVISION_ID = '" + division + "' AND FACTORY_ID = '" + pFacto… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5775a17c | spdMain.CellClick | SCP0020_TactTime.cs:2583 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false && siMain.ActiveS…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtLineByOperationOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0020_TactTime.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8c2a2a8 | spdMain.CellDoubleClick | SCP0020_TactTime.cs:249 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-092fb2df | spdMain.CellDoubleClick | SCP0020_TactTime.cs:258 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4a73d998 | spdMain.CellDoubleClick | SCP0020_TactTime.cs:259 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-15fc63d7 | spdMain.CellDoubleClick | SCP0020_TactTime.cs:263 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this.mainsheetNm | SpdSheet.shtMain | 화면 필드/플래그 변경 |  |  |  |
| AC-824875e7 | spdMain.CellDoubleClick | SCP0020_TactTime.cs:268 | if (!e.ColumnHeader && e.Row >= 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this.mainsheetNm | SpdSheet.shtPacker | 화면 필드/플래그 변경 |  |  |  |

## SCP0020_TactTime.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c7cc1f7 | dsdmMain.Changed | SCP0020_TactTime.cs:2608 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89b19bb9 | dsdmMain.Changed | SCP0020_TactTime.cs:2609 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cb25389 | dsdmMain.Changed | SCP0020_TactTime.cs:2621 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-03c7444a | dsdmMain.Changed | SCP0020_TactTime.cs:2622 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-2823e169 | dsdmMain.Changed | SCP0020_TactTime.cs:2627 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefColumns.TACT_TIME) != nCol && siMain.GetColumnIndex(Def… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfe5e618 | dsdmMain.Changed | SCP0020_TactTime.cs:2630 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.GetText(nRow, siMain.GetColumnIndex(DefColumns.OPERATION_GROU… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72593eb1 | dsdmMain.Changed | SCP0020_TactTime.cs:2639 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated) ▸ if (… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.JUMBO_MIN), 0) | 그리드 값 설정 |  |  |  |
| AC-5ec09b34 | dsdmMain.Changed | SCP0020_TactTime.cs:2644 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated) ▸ else… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.JUMBO_MIN), jumboMin) | 그리드 값 설정 |  |  |  |

## SCP0020_TactTime.SpdMain_Changed_Packer

진입점: dsdmMainPacker.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb9f4100 | dsdmMainPacker.Changed | SCP0020_TactTime.cs:2699 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e5e89a8 | dsdmMainPacker.Changed | SCP0020_TactTime.cs:2700 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17d712d5 | dsdmMainPacker.Changed | SCP0020_TactTime.cs:2710 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (siMain.GetColumnIndex(DefColumns.DAILY_CAPACITY) != nCol) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-015a5809 | dsdmMainPacker.Changed | SCP0020_TactTime.cs:2717 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated) ▸ if… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.TACT_TIME), 0) | 그리드 값 설정 |  |  |  |
| AC-b7d70296 | dsdmMainPacker.Changed | SCP0020_TactTime.cs:2722 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPacker) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated) ▸ el… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.TACT_TIME), tactTime) | 그리드 값 설정 |  |  |  |

## SCP0020_TactTime.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38df075e | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2749 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | dtLine.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4147defd | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2750 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | dtLine.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce109142 | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2757 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | dtLineByOperationOfSpdAll.Select | ("OPERATION_ID = '" + pOperationID + "' AND SCM_SITE_ID = '" + pPlantSiteID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9aac2a7 | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2761 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | dtLineByOperationOsp.Select | ("DIVISION_ID = '" + division + "' AND SCM_SITE_ID='" + pPlantSiteID + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb9b2428 | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2768 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | dtLine.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5196017b | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2769 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-510b40e8 | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2770 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-106cf784 | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2771 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | dtLine.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e83464c4 | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2773 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, iCol, dtLine) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5058bf1f | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2775 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | DATA_OP | dtLine.Select | ("CODE = '" + lineId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-916bdfef | spdMain.ClipboardPasted | SCP0020_TactTime.cs:2778 | if (fps != null) ▸ if (fps.Name == "spdMain" && siMain.IsLock(siMain.SheetName) == false && siMain.Sheet().Rows.Count > 0 && (siMain.ActiveS… | GRID_SET | siMain.SetValue | (iRow, iCol, lineId) | 그리드 값 설정 |  |  |  |

## SCP0020_TactTime.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbb9afa5 | this.spdMain.EditChange | SCP0020_TactTime.cs:2809 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8df5e87a | this.spdMain.EditChange | SCP0020_TactTime.cs:2810 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0020_TactTime.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e8d2170 | spdMain.TopChange | SCP0020_TactTime.cs:277 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0020_TactTime.UnLockOnlyOSP

진입점: EditButton [if (fps != null) ▸ else of (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-099febc4 | EditButton [if (fps != null) ▸ else of (fps.Name == "spdMain… | SCP0020_TactTime.cs:707 | try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (sTemp.ToUpper() != "Y") | GRID_SET | siMain.ActiveSheet.Rows[iRow].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-53e6911b | EditButton [if (fps != null) ▸ else of (fps.Name == "spdMain… | SCP0020_TactTime.cs:708 | try ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (sTemp.ToUpper() != "Y") | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |

