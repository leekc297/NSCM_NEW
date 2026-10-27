# AS-IS 액션 대조표 — SCP0006

> 원천: `Doc/asisfacts/screens/SCP0006/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 422행 · 메서드 52 · 종류 DATA_OP 139 · FLAG 41 · RETURN 41 · CALL_EXT 39 · UI_PROP 28 · GRID_STYLE 24 · MESSAGE 18 · GRID_LOCK 16 · GRID_INIT 16 · POPUP 11 · STATE 9 · GRID_SET 8 · ENDPOINT 7 · UI_MISC 5 · LIST_REBIND 5 · COMBO_DATA 5 · GRID_BIND 3 · VALIDATE 3 · VALUE_SET 2 · STATE_RESET 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 39


## SCP0006_ProjectRoute.AfterFindDataBOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3814bc94 | (진입점 미연결) | SCP0006_ProjectRoute.cs:599 |  | GRID_BIND | siBOM.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-be4180e1 | (진입점 미연결) | SCP0006_ProjectRoute.cs:600 |  | GRID_LOCK | siBOM.LockColumn | (0, siBOM.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-af8de42f | (진입점 미연결) | SCP0006_ProjectRoute.cs:602 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ae4d2ffc | (진입점 미연결) | SCP0006_ProjectRoute.cs:619 | if (this.spdMainSelRow >= 0 && _isReload) | GRID_SET | siSite.ActiveSheet.SetValue | (spdMainSelRow, siSite.GetColumnIndex(DefColumns.PLANT_PER_ITEM), nInput + "/" + nTot) | 그리드 값 설정 |  |  |  |
| AC-15fe5fba | (진입점 미연결) | SCP0006_ProjectRoute.cs:621 | if (this.spdMainSelRow >= 0 && _isReload) | GRID_STYLE | siSite.ActiveSheet.SetActiveCell | (this.spdMainSelRow, this.spdMainSelCol) | 그리드 표시 설정 |  |  |  |
| AC-40772d8e | (진입점 미연결) | SCP0006_ProjectRoute.cs:622 | if (this.spdMainSelRow >= 0 && _isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.spdMainSelRow, this.spdMainSelCol, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0d52587 | (진입점 미연결) | SCP0006_ProjectRoute.cs:628 | if (this.spdBomSelRow >= 0 && _isReload) | GRID_STYLE | siBOM.ActiveSheet.SetActiveCell | (this.spdBomSelRow, this.spdBomSelCol) | 그리드 표시 설정 |  |  |  |
| AC-5c70feab | (진입점 미연결) | SCP0006_ProjectRoute.cs:629 | if (this.spdBomSelRow >= 0 && _isReload) | CALL_EXT | spdBOM.ShowCell | (0, 0, this.spdBomSelRow, this.spdBomSelCol, FarPoint.Win.Spread.VerticalPosition.Center, … | ⚠ 의미 확인 필요 |  |  |  |

## SCP0006_ProjectRoute.AfterFindDataPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-334c94bd | (진입점 미연결) | SCP0006_ProjectRoute.cs:637 |  | GRID_BIND | siPlant.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0749522b | (진입점 미연결) | SCP0006_ProjectRoute.cs:638 |  | GRID_LOCK | siPlant.LockColumn | (0, siPlant.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e35a02d | (진입점 미연결) | SCP0006_ProjectRoute.cs:640 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5a49b52a | (진입점 미연결) | SCP0006_ProjectRoute.cs:643 |  | FLAG | dtOsPackItem | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |

## SCP0006_ProjectRoute.AfterFindDataSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efda92a4 | (진입점 미연결) | SCP0006_ProjectRoute.cs:581 |  | GRID_BIND | siSite.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b4ca7f9f | (진입점 미연결) | SCP0006_ProjectRoute.cs:582 |  | GRID_LOCK | siSite.LockColumn | (0, siSite.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4bc0b29 | (진입점 미연결) | SCP0006_ProjectRoute.cs:584 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-11afdda0 | (진입점 미연결) | SCP0006_ProjectRoute.cs:586 |  | FLAG | siBOM | GetSheetInfo(spdBOM.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-b89112ef | (진입점 미연결) | SCP0006_ProjectRoute.cs:587 |  | FLAG | siPlant | GetSheetInfo(spdPlant.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-dbb2ef46 | (진입점 미연결) | SCP0006_ProjectRoute.cs:592 |  | FLAG | isBomClick | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0006_ProjectRoute.AfterSaveDataPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b6dbb9b | (진입점 미연결) | SCP0006_ProjectRoute.cs:652 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed08ed9e | (진입점 미연결) | SCP0006_ProjectRoute.cs:662 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0006_ProjectRoute.btnAllFind_Click

진입점: this.btnAllFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e7c3341 | this.btnAllFind.Click | SCP0006_ProjectRoute.cs:543 |  | POPUP | new SCM0002_ProjectRouteListSavePopup | () | 팝업/폼 생성 |  |  |  |
| AC-ba4065ab | this.btnAllFind.Click | SCP0006_ProjectRoute.cs:544 |  | POPUP | popItem.Form_Load | (division.ToString()) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9561f237 | this.btnAllFind.Click | SCP0006_ProjectRoute.cs:545 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-927c24bc | this.btnAllFind.Click | SCP0006_ProjectRoute.cs:546 |  | UI_PROP | popItem.Width | 1200 | 속성 Width 설정 |  |  |  |
| AC-fc2c3679 | this.btnAllFind.Click | SCP0006_ProjectRoute.cs:547 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0006_ProjectRoute.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe05c9e4 | this.btnItemId.Click | SCP0006_ProjectRoute.cs:1300 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8cd832de | this.btnItemId.Click | SCP0006_ProjectRoute.cs:1302 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9a6b7f1b | this.btnItemId.Click | SCP0006_ProjectRoute.cs:1303 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6ca96a21 | this.btnItemId.Click | SCP0006_ProjectRoute.cs:1304 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c760c847 | this.btnItemId.Click | SCP0006_ProjectRoute.cs:1310 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0006_ProjectRoute.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77b8099a | this.btnProject.Click | SCP0006_ProjectRoute.cs:1277 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8414a223 | this.btnProject.Click | SCP0006_ProjectRoute.cs:1279 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e0a2dd87 | this.btnProject.Click | SCP0006_ProjectRoute.cs:1280 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-733b1cae | this.btnProject.Click | SCP0006_ProjectRoute.cs:1281 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-62afe318 | this.btnProject.Click | SCP0006_ProjectRoute.cs:1287 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0006_ProjectRoute.CheckChangedValues

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fccdb5c | SaveButton | SCP0006_ProjectRoute.cs:915 | if (siPlant == null \|\| siPlant.IsLock(siPlant.SheetName)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-14a4f5cf | SaveButton | SCP0006_ProjectRoute.cs:918 | if (siPlant.SheetName != SpdSheet.shtPlant) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-028e0dc5 | SaveButton | SCP0006_ProjectRoute.cs:924 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siPlant) | 프레임워크 검증 |  |  |  |
| AC-4ceee0cd | SaveButton | SCP0006_ProjectRoute.cs:925 | if (!DataUtil.checkRequiredOfSpread(siPlant)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d44551d2 | SaveButton | SCP0006_ProjectRoute.cs:927 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa35c66a | SaveButton | SCP0006_ProjectRoute.cs:930 | if (!checkValidN1(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-31251ab6 | SaveButton | SCP0006_ProjectRoute.cs:931 | if (!checkValidN2(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-58a31336 | SaveButton | SCP0006_ProjectRoute.cs:932 | if (!checkValidN3(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9c87195e | SaveButton | SCP0006_ProjectRoute.cs:933 | if (!checkValidN4(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ca29896d | SaveButton | SCP0006_ProjectRoute.cs:934 | if (!checkValidN5(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-efad734f | SaveButton | SCP0006_ProjectRoute.cs:935 | if (!checkValidN6(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-726e1119 | SaveButton | SCP0006_ProjectRoute.cs:936 | if (!checkValidN7(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-808ce049 | SaveButton | SCP0006_ProjectRoute.cs:937 | if (!checkValidN8(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eee0d6ff | SaveButton | SCP0006_ProjectRoute.cs:938 | if (!checkValidN9(dt)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fc71d0df | SaveButton | SCP0006_ProjectRoute.cs:988 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN0

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a56b42e | (진입점 미연결) | SCP0006_ProjectRoute.cs:1462 | for (i < dt.Rows.Count) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a91209f7 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1463 | for (i < dt.Rows.Count) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-56275176 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1470 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-29ed3b94 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1473 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e6bf77d | (진입점 미연결) | SCP0006_ProjectRoute.cs:1474 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ab60585 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1478 | for (i < dt.Rows.Count) ▸ if ("" != dr.Field<string>(DefColumns.PLANT_SITE_ID) && "40" == dr.Field<string>(DefColumns.DIVISION_ID) && "P" ==… | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e13dc5db | (진입점 미연결) | SCP0006_ProjectRoute.cs:1482 | for (i < dt.Rows.Count) ▸ if ("" != dr.Field<string>(DefColumns.PLANT_SITE_ID) && "40" == dr.Field<string>(DefColumns.DIVISION_ID) && "P" ==… | DATA_OP | DBUtils.Filter | (dtPlantSiteOsPack, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-33bd8f5e | (진입점 미연결) | SCP0006_ProjectRoute.cs:1486 | for (i < dt.Rows.Count) ▸ if ("" != dr.Field<string>(DefColumns.PLANT_SITE_ID) && "40" == dr.Field<string>(DefColumns.DIVISION_ID) && "P" ==… | DATA_OP | dr.Field | (DefColumns.ITEM_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7aad806 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1504 | for (i < dt.Rows.Count) ▸ if ("" != dr.Field<string>(DefColumns.PLANT_SITE_ID) && "40" == dr.Field<string>(DefColumns.DIVISION_ID) && "P" ==… | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefColumns.COMPANY_ID, DefColumns.DIVISION_ID, DefColumns.ITEM_ID, D… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7fae532d | (진입점 미연결) | SCP0006_ProjectRoute.cs:1507 | for (i < dt.Rows.Count) ▸ if ("" != dr.Field<string>(DefColumns.PLANT_SITE_ID) && "40" == dr.Field<string>(DefColumns.DIVISION_ID) && "P" ==… | DATA_OP | DBUtils.Filter | (dtOsPackItem, filterPack, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5b481f4d | (진입점 미연결) | SCP0006_ProjectRoute.cs:1511 | for (i < dt.Rows.Count) ▸ if ("" != dr.Field<string>(DefColumns.PLANT_SITE_ID) && "40" == dr.Field<string>(DefColumns.DIVISION_ID) && "P" ==… | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-596b692d | (진입점 미연결) | SCP0006_ProjectRoute.cs:1513 | for (i < dt.Rows.Count) ▸ if ("" != dr.Field<string>(DefColumns.PLANT_SITE_ID) && "40" == dr.Field<string>(DefColumns.DIVISION_ID) && "P" ==… | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-754bbd1b | (진입점 미연결) | SCP0006_ProjectRoute.cs:1520 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-552295b0 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1524 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00226", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88752321 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1527 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN1

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d2b39d0 | SaveButton | SCP0006_ProjectRoute.cs:1542 | for (i < dt.Rows.Count) | DATA_OP | dr[DefColumns.IS_PASS_N1] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-167a975b | SaveButton | SCP0006_ProjectRoute.cs:1543 | for (i < dt.Rows.Count) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-353c44ff | SaveButton | SCP0006_ProjectRoute.cs:1544 | for (i < dt.Rows.Count) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-66613d24 | SaveButton | SCP0006_ProjectRoute.cs:1550 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a01be8b6 | SaveButton | SCP0006_ProjectRoute.cs:1551 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1ec6bce | SaveButton | SCP0006_ProjectRoute.cs:1554 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-df85a692 | SaveButton | SCP0006_ProjectRoute.cs:1562 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-27682d1b | SaveButton | SCP0006_ProjectRoute.cs:1567 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-c19b1fcb | SaveButton | SCP0006_ProjectRoute.cs:1568 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fddaa0b | SaveButton | SCP0006_ProjectRoute.cs:1573 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD != cp_ORG_TO_YYYYMMDD) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7bb1e41 | SaveButton | SCP0006_ProjectRoute.cs:1574 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD != cp_ORG_TO_YYYYMMDD) | DATA_OP | cpDr[DefColumns.IS_PASS_N1] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-215d74b2 | SaveButton | SCP0006_ProjectRoute.cs:1576 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD != cp_ORG_TO_YYYYMMDD) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-9b644f26 | SaveButton | SCP0006_ProjectRoute.cs:1582 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c3f438cd | SaveButton | SCP0006_ProjectRoute.cs:1586 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00101", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72cb58be | SaveButton | SCP0006_ProjectRoute.cs:1589 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN2

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-629c9099 | SaveButton | SCP0006_ProjectRoute.cs:1602 | for (i < dt.Rows.Count) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e31ce156 | SaveButton | SCP0006_ProjectRoute.cs:1604 | for (i < dt.Rows.Count) | DATA_OP | dr[DefColumns.IS_PASS_N2] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-23527db4 | SaveButton | SCP0006_ProjectRoute.cs:1606 | for (i < dt.Rows.Count) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-e0d2efb2 | SaveButton | SCP0006_ProjectRoute.cs:1612 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d99804b8 | SaveButton | SCP0006_ProjectRoute.cs:1613 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5c446f7 | SaveButton | SCP0006_ProjectRoute.cs:1615 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d757a2f | SaveButton | SCP0006_ProjectRoute.cs:1625 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfec1a11 | SaveButton | SCP0006_ProjectRoute.cs:1630 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d2574f2 | SaveButton | SCP0006_ProjectRoute.cs:1631 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-25c0cf9b | SaveButton | SCP0006_ProjectRoute.cs:1636 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD != cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-935c82e5 | SaveButton | SCP0006_ProjectRoute.cs:1637 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD != cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD) | DATA_OP | cpDr[DefColumns.IS_PASS_N2] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-ad294171 | SaveButton | SCP0006_ProjectRoute.cs:1639 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD != cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-91d520f9 | SaveButton | SCP0006_ProjectRoute.cs:1646 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7345f3fb | SaveButton | SCP0006_ProjectRoute.cs:1650 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00102", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c66c7bf4 | SaveButton | SCP0006_ProjectRoute.cs:1653 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN3

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b8839aa | SaveButton | SCP0006_ProjectRoute.cs:1665 | for (i < dt.Rows.Count) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74e4491a | SaveButton | SCP0006_ProjectRoute.cs:1667 | for (i < dt.Rows.Count) | DATA_OP | dr[DefColumns.IS_PASS_N3] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-71aa45e3 | SaveButton | SCP0006_ProjectRoute.cs:1669 | for (i < dt.Rows.Count) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-0f21c9d1 | SaveButton | SCP0006_ProjectRoute.cs:1674 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff47603c | SaveButton | SCP0006_ProjectRoute.cs:1675 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-d430789b | SaveButton | SCP0006_ProjectRoute.cs:1676 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fc02790 | SaveButton | SCP0006_ProjectRoute.cs:1678 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-e504b3d8 | SaveButton | SCP0006_ProjectRoute.cs:1688 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae3fa0ac | SaveButton | SCP0006_ProjectRoute.cs:1693 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb9b53fe | SaveButton | SCP0006_ProjectRoute.cs:1694 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac8bfb67 | SaveButton | SCP0006_ProjectRoute.cs:1695 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PLANT_SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-80ca8311 | SaveButton | SCP0006_ProjectRoute.cs:1699 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD &… | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f28951d | SaveButton | SCP0006_ProjectRoute.cs:1700 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD &… | DATA_OP | cpDr[DefColumns.IS_PASS_N3] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-08eaf6c1 | SaveButton | SCP0006_ProjectRoute.cs:1702 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD &… | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-2d999087 | SaveButton | SCP0006_ProjectRoute.cs:1711 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00103", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb93f3d6 | SaveButton | SCP0006_ProjectRoute.cs:1714 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN4

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8047e23d | SaveButton | SCP0006_ProjectRoute.cs:1726 | for (i < dt.Rows.Count) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5333d619 | SaveButton | SCP0006_ProjectRoute.cs:1728 | for (i < dt.Rows.Count) | DATA_OP | dr[DefColumns.IS_PASS_N4] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a75feb48 | SaveButton | SCP0006_ProjectRoute.cs:1730 | for (i < dt.Rows.Count) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-54046a07 | SaveButton | SCP0006_ProjectRoute.cs:1736 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-259b5176 | SaveButton | SCP0006_ProjectRoute.cs:1737 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdd55d88 | SaveButton | SCP0006_ProjectRoute.cs:1738 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c9d36b1 | SaveButton | SCP0006_ProjectRoute.cs:1740 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f0aaad7 | SaveButton | SCP0006_ProjectRoute.cs:1750 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fa55891 | SaveButton | SCP0006_ProjectRoute.cs:1755 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bcf0136 | SaveButton | SCP0006_ProjectRoute.cs:1756 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-4275829d | SaveButton | SCP0006_ProjectRoute.cs:1757 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c9861e5 | SaveButton | SCP0006_ProjectRoute.cs:1761 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD &… | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2551e1c1 | SaveButton | SCP0006_ProjectRoute.cs:1762 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD &… | DATA_OP | cpDr[DefColumns.IS_PASS_N4] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-72f9bcae | SaveButton | SCP0006_ProjectRoute.cs:1764 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYYYMMDD == cp_ORG_TO_YYYYMMDD &… | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx, changeRowIdx, iColIdx, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-d405cac0 | SaveButton | SCP0006_ProjectRoute.cs:1770 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-60a828d3 | SaveButton | SCP0006_ProjectRoute.cs:1774 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00104", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61d21354 | SaveButton | SCP0006_ProjectRoute.cs:1777 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN5

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-223274a7 | SaveButton | SCP0006_ProjectRoute.cs:1793 | for (i < dt.Rows.Count) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d27f62c1 | SaveButton | SCP0006_ProjectRoute.cs:1795 | for (i < dt.Rows.Count) | DATA_OP | dr[DefColumns.IS_PASS_N5] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37535384 | SaveButton | SCP0006_ProjectRoute.cs:1797 | for (i < dt.Rows.Count) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-ecb38520 | SaveButton | SCP0006_ProjectRoute.cs:1803 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-a73956bc | SaveButton | SCP0006_ProjectRoute.cs:1804 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e344631 | SaveButton | SCP0006_ProjectRoute.cs:1815 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-be4b2122 | SaveButton | SCP0006_ProjectRoute.cs:1826 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-934164f0 | SaveButton | SCP0006_ProjectRoute.cs:1831 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-891707bc | SaveButton | SCP0006_ProjectRoute.cs:1832 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-01a68e22 | SaveButton | SCP0006_ProjectRoute.cs:1846 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD > nCp_ORG_FROM_YYYYMMDD && nORG_… | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-acb3c073 | SaveButton | SCP0006_ProjectRoute.cs:1847 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD > nCp_ORG_FROM_YYYYMMDD && nORG_… | DATA_OP | cpDr[DefColumns.IS_PASS_N5] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-fb612bb7 | SaveButton | SCP0006_ProjectRoute.cs:1849 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (MERGE_DATE != cp_MERGE_DATE && ((nORG_FROM_YYYYMMDD > nCp_ORG_FROM_YYYYMMDD && nORG_… | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-7f95592b | SaveButton | SCP0006_ProjectRoute.cs:1855 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c78c5677 | SaveButton | SCP0006_ProjectRoute.cs:1859 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00105", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4a0a986 | SaveButton | SCP0006_ProjectRoute.cs:1862 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN6

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f1eab14 | SaveButton | SCP0006_ProjectRoute.cs:1872 | lambda | DATA_OP | row.Field | ("VALID_YN") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c8d5e2a | SaveButton | SCP0006_ProjectRoute.cs:1872 | lambda | DATA_OP | row.Field | ("ORG_TO_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-173c8f6c | SaveButton | SCP0006_ProjectRoute.cs:1880 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af29f1e7 | SaveButton | SCP0006_ProjectRoute.cs:1881 | foreach (DataRow dr in dt.AsEnumerable()) | DATA_OP | dr[DefColumns.IS_PASS_N6] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8c3daf55 | SaveButton | SCP0006_ProjectRoute.cs:1883 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-f6056322 | SaveButton | SCP0006_ProjectRoute.cs:1891 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6567868 | SaveButton | SCP0006_ProjectRoute.cs:1896 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-78d88ec9 | SaveButton | SCP0006_ProjectRoute.cs:1914 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-f45cc9c3 | SaveButton | SCP0006_ProjectRoute.cs:1919 | for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-8752d3c4 | SaveButton | SCP0006_ProjectRoute.cs:1929 | for (i < dt.Rows.Count) ▸ if (!isExistNextDate) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc377cc7 | SaveButton | SCP0006_ProjectRoute.cs:1931 | for (i < dt.Rows.Count) ▸ if (!isExistNextDate) | GRID_SET | dt.Rows[i][DefColumns.IS_PASS_N6] | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-994ec1f9 | SaveButton | SCP0006_ProjectRoute.cs:1933 | for (i < dt.Rows.Count) ▸ if (!isExistNextDate) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-6e8d3bc5 | SaveButton | SCP0006_ProjectRoute.cs:1937 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3f32d06 | SaveButton | SCP0006_ProjectRoute.cs:1941 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00106", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c820d1a9 | SaveButton | SCP0006_ProjectRoute.cs:1944 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN7

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c50f4a5e | SaveButton | SCP0006_ProjectRoute.cs:1960 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb7fbb95 | SaveButton | SCP0006_ProjectRoute.cs:1961 | foreach (DataRow dr in dt.AsEnumerable()) | DATA_OP | dr[DefColumns.IS_PASS_N7] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7184702b | SaveButton | SCP0006_ProjectRoute.cs:1963 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx1, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-0d27902b | SaveButton | SCP0006_ProjectRoute.cs:1971 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-a464d02c | SaveButton | SCP0006_ProjectRoute.cs:1976 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-37d806e5 | SaveButton | SCP0006_ProjectRoute.cs:1980 | for (i < dt.Rows.Count) ▸ if (intPRIORITY <1) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a52486c | SaveButton | SCP0006_ProjectRoute.cs:1982 | for (i < dt.Rows.Count) ▸ if (intPRIORITY <1) | GRID_SET | dt.Rows[i][DefColumns.IS_PASS_N7] | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-21228651 | SaveButton | SCP0006_ProjectRoute.cs:1984 | for (i < dt.Rows.Count) ▸ if (intPRIORITY <1) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx1, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-34e47d94 | SaveButton | SCP0006_ProjectRoute.cs:1987 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6667e17c | SaveButton | SCP0006_ProjectRoute.cs:1991 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00107", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6df476e2 | SaveButton | SCP0006_ProjectRoute.cs:1994 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN8

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95449941 | SaveButton | SCP0006_ProjectRoute.cs:2015 | foreach (DataRow dr in dt.AsEnumerable()) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (initIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-687767b6 | SaveButton | SCP0006_ProjectRoute.cs:2016 | foreach (DataRow dr in dt.AsEnumerable()) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-ee3cdb1c | SaveButton | SCP0006_ProjectRoute.cs:2023 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2795bb0 | SaveButton | SCP0006_ProjectRoute.cs:2028 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc442b3e | SaveButton | SCP0006_ProjectRoute.cs:2029 | for (i < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ba9c020 | SaveButton | SCP0006_ProjectRoute.cs:2032 | for (i < dt.Rows.Count) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | GRID_STYLE | siPlant.SetBGColor | (i, iColIdx1, i, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-fef5cd5b | SaveButton | SCP0006_ProjectRoute.cs:2033 | for (i < dt.Rows.Count) ▸ if (strORG_FROM_YYYYMMDD == string.Empty \|\| strORG_TO_YYYYMMDD == string.Empty) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-693f1070 | SaveButton | SCP0006_ProjectRoute.cs:2041 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6f0afcb | SaveButton | SCP0006_ProjectRoute.cs:2045 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD > intORG_TO_YYYYMMDD) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-7e48eaf2 | SaveButton | SCP0006_ProjectRoute.cs:2050 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD < 17530101 \|\| intORG_TO_YYYYMMDD < 17530101) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5b21264 | SaveButton | SCP0006_ProjectRoute.cs:2053 | for (i < dt.Rows.Count) ▸ if (intORG_FROM_YYYYMMDD < 17530101 \|\| intORG_TO_YYYYMMDD < 17530101) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-c070a7bb | SaveButton | SCP0006_ProjectRoute.cs:2059 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d07311f2 | SaveButton | SCP0006_ProjectRoute.cs:2063 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac98798e | SaveButton | SCP0006_ProjectRoute.cs:2067 | else of (!isPass) ▸ if (!isDatePass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00048", new object[] { strStartDate + "~" + strEndDate }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94a2e5e6 | SaveButton | SCP0006_ProjectRoute.cs:2071 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.checkValidN9

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a962c37 | SaveButton | SCP0006_ProjectRoute.cs:2084 | for (i < dt.Rows.Count) | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-61bb5779 | SaveButton | SCP0006_ProjectRoute.cs:2087 | for (i < dt.Rows.Count) | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-68052854 | SaveButton | SCP0006_ProjectRoute.cs:2093 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-40dc7cc7 | SaveButton | SCP0006_ProjectRoute.cs:2094 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-50e9fa3c | SaveButton | SCP0006_ProjectRoute.cs:2095 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.PRIORITY) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac7d51eb | SaveButton | SCP0006_ProjectRoute.cs:2097 | for (i < dt.Rows.Count) | DATA_OP | dr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff53b4b6 | SaveButton | SCP0006_ProjectRoute.cs:2102 | for (i < dt.Rows.Count) | DATA_OP | dt.Select | ("PRIORITY=1 AND VALID_YN ='Y' AND ORG_FROM_YYYYMMDD='" + ORG_FROM_YYYYMMDD + "' AND ORG_T… | 데이터 객체 조작/조회 |  |  |  |
| AC-442682e2 | SaveButton | SCP0006_ProjectRoute.cs:2111 | for (i < dt.Rows.Count) ▸ if (checkRows.Length == 0) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.VALID_YN) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad4033c6 | SaveButton | SCP0006_ProjectRoute.cs:2116 | for (i < dt.Rows.Count) ▸ if (checkRows.Length == 0) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_FROM_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cebd850 | SaveButton | SCP0006_ProjectRoute.cs:2117 | for (i < dt.Rows.Count) ▸ if (checkRows.Length == 0) ▸ for (j < dt.Rows.Count) | DATA_OP | cpDr.Field | (DefColumns.ORG_TO_YYYYMMDD) | 데이터 객체 조작/조회 |  |  |  |
| AC-64fe7dfa | SaveButton | SCP0006_ProjectRoute.cs:2121 | for (i < dt.Rows.Count) ▸ if (checkRows.Length == 0) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYY… | CALL_EXT | siPlant.DisplayedSheet.GetViewRowFromModelRow | (j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ffbd1a3 | SaveButton | SCP0006_ProjectRoute.cs:2123 | for (i < dt.Rows.Count) ▸ if (checkRows.Length == 0) ▸ for (j < dt.Rows.Count) ▸ if (ORG_FROM_YYYYMMDD == cp_ORG_FROM_YYYYMMDD && ORG_TO_YYY… | GRID_STYLE | siPlant.SetBGColor | (changeRowIdx, iColIdx1, changeRowIdx, iColIdx2, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-4d6b331e | SaveButton | SCP0006_ProjectRoute.cs:2129 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c0c824d | SaveButton | SCP0006_ProjectRoute.cs:2133 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00110", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f4e3b9c | SaveButton | SCP0006_ProjectRoute.cs:2136 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.ChkPlantOs

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75faf08a | (진입점 미연결) | SCP0006_ProjectRoute.cs:1333 | if ("" != siPlant.GetValue(nRowIdx, siPlant.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() && "40" == siPlant.GetValue…) | DATA_OP | DBUtils.Filter | (dtPlantSiteOsPack, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-caa46aa6 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1344 | if ("" != siPlant.GetValue(nRowIdx, siPlant.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() && "40" == siPlant.GetValue…) ▸ if (dtChkSi… | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { DefColumns.COMPANY_ID, DefColumns.DIVISION_ID, DefColumns.ITEM_ID } … | ⚠ 의미 확인 필요 |  |  |  |
| AC-f63559ac | (진입점 미연결) | SCP0006_ProjectRoute.cs:1347 | if ("" != siPlant.GetValue(nRowIdx, siPlant.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() && "40" == siPlant.GetValue…) ▸ if (dtChkSi… | DATA_OP | DBUtils.Filter | (dtOsPackItem, filterPack, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7e869918 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1351 | if ("" != siPlant.GetValue(nRowIdx, siPlant.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() && "40" == siPlant.GetValue…) ▸ if (dtChkSi… | MESSAGE | MessageHelper.GMessageBox | ("MSG00226", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44c10020 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1352 | if ("" != siPlant.GetValue(nRowIdx, siPlant.GetColumnIndex(DefColumns.PLANT_SITE_ID)).ToString() && "40" == siPlant.GetValue…) ▸ if (dtChkSi… | GRID_SET | siPlant.SetValue | (nRowIdx, siPlant.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |

## SCP0006_ProjectRoute.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9dfe741 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1069 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-860b49ff | (진입점 미연결) | SCP0006_ProjectRoute.cs:1070 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0006_ProjectRoute.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ee696d0 | this.Load | SCP0006_ProjectRoute.cs:272 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtSite, SpdSheet.shtSite, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b25f77df | this.Load | SCP0006_ProjectRoute.cs:273 |  | FLAG | siSite | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-818a5755 | this.Load | SCP0006_ProjectRoute.cs:275 |  | GRID_INIT | AddSheet | (spdBOM, SpdSheet.shtBOM, SpdSheet.shtBOM, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1561a3a6 | this.Load | SCP0006_ProjectRoute.cs:276 |  | FLAG | siBOM | GetSheetInfo(spdBOM.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-a51b8a9c | this.Load | SCP0006_ProjectRoute.cs:278 |  | GRID_INIT | AddSheet | (spdPlant, SpdSheet.shtPlant, SpdSheet.shtPlant, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-01a45223 | this.Load | SCP0006_ProjectRoute.cs:279 |  | FLAG | siPlant | GetSheetInfo(spdPlant.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb3b6240 | this.Load | SCP0006_ProjectRoute.cs:281 |  | GRID_INIT | siSite.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0006_ProjectRoute.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54202deb | DeleteButton | SCP0006_ProjectRoute.cs:476 | if (fps != null) ▸ if (fps.Name == "spdMain" \|\| fps.Name == "spdBOM") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-426425fe | DeleteButton | SCP0006_ProjectRoute.cs:482 | if (fps != null) ▸ if (fps.Name == "spdPlant") ▸ if (siPlant.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14aa81fc | DeleteButton | SCP0006_ProjectRoute.cs:487 | if (fps != null) ▸ if (fps.Name == "spdPlant") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siPlant.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0006_ProjectRoute.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bb8003c | Dispose | SCP0006_ProjectRoute.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0006_ProjectRoute.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1eb85da | EditButton | SCP0006_ProjectRoute.cs:499 | if (fps != null) ▸ if (fps.Name == "spdMain" \|\| fps.Name == "spdBOM") | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06ca83bc | EditButton | SCP0006_ProjectRoute.cs:500 | if (fps != null) ▸ if (fps.Name == "spdMain" \|\| fps.Name == "spdBOM") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99b9ae2c | EditButton | SCP0006_ProjectRoute.cs:511 | if (fps != null) ▸ if (fps.Name == "spdPlant") ▸ if (!string.IsNullOrEmpty(this._bomCellType)) ▸ if (this._bomCellType.Length >= 2) ▸ if (th… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70c535ee | EditButton | SCP0006_ProjectRoute.cs:515 | if (fps != null) ▸ if (fps.Name == "spdPlant") | FLAG | siPlant | GetSheetInfo(spdPlant.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5964381 | EditButton | SCP0006_ProjectRoute.cs:517 | if (fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-77d81334 | EditButton | SCP0006_ProjectRoute.cs:519 | if (fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.LockColumn | (siPlant.GetColumnIndex(DefColumns.ITEM_ID), siPlant.GetColumnIndex(DefColumns.ITEM_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81b367a0 | EditButton | SCP0006_ProjectRoute.cs:520 | if (fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.LockColumn | (siPlant.GetColumnIndex(DefColumns.PRIORITY_SEQ), siPlant.GetColumnIndex(DefColumns.PRIORI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-90d771f2 | EditButton | SCP0006_ProjectRoute.cs:521 | if (fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.LockColumn | (siPlant.GetColumnIndex(DefColumns.DIVISION_ID), siPlant.GetColumnIndex(DefColumns.DIVISIO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-456cb39b | EditButton | SCP0006_ProjectRoute.cs:522 | if (fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.LockColumn | (siPlant.GetColumnIndex(DefColumns.PROJECT_CODE), siPlant.GetColumnIndex(DefColumns.PROJEC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2734d58a | EditButton | SCP0006_ProjectRoute.cs:523 | if (fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.LockColumn | (siPlant.GetColumnIndex(DefColumns.SCM_SITE_ID), siPlant.GetColumnIndex(DefColumns.SCM_SIT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-974077bb | EditButton | SCP0006_ProjectRoute.cs:524 | if (fps != null) ▸ if (fps.Name == "spdPlant") | GRID_LOCK | siPlant.LockColumn | (siPlant.GetColumnIndex(DefColumns.CREATED_BY), siPlant.GetColumnIndex(DefColumns.LAST_UPD… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0006_ProjectRoute.FindDataBOM

진입점: spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63130c37 | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… | SCP0006_ProjectRoute.cs:447 |  | FLAG | _isReload | isReload | 화면 필드/플래그 변경 |  |  |  |
| AC-fdbdd666 | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… | SCP0006_ProjectRoute.cs:862 |  | ENDPOINT | this.ExecuteSQL | (siBOM, DIC_GET_BOM, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0006_ProjectRoute.FindDataBOMPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fd2939b | (진입점 미연결) | SCP0006_ProjectRoute.cs:879 |  | ENDPOINT | this.ExecuteSQL | ( new List<SpreadInfo>() { siBOM, siPlant } , new List<string>() { DIC_GET_BOM, DIC_GET_PL… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0006_ProjectRoute.FindDataPlant

진입점: spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f1a3265 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… | SCP0006_ProjectRoute.cs:870 |  | ENDPOINT | this.ExecuteSQL | (siPlant, DIC_GET_PLANT, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0006_ProjectRoute.FindDataSite

진입점: this.btnAllFind.Click [if (SaveSucs)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95373c85 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:439 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5f25046f | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:440 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0d296e6 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:694 | else of (isReload) | CALL_EXT | CString.GetComboBoxValue | (cboStatus.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-505e435c | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:697 | else of (isReload) | FLAG | srchDivisionID | division.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d3303d72 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:698 | else of (isReload) | FLAG | srchSaleSite | pSaleSite.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-779bbd66 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:699 | else of (isReload) | FLAG | srchProject | pProject.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-968a9ccc | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:700 | else of (isReload) | FLAG | srchItemId | pItemId.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3608c0e6 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:701 | else of (isReload) | FLAG | srchFromYYYYMMDD | pFromYYYYMMDD.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4bea4bc7 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:702 | else of (isReload) | FLAG | srchToYYYMMDD | pToYYYMMDD.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-25df8d66 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:703 | else of (isReload) | FLAG | srchStatus | pStatus.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7a0e00bd | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:707 |  | CALL_EXT | CommonUtils.CheckItemNoAct | (pItemId, null, ref message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e1f6cb5 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:710 | if (CommonUtils.CheckDataEmpty(message) == false) | MESSAGE | MessageHelper.GMessageBox | (message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e8a8f53 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:715 | if (this.QueryDics[DIC_GET_SITE].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_SITE].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaf81f32 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:720 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpreadSite | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-fe2d09a9 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:721 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataSite | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-676bfc3b | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:722 |  | UI_PROP | qi.ServiceUri | BLUtils.GSCM_SCM_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-5811f7d0 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:726 | if (division.ToString() == "82" \|\| division.ToString() == "40") | UI_PROP | qi.QueryId | "SCP.SCP0006_GET_PROJECT_ROUTE_SITE_82" | 속성 QueryId 설정 |  |  |  |
| AC-2d0bee29 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:730 | else of (division.ToString() == "82" \|\| division.ToString() == "40") | UI_PROP | qi.QueryId | "SCP.SCP0006_GET_PROJECT_ROUTE_SITE" | 속성 QueryId 설정 |  |  |  |
| AC-97cad38a | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:733 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc135864 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:734 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_scm_site_id", pSaleSite)) | 데이터 객체 조작/조회 |  |  |  |
| AC-89761ff3 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:735 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_project_code", pProject)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bd4f6a4 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:736 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", pItemId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08e0f29d | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:737 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymm", pFromYYYYMMDD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-87c457ff | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:738 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymm", pToYYYMMDD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed3132d2 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:739 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_status", pStatus)) | 데이터 객체 조작/조회 |  |  |  |
| AC-738d3bba | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:740 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bdc7519 | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:742 |  | DATA_OP | this.QueryDics[DIC_GET_SITE] | new List<QueryInfo>() {qi} | 행/컬럼 값 대입 |  |  |  |
| AC-fcdcee8a | this.btnAllFind.Click [if (SaveSucs)] 외 1 | SCP0006_ProjectRoute.cs:744 |  | ENDPOINT | this.ExecuteSQL | (siSite, DIC_GET_SITE, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0006_ProjectRoute.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c9550dd | this.Load | SCP0006_ProjectRoute.cs:206 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0006_ProjectRoute.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9396874c | (진입점 미연결) | SCP0006_ProjectRoute.cs:1134 |  | ENDPOINT | new FoxDataRequest | ("SCP.GET_DATE_RANGE_1MONTH") ⇒ SCP.GET_DATE_RANGE_1MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-47756072 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1135 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-97657ed5 | (진입점 미연결) | SCP0006_ProjectRoute.cs:1138 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.GetQueryInfoGetBOM

진입점: spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d998e79a | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:751 |  | UI_PROP | res.BeforeExecuteSQLProc | this.InitSpreadBOM | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-70369273 | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:752 |  | UI_PROP | res.AfterExecuteSQLProc | this.AfterFindDataBOM | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-92f9344c | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:753 |  | UI_PROP | res.ServiceUri | BLUtils.GSCM_SCM_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-27946f22 | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:757 | if (_siteDivision.ToString() == "82" \|\| _siteDivision.ToString() == "40") | UI_PROP | res.QueryId | "SCP.SCP0006_GET_PROJECT_ROUTE_BOM_82" | 속성 QueryId 설정 |  |  |  |
| AC-3408e826 | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:761 | else of (_siteDivision.ToString() == "82" \|\| _siteDivision.ToString() == "40") | UI_PROP | res.QueryId | "SCP.SCP0006_GET_PROJECT_ROUTE_BOM" | 속성 QueryId 설정 |  |  |  |
| AC-1b424724 | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:764 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._siteDivision)) | 데이터 객체 조작/조회 |  |  |  |
| AC-950c8bcc | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:765 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_scm_site_id", this._siteScmSiteId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6ee72eb | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:766 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_model_id", this._siteItemId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-96ff843e | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:767 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_project_code", this._siteProject)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b820cb | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:769 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.GetQueryInfoGetPlant

진입점: spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee94bbde | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:789 |  | UI_PROP | res.BeforeExecuteSQLProc | this.InitSpreadPlant | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-674e62ba | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:790 |  | UI_PROP | res.AfterExecuteSQLProc | this.AfterFindDataPlant | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-9889af64 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:791 |  | UI_PROP | res.ServiceUri | BLUtils.GSCM_SCM_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-31efcdfa | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:792 |  | UI_PROP | res.QueryId | "SCP.SCP0006_GET_PROJECT_ROUTE_PLANT" | 속성 QueryId 설정 |  |  |  |
| AC-a242ef39 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:794 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", _siteDivision)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a7776bc | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:795 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_scm_site_id", _siteScmSiteId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-240c4bf5 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:796 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_project_code", _siteProject)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0027705 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:797 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", _bomItemId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-592397a3 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:799 |  | DATA_OP | this.QueryDics[DIC_GET_PLANT] | new List<QueryInfo>() { res } | 행/컬럼 값 대입 |  |  |  |
| AC-7ad720b6 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:801 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.GetQueryInfoSavePlant

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d202b441 | SaveButton | SCP0006_ProjectRoute.cs:820 |  | UI_PROP | res.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-5b0560b3 | SaveButton | SCP0006_ProjectRoute.cs:821 |  | UI_PROP | res.AfterExecuteSQLProc | this.AfterSaveDataPlant | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-d1e6e343 | SaveButton | SCP0006_ProjectRoute.cs:822 |  | UI_PROP | res.ServiceUri | BLUtils.GSCM_SCM_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-aa2d98dc | SaveButton | SCP0006_ProjectRoute.cs:823 |  | UI_PROP | res.QueryId | "SCP.SCP0006_SAVE_PROJECT_ROUTE_PLANT" | 속성 QueryId 설정 |  |  |  |
| AC-f3fec508 | SaveButton | SCP0006_ProjectRoute.cs:825 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_active_flag", plant_active_flag)) | 데이터 객체 조작/조회 |  |  |  |
| AC-55be35a1 | SaveButton | SCP0006_ProjectRoute.cs:826 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_priority_seq", plant_priority_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c188c251 | SaveButton | SCP0006_ProjectRoute.cs:827 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", plant_division_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9aab84b9 | SaveButton | SCP0006_ProjectRoute.cs:828 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_project_code", plant_project_code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef29348d | SaveButton | SCP0006_ProjectRoute.cs:829 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_scm_site_id", plant_scm_site_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ff61233 | SaveButton | SCP0006_ProjectRoute.cs:830 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_site_id", plant_plant_site_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93f407d7 | SaveButton | SCP0006_ProjectRoute.cs:831 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", plant_item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-616805bd | SaveButton | SCP0006_ProjectRoute.cs:832 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_priority", plant_priority)) | 데이터 객체 조작/조회 |  |  |  |
| AC-71060798 | SaveButton | SCP0006_ProjectRoute.cs:833 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", plant_from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcdfb533 | SaveButton | SCP0006_ProjectRoute.cs:834 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", plant_to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0319837f | SaveButton | SCP0006_ProjectRoute.cs:835 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_valid_yn", plant_valid_yn)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcfa2353 | SaveButton | SCP0006_ProjectRoute.cs:836 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_created_by", plant_created_by)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f12db21f | SaveButton | SCP0006_ProjectRoute.cs:837 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_creation_date", plant_creation_date)) | 데이터 객체 조작/조회 |  |  |  |
| AC-91b818b9 | SaveButton | SCP0006_ProjectRoute.cs:838 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("p_last_updated_by", plant_last_updated_by)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6507e41 | SaveButton | SCP0006_ProjectRoute.cs:839 |  | DATA_OP | res.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8521e7e | SaveButton | SCP0006_ProjectRoute.cs:841 |  | DATA_OP | this.QueryDics[DIC_SAVE_PLANT] | new List<QueryInfo>() { res } | 행/컬럼 값 대입 |  |  |  |
| AC-1e2c6ab6 | SaveButton | SCP0006_ProjectRoute.cs:843 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13a5bcd1 | this.Load | SCP0006_ProjectRoute.cs:246 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-0b105f71 | this.Load | SCP0006_ProjectRoute.cs:249 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtSite) | 데이터 객체 조작/조회 |  |  |  |
| AC-96347129 | this.Load | SCP0006_ProjectRoute.cs:250 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtBOM) | 데이터 객체 조작/조회 |  |  |  |
| AC-56a04c57 | this.Load | SCP0006_ProjectRoute.cs:252 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e964435a | this.Load | SCP0006_ProjectRoute.cs:254 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ac57427d | this.Load | SCP0006_ProjectRoute.cs:261 |  | UI_PROP | drpPeriod.MonthText2 | toDate | 속성 MonthText2 설정 |  |  |  |
| AC-ffc26032 | this.Load | SCP0006_ProjectRoute.cs:263 |  | UI_PROP | drpPeriod.MonthMin1 | strStartYYYYMM + "01" | 속성 MonthMin1 설정 |  |  |  |
| AC-ff9d9bd1 | this.Load | SCP0006_ProjectRoute.cs:264 |  | UI_PROP | drpPeriod.MonthMax1 | strStartYYYYMM + "01" | 속성 MonthMax1 설정 |  |  |  |
| AC-6f8bf2e7 | this.Load | SCP0006_ProjectRoute.cs:266 |  | LIST_REBIND | cboStatus.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCP0006_ProjectRoute.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f0813d2 | this.Load | SCP0006_ProjectRoute.cs:198 |  | DATA_OP | QueryDics.Add | (DIC_GET_SITE, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e8f6871 | this.Load | SCP0006_ProjectRoute.cs:199 |  | DATA_OP | QueryDics.Add | (DIC_GET_BOM, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-95701d89 | this.Load | SCP0006_ProjectRoute.cs:200 |  | DATA_OP | QueryDics.Add | (DIC_GET_PLANT, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-51067cee | this.Load | SCP0006_ProjectRoute.cs:201 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_PLANT, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0006_ProjectRoute.InitSpread

진입점: this.Load / spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c842cc9 | this.Load 외 2 | SCP0006_ProjectRoute.cs:301 | if (spreadInfo.SheetName == SpdSheet.shtSite) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-6a633e23 | this.Load 외 2 | SCP0006_ProjectRoute.cs:317 | if (spreadInfo.SheetName == SpdSheet.shtSite) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-29d353a6 | this.Load 외 2 | SCP0006_ProjectRoute.cs:320 | if (spreadInfo.SheetName == SpdSheet.shtSite) | STATE | col.Visible | !isDivision82 | 컨트롤 상태 Visible |  |  |  |
| AC-5d66a80e | this.Load 외 2 | SCP0006_ProjectRoute.cs:323 | if (spreadInfo.SheetName == SpdSheet.shtSite) | STATE | col.Visible | !isDivision82 | 컨트롤 상태 Visible |  |  |  |
| AC-44f257cb | this.Load 외 2 | SCP0006_ProjectRoute.cs:331 | if (spreadInfo.SheetName == SpdSheet.shtSite) ▸ try ▸ if (col.Visible) | STATE | col.Visible | !isDivision82 | 컨트롤 상태 Visible |  |  |  |
| AC-0bb303a1 | this.Load 외 2 | SCP0006_ProjectRoute.cs:346 | if (spreadInfo.SheetName == SpdSheet.shtBOM) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a3588552 | this.Load 외 2 | SCP0006_ProjectRoute.cs:362 | if (spreadInfo.SheetName == SpdSheet.shtBOM) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-5316ec8a | this.Load 외 2 | SCP0006_ProjectRoute.cs:363 | if (spreadInfo.SheetName == SpdSheet.shtBOM) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-968221f1 | this.Load 외 2 | SCP0006_ProjectRoute.cs:368 | if (spreadInfo.SheetName == SpdSheet.shtPlant) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-459963ef | this.Load 외 2 | SCP0006_ProjectRoute.cs:408 | if (spreadInfo.SheetName == SpdSheet.shtPlant) ▸ if (dtPlantSiteSpread != null) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantByDivisionOperationItem", dtPlantSiteSpread) | 목록 컨트롤 재구성 |  |  |  |
| AC-0a5ea4b6 | this.Load 외 2 | SCP0006_ProjectRoute.cs:411 | if (spreadInfo.SheetName == SpdSheet.shtPlant) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-88999c7f | this.Load 외 2 | SCP0006_ProjectRoute.cs:412 | if (spreadInfo.SheetName == SpdSheet.shtPlant) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0006_ProjectRoute.InitSpreadBOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb563756 | (진입점 미연결) | SCP0006_ProjectRoute.cs:568 |  | GRID_INIT | siBOM.ChangeSheet | (SpdSheet.shtBOM) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0006_ProjectRoute.InitSpreadPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e80cdadd | (진입점 미연결) | SCP0006_ProjectRoute.cs:574 |  | GRID_INIT | siPlant.ChangeSheet | (SpdSheet.shtPlant) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0006_ProjectRoute.InitSpreadSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50b16f25 | (진입점 미연결) | SCP0006_ProjectRoute.cs:562 |  | GRID_INIT | siSite.ChangeSheet | (SpdSheet.shtSite) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0006_ProjectRoute.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7dda9eb | InsertButton | SCP0006_ProjectRoute.cs:1026 | if (fps != null) ▸ if (fps.Name == "spdMain" \|\| fps.Name == "spdBOM") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb6a8c59 | InsertButton | SCP0006_ProjectRoute.cs:1039 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) ▸ if (!isBomClick \|\| stri… | MESSAGE | MessageHelper.GMessageBox | ("MSG00116", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d21ebfc | InsertButton | SCP0006_ProjectRoute.cs:1040 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) ▸ if (!isBomClick \|\| stri… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd9646dd | InsertButton | SCP0006_ProjectRoute.cs:1042 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | DATA_OP | siPlant.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-937e9449 | InsertButton | SCP0006_ProjectRoute.cs:1045 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, _siteDivision) | 데이터 객체 조작/조회 |  |  |  |
| AC-b04914e5 | InsertButton | SCP0006_ProjectRoute.cs:1046 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | DATA_OP | defaultData.Add | (DefColumns.SCM_SITE_ID, _siteScmSiteId) | 데이터 객체 조작/조회 |  |  |  |
| AC-756e587e | InsertButton | SCP0006_ProjectRoute.cs:1047 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | DATA_OP | defaultData.Add | (DefColumns.PROJECT_CODE, _siteProject) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ac4bfa3 | InsertButton | SCP0006_ProjectRoute.cs:1048 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, _bomItemId) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0362fb8 | InsertButton | SCP0006_ProjectRoute.cs:1049 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-1aeee268 | InsertButton | SCP0006_ProjectRoute.cs:1051 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | GRID_SET | siPlant.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-dabb5aae | InsertButton | SCP0006_ProjectRoute.cs:1054 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | GRID_LOCK | siPlant.LockRange | (insCell,siPlant.GetColumnIndex(DefColumns.ITEM_ID), siPlant.GetColumnIndex(DefColumns.ITE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b0dc6e12 | InsertButton | SCP0006_ProjectRoute.cs:1055 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | GRID_LOCK | siPlant.LockRange | (insCell, siPlant.GetColumnIndex(DefColumns.PRIORITY_SEQ), siPlant.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f0f9171 | InsertButton | SCP0006_ProjectRoute.cs:1056 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | GRID_LOCK | siPlant.LockRange | (insCell, siPlant.GetColumnIndex(DefColumns.DIVISION_ID), siPlant.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d6b61c6 | InsertButton | SCP0006_ProjectRoute.cs:1057 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | GRID_LOCK | siPlant.LockRange | (insCell, siPlant.GetColumnIndex(DefColumns.PROJECT_CODE), siPlant.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-82401507 | InsertButton | SCP0006_ProjectRoute.cs:1058 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | GRID_LOCK | siPlant.LockRange | (insCell, siPlant.GetColumnIndex(DefColumns.SCM_SITE_ID), siPlant.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fd329f2e | InsertButton | SCP0006_ProjectRoute.cs:1059 | if (siPlant != null && siPlant.IsLock(siPlant.SheetName) == false) ▸ if (siPlant.SheetName == SpdSheet.shtPlant) | GRID_LOCK | siPlant.LockRange | (insCell,siPlant.GetColumnIndex(DefColumns.CREATED_BY), siPlant.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0006_ProjectRoute.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eda968ef | SaveButton | SCP0006_ProjectRoute.cs:997 |  | ENDPOINT | this.ExecuteSQL | (new List<SpreadInfo>() { this.siPlant, this.siBOM, this.siPlant } , new List<string>() { … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0006_ProjectRoute.SaveDataPlant

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1ba3ff6 | SaveButton | SCP0006_ProjectRoute.cs:1008 | if (!CheckChangedValues(ref changedCnt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e6f249f | SaveButton | SCP0006_ProjectRoute.cs:1012 | if (changedCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0622718 | SaveButton | SCP0006_ProjectRoute.cs:1014 | if (changedCnt == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0006_ProjectRoute.SetCalendar

진입점: this.Load [if (spreadInfo.SheetName == SpdSheet.shtSite)] / spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (spreadInfo.SheetName == SpdSheet.shtSite)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dfdc25c | this.Load [if (spreadInfo.SheetName == SpdSheet.shtSite)] 외 2 | SCP0006_ProjectRoute.cs:419 |  | FLAG | dtCalendar | Data.Common(Data.Type.CalendarMonth, false, drpPeriod.MonthText1.Replace("-", ""), drpPeri… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 화면 필드/플래그 변경 |  |  |  |
| AC-555875c8 | this.Load [if (spreadInfo.SheetName == SpdSheet.shtSite)] 외 2 | SCP0006_ProjectRoute.cs:419 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, drpPeriod.MonthText1.Replace("-", ""), drpPeriod.MonthTex… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c405e73f | this.Load [if (spreadInfo.SheetName == SpdSheet.shtSite)] 외 2 | SCP0006_ProjectRoute.cs:426 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c0b5e1b | this.Load [if (spreadInfo.SheetName == SpdSheet.shtSite)] 외 2 | SCP0006_ProjectRoute.cs:427 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-69d56d98 | this.Load [if (spreadInfo.SheetName == SpdSheet.shtSite)] 외 2 | SCP0006_ProjectRoute.cs:429 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.AddNumColumn | (sYYYYMM_NAME, sYYYYMM, FPMerge.None, 75, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0006_ProjectRoute.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96cf9d44 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1080 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtSalesSite | DBUtils.Filter(dtSalesSiteAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c04a1a8b | this.Load 외 1 | SCP0006_ProjectRoute.cs:1080 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtSalesSiteAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-de0daa33 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1081 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4b8b0aca | this.Load 외 1 | SCP0006_ProjectRoute.cs:1083 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtBuilding | DBUtils.Filter(dtBuildingAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ffb5f007 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1083 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtBuildingAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-85437fc9 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1085 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlantSiteSpread | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperationItem, false, this._siteDivision, thi… | 화면 필드/플래그 변경 |  |  |  |
| AC-6a0a2e74 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1085 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperationItem, false, this._siteDivision, this._bomOperation… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd56c96b | this.Load 외 1 | SCP0006_ProjectRoute.cs:1089 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division == "82" \|\| division == "40") | CALL_EXT | clbSalesSite.SetValues | ("ALL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2982f60c | this.Load 외 1 | SCP0006_ProjectRoute.cs:1090 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division == "82" \|\| division == "40") | STATE | clbSalesSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e9412ad4 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1091 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division == "82" \|\| division == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-579648d8 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1092 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division == "82" \|\| division == "40") | STATE | txtProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-31c94342 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1093 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division == "82" \|\| division == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-07d13653 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1097 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division == "82" \|\| division == "40") | CALL_EXT | clbSalesSite.SetValues | ("ALL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fdc3311 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1098 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division == "82" \|\| division == "40") | STATE | clbSalesSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-675e46fa | this.Load 외 1 | SCP0006_ProjectRoute.cs:1099 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division == "82" \|\| division == "40") | STATE | txtProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f6ca2ac0 | this.Load 외 1 | SCP0006_ProjectRoute.cs:1100 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division == "82" \|\| division == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0006_ProjectRoute.SetChangedPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88129bc1 | this.Load | SCP0006_ProjectRoute.cs:1112 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2c5e1cc7 | this.Load | SCP0006_ProjectRoute.cs:1115 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00d63de7 | this.Load | SCP0006_ProjectRoute.cs:1119 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0,6) | 속성 MonthText1 설정 |  |  |  |
| AC-00f22d55 | this.Load | SCP0006_ProjectRoute.cs:1120 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |

## SCP0006_ProjectRoute.SetOrgData

진입점: dsdm.Changed [if (e.Column == siPlant.GetColumnIndex(DefColumns.FROM_YYYYMMDD) \|\| e.Column == siPlant.GetColumnIndex(DefColumns.TO_YYYYMMD…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f559f0b | dsdm.Changed [if (e.Column == siPlant.GetColumnIndex(DefColu… | SCP0006_ProjectRoute.cs:1377 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_FROM_YYYYMMDD] | strFROM_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-6d499b6d | dsdm.Changed [if (e.Column == siPlant.GetColumnIndex(DefColu… | SCP0006_ProjectRoute.cs:1378 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.ORG_TO_YYYYMMDD] | strTO_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-dbdcedee | dsdm.Changed [if (e.Column == siPlant.GetColumnIndex(DefColu… | SCP0006_ProjectRoute.cs:1379 |  | GRID_SET | dt.Rows[nRowIdx][DefColumns.MERGE_DATE] | strFROM_YYYYMMDD + strTO_YYYYMMDD | 그리드 속성/값 설정 |  |  |  |
| AC-7925708e | dsdm.Changed [if (e.Column == siPlant.GetColumnIndex(DefColu… | SCP0006_ProjectRoute.cs:1381 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0006_ProjectRoute.SetQueryInfoGetBOM

진입점: spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026bbc1f | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:776 | if (this.QueryDics[DIC_GET_BOM].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_BOM].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-24dceb46 | spdMain.CellDoubleClick [else of (siSite.ActiveSheet.Columns… 외 2 | SCP0006_ProjectRoute.cs:781 |  | DATA_OP | this.QueryDics[DIC_GET_BOM] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0006_ProjectRoute.SetQueryInfoGetPlant

진입점: spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible)] / SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e240153 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:808 | if (this.QueryDics[DIC_GET_PLANT].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_PLANT].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ff86580 | spdBOM.CellDoubleClick [else of (siBOM.ActiveSheet.Columns[C… 외 2 | SCP0006_ProjectRoute.cs:813 |  | DATA_OP | this.QueryDics[DIC_GET_PLANT] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0006_ProjectRoute.SetQueryInfoSavePlant

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32581fbd | SaveButton | SCP0006_ProjectRoute.cs:850 | if (this.QueryDics[DIC_SAVE_PLANT].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_PLANT].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-508c4644 | SaveButton | SCP0006_ProjectRoute.cs:855 |  | DATA_OP | this.QueryDics[DIC_SAVE_PLANT] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0006_ProjectRoute.spdBOM_CellDoubleClick

진입점: spdBOM.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c982ee36 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1226 | if (siBOM.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1733660 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1235 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this.spdBomSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4d241abc | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1236 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this.spdBomSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-760a25a0 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1239 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | dtOsPackItem | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2521966b | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1241 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._siteDivision | siBOM.GetText(e.Row, siBOM.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-603d350d | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1242 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._siteScmSiteId | siBOM.GetText(e.Row, siBOM.GetColumnIndex(DefColumns.SCM_SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-d03700cf | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1243 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._bomItemId | siBOM.GetText(e.Row, siBOM.GetColumnIndex(DefColumns.ITEM_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-8bdc63d0 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1244 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._siteProject | siBOM.GetText(e.Row, siBOM.GetColumnIndex(DefColumns.PROJECT_CODE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-85729f8b | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1245 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._bomOperationId | siBOM.GetText(e.Row, siBOM.GetColumnIndex(DefColumns.OPERATION_GROUP_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-7be34d8b | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1246 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._bomCellType | siBOM.GetText(e.Row, siBOM.GetColumnIndex(DefColumns.CELL_TYPE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b66277f | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1253 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | dtPlantSitedSpreadAll.AsEnumerable().SelectMany | (row => row.ItemArray) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33d5661e | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1257 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (!containsNull) | FLAG | dtPlantSitedSpreadAll | Data_SCP.CommonAll(Data_SCP.Type.PlantByDivisionOperationItem1, false, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-ce51e925 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1257 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (!containsNull) | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.PlantByDivisionOperationItem1, false, "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f49e3cc9 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1260 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | dtPlantSiteSpread | Data_SCP.Common(Data_SCP.Type.PlantByDivisionOperationItem, false, this._siteDivision, thi… | 화면 필드/플래그 변경 |  |  |  |
| AC-3817d729 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1260 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByDivisionOperationItem, false, this._siteDivision, this._bomOperation… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c7ba3b42 | spdBOM.CellDoubleClick | SCP0006_ProjectRoute.cs:1267 | else of (siBOM.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | isBomClick | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0006_ProjectRoute.spdPlant_CellDoubleClick

진입점: spdPlant.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddf357c6 | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1392 | if (siPlant.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d07c82f | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1403 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | siPlant.GetValueObject | (e.Row, siPlant.GetColumnIndex(DefColumns.ITEM_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6837ffc | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1404 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | siPlant.GetValueObject | (e.Row, siPlant.GetColumnIndex(DefColumns.PLANT_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39638c52 | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1405 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | siPlant.GetValueObject | (e.Row, siPlant.GetColumnIndex(DefColumns.OPERATION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2da86992 | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1406 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | siPlant.GetValueObject | (e.Row, siPlant.GetColumnIndex(DefColumns.OPERATION_GROUP_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-84b96ab5 | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1437 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | POPUP | new SCP0049_CAPANewModelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5746cf9c | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1439 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | CALL_EXT | popup.LoadData | (UserInfo.UserId, bomDivision, plantPlantId, strOperationGroupId, "ALL", "ALL", strOperati… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0421a33 | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1440 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5ecc5d73 | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1441 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e8bb660c | spdPlant.CellDoubleClick | SCP0006_ProjectRoute.cs:1443 | else of (siPlant.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | isBomClick | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0006_ProjectRoute.spdSite_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb039c78 | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1198 | if (siSite.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49027f32 | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1207 | else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this.spdMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-27c6cdd5 | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1208 | else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this.spdMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-166324b7 | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1210 | else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._siteDivision | siSite.GetText(e.Row, siSite.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-cbe536d8 | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1211 | else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._siteScmSiteId | siSite.GetText(e.Row, siSite.GetColumnIndex(DefColumns.SCM_SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5fce1f3 | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1212 | else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._siteItemId | siSite.GetText(e.Row, siSite.GetColumnIndex(DefColumns.ITEM_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-06718703 | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1213 | else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | this._siteProject | siSite.GetText(e.Row, siSite.GetColumnIndex(DefColumns.PROJECT_CODE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-7814f9ba | spdMain.CellDoubleClick | SCP0006_ProjectRoute.cs:1219 | else of (siSite.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | FLAG | isBomClick | false | 화면 필드/플래그 변경 |  |  |  |

