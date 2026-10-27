# AS-IS 액션 대조표 — DM0030

> 원천: `Doc/asisfacts/screens/DM0030/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 48행 · 메서드 10 · 종류 FLAG 21 · GRID_INIT 8 · UI_MISC 6 · ENDPOINT 3 · RETURN 3 · DATA_OP 2 · VALUE_SET 2 · UI_PROP 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 0


## DM0030_SalesPricePopUpEx.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1276f5af | this.btnButtonList.UsrButtonList_Click_Detected | DM0030_SalesPricePopUpEx.cs:242 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-fda2973c | this.btnButtonList.UsrButtonList_Click_Detected | DM0030_SalesPricePopUpEx.cs:245 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0030_SalesPricePopUpEx.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f3dd07b | this.Load | DM0030_SalesPricePopUpEx.cs:137 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dcc2d629 | this.Load | DM0030_SalesPricePopUpEx.cs:138 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d10912af | this.Load | DM0030_SalesPricePopUpEx.cs:139 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0030_SalesPricePopUpEx.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d20764e | this.Load | DM0030_SalesPricePopUpEx.cs:132 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0030_SalesPricePopUpEx.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d141ec1 | Dispose | DM0030_SalesPricePopUpEx.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0030_SalesPricePopUpEx.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d6ea831 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:191 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-20aa481b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:195 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0002_GET_TEAM_POPUP") ⇒ SCM.SCM0002_GET_TEAM_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-63272f83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:196 | lambda | DATA_OP | request.Parameters["p_team_id"] | txtTeamId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8166715e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:197 | lambda | DATA_OP | request.Parameters["p_team_name"] | txtTeamName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-582f1289 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:198 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc08580a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:200 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b50cf4cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:204 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0ca99d6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:205 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-57ca7441 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:209 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-47404b4f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:213 | if (ds.Tables[0].Rows.Count == 1) | FLAG | departmentId | this.dtFindData.Rows[0][DefColumns.DepartmentId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4831c50 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:214 | if (ds.Tables[0].Rows.Count == 1) | FLAG | departmentName | this.dtFindData.Rows[0][DefColumns.DepartmentName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cc2f7312 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:215 | if (ds.Tables[0].Rows.Count == 1) | FLAG | teamId | this.dtFindData.Rows[0][DefColumns.TeamId].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-be5f83b0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:216 | if (ds.Tables[0].Rows.Count == 1) | FLAG | teamName | this.dtFindData.Rows[0][DefColumns.TeamName].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa5a85a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:218 | if (ds.Tables[0].Rows.Count == 1) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0030_SalesPricePopUpEx.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c24b682 | this.Load | DM0030_SalesPricePopUpEx.cs:108 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fc54d261 | this.Load | DM0030_SalesPricePopUpEx.cs:117 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-0bc6e3ab | this.Load | DM0030_SalesPricePopUpEx.cs:118 |  | FLAG | sTeamId | _teamId | 화면 필드/플래그 변경 |  |  |  |
| AC-3a717560 | this.Load | DM0030_SalesPricePopUpEx.cs:119 |  | FLAG | sTeamName | _teamName | 화면 필드/플래그 변경 |  |  |  |

## DM0030_SalesPricePopUpEx.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c547726b | this.Load | DM0030_SalesPricePopUpEx.cs:127 |  | VALUE_SET | txtTeamId.Text | sTeamId | 컨트롤 값 설정 |  |  |  |
| AC-7698a779 | this.Load | DM0030_SalesPricePopUpEx.cs:128 |  | VALUE_SET | txtTeamName.Text | sTeamName | 컨트롤 값 설정 |  |  |  |

## DM0030_SalesPricePopUpEx.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e117733a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:146 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-066ee942 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:148 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71d40172 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:149 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DepartmentId, DefColumns.DepartmentId, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0a84934 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:150 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DepartmentName, DefColumns.DepartmentName, FPMerge.None, 300, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f3e20b4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:151 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.TeamId, DefColumns.TeamId, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0cf0983 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | DM0030_SalesPricePopUpEx.cs:152 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.TeamName, DefColumns.TeamName, FPMerge.None, 300, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0030_SalesPricePopUpEx.SetTeam

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:] / this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7322063a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:260 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d107e8c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:277 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | departmentId | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.DepartmentId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-f575983e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:278 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | departmentName | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.DepartmentName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e25af631 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:279 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | teamId | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.TeamId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c21b881 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:280 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | teamName | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.TeamName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d61b57d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:286 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | departmentId | departmentId + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.DepartmentId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-6085f34a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:287 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | departmentName | departmentName + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.DepartmentNam… | 화면 필드/플래그 변경 |  |  |  |
| AC-5de8fde2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:289 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | teamId | teamId + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.TeamId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-17617ae2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:290 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | teamName | teamName + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.TeamName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-eea3c0a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:299 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ad348e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:304 | else of (bMulltiSelect) | FLAG | departmentId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DepartmentId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a27f4fc2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:305 | else of (bMulltiSelect) | FLAG | departmentName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DepartmentName)) | 화면 필드/플래그 변경 |  |  |  |
| AC-26f8f4a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:306 | else of (bMulltiSelect) | FLAG | teamId | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamId)) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef6d5b38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0030_SalesPricePopUpEx.cs:307 | else of (bMulltiSelect) | FLAG | teamName | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)) | 화면 필드/플래그 변경 |  |  |  |

## DM0030_SalesPricePopUpEx.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5273107 | this.spdMain.CellDoubleClick | DM0030_SalesPricePopUpEx.cs:253 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

