# AS-IS 액션 대조표 — SSP0014

> 원천: `Doc/asisfacts/screens/SSP0014/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 190행 · 메서드 16 · 종류 UI_PROP 54 · DATA_OP 29 · POPUP 23 · GRID_SET 18 · RETURN 13 · GRID_INIT 8 · FLAG 7 · UI_MISC 7 · GRID_LOCK 7 · ENDPOINT 7 · LIST_REBIND 5 · VALIDATE 3 · MESSAGE 3 · COMBO_DATA 3 · VALUE_SET 1 · GRID_BIND 1 · CALL_EXT 1 · ⚠ 의미 확인 필요 1


## SSP0014_ShipmentModelPIC.btnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5b96e87 | btnItemId.Click | SSP0014_ShipmentModelPIC.cs:847 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0ce081d0 | btnItemId.Click | SSP0014_ShipmentModelPIC.cs:849 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-09e970d7 | btnItemId.Click | SSP0014_ShipmentModelPIC.cs:850 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f2f7978 | btnItemId.Click | SSP0014_ShipmentModelPIC.cs:851 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2686d1b6 | btnItemId.Click | SSP0014_ShipmentModelPIC.cs:857 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0014_ShipmentModelPIC.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-745c17a9 | this.Load | SSP0014_ShipmentModelPIC.cs:208 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-be755cc8 | this.Load | SSP0014_ShipmentModelPIC.cs:209 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-74d22945 | this.Load | SSP0014_ShipmentModelPIC.cs:211 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0014_ShipmentModelPIC.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95651fb3 | this.Load | SSP0014_ShipmentModelPIC.cs:160 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-4147c409 | this.Load | SSP0014_ShipmentModelPIC.cs:162 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-640c6e11 | this.Load | SSP0014_ShipmentModelPIC.cs:163 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-c317afdc | this.Load | SSP0014_ShipmentModelPIC.cs:164 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0014_ShipmentModelPIC.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f87e2bf8 | Dispose | SSP0014_ShipmentModelPIC.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0014_ShipmentModelPIC.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24912c2a | EditButton | SSP0014_ShipmentModelPIC.cs:271 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-27c959a0 | EditButton | SSP0014_ShipmentModelPIC.cs:272 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-fa89aaaa | EditButton | SSP0014_ShipmentModelPIC.cs:274 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION), siMain.GetColumnIndex(DefColumns.NICK_NAME), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ffdaaa0 | EditButton | SSP0014_ShipmentModelPIC.cs:275 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.USER_NAME), siMain.GetColumnIndex(DefColumns.USER_NAME),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a260070e | EditButton | SSP0014_ShipmentModelPIC.cs:276 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PART_LEADER_NAME), siMain.GetColumnIndex(DefColumns.PART… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4b522b0 | EditButton | SSP0014_ShipmentModelPIC.cs:277 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TEAM_LEADER_NAME), siMain.GetColumnIndex(DefColumns.TEAM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad9e726b | EditButton | SSP0014_ShipmentModelPIC.cs:278 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0014_ShipmentModelPIC.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-988f93b0 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:295 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3860be61 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:300 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c9354549 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:300 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb99b949 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:304 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d5b976dc | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:324 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8d5fa689 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:325 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f23de17f | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:329 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0014_GET_SHIPMENT_MODEL_PIC") ⇒ SSP.SSP0014_GET_SHIPMENT_MODEL_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-a04e851c | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:330 | try ▸ lambda | UI_PROP | req.CommandTimeout | 60 * 10 | 속성 CommandTimeout 설정 |  |  |  |
| AC-680ff96d | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:331 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-644594b7 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:332 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-b899a637 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:333 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-3801a2e0 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:334 | try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-74fe918a | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:335 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-034875c5 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:336 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-343dae57 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:337 | try ▸ lambda | DATA_OP | req.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-114b30ed | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:338 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a189de3 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:339 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-89778528 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:346 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ebc64e28 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:348 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-238276bd | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:350 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2b11379d | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:357 | try ▸ for (i< dsBinding.Tables[0].AsEnumerable().Count()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToStri… | GRID_INIT | siMain.SetCellTypeText | (i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-38ad0b95 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:358 | try ▸ for (i< dsBinding.Tables[0].AsEnumerable().Count()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToStri… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP),"Warranty") | 그리드 값 설정 |  |  |  |
| AC-f745639b | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:359 | try ▸ for (i< dsBinding.Tables[0].AsEnumerable().Count()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP)).ToStri… | CALL_EXT | siMain.SetHAlign | (i, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), i, siMain.GetColumnIndex(DefColumns… | ⚠ 의미 확인 필요 |  |  |  |
| AC-13f9ab1e | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:364 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cec2440 | FindButton 외 1 | SSP0014_ShipmentModelPIC.cs:372 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0014_ShipmentModelPIC.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a69ed1d2 | this.Load | SSP0014_ShipmentModelPIC.cs:116 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0014_ShipmentModelPIC.GetUserIDChk

진입점: SaveButton [try ▸ if (iCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbb30210 | SaveButton [try ▸ if (iCount > 0)] | SSP0014_ShipmentModelPIC.cs:562 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0014_GET_USER_ID_CHECK") ⇒ SSP.SSP0014_GET_USER_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-c52f0a64 | SaveButton [try ▸ if (iCount > 0)] | SSP0014_ShipmentModelPIC.cs:563 | try | DATA_OP | request.Parameters["p_user_id"] | sUserID | 행/컬럼 값 대입 |  |  |  |
| AC-15e5c795 | SaveButton [try ▸ if (iCount > 0)] | SSP0014_ShipmentModelPIC.cs:565 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e62eb803 | SaveButton [try ▸ if (iCount > 0)] | SSP0014_ShipmentModelPIC.cs:578 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ foreach (string user in strUSer) | DATA_OP | ds.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-75861ddc | SaveButton [try ▸ if (iCount > 0)] | SSP0014_ShipmentModelPIC.cs:600 | try ▸ if (iCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b9e23eb0 | SaveButton [try ▸ if (iCount > 0)] | SSP0014_ShipmentModelPIC.cs:604 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-14699ef4 | SaveButton [try ▸ if (iCount > 0)] | SSP0014_ShipmentModelPIC.cs:606 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0014_ShipmentModelPIC.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8410695 | this.Load | SSP0014_ShipmentModelPIC.cs:176 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8db78fe1 | this.Load | SSP0014_ShipmentModelPIC.cs:179 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2a244315 | this.Load | SSP0014_ShipmentModelPIC.cs:183 |  | DATA_OP | dtOpreationGroup.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-91b580e4 | this.Load | SSP0014_ShipmentModelPIC.cs:184 |  | DATA_OP | insertRow["CODE"] | "W" | 행/컬럼 값 대입 |  |  |  |
| AC-1782565f | this.Load | SSP0014_ShipmentModelPIC.cs:185 |  | DATA_OP | insertRow["NAME"] | "Warrnaty" | 행/컬럼 값 대입 |  |  |  |
| AC-18cd4e9c | this.Load | SSP0014_ShipmentModelPIC.cs:187 |  | DATA_OP | dtOpreationGroup.Rows.Add | (insertRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7f7b491 | this.Load | SSP0014_ShipmentModelPIC.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dd57edb0 | this.Load | SSP0014_ShipmentModelPIC.cs:190 |  | LIST_REBIND | clsCtrl.setListBox | (dtOpreationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-740ca433 | this.Load | SSP0014_ShipmentModelPIC.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboValidYN, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0014_ShipmentModelPIC.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54001b22 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:220 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-897d9a80 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:221 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-945ac0c4 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:222 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-28ea041e | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:223 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d5dff46 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:225 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.USER_ID].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8adfcad3 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:226 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.PART_LEADER].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b1ce1c5c | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:227 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TEAM_LEADER].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1522ace5 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:229 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.MAIL_USER1].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b5bed3bc | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:230 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.MAIL_USER2].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-758d0009 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:231 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.MAIL_USER3].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a7737570 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:232 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.MAIL_USER4].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9957b566 | this.Load 외 2 | SSP0014_ShipmentModelPIC.cs:233 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.MAIL_USER5].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0014_ShipmentModelPIC.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ec160a9 | SaveButton | SSP0014_ShipmentModelPIC.cs:387 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-66ca6977 | SaveButton | SSP0014_ShipmentModelPIC.cs:391 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e377e1d8 | SaveButton | SSP0014_ShipmentModelPIC.cs:393 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-cfc8d6e7 | SaveButton | SSP0014_ShipmentModelPIC.cs:393 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27d12e14 | SaveButton | SSP0014_ShipmentModelPIC.cs:441 | try ▸ if (iCount > 0) ▸ if (!GetUserIDChk(p_user_id)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2a5eeee | SaveButton | SSP0014_ShipmentModelPIC.cs:444 | try ▸ if (iCount > 0) ▸ if (p_part_leader.Replace("^", "") != null && p_part_leader.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_part_leade… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-def26fa0 | SaveButton | SSP0014_ShipmentModelPIC.cs:448 | try ▸ if (iCount > 0) ▸ if (p_team_leader.Replace("^", "") != null && p_team_leader.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_team_leade… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-059b5db8 | SaveButton | SSP0014_ShipmentModelPIC.cs:457 | try ▸ if (iCount > 0) ▸ foreach (string mailUser1 in arrMailUser1) ▸ if (!string.IsNullOrEmpty(mailUser1) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2358c9d3 | SaveButton | SSP0014_ShipmentModelPIC.cs:466 | try ▸ if (iCount > 0) ▸ foreach (string mailUser2 in arrMailUser2) ▸ if (!string.IsNullOrEmpty(mailUser2) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-606987d6 | SaveButton | SSP0014_ShipmentModelPIC.cs:475 | try ▸ if (iCount > 0) ▸ foreach (string mailUser3 in arrMailUser3) ▸ if (!string.IsNullOrEmpty(mailUser3) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-729a4c83 | SaveButton | SSP0014_ShipmentModelPIC.cs:484 | try ▸ if (iCount > 0) ▸ foreach (string mailUser4 in arrMailUser4) ▸ if (!string.IsNullOrEmpty(mailUser4) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e13518bb | SaveButton | SSP0014_ShipmentModelPIC.cs:493 | try ▸ if (iCount > 0) ▸ foreach (string mailUser5 in arrMailUser5) ▸ if (!string.IsNullOrEmpty(mailUser5) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc764448 | SaveButton | SSP0014_ShipmentModelPIC.cs:497 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC") ⇒ SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-808bc012 | SaveButton | SSP0014_ShipmentModelPIC.cs:501 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5532eb8f | SaveButton | SSP0014_ShipmentModelPIC.cs:502 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5a48cfb3 | SaveButton | SSP0014_ShipmentModelPIC.cs:503 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-0c7157cb | SaveButton | SSP0014_ShipmentModelPIC.cs:504 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-45ef4012 | SaveButton | SSP0014_ShipmentModelPIC.cs:505 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8628f0a5 | SaveButton | SSP0014_ShipmentModelPIC.cs:506 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b7493836 | SaveButton | SSP0014_ShipmentModelPIC.cs:507 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_create_id"] | p_create_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8e576f9 | SaveButton | SSP0014_ShipmentModelPIC.cs:508 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_part_leader"] | p_part_leader | 행/컬럼 값 대입 |  |  |  |
| AC-1f846508 | SaveButton | SSP0014_ShipmentModelPIC.cs:509 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_team_leader"] | p_team_leader | 행/컬럼 값 대입 |  |  |  |
| AC-78155a29 | SaveButton | SSP0014_ShipmentModelPIC.cs:511 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user1"] | p_mail_user1 | 행/컬럼 값 대입 |  |  |  |
| AC-cd043f56 | SaveButton | SSP0014_ShipmentModelPIC.cs:512 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user2"] | p_mail_user2 | 행/컬럼 값 대입 |  |  |  |
| AC-7431bf12 | SaveButton | SSP0014_ShipmentModelPIC.cs:513 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user3"] | p_mail_user3 | 행/컬럼 값 대입 |  |  |  |
| AC-581f5fea | SaveButton | SSP0014_ShipmentModelPIC.cs:514 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user4"] | p_mail_user4 | 행/컬럼 값 대입 |  |  |  |
| AC-9c1c997b | SaveButton | SSP0014_ShipmentModelPIC.cs:515 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user5"] | p_mail_user5 | 행/컬럼 값 대입 |  |  |  |
| AC-c0de9c7c | SaveButton | SSP0014_ShipmentModelPIC.cs:517 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0432f4ca | SaveButton | SSP0014_ShipmentModelPIC.cs:522 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ec0764f4 | SaveButton | SSP0014_ShipmentModelPIC.cs:524 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0bf75fe8 | SaveButton | SSP0014_ShipmentModelPIC.cs:529 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9e5de405 | SaveButton | SSP0014_ShipmentModelPIC.cs:542 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-effd64ce | SaveButton | SSP0014_ShipmentModelPIC.cs:550 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0014_ShipmentModelPIC.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b61cac6d | this.Load | SSP0014_ShipmentModelPIC.cs:137 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c075fd12 | this.Load | SSP0014_ShipmentModelPIC.cs:138 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1225e4e2 | this.Load | SSP0014_ShipmentModelPIC.cs:144 | switch (triggerControl) case "MyDivisionCMM": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivisionCMM", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-30a18f58 | this.Load | SSP0014_ShipmentModelPIC.cs:144 | switch (triggerControl) case "MyDivisionCMM": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivisionCMM", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8ec1dbf5 | this.Load | SSP0014_ShipmentModelPIC.cs:149 | switch (triggerControl) case "OPERATION_GROUP": | FLAG | dtOpreationGroup | DataService.GetSSPInnerTable("OPERATION_GROUP", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-652fb467 | this.Load | SSP0014_ShipmentModelPIC.cs:149 | switch (triggerControl) case "OPERATION_GROUP": | COMBO_DATA | DataService.GetSSPInnerTable | ("OPERATION_GROUP", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0014_ShipmentModelPIC.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d569b4c | this.Load 외 1 | SSP0014_ShipmentModelPIC.cs:202 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-aef4958a | this.Load 외 1 | SSP0014_ShipmentModelPIC.cs:202 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1bcb8422 | this.Load 외 1 | SSP0014_ShipmentModelPIC.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0014_ShipmentModelPIC.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d332b69c | (진입점 미연결) | SSP0014_ShipmentModelPIC.cs:381 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.USER_ID) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.USER_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0014_ShipmentModelPIC.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f059f32 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fd2ee0be | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-fae364f7 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:636 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-bb145f5d | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:637 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fa989fce | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:638 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-1406bbd9 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:639 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-06f6999e | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:641 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-e2192c27 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:643 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-be741084 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:649 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) ▸ if (popup.Sho… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-867c1269 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:658 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dab10688 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:660 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-9a21a8f5 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:661 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-bdaf5ba5 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:662 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dcae25dd | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:663 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-7dd3a98e | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:664 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-c4b6e9fa | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:666 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-8f62178f | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:668 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4d46e1b2 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:674 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PART_LEADER), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-1138b87e | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ff949a1c | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:685 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-d20db644 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:686 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-b15a719a | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:687 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f35ef5ba | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:688 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-1ab60e5b | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:689 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-be07cdba | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:691 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-def618b5 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:693 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3e10869c | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:699 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_LEADER), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-834858a3 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:708 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-77f02297 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-a094af85 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-6153f0fb | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:712 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0ac2e4e3 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:713 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-d4ac2b44 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:714 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-cf1d7e4c | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:716 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-6bbe2e96 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-51aaae40 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:724 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER1), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-ef33fc55 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:733 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-070a4304 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-d8cf24ef | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:736 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-8545e6a7 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f44bca91 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:738 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-e1b6b6e6 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:739 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-4895b288 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-5faf146e | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:743 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cf58e840 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER2), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-b64b24aa | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3ef7f60f | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:760 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-f336fe8f | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-d23d609f | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:762 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d8ef49a2 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-13965e4b | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:764 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-e830eda5 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:766 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-4d995963 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:768 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-94ee1e0d | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:774 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER3), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-9520bed9 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:783 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-85c7b4ec | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:785 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-89991064 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:786 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-4bd1164f | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:787 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-707ef8c2 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:788 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-cd55d896 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:789 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-1c492aea | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:791 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-a27981f0 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:793 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ee0b6a81 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:799 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER4), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-919c8b92 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:808 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b7299436 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:810 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-fe291232 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:811 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-d0335d6d | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:812 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6fb8cd4c | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:813 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-06642220 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:814 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-74128c5b | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:816 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-940a97f2 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:818 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6ffc18a0 | spdMain.CellDoubleClick | SSP0014_ShipmentModelPIC.cs:824 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER5), item.UserID) | 그리드 값 설정 |  |  |  |

## SSP0014_ShipmentModelPIC.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8427f1e | spdMain.TopChange | SSP0014_ShipmentModelPIC.cs:622 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

