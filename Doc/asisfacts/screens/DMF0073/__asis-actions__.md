# AS-IS 액션 대조표 — DMF0073

> 원천: `Doc/asisfacts/screens/DMF0073/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 70행 · 메서드 13 · 종류 DATA_OP 16 · FLAG 15 · ENDPOINT 7 · UI_MISC 6 · RETURN 6 · MESSAGE 5 · GRID_LOCK 4 · GRID_INIT 3 · UI_PROP 2 · VALUE_SET 2 · GRID_BIND 1 · COMBO_DATA 1 · LIST_REBIND 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 0


## DMF0073_VersionBySalesPricePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3daef551 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0073_VersionBySalesPricePopup.cs:330 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b5c2096a | this.btnButtonList.UsrButtonList_Click_Detected | DMF0073_VersionBySalesPricePopup.cs:334 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0073_VersionBySalesPricePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcfc9306 | this.Load | DMF0073_VersionBySalesPricePopup.cs:135 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f4f41378 | this.Load | DMF0073_VersionBySalesPricePopup.cs:136 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb5c8713 | this.Load | DMF0073_VersionBySalesPricePopup.cs:137 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0073_VersionBySalesPricePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8cbc147 | this.Load | DMF0073_VersionBySalesPricePopup.cs:127 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-21e9c1ff | this.Load | DMF0073_VersionBySalesPricePopup.cs:130 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0073_VersionBySalesPricePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a45e0d3 | Dispose | DMF0073_VersionBySalesPricePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0073_VersionBySalesPricePopup.FindData

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6eeb481 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:203 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-520728e0 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:207 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0073_GET_VERSION_SALESPRICE") ⇒ DM.DMF0073_GET_VERSION_SALESPRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-5533a1b2 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:208 | lambda | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-5a8c005c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:209 | lambda | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-df95814e | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:210 | lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-640524e7 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:211 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-36dfa5d4 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:212 | lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-c8a0df13 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:213 | lambda | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-65aa9a1f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:214 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91dda61a | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:216 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-10dd99ce | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:220 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1f12d245 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:221 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b330aa1 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:228 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DMF0073_VersionBySalesPricePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a589143 | this.Load | DMF0073_VersionBySalesPricePopup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-57d0eb06 | this.Load | DMF0073_VersionBySalesPricePopup.cs:100 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6b9b24f2 | this.Load | DMF0073_VersionBySalesPricePopup.cs:108 |  | FLAG | sCode | _Code | 화면 필드/플래그 변경 |  |  |  |
| AC-6d373674 | this.Load | DMF0073_VersionBySalesPricePopup.cs:109 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-c76cccfb | this.Load | DMF0073_VersionBySalesPricePopup.cs:110 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-ef7e8b49 | this.Load | DMF0073_VersionBySalesPricePopup.cs:111 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |

## DMF0073_VersionBySalesPricePopup.GetSpdTitle

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dca6ff6 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:445 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-36bf07e2 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:446 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-01c18be0 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:447 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-54c3b41c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:448 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6885acdb | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:449 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0073" | 행/컬럼 값 대입 |  |  |  |
| AC-ce789d62 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:450 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-db59e885 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:451 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-51662d2f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:453 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a90256b | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:455 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0073_VersionBySalesPricePopup.GridEdit

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90a646fa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:414 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d50e91d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:415 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ce78fac6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:417 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d2d8645 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:432 | if (this.fps != null) ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.EDITABLE)).ToString… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.MONTHLY_ROLLING_FCST), i, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0073_VersionBySalesPricePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c52e0547 | this.Load | DMF0073_VersionBySalesPricePopup.cs:119 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d61e5b78 | this.Load | DMF0073_VersionBySalesPricePopup.cs:119 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ba0f7e2 | this.Load | DMF0073_VersionBySalesPricePopup.cs:120 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-73c623b8 | this.Load | DMF0073_VersionBySalesPricePopup.cs:122 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |

## DMF0073_VersionBySalesPricePopup.InitSpread

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb2c10eb | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:147 |  | FLAG | dtTitle | GetSpdTitle(siMain.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-d914e614 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0073_VersionBySalesPricePopup.cs:148 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0073_VersionBySalesPricePopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0bd818f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumns.MONTHLY_ROLLING_FCST }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-debe25b3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (i, siMain.GetColumnIndex(DefColumns.MONTHLY_ROLLING_FCST)) | 그리드 표시 설정 |  |  |  |
| AC-11a2adb1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:251 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ac23ec1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:266 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0073_SAVE_VERSION_SALESPRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-9d0e8dc4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try | DATA_OP | request.Parameters["P_DIVISION_ID"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-bfc0e4c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try | DATA_OP | request.Parameters["P_VERSION_NO"] | sVERSION_NO | 행/컬럼 값 대입 |  |  |  |
| AC-184b566f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try | DATA_OP | request.Parameters["P_MONTHLY_ROLLING_FCST"] | sROLLING_FCST | 행/컬럼 값 대입 |  |  |  |
| AC-96fb1ada | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:270 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try | DATA_OP | request.Parameters["P_USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-92557ef4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:273 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2ba34c44 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:277 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c358bbed | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d08c82c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:284 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ try… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0012981f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:292 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sROLLING_FCST != "") ▸ cat… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a584c01 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0073_VersionBySalesPricePopup.cs:300 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sROLLING_FCST != "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0073_VersionBySalesPricePopup.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc9d68c2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:357 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6c824228 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:359 |  | FLAG | sPeriod | drpPeriod.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-d8f64b41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:374 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-19973511 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:375 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | CreateDate | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.CREATION_DATE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4b2f2b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:379 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | sVersions + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-bcc5fa4d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:394 | else of (bMulltiSelect) | FLAG | sVersions | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ef8c66f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:395 | else of (bMulltiSelect) | FLAG | CreateDate | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CREATION_DATE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee00f78f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0073_VersionBySalesPricePopup.cs:398 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0073_VersionBySalesPricePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b923f3c | this.spdMain.CellDoubleClick | DMF0073_VersionBySalesPricePopup.cs:348 | if (!siMain.IsLock()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cade4d34 | this.spdMain.CellDoubleClick | DMF0073_VersionBySalesPricePopup.cs:351 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

