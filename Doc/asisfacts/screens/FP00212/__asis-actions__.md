# AS-IS 액션 대조표 — FP00212

> 원천: `Doc/asisfacts/screens/FP00212/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 95행 · 메서드 18 · 종류 FLAG 20 · DATA_OP 16 · UI_PROP 9 · RETURN 7 · LIST_REBIND 7 · COMBO_DATA 6 · POPUP 4 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · ENDPOINT 3 · MESSAGE 2 · CALL_EXT 2 · EXCEL 1 · CALL_BASE 1 · THROW 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 3


## FP00212_BOMExplosionLevel.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4098fd5 | this.btnSql.Click | FP00212_BOMExplosionLevel.cs:272 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7c95bd51 | this.btnSql.Click | FP00212_BOMExplosionLevel.cs:273 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-eb5983f0 | this.btnSql.Click | FP00212_BOMExplosionLevel.cs:275 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ec59b30 | this.btnSql.Click | FP00212_BOMExplosionLevel.cs:276 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00212_BOMExplosionLevel.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-603a1067 | (진입점 미연결) | FP00212_BOMExplosionLevel.cs:493 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00212_BOMExplosionLevel.ClbDivision_SelectedIndexChanged

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f9caac6 | this.Load 외 1 | FP00212_BOMExplosionLevel.cs:193 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9130578d | this.Load 외 1 | FP00212_BOMExplosionLevel.cs:195 |  | UI_PROP | clbSite.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00212_BOMExplosionLevel.ClbSite_SelectedIndexChanged

진입점: this.Load / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39bb240f | this.Load 외 1 | FP00212_BOMExplosionLevel.cs:200 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-23e88b2a | this.Load 외 1 | FP00212_BOMExplosionLevel.cs:202 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00212_BOMExplosionLevel.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7de70ed | this.Load | FP00212_BOMExplosionLevel.cs:228 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-30736b02 | this.Load | FP00212_BOMExplosionLevel.cs:229 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-395940a8 | this.Load | FP00212_BOMExplosionLevel.cs:230 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00212_BOMExplosionLevel.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d629cbb | this.Load | FP00212_BOMExplosionLevel.cs:129 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fb3b7e6a | this.Load | FP00212_BOMExplosionLevel.cs:130 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-e37a600d | this.Load | FP00212_BOMExplosionLevel.cs:131 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-19f93bf4 | this.Load | FP00212_BOMExplosionLevel.cs:135 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-775833f2 | this.Load | FP00212_BOMExplosionLevel.cs:136 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-8dc76876 | this.Load | FP00212_BOMExplosionLevel.cs:137 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00212_BOMExplosionLevel.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17de9031 | Dispose | FP00212_BOMExplosionLevel.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00212_BOMExplosionLevel.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7990419 | EditButton | FP00212_BOMExplosionLevel.cs:254 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6826faa | EditButton | FP00212_BOMExplosionLevel.cs:255 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00212_BOMExplosionLevel.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f1cb893 | ExcelButton | FP00212_BOMExplosionLevel.cs:265 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00212_BOMExplosionLevel.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d49c6b74 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:363 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-786f1e07 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:365 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b20afb4 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:366 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-25f162cb | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:367 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-54fb38f4 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:388 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL") ⇒ FP_Master.PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL | 엔드포인트 요청 생성 |  |  |  |
| AC-7395b6a1 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:389 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-750be870 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:390 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-a66c9d28 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:391 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-4294fa7b | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:392 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-16b29dc5 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:393 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-3f5e1b2e | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:395 | try | DATA_OP | request.Parameters["p_division_lt"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-517695f7 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:396 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-b3fff61e | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:397 | try | DATA_OP | request.Parameters["p_plant_lt"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-fef7bb4c | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:398 | try | DATA_OP | request.Parameters["p_model"] | pModel | 행/컬럼 값 대입 |  |  |  |
| AC-ab7a9428 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:399 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-344a0c93 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:401 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f880da69 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:403 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-070dfd29 | popSql.OnSql [if (programID == "PR_UI_FP00212_GET_BOM_EXPLOS… 외 1 | FP00212_BOMExplosionLevel.cs:410 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00212_BOMExplosionLevel.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da7fcb8f | FindButton | FP00212_BOMExplosionLevel.cs:284 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-204305b7 | FindButton | FP00212_BOMExplosionLevel.cs:290 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38b37748 | FindButton | FP00212_BOMExplosionLevel.cs:291 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e230aa7f | FindButton | FP00212_BOMExplosionLevel.cs:294 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9482e8b5 | FindButton | FP00212_BOMExplosionLevel.cs:296 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-7ca5bbfd | FindButton | FP00212_BOMExplosionLevel.cs:296 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92a0da10 | FindButton | FP00212_BOMExplosionLevel.cs:302 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8aa566a4 | FindButton | FP00212_BOMExplosionLevel.cs:311 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9a47b2ba | FindButton | FP00212_BOMExplosionLevel.cs:313 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f2e3798 | FindButton | FP00212_BOMExplosionLevel.cs:325 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-eacfc694 | FindButton | FP00212_BOMExplosionLevel.cs:327 | try | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-573f9018 | FindButton | FP00212_BOMExplosionLevel.cs:328 | try | CALL_EXT | siMain.SetFormat | ("#,##0.######", 9, 2, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-26e6c3ee | FindButton | FP00212_BOMExplosionLevel.cs:330 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b45b70d | FindButton | FP00212_BOMExplosionLevel.cs:333 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7a1ed324 | FindButton | FP00212_BOMExplosionLevel.cs:346 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6f49518b | FindButton | FP00212_BOMExplosionLevel.cs:347 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00212_BOMExplosionLevel.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf909cfc | this.Load | FP00212_BOMExplosionLevel.cs:108 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00212_BOMExplosionLevel.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f232c3ea | this.Load | FP00212_BOMExplosionLevel.cs:544 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5cf5d5e3 | this.Load | FP00212_BOMExplosionLevel.cs:545 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d7174d7 | this.Load | FP00212_BOMExplosionLevel.cs:545 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c5f445d9 | this.Load | FP00212_BOMExplosionLevel.cs:546 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00212_BOMExplosionLevel.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4455dd8 | this.Load | FP00212_BOMExplosionLevel.cs:144 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-36f8ab72 | this.Load | FP00212_BOMExplosionLevel.cs:146 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a41568a | this.Load | FP00212_BOMExplosionLevel.cs:149 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d6926092 | this.Load | FP00212_BOMExplosionLevel.cs:150 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00212_BOMExplosionLevel.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91e05ba4 | this.Load 외 1 | FP00212_BOMExplosionLevel.cs:237 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-885ccfc3 | this.Load 외 1 | FP00212_BOMExplosionLevel.cs:239 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00212_BOMExplosionLevel.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81386a66 | popSql.OnSql | FP00212_BOMExplosionLevel.cs:455 | if (programID == "PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-e984ce43 | popSql.OnSql | FP00212_BOMExplosionLevel.cs:458 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00212_BOMExplosionLevel.Search_After

진입점: FindButton [finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49e4750e | FindButton [finally] | FP00212_BOMExplosionLevel.cs:419 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-88aa7c86 | FindButton [finally] | FP00212_BOMExplosionLevel.cs:426 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-194cb23a | FindButton [finally] | FP00212_BOMExplosionLevel.cs:432 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sCheck_Alt.SafeString().Equals("Y")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.ALT_PRIORITY), i, siMain.GetColumnIndex(DefColumns.AL… | 그리드 표시 설정 |  |  |  |

## FP00212_BOMExplosionLevel.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eccf007 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:178 |  | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-d65d1565 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:179 |  | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-85cdebfc | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:180 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-2bbb6281 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:180 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22bb91c4 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:181 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f50990ba | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:184 |  | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-38e7d71b | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:185 |  | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-252d15bf | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:186 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-32922c35 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:186 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-50ad94c1 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-857685de | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:506 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-980aadec | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:506 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c436ed6e | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:511 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0d82bbe | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:515 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-27d55f40 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:515 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-46ad6841 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:517 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)clbSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-34b7c0d7 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:519 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)clbSite is UsrCombo) ▸ if ((object)clbSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f2940adc | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:525 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5e9cb74d | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:526 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-db4ec97e | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:526 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-70a16c12 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:528 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eb8ac376 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:530 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dc90a2d2 | this.Load 외 3 | FP00212_BOMExplosionLevel.cs:536 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

