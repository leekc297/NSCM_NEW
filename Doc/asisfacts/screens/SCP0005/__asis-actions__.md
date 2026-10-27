# AS-IS 액션 대조표 — SCP0005

> 원천: `Doc/asisfacts/screens/SCP0005/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 266행 · 메서드 36 · 종류 DATA_OP 67 · GRID_SET 33 · GRID_INIT 25 · UI_PROP 21 · RETURN 21 · POPUP 14 · ENDPOINT 14 · GRID_LOCK 13 · MESSAGE 12 · GRID_STYLE 11 · UI_MISC 10 · FLAG 7 · VALUE_SET 5 · COMBO_DATA 4 · GRID_BIND 3 · CALL_EXT 2 · LIST_REBIND 2 · CALL_BASE 1 · VALIDATE 1 · ⚠ 의미 확인 필요 3


## SCP0005_DistributionRoute.btnEaxel_Upload_Click

진입점: this.btnEaxel_Upload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aabf40d9 | this.btnEaxel_Upload.Click | SCP0005_DistributionRoute.cs:376 |  | POPUP | new ExcelUploadForm2 | ("SCP0005", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-574e0d9a | this.btnEaxel_Upload.Click | SCP0005_DistributionRoute.cs:377 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-a08e2e85 | this.btnEaxel_Upload.Click | SCP0005_DistributionRoute.cs:378 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cc5053b4 | this.btnEaxel_Upload.Click | SCP0005_DistributionRoute.cs:379 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-57f5cba8 | this.btnEaxel_Upload.Click | SCP0005_DistributionRoute.cs:381 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0005_DistributionRoute.btnExcel_Form_Click

진입점: this.btnExcel_Form.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c0a6366 | this.btnExcel_Form.Click | SCP0005_DistributionRoute.cs:1385 |  | CALL_BASE | MenuEtcFileDownButton | ("DistributionRoute_ExcelForm.xls") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0005_DistributionRoute.btnFromSrch_Click

진입점: this.btnFromSrch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeca893d | this.btnFromSrch.Click | SCP0005_DistributionRoute.cs:344 |  | POPUP | popCity.Form_Load | (true, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ade4f8d6 | this.btnFromSrch.Click | SCP0005_DistributionRoute.cs:345 |  | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3f531c1a | this.btnFromSrch.Click | SCP0005_DistributionRoute.cs:346 |  | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-735052c9 | this.btnFromSrch.Click | SCP0005_DistributionRoute.cs:350 | if (popCity.Country != "") | VALUE_SET | txtFromCountry.Text | popCity.Country | 컨트롤 값 설정 |  |  |  |
| AC-d0d93373 | this.btnFromSrch.Click | SCP0005_DistributionRoute.cs:351 | if (popCity.Country != "") | VALUE_SET | txtFromCity.Text | popCity.City | 컨트롤 값 설정 |  |  |  |

## SCP0005_DistributionRoute.btnToSrch_Click

진입점: this.btnToSrch.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11b0c68a | this.btnToSrch.Click | SCP0005_DistributionRoute.cs:362 |  | POPUP | popCity.Form_Load | (true, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-cf0d36f9 | this.btnToSrch.Click | SCP0005_DistributionRoute.cs:363 |  | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0470296d | this.btnToSrch.Click | SCP0005_DistributionRoute.cs:364 |  | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3a04de25 | this.btnToSrch.Click | SCP0005_DistributionRoute.cs:368 | if (popCity.Country != "") | VALUE_SET | txtToCountry.Text | popCity.Country | 컨트롤 값 설정 |  |  |  |
| AC-5a72d3a4 | this.btnToSrch.Click | SCP0005_DistributionRoute.cs:369 | if (popCity.Country != "") | VALUE_SET | txtToCity.Text | popCity.City | 컨트롤 값 설정 |  |  |  |

## SCP0005_DistributionRoute.checkCtiyCode

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26550000 | (진입점 미연결) | SCP0005_DistributionRoute.cs:1257 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0005_DistributionRoute.CheckValid

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-074271b9 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1276 | for (i< siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (i, nPriorityIdx1, i, nPriorityIdx1, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-d402bff5 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1278 | for (i< siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (i, nFromCityName, i, siMain.GetColumnIndex(DefColumns.FROM_CITY), ControlColor.UnLockColo… | 그리드 표시 설정 |  |  |  |
| AC-ca6394cb | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1279 | for (i< siMain.ActiveSheet.RowCount) | GRID_STYLE | siMain.SetBGColor | (i, nToCityName, i, siMain.GetColumnIndex(DefColumns.TO_CITY), ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-f42493aa | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1296 | for (i < siMain.ActiveSheet.RowCount) ▸ if (intPRIORITY < 1) | GRID_STYLE | siMain.SetBGColor | (i, nPriorityIdx1, i, nPriorityIdx1, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-4a171358 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1297 | for (i < siMain.ActiveSheet.RowCount) ▸ if (intPRIORITY < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00107", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdcf0e27 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1305 | for (i < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrEmpty(strFromCity)) | GRID_STYLE | siMain.SetBGColor | (i, nFromCityName, i, siMain.GetColumnIndex(DefColumns.FROM_CITY), ControlColor.InvalidCol… | 그리드 표시 설정 |  |  |  |
| AC-158bff4b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1306 | for (i < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrEmpty(strFromCity)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00167", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-196c6804 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1313 | for (i < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrEmpty(strToCity)) | GRID_STYLE | siMain.SetBGColor | (i, nToCityName, i, siMain.GetColumnIndex(DefColumns.TO_CITY), ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-3312eaba | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1314 | for (i < siMain.ActiveSheet.RowCount) ▸ if (string.IsNullOrEmpty(strToCity)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00167", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb5d042a | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1325 | if (isPassPriority == false \|\| isPassFromCity == false \|\| isPassToCity == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6df869e7 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | SCP0005_DistributionRoute.cs:1328 | else of (isPassPriority == false \|\| isPassFromCity == false \|\| isPassToCity == false) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0005_DistributionRoute.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-868b39be | this.Load | SCP0005_DistributionRoute.cs:233 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8d3965f | this.Load | SCP0005_DistributionRoute.cs:234 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cca2d563 | this.Load | SCP0005_DistributionRoute.cs:236 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0005_DistributionRoute.CSafeSetText

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02916d30 | (진입점 미연결) | SCP0005_DistributionRoute.cs:160 | if (ctl.InvokeRequired) | CALL_EXT | ctl.Invoke | (new CrossThreadSafetySetText(CSafeSetText), ctl, text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-577b851b | (진입점 미연결) | SCP0005_DistributionRoute.cs:162 | else of (ctl.InvokeRequired) | VALUE_SET | ctl.Text | text | 컨트롤 값 설정 |  |  |  |

## SCP0005_DistributionRoute.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b865fb6 | this.Load | SCP0005_DistributionRoute.cs:220 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-7aaac2d7 | this.Load | SCP0005_DistributionRoute.cs:222 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-ad1eb3e9 | this.Load | SCP0005_DistributionRoute.cs:223 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-5e8b58ee | this.Load | SCP0005_DistributionRoute.cs:224 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0005_DistributionRoute.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cae56b67 | DeleteButton | SCP0005_DistributionRoute.cs:305 | if (action != CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2173a6c | DeleteButton | SCP0005_DistributionRoute.cs:307 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0005_DistributionRoute.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03cef4fa | Dispose | SCP0005_DistributionRoute.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0005_DistributionRoute.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bea37ce6 | EditButton | SCP0005_DistributionRoute.cs:318 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e55137f | EditButton | SCP0005_DistributionRoute.cs:319 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-17f70b93 | EditButton | SCP0005_DistributionRoute.cs:321 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ROUTE_ID), siMain.GetColumnIndex(DefColumns.ROUTE_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-97d3bb74 | EditButton | SCP0005_DistributionRoute.cs:322 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_CITY_NAME), siMain.GetColumnIndex(DefColumns.FROM_C… | 그리드 편집 잠금/해제 |  |  |  |
| AC-04e150dd | EditButton | SCP0005_DistributionRoute.cs:323 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TO_CITY_NAME), siMain.GetColumnIndex(DefColumns.TO_CITY_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-681377d9 | EditButton | SCP0005_DistributionRoute.cs:324 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LT_SUM), siMain.GetColumnIndex(DefColumns.LT_SUM), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-24938c2d | EditButton | SCP0005_DistributionRoute.cs:325 | if (this.fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0005_DistributionRoute.FindDataMain

진입점: this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (IgnoreSearchCondition == true)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8096c751 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:393 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f7c32f3f | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:417 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d94df456 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:418 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2eaf0fed | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:420 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b7fc7004 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:424 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0005_GET_DISTRIBUTION_ROUTE") ⇒ SCP.SCP0005_GET_DISTRIBUTION_ROUTE | 엔드포인트 요청 생성 |  |  |  |
| AC-b5a93c75 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:425 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5e14b827 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:426 | try ▸ lambda | DATA_OP | request.Parameters["p_from_country"] | p_from_country | 행/컬럼 값 대입 |  |  |  |
| AC-1eb95d52 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:427 | try ▸ lambda | DATA_OP | request.Parameters["p_from_city"] | p_from_city | 행/컬럼 값 대입 |  |  |  |
| AC-212c9548 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:428 | try ▸ lambda | DATA_OP | request.Parameters["p_to_country"] | p_to_country | 행/컬럼 값 대입 |  |  |  |
| AC-16437b8e | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:429 | try ▸ lambda | DATA_OP | request.Parameters["p_to_city"] | p_to_city | 행/컬럼 값 대입 |  |  |  |
| AC-1d309658 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:430 | try ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-3c9fdea4 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:431 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-f0a62b0e | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:433 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4941194 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:435 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-31e30188 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:442 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-13f0e46a | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:443 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fca92738 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:448 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-724c9fb1 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:457 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7382c088 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:468 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88d6fec9 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:472 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0005_DistributionRoute.FindDataReceive

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (IgnoreSearchCondition == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0b119d8 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:481 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a70d80ac | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:492 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1b973ac4 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:493 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1254589f | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:495 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fbe8c5ec | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:499 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0005_GET_DISTRIBUTION_ROUTEID") ⇒ SCP.SCP0005_GET_DISTRIBUTION_ROUTEID | 엔드포인트 요청 생성 |  |  |  |
| AC-ce451852 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:500 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c24a497a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:501 | try ▸ lambda | DATA_OP | request.Parameters["p_route_id"] | receiveRouteID | 행/컬럼 값 대입 |  |  |  |
| AC-f8c2ccd0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:502 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c60ebd42 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:504 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c4986934 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:511 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e461b6c5 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:512 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d222853e | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:517 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c87dbd46 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:526 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d164c864 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:537 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76a37e79 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ … | SCP0005_DistributionRoute.cs:541 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0005_DistributionRoute.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-175432ad | this.Load | SCP0005_DistributionRoute.cs:169 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e8af12a | this.Load | SCP0005_DistributionRoute.cs:170 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0005_DistributionRoute.GetBodType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9359778b | (진입점 미연결) | SCP0005_DistributionRoute.cs:1207 |  | COMBO_DATA | Data.Common | (Data.Type.BodType, false) ⇒ biz:CommonData.CommonDataList [code=BodType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52ebf0fe | (진입점 미연결) | SCP0005_DistributionRoute.cs:1209 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0005_DistributionRoute.GetData_Country

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4464865c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:911 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ec545cdb | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:912 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-47feaf86 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:916 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0005_GET_COUNTRY_CITY") ⇒ SCP.SCP0005_GET_COUNTRY_CITY | 엔드포인트 요청 생성 |  |  |  |
| AC-6b1090b9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:917 | lambda | DATA_OP | request.Parameters["p_country"] | p_country | 행/컬럼 값 대입 |  |  |  |
| AC-d2142b91 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:918 | lambda | DATA_OP | request.Parameters["p_city"] | p_city | 행/컬럼 값 대입 |  |  |  |
| AC-115e2cc2 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:919 | lambda | DATA_OP | request.Parameters["p_city_name"] | p_city_name | 행/컬럼 값 대입 |  |  |  |
| AC-48f67a5a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:920 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-c512994a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:922 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2e4122d | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:924 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dbd12519 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | SCP0005_DistributionRoute.cs:928 |  | FLAG | dtCountryCity | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## SCP0005_DistributionRoute.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b096807f | (진입점 미연결) | SCP0005_DistributionRoute.cs:1178 |  | CALL_EXT | BLUtils.GetDivisionWithoutEE | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3350d05a | (진입점 미연결) | SCP0005_DistributionRoute.cs:1180 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0005_DistributionRoute.GetFromSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f33cc06 | (진입점 미연결) | SCP0005_DistributionRoute.cs:1187 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, division, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a011dd1 | (진입점 미연결) | SCP0005_DistributionRoute.cs:1188 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0005_DistributionRoute.GetToSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-866e5de8 | (진입점 미연결) | SCP0005_DistributionRoute.cs:1195 |  | COMBO_DATA | Data.Common | (Data.Type.ToSiteByDivision, false, division, UserGroup, UserId) ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95ea3f8c | (진입점 미연결) | SCP0005_DistributionRoute.cs:1197 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0005_DistributionRoute.GetTransMode

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f25ec76 | (진입점 미연결) | SCP0005_DistributionRoute.cs:1217 |  | COMBO_DATA | Data.Common | (Data.Type.TransportMode, false) ⇒ biz:CommonData.CommonDataList [code=TransportMode] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-556824a6 | (진입점 미연결) | SCP0005_DistributionRoute.cs:1218 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0005_DistributionRoute.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1c55fdc | this.Load | SCP0005_DistributionRoute.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransMode, clbTransMode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3073c564 | this.Load | SCP0005_DistributionRoute.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtValidYN, cboValidYN, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-10d35a06 | this.Load | SCP0005_DistributionRoute.cs:208 | if (IgnoreSearchCondition == true) | DATA_OP | ManualSearchCondition.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-50f98e57 | this.Load | SCP0005_DistributionRoute.cs:210 | if (IgnoreSearchCondition == true) ▸ if (ManualSearchCondition.Tables[0].Select().Where(c => c["ControlName"].ToString() == "ROUTE_ID").ToLi… | FLAG | receiveRouteID | ManualSearchCondition.Tables[0].Rows[0]["ControlValue"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## SCP0005_DistributionRoute.InitSpread

진입점: this.Load / this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (IgnoreSearchCondition == true) ▸ try] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0adc9e7d | this.Load 외 3 | SCP0005_DistributionRoute.cs:245 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-680b97e5 | this.Load 외 3 | SCP0005_DistributionRoute.cs:246 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-d00de4b4 | this.Load 외 3 | SCP0005_DistributionRoute.cs:247 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5a9d99fa | this.Load 외 3 | SCP0005_DistributionRoute.cs:249 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.PRIORITY), 0, 0,99) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4d3a4494 | this.Load 외 3 | SCP0005_DistributionRoute.cs:250 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.SHIP_DOC_PREPARATION_DATE), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-57e09b3d | this.Load 외 3 | SCP0005_DistributionRoute.cs:251 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_DEPARTURE_INLAND), 0, 0,999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b7414c6c | this.Load 외 3 | SCP0005_DistributionRoute.cs:252 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_WAIT_SHIPPING), 0, 0,999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4fbe26ea | this.Load 외 3 | SCP0005_DistributionRoute.cs:253 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_VOYAGE), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-623ed4fc | this.Load 외 3 | SCP0005_DistributionRoute.cs:254 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_LAY_OFF_CLEARANCE), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-159b7323 | this.Load 외 3 | SCP0005_DistributionRoute.cs:255 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_ARRIVAL_INLAND), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0005_DistributionRoute.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11bfb3c5 | InsertButton | SCP0005_DistributionRoute.cs:944 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-119328da | InsertButton | SCP0005_DistributionRoute.cs:947 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-36e53395 | InsertButton | SCP0005_DistributionRoute.cs:950 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell,siMain.GetColumnIndex(DefColumns.ROUTE_ID), siMain.GetColumnIndex(DefColumns.ROUT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61292377 | InsertButton | SCP0005_DistributionRoute.cs:951 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FROM_CITY_NAME), siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51ce06b2 | InsertButton | SCP0005_DistributionRoute.cs:952 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell,siMain.GetColumnIndex(DefColumns.TO_CITY_NAME), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-671e3899 | InsertButton | SCP0005_DistributionRoute.cs:953 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell,siMain.GetColumnIndex(DefColumns.LT_SUM), siMain.GetColumnIndex(DefColumns.LT_SUM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-91e930ea | InsertButton | SCP0005_DistributionRoute.cs:954 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell,siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0005_DistributionRoute.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f415879 | SaveButton | SCP0005_DistributionRoute.cs:609 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10c0b296 | SaveButton | SCP0005_DistributionRoute.cs:653 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-ae28855a | SaveButton | SCP0005_DistributionRoute.cs:653 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7641b7c7 | SaveButton | SCP0005_DistributionRoute.cs:655 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!CheckValid()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-860bde62 | SaveButton | SCP0005_DistributionRoute.cs:736 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Stri… | MESSAGE | MessageHelper.GMessageBox | ("MSG00223", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7aed9be9 | SaveButton | SCP0005_DistributionRoute.cs:737 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (Stri… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0011da5 | SaveButton | SCP0005_DistributionRoute.cs:752 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE") ⇒ SCP.SCP0005_SAVE_DISTRIBUTION_ROUTE | 엔드포인트 요청 생성 |  |  |  |
| AC-099b17ae | SaveButton | SCP0005_DistributionRoute.cs:753 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-b94664b8 | SaveButton | SCP0005_DistributionRoute.cs:754 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_route_id"] | strROUTE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c49bdb9c | SaveButton | SCP0005_DistributionRoute.cs:755 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_country"] | strFROM_COUNTRY | 행/컬럼 값 대입 |  |  |  |
| AC-edb23b0f | SaveButton | SCP0005_DistributionRoute.cs:756 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_city"] | strFROM_CITY | 행/컬럼 값 대입 |  |  |  |
| AC-656196f6 | SaveButton | SCP0005_DistributionRoute.cs:757 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_from_city_name"] | strFROM_CITY_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-c65cef1c | SaveButton | SCP0005_DistributionRoute.cs:758 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_transport_mode"] | strTRANSPORT_MODE | 행/컬럼 값 대입 |  |  |  |
| AC-ccf386b1 | SaveButton | SCP0005_DistributionRoute.cs:759 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_priority"] | strPRIORITY | 행/컬럼 값 대입 |  |  |  |
| AC-ac17aa4d | SaveButton | SCP0005_DistributionRoute.cs:760 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_days_mon"] | strDAYS_MON | 행/컬럼 값 대입 |  |  |  |
| AC-cd66e79c | SaveButton | SCP0005_DistributionRoute.cs:761 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_days_tue"] | strDAYS_TUE | 행/컬럼 값 대입 |  |  |  |
| AC-db15ca80 | SaveButton | SCP0005_DistributionRoute.cs:762 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_days_wed"] | strDAYS_WED | 행/컬럼 값 대입 |  |  |  |
| AC-61a04b5e | SaveButton | SCP0005_DistributionRoute.cs:763 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_days_thu"] | strDAYS_THU | 행/컬럼 값 대입 |  |  |  |
| AC-3d878151 | SaveButton | SCP0005_DistributionRoute.cs:764 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_days_fri"] | strDAYS_FRI | 행/컬럼 값 대입 |  |  |  |
| AC-00326e88 | SaveButton | SCP0005_DistributionRoute.cs:765 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_days_sat"] | strDAYS_SAT | 행/컬럼 값 대입 |  |  |  |
| AC-66e43c35 | SaveButton | SCP0005_DistributionRoute.cs:766 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_days_sun"] | strDAYS_SUN | 행/컬럼 값 대입 |  |  |  |
| AC-126091d5 | SaveButton | SCP0005_DistributionRoute.cs:767 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_d_country"] | strD_COUNTRY | 행/컬럼 값 대입 |  |  |  |
| AC-c1ea1fb6 | SaveButton | SCP0005_DistributionRoute.cs:768 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_d_port_code"] | strD_PORT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-258c75f6 | SaveButton | SCP0005_DistributionRoute.cs:769 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_d_port_name"] | strD_PORT_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-767c9a7f | SaveButton | SCP0005_DistributionRoute.cs:770 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_a_country"] | strA_COUNTRY | 행/컬럼 값 대입 |  |  |  |
| AC-73613cf8 | SaveButton | SCP0005_DistributionRoute.cs:771 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_a_port_code"] | strA_PORT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-0216aa94 | SaveButton | SCP0005_DistributionRoute.cs:772 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_a_port_name"] | strA_PORT_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-6c46fc89 | SaveButton | SCP0005_DistributionRoute.cs:773 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipping_company"] | strSHIPPING_COMPANY | 행/컬럼 값 대입 |  |  |  |
| AC-9b979cd1 | SaveButton | SCP0005_DistributionRoute.cs:774 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_country"] | strTO_COUNTRY | 행/컬럼 값 대입 |  |  |  |
| AC-51c240df | SaveButton | SCP0005_DistributionRoute.cs:775 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_city"] | strTO_CITY | 행/컬럼 값 대입 |  |  |  |
| AC-54088789 | SaveButton | SCP0005_DistributionRoute.cs:776 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_to_city_name"] | strTO_CITY_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-4d937d6c | SaveButton | SCP0005_DistributionRoute.cs:777 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_ship_doc_preparation_date"] | strSHIP_DOC_PREPARATION_DATE | 행/컬럼 값 대입 |  |  |  |
| AC-faaeb748 | SaveButton | SCP0005_DistributionRoute.cs:778 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_lt_departure_inland"] | strLT_DEPARTURE_INLAND | 행/컬럼 값 대입 |  |  |  |
| AC-fdee7064 | SaveButton | SCP0005_DistributionRoute.cs:779 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_lt_wait_shipping"] | strLT_WAIT_SHIPPING | 행/컬럼 값 대입 |  |  |  |
| AC-a6eff1f8 | SaveButton | SCP0005_DistributionRoute.cs:780 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_lt_voyage"] | strLT_VOYAGE | 행/컬럼 값 대입 |  |  |  |
| AC-38ab666b | SaveButton | SCP0005_DistributionRoute.cs:781 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_lt_lay_off_clearance"] | strLT_LAY_OFF_CLEARANCE | 행/컬럼 값 대입 |  |  |  |
| AC-b386b8e8 | SaveButton | SCP0005_DistributionRoute.cs:782 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_lt_arrival_inland"] | strLT_ARRIVAL_INLAND | 행/컬럼 값 대입 |  |  |  |
| AC-fbf19b04 | SaveButton | SCP0005_DistributionRoute.cs:783 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | strVALID_YN | 행/컬럼 값 대입 |  |  |  |
| AC-c6600e0f | SaveButton | SCP0005_DistributionRoute.cs:785 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-6ef0541a | SaveButton | SCP0005_DistributionRoute.cs:786 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_lt_type"] | strLT_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-604640e5 | SaveButton | SCP0005_DistributionRoute.cs:788 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_OneSegmentCost"] | str_1SegmentCost | 행/컬럼 값 대입 |  |  |  |
| AC-192597f7 | SaveButton | SCP0005_DistributionRoute.cs:789 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_TwoSegmentCost"] | str_2SegmentCost | 행/컬럼 값 대입 |  |  |  |
| AC-507d27ee | SaveButton | SCP0005_DistributionRoute.cs:790 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_ThreeSegmentCost"] | str_3SegmentCost | 행/컬럼 값 대입 |  |  |  |
| AC-97ae5db9 | SaveButton | SCP0005_DistributionRoute.cs:792 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d045876a | SaveButton | SCP0005_DistributionRoute.cs:794 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 60 * 30 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ee7bfa28 | SaveButton | SCP0005_DistributionRoute.cs:796 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52952319 | SaveButton | SCP0005_DistributionRoute.cs:801 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { response.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4182fe9 | SaveButton | SCP0005_DistributionRoute.cs:813 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043", new object[] { "( Route Id : " +dtErr.Rows[0][DefColumns.ROUTE_ID].ToString()… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9358fd2 | SaveButton | SCP0005_DistributionRoute.cs:858 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.LT_TYPE), i, siMain.GetColumnIndex(DefColumns.TRANSPO… | 그리드 표시 설정 |  |  |  |
| AC-58427caf | SaveButton | SCP0005_DistributionRoute.cs:859 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.D_PORT_NAME), i, siMain.GetColumnIndex(DefColumns.TO_… | 그리드 표시 설정 |  |  |  |
| AC-4806443f | SaveButton | SCP0005_DistributionRoute.cs:861 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.FROM_CITY_NAME), i, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-1c8ca8a7 | SaveButton | SCP0005_DistributionRoute.cs:862 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PRIORITY), i, siMain.GetColumnIndex(DefColumns.PRIORI… | 그리드 표시 설정 |  |  |  |
| AC-2cf329e3 | SaveButton | SCP0005_DistributionRoute.cs:863 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TO_CITY_NAME), i, siMain.GetColumnIndex(DefColumns.TO… | 그리드 표시 설정 |  |  |  |
| AC-de9e1215 | SaveButton | SCP0005_DistributionRoute.cs:873 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e4539b3 | SaveButton | SCP0005_DistributionRoute.cs:883 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0005_DistributionRoute.SetCityCode

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.LT_ARRIVAL_INLAND) \|\| e.Column == siMain.GetColumnIndex(DefColumns.LT_WAIT_…) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TO_CITY))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b9b068e | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1347 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "FROM") | DATA_OP | dtCountryCity.Select | ("CITY = '" + strFROM_CITY.ToUpper() + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3d7b088 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1350 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "FROM") ▸ if (drsF… | DATA_OP | dr[DefColumns.FROM_COUNTRY] | drsFrom[0]["COUNTRY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b097ff0 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1351 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "FROM") ▸ if (drsF… | DATA_OP | dr[DefColumns.FROM_CITY] | drsFrom[0]["CITY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad7b425c | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1352 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "FROM") ▸ if (drsF… | DATA_OP | dr[DefColumns.FROM_CITY_NAME] | drsFrom[0]["CITY_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cd653668 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1355 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "FROM") ▸ else of … | DATA_OP | dr[DefColumns.FROM_COUNTRY] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-58f49918 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1356 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "FROM") ▸ else of … | DATA_OP | dr[DefColumns.FROM_CITY_NAME] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cfc4ee66 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1362 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "TO") | DATA_OP | dtCountryCity.Select | ("CITY = '" + strTO_CITY.ToUpper() + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-f80f9808 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1365 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "TO") ▸ if (drsTo.… | DATA_OP | dr[DefColumns.TO_COUNTRY] | drsTo[0]["COUNTRY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad91c4d4 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1366 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "TO") ▸ if (drsTo.… | DATA_OP | dr[DefColumns.TO_CITY] | drsTo[0]["CITY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80878c1d | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1367 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "TO") ▸ if (drsTo.… | DATA_OP | dr[DefColumns.TO_CITY_NAME] | drsTo[0]["CITY_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9806d88a | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1370 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "TO") ▸ else of (d… | DATA_OP | dr[DefColumns.TO_COUNTRY] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07cc3aba | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0005_DistributionRoute.cs:1371 | if (!string.IsNullOrEmpty(strFROM_CITY) \|\| !string.IsNullOrEmpty(strTO_CITY)) ▸ if (dtCountryCity != null) ▸ if (Loc == "TO") ▸ else of (d… | DATA_OP | dr[DefColumns.TO_CITY_NAME] | "" | 행/컬럼 값 대입 |  |  |  |

## SCP0005_DistributionRoute.SetImageCell

진입점: this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (IgnoreSearchCondition == true) ▸ try] / InsertButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dcb839c | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 3 | SCP0005_DistributionRoute.cs:590 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.FROM_COUNTRY)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-bae594de | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 3 | SCP0005_DistributionRoute.cs:591 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.FROM_CITY)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-aa7653b0 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 3 | SCP0005_DistributionRoute.cs:594 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TO_COUNTRY)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-af490436 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 3 | SCP0005_DistributionRoute.cs:595 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TO_CITY)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0005_DistributionRoute.SetSpreadColumn

진입점: this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (IgnoreSearchCondition == true) ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0)] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a99db43 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:560 | for (iRow < siMain.ActiveSheet.RowCount) | UI_PROP | row.Height | 60 | 속성 Height 설정 |  |  |  |
| AC-2b1a1f33 | this.btnEaxel_Upload.Click [if (MessageHelper.GMessageBox("M… 외 2 | SCP0005_DistributionRoute.cs:569 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case "ROUTE_ID": | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].BackColor | colorLink | 그리드 속성/값 설정 |  |  |  |

## SCP0005_DistributionRoute.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7317fdf0 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1091 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a17635b | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1095 | if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | POPUP | new GSCM.SCM.PopUp.UIL.SCP0005_DistributionRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-37d0e427 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1097 | if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | UI_PROP | popup.Width | 1280 | 속성 Width 설정 |  |  |  |
| AC-1e491c9d | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1098 | if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | UI_PROP | popup.Height | 600 | 속성 Height 설정 |  |  |  |
| AC-e18c1bad | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1099 | if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4c636ebd | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1100 | if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | UI_PROP | popup.ROUTE_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ROUTE_ID)).ToString() | 속성 ROUTE_ID 설정 |  |  |  |
| AC-fc5e02c4 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1103 | if (e.Column == siMain.GetColumnIndex(DefColumns.ROUTE_ID)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2524dd03 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1138 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f4a4e860 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1139 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18af0a62 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1140 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6daa9f61 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1152 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_COUNTRY), sCountry) | 그리드 값 설정 |  |  |  |
| AC-c28bc3e4 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1153 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_CITY), sCity) | 그리드 값 설정 |  |  |  |
| AC-4bb58056 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1154 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_CITY_NAME), sCityName) | 그리드 값 설정 |  |  |  |
| AC-ccd4976b | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1158 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_COUNTRY), sCountry) | 그리드 값 설정 |  |  |  |
| AC-28544b0a | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1159 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_CITY), sCity) | 그리드 값 설정 |  |  |  |
| AC-22a23441 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1160 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_CITY_NAME), sCityName) | 그리드 값 설정 |  |  |  |
| AC-689493c6 | spdMain.CellDoubleClick | SCP0005_DistributionRoute.cs:1166 | if (!siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_CITY) \|\| e.Column == siMain.GetColumnIndex(D… | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0005_DistributionRoute.spdMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3872448f | dsdm.Changed | SCP0005_DistributionRoute.cs:968 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb63a8de | dsdm.Changed | SCP0005_DistributionRoute.cs:972 | if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dcf8bc6 | dsdm.Changed | SCP0005_DistributionRoute.cs:1007 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | MESSAGE | MessageHelper.GMessageBox | ("MSG00209", new object[] { "Total L/T", "999" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4df437eb | dsdm.Changed | SCP0005_DistributionRoute.cs:1009 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | dt.Rows[nRow][DefColumns.LT_ARRIVAL_INLAND] | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-b48f48b4 | dsdm.Changed | SCP0005_DistributionRoute.cs:1012 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPING] | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-4c54d2f3 | dsdm.Changed | SCP0005_DistributionRoute.cs:1017 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | dt.Rows[nRow][DefColumns.LT_DEPARTURE_INLAND] | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-f6fb2011 | dsdm.Changed | SCP0005_DistributionRoute.cs:1022 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | dt.Rows[nRow][DefColumns.LT_LAY_OFF_CLEARANCE] | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-430654ae | dsdm.Changed | SCP0005_DistributionRoute.cs:1027 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | dt.Rows[nRow][DefColumns.LT_VOYAGE] | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-9c28535d | dsdm.Changed | SCP0005_DistributionRoute.cs:1031 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | dt.Rows[nRow][DefColumns.LT_SUM] | strLtSum | 그리드 속성/값 설정 |  |  |  |
| AC-c5a5fd0b | dsdm.Changed | SCP0005_DistributionRoute.cs:1032 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1669670d | dsdm.Changed | SCP0005_DistributionRoute.cs:1036 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | dt.Rows[nRow][DefColumns.LT_SUM] | strLtSum | 그리드 속성/값 설정 |  |  |  |
| AC-d56c41bd | dsdm.Changed | SCP0005_DistributionRoute.cs:1045 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_MON), "Y") | 그리드 값 설정 |  |  |  |
| AC-694b03ca | dsdm.Changed | SCP0005_DistributionRoute.cs:1046 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_TUE), "Y") | 그리드 값 설정 |  |  |  |
| AC-83652a38 | dsdm.Changed | SCP0005_DistributionRoute.cs:1047 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_WED), "Y") | 그리드 값 설정 |  |  |  |
| AC-69827f35 | dsdm.Changed | SCP0005_DistributionRoute.cs:1048 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_THU), "Y") | 그리드 값 설정 |  |  |  |
| AC-49db0d6d | dsdm.Changed | SCP0005_DistributionRoute.cs:1049 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_FRI), "Y") | 그리드 값 설정 |  |  |  |
| AC-8dfedab6 | dsdm.Changed | SCP0005_DistributionRoute.cs:1050 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_SAT), "Y") | 그리드 값 설정 |  |  |  |
| AC-ba591d0e | dsdm.Changed | SCP0005_DistributionRoute.cs:1051 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DAYS_SUN), "Y") | 그리드 값 설정 |  |  |  |
| AC-3d1f6557 | dsdm.Changed | SCP0005_DistributionRoute.cs:1055 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.A_COUNTRY), "-") | 그리드 값 설정 |  |  |  |
| AC-49b8fb26 | dsdm.Changed | SCP0005_DistributionRoute.cs:1056 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.A_PORT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-745d1e17 | dsdm.Changed | SCP0005_DistributionRoute.cs:1057 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.A_PORT_NAME), "-") | 그리드 값 설정 |  |  |  |
| AC-961c42fe | dsdm.Changed | SCP0005_DistributionRoute.cs:1058 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.D_COUNTRY), "-") | 그리드 값 설정 |  |  |  |
| AC-8dc788f4 | dsdm.Changed | SCP0005_DistributionRoute.cs:1059 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.D_PORT_CODE), "-") | 그리드 값 설정 |  |  |  |
| AC-42aa3fb8 | dsdm.Changed | SCP0005_DistributionRoute.cs:1060 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.D_PORT_NAME), "-") | 그리드 값 설정 |  |  |  |
| AC-54ae6092 | dsdm.Changed | SCP0005_DistributionRoute.cs:1061 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPPING_COMPANY), "-") | 그리드 값 설정 |  |  |  |
| AC-0e5c89c3 | dsdm.Changed | SCP0005_DistributionRoute.cs:1081 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0005_DistributionRoutePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-585a05e0 | this.Load | SCP0005_DistributionRoutePopup.cs:122 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-50ed3d23 | this.Load | SCP0005_DistributionRoutePopup.cs:123 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8073be7b | this.Load | SCP0005_DistributionRoutePopup.cs:125 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0005_DistributionRoutePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57c32e85 | this.Load | SCP0005_DistributionRoutePopup.cs:117 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0005_DistributionRoutePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eafada41 | Dispose | SCP0005_DistributionRoutePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0005_DistributionRoutePopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-328c88e3 | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:167 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c3574470 | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:171 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID") ⇒ SCP.SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 엔드포인트 요청 생성 |  |  |  |
| AC-c585230c | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:172 | lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fad5096b | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:173 | lambda | DATA_OP | request.Parameters["p_route_id"] | ROUTE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-a75a6c16 | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:174 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-432cf226 | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:175 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-23760848 | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:177 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-06f912b8 | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:181 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4ab4eef8 | this.Load 외 1 | SCP0005_DistributionRoutePopup.cs:182 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0005_DistributionRoutePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92d0f0e9 | this.Load | SCP0005_DistributionRoutePopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0005_DistributionRoutePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9761f568 | this.Load | SCP0005_DistributionRoutePopup.cs:134 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-aec40854 | this.Load | SCP0005_DistributionRoutePopup.cs:136 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-aae8c74f | this.Load | SCP0005_DistributionRoutePopup.cs:137 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-19a6bd19 | this.Load | SCP0005_DistributionRoutePopup.cs:139 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.PRIORITY), 0, 0, 99) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0e46c04b | this.Load | SCP0005_DistributionRoutePopup.cs:140 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.SHIP_DOC_PREPARATION_DATE), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c28b166a | this.Load | SCP0005_DistributionRoutePopup.cs:141 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_DEPARTURE_INLAND), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07a2c4f3 | this.Load | SCP0005_DistributionRoutePopup.cs:142 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_WAIT_SHIPPING), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b933c100 | this.Load | SCP0005_DistributionRoutePopup.cs:143 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_VOYAGE), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cf452651 | this.Load | SCP0005_DistributionRoutePopup.cs:144 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_LAY_OFF_CLEARANCE), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3907d0f9 | this.Load | SCP0005_DistributionRoutePopup.cs:145 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.LT_ARRIVAL_INLAND), 0, 0, 999) | 그리드 시트/컬럼 구성·표시 |  |  |  |

