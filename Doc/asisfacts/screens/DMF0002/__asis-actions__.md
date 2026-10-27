# AS-IS 액션 대조표 — DMF0002

> 원천: `Doc/asisfacts/screens/DMF0002/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 150행 · 메서드 23 · 종류 DATA_OP 38 · GRID_INIT 25 · ENDPOINT 16 · RETURN 15 · FLAG 10 · MESSAGE 8 · GRID_SET 8 · CALL_EXT 7 · GRID_STYLE 6 · GRID_LOCK 4 · LIST_REBIND 3 · UI_MISC 2 · GRID_BIND 2 · STATE_RESET 2 · UI_PROP 2 · VALUE_SET 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 7


## BucketConversion.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e4ea7d5 | this.clbDivision.SelectedIndexChanged | BucketConversion.cs:620 |  | FLAG | dtSalesSite | GetSalesSitebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad0a991f | this.clbDivision.SelectedIndexChanged | BucketConversion.cs:621 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## BucketConversion.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6c6b3ae | this.Load | BucketConversion.cs:149 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMainMtoW, SpdSheet.shtMainMtoW, 2, 1, 50) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-28087dbf | this.Load | BucketConversion.cs:150 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMainWtoD, SpdSheet.shtMainWtoD, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4cdd6d95 | this.Load | BucketConversion.cs:152 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMainMtoW) | 화면 필드/플래그 변경 |  |  |  |
| AC-db6fdf85 | this.Load | BucketConversion.cs:155 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainWtoD) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f489e3a | this.Load | BucketConversion.cs:157 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMainWtoD) | 화면 필드/플래그 변경 |  |  |  |

## BucketConversion.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39f94824 | DeleteButton | BucketConversion.cs:285 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## BucketConversion.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be3dce77 | Dispose | BucketConversion.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## BucketConversion.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18157f2a | EditButton | BucketConversion.cs:296 | if (this.fps != null) | GRID_LOCK | si.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7eb2e066 | EditButton | BucketConversion.cs:298 | if (this.fps != null) ▸ if (si.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb5ca929 | EditButton | BucketConversion.cs:300 | if (this.fps != null) | GRID_LOCK | si.LockColumn | (si.GetColumnIndex(DefColumns.Division), si.GetColumnIndex(DefColumns.ScmSiteId), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e859d52 | EditButton | BucketConversion.cs:310 | if (this.fps != null) ▸ if (si.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ for (iCol <= si.GetMaxColumnIndex()) ▸ if (!si.IsLock(si.She… | GRID_STYLE | si.SetBGColor | (0, iCol, si.GetMaxRowIndex(), iCol, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-7d8854b1 | EditButton | BucketConversion.cs:314 | if (this.fps != null) ▸ if (si.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ for (iCol <= si.GetMaxColumnIndex()) ▸ if (!si.IsLock(si.She… | GRID_STYLE | si.SetBGColor | (0, iCol, si.GetMaxRowIndex(), iCol, ControlColor.LockColor) | 그리드 표시 설정 |  |  |  |
| AC-3d1e3f8a | EditButton | BucketConversion.cs:319 | if (this.fps != null) ▸ if (si.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ for (iCol <= si.GetMaxColumnIndex()) ▸ else of (!si.IsLock(s… | GRID_STYLE | si.SetBGColor | (0, iCol, si.GetMaxRowIndex(), iCol, ControlColor.LockColor) | 그리드 표시 설정 |  |  |  |
| AC-171a1b54 | EditButton | BucketConversion.cs:332 | if (this.fps != null) ▸ else of (si.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ for (iCol <= si.GetMaxColumnIndex()) ▸ if (si.GetColumn… | GRID_STYLE | si.SetBGColor | (0, iCol, si.GetMaxRowIndex(), iCol, ControlColor.UnLockColor) | 그리드 표시 설정 |  |  |  |
| AC-74f10818 | EditButton | BucketConversion.cs:336 | if (this.fps != null) ▸ else of (si.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ for (iCol <= si.GetMaxColumnIndex()) ▸ if (si.GetColumn… | GRID_STYLE | si.SetBGColor | (0, iCol, si.GetMaxRowIndex(), iCol, ControlColor.LockColor) | 그리드 표시 설정 |  |  |  |

## BucketConversion.FindMtoWData

진입점: FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ finally ▸ if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa3efe4d | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:357 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainMtoW) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29cf83fe | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:364 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcef69f9 | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:368 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0002_GET_MONTH_TO_WEEK_DATA") ⇒ DM.DMF0002_GET_MONTH_TO_WEEK_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-fdd3f756 | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:369 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-c3d2269f | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:370 | lambda | DATA_OP | request.Parameters["p_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7758debf | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:371 | lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-a09d3b19 | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:372 | lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-7190e63e | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:373 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e47fc53 | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:375 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-02a49fd3 | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:379 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e16f5e3c | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:380 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-024fdc3d | FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.sh… 외 1 | BucketConversion.cs:387 |  | STATE_RESET | dtMtoWSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## BucketConversion.FindWtoDData

진입점: FindButton [else of (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ finally ▸ else of (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d48ef70 | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:394 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainWtoD) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cd43958 | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:399 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d0cce4e | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:403 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0002_GET_WEEK_TO_DAY_DATA") ⇒ DM.DMF0002_GET_WEEK_TO_DAY_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-aabcf2e6 | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:404 | lambda | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9d2dd4c1 | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:405 | lambda | DATA_OP | request.Parameters["p_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b7415a52 | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:406 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52d8ba4b | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:408 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3a3fe51e | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:412 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-efb52751 | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:413 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-15a42c3b | FindButton [else of (spdMain.ActiveSheet.SheetName == SpdShe… 외 1 | BucketConversion.cs:420 |  | STATE_RESET | dtWtoDSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## BucketConversion.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMainMtoW)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716f08cf | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | BucketConversion.cs:569 | foreach (DataRow dr in dtValidation.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sDivision == siMain.GetValue(iRow, siMain.GetColumnI… | CALL_EXT | Convert.ToUInt16 | (siMain.GetText(iRow, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94eca47f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | BucketConversion.cs:581 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## BucketConversion.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b9b8bfa | this.Load | BucketConversion.cs:119 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6e24a4e8 | this.Load | BucketConversion.cs:120 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## BucketConversion.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e29a5859 | this.Load | BucketConversion.cs:946 |  | ENDPOINT | new FoxDataRequest | ("SCM_SYS.SCM_SYS_GET_DIVISION") ⇒ SCM_SYS.SCM_SYS_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-57e378d7 | this.Load | BucketConversion.cs:948 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e0dffac6 | this.Load | BucketConversion.cs:951 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## BucketConversion.GetMonthRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06605b38 | this.Load | BucketConversion.cs:974 |  | ENDPOINT | new FoxDataRequest | ("DM.Get_Month_Range") ⇒ DM.Get_Month_Range | 엔드포인트 요청 생성 |  |  |  |
| AC-574b0c89 | this.Load | BucketConversion.cs:975 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-64c5f76a | this.Load | BucketConversion.cs:978 |  | RETURN | return sMonthRange; |  | 처리 중단/반환 |  |  |  |

## BucketConversion.GetSalesSitebyDivision

진입점: this.clbDivision.SelectedIndexChanged / this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3f4f44d | this.clbDivision.SelectedIndexChanged 외 2 | BucketConversion.cs:960 |  | ENDPOINT | new FoxDataRequest | ("SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION") ⇒ SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-75a646e2 | this.clbDivision.SelectedIndexChanged 외 2 | BucketConversion.cs:961 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-82193b9b | this.clbDivision.SelectedIndexChanged 외 2 | BucketConversion.cs:962 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-60a02114 | this.clbDivision.SelectedIndexChanged 외 2 | BucketConversion.cs:965 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## BucketConversion.GetSpdTitle

진입점: this.Load [if (siMain.SheetName == SpdSheet.shtMainMtoW)] / FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ if (siMain.SheetName == SpdSheet.shtMainMtoW)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ finally ▸ if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ if (siMain.SheetName == SpdSheet.shtMainMtoW)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d5fe2da | this.Load [if (siMain.SheetName == SpdSheet.shtMainMtoW)] 외 2 | BucketConversion.cs:987 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0002_GET_MTOW_SPREAD_TITLE") ⇒ DM.DMF0002_GET_MTOW_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-8573ac35 | this.Load [if (siMain.SheetName == SpdSheet.shtMainMtoW)] 외 2 | BucketConversion.cs:988 |  | DATA_OP | request.Parameters["p_from_month"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-a832461e | this.Load [if (siMain.SheetName == SpdSheet.shtMainMtoW)] 외 2 | BucketConversion.cs:989 |  | DATA_OP | request.Parameters["p_to_month"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-d32b94f4 | this.Load [if (siMain.SheetName == SpdSheet.shtMainMtoW)] 외 2 | BucketConversion.cs:991 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-05a496bf | this.Load [if (siMain.SheetName == SpdSheet.shtMainMtoW)] 외 2 | BucketConversion.cs:991 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## BucketConversion.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8184a8fc | this.Load | BucketConversion.cs:134 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec02238e | this.Load | BucketConversion.cs:135 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aae0f714 | this.Load | BucketConversion.cs:137 |  | FLAG | dtSalesSite | GetSalesSitebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa975a21 | this.Load | BucketConversion.cs:138 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2573841e | this.Load | BucketConversion.cs:140 |  | VALUE_SET | mrpMonth.InitValue | GetMonthRange() | 컨트롤 값 설정 |  |  |  |

## BucketConversion.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eed8d74e | this.Load | BucketConversion.cs:245 |  | FLAG | dtMtoWSave | new DataTable("MtoWSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-7d84a939 | this.Load | BucketConversion.cs:246 |  | DATA_OP | dtMtoWSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d91b6c57 | this.Load | BucketConversion.cs:247 |  | DATA_OP | dtMtoWSave.Columns.Add | (DefColumns.ScmSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc6c634d | this.Load | BucketConversion.cs:248 |  | DATA_OP | dtMtoWSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3ff83e1 | this.Load | BucketConversion.cs:249 |  | DATA_OP | dtMtoWSave.Columns.Add | (DefColumns.BucketPer, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-76a2dd4f | this.Load | BucketConversion.cs:250 |  | DATA_OP | dtMtoWSave.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c72b93ef | this.Load | BucketConversion.cs:252 |  | FLAG | dtWtoDSave | new DataTable("WtoDSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-3485a55c | this.Load | BucketConversion.cs:253 |  | DATA_OP | dtWtoDSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ad42a20 | this.Load | BucketConversion.cs:254 |  | DATA_OP | dtWtoDSave.Columns.Add | (DefColumns.ScmSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-09fc3ad6 | this.Load | BucketConversion.cs:255 |  | DATA_OP | dtWtoDSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec06594 | this.Load | BucketConversion.cs:256 |  | DATA_OP | dtWtoDSave.Columns.Add | (DefColumns.BucketPer, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d705bd4 | this.Load | BucketConversion.cs:257 |  | DATA_OP | dtWtoDSave.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## BucketConversion.InitSpread

진입점: this.Load / FindButton [if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ finally ▸ if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3bab6e9 | this.Load 외 2 | BucketConversion.cs:163 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3ae6e867 | this.Load 외 2 | BucketConversion.cs:165 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2bdca73a | this.Load 외 2 | BucketConversion.cs:166 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.Division, DefColumns.Division, FPMerge.None, 130, true, dtDivision, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12369b06 | this.Load 외 2 | BucketConversion.cs:167 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.Customer, DefColumns.Customer, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0019a40a | this.Load 외 2 | BucketConversion.cs:168 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.SalesSiteId, DefColumns.ScmSiteId, FPMerge.None, 100, true, dtSalesSite, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ab590ea | this.Load 외 2 | BucketConversion.cs:172 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(CAppSetting.StringAction), 2, 1, 30, "A", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2df06e2a | this.Load 외 2 | BucketConversion.cs:173 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Division), 2, 1, 30, DefColumnsLabel.Division, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12ff26b3 | this.Load 외 2 | BucketConversion.cs:174 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Customer), 2, 1, 30, DefColumnsLabel.Customer, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a46d970 | this.Load 외 2 | BucketConversion.cs:175 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ScmSiteId), 2, 1, 30, DefColumnsLabel.SalesSiteId, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aae233c4 | this.Load 외 2 | BucketConversion.cs:195 | if (siMain.SheetName == SpdSheet.shtMainMtoW) ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | siMain.AddNumTextColumn | (sColumnLabel, sColumnName, FPMerge.None, 40, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-730475c5 | this.Load 외 2 | BucketConversion.cs:199 | if (siMain.SheetName == SpdSheet.shtMainMtoW) ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sSpanLabelName != sSmallLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8a19948 | this.Load 외 2 | BucketConversion.cs:207 | if (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8e95d8b | this.Load 외 2 | BucketConversion.cs:211 | else of (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.AddNumTextColumn | (DefColumnsLabel.Monday, DefColumns.Monday, FPMerge.None, 40, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4cf09e6 | this.Load 외 2 | BucketConversion.cs:212 | else of (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.AddNumTextColumn | (DefColumnsLabel.Tuesday, DefColumns.Tuesday, FPMerge.None, 40, true, FPHAlign.Right, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75cdd8d6 | this.Load 외 2 | BucketConversion.cs:213 | else of (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.AddNumTextColumn | (DefColumnsLabel.Wednesday, DefColumns.Wednesday, FPMerge.None, 40, true, FPHAlign.Right, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab27cf2b | this.Load 외 2 | BucketConversion.cs:214 | else of (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.AddNumTextColumn | (DefColumnsLabel.Thursday, DefColumns.Thursday, FPMerge.None, 40, true, FPHAlign.Right, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-693d7ede | this.Load 외 2 | BucketConversion.cs:215 | else of (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.AddNumTextColumn | (DefColumnsLabel.Friday, DefColumns.Friday, FPMerge.None, 40, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c01ae52 | this.Load 외 2 | BucketConversion.cs:216 | else of (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.AddNumTextColumn | (DefColumnsLabel.Saturday, DefColumns.Saturday, FPMerge.None, 40, true, FPHAlign.Right, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e73a4be | this.Load 외 2 | BucketConversion.cs:217 | else of (siMain.SheetName == SpdSheet.shtMainMtoW) | GRID_INIT | siMain.AddNumTextColumn | (DefColumnsLabel.Sunday, DefColumns.Sunday, FPMerge.None, 40, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1c326da | this.Load 외 2 | BucketConversion.cs:229 |  | GRID_INIT | siMain.Freeze | (FPFrozen.Col, siMain.GetColumnIndex(DefColumns.ScmSiteId) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## BucketConversion.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14f8e905 | InsertButton | BucketConversion.cs:591 | if (si != null && si.IsLock(si.SheetName) == false) | DATA_OP | si.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1855a6c0 | InsertButton | BucketConversion.cs:598 | if (si != null && si.IsLock(si.SheetName) == false) ▸ if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) ▸ for (iCol <= si.GetMaxCol… | GRID_STYLE | si.SetBGColor | (0, iCol, si.GetMaxRowIndex(), iCol, ControlColor.LockColor) | 그리드 표시 설정 |  |  |  |

## BucketConversion.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7da170b | SaveButton | BucketConversion.cs:447 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMainMtoW) ▸ if (!fnValidation(dtSave)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00092") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf39a474 | SaveButton | BucketConversion.cs:448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMainMtoW) ▸ if (!fnValidation(dtSave)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9bd19b8 | SaveButton | BucketConversion.cs:459 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (siMain.SheetName == SpdSheet.shtMainMtoW) ▸ if (!fnValidation(dtS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00092") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3184f04e | SaveButton | BucketConversion.cs:460 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (siMain.SheetName == SpdSheet.shtMainMtoW) ▸ if (!fnValidation(dtS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-838d88bc | SaveButton | BucketConversion.cs:499 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0002_SAVE_BUCKET_CONVERSION_OK | 엔드포인트 요청 생성 |  |  |  |
| AC-3aa41d72 | SaveButton | BucketConversion.cs:500 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-5ccd2b54 | SaveButton | BucketConversion.cs:501 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-991f5f6a | SaveButton | BucketConversion.cs:502 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-5e568cd7 | SaveButton | BucketConversion.cs:503 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-24f4d5e7 | SaveButton | BucketConversion.cs:504 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bucket_per"] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-4735170f | SaveButton | BucketConversion.cs:505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_conversion_type"] | sConvertionType | 행/컬럼 값 대입 |  |  |  |
| AC-3369f22a | SaveButton | BucketConversion.cs:506 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3e25b00e | SaveButton | BucketConversion.cs:514 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## BucketConversion.SetSaveData

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ for (iCol < iStartCol + 7) ▸ else of (sColMonth == sMonth) ▸ if (siMain.GetText(e.Row, iCol - 1) != "" && e.Column == iCol - 1 && iTotal < 100) ▸ if (sDivision != "" && sScmSiteId != "")] / dsdm2.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (iTotal > 100) ▸ else of (sColName == DefColumns.Sunday)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f3c35a1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1001 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec246863 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1005 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f58f7e3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1006 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9cfcad6e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1007 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSiteId] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-4a7544bf | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1008 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-6f7a76b5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1009 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | iBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-a9781b24 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1010 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-01db49aa | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1012 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-8028c1bb | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1013 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9fbe902c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1017 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | iBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-a0ccef60 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | BucketConversion.cs:1018 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## BucketConversion.shtMainMtoWDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e89778f2 | dsdm.Changed | BucketConversion.cs:674 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ if (siMain.GetText… | CALL_EXT | Convert.ToInt16 | (siMain.GetText(e.Row, siMain.GetColumnIndex(sColName))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94044f7b | dsdm.Changed | BucketConversion.cs:685 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ if ((sDivision == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c649e3de | dsdm.Changed | BucketConversion.cs:686 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ if ((sDivision == … | GRID_SET | siMain.SetValue | (e.Row, e.Column, null) | 그리드 값 설정 |  |  |  |
| AC-675446b9 | dsdm.Changed | BucketConversion.cs:688 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ if ((sDivision == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52c61c1d | dsdm.Changed | BucketConversion.cs:692 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) | CALL_EXT | Convert.ToInt16 | (sColName.Substring(sColName.Length - 1, 1)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f48654c | dsdm.Changed | BucketConversion.cs:704 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ for (iCol < iStart… | CALL_EXT | Convert.ToInt16 | (siMain.GetText(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-625f7091 | dsdm.Changed | BucketConversion.cs:708 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ for (iCol < iStart… | GRID_SET | siMain.SetValue | (e.Row, e.Column, null) | 그리드 값 설정 |  |  |  |
| AC-b1d58eb6 | dsdm.Changed | BucketConversion.cs:710 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ for (iCol < iStart… | MESSAGE | MessageHelper.GMessageBox | ("MSG00091") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-379cf595 | dsdm.Changed | BucketConversion.cs:711 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ for (iCol < iStart… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc0cb1c3 | dsdm.Changed | BucketConversion.cs:720 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ for (iCol < iStart… | CALL_EXT | Convert.ToInt16 | (siMain.GetText(e.Row, iCol - 1)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-766fbcbe | dsdm.Changed | BucketConversion.cs:721 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("W_") == 0) ▸ for (iCol < iStart… | GRID_SET | siMain.SetText | (e.Row, iCol - 1, iBucketPer.ToString()) | 그리드 값 설정 |  |  |  |
| AC-36a5a947 | dsdm.Changed | BucketConversion.cs:773 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("W_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfc810cc | dsdm.Changed | BucketConversion.cs:774 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("W_") == 0) ▸ if (sColName … | GRID_SET | siMain.SetValue | (e.Row, e.Column, null) | 그리드 값 설정 |  |  |  |
| AC-8237aa5a | dsdm.Changed | BucketConversion.cs:776 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("W_") == 0) ▸ if (sColName … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## BucketConversion.shtMainWtoDDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65ccbb4b | dsdm2.Changed | BucketConversion.cs:811 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (siMain.GetText… | CALL_EXT | Convert.ToInt16 | (siMain.GetText(e.Row, siMain.GetColumnIndex(sColName))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5ca7dd0 | dsdm2.Changed | BucketConversion.cs:822 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if ((sDivision == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0023aca4 | dsdm2.Changed | BucketConversion.cs:823 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if ((sDivision == … | GRID_SET | siMain.SetValue | (e.Row, e.Column, null) | 그리드 값 설정 |  |  |  |
| AC-87d443be | dsdm2.Changed | BucketConversion.cs:825 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if ((sDivision == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02b5de05 | dsdm2.Changed | BucketConversion.cs:835 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ for (iCol < iStart… | CALL_EXT | Convert.ToInt16 | (siMain.GetText(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-105b2974 | dsdm2.Changed | BucketConversion.cs:843 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (iTotal > 100) … | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-88eac0a0 | dsdm2.Changed | BucketConversion.cs:847 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (iTotal > 100) … | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-a5452cd2 | dsdm2.Changed | BucketConversion.cs:927 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e46ee4e0 | dsdm2.Changed | BucketConversion.cs:928 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | GRID_SET | siMain.SetValue | (e.Row, e.Column, null) | 그리드 값 설정 |  |  |  |
| AC-48505bf3 | dsdm2.Changed | BucketConversion.cs:930 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## BucketConversion.spdMain_ActiveSheetChanged

진입점: spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28f0329e | spdMain.ActiveSheetChanged | BucketConversion.cs:626 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba5ed34e | spdMain.ActiveSheetChanged | BucketConversion.cs:630 | if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) | UI_PROP | lblMonth.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e30bca98 | spdMain.ActiveSheetChanged | BucketConversion.cs:634 | else of (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainMtoW) | UI_PROP | lblMonth.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## BucketConversion.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4f21ea1 | this.spdMain.ComboSelChange | BucketConversion.cs:642 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSalesSite | GetSalesSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-d15e7834 | this.spdMain.ComboSelChange | BucketConversion.cs:643 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

