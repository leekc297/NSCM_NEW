# AS-IS 액션 대조표 — FP00160

> 원천: `Doc/asisfacts/screens/FP00160/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 214행 · 메서드 24 · 종류 DATA_OP 50 · GRID_SET 32 · FLAG 22 · RETURN 20 · UI_PROP 13 · POPUP 10 · GRID_INIT 10 · GRID_LOCK 8 · UI_MISC 6 · COMBO_DATA 6 · MESSAGE 6 · THROW 5 · LIST_REBIND 5 · ENDPOINT 5 · STATE 4 · GRID_STYLE 3 · VALIDATE 3 · CALL_EXT 2 · STATE_RESET 1 · EXCEL 1 · GRID_BIND 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 3


## FP00160_Building_BOD.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0baaaa1a | this.btnImport.Click | FP00160_Building_BOD.cs:841 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-728cfaac | this.btnImport.Click | FP00160_Building_BOD.cs:845 | try | POPUP | new FPC0100_ExcelImportPopup | ("FPC0100", "BuildingBODImport", "FP_Master.PR_UI_FP00160_BUILDING_BOD", sParamsFilter, sD… | 팝업/폼 생성 |  |  |  |
| AC-afa52774 | this.btnImport.Click | FP00160_Building_BOD.cs:846 | try | UI_PROP | popComImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7f243b8b | this.btnImport.Click | FP00160_Building_BOD.cs:847 | try | POPUP | popComImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-55454818 | this.btnImport.Click | FP00160_Building_BOD.cs:858 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00160_Building_BOD.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07bf80d1 | this.btnSql.Click | FP00160_Building_BOD.cs:805 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3d9bcd40 | this.btnSql.Click | FP00160_Building_BOD.cs:806 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1cfa758a | this.btnSql.Click | FP00160_Building_BOD.cs:808 |  | DATA_OP | popSql.Services.Add | ("SELECT_BUILDING_BOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-77884d78 | this.btnSql.Click | FP00160_Building_BOD.cs:809 |  | DATA_OP | popSql.Services.Add | ("SAVE_BUILDING_BOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cdbd5b2 | this.btnSql.Click | FP00160_Building_BOD.cs:810 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00160_Building_BOD.ClbSite_SelectedIndexChanged

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65676a39 | cboSite.SelectedIndexChanged | FP00160_Building_BOD.cs:881 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-586d25a7 | cboSite.SelectedIndexChanged | FP00160_Building_BOD.cs:886 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-92774b6e | cboSite.SelectedIndexChanged | FP00160_Building_BOD.cs:889 |  | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-2e900dd5 | cboSite.SelectedIndexChanged | FP00160_Building_BOD.cs:889 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70445ca3 | cboSite.SelectedIndexChanged | FP00160_Building_BOD.cs:890 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00160_Building_BOD.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbc74807 | (진입점 미연결) | FP00160_Building_BOD.cs:266 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d9002b37 | (진입점 미연결) | FP00160_Building_BOD.cs:267 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00160_Building_BOD.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3d0c1b9 | this.Load | FP00160_Building_BOD.cs:276 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6e819fa8 | this.Load | FP00160_Building_BOD.cs:277 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb2a5939 | this.Load | FP00160_Building_BOD.cs:279 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00160_Building_BOD.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5681a639 | this.Load | FP00160_Building_BOD.cs:186 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-d2451a1d | this.Load | FP00160_Building_BOD.cs:188 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-46d73605 | this.Load | FP00160_Building_BOD.cs:189 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-79f66767 | this.Load | FP00160_Building_BOD.cs:190 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00160_Building_BOD.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d26de4a0 | DeleteButton | FP00160_Building_BOD.cs:417 | if (spdMain != null) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04a2cc97 | DeleteButton | FP00160_Building_BOD.cs:421 | if (spdMain != null) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00160_Building_BOD.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-812a5dc0 | Dispose | FP00160_Building_BOD.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00160_Building_BOD.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d88fe7ba | EditButton | FP00160_Building_BOD.cs:357 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7f10ba8 | EditButton | FP00160_Building_BOD.cs:359 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0f1e3c5a | EditButton | FP00160_Building_BOD.cs:361 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.TRANSPORT_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d7322a3 | EditButton | FP00160_Building_BOD.cs:362 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM), siMain.GetColumnIndex(DefColumns.TR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-383d4fa7 | EditButton | FP00160_Building_BOD.cs:372 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN1.Equals("N") \|\| sEditYN2.Equals… | GRID_SET | siMain.ActiveSheet.Rows[i,i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-a9bf6cb7 | EditButton | FP00160_Building_BOD.cs:376 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN1.Equals("N") \|\| sEditYN2.Equals… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-68055aab | EditButton | FP00160_Building_BOD.cs:380 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN1.Equals("N") \|\| sEditYN2.Equals… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-015f5877 | EditButton | FP00160_Building_BOD.cs:387 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN1.Equals("N") \|\| sEditYN2.E… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME), i, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-39c511d5 | EditButton | FP00160_Building_BOD.cs:391 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN1.Equals("N") \|\| sEditYN2.E… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME), i, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |

## FP00160_Building_BOD.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c35dd72 | ExcelButton | FP00160_Building_BOD.cs:793 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00160_Building_BOD.Find_Data

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e036924 | FindButton 외 1 | FP00160_Building_BOD.cs:451 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b006f937 | FindButton 외 1 | FP00160_Building_BOD.cs:456 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1ae8443 | FindButton 외 1 | FP00160_Building_BOD.cs:457 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce95b667 | FindButton 외 1 | FP00160_Building_BOD.cs:460 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0be5cd44 | FindButton 외 1 | FP00160_Building_BOD.cs:463 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47dcc114 | FindButton 외 1 | FP00160_Building_BOD.cs:466 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b2d87e38 | FindButton 외 1 | FP00160_Building_BOD.cs:466 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0aaec353 | FindButton 외 1 | FP00160_Building_BOD.cs:472 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b7141b45 | FindButton 외 1 | FP00160_Building_BOD.cs:475 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7965f6e2 | FindButton 외 1 | FP00160_Building_BOD.cs:481 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_BuildingBOD("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f02d20d | FindButton 외 1 | FP00160_Building_BOD.cs:492 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-df3f9897 | FindButton 외 1 | FP00160_Building_BOD.cs:494 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-99a304d9 | FindButton 외 1 | FP00160_Building_BOD.cs:497 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-10ab0044 | FindButton 외 1 | FP00160_Building_BOD.cs:501 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d12adaf9 | FindButton 외 1 | FP00160_Building_BOD.cs:509 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-2379c6c2 | FindButton 외 1 | FP00160_Building_BOD.cs:514 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dbfb6db9 | FindButton 외 1 | FP00160_Building_BOD.cs:518 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-19f6d33f | FindButton 외 1 | FP00160_Building_BOD.cs:519 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f05e5b2b | FindButton 외 1 | FP00160_Building_BOD.cs:520 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a474e223 | FindButton 외 1 | FP00160_Building_BOD.cs:520 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00160_Building_BOD.Find_Data_BuildingBOD

진입점: popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5ab3ee6 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:530 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa2a93f7 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:542 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00160_BUILDING_BOD") ⇒ FP_Master.PR_UI_FP00160_BUILDING_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-da45bf7e | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:544 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-bec6e76a | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:545 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-ad89e989 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:546 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36933473 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:547 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-233f6f5e | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:549 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d0572bb6 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:550 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-b5e179d8 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:551 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-21a8879a | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:552 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9a292bff | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:553 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-5c4ed304 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:554 | try | DATA_OP | request.Parameters["p_bod_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc1eab45 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:555 | try | DATA_OP | request.Parameters["p_from_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-98c44046 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:556 | try | DATA_OP | request.Parameters["p_from_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8a3f1da | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:557 | try | DATA_OP | request.Parameters["p_to_factory_id"] | request.Parameters["p_to_operation_id"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-9c94a314 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:558 | try | DATA_OP | request.Parameters["p_to_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a870d9a3 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:559 | try | DATA_OP | request.Parameters["p_bod_pattern_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d8b0697b | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:560 | try | DATA_OP | request.Parameters["p_transport_mode"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-91d6c661 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:561 | try | DATA_OP | request.Parameters["p_transport_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b5d96231 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:562 | try | DATA_OP | request.Parameters["p_transport_time_uom"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a5ef87c6 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:563 | try | DATA_OP | request.Parameters["p_bod_start_time"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38d695cb | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:564 | try | DATA_OP | request.Parameters["p_release_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f0192e4 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:565 | try | DATA_OP | request.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-34d742b2 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:567 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-59885bcb | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:569 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9485ce17 | popSql.OnSql [if (programID == "SELECT_BUILDING_BOD")] 외 2 | FP00160_Building_BOD.cs:574 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00160_Building_BOD.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6779ba94 | this.Load | FP00160_Building_BOD.cs:106 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00160_Building_BOD.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1688c25 | this.Load | FP00160_Building_BOD.cs:127 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5db46a57 | this.Load | FP00160_Building_BOD.cs:133 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5df4663f | this.Load | FP00160_Building_BOD.cs:134 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7494f0a8 | this.Load | FP00160_Building_BOD.cs:139 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-953d8d4e | this.Load | FP00160_Building_BOD.cs:141 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-ac856b95 | this.Load | FP00160_Building_BOD.cs:145 | try | FLAG | dtTransportMode | DataCommon.GetUserFormCodeData(_FormProcedure, "FP00160_findLookUpCode", "TRANSPORT_MODE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-ac1e9dca | this.Load | FP00160_Building_BOD.cs:145 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP00160_findLookUpCode", "TRANSPORT_MODE") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f6eb42c | this.Load | FP00160_Building_BOD.cs:146 | try | FLAG | dtTransportTimeUON | DataCommon.GetUserFormCodeData(_FormProcedure, "FP00160_findLookUpCode", "TRANSPORT_TIME_U… ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0720956b | this.Load | FP00160_Building_BOD.cs:146 | try | COMBO_DATA | DataCommon.GetUserFormCodeData | (_FormProcedure, "FP00160_findLookUpCode", "TRANSPORT_TIME_UOM") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f77a17ae | this.Load | FP00160_Building_BOD.cs:150 | try | FLAG | dtMyDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-edaf8ad5 | this.Load | FP00160_Building_BOD.cs:150 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18974481 | this.Load | FP00160_Building_BOD.cs:153 | try ▸ if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-18fc3e75 | this.Load | FP00160_Building_BOD.cs:156 | try | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-cec8dedb | this.Load | FP00160_Building_BOD.cs:165 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f7aca0e1 | this.Load | FP00160_Building_BOD.cs:166 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b5542111 | this.Load | FP00160_Building_BOD.cs:167 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-558f7490 | this.Load | FP00160_Building_BOD.cs:172 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-558058ae | this.Load | FP00160_Building_BOD.cs:173 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-74454372 | this.Load | FP00160_Building_BOD.cs:174 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4c491eb4 | this.Load | FP00160_Building_BOD.cs:179 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00160_Building_BOD.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d16649af | this.Load | FP00160_Building_BOD.cs:237 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-4b4fa39d | this.Load | FP00160_Building_BOD.cs:238 |  | UI_PROP | clbBuilding.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-ee7b3fe4 | this.Load | FP00160_Building_BOD.cs:239 |  | UI_PROP | cboSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00160_Building_BOD.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beb9c2e1 | this.Load | FP00160_Building_BOD.cs:291 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7a3726b | this.Load | FP00160_Building_BOD.cs:292 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e084129d | this.Load | FP00160_Building_BOD.cs:296 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00160_Building_BOD.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4eb0572 | InsertButton | FP00160_Building_BOD.cs:585 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-246975e8 | InsertButton | FP00160_Building_BOD.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID)].CellTy… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-92169274 | InsertButton | FP00160_Building_BOD.cs:594 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TO_OPERATION_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-be0d1a81 | InsertButton | FP00160_Building_BOD.cs:601 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f28c633e | InsertButton | FP00160_Building_BOD.cs:602 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TO_FACTORY_ID), siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6a79a96d | InsertButton | FP00160_Building_BOD.cs:603 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_NAME), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fe42dcc2 | InsertButton | FP00160_Building_BOD.cs:604 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM), siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-caea7072 | InsertButton | FP00160_Building_BOD.cs:607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM), "MINUTE") | 그리드 값 설정 |  |  |  |

## FP00160_Building_BOD.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c26eb3c1 | popSql.OnSql | FP00160_Building_BOD.cs:1009 | if (programID == "SELECT_BUILDING_BOD") | RETURN | return Find_Data_BuildingBOD("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-c0302e9e | popSql.OnSql | FP00160_Building_BOD.cs:1013 | else of (programID == "SELECT_BUILDING_BOD") ▸ if (programID == "SAVE_BUILDING_BOD") | RETURN | return Save_Data_BuildingBOD("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9daf4cc2 | popSql.OnSql | FP00160_Building_BOD.cs:1015 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00160_Building_BOD.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d7cd7fd | SaveButton | FP00160_Building_BOD.cs:616 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6179d0e8 | SaveButton | FP00160_Building_BOD.cs:618 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e041d0b9 | SaveButton | FP00160_Building_BOD.cs:622 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1542e4c | SaveButton | FP00160_Building_BOD.cs:623 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42a19474 | SaveButton | FP00160_Building_BOD.cs:626 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-db2479eb | SaveButton | FP00160_Building_BOD.cs:633 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8399deea | SaveButton | FP00160_Building_BOD.cs:635 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0ace6472 | SaveButton | FP00160_Building_BOD.cs:636 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39a2792f | SaveButton | FP00160_Building_BOD.cs:641 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9c378900 | SaveButton | FP00160_Building_BOD.cs:646 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30b7d215 | SaveButton | FP00160_Building_BOD.cs:655 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-09d4cf75 | SaveButton | FP00160_Building_BOD.cs:659 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-16d10d79 | SaveButton | FP00160_Building_BOD.cs:663 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4763d06b | SaveButton | FP00160_Building_BOD.cs:664 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-0bd05447 | SaveButton | FP00160_Building_BOD.cs:668 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00160_Building_BOD.Save_Data_BuildingBOD

진입점: popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸ if (programID == "SAVE_BUILDING_BOD")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7db1ba21 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:715 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState==CAppSetting.FlagM) ▸ if (string.IsNullOrEmpty(sBodId)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44999834 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:716 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState==CAppSetting.FlagM) ▸ if (string.IsNullOrEmpty(sBodId)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0d2e3a48 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:749 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00160_BUILDING_BOD") ⇒ FP_Master.PR_UI_FP00160_BUILDING_BOD | 엔드포인트 요청 생성 |  |  |  |
| AC-92d9d32c | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:750 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-87190b17 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:752 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-63d10de8 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:753 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-aff69380 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:754 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a79d1ec4 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:755 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-8182f194 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:756 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-cceae034 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:757 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-00b1aee7 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:758 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-79efe1bb | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:759 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-840fff68 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:760 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-c535243d | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:761 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bod_id"] | p_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5a65dd7 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:762 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_from_factory_id"] | p_from_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-0dd84317 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:763 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_from_operation_id"] | p_from_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-2bcce3d7 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:764 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_factory_id"] | p_to_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5258b97 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:765 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_to_operation_id"] | p_to_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-3e850f52 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:766 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bod_pattern_id"] | p_bod_pattern_id | 행/컬럼 값 대입 |  |  |  |
| AC-50cdd9b2 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:767 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_mode"] | p_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-0e633a72 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:768 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_time"] | p_transport_time | 행/컬럼 값 대입 |  |  |  |
| AC-bdff8428 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:769 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_transport_time_uom"] | p_transport_time_uom | 행/컬럼 값 대입 |  |  |  |
| AC-09f088fc | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:770 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_bod_start_time"] | p_bod_start_time | 행/컬럼 값 대입 |  |  |  |
| AC-d2a22f73 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:771 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_release_flag"] | p_release_flag | 행/컬럼 값 대입 |  |  |  |
| AC-116494d7 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:772 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-30467d0a | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:774 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-97e2ba59 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:775 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-41c66a62 | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:781 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-aa07321a | popSql.OnSql [else of (programID == "SELECT_BUILDING_BOD") ▸… 외 1 | FP00160_Building_BOD.cs:787 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00160_Building_BOD.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a1cbf6 | SaveButton | FP00160_Building_BOD.cs:434 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00160_Building_BOD.SetChangedControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6f3e824 | this.Load [try] 외 1 | FP00160_Building_BOD.cs:211 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ef15e5d | this.Load [try] 외 1 | FP00160_Building_BOD.cs:213 | try | FLAG | dtSiteByDivision | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", ""… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1fbd36f7 | this.Load [try] 외 1 | FP00160_Building_BOD.cs:213 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, "", "", "", "", "", "", pDivisi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ee6d5866 | this.Load [try] 외 1 | FP00160_Building_BOD.cs:214 | try | LIST_REBIND | clsCtrl.setListBox | (dtSiteByDivision, cboSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c519ebf6 | this.Load [try] 외 1 | FP00160_Building_BOD.cs:219 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e21da299 | this.Load [try] 외 1 | FP00160_Building_BOD.cs:222 | try | FLAG | dtBuildingBySitePlant | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-3164816e | this.Load [try] 외 1 | FP00160_Building_BOD.cs:222 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eacf2b2f | this.Load [try] 외 1 | FP00160_Building_BOD.cs:223 | try | LIST_REBIND | clsCtrl.setListBox | (dtBuildingBySitePlant, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-00fe04c8 | this.Load [try] 외 1 | FP00160_Building_BOD.cs:229 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00160_Building_BOD.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-163725a6 | this.Load [try] | FP00160_Building_BOD.cs:305 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c1cc0d4 | this.Load [try] | FP00160_Building_BOD.cs:306 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5a07cd26 | this.Load [try] | FP00160_Building_BOD.cs:311 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-208fb543 | this.Load [try] | FP00160_Building_BOD.cs:312 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_TIME_UOM)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2c3675ef | this.Load [try] | FP00160_Building_BOD.cs:315 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-99102d5f | this.Load [try] | FP00160_Building_BOD.cs:316 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-81dc527f | this.Load [try] | FP00160_Building_BOD.cs:317 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3ba18772 | this.Load [try] | FP00160_Building_BOD.cs:318 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FACTORY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-bf13cd57 | this.Load [try] | FP00160_Building_BOD.cs:319 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BOD_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-aa9b410f | this.Load [try] | FP00160_Building_BOD.cs:320 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.FROM_OPERATION_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f0f51c84 | this.Load [try] | FP00160_Building_BOD.cs:321 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TO_OPERATION_NAME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6df58f55 | this.Load [try] | FP00160_Building_BOD.cs:322 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BOD_PATTERN_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ed0bb94c | this.Load [try] | FP00160_Building_BOD.cs:323 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6e499523 | this.Load [try] | FP00160_Building_BOD.cs:324 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.BOD_START_TIME)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f9dd938f | this.Load [try] | FP00160_Building_BOD.cs:325 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.RELEASE_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e624bcd7 | this.Load [try] | FP00160_Building_BOD.cs:326 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DESCRIPTION)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c327f74a | this.Load [try] | FP00160_Building_BOD.cs:327 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-17ba2ccd | this.Load [try] | FP00160_Building_BOD.cs:328 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN2)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00160_Building_BOD.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4b3813a | this.spdMain.CellClick | FP00160_Building_BOD.cs:921 | try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44f396b3 | this.spdMain.CellClick | FP00160_Building_BOD.cs:923 | try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e551190 | this.spdMain.CellClick | FP00160_Building_BOD.cs:939 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | POPUP | new FPC0025_WorkCenterOperationPopup | (sSheetName, "", "") | 팝업/폼 생성 |  |  |  |
| AC-236d981f | this.spdMain.CellClick | FP00160_Building_BOD.cs:940 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-369d07ca | this.spdMain.CellClick | FP00160_Building_BOD.cs:941 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ae1ea984 | this.spdMain.CellClick | FP00160_Building_BOD.cs:953 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.COMPANY_ID), sCompany) | 그리드 값 설정 |  |  |  |
| AC-09287081 | this.spdMain.CellClick | FP00160_Building_BOD.cs:954 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-76421e52 | this.spdMain.CellClick | FP00160_Building_BOD.cs:955 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SITE_ID), sSite) | 그리드 값 설정 |  |  |  |
| AC-52bb2236 | this.spdMain.CellClick | FP00160_Building_BOD.cs:956 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID), sPlant) | 그리드 값 설정 |  |  |  |
| AC-2842a7fe | this.spdMain.CellClick | FP00160_Building_BOD.cs:957 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), sFromFactory) | 그리드 값 설정 |  |  |  |
| AC-df985b16 | this.spdMain.CellClick | FP00160_Building_BOD.cs:958 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_FACTORY_ID), sFromFactory) | 그리드 값 설정 |  |  |  |
| AC-437747a5 | this.spdMain.CellClick | FP00160_Building_BOD.cs:959 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID), sFromOperation) | 그리드 값 설정 |  |  |  |
| AC-1d863633 | this.spdMain.CellClick | FP00160_Building_BOD.cs:960 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATION_ID… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FROM_OPERATION_NAME), sFromOperationName) | 그리드 값 설정 |  |  |  |
| AC-ae5d1819 | this.spdMain.CellClick | FP00160_Building_BOD.cs:968 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bfb0cc8d | this.spdMain.CellClick | FP00160_Building_BOD.cs:972 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | POPUP | new FPC0025_WorkCenterOperationPopup | (sSheetName, "", "") | 팝업/폼 생성 |  |  |  |
| AC-d41f2a29 | this.spdMain.CellClick | FP00160_Building_BOD.cs:973 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d5c499c4 | this.spdMain.CellClick | FP00160_Building_BOD.cs:974 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5cd9c94d | this.spdMain.CellClick | FP00160_Building_BOD.cs:983 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_FACTORY_ID), sToFactory) | 그리드 값 설정 |  |  |  |
| AC-5d49243b | this.spdMain.CellClick | FP00160_Building_BOD.cs:984 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_OPERATION_ID), sToOperation) | 그리드 값 설정 |  |  |  |
| AC-c3b71ab3 | this.spdMain.CellClick | FP00160_Building_BOD.cs:985 | try ▸ if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FROM_OPERATI… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TO_OPERATION_NAME), sToOperationName) | 그리드 값 설정 |  |  |  |
| AC-6c3859f8 | this.spdMain.CellClick | FP00160_Building_BOD.cs:992 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

