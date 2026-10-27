# AS-IS 액션 대조표 — DMF0013

> 원천: `Doc/asisfacts/screens/DMF0013/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 313행 · 메서드 32 · 종류 DATA_OP 82 · GRID_INIT 39 · FLAG 31 · RETURN 23 · COMBO_DATA 22 · MESSAGE 20 · ENDPOINT 20 · LIST_REBIND 14 · GRID_STYLE 11 · POPUP 10 · UI_PROP 9 · GRID_LOCK 8 · GRID_COMBO 6 · UI_MISC 5 · VALUE_SET 4 · GRID_SET 3 · STATE 2 · CALL_EXT 1 · EXCEL 1 · GRID_BIND 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 1


## DMF0013_CustPsiUpload.btmItem_Click

진입점: this.btmItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-282de6b3 | this.btmItem.Click | DMF0013_CustPsiUpload.cs:720 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-d0cb0527 | this.btmItem.Click | DMF0013_CustPsiUpload.cs:722 |  | POPUP | popItem.Form_Load | (true, sdivision, "", sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-20bf6ac3 | this.btmItem.Click | DMF0013_CustPsiUpload.cs:723 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d763766e | this.btmItem.Click | DMF0013_CustPsiUpload.cs:724 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3c4fa089 | this.btmItem.Click | DMF0013_CustPsiUpload.cs:730 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0013_CustPsiUpload.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc3104d6 | this.btnExcelUpload.Click | DMF0013_CustPsiUpload.cs:927 |  | POPUP | new ExcelUploadForm | ("DMF0013", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-8a22b13f | this.btnExcelUpload.Click | DMF0013_CustPsiUpload.cs:928 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-abc51474 | this.btnExcelUpload.Click | DMF0013_CustPsiUpload.cs:929 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0bf90f32 | this.btnExcelUpload.Click | DMF0013_CustPsiUpload.cs:930 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0013_CustPsiUpload.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72b73e33 | this.btnProject.Click | DMF0013_CustPsiUpload.cs:693 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-7412f8ba | this.btnProject.Click | DMF0013_CustPsiUpload.cs:694 |  | POPUP | popProject.Form_Load | (true, sDivision, "", sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d467da17 | this.btnProject.Click | DMF0013_CustPsiUpload.cs:695 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c5eb162f | this.btnProject.Click | DMF0013_CustPsiUpload.cs:696 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-36e485e3 | this.btnProject.Click | DMF0013_CustPsiUpload.cs:703 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0013_CustPsiUpload.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95467146 | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:645 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6c5cc156 | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:645 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0000b20 | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:646 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-490ca96a | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:650 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ea9228a3 | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:650 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8905b156 | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:651 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-18afb0ae | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:655 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-db60376a | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:655 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e701c9af | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:656 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5ccc0f2f | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:658 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-0ee952c0 | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:658 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dda52a33 | this.clbDivision.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:659 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0013_CustPsiUpload.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09dc3d52 | this.clbEndCustomer.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:681 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5a02a670 | this.clbEndCustomer.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:681 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e5553aa | this.clbEndCustomer.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:682 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0013_CustPsiUpload.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9ef53bd | this.clbTeam.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:667 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-64a66d8a | this.clbTeam.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:667 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b319045 | this.clbTeam.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:668 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4fba93dd | this.clbTeam.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:672 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b718ea6d | this.clbTeam.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:672 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d4058ad | this.clbTeam.SelectedIndexChanged | DMF0013_CustPsiUpload.cs:673 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0013_CustPsiUpload.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6dec9a4 | this.Load | DMF0013_CustPsiUpload.cs:207 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3919803d | this.Load | DMF0013_CustPsiUpload.cs:208 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-07ce73c0 | this.Load | DMF0013_CustPsiUpload.cs:209 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e42f13f | this.Load | DMF0013_CustPsiUpload.cs:212 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-960a307e | this.Load | DMF0013_CustPsiUpload.cs:213 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-73827ed3 | this.Load | DMF0013_CustPsiUpload.cs:214 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-358e2a87 | this.Load | DMF0013_CustPsiUpload.cs:215 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-ded329cd | this.Load | DMF0013_CustPsiUpload.cs:216 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-6f060b6b | this.Load | DMF0013_CustPsiUpload.cs:220 |  | GRID_INIT | siMain.ColumnHeaderHeight | (0, 30) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-205f7280 | this.Load | DMF0013_CustPsiUpload.cs:221 |  | GRID_INIT | siMain.ColumnHeaderHeight | (1, 35) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0013_CustPsiUpload.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70aaeebe | this.Load | DMF0013_CustPsiUpload.cs:196 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-c9a3481b | this.Load | DMF0013_CustPsiUpload.cs:200 | if (UserInfoContext.Current["NowGroupID"].IndexOf("Viewer") >= 0) | STATE | btnExcelUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-87f34164 | this.Load | DMF0013_CustPsiUpload.cs:201 | if (UserInfoContext.Current["NowGroupID"].IndexOf("Viewer") >= 0) | STATE | btnExcelUpload.Visible | false | 컨트롤 상태 Visible |  |  |  |

## DMF0013_CustPsiUpload.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e066fe8f | DeleteButton | DMF0013_CustPsiUpload.cs:343 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0013_CustPsiUpload.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7843635f | Dispose | DMF0013_CustPsiUpload.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0013_CustPsiUpload.drpPeriod_ValueChanged

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25a85c34 | drpPeriod.ValueChanged | DMF0013_CustPsiUpload.cs:743 | if (dtFrom > dtTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e247c67d | drpPeriod.ValueChanged | DMF0013_CustPsiUpload.cs:745 | if (dtFrom > dtTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-145b1338 | EditButton | DMF0013_CustPsiUpload.cs:351 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-854a9bf2 | EditButton | DMF0013_CustPsiUpload.cs:352 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-937b31fb | EditButton | DMF0013_CustPsiUpload.cs:359 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DivisionId), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-107d9c61 | EditButton | DMF0013_CustPsiUpload.cs:363 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).T… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0013_CustPsiUpload.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59a511f0 | ExcelButton | DMF0013_CustPsiUpload.cs:377 |  | EXCEL | base.ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## DMF0013_CustPsiUpload.FindData

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c9115d1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:390 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a910b319 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:398 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41dd83d3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:400 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78b636e7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:403 | try | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, clb… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-09562c24 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:403 | try | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, clbScmSite.Con… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-da7a1c3b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:409 | try ▸ if (int.Parse(sDate[0]) > int.Parse(sDate[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c5f0fd8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:410 | try ▸ if (int.Parse(sDate[0]) > int.Parse(sDate[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2675e0c4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:415 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e6c1040 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:417 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-f6b08d46 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:419 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f7a83f4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:422 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-72e5e4fa | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:433 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA") ⇒ DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-4f394ca1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:435 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-bcb62dbd | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:436 | try | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-886d6626 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:437 | try | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-6549d63c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:438 | try | DATA_OP | request.Parameters["p_scm_site_id"] | clbScmSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-53a09c4d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:439 | try | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-68fafb28 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:440 | try | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-3b4d8927 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:441 | try | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-355a4204 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:442 | try | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sDate[0].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b6580fbf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:443 | try | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sDate[1].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5da5663f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:444 | try | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-37d6dd9d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:445 | try | DATA_OP | request.Parameters["p_dom_exp"] | clbDomExp.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a502d773 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:446 | try | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-03f4b80a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:448 | try | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-126a0578 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:450 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95692da5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:452 | try | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-05870445 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:458 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3ea74270 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:460 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-47a2fe0f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:461 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-401ff3e3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:463 | try | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f2029675 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:472 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8260854 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:476 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7d603362 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0013_CustPsiUpload.cs:478 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0013_CustPsiUpload.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33be8555 | this.Load | DMF0013_CustPsiUpload.cs:141 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b117ed9 | this.Load | DMF0013_CustPsiUpload.cs:142 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0013_CustPsiUpload.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2398e07c | this.Load | DMF0013_CustPsiUpload.cs:994 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-b7b51974 | this.Load | DMF0013_CustPsiUpload.cs:995 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c0e57c6e | this.Load | DMF0013_CustPsiUpload.cs:996 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-045fad6a | this.Load | DMF0013_CustPsiUpload.cs:998 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-37bf9ee1 | this.Load | DMF0013_CustPsiUpload.cs:1001 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e65d1850 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1025 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c0c600d5 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1027 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8e2480d | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1030 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21a3ed6f | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1053 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c5667d10 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1054 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2c5538f8 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1055 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-dcda53d0 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1056 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-624de96b | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1059 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-366c1502 | this.Load | DMF0013_CustPsiUpload.cs:1100 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-4238a9b3 | this.Load | DMF0013_CustPsiUpload.cs:1101 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-c24d21f1 | this.Load | DMF0013_CustPsiUpload.cs:1102 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9bd04234 | this.Load | DMF0013_CustPsiUpload.cs:1105 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.GetPlantSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57d04091 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1084 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-07d87d33 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1085 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b5c7bf5a | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1086 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-27e87781 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1087 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-f6e13687 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1088 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11b2fb9e | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1091 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ad1e9ef | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1068 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-ddcd9cdf | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1069 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6bc0b8c0 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1070 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9bc0b0a7 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1071 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-0f4ded5f | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1072 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0679ef7d | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1075 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.GetSpdTitle

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-313e76ac | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:1010 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0014_GET_SPREAD_TITLE") ⇒ DM.DMF0014_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-e4c79db5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:1011 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sDate[0] | 행/컬럼 값 대입 |  |  |  |
| AC-7b71870e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:1012 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sDate[1] | 행/컬럼 값 대입 |  |  |  |
| AC-8e740f30 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:1013 |  | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a919e44f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:1015 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4d33e04a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:1015 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0013_CustPsiUpload.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de9c788d | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1039 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-dfd8a58d | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1040 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e6e2123a | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1041 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4faae848 | (진입점 미연결) | DMF0013_CustPsiUpload.cs:1044 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa687058 | this.Load | DMF0013_CustPsiUpload.cs:153 |  | FLAG | dtSprDivision | Data.Common(Data.Type.Division, false) ⇒ biz:CommonData.CommonDataList [code=Division] | 화면 필드/플래그 변경 |  |  |  |
| AC-d2856558 | this.Load | DMF0013_CustPsiUpload.cs:153 |  | COMBO_DATA | Data.Common | (Data.Type.Division, false) ⇒ biz:CommonData.CommonDataList [code=Division] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c725e947 | this.Load | DMF0013_CustPsiUpload.cs:155 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-6237fe78 | this.Load | DMF0013_CustPsiUpload.cs:155 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-349d5be3 | this.Load | DMF0013_CustPsiUpload.cs:156 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-490ade61 | this.Load | DMF0013_CustPsiUpload.cs:160 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-63bc0b63 | this.Load | DMF0013_CustPsiUpload.cs:160 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9ba3bba | this.Load | DMF0013_CustPsiUpload.cs:161 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d68e90f2 | this.Load | DMF0013_CustPsiUpload.cs:165 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-fa35f86c | this.Load | DMF0013_CustPsiUpload.cs:165 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cabb6a06 | this.Load | DMF0013_CustPsiUpload.cs:166 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-138d4bf1 | this.Load | DMF0013_CustPsiUpload.cs:170 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-2fac832c | this.Load | DMF0013_CustPsiUpload.cs:170 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6740b9d | this.Load | DMF0013_CustPsiUpload.cs:171 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1a7a5300 | this.Load | DMF0013_CustPsiUpload.cs:173 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-d775f8e3 | this.Load | DMF0013_CustPsiUpload.cs:173 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6434202 | this.Load | DMF0013_CustPsiUpload.cs:174 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1fd7390d | this.Load | DMF0013_CustPsiUpload.cs:176 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-59f5abe7 | this.Load | DMF0013_CustPsiUpload.cs:178 |  | FLAG | dtBucketType | GetLookupValues("BUCKET_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-f5d74c31 | this.Load | DMF0013_CustPsiUpload.cs:179 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-afbe08ae | this.Load | DMF0013_CustPsiUpload.cs:181 |  | FLAG | dtDomExp | Data.Common(Data.Type.DOM_EXP) ⇒ biz:CommonData.CommonDataList [code=DOM_EXP] | 화면 필드/플래그 변경 |  |  |  |
| AC-9cc0b15f | this.Load | DMF0013_CustPsiUpload.cs:181 |  | COMBO_DATA | Data.Common | (Data.Type.DOM_EXP) ⇒ biz:CommonData.CommonDataList [code=DOM_EXP] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28db616a | this.Load | DMF0013_CustPsiUpload.cs:182 |  | LIST_REBIND | clsCtrl.setListBox | (dtDomExp, clbDomExp, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-728fed91 | this.Load | DMF0013_CustPsiUpload.cs:184 |  | FLAG | dtIncoterms | GetLookupValues("INCOTERMS") | 화면 필드/플래그 변경 |  |  |  |
| AC-bdf1f441 | this.Load | DMF0013_CustPsiUpload.cs:185 |  | FLAG | dtSalesType | GetLookupValues("SALES_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-564ef4c9 | this.Load | DMF0013_CustPsiUpload.cs:186 |  | FLAG | dtUploadUOM | GetLookupValues("UPLOAD_UOM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-19332058 | this.Load | DMF0013_CustPsiUpload.cs:189 |  | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, clbDivision.ControlValues, clbEndCustomer.Co… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-1e6fe773 | this.Load | DMF0013_CustPsiUpload.cs:189 |  | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, clbDivision.ControlValues, clbEndCustomer.ControlValues… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0013_CustPsiUpload.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05ba2de3 | this.Load | DMF0013_CustPsiUpload.cs:308 |  | FLAG | dtSave | new DataTable("CustFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-3940630f | this.Load | DMF0013_CustPsiUpload.cs:309 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DivisionId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-25d009df | this.Load | DMF0013_CustPsiUpload.cs:310 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19f1a351 | this.Load | DMF0013_CustPsiUpload.cs:311 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerProject, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-35275448 | this.Load | DMF0013_CustPsiUpload.cs:312 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerModel, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a684d9b8 | this.Load | DMF0013_CustPsiUpload.cs:313 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-95b93494 | this.Load | DMF0013_CustPsiUpload.cs:314 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfbbe15b | this.Load | DMF0013_CustPsiUpload.cs:315 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d16880ba | this.Load | DMF0013_CustPsiUpload.cs:316 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MeasureGroup, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac89b7ef | this.Load | DMF0013_CustPsiUpload.cs:317 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-59643f1e | this.Load | DMF0013_CustPsiUpload.cs:318 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlantSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe5847a3 | this.Load | DMF0013_CustPsiUpload.cs:319 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UploadUOM, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-db76b674 | this.Load | DMF0013_CustPsiUpload.cs:320 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ProjectCode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b50a5e60 | this.Load | DMF0013_CustPsiUpload.cs:321 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0ad0f7c | this.Load | DMF0013_CustPsiUpload.cs:322 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ff8c414 | this.Load | DMF0013_CustPsiUpload.cs:323 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0013_CustPsiUpload.InitSpread

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e982051a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:226 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a46ec5ee | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:228 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ccc2090b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:229 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.DivisionId, DefColumns.DivisionId, FPMerge.Restricted, 60, true, dtSprDiv… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2564c89d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:230 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.ScmSite, DefColumns.ScmSite, FPMerge.Restricted, 60, true, dtScmSite, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2bed835 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:231 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.PlantSite, DefColumns.PlantSite, FPMerge.Restricted, 60, true, dtPlantSit… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e33c36c2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:232 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.CustomerProject, DefColumns.CustomerProject, FPMerge.Restricted, 60, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-151ea05c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:233 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.CustomerModel, DefColumns.CustomerModel, FPMerge.Restricted, 60, true, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-06a31c24 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:234 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.Incoterms, DefColumns.Incoterms, FPMerge.Restricted, 40, true, dtIncoterm… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c24f3c1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:235 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.FcstType, DefColumns.FcstType, FPMerge.Restricted, 40, true, dtSalesType,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a75d138 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:236 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.DomExp, DefColumns.DomExp, FPMerge.Restricted, 60, true, dtDomExp, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc0bd358 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:237 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.MeasureGroup, DefColumns.MeasureGroup, FPMerge.Restricted, 60, true, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a787535d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:238 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.Measure, DefColumns.Measure, FPMerge.Restricted, 40, true, dtMeasure, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9bf2c421 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:239 |  | GRID_INIT | siMain.AddComboColumn | (DefColumnsLabel.UploadUOM, DefColumns.UploadUOM, FPMerge.Restricted, 40, true, dtUploadUO… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-025b96b0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:240 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ProjectCode, DefColumns.ProjectCode, FPMerge.Restricted, 80, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-544a9a3c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:241 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ItemId, DefColumns.ItemId, FPMerge.Restricted, 100, true, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7e97d16 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:242 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.EditFlag, DefColumns.EditFlag, FPMerge.Restricted, 0, true, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-326405a1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:244 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(CAppSetting.StringAction), 2, 1, 30, "A", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9625480 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:245 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DivisionId), 2, 1, 30, DefColumnsLabel.DivisionId, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98d75196 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:246 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ScmSite), 2, 1, 30, DefColumnsLabel.ScmSite, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b46a80c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:247 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.PlantSite), 2, 1, 30, DefColumnsLabel.PlantSite, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53945227 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:248 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.CustomerProject), 2, 1, 30, DefColumnsLabel.CustomerP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a315ec3b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:249 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.CustomerModel), 2, 1, 30, DefColumnsLabel.CustomerMod… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f2ec907 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:250 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Incoterms), 2, 1, 30, DefColumnsLabel.Incoterms, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9408fef8 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:251 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FcstType), 2, 1, 30, DefColumnsLabel.FcstType, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6f8c4bd | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:252 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DomExp), 2, 1, 30, DefColumnsLabel.DomExp, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7ba9499 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:253 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.MeasureGroup), 2, 1, 30, DefColumnsLabel.MeasureGroup… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ec918a9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:254 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.Measure), 2, 1, 30, DefColumnsLabel.Measure, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e346caa | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:255 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.UploadUOM), 2, 1, 30, DefColumnsLabel.UploadUOM, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c839b033 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:256 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ProjectCode), 2, 1, 30, DefColumnsLabel.ProjectCode, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c7d39ed | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:257 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ItemId), 2, 1, 30, DefColumnsLabel.ItemId, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f59ed420 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:258 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.EditFlag), 2, 1, 30, DefColumnsLabel.EditFlag, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b5ef7bf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:269 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.EditFlag)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-33940b69 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:277 | foreach (DataRow dr in dtTitle.Rows) | GRID_INIT | siMain.AddNumTextColumn | (sColumnLabel, sColumnName, FPMerge.Restricted, 50, true, FPHAlign.Right, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5441665 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:281 | foreach (DataRow dr in dtTitle.Rows) ▸ if (sSpanLabelName != sSmallLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abc48273 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:290 | foreach (DataRow dr in dtTitle.Rows) ▸ if (sSmallLabelName == DefColumnsLabel.Saturday \|\| sSmallLabelName == DefColumnsLabel.Sunday) | GRID_SET | siMain.Sheet().ColumnHeader.Cells[0, siMain.GetMaxColumnIndex()].ForeColor | sSmallLabelName == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e5a3a2e1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0013_CustPsiUpload.cs:294 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0013_CustPsiUpload.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e790e03 | InsertButton | DMF0013_CustPsiUpload.cs:621 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-900ea7f5 | InsertButton | DMF0013_CustPsiUpload.cs:627 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DivisionId), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b9913211 | InsertButton | DMF0013_CustPsiUpload.cs:628 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f5e069a0 | InsertButton | DMF0013_CustPsiUpload.cs:629 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSite), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a461edd4 | InsertButton | DMF0013_CustPsiUpload.cs:631 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetText | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MeasureGroup), "PSI") | 그리드 값 설정 |  |  |  |
| AC-9b04d3cb | InsertButton | DMF0013_CustPsiUpload.cs:632 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MeasureGroup), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b9b70e5 | InsertButton | DMF0013_CustPsiUpload.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UploadUOM), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0013_CustPsiUpload.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1beed684 | SaveButton | DMF0013_CustPsiUpload.cs:565 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0013_SAVE_CUST_PSI_UPLOAD_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-d8818593 | SaveButton | DMF0013_CustPsiUpload.cs:566 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-82ac3ccf | SaveButton | DMF0013_CustPsiUpload.cs:567 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e404d054 | SaveButton | DMF0013_CustPsiUpload.cs:568 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-d03fe478 | SaveButton | DMF0013_CustPsiUpload.cs:569 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-0b9db220 | SaveButton | DMF0013_CustPsiUpload.cs:570 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_project_code"] | sCustomerProject | 행/컬럼 값 대입 |  |  |  |
| AC-a733ebe1 | SaveButton | DMF0013_CustPsiUpload.cs:571 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_model"] | sCustomerModel | 행/컬럼 값 대입 |  |  |  |
| AC-871320cd | SaveButton | DMF0013_CustPsiUpload.cs:572 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-b6c95915 | SaveButton | DMF0013_CustPsiUpload.cs:573 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-7df631aa | SaveButton | DMF0013_CustPsiUpload.cs:574 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp"] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-e88d45ad | SaveButton | DMF0013_CustPsiUpload.cs:575 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure_group"] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-76537c01 | SaveButton | DMF0013_CustPsiUpload.cs:576 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-a69bb99d | SaveButton | DMF0013_CustPsiUpload.cs:577 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_uom"] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-d1acac04 | SaveButton | DMF0013_CustPsiUpload.cs:578 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-c4762ca3 | SaveButton | DMF0013_CustPsiUpload.cs:579 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-46b423e7 | SaveButton | DMF0013_CustPsiUpload.cs:580 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-5a7ddf71 | SaveButton | DMF0013_CustPsiUpload.cs:581 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-0b0621b0 | SaveButton | DMF0013_CustPsiUpload.cs:582 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-88ef7f3e | SaveButton | DMF0013_CustPsiUpload.cs:584 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2b5444ba | SaveButton | DMF0013_CustPsiUpload.cs:588 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d40962d | SaveButton | DMF0013_CustPsiUpload.cs:593 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c29fa856 | SaveButton | DMF0013_CustPsiUpload.cs:600 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7623f29 | SaveButton | DMF0013_CustPsiUpload.cs:609 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00150") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0013_CustPsiUpload.SetSaveData

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6879c91b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:893 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cbbff9b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:897 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dec3ae6f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:898 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DivisionId] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-158326bb | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:899 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSite] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-42964fd8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:900 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerProject] | sCustomerProject | 행/컬럼 값 대입 |  |  |  |
| AC-6751925e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:901 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerModel] | sCustomerModel | 행/컬럼 값 대입 |  |  |  |
| AC-1d2b3992 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:902 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-887b336a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:903 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-c40b1a53 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:904 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-425f06b7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:905 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MeasureGroup] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-f9590e39 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:906 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-8c0716c3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:907 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlantSite] | sPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-68e13fd1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:908 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.UploadUOM] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-f847d014 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:909 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ProjectCode] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-c7d0a653 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:910 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-7ea431c7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:911 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-b08349de | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:912 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-3b393843 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:914 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-844f910c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:915 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6af711e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:919 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-f897de02 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0013_CustPsiUpload.cs:920 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0013_CustPsiUpload.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-209792ab | this.spdMain.CellDoubleClick | DMF0013_CustPsiUpload.cs:972 | if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0013_CustPsiUpload.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04622e37 | dsdm.Changed | DMF0013_CustPsiUpload.cs:787 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivision == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.DivisionId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-368eacba | dsdm.Changed | DMF0013_CustPsiUpload.cs:788 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivision == "… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.DivisionId)) | 그리드 표시 설정 |  |  |  |
| AC-f9bb12bf | dsdm.Changed | DMF0013_CustPsiUpload.cs:789 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivision == "… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-020e0359 | dsdm.Changed | DMF0013_CustPsiUpload.cs:794 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.ScmSite }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c4b3330 | dsdm.Changed | DMF0013_CustPsiUpload.cs:795 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite)) | 그리드 표시 설정 |  |  |  |
| AC-2397b07b | dsdm.Changed | DMF0013_CustPsiUpload.cs:796 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e39d68c | dsdm.Changed | DMF0013_CustPsiUpload.cs:800 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.CustomerProject }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-502bb274 | dsdm.Changed | DMF0013_CustPsiUpload.cs:801 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.CustomerProject)) | 그리드 표시 설정 |  |  |  |
| AC-e2f97988 | dsdm.Changed | DMF0013_CustPsiUpload.cs:802 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b393b997 | dsdm.Changed | DMF0013_CustPsiUpload.cs:806 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.CustomerModel }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e9a20e1 | dsdm.Changed | DMF0013_CustPsiUpload.cs:807 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.CustomerModel)) | 그리드 표시 설정 |  |  |  |
| AC-d8d875fc | dsdm.Changed | DMF0013_CustPsiUpload.cs:808 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd1ecc95 | dsdm.Changed | DMF0013_CustPsiUpload.cs:812 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d0938fe | dsdm.Changed | DMF0013_CustPsiUpload.cs:813 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)) | 그리드 표시 설정 |  |  |  |
| AC-18905fc4 | dsdm.Changed | DMF0013_CustPsiUpload.cs:814 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d806f635 | dsdm.Changed | DMF0013_CustPsiUpload.cs:818 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.FcstType }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6640486d | dsdm.Changed | DMF0013_CustPsiUpload.cs:819 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.FcstType)) | 그리드 표시 설정 |  |  |  |
| AC-08233170 | dsdm.Changed | DMF0013_CustPsiUpload.cs:820 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c60e7462 | dsdm.Changed | DMF0013_CustPsiUpload.cs:824 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.DomExp }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-394f74f4 | dsdm.Changed | DMF0013_CustPsiUpload.cs:825 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.DomExp)) | 그리드 표시 설정 |  |  |  |
| AC-d992eabe | dsdm.Changed | DMF0013_CustPsiUpload.cs:826 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38e11a8c | dsdm.Changed | DMF0013_CustPsiUpload.cs:830 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.MeasureGroup }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e74e587 | dsdm.Changed | DMF0013_CustPsiUpload.cs:831 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.MeasureGroup)) | 그리드 표시 설정 |  |  |  |
| AC-aa51c763 | dsdm.Changed | DMF0013_CustPsiUpload.cs:832 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89e29889 | dsdm.Changed | DMF0013_CustPsiUpload.cs:836 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.Measure }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05497d26 | dsdm.Changed | DMF0013_CustPsiUpload.cs:837 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.Measure)) | 그리드 표시 설정 |  |  |  |
| AC-ccab2535 | dsdm.Changed | DMF0013_CustPsiUpload.cs:838 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05e69b8f | dsdm.Changed | DMF0013_CustPsiUpload.cs:842 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.PlantSite }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac44b007 | dsdm.Changed | DMF0013_CustPsiUpload.cs:843 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite)) | 그리드 표시 설정 |  |  |  |
| AC-6fa30b64 | dsdm.Changed | DMF0013_CustPsiUpload.cs:844 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8d6d984a | dsdm.Changed | DMF0013_CustPsiUpload.cs:848 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnsLabel.UploadUOM }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c880b4aa | dsdm.Changed | DMF0013_CustPsiUpload.cs:849 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms)) | 그리드 표시 설정 |  |  |  |
| AC-6257fc9e | dsdm.Changed | DMF0013_CustPsiUpload.cs:850 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ else of (sDivision… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1edf35d0 | dsdm.Changed | DMF0013_CustPsiUpload.cs:868 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (e.Column … | COMBO_DATA | Data.Common | (Data.Type.CUST_FCST_UPLOAD_UOM, false, sDivisionId, sScmSiteId, sMeasureGroup, sMeasure, … ⇒ biz:CommonData.CommonDataList [code=CUST_FCST_UPLOAD_UOM] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-28297720 | dsdm.Changed | DMF0013_CustPsiUpload.cs:869 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (e.Column … | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.UploadUOM), sUploadUOM) | 그리드 값 설정 |  |  |  |

## DMF0013_CustPsiUpload.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e239ad1 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:940 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtScmSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-528d6b84 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:940 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, CAppSet… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c81efe82 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:942 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2dae7735 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:944 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb259837 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:944 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8cee8416 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:946 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a1aa6bec | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:950 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sSc… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-63ae4333 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:950 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sScmSite, cboB… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c175403 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:951 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-55f243c7 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:954 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), e.Row, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d1ac279 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:956 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ else of (sDivision != "81") | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSite), e.Row, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3d4ee38 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:963 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSite)) | FLAG | dtMeasure | Data.Common(Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sSc… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-34c1e982 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:963 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSite)) | COMBO_DATA | Data.Common | (Data.Type.CustomerMeasure, false, sDivision, clbEndCustomer.ControlValues, sScmSite, cboB… ⇒ biz:CommonData.CommonDataList [code=CustomerMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fba4aea7 | this.spdMain.ComboSelChange | DMF0013_CustPsiUpload.cs:964 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ScmSite)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

