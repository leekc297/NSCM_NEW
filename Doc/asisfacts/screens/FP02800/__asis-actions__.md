# AS-IS 액션 대조표 — FP02800

> 원천: `Doc/asisfacts/screens/FP02800/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 120행 · 메서드 19 · 종류 FLAG 23 · GRID_INIT 18 · DATA_OP 16 · RETURN 9 · LIST_REBIND 9 · UI_PROP 7 · COMBO_DATA 7 · POPUP 4 · STATE 4 · UI_MISC 4 · THROW 4 · CALL_EXT 4 · MESSAGE 3 · ENDPOINT 3 · EXCEL 1 · CALL_BASE 1 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 5


## FP02800_BOM_Explosion.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32fefc6f | this.btnSql.Click | FP02800_BOM_Explosion.cs:323 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-54403550 | this.btnSql.Click | FP02800_BOM_Explosion.cs:324 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-de9b1842 | this.btnSql.Click | FP02800_BOM_Explosion.cs:326 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02800_BOM_EXPLOSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-edee23b6 | this.btnSql.Click | FP02800_BOM_Explosion.cs:327 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02800_BOM_Explosion.CboSite_SelectedIndexChanged

진입점: this.Load [try] / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7268be34 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:514 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4ed531b3 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:516 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02800_BOM_Explosion.checkValidItem

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaac00f7 | FindButton [try] | FP02800_BOM_Explosion.cs:674 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00246", new object[] { lblMaterial.CustomizationFormText, "5" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c754abcf | FindButton [try] | FP02800_BOM_Explosion.cs:677 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## FP02800_BOM_Explosion.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd75a034 | this.Load | FP02800_BOM_Explosion.cs:238 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d5f9e83b | this.Load | FP02800_BOM_Explosion.cs:239 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-75f32534 | this.Load | FP02800_BOM_Explosion.cs:241 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9233de6 | this.Load | FP02800_BOM_Explosion.cs:242 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9d284e0 | this.Load | FP02800_BOM_Explosion.cs:244 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02800_BOM_Explosion.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06178905 | this.Load | FP02800_BOM_Explosion.cs:181 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7cd6e538 | this.Load | FP02800_BOM_Explosion.cs:182 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-192825a3 | this.Load | FP02800_BOM_Explosion.cs:183 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-154d331c | this.Load | FP02800_BOM_Explosion.cs:187 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a899d86e | this.Load | FP02800_BOM_Explosion.cs:188 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d52da428 | this.Load | FP02800_BOM_Explosion.cs:189 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02800_BOM_Explosion.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c9a253e | Dispose | FP02800_BOM_Explosion.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02800_BOM_Explosion.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df791a10 | EditButton | FP02800_BOM_Explosion.cs:305 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce2620e9 | EditButton | FP02800_BOM_Explosion.cs:306 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02800_BOM_Explosion.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e696f59 | ExcelButton | FP02800_BOM_Explosion.cs:316 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02800_BOM_Explosion.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9587115 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:438 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pDivisionID = CString.GetCheckedListValue(dtDivision, clb… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aef86b26 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:440 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-53804dcc | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:441 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ebdbb33 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:442 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-098ba8a4 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:443 | try ▸ lambda | FLAG | pExplosionType | CString.GetCheckedListValue(dtExplosionType, cboExplosionType.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-74905f45 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:476 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02800_BOM_EXPLOSION") ⇒ FP_Master.PR_UI_FP02800_BOM_EXPLOSION | 엔드포인트 요청 생성 |  |  |  |
| AC-ed8f2aaa | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:477 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-75440fc3 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:478 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-42557bf1 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:479 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-7c2fbf3b | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:480 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7bf3961f | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:481 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-66d841b3 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:483 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-3f603b7d | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:484 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-5505916d | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:485 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-c67f2e2d | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:486 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-43591175 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:487 | try | DATA_OP | request.Parameters["p_bom_type"] | pExplosionType.Equals("ALL") ? DBNull.Value : pExplosionType | 행/컬럼 값 대입 |  |  |  |
| AC-515598a0 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:488 | try | DATA_OP | request.Parameters["p_view_type"] | pViewType.Equals("ALL") ? DBNull.Value : pViewType | 행/컬럼 값 대입 |  |  |  |
| AC-5b143dca | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:490 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-575ce492 | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:492 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-08a62b1d | popSql.OnSql [if (programID == "PR_UI_FP02800_BOM_EXPLOSION"… 외 1 | FP02800_BOM_Explosion.cs:499 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02800_BOM_Explosion.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a57a539f | FindButton | FP02800_BOM_Explosion.cs:335 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-54b65da2 | FindButton | FP02800_BOM_Explosion.cs:340 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-eb103b99 | FindButton | FP02800_BOM_Explosion.cs:340 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84595665 | FindButton | FP02800_BOM_Explosion.cs:342 | try ▸ if (!checkValidItem()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81022ae0 | FindButton | FP02800_BOM_Explosion.cs:346 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-976848b7 | FindButton | FP02800_BOM_Explosion.cs:347 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d5fa1b9 | FindButton | FP02800_BOM_Explosion.cs:350 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6c2dc59f | FindButton | FP02800_BOM_Explosion.cs:356 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6384591d | FindButton | FP02800_BOM_Explosion.cs:365 | try ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-676b2f24 | FindButton | FP02800_BOM_Explosion.cs:370 | try ▸ if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6352986 | FindButton | FP02800_BOM_Explosion.cs:380 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e5416d46 | FindButton | FP02800_BOM_Explosion.cs:381 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5a731ce | FindButton | FP02800_BOM_Explosion.cs:391 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f9bb8561 | FindButton | FP02800_BOM_Explosion.cs:395 | try ▸ if (siMain.ActiveSheetIndex == 0) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b58015b5 | FindButton | FP02800_BOM_Explosion.cs:396 | try ▸ if (siMain.ActiveSheetIndex == 0) | CALL_EXT | siMain.SetFormat | ("#,##0.#####", 8, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10b186ad | FindButton | FP02800_BOM_Explosion.cs:397 | try ▸ if (siMain.ActiveSheetIndex == 0) | CALL_EXT | siMain.SetFormat | ("#,##0.#####", 14, 1, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89ab9257 | FindButton | FP02800_BOM_Explosion.cs:401 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-132d2dd8 | FindButton | FP02800_BOM_Explosion.cs:404 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ec4dd922 | FindButton | FP02800_BOM_Explosion.cs:420 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a1fc3054 | FindButton | FP02800_BOM_Explosion.cs:421 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02800_BOM_Explosion.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-839ecbd6 | this.Load | FP02800_BOM_Explosion.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02800_BOM_Explosion.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd884a4c | this.Load [try] | FP02800_BOM_Explosion.cs:731 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c9aa2081 | this.Load [try] | FP02800_BOM_Explosion.cs:732 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4770f443 | this.Load [try] | FP02800_BOM_Explosion.cs:732 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4c2e57c9 | this.Load [try] | FP02800_BOM_Explosion.cs:733 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02800_BOM_Explosion.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83f34ca5 | this.Load | FP02800_BOM_Explosion.cs:130 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-28f1c1f9 | this.Load | FP02800_BOM_Explosion.cs:133 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-878d9efc | this.Load | FP02800_BOM_Explosion.cs:136 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-0b87450f | this.Load | FP02800_BOM_Explosion.cs:137 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-421539fc | this.Load | FP02800_BOM_Explosion.cs:141 | try | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-db347756 | this.Load | FP02800_BOM_Explosion.cs:141 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bcd56950 | this.Load | FP02800_BOM_Explosion.cs:142 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a89a1191 | this.Load | FP02800_BOM_Explosion.cs:145 | try | FLAG | dtExplosionType | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02800_BOM_EXPLOSION", "EXPLOSION_… | 화면 필드/플래그 변경 |  |  |  |
| AC-f8d868fc | this.Load | FP02800_BOM_Explosion.cs:145 | try | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02800_BOM_EXPLOSION", "EXPLOSION_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e262474e | this.Load | FP02800_BOM_Explosion.cs:160 | try | LIST_REBIND | clsCtrl.setListBox | (dtExplosionType, cboExplosionType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d60fa8d1 | this.Load | FP02800_BOM_Explosion.cs:171 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02800_BOM_Explosion.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57f0d4e1 | this.Load | FP02800_BOM_Explosion.cs:258 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53af3487 | this.Load | FP02800_BOM_Explosion.cs:259 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6e206c3 | this.Load | FP02800_BOM_Explosion.cs:264 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02800_BOM_Explosion.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bfdb79c | popSql.OnSql | FP02800_BOM_Explosion.cs:642 | if (programID == "PR_UI_FP02800_BOM_EXPLOSION") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-b9912689 | popSql.OnSql | FP02800_BOM_Explosion.cs:645 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02800_BOM_Explosion.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7add89d0 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:198 | try | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-913fe01f | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:199 | try | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-b427955a | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:200 | try | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-6ca234a5 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:200 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ea6b067 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:201 | try | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-85e072c2 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:205 | try | FLAG | sDataID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f75bbd9 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:206 | try | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-9aec4637 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:207 | try | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-ffaec2d2 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:207 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f5b5c35 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:208 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9c3a0bae | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:213 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-4e85588a | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:693 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff2a48c1 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:693 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ee5101e7 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:698 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-5bf62666 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:702 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-961c1baa | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:702 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-cc340b76 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:704 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bf6de69d | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:706 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-925497f5 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:712 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e0f5c430 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:713 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-eaf0e2a7 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:713 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-55d1c6e3 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:715 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-104ceaeb | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:717 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cd629987 | this.Load [try] 외 3 | FP02800_BOM_Explosion.cs:723 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP02800_BOM_Explosion.SetSpreadInit

진입점: this.Load [try] / FindButton [try ▸ if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cad14dc1 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:273 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4beaec6 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:274 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-f66c6a65 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:275 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e221dfdf | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:279 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9424c87 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:280 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-7e300063 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:281 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-158918a9 | this.Load [try] 외 1 | FP02800_BOM_Explosion.cs:290 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02800_BOM_Explosion.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-648741b3 | this.spdMain.ActiveSheetChanged | FP02800_BOM_Explosion.cs:530 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af64074d | this.spdMain.ActiveSheetChanged | FP02800_BOM_Explosion.cs:531 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-30798f48 | this.spdMain.ActiveSheetChanged | FP02800_BOM_Explosion.cs:540 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf86e638 | this.spdMain.ActiveSheetChanged | FP02800_BOM_Explosion.cs:541 | else of (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (((FarPoint.Win.Spread.FpSpread)sender).Acti… | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP02800_BOM_Explosion.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1091ede | this.spdMain.ComboSelChange | FP02800_BOM_Explosion.cs:554 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtSub) ▸ if (siMain.ActiveSh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

