# AS-IS 액션 대조표 — SCP0042

> 원천: `Doc/asisfacts/screens/SCP0042/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 244행 · 메서드 24 · 종류 DATA_OP 59 · RETURN 31 · MESSAGE 21 · GRID_SET 17 · GRID_LOCK 16 · GRID_INIT 15 · FLAG 14 · ENDPOINT 11 · LIST_REBIND 9 · GRID_STYLE 8 · UI_MISC 8 · POPUP 7 · CALL_EXT 7 · COMBO_DATA 7 · UI_PROP 5 · VALIDATE 4 · GRID_BIND 2 · VALUE_SET 1 · STATE_RESET 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 7


## SCP0042_TactTime_Test.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716e713e | this.btnItemId.Click | SCP0042_TactTime_Test.cs:1325 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d9c8c9f4 | this.btnItemId.Click | SCP0042_TactTime_Test.cs:1327 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6072a5b7 | this.btnItemId.Click | SCP0042_TactTime_Test.cs:1328 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-927087d9 | this.btnItemId.Click | SCP0042_TactTime_Test.cs:1329 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-44261821 | this.btnItemId.Click | SCP0042_TactTime_Test.cs:1335 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0042_TactTime_Test.checkValidN5

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c66c67d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1173 | for (i < dt.Rows.Count) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a8057fe | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1176 | for (i < dt.Rows.Count) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-de430b8a | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1182 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TACT_TIME_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-cee0b572 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1183 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.TACT_TIME_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a2d9c6b | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1202 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a3b9898 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1203 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d5a68aa | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1213 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92b8da3a | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1214 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-673be54c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1216 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-ac2da4f4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1217 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if ((nLOSS_START_DATE >= nCp_LOSS_START_DATE && nLOSS_START_DATE <= nCp_LOSS_END_DATE) \… | GRID_STYLE | siExcept.SetBGColor | (changeCpRowIdx, iColIdx1, changeCpRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-2199f4d1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1227 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00105", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1cc776e6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1230 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0042_TactTime_Test.checkValidN8

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-581a0fda | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1246 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f93995df | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1247 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-9e20c98e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1257 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_START_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-e94755f4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1258 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.TACT_TIME_END_DATE) | 데이터 객체 조작/조회 |  |  |  |
| AC-af2480fa | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1262 | for (i < dt.Rows.Count) ▸ if (str_START_DATE == string.Empty \|\| str_END_DATE == string.Empty) | GRID_STYLE | siExcept.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-b8ed05ff | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1263 | for (i < dt.Rows.Count) ▸ if (str_START_DATE == string.Empty \|\| str_END_DATE == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5f7aa452 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1272 | for (i < dt.Rows.Count) ▸ if (intLOSS_START_DATE > intLOSS_END_DATE) | CALL_EXT | siExcept.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78568995 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1275 | for (i < dt.Rows.Count) ▸ if (intLOSS_START_DATE > intLOSS_END_DATE) | GRID_STYLE | siExcept.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-cd0e424d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1285 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46c3ef15 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1288 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0042_TactTime_Test.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15e81a82 | clbPlantSite.SelectedIndexChanged | SCP0042_TactTime_Test.cs:1310 |  | FLAG | dtLineByOperation | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-1bcc7655 | clbPlantSite.SelectedIndexChanged | SCP0042_TactTime_Test.cs:1310 |  | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f64706d6 | clbPlantSite.SelectedIndexChanged | SCP0042_TactTime_Test.cs:1311 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0042_TactTime_Test.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fec329e9 | (진입점 미연결) | SCP0042_TactTime_Test.cs:227 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e2442a97 | (진입점 미연결) | SCP0042_TactTime_Test.cs:228 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0042_TactTime_Test.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94f00e8d | this.Load | SCP0042_TactTime_Test.cs:258 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1b8e09c7 | this.Load | SCP0042_TactTime_Test.cs:259 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4137c16 | this.Load | SCP0042_TactTime_Test.cs:260 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3454a677 | this.Load | SCP0042_TactTime_Test.cs:264 |  | GRID_INIT | this.AddSheet | (spdExcept, SpdSheet.shtExcept, SpdSheet.shtExcept, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89c36451 | this.Load | SCP0042_TactTime_Test.cs:265 |  | FLAG | siExcept | GetSheetInfo(spdExcept.Name, spdExcept.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-245d48c3 | this.Load | SCP0042_TactTime_Test.cs:266 |  | GRID_INIT | siExcept.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0042_TactTime_Test.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f815ffaf | DeleteButton | SCP0042_TactTime_Test.cs:446 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ccf3a005 | DeleteButton | SCP0042_TactTime_Test.cs:451 | if (fps.Name == "spdMain") ▸ if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a3f0f5b | DeleteButton | SCP0042_TactTime_Test.cs:452 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b90439a3 | DeleteButton | SCP0042_TactTime_Test.cs:455 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21133ed4 | DeleteButton | SCP0042_TactTime_Test.cs:459 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") | DATA_OP | siExcept.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0042_TactTime_Test.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afe851e4 | Dispose | SCP0042_TactTime_Test.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0042_TactTime_Test.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c3ebcf2 | EditButton | SCP0042_TactTime_Test.cs:402 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1da4d80f | EditButton | SCP0042_TactTime_Test.cs:403 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d801d92f | EditButton | SCP0042_TactTime_Test.cs:405 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d70a9ddf | EditButton | SCP0042_TactTime_Test.cs:406 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.BOM_MIN_DUE_DATE), siMain.GetColumnIndex(DefColumns.BIG_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-282d6bca | EditButton | SCP0042_TactTime_Test.cs:407 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DAILY_CAPACITY), siMain.GetColumnIndex(DefColumns.UOM_CO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d4cd25b0 | EditButton | SCP0042_TactTime_Test.cs:413 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (siMain.ActiveSheet.GetText(i, siMain.GetColumnIn… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LINE_ID), i, siMain.GetColumnIndex(DefColumns.LINE_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-43fd2a35 | EditButton | SCP0042_TactTime_Test.cs:417 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrEmpty(strMODEL_SITE)) | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LINE_ID), i, siMain.GetColumnIndex(DefColumns.TACT_TI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a8d992b | EditButton | SCP0042_TactTime_Test.cs:424 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction]… | MESSAGE | MessageHelper.GMessageBox | ("MSG00199", new object[] { "Tac Time" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dee79337 | EditButton | SCP0042_TactTime_Test.cs:425 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction]… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a1f1af64 | EditButton | SCP0042_TactTime_Test.cs:432 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (string.IsNullOrEmpty(strMODEL_SITE)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ae9dc89 | EditButton | SCP0042_TactTime_Test.cs:434 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") | FLAG | siExcept | GetSheetInfo(spdExcept.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-91032c17 | EditButton | SCP0042_TactTime_Test.cs:435 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") | GRID_LOCK | siExcept.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-fae0b41d | EditButton | SCP0042_TactTime_Test.cs:437 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefColumns.DIVISION_ID), siExcept.GetColumnIndex(DefColumns.LINE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e06d2914 | EditButton | SCP0042_TactTime_Test.cs:438 | if (fps != null) ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") | GRID_LOCK | siExcept.LockColumn | (siExcept.GetColumnIndex(DefColumns.CREATED_BY), siExcept.GetColumnIndex(DefColumns.LAST_U… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0042_TactTime_Test.FindData_Except

진입점: spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d4edbd7 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:655 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ee18ad8c | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:672 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1a0caf77 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:673 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9e41a584 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:674 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-991fd9e8 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:678 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_GET_TACT_TIME_EXCEPT") ⇒ SCP.SCP0020_GET_TACT_TIME_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-1339e0f6 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:679 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b997eaa1 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:680 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-49388c75 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:681 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2395106 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:682 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-33713df9 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:683 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b76e18c8 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:684 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-b4dd64c5 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:686 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c8d93c9 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:688 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7df7077a | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:696 | try | GRID_BIND | siExcept.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ecf6d5cb | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:697 | try | GRID_LOCK | siExcept.LockColumn | (0, siExcept.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8ad5dccb | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:699 | try | GRID_INIT | siExcept.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64a15d62 | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:702 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f3ff664b | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:711 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0905783c | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:716 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6993c4ca | spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] 외 1 | SCP0042_TactTime_Test.cs:721 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0042_TactTime_Test.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e28a63c8 | FindButton 외 1 | SCP0042_TactTime_Test.cs:564 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-08d88891 | FindButton 외 1 | SCP0042_TactTime_Test.cs:568 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-55c630e9 | FindButton 외 1 | SCP0042_TactTime_Test.cs:568 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7e64aab | FindButton 외 1 | SCP0042_TactTime_Test.cs:570 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5db9b502 | FindButton 외 1 | SCP0042_TactTime_Test.cs:579 | try | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0267dbe6 | FindButton 외 1 | SCP0042_TactTime_Test.cs:584 | try | FLAG | dtLineByOperationOfSpd | Data.Common(Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-49dcd333 | FindButton 외 1 | SCP0042_TactTime_Test.cs:584 | try | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e593e17 | FindButton 외 1 | SCP0042_TactTime_Test.cs:590 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b3c50f4e | FindButton 외 1 | SCP0042_TactTime_Test.cs:592 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d71a5cff | FindButton 외 1 | SCP0042_TactTime_Test.cs:596 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_GET_TACT_TIME") ⇒ SCP.SCP0020_GET_TACT_TIME | 엔드포인트 요청 생성 |  |  |  |
| AC-83a0aff3 | FindButton 외 1 | SCP0042_TactTime_Test.cs:597 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-15aabb3e | FindButton 외 1 | SCP0042_TactTime_Test.cs:598 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-df562be5 | FindButton 외 1 | SCP0042_TactTime_Test.cs:599 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-666dfa57 | FindButton 외 1 | SCP0042_TactTime_Test.cs:600 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-9fdb771e | FindButton 외 1 | SCP0042_TactTime_Test.cs:601 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_group_id"] | p_operation_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-0e04db7f | FindButton 외 1 | SCP0042_TactTime_Test.cs:602 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ebd887d | FindButton 외 1 | SCP0042_TactTime_Test.cs:603 | try ▸ lambda | DATA_OP | request.Parameters["p_valid"] | pValid.Equals("ALL") ? DBNull.Value : pValid | 행/컬럼 값 대입 |  |  |  |
| AC-2493971e | FindButton 외 1 | SCP0042_TactTime_Test.cs:604 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-4fe11751 | FindButton 외 1 | SCP0042_TactTime_Test.cs:606 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f9889e24 | FindButton 외 1 | SCP0042_TactTime_Test.cs:608 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8f4abbcf | FindButton 외 1 | SCP0042_TactTime_Test.cs:616 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-514972d9 | FindButton 외 1 | SCP0042_TactTime_Test.cs:617 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d76eec16 | FindButton 외 1 | SCP0042_TactTime_Test.cs:622 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83be0e76 | FindButton 외 1 | SCP0042_TactTime_Test.cs:625 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1519ed16 | FindButton 외 1 | SCP0042_TactTime_Test.cs:634 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-70c06e0d | FindButton 외 1 | SCP0042_TactTime_Test.cs:639 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1dfe83db | FindButton 외 1 | SCP0042_TactTime_Test.cs:644 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0042_TactTime_Test.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ded95c30 | this.Load | SCP0042_TactTime_Test.cs:148 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0042_TactTime_Test.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-560ed1af | this.Load | SCP0042_TactTime_Test.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-af0e0e24 | this.Load | SCP0042_TactTime_Test.cs:167 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f924dd39 | this.Load | SCP0042_TactTime_Test.cs:169 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-59abc8b9 | this.Load | SCP0042_TactTime_Test.cs:170 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-55490cdb | this.Load | SCP0042_TactTime_Test.cs:172 |  | FLAG | dtOperationGroup | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-060598b0 | this.Load | SCP0042_TactTime_Test.cs:172 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-98a1c8a7 | this.Load | SCP0042_TactTime_Test.cs:173 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0042_TactTime_Test.InitSpread

진입점: this.Load / spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b05ede71 | this.Load 외 3 | SCP0042_TactTime_Test.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3b73fbd4 | this.Load 외 3 | SCP0042_TactTime_Test.cs:277 | if (spreadInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineByOperation", dtLineByOperationOfSpd) | 목록 컨트롤 재구성 |  |  |  |
| AC-44147b0b | this.Load 외 3 | SCP0042_TactTime_Test.cs:278 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3591c3b8 | this.Load 외 3 | SCP0042_TactTime_Test.cs:280 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.PRIORITY), 0, 0, 99) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a43bac9c | this.Load 외 3 | SCP0042_TactTime_Test.cs:283 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a619591 | this.Load 외 3 | SCP0042_TactTime_Test.cs:323 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-17f7dc29 | this.Load 외 3 | SCP0042_TactTime_Test.cs:325 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtExcept) | LIST_REBIND | SpreadInfo.SetComBoParam | ("LineByOperation", dtLineByOperationOfSpd) | 목록 컨트롤 재구성 |  |  |  |
| AC-6be004df | this.Load 외 3 | SCP0042_TactTime_Test.cs:326 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-9d2ed836 | this.Load 외 3 | SCP0042_TactTime_Test.cs:327 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtExcept) | GRID_INIT | spreadInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0042_TactTime_Test.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8763c9e | InsertButton | SCP0042_TactTime_Test.cs:465 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6beb75b4 | InsertButton | SCP0042_TactTime_Test.cs:473 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8ca6674 | InsertButton | SCP0042_TactTime_Test.cs:475 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e014812 | InsertButton | SCP0042_TactTime_Test.cs:493 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), strDIVISION_ID) | 그리드 값 설정 |  |  |  |
| AC-b16f5382 | InsertButton | SCP0042_TactTime_Test.cs:494 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), strPLANT_SITE_ID) | 그리드 값 설정 |  |  |  |
| AC-1d0ce42e | InsertButton | SCP0042_TactTime_Test.cs:495 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PLANT_SITE_NAME), strPLANT_SITE_N… | 그리드 값 설정 |  |  |  |
| AC-8bd24810 | InsertButton | SCP0042_TactTime_Test.cs:496 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), strITEM_ID) | 그리드 값 설정 |  |  |  |
| AC-fb7f7109 | InsertButton | SCP0042_TactTime_Test.cs:497 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_ID), strOPERATION_ID) | 그리드 값 설정 |  |  |  |
| AC-69d33fb0 | InsertButton | SCP0042_TactTime_Test.cs:498 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.OPERATION_NAME), strOPERATION_NAM… | 그리드 값 설정 |  |  |  |
| AC-42622b99 | InsertButton | SCP0042_TactTime_Test.cs:500 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NICK_NAME), strNICK_NAME) | 그리드 값 설정 |  |  |  |
| AC-557f040d | InsertButton | SCP0042_TactTime_Test.cs:501 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-72e92278 | InsertButton | SCP0042_TactTime_Test.cs:503 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-570aa92f | InsertButton | SCP0042_TactTime_Test.cs:504 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.BOM_MIN_DUE_DATE), siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d4aad31 | InsertButton | SCP0042_TactTime_Test.cs:505 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DAILY_CAPACITY), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3332498f | InsertButton | SCP0042_TactTime_Test.cs:515 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00161", new object[] { "Tac Time" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-559673a0 | InsertButton | SCP0042_TactTime_Test.cs:516 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70d757b5 | InsertButton | SCP0042_TactTime_Test.cs:533 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Line" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8820bd63 | InsertButton | SCP0042_TactTime_Test.cs:534 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) ▸ if … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3b4902f | InsertButton | SCP0042_TactTime_Test.cs:537 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | DATA_OP | siExcept.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e65eb3a0 | InsertButton | SCP0042_TactTime_Test.cs:540 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.DIVISION_ID), strDIVISION_ID) | 그리드 값 설정 |  |  |  |
| AC-f6457230 | InsertButton | SCP0042_TactTime_Test.cs:541 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.PLANT_SITE_ID), strPLANT_SITE… | 그리드 값 설정 |  |  |  |
| AC-1752e4d3 | InsertButton | SCP0042_TactTime_Test.cs:542 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.PLANT_SITE_NAME), strPLANT_SI… | 그리드 값 설정 |  |  |  |
| AC-50d1b349 | InsertButton | SCP0042_TactTime_Test.cs:543 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.ITEM_ID), strITEM_ID) | 그리드 값 설정 |  |  |  |
| AC-e4f79c61 | InsertButton | SCP0042_TactTime_Test.cs:544 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.OPERATION_ID), strOPERATION_I… | 그리드 값 설정 |  |  |  |
| AC-bc5eb2e6 | InsertButton | SCP0042_TactTime_Test.cs:545 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.OPERATION_NAME), strOPERATION… | 그리드 값 설정 |  |  |  |
| AC-a4c75932 | InsertButton | SCP0042_TactTime_Test.cs:546 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.LINE_ID), strLINE_ID) | 그리드 값 설정 |  |  |  |
| AC-f80b7de8 | InsertButton | SCP0042_TactTime_Test.cs:547 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.NICK_NAME), strNICK_NAME) | 그리드 값 설정 |  |  |  |
| AC-f73d938b | InsertButton | SCP0042_TactTime_Test.cs:548 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_SET | siExcept.SetValue | (siExcept.ActiveRowIndex, siExcept.GetColumnIndex(DefColumns.USE_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-a91fff90 | InsertButton | SCP0042_TactTime_Test.cs:551 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefColumns.DIVISION_ID), siExcept.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7410eab | InsertButton | SCP0042_TactTime_Test.cs:552 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(siExcept.SheetName) == false) | GRID_LOCK | siExcept.LockRange | (insCell, siExcept.GetColumnIndex(DefColumns.CREATED_BY), siExcept.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0042_TactTime_Test.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be56a508 | SaveButton | SCP0042_TactTime_Test.cs:379 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0042_TactTime_Test.SaveData_Except

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdExcept")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36dbe30d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:966 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (siExcept.ActiveSheet.Rows.Count <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00f484f8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1001 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siExcept) | 프레임워크 검증 |  |  |  |
| AC-9f837d6e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1001 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!DataUtil.checkRequiredOfSpread(s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf55a30f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1002 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN8(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa32b2de | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1003 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (!checkValidN5(dt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1770b9c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1017 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1584d295 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1018 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-694caf80 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1023 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57d489d2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1024 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3cbc2ca0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1029 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30a45897 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1030 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ for (i <= siExcept.GetMaxRowIndex()) … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb69e767 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1076 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_SAVE_TACT_TIME_EXCEPT") ⇒ SCP.SCP0020_SAVE_TACT_TIME_EXCEPT | 엔드포인트 요청 생성 |  |  |  |
| AC-32e90b75 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1078 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-708aec66 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1081 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag" ] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f07a9dc1 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1082 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-14c0fc1f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1083 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6060b7d4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1084 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-807e705f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1085 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-597090d4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1086 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b96a4875 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1087 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time_start_date"] | p_tact_time_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-57f4b2ba | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1088 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time_end_date"] | p_tact_time_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-627a0a1a | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1089 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_tact_time"] | p_tact_time | 행/컬럼 값 대입 |  |  |  |
| AC-6903cda4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1090 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_yield"] | p_yield | 행/컬럼 값 대입 |  |  |  |
| AC-83d4cde7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1091 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_except_comment"] | p_except_comment | 행/컬럼 값 대입 |  |  |  |
| AC-7e93f0ab | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1092 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_use_yn"] | p_use_yn | 행/컬럼 값 대입 |  |  |  |
| AC-bbbf965e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1093 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-069db69a | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1094 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_division_id"] | p_org_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-62778e4f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1095 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_plant_site_id"] | p_org_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9f0b40d8 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1096 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_item_id"] | p_org_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d09ea1ee | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1097 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_operation_id"] | p_org_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-40ea1fa2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1098 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_line_id"] | p_org_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b75bd5f6 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1099 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_tact_time_start_date"] | p_org_tact_time_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-ef05d8fc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1100 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_org_tact_time_end_date"] | p_org_tact_time_end_date | 행/컬럼 값 대입 |  |  |  |
| AC-2bdaaa61 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1102 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-da8110d9 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1104 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d6afc1df | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1104 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-d1502949 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1112 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4653e2a7 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1124 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-489c90a4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1138 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | GRID_STYLE | siExcept.SetBGColor | (i, siExcept.GetColumnIndex(DefColumns.TACT_TIME_START_DATE), i, siExcept.GetColumnIndex(D… | 그리드 표시 설정 |  |  |  |
| AC-6501d042 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCP0042_TactTime_Test.cs:1148 | if (fps.Name == "spdExcept") ▸ if (siExcept != null && siExcept.IsLock(SpdSheet.shtExcept) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0042_TactTime_Test.SaveData_Main

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13703953 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:734 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e2cf4ba | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:762 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-7aaa1e99 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:762 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1c7e35f | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:779 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1bcdc656 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:780 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f283705 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:786 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41e3dd80 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:787 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a74393b | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:792 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa84ca05 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:793 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9eb96b80 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:797 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e262fad4 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:798 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Deci… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c557b6fb | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:853 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0020_SAVE_TACT_TIME") ⇒ SCP.SCP0020_SAVE_TACT_TIME | 엔드포인트 요청 생성 |  |  |  |
| AC-83f8692a | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:857 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-87f723b1 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:858 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1e7d34ec | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:859 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-03d41fee | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:860 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b585b537 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:861 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-3dbe8f93 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:862 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-007e60ca | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:863 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-7d611549 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:864 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_tact_time"] | p_tact_time | 행/컬럼 값 대입 |  |  |  |
| AC-1cc94fe9 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:865 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yield"] | p_yield | 행/컬럼 값 대입 |  |  |  |
| AC-3822abb4 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:866 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-702dc342 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:873 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_input_status"] | p_input_status | 행/컬럼 값 대입 |  |  |  |
| AC-38039be6 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:874 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_uom"] | p_item_uom | 행/컬럼 값 대입 |  |  |  |
| AC-e804aa4b | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:875 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_uom_convert_value"] | p_uom_convert_value | 행/컬럼 값 대입 |  |  |  |
| AC-9baa15cb | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:877 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc73bbd6 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:878 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8c6d3ac8 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:880 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2107a8ae | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:885 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce3af0a0 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:899 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18d71fa4 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:921 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID), i, siMain.GetColumnIndex(DefColumns.LIN… | 그리드 표시 설정 |  |  |  |
| AC-585eacf8 | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:931 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ddc95acd | SaveButton [if (fps.Name == "spdMain")] | SCP0042_TactTime_Test.cs:941 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0042_TactTime_Test.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b35904f | this.Load 외 1 | SCP0042_TactTime_Test.cs:240 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperNonOsp, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f1be9b1 | this.Load 외 1 | SCP0042_TactTime_Test.cs:240 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperNonOsp, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32ab9cd3 | this.Load 외 1 | SCP0042_TactTime_Test.cs:241 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c2bf7c92 | this.Load 외 1 | SCP0042_TactTime_Test.cs:247 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtLineByOperation | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-1e229990 | this.Load 외 1 | SCP0042_TactTime_Test.cs:247 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3208a2e3 | this.Load 외 1 | SCP0042_TactTime_Test.cs:248 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperation, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3fe4cf4a | this.Load 외 1 | SCP0042_TactTime_Test.cs:250 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtLineByOperationOfSpd | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-83ba6fbb | this.Load 외 1 | SCP0042_TactTime_Test.cs:250 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0042_TactTime_Test.setExceptYnColor

진입점: FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3590e97a | FindButton [try ▸ if (siMain.GetMaxRowIndex() > 0)] 외 1 | SCP0042_TactTime_Test.cs:1374 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sExceptYn == "Y") | UI_PROP | range1.BackColor | Color.FromArgb(80, Color.LightSkyBlue) | 속성 BackColor 설정 |  |  |  |

## SCP0042_TactTime_Test.SpdExcept_TopChange

진입점: spdExcept.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34fe0f7d | spdExcept.TopChange | SCP0042_TactTime_Test.cs:193 |  | GRID_INIT | siExcept.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0042_TactTime_Test.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7e6c8d1 | spdMain.CellClick | SCP0042_TactTime_Test.cs:1342 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-43f146ca | spdMain.CellClick | SCP0042_TactTime_Test.cs:1355 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | FLAG | dtLineByOperationOfSpd | Data.Common(Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPla… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-a961d69a | spdMain.CellClick | SCP0042_TactTime_Test.cs:1355 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, "", pFactoryID, pOperationID, pPlantSiteID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f3cb306e | spdMain.CellClick | SCP0042_TactTime_Test.cs:1357 | if (fps != null && siMain.IsLock(SpdSheet.shtMain) == false && siMain.IsLockCell(e.Row, e.Column) == false) ▸ if (e.Column == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtLineByOperationOfSpd) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0042_TactTime_Test.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b41e83f0 | spdMain.CellDoubleClick | SCP0042_TactTime_Test.cs:200 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-187e63c6 | spdMain.CellDoubleClick | SCP0042_TactTime_Test.cs:209 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-eabb8ca2 | spdMain.CellDoubleClick | SCP0042_TactTime_Test.cs:210 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0042_TactTime_Test.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b4c43b3 | spdMain.TopChange | SCP0042_TactTime_Test.cs:219 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

