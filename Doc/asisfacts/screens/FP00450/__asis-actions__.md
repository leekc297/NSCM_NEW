# AS-IS 액션 대조표 — FP00450

> 원천: `Doc/asisfacts/screens/FP00450/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 715행 · 메서드 61 · 종류 DATA_OP 292 · FLAG 117 · RETURN 44 · GRID_SET 44 · UI_PROP 34 · GRID_LOCK 34 · ENDPOINT 26 · POPUP 18 · GRID_COMBO 15 · GRID_INIT 14 · UI_MISC 12 · CALL_EXT 12 · LIST_REBIND 10 · GRID_BIND 8 · MESSAGE 7 · THROW 7 · VALUE_SET 6 · COMBO_DATA 6 · STATE_RESET 4 · GRID_CLEAR 3 · EXCEL 1 · VALIDATE 1 · ⚠ 의미 확인 필요 12


## FP00450_MaterialSetupGroupPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29d406d2 | .ctor | FP00450_MaterialSetupGroupPopup.cs:169 |  | FLAG | this.sSite | pSite | 화면 필드/플래그 변경 |  |  |  |
| AC-998ef7f0 | .ctor | FP00450_MaterialSetupGroupPopup.cs:170 |  | FLAG | this.sNoFactory | pNoFactory | 화면 필드/플래그 변경 |  |  |  |

## FP00450_MaterialSetupGroupPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ad1b064 | this.btnButtonList.UsrButtonList_Click_Detected | FP00450_MaterialSetupGroupPopup.cs:384 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-597e0315 | this.btnButtonList.UsrButtonList_Click_Detected | FP00450_MaterialSetupGroupPopup.cs:387 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00450_MaterialSetupGroupPopup.cboCategory_selectedIndexChanged

진입점: this.cboCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e358c17d | this.cboCategory.SelectedIndexChanged | FP00450_MaterialSetupGroupPopup.cs:372 |  | DATA_OP | Filter["SETUP_CATEGORY_ID"] | CString.GetCheckedListValue(dtCategory, cboCategory.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00450_MaterialSetupGroupPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7519cad2 | this.Load | FP00450_MaterialSetupGroupPopup.cs:251 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e9ae6709 | this.Load | FP00450_MaterialSetupGroupPopup.cs:252 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-dbf422d3 | this.Load | FP00450_MaterialSetupGroupPopup.cs:253 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00450_MaterialSetupGroupPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71351cb6 | this.Load | FP00450_MaterialSetupGroupPopup.cs:246 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00450_MaterialSetupGroupPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6f4658a | Dispose | FP00450_MaterialSetupGroupPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00450_MaterialSetupGroupPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79ca32d3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:302 |  | DATA_OP | Filter["ITEM_SETUP_GROUP_ID"] | txtSetupGroup.Text | 행/컬럼 값 대입 |  |  |  |
| AC-95d505ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:313 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-72fe5146 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:314 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-53ce2752 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:317 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8869ecf6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:319 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { DataSet main = DataService.FP_ExecuteProcedure(query_procedure, Filter, ""); retu… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e0d442db | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:321 | lambda | ENDPOINT | DataService.FP_ExecuteProcedure | (query_procedure, Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f55a3ffd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:322 | lambda | RETURN | return main; |  | 처리 중단/반환 |  |  |  |
| AC-c4bf04af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:326 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9eeb6523 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:329 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex()-1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d99f286 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:334 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-7f331036 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00450_MaterialSetupGroupPopup.cs:336 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00450_MaterialSetupGroupPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00298ad0 | this.Load | FP00450_MaterialSetupGroupPopup.cs:186 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-93886ede | this.Load | FP00450_MaterialSetupGroupPopup.cs:188 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00450_MaterialSetupGroupPopup.GetCategory

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b2d7e86 | this.Load | FP00450_MaterialSetupGroupPopup.cs:235 |  | FLAG | dtCategory | DataService.FP_ExecuteQuery2( "FP00450_SetupCondition", "findCategory", Filter.Dictionary,… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findCategory] \| FP\MASTER\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-bd03a26b | this.Load | FP00450_MaterialSetupGroupPopup.cs:235 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ( "FP00450_SetupCondition", "findCategory", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findCategory] \| FP\MASTER\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4bffa3d0 | this.Load | FP00450_MaterialSetupGroupPopup.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b3475102 | this.Load | FP00450_MaterialSetupGroupPopup.cs:240 | if (cboCategory.Items.Count > 1) | VALUE_SET | cboCategory.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00450_MaterialSetupGroupPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83b8dc62 | this.Load | FP00450_MaterialSetupGroupPopup.cs:220 |  | VALUE_SET | txtDivision.Text | Filter["DIVISION_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-40429833 | this.Load | FP00450_MaterialSetupGroupPopup.cs:221 |  | VALUE_SET | txtSite.Text | Filter["SITE_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-0b5834e8 | this.Load | FP00450_MaterialSetupGroupPopup.cs:222 |  | VALUE_SET | txtPlant.Text | Filter["PLANT_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-bd83d654 | this.Load | FP00450_MaterialSetupGroupPopup.cs:223 |  | VALUE_SET | txtOperation.Text | Filter["OPERATION_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-7148423f | this.Load | FP00450_MaterialSetupGroupPopup.cs:224 |  | VALUE_SET | txtLineSetup.Text | Filter["LINE_SETUP_GROUP_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-94fb3dc8 | this.Load | FP00450_MaterialSetupGroupPopup.cs:227 |  | DATA_OP | Filter["SETUP_CATEGORY_ID"] | CString.GetCheckedListValue(dtCategory, cboCategory.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00450_MaterialSetupGroupPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55c7e519 | this.Load | FP00450_MaterialSetupGroupPopup.cs:263 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb92a2cc | this.Load | FP00450_MaterialSetupGroupPopup.cs:264 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00450_MaterialSetupGroupPopup.SetOperationInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9f01872 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:428 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3546617 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:429 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c34d975b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:431 |  | DATA_OP | Filter["SETUP_CATEGORY_ID"] | this.dtFindData.Rows[iClick_Row]["SETUP_CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f5f634f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:432 |  | DATA_OP | Filter["SETUP_KEY_ID"] | this.dtFindData.Rows[iClick_Row]["SETUP_KEY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-14942c9d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:433 |  | DATA_OP | Filter["ITEM_SETUP_GROUP_ID"] | this.dtFindData.Rows[iClick_Row]["ITEM_SETUP_GROUP_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-28f86460 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:435 |  | FLAG | _DivisionId | this.dtFindData.Rows[iClick_Row][DefColumns.DIVISION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-860d9d67 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:436 |  | FLAG | _SiteId | this.dtFindData.Rows[iClick_Row][DefColumns.SITE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-74f86127 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:437 |  | FLAG | _PlantId | this.dtFindData.Rows[iClick_Row][DefColumns.PLANT_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4d2fab77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:438 |  | FLAG | _LineSetupId | this.dtFindData.Rows[iClick_Row][DefColumns.FACTORY_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8600f62e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:439 |  | FLAG | _OperationId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6a920a3d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:440 |  | FLAG | _OperationName | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f90dec74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:441 |  | FLAG | _SetupGroupId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6703bcd5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FP00450_MaterialSetupGroupPopup.cs:444 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00450_MaterialSetupGroupPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e55617c | this.Load | FP00450_MaterialSetupGroupPopup.cs:270 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4075ee71 | this.Load | FP00450_MaterialSetupGroupPopup.cs:271 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-812394e7 | this.Load | FP00450_MaterialSetupGroupPopup.cs:275 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00450_MaterialSetupGroupPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b655bcf3 | this.spdMain.CellClick | FP00450_MaterialSetupGroupPopup.cs:398 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00450_MaterialSetupGroupPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6059b2b | this.spdMain.CellDoubleClick | FP00450_MaterialSetupGroupPopup.cs:403 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b71360cc | this.spdMain.CellDoubleClick | FP00450_MaterialSetupGroupPopup.cs:405 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b2895d2 | this.spdMain.CellDoubleClick | FP00450_MaterialSetupGroupPopup.cs:410 |  | FLAG | _SetupGroupId | this.dtFindData.Rows[e.Row]["ITEM_SETUP_GROUP_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-13ab0574 | this.spdMain.CellDoubleClick | FP00450_MaterialSetupGroupPopup.cs:411 |  | DATA_OP | Filter["SETUP_CATEGORY_ID"] | this.dtFindData.Rows[e.Row]["SETUP_CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2510f567 | this.spdMain.CellDoubleClick | FP00450_MaterialSetupGroupPopup.cs:412 |  | DATA_OP | Filter["SETUP_KEY_ID"] | this.dtFindData.Rows[e.Row]["SETUP_KEY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-040014f2 | this.spdMain.CellDoubleClick | FP00450_MaterialSetupGroupPopup.cs:413 |  | DATA_OP | Filter["ITEM_SETUP_GROUP_ID"] | this.dtFindData.Rows[e.Row]["ITEM_SETUP_GROUP_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c585166 | this.spdMain.CellDoubleClick | FP00450_MaterialSetupGroupPopup.cs:417 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00450_Setup_Condition.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76647610 | this.btnSql.Click | FP00450_Setup_Condition.cs:961 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6d0d8e57 | this.btnSql.Click | FP00450_Setup_Condition.cs:962 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c009a37 | this.btnSql.Click | FP00450_Setup_Condition.cs:964 |  | DATA_OP | popSql.Services.Add | (FindProcedure) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9861c06 | this.btnSql.Click | FP00450_Setup_Condition.cs:965 |  | DATA_OP | popSql.Services.Add | (FindProcedureDetail) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b378fab | this.btnSql.Click | FP00450_Setup_Condition.cs:966 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00450_Setup_Condition.btnUpload_Click

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb1ff50f | this.btnUpload.Click | FP00450_Setup_Condition.cs:1857 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-907740bd | this.btnUpload.Click | FP00450_Setup_Condition.cs:1858 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-eab8efa1 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1858 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c4f8266b | this.btnUpload.Click | FP00450_Setup_Condition.cs:1861 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9e50575e | this.btnUpload.Click | FP00450_Setup_Condition.cs:1862 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b655c7e5 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1863 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b36f7e8d | this.btnUpload.Click | FP00450_Setup_Condition.cs:1864 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3cad6ce1 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1865 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-da539ad7 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1866 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["LINE_SETUP_GROUP_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8c3e4866 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1867 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["SETUP_CATEGORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-32bc4a96 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1868 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["SETUP_KEY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ee6a6383 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1869 | if (fps.Name == spdMain.Name) | GRID_SET | p.KeyColumns["SETUP_CONDITION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-aab9f2ab | this.btnUpload.Click | FP00450_Setup_Condition.cs:1871 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-51bf8f98 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1872 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-eab6d3b1 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1873 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-c2531260 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1874 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-c783f1dc | this.btnUpload.Click | FP00450_Setup_Condition.cs:1875 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-b7ca9f76 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1876 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["LINE_SETUP_GROUP_ID"] | "Line Setup Group" | 행/컬럼 값 대입 |  |  |  |
| AC-fe231b6e | this.btnUpload.Click | FP00450_Setup_Condition.cs:1877 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["SETUP_CATEGORY_ID"] | "Category" | 행/컬럼 값 대입 |  |  |  |
| AC-507efad0 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1878 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["SETUP_KEY_ID"] | "Class" | 행/컬럼 값 대입 |  |  |  |
| AC-6eb2f218 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1879 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["SETUP_CONDITION_ID"] | "Condition" | 행/컬럼 값 대입 |  |  |  |
| AC-3ae66614 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1880 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["SETUP_TIME"] | "Setup Time(MIN)" | 행/컬럼 값 대입 |  |  |  |
| AC-10d76eb5 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1881 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-c1f62b31 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1883 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["OPERATION_GROUP_ID"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b42e82f6 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1884 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["SETUP_TIME_UOM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-1b34690e | this.btnUpload.Click | FP00450_Setup_Condition.cs:1885 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["DESCRIPTION"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-ed197878 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1886 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnWidth["EDIT_YN"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-638bf334 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1888 | if (fps.Name == spdMain.Name) | DATA_OP | p.ColumnBgColor["SETUP_TIME"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-ab4f23c6 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1890 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoSearchData | ExcelImport_Main_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-eda5c62b | this.btnUpload.Click | FP00450_Setup_Condition.cs:1891 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoLineCheck | ExcelImport_Main_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-4beb56d3 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1892 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoSaveData | ExcelImport_Main_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-29b104f8 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1893 | if (fps.Name == spdMain.Name) | UI_PROP | p.DoValidationData | ExcelImport_Main_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-165c9389 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1894 | if (fps.Name == spdMain.Name) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e23cbf96 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1902 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | UI_PROP | p.ColumnHeaderCount | 2 | 속성 ColumnHeaderCount 설정 |  |  |  |
| AC-ebe752b8 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1903 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fd3d92e2 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1904 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-967c2860 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1905 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-deaabc2d | this.btnUpload.Click | FP00450_Setup_Condition.cs:1906 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e85818b1 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1907 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4dc11510 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1908 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["LINE_SETUP_GROUP_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a21d391e | this.btnUpload.Click | FP00450_Setup_Condition.cs:1909 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["SETUP_CATEGORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ed27da5a | this.btnUpload.Click | FP00450_Setup_Condition.cs:1910 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["SETUP_KEY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8d0eaaf8 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1911 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["FROM_ITEM_SETUP_GROUP_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0bc2bcf3 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1912 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["TO_ITEM_SETUP_GROUP_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b098d17b | this.btnUpload.Click | FP00450_Setup_Condition.cs:1913 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | p.KeyColumns["SETUP_CONDITION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c86f8424 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1915 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-6f97076b | this.btnUpload.Click | FP00450_Setup_Condition.cs:1916 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-94dc4ed0 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1917 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-8ac84984 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1918 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-f6ed9be1 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1919 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["OPERATION_ID"] | new Tuple<string, string>("Operation", "Line Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-ab596e98 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1920 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["LINE_SETUP_GROUP_ID"] | new Tuple<string, string>("Setup Group", "Line Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-13eee570 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1921 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["SETUP_CATEGORY_ID"] | new Tuple<string, string>("Category", "Material Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-ca1b75a9 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1922 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["SETUP_KEY_ID"] | new Tuple<string, string>("Class", "Material Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-e6739706 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1923 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["FROM_ITEM_SETUP_GROUP_ID"] | new Tuple<string, string>("From Setup Group", "Material Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-81436372 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1924 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["FROM_ITEM_SETUP_GROUP_NAME"] | new Tuple<string, string>("From Setup Group Nick Name", "Material Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-4b68a095 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1925 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["TO_ITEM_SETUP_GROUP_ID"] | new Tuple<string, string>("To Setup Group", "Material Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-7b6a9a6b | this.btnUpload.Click | FP00450_Setup_Condition.cs:1926 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["TO_ITEM_SETUP_GROUP_NAME"] | new Tuple<string, string>("To Setup Group Nick Name", "Material Setup Group") | 행/컬럼 값 대입 |  |  |  |
| AC-8f9682d9 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1927 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["SETUP_CONDITION_ID"] | "Setup Condition" | 행/컬럼 값 대입 |  |  |  |
| AC-a2c8fc90 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1928 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["SETUP_TIME"] | "Setup Time" | 행/컬럼 값 대입 |  |  |  |
| AC-a1e223e4 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1929 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["ADJUST_CELL_QTY"] | "Adjust Cell QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-ccb27fc5 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1930 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-0045c74e | this.btnUpload.Click | FP00450_Setup_Condition.cs:1932 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["COMPANY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-f654b809 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1933 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["DIVISION_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-9d4973ba | this.btnUpload.Click | FP00450_Setup_Condition.cs:1934 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["SITE_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-1b34d9ba | this.btnUpload.Click | FP00450_Setup_Condition.cs:1935 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["PLANT_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-d7db2792 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1936 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["OPERATION_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-0ff94bd0 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1937 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["LINE_SETUP_GROUP_ID"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-efe5495b | this.btnUpload.Click | FP00450_Setup_Condition.cs:1938 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["SETUP_CATEGORY_ID"] | 110 | 행/컬럼 값 대입 |  |  |  |
| AC-1967f46c | this.btnUpload.Click | FP00450_Setup_Condition.cs:1939 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["SETUP_KEY_ID"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-f953aed0 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1940 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["FROM_ITEM_SETUP_GROUP_ID"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-f6837a6d | this.btnUpload.Click | FP00450_Setup_Condition.cs:1941 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["FROM_ITEM_SETUP_GROUP_NAME"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-00cc4e84 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1942 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["TO_ITEM_SETUP_GROUP_ID"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-2a9640cf | this.btnUpload.Click | FP00450_Setup_Condition.cs:1943 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["TO_ITEM_SETUP_GROUP_NAME"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-e76d99ce | this.btnUpload.Click | FP00450_Setup_Condition.cs:1944 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["SETUP_CONDITION_ID"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-ce9e96f8 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1945 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["SETUP_TIME"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-5dea9f02 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1946 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["ADJUST_CELL_QTY"] | 80 | 행/컬럼 값 대입 |  |  |  |
| AC-8df2130e | this.btnUpload.Click | FP00450_Setup_Condition.cs:1947 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | p.ColumnWidth["MESSAGE"] | 250 | 행/컬럼 값 대입 |  |  |  |
| AC-063bf4ee | this.btnUpload.Click | FP00450_Setup_Condition.cs:1952 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | UI_PROP | p.DoSearchData | ExcelImport_Matrix_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-a2a12c6c | this.btnUpload.Click | FP00450_Setup_Condition.cs:1953 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | UI_PROP | p.DoLineCheck | ExcelImport_Matrix_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-65ea6869 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1954 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | UI_PROP | p.DoSaveData | ExcelImport_Matrix_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-2431128c | this.btnUpload.Click | FP00450_Setup_Condition.cs:1955 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | UI_PROP | p.DoValidationData | ExcelImport_Matrix_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-2f6f9d60 | this.btnUpload.Click | FP00450_Setup_Condition.cs:1956 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00450_Setup_Condition.cboKey_SelectedIndexChanged

진입점: this.Load / cboKey.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-720df9c8 | this.Load 외 1 | FP00450_Setup_Condition.cs:1847 |  | DATA_OP | Filter["SETUP_KEY_ID"] | CString.GetCheckedListValue(dtKey, cboKey.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00450_Setup_Condition.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a54b8550 | this.Load | FP00450_Setup_Condition.cs:324 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-17655ee2 | this.Load | FP00450_Setup_Condition.cs:325 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-a77cccf1 | this.Load | FP00450_Setup_Condition.cs:328 |  | GRID_INIT | this.AddSheet | (spdTotal, SpdSheet.shtTotal, SpdSheet.shtTotal, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-534cd35c | this.Load | FP00450_Setup_Condition.cs:329 |  | FLAG | siSub | GetSheetInfo(spdTotal.Name, SpdSheet.shtTotal) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1ede201 | this.Load | FP00450_Setup_Condition.cs:332 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00450_Setup_Condition.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8814c90c | this.Load | FP00450_Setup_Condition.cs:207 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f24d64b9 | this.Load | FP00450_Setup_Condition.cs:209 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-52df55ab | this.Load | FP00450_Setup_Condition.cs:210 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-da857bba | this.Load | FP00450_Setup_Condition.cs:211 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00450_Setup_Condition.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22fa18f3 | DeleteButton | FP00450_Setup_Condition.cs:552 | if (fps.Name == spdMain.Name) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39e79382 | DeleteButton | FP00450_Setup_Condition.cs:556 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00450_Setup_Condition.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f03e08d3 | Dispose | FP00450_Setup_Condition.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00450_Setup_Condition.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e58baf22 | EditButton | FP00450_Setup_Condition.cs:565 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-80ad8781 | EditButton | FP00450_Setup_Condition.cs:567 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1fd02c72 | EditButton | FP00450_Setup_Condition.cs:577 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex() - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b44263d | EditButton | FP00450_Setup_Condition.cs:583 | if (spdTotal != null) | FLAG | siSub | GetSheetInfo(spdTotal.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a0f7124 | EditButton | FP00450_Setup_Condition.cs:585 | if (spdTotal != null) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-18967ac7 | EditButton | FP00450_Setup_Condition.cs:595 | if (spdTotal != null) ▸ if (isEdit) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex() - 3, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-084a827f | EditButton | FP00450_Setup_Condition.cs:596 | if (spdTotal != null) ▸ if (isEdit) | GRID_LOCK | siSub.LockColumn | (siSub.GetMaxColumnIndex() - 2, siSub.GetMaxColumnIndex() - 2, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-018c2f6a | EditButton | FP00450_Setup_Condition.cs:597 | if (spdTotal != null) ▸ if (isEdit) | GRID_LOCK | siSub.LockColumn | (siSub.GetMaxColumnIndex() - 1, siSub.GetMaxColumnIndex() - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00450_Setup_Condition.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a49a7fe | ExcelButton | FP00450_Setup_Condition.cs:1146 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Main_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d048e035 | (진입점 미연결) | FP00450_Setup_Condition.cs:2017 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Main_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19de57e7 | (진입점 미연결) | FP00450_Setup_Condition.cs:1980 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-205defb1 | (진입점 미연결) | FP00450_Setup_Condition.cs:1980 |  | DATA_OP | data.Tables[0].Columns.Contains | ("SHOP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5429aaab | (진입점 미연결) | FP00450_Setup_Condition.cs:1981 | if (data.Good() && !data.Tables[0].Columns.Contains("SHOP_GROUP_ID")) | DATA_OP | data.Tables[0].Columns.Add | (new DataColumn("SHOP_GROUP_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f99bd3f0 | (진입점 미연결) | FP00450_Setup_Condition.cs:1982 |  | MESSAGE | MessageBox.Show | ("The Setup Time is changed and the Setup Matrix's Setup Time is also changed. Do you like… | 메시지 표시 |  |  |  |
| AC-db7d75fc | (진입점 미연결) | FP00450_Setup_Condition.cs:1985 | if (dlg_res != DialogResult.OK) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a349fda6 | (진입점 미연결) | FP00450_Setup_Condition.cs:1986 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00450_SetupCondition", "merge_FP00450", data, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00450] \| FP\Master\FP00… | 엔드포인트 호출 |  |  |  |
| AC-abdc04c8 | (진입점 미연결) | FP00450_Setup_Condition.cs:1991 | if (res.DataSet != null) | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2d62598e | (진입점 미연결) | FP00450_Setup_Condition.cs:1993 |  | UI_PROP | res.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-8577d6c8 | (진입점 미연결) | FP00450_Setup_Condition.cs:1994 |  | DATA_OP | r.Tables.Add | (res) | 데이터 객체 조작/조회 |  |  |  |
| AC-c79ce198 | (진입점 미연결) | FP00450_Setup_Condition.cs:1995 |  | RETURN | return r; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Main_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e2d2c4c | (진입점 미연결) | FP00450_Setup_Condition.cs:1970 | if (set.Good()) | CALL_EXT | set.Tables[0].SetColumnsOrder | ("COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID" , "OPERATION_ID", "LINE_SETUP_GROUP_ID… | ⚠ 의미 확인 필요 |  |  |  |
| AC-07eec9bf | (진입점 미연결) | FP00450_Setup_Condition.cs:1975 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Main_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01569a78 | (진입점 미연결) | FP00450_Setup_Condition.cs:2001 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bd34a6a | (진입점 미연결) | FP00450_Setup_Condition.cs:2002 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00450_SetupCondition", "delete_Excel_buffer", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-4d0bc3e9 | (진입점 미연결) | FP00450_Setup_Condition.cs:2006 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00450_SetupCondition", "insert_Excel_buffer", data,0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\MASTE… | 엔드포인트 호출 |  |  |  |
| AC-ab24be9d | (진입점 미연결) | FP00450_Setup_Condition.cs:2010 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00450_SetupCondition", "find_Excel_buffer_validation", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-10b8b948 | (진입점 미연결) | FP00450_Setup_Condition.cs:2010 |  | RETURN | return DataService.FP_ExecuteQuery( "FP00450_SetupCondition", "find_Excel_buffer… |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Matrix_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0381397 | (진입점 미연결) | FP00450_Setup_Condition.cs:2101 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Matrix_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fbac2b6 | (진입점 미연결) | FP00450_Setup_Condition.cs:2075 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00450_SetupCondition", "merge_FP00450_cal", data, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00450_cal] \| FP\Master\… | 엔드포인트 호출 |  |  |  |
| AC-c44ad26a | (진입점 미연결) | FP00450_Setup_Condition.cs:2079 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Matrix_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7846d3fc | (진입점 미연결) | FP00450_Setup_Condition.cs:2024 | if (LastRowForExcel == -1) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8677e7e4 | (진입점 미연결) | FP00450_Setup_Condition.cs:2027 | try | DATA_OP | siMain.GetBindingRow | (LastRowForExcel) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-980a0840 | (진입점 미연결) | FP00450_Setup_Condition.cs:2030 | try ▸ if (row != null) | FLAG | sDivision | row["DIVISION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-edd904df | (진입점 미연결) | FP00450_Setup_Condition.cs:2031 | try ▸ if (row != null) | FLAG | sSite | row["SITE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a378f95c | (진입점 미연결) | FP00450_Setup_Condition.cs:2032 | try ▸ if (row != null) | FLAG | sCompany | row["COMPANY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f56bd12 | (진입점 미연결) | FP00450_Setup_Condition.cs:2033 | try ▸ if (row != null) | FLAG | sPlant | row["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-267684b5 | (진입점 미연결) | FP00450_Setup_Condition.cs:2034 | try ▸ if (row != null) | FLAG | sOperation | row["OPERATION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a0a7e98 | (진입점 미연결) | FP00450_Setup_Condition.cs:2035 | try ▸ if (row != null) | FLAG | sCategory | row["SETUP_CATEGORY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4e598630 | (진입점 미연결) | FP00450_Setup_Condition.cs:2036 | try ▸ if (row != null) | FLAG | sSetup | row["SETUP_KEY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bcfe281c | (진입점 미연결) | FP00450_Setup_Condition.cs:2037 | try ▸ if (row != null) | FLAG | sLineSetup | row["LINE_SETUP_GROUP_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d6d7e2ac | (진입점 미연결) | FP00450_Setup_Condition.cs:2041 | try ▸ else of (row != null) | FLAG | sDivision | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f83e23ae | (진입점 미연결) | FP00450_Setup_Condition.cs:2045 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["COMPANY_ID"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-16971e95 | (진입점 미연결) | FP00450_Setup_Condition.cs:2046 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-452f49b9 | (진입점 미연결) | FP00450_Setup_Condition.cs:2047 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-243e6dc4 | (진입점 미연결) | FP00450_Setup_Condition.cs:2048 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["PLANT_ID"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-466ed946 | (진입점 미연결) | FP00450_Setup_Condition.cs:2049 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["OPERATION_ID"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-808a08bb | (진입점 미연결) | FP00450_Setup_Condition.cs:2050 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SETUP_CATEGORY_ID"] | sCategory | 행/컬럼 값 대입 |  |  |  |
| AC-308948a8 | (진입점 미연결) | FP00450_Setup_Condition.cs:2051 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SETUP_KEY_ID"] | sSetup | 행/컬럼 값 대입 |  |  |  |
| AC-93859cdf | (진입점 미연결) | FP00450_Setup_Condition.cs:2052 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["LINE_SETUP_GROUP_ID"] | sLineSetup | 행/컬럼 값 대입 |  |  |  |
| AC-1bc11af7 | (진입점 미연결) | FP00450_Setup_Condition.cs:2057 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) ▸ if (dsDetail.Good()) | CALL_EXT | dsDetail.Tables[0].SetColumnsOrder | ("COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID" , "OPERATION_ID", "LINE_SETUP_GROUP_ID… | ⚠ 의미 확인 필요 |  |  |  |
| AC-09142259 | (진입점 미연결) | FP00450_Setup_Condition.cs:2063 | try ▸ if (!string.IsNullOrWhiteSpace(sDivision)) | RETURN | return dsDetail; |  | 처리 중단/반환 |  |  |  |
| AC-5add063d | (진입점 미연결) | FP00450_Setup_Condition.cs:2068 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-aa2a3c35 | (진입점 미연결) | FP00450_Setup_Condition.cs:2070 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.ExcelImport_Matrix_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60a7e0b0 | (진입점 미연결) | FP00450_Setup_Condition.cs:2085 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a7001f6 | (진입점 미연결) | FP00450_Setup_Condition.cs:2086 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00450_SetupCondition", "delete_Excel_buffer_sub", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] \| … | 엔드포인트 호출 |  |  |  |
| AC-33956ec1 | (진입점 미연결) | FP00450_Setup_Condition.cs:2090 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00450_SetupCondition", "insert_Excel_buffer_sub", data, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer_sub] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-372e3cc9 | (진입점 미연결) | FP00450_Setup_Condition.cs:2094 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00450_SetupCondition", "find_Excel_buffer_validation_sub", column_params, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_su… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7b6f7455 | (진입점 미연결) | FP00450_Setup_Condition.cs:2094 |  | RETURN | return DataService.FP_ExecuteQuery( "FP00450_SetupCondition", "find_Excel_buffer… |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.FilterValidation

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ea74d8e | FindButton | FP00450_Setup_Condition.cs:318 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.FindData

진입점: popSql.OnSql [if (programID == FindProcedure)] / this.btnUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.DialogResult == DialogResult.OK)] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48388afe | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00450_Setup_Condition.cs:1289 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e52bf60 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00450_Setup_Condition.cs:1292 | try | ENDPOINT | DataService.FP_ExecuteProcedure | (FindProcedure, set, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-742ff18d | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00450_Setup_Condition.cs:1294 | try | RETURN | return main; |  | 처리 중단/반환 |  |  |  |
| AC-36eafb29 | popSql.OnSql [if (programID == FindProcedure)] 외 4 | FP00450_Setup_Condition.cs:1298 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00450_Setup_Condition.FindDataDetail

진입점: popSql.OnSql [else of (programID == FindProcedure) ▸ if (programID == FindProcedureDetail)] / this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (p.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrWhiteSpace(sDivision))] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!string.IsNullOrWhiteSpace(sDivision))] / FindButton [try ▸ try] / SaveButton [else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (!string.IsNullOrWhiteSpace(sDivision))] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d347fa3 | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 5 | FP00450_Setup_Condition.cs:1336 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-de8707ba | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 5 | FP00450_Setup_Condition.cs:1338 | try | ENDPOINT | DataService.FP_ExecuteProcedure | (FindProcedureDetail, set, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-15a5b24a | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 5 | FP00450_Setup_Condition.cs:1341 | try | RETURN | return dtDetail; |  | 처리 중단/반환 |  |  |  |
| AC-4671b92a | popSql.OnSql [else of (programID == FindProcedure) ▸ if (pro… 외 5 | FP00450_Setup_Condition.cs:1345 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00450_Setup_Condition.FindOptionData

진입점: popSql.OnSql [if (programID == FindProcedure) ▸ try] / this.btnUpload.Click [if (fps.Name == spdMain.Name) ▸ if (p.DialogResult == DialogResult.OK) ▸ try] / FindButton [try ▸ lambda ▸ try] / SaveButton [if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b740b92 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1306 |  | FLAG | dtLinesetupGroup | DataService.FP_ExecuteQuery2("FP00450_SetupCondition", "findLineSetupGroup", Filter.Dictio… | 화면 필드/플래그 변경 |  |  |  |
| AC-81acbaba | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1307 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00450_SetupCondition", "findLineSetupGroup", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineSetupGroup] \| FP\MASTE… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5ecb2cb0 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1309 |  | FLAG | dtCondtionCategory | DataService.FP_ExecuteQuery2("FP00450_SetupCondition", "find_condition_category", Filter.D… | 화면 필드/플래그 변경 |  |  |  |
| AC-90f546af | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1310 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00450_SetupCondition", "find_condition_category", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_category] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fbaf1e5c | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1312 |  | FLAG | dtConditionKey | DataService.FP_ExecuteQuery2("FP00450_SetupCondition", "find_condition_key", Filter.Dictio… | 화면 필드/플래그 변경 |  |  |  |
| AC-a3091e4a | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1313 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00450_SetupCondition", "find_condition_key", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_key] \| FP\MASTE… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a3dbf22e | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1317 |  | FLAG | dtSetupCondition | DataService.FP_ExecuteQuery2("FP00450_SetupCondition", "findMatrix_setupconditon", Filter.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0d9d20bb | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1318 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00450_SetupCondition", "findMatrix_setupconditon", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_setupconditon] \| FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-19ff6115 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1321 |  | FLAG | dtItemSetup | DataService.FP_ExecuteQuery2("FP00450_SetupCondition", "findMatrix_itemsetup", Filter.Dict… | 화면 필드/플래그 변경 |  |  |  |
| AC-393c6e41 | popSql.OnSql [if (programID == FindProcedure) ▸ try] 외 4 | FP00450_Setup_Condition.cs:1322 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00450_SetupCondition", "findMatrix_itemsetup", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_itemsetup] \| FP\MAS… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00450_Setup_Condition.FindSubData

진입점: this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (p.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0799190d | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1663 | if (rowIndex < 0) | FLAG | LastRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-8a91dcab | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1664 | if (rowIndex < 0) | FLAG | dsDetail | null | 화면 필드/플래그 변경 |  |  |  |
| AC-533de0a9 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1665 | if (rowIndex < 0) | GRID_CLEAR | siSub.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-f6efa422 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1666 | if (rowIndex < 0) | GRID_BIND | siSub.Query | ((DataSet)null) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-88f3e064 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1667 | if (rowIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17e6d784 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1676 |  | DATA_OP | siMain.GetBindingRow | (rowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-08d6dbb9 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1679 | if (row != null) | FLAG | sDivision | row["DIVISION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d0eebc73 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1680 | if (row != null) | FLAG | sSite | row["SITE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-44f90fbe | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1681 | if (row != null) | FLAG | sCompany | row["COMPANY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d2e48458 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1682 | if (row != null) | FLAG | sPlant | row["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-62ce0de5 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1683 | if (row != null) | FLAG | sOperation | row["OPERATION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fabee558 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1684 | if (row != null) | FLAG | sCategory | row["SETUP_CATEGORY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c5ab32b9 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1685 | if (row != null) | FLAG | sSetup | row["SETUP_KEY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a5b091f8 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1686 | if (row != null) | FLAG | sLineSetup | row["LINE_SETUP_GROUP_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4aa5a90 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1690 | else of (row != null) | FLAG | sDivision | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e895144b | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1694 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["COMPANY_ID"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-7077f5d1 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1695 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7369945a | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1696 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-1fef0095 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1697 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["PLANT_ID"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-ae1a5395 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1698 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["OPERATION_ID"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-6071dd1f | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1699 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SETUP_CATEGORY_ID"] | sCategory | 행/컬럼 값 대입 |  |  |  |
| AC-feec395a | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1700 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SETUP_KEY_ID"] | sSetup | 행/컬럼 값 대입 |  |  |  |
| AC-2c6d2f71 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1701 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["LINE_SETUP_GROUP_ID"] | sLineSetup | 행/컬럼 값 대입 |  |  |  |
| AC-d4f129c5 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1703 | if (!string.IsNullOrWhiteSpace(sDivision)) | FLAG | dsDetail | FindDataDetail(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b3d0b76a | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1704 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dsDetail.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43a28307 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1705 | if (!string.IsNullOrWhiteSpace(sDivision)) | GRID_BIND | siSub.Query | (dsDetail, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-63e3d669 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1708 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65948400 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1709 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4c826a7 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1710 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dtResult.Columns.Add | ("LINE_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-408c3d7e | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1714 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-74e95202 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1715 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef52d961 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1716 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-69a322c4 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1717 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-79b4351b | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1718 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dRow.Field | ("LINE_SETUP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-72cf49df | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1719 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dRow.Field | ("SETUP_CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-815f36e7 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1720 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | dRow.Field | ("SETUP_KEY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6d6a321 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1724 | if (!string.IsNullOrWhiteSpace(sDivision)) ▸ foreach (var b in distinctRows) | DATA_OP | dtResult.Rows.Add | (b.col1.ToString(), b.col2.ToString(), b.col3.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-81993aa4 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1730 | if (!string.IsNullOrWhiteSpace(sDivision)) | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |
| AC-328eba95 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1731 | if (!string.IsNullOrWhiteSpace(sDivision)) | LIST_REBIND | siSub.LoadCombo | (cb, dtResult, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8f549088 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1733 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["COMPANY_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-21b6dbc0 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1734 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["DIVISION_ID"] | old_divsion | 행/컬럼 값 대입 |  |  |  |
| AC-1783b136 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1735 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SITE_ID"] | old_site | 행/컬럼 값 대입 |  |  |  |
| AC-676f4368 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1736 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["PLANT_ID"] | old_plant | 행/컬럼 값 대입 |  |  |  |
| AC-1093344e | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1737 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["OPERATION_ID"] | old_operation | 행/컬럼 값 대입 |  |  |  |
| AC-df749bce | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1738 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SETUP_CATEGORY_ID"] | old_category | 행/컬럼 값 대입 |  |  |  |
| AC-cd4fcff4 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1739 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["SETUP_KEY_ID"] | old_key | 행/컬럼 값 대입 |  |  |  |
| AC-269701b9 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1740 | if (!string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["LINE_SETUP_GROUP_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93bd8c43 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1744 | else of (!string.IsNullOrWhiteSpace(sDivision)) | FLAG | dsDetail | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9efee3f5 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1745 | else of (!string.IsNullOrWhiteSpace(sDivision)) | GRID_CLEAR | siSub.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-6a41893b | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1746 | else of (!string.IsNullOrWhiteSpace(sDivision)) | GRID_BIND | siSub.Query | ((DataSet)null) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-52078494 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1753 | if (this.IsEditMode == true) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex() - 3, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a4841a43 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1754 | if (this.IsEditMode == true) | GRID_LOCK | siSub.LockColumn | (siSub.GetMaxColumnIndex() - 2, siSub.GetMaxColumnIndex() - 2, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f197977 | this.btnUpload.Click [else of (fps.Name == spdMain.Name) ▸ i… 외 2 | FP00450_Setup_Condition.cs:1755 | if (this.IsEditMode == true) | GRID_LOCK | siSub.LockColumn | (siSub.GetMaxColumnIndex() - 1, siSub.GetMaxColumnIndex() - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00450_Setup_Condition.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff56047 | this.Load | FP00450_Setup_Condition.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00450_Setup_Condition.formTestButton_Click

진입점: this.formTestButton.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0c3af71 | this.formTestButton.Click | FP00450_Setup_Condition.cs:2107 |  | POPUP | demo.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00450_Setup_Condition.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3b0c9f6 | this.Load | FP00450_Setup_Condition.cs:245 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1924f6bc | this.Load | FP00450_Setup_Condition.cs:246 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-670913f9 | this.Load | FP00450_Setup_Condition.cs:246 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-847fdb72 | this.Load | FP00450_Setup_Condition.cs:249 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-e0a60a35 | this.Load | FP00450_Setup_Condition.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00450_Setup_Condition.GetFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82350aab | (진입점 미연결) | FP00450_Setup_Condition.cs:2118 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.GetKey

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b216864 | (진입점 미연결) | FP00450_Setup_Condition.cs:257 |  | FLAG | dtKey | DataService.FP_ExecuteProcedure2("PR_UI_FP00450_FINDFILTERKEY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d87c1d51 | (진입점 미연결) | FP00450_Setup_Condition.cs:257 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP00450_FINDFILTERKEY", Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-98b653bb | (진입점 미연결) | FP00450_Setup_Condition.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtKey, cboKey, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00450_Setup_Condition.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd8958e3 | this.Load | FP00450_Setup_Condition.cs:184 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb9111c5 | this.Load | FP00450_Setup_Condition.cs:186 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c0fb4d32 | this.Load | FP00450_Setup_Condition.cs:187 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-62da5292 | this.Load | FP00450_Setup_Condition.cs:193 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-91c34c2d | this.Load | FP00450_Setup_Condition.cs:196 |  | DATA_OP | Filter["USER_ID"] | CurrentUser = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b96838a1 | this.Load | FP00450_Setup_Condition.cs:196 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00450_Setup_Condition.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd0d12c8 | this.Load | FP00450_Setup_Condition.cs:357 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d66fc7e5 | this.Load | FP00450_Setup_Condition.cs:358 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00450_Setup_Condition.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8c62759 | this.Load 외 1 | FP00450_Setup_Condition.cs:341 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ff79e791 | this.Load 외 1 | FP00450_Setup_Condition.cs:343 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-767bd881 | this.Load 외 1 | FP00450_Setup_Condition.cs:349 | if (spreadInfo.SheetName == SpdSheet.shtTotal) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-218dcdc0 | this.Load 외 1 | FP00450_Setup_Condition.cs:351 | if (spreadInfo.SheetName == SpdSheet.shtTotal) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |

## FP00450_Setup_Condition.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb657fbf | InsertButton | FP00450_Setup_Condition.cs:398 | if (fps.Name == spdMain.Name) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e1748c3e | InsertButton | FP00450_Setup_Condition.cs:400 | if (fps.Name == spdMain.Name) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex("OPERATION_ID")].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-afebc057 | InsertButton | FP00450_Setup_Condition.cs:401 | if (fps.Name == spdMain.Name) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex("LINE_SETUP_GROUP_ID"), dtLinesetupGroup) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b50840e8 | InsertButton | FP00450_Setup_Condition.cs:402 | if (fps.Name == spdMain.Name) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex("SETUP_CATEGORY_ID"), dtCondtionCategory) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f560e87c | InsertButton | FP00450_Setup_Condition.cs:403 | if (fps.Name == spdMain.Name) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex("SETUP_KEY_ID"), dtConditionKey) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a9b41610 | InsertButton | FP00450_Setup_Condition.cs:406 | if (fps.Name == spdMain.Name) | DATA_OP | defaultData.Add | ("SETUP_TIME", "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1fdbd56 | InsertButton | FP00450_Setup_Condition.cs:407 | if (fps.Name == spdMain.Name) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-863c69f1 | InsertButton | FP00450_Setup_Condition.cs:411 | if (fps.Name == spdMain.Name) | GRID_LOCK | siMain.LockRange2 | (insCell.Row.Index, 1, insCell.Row.Index, siMain.GetColumnIndex("OPERATION_ID") - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-fac9ef3e | InsertButton | FP00450_Setup_Condition.cs:412 | if (fps.Name == spdMain.Name) | GRID_LOCK | siMain.LockRange2 | (insCell.Row.Index, siMain.GetColumnIndex("OPERATION_ID"), insCell.Row.Index, siMain.GetMa… | 그리드 편집 잠금 전환 |  |  |  |
| AC-b92a7ed5 | InsertButton | FP00450_Setup_Condition.cs:416 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f608203 | InsertButton | FP00450_Setup_Condition.cs:418 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex("OPERATION_ID")].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-7bfd8013 | InsertButton | FP00450_Setup_Condition.cs:419 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex("FROM_ITEM_SETUP_GROUP_ID")].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c5233e1f | InsertButton | FP00450_Setup_Condition.cs:420 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex("TO_ITEM_SETUP_GROUP_ID")].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-fec5fa16 | InsertButton | FP00450_Setup_Condition.cs:421 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_COMBO | siSub.SetCellTypeCombo | (iRow, siSub.GetColumnIndex("LINE_SETUP_GROUP_ID"), dtLinesetupGroup) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c890afcd | InsertButton | FP00450_Setup_Condition.cs:422 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_COMBO | siSub.SetCellTypeCombo | (iRow, siSub.GetColumnIndex("SETUP_CONDITION_ID"), dtSetupCondition) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-65fe7197 | InsertButton | FP00450_Setup_Condition.cs:434 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | dsDetail.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-20deaace | InsertButton | FP00450_Setup_Condition.cs:435 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | UI_PROP | insCell.Row.Tag | newRow | 속성 Tag 설정 |  |  |  |
| AC-122a92f6 | InsertButton | FP00450_Setup_Condition.cs:437 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("DIVISION_ID", row["DIVISION_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-21aa0bd7 | InsertButton | FP00450_Setup_Condition.cs:438 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("SITE_ID", row["SITE_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6e2f763 | InsertButton | FP00450_Setup_Condition.cs:439 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("PLANT_ID", row["PLANT_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-07938a85 | InsertButton | FP00450_Setup_Condition.cs:440 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("OPERATION_ID", row["OPERATION_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c51b530b | InsertButton | FP00450_Setup_Condition.cs:441 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("LINE_SETUP_GROUP_ID", row["LINE_SETUP_GROUP_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0274382 | InsertButton | FP00450_Setup_Condition.cs:442 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("SETUP_CATEGORY_ID", row["SETUP_CATEGORY_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-dabacf67 | InsertButton | FP00450_Setup_Condition.cs:443 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("SETUP_KEY_ID", row["SETUP_KEY_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d337473e | InsertButton | FP00450_Setup_Condition.cs:444 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("SETUP_CONDITION_ID", row["SETUP_CONDITION_ID"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5c41b6a | InsertButton | FP00450_Setup_Condition.cs:445 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("FROM_ITEM_SETUP_GROUP_NAME", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc9868a6 | InsertButton | FP00450_Setup_Condition.cs:446 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("TO_ITEM_SETUP_GROUP_NAME", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-633785f6 | InsertButton | FP00450_Setup_Condition.cs:447 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("SETUP_TIME", row["SETUP_TIME"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2093c6df | InsertButton | FP00450_Setup_Condition.cs:448 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | defaultData.Add | ("ADJUST_CELL_QTY", 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0ccc968 | InsertButton | FP00450_Setup_Condition.cs:450 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["DIVISION_ID"] | sDivision = row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-825eaf65 | InsertButton | FP00450_Setup_Condition.cs:450 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sDivision | row["DIVISION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1081207a | InsertButton | FP00450_Setup_Condition.cs:451 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["SITE_ID"] | sSite = row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-93e6072c | InsertButton | FP00450_Setup_Condition.cs:451 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sSite | row["SITE_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-424a95d2 | InsertButton | FP00450_Setup_Condition.cs:452 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["COMPANY_ID"] | sCompany = row["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-44ea4ea3 | InsertButton | FP00450_Setup_Condition.cs:452 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sCompany | row["COMPANY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9dc3e093 | InsertButton | FP00450_Setup_Condition.cs:453 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["PLANT_ID"] | sPlant = row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0fddb07e | InsertButton | FP00450_Setup_Condition.cs:453 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sPlant | row["PLANT_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0e0347cb | InsertButton | FP00450_Setup_Condition.cs:454 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["OPERATION_ID"] | sOperation = row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ffce326c | InsertButton | FP00450_Setup_Condition.cs:454 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sOperation | row["OPERATION_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1b97b24a | InsertButton | FP00450_Setup_Condition.cs:455 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["SETUP_CATEGORY_ID"] | sCategory = row["SETUP_CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-506a0c25 | InsertButton | FP00450_Setup_Condition.cs:455 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sCategory | row["SETUP_CATEGORY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-47bda27f | InsertButton | FP00450_Setup_Condition.cs:456 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["SETUP_KEY_ID"] | sSetup = row["SETUP_KEY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-219c5c5f | InsertButton | FP00450_Setup_Condition.cs:456 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sSetup | row["SETUP_KEY_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3e68057e | InsertButton | FP00450_Setup_Condition.cs:457 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | DATA_OP | newRow["LINE_SETUP_GROUP_ID"] | sLineSetup = row["LINE_SETUP_GROUP_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-553c1fde | InsertButton | FP00450_Setup_Condition.cs:457 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ try ▸ if (row != null) | FLAG | sLineSetup | row["LINE_SETUP_GROUP_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-bb7f3ecd | InsertButton | FP00450_Setup_Condition.cs:461 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-e06b5bc4 | InsertButton | FP00450_Setup_Condition.cs:465 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, 1, insCell.Row.Index, siSub.GetColumnIndex("OPERATION_ID") - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-16d0a92c | InsertButton | FP00450_Setup_Condition.cs:466 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("OPERATION_ID"), insCell.Row.Index, siSub.GetColu… | 그리드 편집 잠금 전환 |  |  |  |
| AC-60cf047b | InsertButton | FP00450_Setup_Condition.cs:467 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("SETUP_CATEGORY_ID"), insCell.Row.Index, siSub.Ge… | 그리드 편집 잠금 전환 |  |  |  |
| AC-af52cba7 | InsertButton | FP00450_Setup_Condition.cs:468 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("FROM_ITEM_SETUP_GROUP_ID"), insCell.Row.Index, s… | 그리드 편집 잠금 전환 |  |  |  |
| AC-6941dc24 | InsertButton | FP00450_Setup_Condition.cs:469 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("FROM_ITEM_SETUP_GROUP_NAME"), insCell.Row.Index,… | 그리드 편집 잠금 전환 |  |  |  |
| AC-ed203955 | InsertButton | FP00450_Setup_Condition.cs:470 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("TO_ITEM_SETUP_GROUP_ID"), insCell.Row.Index, siS… | 그리드 편집 잠금 전환 |  |  |  |
| AC-fd9f7145 | InsertButton | FP00450_Setup_Condition.cs:471 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("TO_ITEM_SETUP_GROUP_NAME"), insCell.Row.Index, s… | 그리드 편집 잠금 전환 |  |  |  |
| AC-a1764d5f | InsertButton | FP00450_Setup_Condition.cs:472 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("SETUP_CONDITION_ID"), insCell.Row.Index, siSub.G… | 그리드 편집 잠금 전환 |  |  |  |
| AC-99c73805 | InsertButton | FP00450_Setup_Condition.cs:473 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("SETUP_TIME"), insCell.Row.Index, siSub.GetColumn… | 그리드 편집 잠금 전환 |  |  |  |
| AC-65d332d9 | InsertButton | FP00450_Setup_Condition.cs:474 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_LOCK | siSub.LockRange2 | (insCell.Row.Index, siSub.GetColumnIndex("ADJUST_CELL_QTY"), insCell.Row.Index, siSub.GetC… | 그리드 편집 잠금 전환 |  |  |  |
| AC-d94893a1 | InsertButton | FP00450_Setup_Condition.cs:477 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b020eea | InsertButton | FP00450_Setup_Condition.cs:478 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3de3d26 | InsertButton | FP00450_Setup_Condition.cs:483 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc7792d4 | InsertButton | FP00450_Setup_Condition.cs:484 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b26a0043 | InsertButton | FP00450_Setup_Condition.cs:485 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c836b70 | InsertButton | FP00450_Setup_Condition.cs:486 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2335193 | InsertButton | FP00450_Setup_Condition.cs:491 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-de7e1342 | InsertButton | FP00450_Setup_Condition.cs:494 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_COMBO | siSub.SetCellTypeCombo | (iRow, siSub.GetColumnIndex("LINE_SETUP_GROUP_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6326093d | InsertButton | FP00450_Setup_Condition.cs:527 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | STATE_RESET | dtResult.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8ab8ad14 | InsertButton | FP00450_Setup_Condition.cs:530 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-da156c66 | InsertButton | FP00450_Setup_Condition.cs:531 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5213892f | InsertButton | FP00450_Setup_Condition.cs:532 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-57455df5 | InsertButton | FP00450_Setup_Condition.cs:533 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a1dddfa | InsertButton | FP00450_Setup_Condition.cs:534 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("LINE_SETUP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cb9218f | InsertButton | FP00450_Setup_Condition.cs:535 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("SETUP_CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e181df6 | InsertButton | FP00450_Setup_Condition.cs:536 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | DATA_OP | dRow.Field | ("SETUP_KEY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-39929cd3 | InsertButton | FP00450_Setup_Condition.cs:542 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3b7c515 | InsertButton | FP00450_Setup_Condition.cs:544 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | GRID_COMBO | siSub.SetCellTypeCombo | (iRow, siSub.GetColumnIndex("SETUP_CONDITION_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP00450_Setup_Condition.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6989257 | (진입점 미연결) | FP00450_Setup_Condition.cs:1153 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00450_Setup_Condition.InvaidMessageMainRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b9d697b | (진입점 미연결) | FP00450_Setup_Condition.cs:701 |  | MESSAGE | MessageBox.Show | (colname + " data not provided") | 메시지 표시 |  |  |  |
| AC-ef1b22bf | (진입점 미연결) | FP00450_Setup_Condition.cs:702 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f022ade4 | popSql.OnSql | FP00450_Setup_Condition.cs:1270 | if (programID == FindProcedure) | RETURN | return FindData(false); |  | 처리 중단/반환 |  |  |  |
| AC-20cb5f9f | popSql.OnSql | FP00450_Setup_Condition.cs:1274 | else of (programID == FindProcedure) ▸ if (programID == FindProcedureDetail) | RETURN | return FindDataDetail(false); |  | 처리 중단/반환 |  |  |  |
| AC-af37d16e | popSql.OnSql | FP00450_Setup_Condition.cs:1276 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a142991 | SaveButton | FP00450_Setup_Condition.cs:714 | if (fps.Name == spdMain.Name) | CALL_EXT | siMain.GetChangeDataSet | (ValidateMainRow, InvaidMessageMainRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1027ab81 | SaveButton | FP00450_Setup_Condition.cs:715 | if (fps.Name == spdMain.Name) | CALL_EXT | siMain.GetDeletedDataSet | (ValidateMainRow, InvaidMessageMainRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ab6c7ff | SaveButton | FP00450_Setup_Condition.cs:718 | if (fps.Name == spdMain.Name) ▸ if (!changed.Good() && !removed.Good()) | MESSAGE | MessageBox.Show | ("There is no changed") | 메시지 표시 |  |  |  |
| AC-d58b3f89 | SaveButton | FP00450_Setup_Condition.cs:719 | if (fps.Name == spdMain.Name) ▸ if (!changed.Good() && !removed.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3567a03 | SaveButton | FP00450_Setup_Condition.cs:721 | if (fps.Name == spdMain.Name) | CALL_EXT | siMain.GetChangeRowCount | ("SETUP_TIME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fed75f1e | SaveButton | FP00450_Setup_Condition.cs:724 | if (fps.Name == spdMain.Name) ▸ if (setup_count_changed_count > 0) | MESSAGE | MessageBox.Show | ("The Setup Time is changed and the Setup Matrix's Setup Time is also changed. Do you proc… | 메시지 표시 |  |  |  |
| AC-1146e456 | SaveButton | FP00450_Setup_Condition.cs:730 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | DATA_OP | changed.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-25c5e0b3 | SaveButton | FP00450_Setup_Condition.cs:732 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ if (!changed.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | changed.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d80b94d8 | SaveButton | FP00450_Setup_Condition.cs:734 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | DATA_OP | removed.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b739c807 | SaveButton | FP00450_Setup_Condition.cs:736 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ if (!removed.Tables[0].Columns.Contains("USER_ID")) | DATA_OP | removed.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-baa800d5 | SaveButton | FP00450_Setup_Condition.cs:742 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in changed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | CALL_EXT | ro.RejectChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-062df097 | SaveButton | FP00450_Setup_Condition.cs:743 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in changed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5a254cca | SaveButton | FP00450_Setup_Condition.cs:744 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in changed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | DATA_OP | ro.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f5ff691 | SaveButton | FP00450_Setup_Condition.cs:745 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in changed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | DATA_OP | ro.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8314da53 | SaveButton | FP00450_Setup_Condition.cs:748 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in changed.Tables[0].Rows) ▸ else of (ro.RowState == D… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9835601c | SaveButton | FP00450_Setup_Condition.cs:754 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in removed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | CALL_EXT | ro.RejectChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d00f0938 | SaveButton | FP00450_Setup_Condition.cs:755 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in removed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1f300702 | SaveButton | FP00450_Setup_Condition.cs:756 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in removed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | DATA_OP | ro.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e4a038e2 | SaveButton | FP00450_Setup_Condition.cs:757 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in removed.Tables[0].Rows) ▸ if (ro.RowState == DataRo… | DATA_OP | ro.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-31603870 | SaveButton | FP00450_Setup_Condition.cs:760 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ foreach (DataRow ro in removed.Tables[0].Rows) ▸ else of (ro.RowState == D… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-174d5fd0 | SaveButton | FP00450_Setup_Condition.cs:764 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ if (changed.Good()) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00450_SetupCondition", "saveAll_FP00450", changed, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00450] \| FP\Master\FP… | 엔드포인트 호출 |  |  |  |
| AC-9dced192 | SaveButton | FP00450_Setup_Condition.cs:768 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) ▸ if (removed.Good()) | ENDPOINT | DataService.FP_PseudoBatch | ("FP00450_SetupCondition", "deleteAll_FP00450", removed, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=deleteAll_FP00450] \| FP\Master\… | 엔드포인트 호출 |  |  |  |
| AC-04071028 | SaveButton | FP00450_Setup_Condition.cs:770 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | FLAG | dsMain | FindData(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-172944e4 | SaveButton | FP00450_Setup_Condition.cs:776 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c127df5e | SaveButton | FP00450_Setup_Condition.cs:777 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2ee56699 | SaveButton | FP00450_Setup_Condition.cs:779 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d199c104 | SaveButton | FP00450_Setup_Condition.cs:780 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | FLAG | dsDetail | null | 화면 필드/플래그 변경 |  |  |  |
| AC-01db5b51 | SaveButton | FP00450_Setup_Condition.cs:781 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | GRID_CLEAR | siSub.ActiveSheet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-ed86ad2a | SaveButton | FP00450_Setup_Condition.cs:782 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | GRID_BIND | siSub.Query | ((DataSet)null) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d4adcf1a | SaveButton | FP00450_Setup_Condition.cs:783 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9043a419 | SaveButton | FP00450_Setup_Condition.cs:784 | if (fps.Name == spdMain.Name) ▸ if (dlg_res == DialogResult.OK) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-24064752 | SaveButton | FP00450_Setup_Condition.cs:848 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ foreach (DataRow ro in dsDetail.Tables[0].Rows) ▸ if (val == null) | DATA_OP | ro["ADJUST_CELL_QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-9652e00a | SaveButton | FP00450_Setup_Condition.cs:853 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ foreach (DataRow ro in dsDetail.Tables[0].Rows) ▸ else of (val == null… | DATA_OP | ro["ADJUST_CELL_QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-a9b057f0 | SaveButton | FP00450_Setup_Condition.cs:857 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | CALL_EXT | siSub.GetChangeDataSet | (ValidateMainRow, InvaidMessageMainRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c7653b3 | SaveButton | FP00450_Setup_Condition.cs:858 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) | CALL_EXT | siSub.GetDeletedDataSet | (ValidateMainRow, InvaidMessageMainRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b03a0104 | SaveButton | FP00450_Setup_Condition.cs:861 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) | DATA_OP | changed.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d598a487 | SaveButton | FP00450_Setup_Condition.cs:863 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (changed.Good() && !chang… | DATA_OP | changed.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cfa7487 | SaveButton | FP00450_Setup_Condition.cs:868 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (changed.Good() && !chang… | CALL_EXT | ro.RejectChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-76d489b7 | SaveButton | FP00450_Setup_Condition.cs:869 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (changed.Good() && !chang… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5729afd4 | SaveButton | FP00450_Setup_Condition.cs:870 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (changed.Good() && !chang… | DATA_OP | ro.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-60071296 | SaveButton | FP00450_Setup_Condition.cs:871 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (changed.Good() && !chang… | DATA_OP | ro.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-12cebde5 | SaveButton | FP00450_Setup_Condition.cs:874 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (changed.Good() && !chang… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e631d75e | SaveButton | FP00450_Setup_Condition.cs:876 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (changed.Good() && !chang… | ENDPOINT | DataService.FP_UpdateBatch | ("FP00450_SetupCondition", "saveAll_FP00450_cal", changed, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00450_cal] \| FP\Maste… | 엔드포인트 호출 |  |  |  |
| AC-d319a852 | SaveButton | FP00450_Setup_Condition.cs:878 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) | DATA_OP | removed.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-45693d2c | SaveButton | FP00450_Setup_Condition.cs:880 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (removed.Good() && !remov… | DATA_OP | removed.Tables[0].Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5547615 | SaveButton | FP00450_Setup_Condition.cs:885 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (removed.Good() && !remov… | CALL_EXT | ro.RejectChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5e08fd5 | SaveButton | FP00450_Setup_Condition.cs:886 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (removed.Good() && !remov… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-838695f9 | SaveButton | FP00450_Setup_Condition.cs:887 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (removed.Good() && !remov… | DATA_OP | ro.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d772d7b | SaveButton | FP00450_Setup_Condition.cs:888 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (removed.Good() && !remov… | DATA_OP | ro.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c275bad | SaveButton | FP00450_Setup_Condition.cs:891 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (removed.Good() && !remov… | DATA_OP | ro["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-68c1cf08 | SaveButton | FP00450_Setup_Condition.cs:893 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) ▸ if (removed.Good() && !remov… | ENDPOINT | DataService.FP_UpdateBatch | ("FP00450_SetupCondition", "deleteAll_FP00450_cal", removed, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=deleteAll_FP00450_cal] \| FP\Mas… | 엔드포인트 호출 |  |  |  |
| AC-e18507d1 | SaveButton | FP00450_Setup_Condition.cs:901 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c5d3ea85 | SaveButton | FP00450_Setup_Condition.cs:902 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) | DATA_OP | dsDetail.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90a42ec8 | SaveButton | FP00450_Setup_Condition.cs:905 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8058020b | SaveButton | FP00450_Setup_Condition.cs:906 | else of (fps.Name == spdMain.Name) ▸ if (fps.Name == spdTotal.Name) ▸ if (changed.Good() \|\| removed.Good()) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## FP00450_Setup_Condition.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-162bf05e | SaveButton | FP00450_Setup_Condition.cs:605 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / cboOperation.SelectedIndexChanged / cboCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d024e28 | this.Load 외 5 | FP00450_Setup_Condition.cs:270 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-208b1db2 | this.Load 외 5 | FP00450_Setup_Condition.cs:270 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-68feec46 | this.Load 외 5 | FP00450_Setup_Condition.cs:276 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2732d615 | this.Load 외 5 | FP00450_Setup_Condition.cs:276 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fc4b5b17 | this.Load 외 5 | FP00450_Setup_Condition.cs:277 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6e8cf1fe | this.Load 외 5 | FP00450_Setup_Condition.cs:283 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues,true) | 행/컬럼 값 대입 |  |  |  |
| AC-7ceabe7f | this.Load 외 5 | FP00450_Setup_Condition.cs:284 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed334d81 | this.Load 외 5 | FP00450_Setup_Condition.cs:284 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-b8247bd3 | this.Load 외 5 | FP00450_Setup_Condition.cs:285 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ae07e641 | this.Load 외 5 | FP00450_Setup_Condition.cs:291 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-66b9f82f | this.Load 외 5 | FP00450_Setup_Condition.cs:292 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bf746695 | this.Load 외 5 | FP00450_Setup_Condition.cs:292 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c8b5d933 | this.Load 외 5 | FP00450_Setup_Condition.cs:293 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-29d3b805 | this.Load 외 5 | FP00450_Setup_Condition.cs:299 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues,true) | 행/컬럼 값 대입 |  |  |  |
| AC-0197f404 | this.Load 외 5 | FP00450_Setup_Condition.cs:300 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtCategory | DataService.FP_ExecuteQuery2("FP00450_SetupCondition", "findSetupCategory", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] \| FP\MASTER… | 화면 필드/플래그 변경 |  |  |  |
| AC-08a5938c | this.Load 외 5 | FP00450_Setup_Condition.cs:300 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00450_SetupCondition", "findSetupCategory", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] \| FP\MASTER… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2779fd17 | this.Load 외 5 | FP00450_Setup_Condition.cs:301 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1c2feae4 | this.Load 외 5 | FP00450_Setup_Condition.cs:306 | switch (triggerControl) case DefColumns.CATEGORY_ID: | DATA_OP | Filter["SETUP_CATEGORY_ID"] | CString.GetCheckedListValue(dtOperation, cboCategory.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-47f04cd0 | this.Load 외 5 | FP00450_Setup_Condition.cs:308 | switch (triggerControl) case DefColumns.CATEGORY_ID: | FLAG | dtKey | DataService.FP_ExecuteProcedure2("PR_UI_FP00450_FINDFILTERKEY", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8be57d19 | this.Load 외 5 | FP00450_Setup_Condition.cs:308 | switch (triggerControl) case DefColumns.CATEGORY_ID: | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_FP00450_FINDFILTERKEY", Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a72f2383 | this.Load 외 5 | FP00450_Setup_Condition.cs:309 | switch (triggerControl) case DefColumns.CATEGORY_ID: | LIST_REBIND | clsCtrl.setListBox | (dtKey, cboKey, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00450_Setup_Condition.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55b21d37 | this.Load | FP00450_Setup_Condition.cs:148 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-365b6fb8 | this.Load | FP00450_Setup_Condition.cs:150 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c38a0f74 | this.Load | FP00450_Setup_Condition.cs:151 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lclForm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4eef3514 | this.Load | FP00450_Setup_Condition.cs:155 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7932ae60 | this.Load | FP00450_Setup_Condition.cs:156 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lclForm.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00450_Setup_Condition.SetFilter

진입점: this.Load [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboOperation.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboCategory.SelectedIndexChanged [switch (triggerContr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc85b9be | this.Load [switch (triggerControl) case DefColumns.DIVISION_… 외 5 | FP00450_Setup_Condition.cs:2113 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00450_Setup_Condition.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae1edfb5 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1361 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa917a67 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1363 | if (this.IsEditMode == true) ▸ try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a3020a8 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1373 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | POPUP | new FPC0024_WorkCenterOperationPopup | ("WORKCENTER_OPERATION_FACTORY_NONE", "", "") | 팝업/폼 생성 |  |  |  |
| AC-f3e56b42 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1374 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7fa99fee | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1375 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e3146b57 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1377 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sPlant | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f4bb2cf9 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1378 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sDivision | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-a517ee7b | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1379 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sSite | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c4199a2f | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1380 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sOperation | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-82b73334 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1381 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sOperationGroup | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-92a1c86b | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1385 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sCompany | popOperation._CompanyId | 화면 필드/플래그 변경 |  |  |  |
| AC-a805689b | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1386 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sPlant | popOperation._PlantId | 화면 필드/플래그 변경 |  |  |  |
| AC-0b90789f | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1387 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sDivision | popOperation._DivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-4ca3a693 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1388 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sSite | popOperation._SiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-28edaa17 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1389 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sOperation | popOperation._OperationId | 화면 필드/플래그 변경 |  |  |  |
| AC-a9ce417b | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1390 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | FLAG | sOperationGroup | popOperation._OperationGroupId | 화면 필드/플래그 변경 |  |  |  |
| AC-7de5a618 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1392 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex("DIVISION_ID"), sDivision) | 그리드 값 설정 |  |  |  |
| AC-42b87be5 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1393 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex("PLANT_ID"), sPlant) | 그리드 값 설정 |  |  |  |
| AC-280868b6 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1394 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex("SITE_ID"), sSite) | 그리드 값 설정 |  |  |  |
| AC-ed4ab4a2 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1395 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex("OPERATION_ID"), sOperation) | 그리드 값 설정 |  |  |  |
| AC-6b955a5e | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1398 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dsMain.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5b68e0b | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1399 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | row["COMPANY_ID"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-18b3bd65 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1400 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | row["OPERATION_GROUP_ID"] | sOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-80296b14 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1401 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | row["SETUP_TIME_UOM"] | "MINUTE" | 행/컬럼 값 대입 |  |  |  |
| AC-e886f1f7 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1402 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_SET | siMain.ActiveSheet.Rows[e.Row].Tag | row | 그리드 속성/값 설정 |  |  |  |
| AC-0f33a2f1 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1405 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fced4ca | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1406 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-64a62f63 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1411 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2fd238f | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1412 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-038ced41 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1413 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1aecee82 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1414 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1ff3ac8 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1419 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-22e77618 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1422 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("LINE_SETUP_GROUP_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-95f21905 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1426 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ca54703 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1427 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce5d2657 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1428 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-63e96c36 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1429 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-87da6be3 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1433 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("SETUP_CATEGORY_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-745cde11 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1434 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | STATE_RESET | dtResult.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cced3c15 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1437 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa1969db | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1438 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-33aa8e68 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1439 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-882a9cf0 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1440 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-89363e7e | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1446 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1051cf7b | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1448 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnInd… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("SETUP_KEY_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-eb684cb8 | this.spdMain.CellClick | FP00450_Setup_Condition.cs:1455 | if (this.IsEditMode == true) ▸ catch ((Exception editException)) | THROW | throw editException; |  | 예외 발생 |  |  |  |

## FP00450_Setup_Condition.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fe263b9 | this.spdMain.CellDoubleClick | FP00450_Setup_Condition.cs:1766 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | LastRowForExcel | LastRow = e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-eb40b40f | this.spdMain.CellDoubleClick | FP00450_Setup_Condition.cs:1766 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | LastRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-740d7320 | this.spdMain.CellDoubleClick | FP00450_Setup_Condition.cs:1770 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.IsLock(SpdSheet.shtMain) == false) | GRID_LOCK | siSub.SwitchLock | (false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-538f984c | this.spdMain.CellDoubleClick | FP00450_Setup_Condition.cs:1771 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.IsLock(SpdSheet.shtMain) == false) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex() - 3, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-23eb276a | this.spdMain.CellDoubleClick | FP00450_Setup_Condition.cs:1772 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.IsLock(SpdSheet.shtMain) == false) | GRID_LOCK | siSub.LockColumn | (siSub.GetMaxColumnIndex() - 2, siSub.GetMaxColumnIndex() - 2, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f93e70f3 | this.spdMain.CellDoubleClick | FP00450_Setup_Condition.cs:1773 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.IsLock(SpdSheet.shtMain) == false) | GRID_LOCK | siSub.LockColumn | (siSub.GetMaxColumnIndex() - 1, siSub.GetMaxColumnIndex() - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00450_Setup_Condition.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f843ea7 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1168 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex("DIVISION_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-64ecf74c | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1169 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | FLAG | sSite | siMain.GetValue(e.Row, siMain.GetColumnIndex("SITE_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e38db5b3 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1170 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | FLAG | sPlant | siMain.GetValue(e.Row, siMain.GetColumnIndex("PLANT_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-22fd38db | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1171 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | FLAG | sOperation | siMain.GetValue(e.Row, siMain.GetColumnIndex("OPERATION_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a4bd4f4 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1175 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0aac80cb | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1176 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1283022 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1177 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dtResult.Columns.Add | ("LINE_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d955725 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1181 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbe59b38 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1182 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2abdb40 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1183 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-54c6652e | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1184 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5164cf1 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1185 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("LINE_SETUP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f4162a3 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1189 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-015b8c5e | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1191 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("SETUP_CATEGORY_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-baab1ae0 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1192 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | STATE_RESET | dtResult.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-83f07e0f | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1195 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-71fc7416 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1196 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-82d81165 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1197 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-783ec1e3 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1198 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8173cdf8 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1199 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | DATA_OP | dRow.Field | ("LINE_SETUP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5682569 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1204 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-f351d093 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1206 | if (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("SETUP_KEY_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4762f614 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1212 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | FLAG | sDivision | siMain.GetValue(e.Row, siMain.GetColumnIndex("DIVISION_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c59b4838 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1213 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | FLAG | sSite | siMain.GetValue(e.Row, siMain.GetColumnIndex("SITE_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c3cfa62 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1214 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | FLAG | sPlant | siMain.GetValue(e.Row, siMain.GetColumnIndex("PLANT_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-30c4b1c5 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1215 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | FLAG | sOperation | siMain.GetValue(e.Row, siMain.GetColumnIndex("OPERATION_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3b529a45 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1220 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5986519d | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1221 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b72046fd | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1222 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dtResult.Columns.Add | ("LINE_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08f13716 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1223 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dtResult.Columns.Add | ("SETUP_CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c9de826 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1228 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb104415 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1229 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a35c8a8c | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1230 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-64b5d057 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1231 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-14217ed1 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1232 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dRow.Field | ("LINE_SETUP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-29dcb48f | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1233 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dRow.Field | ("SETUP_CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-509cbe4d | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1238 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-8597fc68 | this.spdMain.ComboSelChange | FP00450_Setup_Condition.cs:1240 | else of (e.Column == siMain.GetColumnIndex("LINE_SETUP_GROUP_ID") && action == CAppSetting.FlagI) ▸ if (e.Column == siMain.GetColumnIndex("S… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("SETUP_KEY_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP00450_Setup_Condition.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce470327 | this.spdMain.KeyDown | FP00450_Setup_Condition.cs:1784 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-e5702e8e | this.spdMain.KeyDown | FP00450_Setup_Condition.cs:1815 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00450_Setup_Condition.spdTotal_CellClick

진입점: this.spdTotal.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e817581 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1467 | if (this.IsEditMode == true) ▸ try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0e5fc46 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1469 | if (this.IsEditMode == true) ▸ try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ceacd02b | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1479 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | POPUP | new FPC0024_WorkCenterOperationPopup | ("WORKCENTER_OPERATION_FACTORY_NONE", "", "") | 팝업/폼 생성 |  |  |  |
| AC-a68b3ada | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1480 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a9b99eb7 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1481 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5f1227ff | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1485 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sPlant | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5c4f807f | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1486 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sDivision | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1bbf5630 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1487 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sSite | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-416791f6 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1488 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sOperation | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f1d2e594 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1489 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sOperationGroup | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6e4b5134 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1493 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sCompany | popOperation._CompanyId | 화면 필드/플래그 변경 |  |  |  |
| AC-9c1715e7 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1494 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sPlant | popOperation._PlantId | 화면 필드/플래그 변경 |  |  |  |
| AC-e85f14c8 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1495 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sDivision | popOperation._DivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-533167f2 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1496 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sSite | popOperation._SiteId | 화면 필드/플래그 변경 |  |  |  |
| AC-0d8e1ef2 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1497 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sOperation | popOperation._OperationId | 화면 필드/플래그 변경 |  |  |  |
| AC-0e22605b | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1498 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | FLAG | sOperationGroup | popOperation._OperationGroupId | 화면 필드/플래그 변경 |  |  |  |
| AC-7e16a0ff | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1500 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("DIVISION_ID"), sDivision) | 그리드 값 설정 |  |  |  |
| AC-f6cfdc1c | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1501 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("PLANT_ID"), sPlant) | 그리드 값 설정 |  |  |  |
| AC-8f64510a | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1502 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("SITE_ID"), sSite) | 그리드 값 설정 |  |  |  |
| AC-38ed7dbd | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1503 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("OPERATION_ID"), sOperation) | 그리드 값 설정 |  |  |  |
| AC-55a9994f | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1506 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dsDetail.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5bd4134d | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1507 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | row["COMPANY_ID"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-2c65175f | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1508 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | row["OPERATION_GROUP_ID"] | sOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-37745c30 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1509 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | row["SETUP_TIME_UOM"] | "MINUTE" | 행/컬럼 값 대입 |  |  |  |
| AC-f4bea292 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1510 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | GRID_SET | siSub.ActiveSheet.Rows[e.Row].Tag | row | 그리드 속성/값 설정 |  |  |  |
| AC-523ea99f | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1513 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f415cdf | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1514 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99ccbda5 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1519 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e73e2d8 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1520 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2fdcbcf3 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1521 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7dfb627a | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1522 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae9f8a42 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1527 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b2af6b9 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1530 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex("LINE_SETUP_GROUP_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2ea8b7ff | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1563 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | STATE_RESET | dtResult.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-566a9c3a | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1566 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5a58cbe | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1567 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ec02fa59 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1568 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e19177fe | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1569 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f98920a | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1570 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("LINE_SETUP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2263a109 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1571 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("SETUP_CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a2f4f1d | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1572 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dRow.Field | ("SETUP_KEY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-db109ba7 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1578 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b65fc8e2 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1580 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex… | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex("SETUP_CONDITION_ID"), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-939f7dc7 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1587 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | POPUP | new FP00450_MaterialSetupGroupPopup | ("", "", "") | 팝업/폼 생성 |  |  |  |
| AC-274664f7 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1588 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | UI_PROP | pop.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-8ce620f9 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1588 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7cec940 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1590 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["COMPANY_ID"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-5a9900dd | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1591 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["DIVISION_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("DIVISION_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-12955bdb | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1592 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["SITE_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("SITE_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-8923c515 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1593 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["PLANT_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("PLANT_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-646eef5a | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1594 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["OPERATION_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("OPERATION_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-28221e66 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1595 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["LINE_SETUP_GROUP_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("LINE_SETUP_GROUP_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-cafa7495 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1596 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["SETUP_CATEGORY_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("SETUP_CATEGORY_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-9a861a4c | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1598 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-deb5b6c2 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1599 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-48076d32 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1609 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("SETUP_CATEGORY_ID"), ITEM_SETUP_CATEGORY_ID) | 그리드 값 설정 |  |  |  |
| AC-428e5379 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1610 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("SETUP_KEY_ID"), CLASS_ID) | 그리드 값 설정 |  |  |  |
| AC-ba048f20 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1611 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("TO_ITEM_SETUP_GROUP_ID"), "") | 그리드 값 설정 |  |  |  |
| AC-96960804 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1613 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("FROM_ITEM_SETUP_GROUP_ID"), ITEM_SETUP_GROUP_ID) | 그리드 값 설정 |  |  |  |
| AC-c74f5444 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1618 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | POPUP | new FP00450_MaterialSetupGroupPopup | ("", "", "") | 팝업/폼 생성 |  |  |  |
| AC-37645cfc | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1619 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | UI_PROP | pop.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-b2bb9fbe | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1619 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ee228348 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1621 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["COMPANY_ID"] | sCompany | 행/컬럼 값 대입 |  |  |  |
| AC-face07ff | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1622 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["DIVISION_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("DIVISION_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-870f563a | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1623 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["SITE_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("SITE_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-17f808c4 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1624 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["PLANT_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("PLANT_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-bb4632fd | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1625 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["OPERATION_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("OPERATION_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-b5f09337 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1626 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["LINE_SETUP_GROUP_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("LINE_SETUP_GROUP_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-0fc39c57 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1627 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | DATA_OP | pop.Filter["SETUP_CATEGORY_ID"] | siSub.GetText(e.Row, siSub.GetColumnIndex("SETUP_CATEGORY_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-d7d083eb | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1629 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4066f1d6 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1630 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fc2aa9f5 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1640 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("SETUP_CATEGORY_ID"), ITEM_SETUP_CATEGORY_ID) | 그리드 값 설정 |  |  |  |
| AC-1dad0976 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1641 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("SETUP_KEY_ID"), CLASS_ID) | 그리드 값 설정 |  |  |  |
| AC-ac73341a | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1642 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("FROM_ITEM_SETUP_GROUP_ID"), "") | 그리드 값 설정 |  |  |  |
| AC-ffaecc4b | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1644 | if (this.IsEditMode == true) ▸ try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siSub.GetColumn… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("TO_ITEM_SETUP_GROUP_ID"), ITEM_SETUP_GROUP_ID) | 그리드 값 설정 |  |  |  |
| AC-00391e80 | this.spdTotal.CellClick | FP00450_Setup_Condition.cs:1655 | if (this.IsEditMode == true) ▸ catch ((Exception editException)) | THROW | throw editException; |  | 예외 발생 |  |  |  |

## FP00450_Setup_Condition.UIFindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f1817ee | FindButton | FP00450_Setup_Condition.cs:985 | if (FilterValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d41e5db3 | FindButton | FP00450_Setup_Condition.cs:988 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0c10632f | FindButton | FP00450_Setup_Condition.cs:994 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72693dde | FindButton | FP00450_Setup_Condition.cs:995 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5a6682d | FindButton | FP00450_Setup_Condition.cs:998 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c953d870 | FindButton | FP00450_Setup_Condition.cs:1000 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6c42cf55 | FindButton | FP00450_Setup_Condition.cs:1002 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fd3de9d6 | FindButton | FP00450_Setup_Condition.cs:1013 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-df9648ea | FindButton | FP00450_Setup_Condition.cs:1015 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-58a6843a | FindButton | FP00450_Setup_Condition.cs:1015 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-29135a17 | FindButton | FP00450_Setup_Condition.cs:1029 | try | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e63dea1 | FindButton | FP00450_Setup_Condition.cs:1030 | try | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b36c8ab7 | FindButton | FP00450_Setup_Condition.cs:1031 | try | DATA_OP | dtResult.Columns.Add | ("LINE_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60e43538 | FindButton | FP00450_Setup_Condition.cs:1037 | try ▸ try ▸ if (dsMain.Good()) | FLAG | LastRowForExcel | LastRow = 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c899e416 | FindButton | FP00450_Setup_Condition.cs:1037 | try ▸ try ▸ if (dsMain.Good()) | FLAG | LastRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-3d296d4b | FindButton | FP00450_Setup_Condition.cs:1039 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["COMPANY_ID"] | dsMain.Tables[0].Rows[0]["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-249be8a2 | FindButton | FP00450_Setup_Condition.cs:1040 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["DIVISION_ID"] | dsMain.Tables[0].Rows[0]["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-99137697 | FindButton | FP00450_Setup_Condition.cs:1041 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["SITE_ID"] | dsMain.Tables[0].Rows[0]["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-467ba67d | FindButton | FP00450_Setup_Condition.cs:1042 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["PLANT_ID"] | dsMain.Tables[0].Rows[0]["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc19be84 | FindButton | FP00450_Setup_Condition.cs:1043 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["OPERATION_ID"] | dsMain.Tables[0].Rows[0]["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8642847c | FindButton | FP00450_Setup_Condition.cs:1044 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["SETUP_CATEGORY_ID"] | dsMain.Tables[0].Rows[0]["SETUP_CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9d279a5c | FindButton | FP00450_Setup_Condition.cs:1045 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["SETUP_KEY_ID"] | dsMain.Tables[0].Rows[0]["SETUP_KEY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-84e20b98 | FindButton | FP00450_Setup_Condition.cs:1046 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | Filter["LINE_SETUP_GROUP_ID"] | dsMain.Tables[0].Rows[0]["LINE_SETUP_GROUP_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9303a8e0 | FindButton | FP00450_Setup_Condition.cs:1049 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sDivision | Filter["DIVISION_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-2a780904 | FindButton | FP00450_Setup_Condition.cs:1050 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sSite | Filter["SITE_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-e0b82f37 | FindButton | FP00450_Setup_Condition.cs:1051 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sCompany | Filter["COMPANY_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-87207c0b | FindButton | FP00450_Setup_Condition.cs:1052 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sPlant | Filter["PLANT_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-2854a512 | FindButton | FP00450_Setup_Condition.cs:1053 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sOperation | Filter["OPERATION_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-9885df25 | FindButton | FP00450_Setup_Condition.cs:1054 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sCategory | Filter["SETUP_CATEGORY_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-4374c645 | FindButton | FP00450_Setup_Condition.cs:1055 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sSetup | Filter["SETUP_KEY_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-90df6591 | FindButton | FP00450_Setup_Condition.cs:1056 | try ▸ try ▸ if (dsMain.Good()) | FLAG | sLineSetup | Filter["LINE_SETUP_GROUP_ID"] | 화면 필드/플래그 변경 |  |  |  |
| AC-48d1a9c3 | FindButton | FP00450_Setup_Condition.cs:1060 | try ▸ try ▸ else of (dsMain.Good()) | FLAG | LastRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-24bbe9c3 | FindButton | FP00450_Setup_Condition.cs:1062 | try ▸ try | FLAG | dsDetail | FindDataDetail(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4daff0f8 | FindButton | FP00450_Setup_Condition.cs:1067 | try ▸ try | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac3fa55d | FindButton | FP00450_Setup_Condition.cs:1068 | try ▸ try | DATA_OP | dRow.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a03c1cf | FindButton | FP00450_Setup_Condition.cs:1069 | try ▸ try | DATA_OP | dRow.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-257c9088 | FindButton | FP00450_Setup_Condition.cs:1070 | try ▸ try | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-31acbb03 | FindButton | FP00450_Setup_Condition.cs:1071 | try ▸ try | DATA_OP | dRow.Field | ("LINE_SETUP_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0dd99993 | FindButton | FP00450_Setup_Condition.cs:1072 | try ▸ try | DATA_OP | dRow.Field | ("SETUP_CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0f1505c | FindButton | FP00450_Setup_Condition.cs:1073 | try ▸ try | DATA_OP | dRow.Field | ("SETUP_KEY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-66592576 | FindButton | FP00450_Setup_Condition.cs:1077 | try ▸ try ▸ foreach (var b in distinctRows) | DATA_OP | dtResult.Rows.Add | (b.col1.ToString(), b.col2.ToString(), b.col3.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c298bb7 | FindButton | FP00450_Setup_Condition.cs:1084 | try ▸ catch ((Exception detailEx)) | THROW | throw detailEx; |  | 예외 발생 |  |  |  |
| AC-18218b88 | FindButton | FP00450_Setup_Condition.cs:1088 | try ▸ finally | DATA_OP | Filter["COMPANY_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b7036e57 | FindButton | FP00450_Setup_Condition.cs:1089 | try ▸ finally | DATA_OP | Filter["DIVISION_ID"] | old_divsion | 행/컬럼 값 대입 |  |  |  |
| AC-7dfaab20 | FindButton | FP00450_Setup_Condition.cs:1090 | try ▸ finally | DATA_OP | Filter["SITE_ID"] | old_site | 행/컬럼 값 대입 |  |  |  |
| AC-e749a53e | FindButton | FP00450_Setup_Condition.cs:1091 | try ▸ finally | DATA_OP | Filter["PLANT_ID"] | old_plant | 행/컬럼 값 대입 |  |  |  |
| AC-cbe21585 | FindButton | FP00450_Setup_Condition.cs:1092 | try ▸ finally | DATA_OP | Filter["OPERATION_ID"] | old_operation | 행/컬럼 값 대입 |  |  |  |
| AC-56936f24 | FindButton | FP00450_Setup_Condition.cs:1093 | try ▸ finally | DATA_OP | Filter["SETUP_CATEGORY_ID"] | old_category | 행/컬럼 값 대입 |  |  |  |
| AC-dcea7f40 | FindButton | FP00450_Setup_Condition.cs:1094 | try ▸ finally | DATA_OP | Filter["SETUP_KEY_ID"] | old_key | 행/컬럼 값 대입 |  |  |  |
| AC-d1f22bf3 | FindButton | FP00450_Setup_Condition.cs:1095 | try ▸ finally | DATA_OP | Filter["LINE_SETUP_GROUP_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b6190c86 | FindButton | FP00450_Setup_Condition.cs:1101 | try | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7973411a | FindButton | FP00450_Setup_Condition.cs:1102 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a3c0a272 | FindButton | FP00450_Setup_Condition.cs:1104 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f9ed5a4 | FindButton | FP00450_Setup_Condition.cs:1107 | try | DATA_OP | dsDetail.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bb24c8e9 | FindButton | FP00450_Setup_Condition.cs:1108 | try | GRID_BIND | siSub.Query | (dsDetail, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3dc02241 | FindButton | FP00450_Setup_Condition.cs:1112 | try | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |
| AC-e0247b47 | FindButton | FP00450_Setup_Condition.cs:1113 | try | LIST_REBIND | siSub.LoadCombo | (cb, dtResult, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c20db7f7 | FindButton | FP00450_Setup_Condition.cs:1117 | try | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-222b1db9 | FindButton | FP00450_Setup_Condition.cs:1124 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67e5b8f2 | FindButton | FP00450_Setup_Condition.cs:1129 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9f9217fd | FindButton | FP00450_Setup_Condition.cs:1130 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fefc0d86 | FindButton | FP00450_Setup_Condition.cs:1132 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00450_Setup_Condition.ValidateMainRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe9f66d0 | (진입점 미연결) | FP00450_Setup_Condition.cs:622 | if (!check) | RETURN | return "DIVISION_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-b663fc9f | (진입점 미연결) | FP00450_Setup_Condition.cs:630 | if (!check) | RETURN | return "SITE_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-4baea47c | (진입점 미연결) | FP00450_Setup_Condition.cs:638 | if (!check) | RETURN | return "PLANT_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-72c0a342 | (진입점 미연결) | FP00450_Setup_Condition.cs:646 | if (!check) | RETURN | return "OPERATION_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-39c989bd | (진입점 미연결) | FP00450_Setup_Condition.cs:654 | if (!check) | RETURN | return "LINE_SETUP_GROUP_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-781addc3 | (진입점 미연결) | FP00450_Setup_Condition.cs:662 | if (!check) | RETURN | return "SETUP_CATEGORY_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-fcf21715 | (진입점 미연결) | FP00450_Setup_Condition.cs:670 | if (!check) | RETURN | return "SETUP_KEY_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-c1a0f7a9 | (진입점 미연결) | FP00450_Setup_Condition.cs:678 | if (!check) | RETURN | return "SETUP_CONDITION_ID"; |  | 처리 중단/반환 |  |  |  |
| AC-31f2e7aa | (진입점 미연결) | FP00450_Setup_Condition.cs:686 | if (!check) | RETURN | return "SETUP_TIME"; |  | 처리 중단/반환 |  |  |  |
| AC-3c7d6001 | (진입점 미연결) | FP00450_Setup_Condition.cs:690 |  | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

