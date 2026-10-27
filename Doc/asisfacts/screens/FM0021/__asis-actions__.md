# AS-IS 액션 대조표 — FM0021

> 원천: `Doc/asisfacts/screens/FM0021/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 198행 · 메서드 23 · 종류 DATA_OP 50 · GRID_SET 31 · RETURN 19 · FLAG 18 · POPUP 10 · GRID_INIT 10 · UI_PROP 9 · GRID_LOCK 8 · COMBO_DATA 6 · THROW 5 · LIST_REBIND 5 · UI_MISC 5 · ENDPOINT 5 · MESSAGE 5 · VALIDATE 3 · CALL_EXT 2 · STATE 2 · STATE_RESET 1 · EXCEL 1 · GRID_BIND 1 · GRID_STYLE 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 3


## FM0021_Building_BOD.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c2eb8d4 | this.btnImport.Click | FM0021_Building_BOD.cs:446 | try | POPUP | new FPC0100_ExcelImportPopup | ("FPC0100", "BuildingBODImport", "FP_Master.PR_UI_FM0021_BUILDING_BOD", sParamsFilter, sDb… | 팝업/폼 생성 |  |  |  |
| AC-1350705d | this.btnImport.Click | FM0021_Building_BOD.cs:447 | try | UI_PROP | popComImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7d65af70 | this.btnImport.Click | FM0021_Building_BOD.cs:448 | try | POPUP | popComImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-44320fa0 | this.btnImport.Click | FM0021_Building_BOD.cs:459 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0021_Building_BOD.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd37e451 | this.btnSql.Click | FM0021_Building_BOD.cs:411 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-441b2d89 | this.btnSql.Click | FM0021_Building_BOD.cs:412 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3fc130b5 | this.btnSql.Click | FM0021_Building_BOD.cs:414 |  | DATA_OP | popSql.Services.Add | ("SELECT_BUILDING_BOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac2b8763 | this.btnSql.Click | FM0021_Building_BOD.cs:415 |  | DATA_OP | popSql.Services.Add | ("SAVE_BUILDING_BOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-97b34702 | this.btnSql.Click | FM0021_Building_BOD.cs:416 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FM0021_Building_BOD.ClbSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6f2f6a5 | cboSite.SelectedIndexChanged | FM0021_Building_BOD.cs:828 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-77b5fbc9 | cboSite.SelectedIndexChanged | FM0021_Building_BOD.cs:833 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-eca3b2a9 | cboSite.SelectedIndexChanged | FM0021_Building_BOD.cs:836 |  | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-4e221b8d | cboSite.SelectedIndexChanged | FM0021_Building_BOD.cs:836 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf65d6a9 | cboSite.SelectedIndexChanged | FM0021_Building_BOD.cs:837 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |

## FM0021_Building_BOD.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db61fbee | (진입점 미연결) | FM0021_Building_BOD.cs:248 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-fb3602b8 | (진입점 미연결) | FM0021_Building_BOD.cs:249 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FM0021_Building_BOD.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2aa7faf | this.Load | FM0021_Building_BOD.cs:258 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8041a86a | this.Load | FM0021_Building_BOD.cs:259 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-36d227d7 | this.Load | FM0021_Building_BOD.cs:261 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FM0021_Building_BOD.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42b4d9ef | this.Load | FM0021_Building_BOD.cs:172 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-bde44f22 | this.Load | FM0021_Building_BOD.cs:174 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d903bb0c | this.Load | FM0021_Building_BOD.cs:175 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-1ce8ac4b | this.Load | FM0021_Building_BOD.cs:176 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FM0021_Building_BOD.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccbd197d | DeleteButton | FM0021_Building_BOD.cs:380 | if (spdMain != null) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95bc33b6 | DeleteButton | FM0021_Building_BOD.cs:384 | if (spdMain != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FM0021_Building_BOD.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-422ffc91 | Dispose | FM0021_Building_BOD.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FM0021_Building_BOD.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67ad27d2 | EditButton | FM0021_Building_BOD.cs:339 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9fb6c29e | EditButton | FM0021_Building_BOD.cs:341 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-38004598 | EditButton | FM0021_Building_BOD.cs:343 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.TRANSPORT_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a06434ec | EditButton | FM0021_Building_BOD.cs:344 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM), siMain.GetColumnIndex(DefColumns.TR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c86ad32 | EditButton | FM0021_Building_BOD.cs:354 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN1.Equals("N") \|\| sEditYN2.Equals… | GRID_SET | siMain.ActiveSheet.Rows[i,i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-c8387e79 | EditButton | FM0021_Building_BOD.cs:355 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN1.Equals("N") \|\| sEditYN2.Equals… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |

## FM0021_Building_BOD.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-318b02e8 | ExcelButton | FM0021_Building_BOD.cs:804 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FM0021_Building_BOD.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3df3fc1 | FindButton 외 1 | FM0021_Building_BOD.cs:470 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f97e72d4 | FindButton 외 1 | FM0021_Building_BOD.cs:474 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1456f579 | FindButton 외 1 | FM0021_Building_BOD.cs:477 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-7755edce | FindButton 외 1 | FM0021_Building_BOD.cs:477 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-037bed5c | FindButton 외 1 | FM0021_Building_BOD.cs:483 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-990f4513 | FindButton 외 1 | FM0021_Building_BOD.cs:486 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-628cea93 | FindButton 외 1 | FM0021_Building_BOD.cs:492 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_BuildingBOD("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e4f99df | FindButton 외 1 | FM0021_Building_BOD.cs:503 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cbc88487 | FindButton 외 1 | FM0021_Building_BOD.cs:505 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-949e024a | FindButton 외 1 | FM0021_Building_BOD.cs:508 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9c5fbe59 | FindButton 외 1 | FM0021_Building_BOD.cs:512 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-45a55346 | FindButton 외 1 | FM0021_Building_BOD.cs:520 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-90623fa0 | FindButton 외 1 | FM0021_Building_BOD.cs:525 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d4d5cb7c | FindButton 외 1 | FM0021_Building_BOD.cs:529 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a64c0e8b | FindButton 외 1 | FM0021_Building_BOD.cs:531 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7b3d24c8 | FindButton 외 1 | FM0021_Building_BOD.cs:531 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FM0021_Building_BOD.Find_Data_BuildingBOD

진입점: popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21308e42 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:541 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c75b89b | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:555 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0021_BUILDING_BOD") ⇒ FP_Master.PR_UI_FM0021_BUILDING_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-704bfdb5 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:556 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-924406e1 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:557 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-a8dffe28 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:558 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b25bfd6 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:559 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-281d7b6c | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:561 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cabdaac8 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:562 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-034c98f0 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:563 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-c97e74f6 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:564 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbeefb7c | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:565 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-28d278c2 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:566 | try | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51a9f11f | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:567 | try | DATA_OP | request.Parameters["p_from_factory_id"] | request.Parameters["p_from_operation_id"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-659b0f4b | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:568 | try | DATA_OP | request.Parameters["p_from_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-081f7e7b | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:569 | try | DATA_OP | request.Parameters["p_to_factory_id"] | request.Parameters["p_to_operation_id"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3558460 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:570 | try | DATA_OP | request.Parameters["p_to_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-48779b13 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:571 | try | DATA_OP | request.Parameters["p_bod_pattern_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-932ee63c | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:572 | try | DATA_OP | request.Parameters["p_transport_mode"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00296771 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:573 | try | DATA_OP | request.Parameters["p_transport_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-281b87b1 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:574 | try | DATA_OP | request.Parameters["p_transport_time_uom"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3abe3003 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:575 | try | DATA_OP | request.Parameters["p_bod_start_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7f08a5fc | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:576 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0bdf8b0a | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:577 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c5d222a | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:579 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b731a01c | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:581 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e7266afb | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FM0021_Building_BOD.cs:586 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0021_Building_BOD.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af2b2b7f | this.Load | FM0021_Building_BOD.cs:106 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FM0021_Building_BOD.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0324bb0 | this.Load | FM0021_Building_BOD.cs:127 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a49c3b0a | this.Load | FM0021_Building_BOD.cs:133 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ceb18e28 | this.Load | FM0021_Building_BOD.cs:134 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-071ca169 | this.Load | FM0021_Building_BOD.cs:137 | try | FLAG | dtTransportMode | DataCommon.GetUserFormCodeData(_FormProcedure, "FM0021_findLookUpCode", "TRANSPORT_MODE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-22d460ee | this.Load | FM0021_Building_BOD.cs:137 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FM0021_findLookUpCode", "TRANSPORT_MODE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-086cecf1 | this.Load | FM0021_Building_BOD.cs:138 | try | FLAG | dtTransportTimeUON | DataCommon.GetUserFormCodeData(_FormProcedure, "FM0021_findLookUpCode", "TRANSPORT_TIME_UO… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-45de44bb | this.Load | FM0021_Building_BOD.cs:138 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FM0021_findLookUpCode", "TRANSPORT_TIME_UOM") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-005986e2 | this.Load | FM0021_Building_BOD.cs:142 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-0cd9a2f7 | this.Load | FM0021_Building_BOD.cs:142 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3a4ab26 | this.Load | FM0021_Building_BOD.cs:145 | try ▸ if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-92658368 | this.Load | FM0021_Building_BOD.cs:148 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e68a8612 | this.Load | FM0021_Building_BOD.cs:157 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-501753e8 | this.Load | FM0021_Building_BOD.cs:158 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-13bff67f | this.Load | FM0021_Building_BOD.cs:159 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3a069d0b | this.Load | FM0021_Building_BOD.cs:165 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0021_Building_BOD.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b31f8d8a | this.Load | FM0021_Building_BOD.cs:273 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f57f4b7 | this.Load | FM0021_Building_BOD.cs:274 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-db213aee | this.Load | FM0021_Building_BOD.cs:278 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0021_Building_BOD.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67d42a90 | InsertButton | FM0021_Building_BOD.cs:597 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9ed6d38 | InsertButton | FM0021_Building_BOD.cs:605 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID)].CellTy… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8fbfb0cb | InsertButton | FM0021_Building_BOD.cs:606 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TO_OPERATION_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-de152b66 | InsertButton | FM0021_Building_BOD.cs:613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-83a6dc70 | InsertButton | FM0021_Building_BOD.cs:614 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_FACTORY_ID), siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3cb23e2 | InsertButton | FM0021_Building_BOD.cs:615 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_NAME), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eff42d64 | InsertButton | FM0021_Building_BOD.cs:616 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM), siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1be7ad41 | InsertButton | FM0021_Building_BOD.cs:619 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM), "MINUTE") | 그리드 값 설정 |  |  |  |

## FM0021_Building_BOD.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-730db6a9 | popSql.OnSql | FM0021_Building_BOD.cs:956 | if (programID == "SELECT_BUILDING_BOD") | RETURN | return Find_Data_BuildingBOD("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-aec534c7 | popSql.OnSql | FM0021_Building_BOD.cs:960 | else of (programID == "SELECT_BUILDING_BOD") ▸ if (programID == "SAVE_BUILDING_BOD") | RETURN | return Save_Data_BuildingBOD("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-ea06a482 | popSql.OnSql | FM0021_Building_BOD.cs:962 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0021_Building_BOD.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69d879d7 | SaveButton | FM0021_Building_BOD.cs:628 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37c66abd | SaveButton | FM0021_Building_BOD.cs:630 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80a10a66 | SaveButton | FM0021_Building_BOD.cs:634 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e45df8c2 | SaveButton | FM0021_Building_BOD.cs:635 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b15ed1f | SaveButton | FM0021_Building_BOD.cs:638 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-60342bff | SaveButton | FM0021_Building_BOD.cs:645 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-bc6e6a57 | SaveButton | FM0021_Building_BOD.cs:647 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-429848ce | SaveButton | FM0021_Building_BOD.cs:648 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29add2e0 | SaveButton | FM0021_Building_BOD.cs:653 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3347ac31 | SaveButton | FM0021_Building_BOD.cs:658 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-613e2878 | SaveButton | FM0021_Building_BOD.cs:667 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05d92def | SaveButton | FM0021_Building_BOD.cs:671 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d158c9d3 | SaveButton | FM0021_Building_BOD.cs:675 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-11175183 | SaveButton | FM0021_Building_BOD.cs:676 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-3e354262 | SaveButton | FM0021_Building_BOD.cs:680 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FM0021_Building_BOD.Save_Data_BuildingBOD

진입점: popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸ if (programID == "SAVE_BUILDING_BOD")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a80daa01 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:727 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState==CAppSetting.FlagM) ▸ if (string.IsNullOrEmpty(sBodId)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91ab83c5 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:728 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState==CAppSetting.FlagM) ▸ if (string.IsNullOrEmpty(sBodId)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e421779b | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:761 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FM0021_BUILDING_BOD") ⇒ FP_Master.PR_UI_FM0021_BUILDING_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-ad5e1a20 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:762 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-563a6c1b | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:764 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-df3a4d23 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:765 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5acf4890 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:766 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-6c902e0a | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:767 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-97c4eb23 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:768 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-ade4791d | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:769 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9cc244fb | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:770 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-02370ce2 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:771 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-6570e18f | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:772 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-e1bfbdc2 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:773 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d6e7d86 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:774 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_from_factory_id"] | p_from_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-c57731ac | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:775 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_from_operation_id"] | p_from_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c2dd901 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:776 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_factory_id"] | p_to_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf1da3bc | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:777 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_operation_id"] | p_to_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-7d30f79e | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:778 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bod_pattern_id"] | p_bod_pattern_id | 행/컬럼 값 대입 |  |  |  |
| AC-dd7e3b60 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:779 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-1d1f9cfb | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:780 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_time"] | p_transport_time | 행/컬럼 값 대입 |  |  |  |
| AC-dea49801 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:781 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_time_uom"] | p_transport_time_uom | 행/컬럼 값 대입 |  |  |  |
| AC-88190ca5 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:782 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bod_start_time"] | p_bod_start_time | 행/컬럼 값 대입 |  |  |  |
| AC-e81fb3a9 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:783 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-355d4e19 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:784 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-10ae43ab | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:786 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eb1b8dab | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:787 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7de959af | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:793 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-333313f8 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FM0021_Building_BOD.cs:799 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FM0021_Building_BOD.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc112ef | SaveButton | FM0021_Building_BOD.cs:397 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FM0021_Building_BOD.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7387c5be | this.Load [try] 외 1 | FM0021_Building_BOD.cs:197 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-0afd4a42 | this.Load [try] 외 1 | FM0021_Building_BOD.cs:199 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ec844b3e | this.Load [try] 외 1 | FM0021_Building_BOD.cs:199 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f5cf775 | this.Load [try] 외 1 | FM0021_Building_BOD.cs:200 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b87e53d6 | this.Load [try] 외 1 | FM0021_Building_BOD.cs:205 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-67ab1c03 | this.Load [try] 외 1 | FM0021_Building_BOD.cs:208 | try | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca42aac3 | this.Load [try] 외 1 | FM0021_Building_BOD.cs:208 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23ee9d0a | this.Load [try] 외 1 | FM0021_Building_BOD.cs:209 | try | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d0040f2f | this.Load [try] 외 1 | FM0021_Building_BOD.cs:215 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FM0021_Building_BOD.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-418a98fa | this.Load [try] | FM0021_Building_BOD.cs:287 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d765873a | this.Load [try] | FM0021_Building_BOD.cs:288 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-fdbf6eeb | this.Load [try] | FM0021_Building_BOD.cs:293 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-05c0e4da | this.Load [try] | FM0021_Building_BOD.cs:294 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-87ff029e | this.Load [try] | FM0021_Building_BOD.cs:297 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-28646b86 | this.Load [try] | FM0021_Building_BOD.cs:298 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f2abe4a4 | this.Load [try] | FM0021_Building_BOD.cs:299 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-26444844 | this.Load [try] | FM0021_Building_BOD.cs:300 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5462fa16 | this.Load [try] | FM0021_Building_BOD.cs:301 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BOD_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2c105580 | this.Load [try] | FM0021_Building_BOD.cs:302 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FROM_OPERATION_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-438f32c2 | this.Load [try] | FM0021_Building_BOD.cs:303 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TO_OPERATION_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2064b000 | this.Load [try] | FM0021_Building_BOD.cs:304 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BOD_PATTERN_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2360cb54 | this.Load [try] | FM0021_Building_BOD.cs:305 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5677a2b9 | this.Load [try] | FM0021_Building_BOD.cs:306 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BOD_START_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-380e3fc2 | this.Load [try] | FM0021_Building_BOD.cs:307 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.RELEASE_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-44c001ba | this.Load [try] | FM0021_Building_BOD.cs:308 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4761a764 | this.Load [try] | FM0021_Building_BOD.cs:309 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN1)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-712e0be5 | this.Load [try] | FM0021_Building_BOD.cs:310 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN2)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FM0021_Building_BOD.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c779fd7d | this.spdMain.CellClick | FM0021_Building_BOD.cs:868 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fbf743e | this.spdMain.CellClick | FM0021_Building_BOD.cs:870 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7dc7729e | this.spdMain.CellClick | FM0021_Building_BOD.cs:886 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | POPUP | new FPC0025_WorkCenterOperationPopup | (sSheetName, sSite, sToFactory) | 팝업/폼 생성 |  |  |  |
| AC-91b1a506 | this.spdMain.CellClick | FM0021_Building_BOD.cs:887 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bed05d50 | this.spdMain.CellClick | FM0021_Building_BOD.cs:888 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-463a718a | this.spdMain.CellClick | FM0021_Building_BOD.cs:900 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-408226ce | this.spdMain.CellClick | FM0021_Building_BOD.cs:901 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-b2348942 | this.spdMain.CellClick | FM0021_Building_BOD.cs:902 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-d5d354d3 | this.spdMain.CellClick | FM0021_Building_BOD.cs:903 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-e0d6f230 | this.spdMain.CellClick | FM0021_Building_BOD.cs:904 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), sFromFactory) | 그리드 값 설정 |  |  |  |
| AC-cd4c8412 | this.spdMain.CellClick | FM0021_Building_BOD.cs:905 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_FACTORY_ID), sFromFactory) | 그리드 값 설정 |  |  |  |
| AC-48f84de5 | this.spdMain.CellClick | FM0021_Building_BOD.cs:906 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID), sFromOperation) | 그리드 값 설정 |  |  |  |
| AC-6827379c | this.spdMain.CellClick | FM0021_Building_BOD.cs:907 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_NAME), sFromOperationName) | 그리드 값 설정 |  |  |  |
| AC-c6f31bcf | this.spdMain.CellClick | FM0021_Building_BOD.cs:915 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df0e67e6 | this.spdMain.CellClick | FM0021_Building_BOD.cs:919 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | POPUP | new FPC0025_WorkCenterOperationPopup | (sSheetName, "", "") | 팝업/폼 생성 |  |  |  |
| AC-416d6318 | this.spdMain.CellClick | FM0021_Building_BOD.cs:920 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-110d760e | this.spdMain.CellClick | FM0021_Building_BOD.cs:921 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bfa0ff1d | this.spdMain.CellClick | FM0021_Building_BOD.cs:930 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_FACTORY_ID), sToFactory) | 그리드 값 설정 |  |  |  |
| AC-cd9fd4fb | this.spdMain.CellClick | FM0021_Building_BOD.cs:931 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_OPERATION_ID), sToOperation) | 그리드 값 설정 |  |  |  |
| AC-01ed5328 | this.spdMain.CellClick | FM0021_Building_BOD.cs:932 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_OPERATION_NAME), sToOperationName) | 그리드 값 설정 |  |  |  |
| AC-8d7ad313 | this.spdMain.CellClick | FM0021_Building_BOD.cs:939 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

