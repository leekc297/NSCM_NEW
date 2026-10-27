# AS-IS 액션 대조표 — DM0006

> 원천: `Doc/asisfacts/screens/DM0006/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 726행 · 메서드 59 · 종류 DATA_OP 207 · ENDPOINT 69 · GRID_LOCK 59 · FLAG 58 · GRID_INIT 49 · GRID_SET 49 · RETURN 47 · UI_PROP 32 · POPUP 27 · COMBO_DATA 21 · CALL_EXT 19 · VALUE_SET 16 · MESSAGE 16 · LIST_REBIND 15 · GRID_COMBO 15 · UI_MISC 11 · GRID_BIND 7 · THROW 4 · STATE_RESET 3 · GRID_STYLE 2 · ⚠ 의미 확인 필요 19


## DM0006_CustomerModelMapping.btnModelType_Click

진입점: this.btnModelType.Click / this.umltModel.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3917cb6b | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:785 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-af3e6511 | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:787 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c3dcdf40 | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:788 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6ecff330 | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:789 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b0871643 | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:791 |  | VALUE_SET | umltModel.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |
| AC-bd8fbab3 | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:854 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-84352189 | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:856 |  | POPUP | popItem.Form_Load | (true, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-113ac23d | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:857 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8497905e | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:858 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-06af3cec | this.btnModelType.Click 외 1 | DM0006_CustomerModelMapping.cs:864 |  | VALUE_SET | umltModel.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DM0006_CustomerModelMapping.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem6.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-566f74d6 | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:803 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-dfcf6f4e | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:804 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-cd078f1b | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:805 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-12ba4c42 | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:806 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4f2b03d0 | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:808 |  | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |
| AC-074b56bf | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:878 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dd79aaa1 | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:879 |  | POPUP | popProject.Form_Load | (true, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-40edae32 | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:880 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18ef8442 | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:881 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-57fb2f12 | this.btnProject.Click 외 2 | DM0006_CustomerModelMapping.cs:888 |  | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0006_CustomerModelMapping.clbDivision_SelectedIndexChanged

진입점: this.clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af031f17 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:822 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9d28af0 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:825 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c40c7fe7 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:838 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-299eede4 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:838 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66ad0f6e | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:839 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-39b49ed1 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:843 | try | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-de3a1581 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:843 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3dc4450 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:844 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-17d8a968 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:848 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7845878c | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:848 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-075d0646 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:849 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e75d4968 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:861 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6e844658 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:862 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-160fb45c | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:866 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4765978f | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:900 |  | FLAG | dtSalesSite | GetScmSitebyDivision(clbDivisions.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c763c7d7 | this.clbDivisions.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:901 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0006_CustomerModelMapping.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87486ce8 | this.clbEndCustomer.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1354 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f3b8fb91 | this.clbEndCustomer.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1354 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc98ea65 | this.clbEndCustomer.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1355 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0006_CustomerModelMapping.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1628cf2 | this.clbTeam.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1426 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bf739abe | this.clbTeam.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1426 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-570bee96 | this.clbTeam.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1427 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3434a437 | this.clbTeam.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1431 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-db54446b | this.clbTeam.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1431 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b7aa448c | this.clbTeam.SelectedIndexChanged | DM0006_CustomerModelMapping.cs:1432 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0006_CustomerModelMapping.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5a540f7 | this.Load | DM0006_CustomerModelMapping.cs:201 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1897b4cf | this.Load | DM0006_CustomerModelMapping.cs:202 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-80fa6ffc | this.Load | DM0006_CustomerModelMapping.cs:203 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-566acbc4 | this.Load | DM0006_CustomerModelMapping.cs:208 |  | FLAG | dsdm | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Dat… | 화면 필드/플래그 변경 |  |  |  |
| AC-39b2d2f8 | this.Load | DM0006_CustomerModelMapping.cs:164 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3e601d2a | this.Load | DM0006_CustomerModelMapping.cs:165 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4af4223b | this.Load | DM0006_CustomerModelMapping.cs:166 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0006_CustomerModelMapping.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aebe50c7 | this.Load | DM0006_CustomerModelMapping.cs:167 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-b397c845 | this.Load | DM0006_CustomerModelMapping.cs:169 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-c30749a0 | this.Load | DM0006_CustomerModelMapping.cs:171 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d1e90bd9 | this.Load | DM0006_CustomerModelMapping.cs:172 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-7087647a | this.Load | DM0006_CustomerModelMapping.cs:173 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-a3781821 | this.Load | DM0006_CustomerModelMapping.cs:174 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0006_CustomerModelMapping.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-580f484d | DeleteButton | DM0006_CustomerModelMapping.cs:278 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-85c2343c | DeleteButton | DM0006_CustomerModelMapping.cs:235 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0006_CustomerModelMapping.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44c87190 | Dispose | DM0006_CustomerModelMapping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-d542fc9a | Dispose | DM0006_CustomerModelMapping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0006_CustomerModelMapping.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ea80087 | dsdm.Changed | DM0006_CustomerModelMapping.cs:1461 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd79584f | dsdm.Changed | DM0006_CustomerModelMapping.cs:1466 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efa42fc7 | dsdm.Changed | DM0006_CustomerModelMapping.cs:1467 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32a6c9b9 | dsdm.Changed | DM0006_CustomerModelMapping.cs:1468 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90581104 | dsdm.Changed | DM0006_CustomerModelMapping.cs:1483 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.CONVERT_QT… | GRID_SET | siMain.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-53b3901b | dsdm.Changed | DM0006_CustomerModelMapping.cs:1495 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DM0006_CustomerModelMapping.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-618955dc | EditButton | DM0006_CustomerModelMapping.cs:285 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9e6382a | EditButton | DM0006_CustomerModelMapping.cs:286 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-52d6b268 | EditButton | DM0006_CustomerModelMapping.cs:289 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.SCM_SITE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38f35930 | EditButton | DM0006_CustomerModelMapping.cs:290 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.GetColumnIndex(DefColumns.CUSTOMER… | 그리드 편집 잠금/해제 |  |  |  |
| AC-76dd526d | EditButton | DM0006_CustomerModelMapping.cs:291 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.GetColumnIndex(DefColumns.CAPAC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22b8fbc5 | EditButton | DM0006_CustomerModelMapping.cs:292 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetColumnIndex(DefColumns.LAST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b77cc02 | EditButton | DM0006_CustomerModelMapping.cs:293 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.LAST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a203f1f4 | EditButton | DM0006_CustomerModelMapping.cs:304 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), i, siMain.GetColumnIndex(DefColumns.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abefe3b4 | EditButton | DM0006_CustomerModelMapping.cs:305 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), i, siMain.GetColumnIndex(DefColumns.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1de59864 | EditButton | DM0006_CustomerModelMapping.cs:306 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID), i, siMain.GetColumnIndex(DefColumns.ITEM_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-37e8400a | EditButton | DM0006_CustomerModelMapping.cs:307 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-240db368 | EditButton | DM0006_CustomerModelMapping.cs:308 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), i, siMain.GetColumnIndex(DefColumns.ITEM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd4aead2 | EditButton | DM0006_CustomerModelMapping.cs:309 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CAPACITY), i, siMain.GetColumnIndex(DefColumns.CAPACI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d710b36 | EditButton | DM0006_CustomerModelMapping.cs:310 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-04676054 | EditButton | DM0006_CustomerModelMapping.cs:311 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c17c12d8 | EditButton | DM0006_CustomerModelMapping.cs:318 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).To… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-69652741 | EditButton | DM0006_CustomerModelMapping.cs:328 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).To… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01a52adb | EditButton | DM0006_CustomerModelMapping.cs:329 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).To… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), i, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3dfae6d9 | EditButton | DM0006_CustomerModelMapping.cs:336 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (AUTHORITY_YN == "N") | GRID_LOCK | siMain.LockRange | (i, 0, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-869958ec | EditButton | DM0006_CustomerModelMapping.cs:242 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4b35ba8 | EditButton | DM0006_CustomerModelMapping.cs:243 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1d14eee0 | EditButton | DM0006_CustomerModelMapping.cs:246 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad69a2dc | EditButton | DM0006_CustomerModelMapping.cs:247 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CUSTOMER_PROJECT_CODE), siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5371d778 | EditButton | DM0006_CustomerModelMapping.cs:248 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL), siMain.GetColumnIndex(DefColumns.CUSTOM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ee5fc01 | EditButton | DM0006_CustomerModelMapping.cs:249 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), siMain.GetColumnIndex(DefColumns.SCM_SITE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61f22cbd | EditButton | DM0006_CustomerModelMapping.cs:251 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.GetColumnIndex(DefColumns.PROJECT_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b72eced1 | EditButton | DM0006_CustomerModelMapping.cs:252 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_ID), siMain.GetColumnIndex(DefColumns.ITEM_ID), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db4828b1 | EditButton | DM0006_CustomerModelMapping.cs:253 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CAPACITY), siMain.GetColumnIndex(DefColumns.CAPACITY), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cf24d95b | EditButton | DM0006_CustomerModelMapping.cs:254 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetColumnIndex(DefColumns.LAST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2801d27a | EditButton | DM0006_CustomerModelMapping.cs:255 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.LAST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6dea806e | EditButton | DM0006_CustomerModelMapping.cs:257 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), siMain.GetColumnIndex(DefColumns.END_CUST… | 그리드 편집 잠금/해제 |  |  |  |

## DM0006_CustomerModelMapping.FindData

진입점: FindButton / SaveButton [try ▸ if (sRMSG.Trim() == "success") ▸ if (blnInsert)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b0594eb | FindButton 외 2 | DM0006_CustomerModelMapping.cs:368 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-608f8d10 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:369 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58be651b | FindButton 외 2 | DM0006_CustomerModelMapping.cs:372 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e8f37cc3 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:389 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8106e64a | FindButton 외 2 | DM0006_CustomerModelMapping.cs:390 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4e59f7b | FindButton 외 2 | DM0006_CustomerModelMapping.cs:395 | try | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-deae3ae7 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:400 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76addd48 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:404 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA") ⇒ DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-653e73ad | FindButton 외 2 | DM0006_CustomerModelMapping.cs:406 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2ec8431 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:407 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-1a9a3d05 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:408 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f3275829 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:409 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1467378 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:410 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-de0fcaa5 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:411 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-e8476078 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:412 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_project_code"] | p_customer_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-551694f3 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:413 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model"] | p_customer_model | 행/컬럼 값 대입 |  |  |  |
| AC-97c53ca0 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:414 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-04538920 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:415 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-24c7f872 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:416 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-448cd7c8 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:417 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0ca1d87b | FindButton 외 2 | DM0006_CustomerModelMapping.cs:419 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2e911965 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:438 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-251eaa98 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:439 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e42e265c | FindButton 외 2 | DM0006_CustomerModelMapping.cs:442 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7226dfa | FindButton 외 2 | DM0006_CustomerModelMapping.cs:449 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-708aa92a | FindButton 외 2 | DM0006_CustomerModelMapping.cs:454 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-e8d9494f | FindButton 외 2 | DM0006_CustomerModelMapping.cs:458 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((iRow % 100) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-3852ba47 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:470 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-e184efe4 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:471 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6606443 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:476 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-832b4dfd | FindButton 외 2 | DM0006_CustomerModelMapping.cs:480 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0b0fc6ac | FindButton 외 2 | DM0006_CustomerModelMapping.cs:481 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-7777d3b9 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:485 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6883c926 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:294 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Mst.WSL/FoxDataService.svc… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-670432b6 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:306 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA") ⇒ DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-f29847a3 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:307 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1944e91 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:308 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-098983cd | FindButton 외 2 | DM0006_CustomerModelMapping.cs:309 | lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-8b87177e | FindButton 외 2 | DM0006_CustomerModelMapping.cs:310 | lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6c040d36 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:311 | lambda | DATA_OP | request.Parameters["p_customer_project_code"] | p_customer_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-ba5a23bf | FindButton 외 2 | DM0006_CustomerModelMapping.cs:312 | lambda | DATA_OP | request.Parameters["p_customer_model"] | p_customer_model | 행/컬럼 값 대입 |  |  |  |
| AC-d18613eb | FindButton 외 2 | DM0006_CustomerModelMapping.cs:313 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-af89fb45 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:315 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d86100f9 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:319 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-60987b68 | FindButton 외 2 | DM0006_CustomerModelMapping.cs:320 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DM0006_CustomerModelMapping.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cd94ea8 | this.Load | DM0006_CustomerModelMapping.cs:124 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b38ea36 | this.Load | DM0006_CustomerModelMapping.cs:125 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d6357141 | this.Load | DM0006_CustomerModelMapping.cs:100 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5572afcf | this.Load | DM0006_CustomerModelMapping.cs:101 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0006_CustomerModelMapping.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ad8e8fa | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1381 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-342be03b | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1382 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d7c3f99e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1383 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-d031460e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1384 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6f79a48 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1387 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4b74cce | this.Load | DM0006_CustomerModelMapping.cs:1263 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-351063c1 | this.Load | DM0006_CustomerModelMapping.cs:1265 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d99884da | this.Load | DM0006_CustomerModelMapping.cs:1268 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-415b7f81 | this.Load | DM0006_CustomerModelMapping.cs:130 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-bc494efd | this.Load | DM0006_CustomerModelMapping.cs:132 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d67a847c | this.Load | DM0006_CustomerModelMapping.cs:135 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29245409 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1322 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-410c8fb6 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1323 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ed26fb97 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1324 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-a6c6f821 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1325 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-93382f9f | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1328 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetLookupValues

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8131a5d2 | this.Load | DM0006_CustomerModelMapping.cs:1337 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-5ba612ae | this.Load | DM0006_CustomerModelMapping.cs:1338 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-769c09ef | this.Load | DM0006_CustomerModelMapping.cs:1339 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-646bc527 | this.Load | DM0006_CustomerModelMapping.cs:1342 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))] / this.clbDivisions.SelectedIndexChanged / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e66f09f0 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:1277 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5537a5c6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:1278 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e1aaa3da | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:1279 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-bafc64be | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:1280 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-3efc8bf8 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:1281 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ef16302 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:1284 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-e394ebcd | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:144 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-abd240df | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:145 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2b817d4a | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:146 |  | DATA_OP | request.Parameters["p_dept_id"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-dfba82f6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:147 |  | DATA_OP | request.Parameters["p_end_customer"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-a8bc32c7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:148 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd341db1 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0006_CustomerModelMapping.cs:151 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f968d9a | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1403 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3f199ae4 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1404 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2577a2bf | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1405 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e324d13b | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1406 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-72d43b8b | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1407 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-271724e5 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1410 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetScmSiteInfobyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af333384 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1293 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-48626372 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1294 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8edd6ce5 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1295 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-06655da2 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1296 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2955f400 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1299 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetSpdTitle

진입점: this.Load / FindButton / SaveButton [try ▸ if (sRMSG.Trim() == "success") ▸ if (blnInsert)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5b9bdac | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1362 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-3fc4b3bf | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1363 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6a55ca57 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1364 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-35e8bd76 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1365 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-99d719ec | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1366 |  | DATA_OP | request.Parameters["p_program_id"] | "DM0006" | 행/컬럼 값 대입 |  |  |  |
| AC-b54418e0 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1367 |  | DATA_OP | request.Parameters["p_sheet_name"] | "Customer Model Mapping" | 행/컬럼 값 대입 |  |  |  |
| AC-6cbb57e8 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1369 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-474262e9 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1369 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ff4ecc38 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:1372 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e2f19da | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1308 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-719055c5 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1309 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-464ec75b | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1310 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f47dfca | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1313 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23d0f810 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1441 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-59d32539 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1442 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-71c548a9 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1443 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-434573f5 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:1450 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e28d3cf | this.Load | DM0006_CustomerModelMapping.cs:134 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bc03ee12 | this.Load | DM0006_CustomerModelMapping.cs:136 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9c8b79f6 | this.Load | DM0006_CustomerModelMapping.cs:136 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40075033 | this.Load | DM0006_CustomerModelMapping.cs:137 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d262891d | this.Load | DM0006_CustomerModelMapping.cs:138 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-ef0885ef | this.Load | DM0006_CustomerModelMapping.cs:140 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-719d2c96 | this.Load | DM0006_CustomerModelMapping.cs:140 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4d329cc | this.Load | DM0006_CustomerModelMapping.cs:142 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4d877146 | this.Load | DM0006_CustomerModelMapping.cs:144 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bd9deb04 | this.Load | DM0006_CustomerModelMapping.cs:144 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70f9ce68 | this.Load | DM0006_CustomerModelMapping.cs:146 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c4432c0 | this.Load | DM0006_CustomerModelMapping.cs:149 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bba2ce48 | this.Load | DM0006_CustomerModelMapping.cs:149 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a3ccf28a | this.Load | DM0006_CustomerModelMapping.cs:151 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ed2c5918 | this.Load | DM0006_CustomerModelMapping.cs:153 |  | FLAG | dtItemType | GetLookupValues("ITEM_TYPE_CODE") | 화면 필드/플래그 변경 |  |  |  |
| AC-bcb108a6 | this.Load | DM0006_CustomerModelMapping.cs:155 |  | FLAG | dtDepartment | Data.Common(Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoC… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 화면 필드/플래그 변경 |  |  |  |
| AC-4e27473b | this.Load | DM0006_CustomerModelMapping.cs:155 |  | COMBO_DATA | Data.Common | (Data.Type.UpperDeptId, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=UpperDeptId] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-877ed8a4 | this.Load | DM0006_CustomerModelMapping.cs:158 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true,"Y") | 목록 컨트롤 재구성 |  |  |  |
| AC-97b2dce7 | this.Load | DM0006_CustomerModelMapping.cs:113 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-aa2483f5 | this.Load | DM0006_CustomerModelMapping.cs:115 |  | FLAG | dtDivision | GetDivision() | 화면 필드/플래그 변경 |  |  |  |
| AC-94bee9d1 | this.Load | DM0006_CustomerModelMapping.cs:116 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8cb740cb | this.Load | DM0006_CustomerModelMapping.cs:117 |  | VALUE_SET | clbDivisions.ControlValues | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-af6d1e99 | this.Load | DM0006_CustomerModelMapping.cs:119 |  | FLAG | dtSalesSite | GetScmSitebyDivision(clbDivisions.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d9682e7 | this.Load | DM0006_CustomerModelMapping.cs:120 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0006_CustomerModelMapping.InitSpread

진입점: this.Load / FindButton / SaveButton [try ▸ if (sRMSG.Trim() == "success") ▸ if (blnInsert)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdc8c8c2 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:216 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-3fbce791 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:174 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5ba60efd | this.Load 외 3 | DM0006_CustomerModelMapping.cs:176 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-498b6067 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:181 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID , FPMerge.None, 120, true, dtDivision, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b95c2053 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:186 |  | GRID_INIT | siMain.AddTextColumn | ("End Customer", DefColumns.END_CUSTOMER, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f164f73 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:187 |  | GRID_INIT | siMain.AddComboColumn | ("Site", DefColumns.SCM_SITE_ID , FPMerge.None, 120, true, dtSalesSite, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-514f13ae | this.Load 외 3 | DM0006_CustomerModelMapping.cs:189 |  | GRID_INIT | siMain.AddTextColumn | ("Project Code", DefColumns.PROJECT_CODE , FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f5a22c9 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:190 |  | GRID_INIT | siMain.AddTextColumn | ("Project", DefColumns.PROJECT_NAME , FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-801214d4 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:192 |  | GRID_INIT | siMain.AddTextColumn | ("Customer PJT", DefColumns.CUSTOMER_PROJECT_CODE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ef17c11 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:193 |  | GRID_INIT | siMain.AddTextColumn | ("Customer Model", DefColumns.CUSTOMER_MODEL, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0929f30 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:196 |  | GRID_INIT | siMain.AddTextColumn | ("Model", DefColumns.ITEM_ID , FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b198b9cc | this.Load 외 3 | DM0006_CustomerModelMapping.cs:197 |  | GRID_INIT | siMain.AddTextColumn | ("Model Type", DefColumns.ITEM_CLASS_NAME , FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63b87b49 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:199 |  | GRID_INIT | siMain.AddNumColumn | ("KW/h", DefColumns.CAPACITY , FPMerge.None, 120, true,true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7c26c56 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:201 |  | GRID_INIT | siMain.AddNumColumn | ("Convert Qty(Pack)", DefColumns.CONVERT_QTY_PACK , FPMerge.None, 200, true,true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac4a36f9 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:203 |  | GRID_INIT | siMain.AddNumColumn | ("Convert Qty(Module)", DefColumns.CONVERT_QTY_MODULE , FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3865b67 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:205 |  | GRID_INIT | siMain.AddNumColumn | ("Convert Qty(Cell)", DefColumns.CONVERT_QTY_CELL , FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-707e0de2 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:206 |  | GRID_INIT | siMain.AddComboColumn | ("Acvite", DefColumns.VALID_YN , FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90050a22 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:208 |  | GRID_INIT | siMain.AddTextColumn | ("Update Date", DefColumns.LAST_UPDATE_DATE , FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca1358ca | this.Load 외 3 | DM0006_CustomerModelMapping.cs:209 |  | GRID_INIT | siMain.AddTextColumn | ("Update User", DefColumns.LAST_UPDATED_BY , FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0006_CustomerModelMapping.InitSpread_X

진입점: this.Load / FindButton / SaveButton [try ▸ if (sRMSG.Trim() == "success") ▸ if (blnInsert)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e79181f | this.Load 외 3 | DM0006_CustomerModelMapping.cs:250 |  | GRID_STYLE | siMain.SetColumnMerge | (siMain.GetColumnIndex(DefColumns.PROJECT_CODE), FPMerge.None) | 그리드 표시 설정 |  |  |  |
| AC-57d52d69 | this.Load 외 3 | DM0006_CustomerModelMapping.cs:252 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0006_CustomerModelMapping.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a4ddd0a | InsertButton | DM0006_CustomerModelMapping.cs:714 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a4522a0f | InsertButton | DM0006_CustomerModelMapping.cs:717 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-162675e6 | InsertButton | DM0006_CustomerModelMapping.cs:718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-30040e7c | InsertButton | DM0006_CustomerModelMapping.cs:720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-47d4cb45 | InsertButton | DM0006_CustomerModelMapping.cs:722 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47eb370f | InsertButton | DM0006_CustomerModelMapping.cs:723 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6fda1147 | InsertButton | DM0006_CustomerModelMapping.cs:724 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a645efb | InsertButton | DM0006_CustomerModelMapping.cs:725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-031b282b | InsertButton | DM0006_CustomerModelMapping.cs:726 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3cd1a5ed | InsertButton | DM0006_CustomerModelMapping.cs:727 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-10f38311 | InsertButton | DM0006_CustomerModelMapping.cs:736 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-92af65bd | InsertButton | DM0006_CustomerModelMapping.cs:737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5b392aa8 | InsertButton | DM0006_CustomerModelMapping.cs:738 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5887fde | InsertButton | DM0006_CustomerModelMapping.cs:739 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff0ed38e | InsertButton | DM0006_CustomerModelMapping.cs:740 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d200654 | InsertButton | DM0006_CustomerModelMapping.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CAPACITY), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a171d5ef | InsertButton | DM0006_CustomerModelMapping.cs:742 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5d67eadd | InsertButton | DM0006_CustomerModelMapping.cs:743 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c81f7dc1 | InsertButton | DM0006_CustomerModelMapping.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_PACK, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d33d7b0 | InsertButton | DM0006_CustomerModelMapping.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_MODULE, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-a07633cd | InsertButton | DM0006_CustomerModelMapping.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_CELL, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-09e70ccd | InsertButton | DM0006_CustomerModelMapping.cs:752 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CAPACITY, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-893b63b2 | InsertButton | DM0006_CustomerModelMapping.cs:753 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f45a1f1 | InsertButton | DM0006_CustomerModelMapping.cs:754 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LAST_UPDATED_BY, base.UserInfo.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-d00acd54 | InsertButton | DM0006_CustomerModelMapping.cs:755 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LAST_UPDATE_DATE, System.DateTime.Now.ToString("yyyy-MM-dd hh:ss")) | 데이터 객체 조작/조회 |  |  |  |
| AC-00a7e3dc | InsertButton | DM0006_CustomerModelMapping.cs:758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7085b71e | InsertButton | DM0006_CustomerModelMapping.cs:797 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dd733cf4 | InsertButton | DM0006_CustomerModelMapping.cs:806 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-85ae0700 | InsertButton | DM0006_CustomerModelMapping.cs:807 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_ID), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-13815592 | InsertButton | DM0006_CustomerModelMapping.cs:808 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CAPACITY), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-40bb28c6 | InsertButton | DM0006_CustomerModelMapping.cs:809 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-26bfdacf | InsertButton | DM0006_CustomerModelMapping.cs:810 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-14913555 | InsertButton | DM0006_CustomerModelMapping.cs:812 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4478e0ed | InsertButton | DM0006_CustomerModelMapping.cs:815 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_PACK, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-802157b8 | InsertButton | DM0006_CustomerModelMapping.cs:816 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_MODULE, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff87371a | InsertButton | DM0006_CustomerModelMapping.cs:817 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_CELL, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3eb6742 | InsertButton | DM0006_CustomerModelMapping.cs:819 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CAPACITY, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef8b7ca7 | InsertButton | DM0006_CustomerModelMapping.cs:820 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b3c5c01 | InsertButton | DM0006_CustomerModelMapping.cs:821 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LAST_UPDATED_BY, base.UserInfo.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6c80171 | InsertButton | DM0006_CustomerModelMapping.cs:822 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LAST_UPDATE_DATE, System.DateTime.Now.ToString("yyyy-MM-dd hh:ss")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f59f3c0b | InsertButton | DM0006_CustomerModelMapping.cs:825 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0006_CustomerModelMapping.SaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feb4b4c6 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:715 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f5bb3327 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:724 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-194ddbf7 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:726 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-adbf4061 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:730 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6e5e64b9 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:732 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-9872c322 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7d4b9ebd | (진입점 미연결) | DM0006_CustomerModelMapping.cs:760 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9337eed9 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-de0d1e14 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:762 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ca2ced8 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:766 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-5f197099 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:767 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-8316d276 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:768 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-c13bf2d6 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:770 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-1506aa8a | (진입점 미연결) | DM0006_CustomerModelMapping.cs:770 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a17f772 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:774 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-58a4837e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:778 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0181ad62 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:778 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-506c8ef3 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:783 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0006_CustomerModelMapping.SaveData_BizService

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9f1286a | (진입점 미연결) | DM0006_CustomerModelMapping.cs:598 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxBizClient("GSCM", "GSCM.DM.Mst.WSL/FoxBizService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-136b76eb | (진입점 미연결) | DM0006_CustomerModelMapping.cs:602 | lambda | ENDPOINT | new FoxBizRequest | ("GSCM_DM_Mst_BLL", "mSetTestList") ⇒ biz:GSCM_DM_Mst_BLL.mSetTestList | 엔드포인트 요청 생성 |  |  |  |
| AC-f4225e6c | (진입점 미연결) | DM0006_CustomerModelMapping.cs:603 | lambda | DATA_OP | request.Parameters["search"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a36486f2 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:604 | lambda | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b8d4ea55 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:606 | lambda | RETURN | return (DataSet)response.Result; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.SaveData_BizServiceCollection

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e4ffa79 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:615 |  | DATA_OP | search.Add | ("Search", "Test") | 데이터 객체 조작/조회 |  |  |  |
| AC-4dde7a0d | (진입점 미연결) | DM0006_CustomerModelMapping.cs:616 |  | DATA_OP | search.Add | ("Search2", 123) | 데이터 객체 조작/조회 |  |  |  |
| AC-11ae4b98 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:621 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxBizClient("GSCM", "GSCM.DM.Mst.WSL/FoxBizService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a393d51 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:625 | lambda | ENDPOINT | new FoxBizRequest | ("GSCM_DM_Mst_BLL", "mSetTestListCollection") ⇒ biz:GSCM_DM_Mst_BLL.mSetTestListCollection | 엔드포인트 요청 생성 |  |  |  |
| AC-8eae6867 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:626 | lambda | DATA_OP | request.Parameters["search"] | search | 행/컬럼 값 대입 |  |  |  |
| AC-c59bb852 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:627 | lambda | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b9335bc | (진입점 미연결) | DM0006_CustomerModelMapping.cs:629 | lambda | RETURN | return (DataSet)response.Result; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.SaveData_BizServiceCollection2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2777e15d | (진입점 미연결) | DM0006_CustomerModelMapping.cs:641 |  | DATA_OP | nvcCol["search"] | "test" | 행/컬럼 값 대입 |  |  |  |
| AC-3dd89ee6 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:646 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxBizClient("GSCM", "GSCM.DM.Mst.WSL/FoxBizService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce81ea6f | (진입점 미연결) | DM0006_CustomerModelMapping.cs:650 | lambda | ENDPOINT | new FoxBizRequest | ("GSCM_DM_Mst_BLL", "mSetTestListCollection2") ⇒ biz:GSCM_DM_Mst_BLL.mSetTestListCollection2 | 엔드포인트 요청 생성 |  |  |  |
| AC-d3af8487 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:651 | lambda | DATA_OP | request.Parameters["search"] | nvcCol | 행/컬럼 값 대입 |  |  |  |
| AC-90282344 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:652 | lambda | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-066b31b7 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:654 | lambda | RETURN | return (DataSet)response.Result; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.SaveData_BizServiceCollection3

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-227d9181 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:661 |  | ENDPOINT | spdMain.Sheets[0].GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70a849c9 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:668 |  | DATA_OP | dt.Columns.Add | (new DataColumn("Col1", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-996c5dbb | (진입점 미연결) | DM0006_CustomerModelMapping.cs:669 |  | DATA_OP | dt.Columns.Add | (new DataColumn("Col2", typeof(int))) | 데이터 객체 조작/조회 |  |  |  |
| AC-db08edf2 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:670 |  | DATA_OP | dt.Columns.Add | (new DataColumn("Col3", typeof(object))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7755a3ea | (진입점 미연결) | DM0006_CustomerModelMapping.cs:672 |  | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af595679 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:673 |  | DATA_OP | row["Col1"] | "test" | 행/컬럼 값 대입 |  |  |  |
| AC-b4f04b0a | (진입점 미연결) | DM0006_CustomerModelMapping.cs:674 |  | DATA_OP | row["Col2"] | 10 | 행/컬럼 값 대입 |  |  |  |
| AC-ccd59af4 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:675 |  | DATA_OP | row["Col3"] | "object test" | 행/컬럼 값 대입 |  |  |  |
| AC-6951c474 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:676 |  | DATA_OP | dt.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f04fbbb | (진입점 미연결) | DM0006_CustomerModelMapping.cs:678 |  | DATA_OP | ds2.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bfa346e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:683 |  | DATA_OP | dic.Add | ("test", "test") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8578704 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:685 |  | CALL_EXT | JsonConvert.SerializeObject | (dic, Formatting.Indented) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e932806f | (진입점 미연결) | DM0006_CustomerModelMapping.cs:690 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxBizClient("GSCM", "GSCM.DM.Mst.WSL/FoxBizService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-118d6ecd | (진입점 미연결) | DM0006_CustomerModelMapping.cs:694 | lambda | ENDPOINT | new FoxBizRequest | ("GSCM_DM_Mst_BLL", "mSetTestListCollection3") ⇒ biz:GSCM_DM_Mst_BLL.mSetTestListCollection3 | 엔드포인트 요청 생성 |  |  |  |
| AC-49103268 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:696 | lambda | DATA_OP | request.Parameters["ds"] | ds2 | 행/컬럼 값 대입 |  |  |  |
| AC-62dd1688 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:697 | lambda | DATA_OP | request.Parameters["dt"] | dt | 행/컬럼 값 대입 |  |  |  |
| AC-4cdeda9e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:698 | lambda | DATA_OP | request.Parameters["arr"] | arr | 행/컬럼 값 대입 |  |  |  |
| AC-5ca375db | (진입점 미연결) | DM0006_CustomerModelMapping.cs:699 | lambda | DATA_OP | request.Parameters["json"] | json | 행/컬럼 값 대입 |  |  |  |
| AC-e4b24e18 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:701 | lambda | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-962bbf88 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:703 | lambda | RETURN | return (DataSet)response.Result; |  | 처리 중단/반환 |  |  |  |

## DM0006_CustomerModelMapping.SaveData_DataService

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3f855e3 | SaveButton | DM0006_CustomerModelMapping.cs:499 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24ea0255 | SaveButton | DM0006_CustomerModelMapping.cs:500 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7de9505 | SaveButton | DM0006_CustomerModelMapping.cs:503 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1b0357c7 | SaveButton | DM0006_CustomerModelMapping.cs:551 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisioin == "" \|\| sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" \|\| s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be2f526f | SaveButton | DM0006_CustomerModelMapping.cs:552 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisioin == "" \|\| sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" \|\| s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97ed0606 | SaveButton | DM0006_CustomerModelMapping.cs:566 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivisioin == "" \|\| sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" \… | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a93862f2 | SaveButton | DM0006_CustomerModelMapping.cs:572 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivisioin == "" \|\| sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" \… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { msg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1bcc6c67 | SaveButton | DM0006_CustomerModelMapping.cs:573 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivisioin == "" \|\| sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" \… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed6bccb8 | SaveButton | DM0006_CustomerModelMapping.cs:598 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols["A"] | += action + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-ebb7ff3d | SaveButton | DM0006_CustomerModelMapping.cs:600 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.DIVISION_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-62678ee0 | SaveButton | DM0006_CustomerModelMapping.cs:601 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.SCM_SITE_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-de8c6450 | SaveButton | DM0006_CustomerModelMapping.cs:602 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.PROJECT_CODE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-48045a9d | SaveButton | DM0006_CustomerModelMapping.cs:604 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.ITEM_CLASS_NAME] | += "^" | 행/컬럼 값 대입 |  |  |  |
| AC-2dc38886 | SaveButton | DM0006_CustomerModelMapping.cs:605 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.ITEM_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-3e9d1d31 | SaveButton | DM0006_CustomerModelMapping.cs:607 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CUSTOMER_PROJECT_CODE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PROJECT_CODE)).ToString() … | 행/컬럼 값 대입 |  |  |  |
| AC-e82cede9 | SaveButton | DM0006_CustomerModelMapping.cs:608 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CUSTOMER_MODEL] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-056a9ccd | SaveButton | DM0006_CustomerModelMapping.cs:610 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_PACK] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_PACK)).ToString() == ""… | 행/컬럼 값 대입 |  |  |  |
| AC-5ebd5d71 | SaveButton | DM0006_CustomerModelMapping.cs:611 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_MODULE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE)).ToString() == … | 행/컬럼 값 대입 |  |  |  |
| AC-00cac955 | SaveButton | DM0006_CustomerModelMapping.cs:612 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_CELL] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL)).ToString() == ""… | 행/컬럼 값 대입 |  |  |  |
| AC-96d8b608 | SaveButton | DM0006_CustomerModelMapping.cs:614 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CAPACITY] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CAPACITY)).ToString() == "" ? "0" :… | 행/컬럼 값 대입 |  |  |  |
| AC-3c8720b9 | SaveButton | DM0006_CustomerModelMapping.cs:616 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.VALID_YN] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-e3bb77da | SaveButton | DM0006_CustomerModelMapping.cs:618 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.LAST_UPDATE_DATE] | += System.DateTime.Now.ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-db2f83b8 | SaveButton | DM0006_CustomerModelMapping.cs:619 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.LAST_UPDATED_BY] | += sUserId + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-23ead70a | SaveButton | DM0006_CustomerModelMapping.cs:631 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3728f986 | SaveButton | DM0006_CustomerModelMapping.cs:635 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA") ⇒ DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-59c68404 | SaveButton | DM0006_CustomerModelMapping.cs:636 | try ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | nvcCols["A"].Substring(0, nvcCols["A"].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6b9b57fd | SaveButton | DM0006_CustomerModelMapping.cs:637 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | nvcCols[DefColumns.DIVISION_ID].Substring(0, nvcCols[DefColumns.DIVISION_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-98a8e463 | SaveButton | DM0006_CustomerModelMapping.cs:638 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_project_code"] | nvcCols[DefColumns.CUSTOMER_PROJECT_CODE].Substring(0, nvcCols[DefColumns.CUSTOMER_PROJECT… | 행/컬럼 값 대입 |  |  |  |
| AC-035dba05 | SaveButton | DM0006_CustomerModelMapping.cs:639 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model"] | nvcCols[DefColumns.CUSTOMER_MODEL].Substring(0, nvcCols[DefColumns.CUSTOMER_MODEL].Length … | 행/컬럼 값 대입 |  |  |  |
| AC-6705c51d | SaveButton | DM0006_CustomerModelMapping.cs:640 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | nvcCols[DefColumns.SCM_SITE_ID].Substring(0, nvcCols[DefColumns.SCM_SITE_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c8c6e636 | SaveButton | DM0006_CustomerModelMapping.cs:641 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | nvcCols[DefColumns.PROJECT_CODE].Substring(0, nvcCols[DefColumns.PROJECT_CODE].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b79c9186 | SaveButton | DM0006_CustomerModelMapping.cs:642 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | nvcCols[DefColumns.ITEM_ID].Substring(0, nvcCols[DefColumns.ITEM_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-daddc1bc | SaveButton | DM0006_CustomerModelMapping.cs:643 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | nvcCols[DefColumns.VALID_YN].Substring(0, nvcCols[DefColumns.VALID_YN].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5c76b467 | SaveButton | DM0006_CustomerModelMapping.cs:644 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model_type"] | nvcCols[DefColumns.ITEM_CLASS_NAME].Substring(0, nvcCols[DefColumns.ITEM_CLASS_NAME].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-1a04fdce | SaveButton | DM0006_CustomerModelMapping.cs:645 | try ▸ lambda | DATA_OP | request.Parameters["p_convert_qty_pack"] | nvcCols[DefColumns.CONVERT_QTY_PACK].Substring(0, nvcCols[DefColumns.CONVERT_QTY_PACK].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-8aba5e9f | SaveButton | DM0006_CustomerModelMapping.cs:646 | try ▸ lambda | DATA_OP | request.Parameters["p_convert_qty_module"] | nvcCols[DefColumns.CONVERT_QTY_MODULE].Substring(0, nvcCols[DefColumns.CONVERT_QTY_MODULE]… | 행/컬럼 값 대입 |  |  |  |
| AC-4c305106 | SaveButton | DM0006_CustomerModelMapping.cs:647 | try ▸ lambda | DATA_OP | request.Parameters["p_convert_qty_cell"] | nvcCols[DefColumns.CONVERT_QTY_CELL].Substring(0, nvcCols[DefColumns.CONVERT_QTY_CELL].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-7061ed4b | SaveButton | DM0006_CustomerModelMapping.cs:648 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-ba46c437 | SaveButton | DM0006_CustomerModelMapping.cs:649 | try ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-494efe8b | SaveButton | DM0006_CustomerModelMapping.cs:650 | try ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-ad3a1564 | SaveButton | DM0006_CustomerModelMapping.cs:651 | try ▸ lambda | DATA_OP | request.Parameters["p_last_update_date"] | nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-6a0f7d40 | SaveButton | DM0006_CustomerModelMapping.cs:655 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1df3cda2 | SaveButton | DM0006_CustomerModelMapping.cs:655 | try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-439041f6 | SaveButton | DM0006_CustomerModelMapping.cs:666 | try ▸ if (sRMSG.Trim() == "success") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-060d5ac9 | SaveButton | DM0006_CustomerModelMapping.cs:669 | try ▸ if (sRMSG.Trim() == "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-976171b3 | SaveButton | DM0006_CustomerModelMapping.cs:688 | try ▸ else of (sRMSG.Trim() == "success") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c8baf057 | SaveButton | DM0006_CustomerModelMapping.cs:691 | try ▸ else of (sRMSG.Trim() == "success") | CALL_EXT | log.Write | (FoxLogLevel.Error, sRMSG) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fcbac0c | SaveButton | DM0006_CustomerModelMapping.cs:692 | try ▸ else of (sRMSG.Trim() == "success") | MESSAGE | MessageBox.Show | (sRMSG, "Warning!") | 메시지 표시 |  |  |  |
| AC-9cb754c1 | SaveButton | DM0006_CustomerModelMapping.cs:699 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-11deb9c4 | SaveButton | DM0006_CustomerModelMapping.cs:700 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-b2abdc48 | SaveButton | DM0006_CustomerModelMapping.cs:704 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9bb154c7 | SaveButton | DM0006_CustomerModelMapping.cs:361 | for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisioin == "" \|\| sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "DIVISION, CUSTOMR PJT, CUSTOMER MODEL, and SCM SITE ID are re… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53f09a4e | SaveButton | DM0006_CustomerModelMapping.cs:362 | for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisioin == "" \|\| sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e0a175a | SaveButton | DM0006_CustomerModelMapping.cs:381 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols["A"] | += action + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-8487da7b | SaveButton | DM0006_CustomerModelMapping.cs:383 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.DIVISION_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-3e658ce3 | SaveButton | DM0006_CustomerModelMapping.cs:384 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.SCM_SITE_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-1b143e21 | SaveButton | DM0006_CustomerModelMapping.cs:385 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.PROJECT_CODE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-06e35d89 | SaveButton | DM0006_CustomerModelMapping.cs:387 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.ITEM_CLASS_NAME] | += "^" | 행/컬럼 값 대입 |  |  |  |
| AC-09066544 | SaveButton | DM0006_CustomerModelMapping.cs:388 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.ITEM_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-d8a86666 | SaveButton | DM0006_CustomerModelMapping.cs:390 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CUSTOMER_PROJECT_CODE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PROJECT_CODE)).ToString() … | 행/컬럼 값 대입 |  |  |  |
| AC-08942f84 | SaveButton | DM0006_CustomerModelMapping.cs:391 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CUSTOMER_MODEL] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-5bdb14bb | SaveButton | DM0006_CustomerModelMapping.cs:393 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_PACK] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_PACK)).ToString() == ""… | 행/컬럼 값 대입 |  |  |  |
| AC-8a51373b | SaveButton | DM0006_CustomerModelMapping.cs:394 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_MODULE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE)).ToString() == … | 행/컬럼 값 대입 |  |  |  |
| AC-f817e608 | SaveButton | DM0006_CustomerModelMapping.cs:395 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_CELL] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL)).ToString() == ""… | 행/컬럼 값 대입 |  |  |  |
| AC-70d46a7f | SaveButton | DM0006_CustomerModelMapping.cs:397 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CAPACITY] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CAPACITY)).ToString() == "" ? "0" :… | 행/컬럼 값 대입 |  |  |  |
| AC-3b5a0c38 | SaveButton | DM0006_CustomerModelMapping.cs:399 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.VALID_YN] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-bb629168 | SaveButton | DM0006_CustomerModelMapping.cs:401 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.LAST_UPDATE_DATE] | += System.DateTime.Now.ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-cba7587a | SaveButton | DM0006_CustomerModelMapping.cs:402 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.LAST_UPDATED_BY] | += sUserId + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-03094cff | SaveButton | DM0006_CustomerModelMapping.cs:414 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Mst.WSL/FoxDataService.svc… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b45f20b | SaveButton | DM0006_CustomerModelMapping.cs:418 | lambda | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA") ⇒ DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-5ce59987 | SaveButton | DM0006_CustomerModelMapping.cs:419 | lambda | DATA_OP | request.Parameters["p_active_flag"] | nvcCols["A"].Substring(0, nvcCols["A"].Length -1) | 행/컬럼 값 대입 |  |  |  |
| AC-b2460966 | SaveButton | DM0006_CustomerModelMapping.cs:420 | lambda | DATA_OP | request.Parameters["p_division_id"] | nvcCols[DefColumns.DIVISION_ID].Substring(0, nvcCols[DefColumns.DIVISION_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-66863bf9 | SaveButton | DM0006_CustomerModelMapping.cs:421 | lambda | DATA_OP | request.Parameters["p_customer_project_code"] | nvcCols[DefColumns.CUSTOMER_PROJECT_CODE].Substring(0, nvcCols[DefColumns.CUSTOMER_PROJECT… | 행/컬럼 값 대입 |  |  |  |
| AC-9d7a57be | SaveButton | DM0006_CustomerModelMapping.cs:422 | lambda | DATA_OP | request.Parameters["p_customer_model"] | nvcCols[DefColumns.CUSTOMER_MODEL].Substring(0, nvcCols[DefColumns.CUSTOMER_MODEL].Length … | 행/컬럼 값 대입 |  |  |  |
| AC-c88cc361 | SaveButton | DM0006_CustomerModelMapping.cs:423 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | nvcCols[DefColumns.SCM_SITE_ID].Substring(0, nvcCols[DefColumns.SCM_SITE_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-63b2a95b | SaveButton | DM0006_CustomerModelMapping.cs:424 | lambda | DATA_OP | request.Parameters["p_project_code"] | nvcCols[DefColumns.PROJECT_CODE].Substring(0, nvcCols[DefColumns.PROJECT_CODE].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4e69999f | SaveButton | DM0006_CustomerModelMapping.cs:425 | lambda | DATA_OP | request.Parameters["p_item_id"] | nvcCols[DefColumns.ITEM_ID].Substring(0, nvcCols[DefColumns.ITEM_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3d957b10 | SaveButton | DM0006_CustomerModelMapping.cs:426 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | nvcCols[DefColumns.VALID_YN].Substring(0, nvcCols[DefColumns.VALID_YN].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7d20d174 | SaveButton | DM0006_CustomerModelMapping.cs:427 | lambda | DATA_OP | request.Parameters["p_customer_model_type"] | nvcCols[DefColumns.ITEM_CLASS_NAME].Substring(0, nvcCols[DefColumns.ITEM_CLASS_NAME].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-9ca61d0b | SaveButton | DM0006_CustomerModelMapping.cs:428 | lambda | DATA_OP | request.Parameters["p_convert_qty_pack"] | nvcCols[DefColumns.CONVERT_QTY_PACK].Substring(0, nvcCols[DefColumns.CONVERT_QTY_PACK].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-fb9b8ba9 | SaveButton | DM0006_CustomerModelMapping.cs:429 | lambda | DATA_OP | request.Parameters["p_convert_qty_module"] | nvcCols[DefColumns.CONVERT_QTY_MODULE].Substring(0, nvcCols[DefColumns.CONVERT_QTY_MODULE]… | 행/컬럼 값 대입 |  |  |  |
| AC-369f7220 | SaveButton | DM0006_CustomerModelMapping.cs:430 | lambda | DATA_OP | request.Parameters["p_convert_qty_cell"] | nvcCols[DefColumns.CONVERT_QTY_CELL].Substring(0, nvcCols[DefColumns.CONVERT_QTY_CELL].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-757c2dda | SaveButton | DM0006_CustomerModelMapping.cs:431 | lambda | DATA_OP | request.Parameters["p_created_by"] | nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-af66cf61 | SaveButton | DM0006_CustomerModelMapping.cs:432 | lambda | DATA_OP | request.Parameters["p_creation_date"] | nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-695e0a1e | SaveButton | DM0006_CustomerModelMapping.cs:433 | lambda | DATA_OP | request.Parameters["p_last_updated_by"] | nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-6d2e39c4 | SaveButton | DM0006_CustomerModelMapping.cs:434 | lambda | DATA_OP | request.Parameters["p_last_update_date"] | nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-578fb9d4 | SaveButton | DM0006_CustomerModelMapping.cs:438 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3192c198 | SaveButton | DM0006_CustomerModelMapping.cs:438 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-1087e99e | SaveButton | DM0006_CustomerModelMapping.cs:481 | if (sRMSG.Trim() == "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae03fe3e | SaveButton | DM0006_CustomerModelMapping.cs:491 | else of (sRMSG.Trim() == "success") | CALL_EXT | log.Write | (FoxLogLevel.Error, sRMSG) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3add4b4e | SaveButton | DM0006_CustomerModelMapping.cs:493 | else of (sRMSG.Trim() == "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { sRMSG }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0006_CustomerModelMapping.SaveDataBiz

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd2af517 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:508 | if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9d2fb260 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:526 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e7fe6ba | (진입점 미연결) | DM0006_CustomerModelMapping.cs:528 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-25b8b7a4 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:529 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DIVISION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c9ef6fc0 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:530 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SCM_SITE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f1304215 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:531 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.PROJECT_CODE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-70c08e1b | (진입점 미연결) | DM0006_CustomerModelMapping.cs:533 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ITEM_CLASS_NAME] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-67ef0a35 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:534 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ITEM_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-18f2536f | (진입점 미연결) | DM0006_CustomerModelMapping.cs:536 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.CUSTOMER_PROJECT_CODE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-944ae4ef | (진입점 미연결) | DM0006_CustomerModelMapping.cs:537 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.CUSTOMER_MODEL] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d6db2168 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:539 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.CONVERT_QTY_PACK] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_PACK)).ToString() == "" ? … | 행/컬럼 값 대입 |  |  |  |
| AC-d692d362 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:540 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.CONVERT_QTY_MODULE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE)).ToString() == "" … | 행/컬럼 값 대입 |  |  |  |
| AC-b65d66d4 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:541 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.CONVERT_QTY_CELL] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL)).ToString() == "" ? … | 행/컬럼 값 대입 |  |  |  |
| AC-8253788e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:542 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.CAPACITY] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CAPACITY)).ToString() == "" ? "0" : si… | 행/컬럼 값 대입 |  |  |  |
| AC-4318c62e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:543 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.VALID_YN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7b184d77 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:545 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LAST_UPDATE_DATE] | System.DateTime.Now.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2be84c69 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:546 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LAST_UPDATED_BY] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-221fb64b | (진입점 미연결) | DM0006_CustomerModelMapping.cs:547 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c52ff40c | (진입점 미연결) | DM0006_CustomerModelMapping.cs:550 |  | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-05461b7f | (진입점 미연결) | DM0006_CustomerModelMapping.cs:571 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxBizClient("GSCM", "GSCM.DM.Mst.WSL/FoxBizService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e8a326e | (진입점 미연결) | DM0006_CustomerModelMapping.cs:575 | lambda | ENDPOINT | new FoxBizRequest | ("GSCM_DM_Mst_BLL", "mSet_DM0006_CustomerModelMapping_INT") ⇒ biz:GSCM_DM_Mst_BLL.mSet_DM0006_CustomerModelMapping_INT | 엔드포인트 요청 생성 |  |  |  |
| AC-07be6e4a | (진입점 미연결) | DM0006_CustomerModelMapping.cs:577 | lambda | DATA_OP | request.Parameters["saveDS"] | saveDS | 행/컬럼 값 대입 |  |  |  |
| AC-0b941c65 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:579 | lambda | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b183970 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:581 | lambda | RETURN | return (int)response.Result; |  | 처리 중단/반환 |  |  |  |
| AC-4ca1eb82 | (진입점 미연결) | DM0006_CustomerModelMapping.cs:587 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iResult }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0006_CustomerModelMapping.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-295bfb6e | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1112 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a26a128 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1146 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c9d7823c | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1147 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-5badee11 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1148 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f362ab47 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1149 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-259ffdd7 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1161 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-9b5bc8d4 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1162 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-eb7c68ee | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1165 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-dd648576 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1166 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-d07e7cae | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1199 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-586007ed | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1201 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d93ddf4d | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1202 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f87c70bd | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1203 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eb611d63 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1207 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-3c67932c | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1208 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName) | 그리드 값 설정 |  |  |  |
| AC-47ff53af | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1209 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), popItem.ItemName) | 그리드 값 설정 |  |  |  |
| AC-5bf5443b | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1211 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b479093 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1215 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), e.Row, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca2e323a | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1225 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), e.Row, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b59749bf | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:1226 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), e.Row, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3a819b84 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:924 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-194a2210 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:947 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a9e48315 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:948 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, "") | 팝업 초기화(인자 전달) |  |  |  |
| AC-0c25134b | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:949 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c2bd973f | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:950 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0673f5f3 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:954 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-9bdc12a4 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:955 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-24d5fe22 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:958 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fa0e84d8 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:959 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-f9e01c5b | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:975 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e61e2439 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:977 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.Form_Load | (false, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-180da342 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:978 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-67380b45 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:979 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fa4a260d | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:983 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-9eec0100 | this.spdMain.CellDoubleClick | DM0006_CustomerModelMapping.cs:984 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName) | 그리드 값 설정 |  |  |  |

## DM0006_CustomerModelMapping.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7079f1dd | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:886 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-2e080fb1 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:886 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a306058 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:887 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-90f97625 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:894 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-4525d1f6 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:894 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c9366b8a | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:895 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-67ba8ec3 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:900 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-46f3263f | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:900 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07b442f9 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:901 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-97977550 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:911 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b2ac4366 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:913 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-b1c5245b | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:915 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e8637516 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:917 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-6fcc71a9 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:919 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-2b43af2e | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:921 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-28c63676 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:923 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-dc248e6c | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:942 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-2dc0de7b | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:942 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e01153ae | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:943 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3436ae92 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:947 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6af9be8a | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:947 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e9a2708 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:948 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6c5ae290 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:962 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-2116e006 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:964 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b04e0849 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:966 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-6d7d04c4 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:968 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-cbd0ea76 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:970 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-37328564 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:972 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-82966856 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:982 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e77fdc38 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:982 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc3cd410 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:983 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1b74f0cf | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:989 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b7845126 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:991 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-5abd8328 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:993 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-e5bc6b39 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:995 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-73ae615d | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:997 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-a447b71f | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:1006 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-3a7c4878 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:1008 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-2518fd19 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:1010 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c07232d0 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:1012 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-aa83df70 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:910 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-84e73902 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:911 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4c9ea952 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:913 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-2185dbe1 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:914 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-6c2f115d | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:916 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-74ad4861 | this.spdMain.ComboSelChange | DM0006_CustomerModelMapping.cs:917 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |

## DM0006_CustomerModelMapping.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e49a4cb | this.spdMain.KeyUp | DM0006_CustomerModelMapping.cs:1243 | if (e.Control == true && e.KeyCode == Keys.V) | CALL_EXT | spdMain.Sheets[0].ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f40a5bb | this.spdMain.KeyUp | DM0006_CustomerModelMapping.cs:1250 | if (e.Control == true && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-528c5217 | this.spdMain.KeyUp | DM0006_CustomerModelMapping.cs:999 | if (e.Control == true && e.KeyCode == Keys.V) | CALL_EXT | spdMain.Sheets[0].ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a00b7b1b | this.spdMain.KeyUp | DM0006_CustomerModelMapping.cs:1006 | if (e.Control == true && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0006_CustomerModelMapping.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa7befd7 | this.spdMain.TopChange | DM0006_CustomerModelMapping.cs:1348 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0006_POPUP_01.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ef99e97 | this.btnButtonList.UsrButtonList_Click_Detected | DM0006_POPUP_01.cs:432 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-6baabb90 | this.btnButtonList.UsrButtonList_Click_Detected | DM0006_POPUP_01.cs:435 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0006_POPUP_01.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8d9afa6 | this.Load | DM0006_POPUP_01.cs:156 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f23b7af8 | this.Load | DM0006_POPUP_01.cs:157 |  | GRID_INIT | this.AddSheet | (fpWhere, SpdSheet.shtWhere, SpdSheet.shtWhere, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34a23223 | this.Load | DM0006_POPUP_01.cs:159 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-17c9cec7 | this.Load | DM0006_POPUP_01.cs:160 |  | FLAG | siWhere | GetSheetInfo(fpWhere.Name, fpWhere.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-46224293 | this.Load | DM0006_POPUP_01.cs:85 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b1e7f83c | this.Load | DM0006_POPUP_01.cs:86 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-dafa92fd | this.Load | DM0006_POPUP_01.cs:87 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0006_POPUP_01.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41684ec9 | this.Load | DM0006_POPUP_01.cs:151 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-67b7fc91 | this.Load | DM0006_POPUP_01.cs:80 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0006_POPUP_01.Delete_Button

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b5fb37d | (진입점 미연결) | DM0006_POPUP_01.cs:456 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-17024f0d | (진입점 미연결) | DM0006_POPUP_01.cs:459 | else of (fps.Name == "spdMain") | DATA_OP | siWhere.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0006_POPUP_01.DeleteButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:] / DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6e3266c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:204 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-095cdb20 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:207 | else of (fps.Name == "spdMain") | DATA_OP | siWhere.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ad214329 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:120 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0006_POPUP_01.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ed2cf54 | Dispose | DM0006_POPUP_01.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-2b9d344c | Dispose | DM0006_POPUP_01.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0006_POPUP_01.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Edit:] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62775353 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:216 | if (dtCols == null) ▸ if (FindData("FIND") == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dc5f265 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:220 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c04c8520 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:221 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2467ebeb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:222 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(GroupColumns.NAME), siMain.GetColumnIndex(GroupColumns.TYPE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-867ad655 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:225 |  | FLAG | siWhere | GetSheetInfo(fpWhere.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-28a27f0a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:226 |  | GRID_LOCK | siWhere.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4cef2714 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:227 |  | GRID_LOCK | siWhere.LockColumn | (siWhere.GetColumnIndex(WhereColumns.TYPE), siWhere.GetColumnIndex(WhereColumns.COLUMN), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2499e4a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:127 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-099affb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:128 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-93c32fa1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:130 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Column1), siMain.GetColumnIndex(DefColumns.Column3), tru… | 그리드 편집 잠금/해제 |  |  |  |

## DM0006_POPUP_01.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / EditButton [if (dtCols == null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-823620f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:272 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | txtReportName.Text | clsData.sReport_Name | 컨트롤 값 설정 |  |  |  |
| AC-42841ba6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:273 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | txtDescription.Text | clsData.sDes | 컨트롤 값 설정 |  |  |  |
| AC-d9d72f93 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:274 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | clbRole.ControlValues | clsData.sRole_ID | 컨트롤 값 설정 |  |  |  |
| AC-32b54289 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:275 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | VALUE_SET | rtxtSQL.Text | clsData.sSql | 컨트롤 값 설정 |  |  |  |
| AC-4f1e5a9d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:300 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0c1e5ca1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:301 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3203ea5a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:305 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_BIND | siWhere.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7c340016 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:306 | if (sMode == "LOAD") ▸ if (clsData.sFlag != "") | GRID_LOCK | siWhere.LockColumn | (0, siWhere.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8d83d20 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:314 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") ▸ if (lbl_DQ_ID.Text == "") | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-98608933 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:320 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-5c2df20a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:321 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | DATA_OP | request.Parameters["p_dq_id"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d5c15c5e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:322 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | DATA_OP | request.Parameters["p_dq_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9f466418 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:323 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | DATA_OP | request.Parameters["p_role"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d61e18f3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:324 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62a4bc6c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:331 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | txtReportName.Text | ds.Tables[0].Rows[0]["DQ_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-4e1d13b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:332 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | txtDescription.Text | ds.Tables[0].Rows[0]["DESCRIPTION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-abe5e3f2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:342 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | clbRole.ControlValues | sRoles | 컨트롤 값 설정 |  |  |  |
| AC-2a65351b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:343 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | VALUE_SET | rtxtSQL.Text | ds.Tables[0].Rows[0]["DQ_TEXT"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bcd831de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:349 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-802e5bbc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:350 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-57a0cd3b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:354 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_BIND | siWhere.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ff14a799 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:355 | if (sMode == "LOAD") ▸ else of (clsData.sFlag != "") | GRID_LOCK | siWhere.LockColumn | (0, siWhere.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-63077c06 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:364 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (rtxtSQL.Text.Trim() == "") | POPUP | FoxMessageBox.Show | ("No Query.") | 팝업/폼 열기 |  |  |  |
| AC-23c1e016 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:365 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (rtxtSQL.Text.Trim() == "") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-7d55827d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:370 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") | CALL_EXT | clsQuerys.ReplaceFirstOccurence | ("SELECT", "SELECT TOP 0 ", sSQL) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5219a69a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:371 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") | ENDPOINT | clsQuerys.GetDataByDB | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a23021cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:375 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (dtSQL.Rows.Count == 1) | POPUP | FoxMessageBox.Show | ("Error" + dtSQL.Rows[0][1].ToString()) | 팝업/폼 열기 |  |  |  |
| AC-7e286bc5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:376 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ if (dtSQL.Rows.Count == 1) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-28b19658 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:379 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | FLAG | this.dtCols | clsQuerys.GetColumnList(dtSQL) | 화면 필드/플래그 변경 |  |  |  |
| AC-1329bd97 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:379 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | CALL_EXT | clsQuerys.GetColumnList | (dtSQL) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8d8fab6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:380 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | FLAG | this.dtTypes | clsQuerys.GetColumnTypeList(dtSQL) | 화면 필드/플래그 변경 |  |  |  |
| AC-909cc345 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:380 | else of (sMode == "LOAD") ▸ if (sMode == "FIND") ▸ else of (dtSQL.Rows.Count == 1) | CALL_EXT | clsQuerys.GetColumnTypeList | (dtSQL) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12d2f91a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:385 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-0b09fa39 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:150 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c27db782 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:154 | lambda | ENDPOINT | new FoxDataRequest | ("xxxx.xxxx") ⇒ xxxx.xxxx | 엔드포인트 요청 생성 |  |  |  |
| AC-427cb1dc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:155 | lambda | DATA_OP | request.Parameters["Search"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1a41c863 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:156 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-799e8ba8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:158 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5e9f86dd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:162 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cac84b38 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:163 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9887377 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:166 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8ff6510 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:171 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-5f599ae2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:171 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f514386d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:172 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0006_POPUP_01.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d80593c | this.Load | DM0006_POPUP_01.cs:104 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-55705f17 | this.Load | DM0006_POPUP_01.cs:106 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-36f713cd | this.Load | DM0006_POPUP_01.cs:68 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0006_POPUP_01.fpWhere_CellDoubleClick

진입점: this.fpWhere.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b621087a | this.fpWhere.CellDoubleClick | DM0006_POPUP_01.cs:657 | if (siWhere.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0006_POPUP_01.GroupData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / this.Load [if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / FindButton [if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / EditButton [if (dtCols == null) ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-496de4a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:396 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | 엔드포인트 요청 생성 |  |  |  |
| AC-ec197268 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:397 |  | DATA_OP | request.Parameters["p_dq_id"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-59daf701 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:398 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-36139809 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:400 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## DM0006_POPUP_01.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8e5287d | this.Load | DM0006_POPUP_01.cs:130 |  | FLAG | dtRole | clsQuerys.GetCommonDataByDB("ROLES") | 화면 필드/플래그 변경 |  |  |  |
| AC-1ea145d2 | this.Load | DM0006_POPUP_01.cs:130 |  | COMBO_DATA | clsQuerys.GetCommonDataByDB | ("ROLES") | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-aefa3872 | this.Load | DM0006_POPUP_01.cs:131 |  | LIST_REBIND | clsCtrl.setListBox | (dtRole, clbRole, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0006_POPUP_01.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / EditButton [if (dtCols == null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9e385d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:94 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-27d43008 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:96 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-56f30167 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:97 |  | GRID_INIT | siMain.AddTextColumn | ("Column1", DefColumns.Column1, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d608780 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:98 |  | GRID_INIT | siMain.AddTextColumn | ("Column2", DefColumns.Column2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81b297a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:99 |  | GRID_INIT | siMain.AddTextColumn | ("Column3", DefColumns.Column3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34356e3d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:101 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Column3)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0006_POPUP_01.InitSpread_Group

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40710042 | this.Load | DM0006_POPUP_01.cs:631 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-bd62a7c5 | this.Load | DM0006_POPUP_01.cs:633 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2649940c | this.Load | DM0006_POPUP_01.cs:634 |  | GRID_INIT | siMain.AddTextColumn | ("Column", GroupColumns.NAME, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2d46374 | this.Load | DM0006_POPUP_01.cs:635 |  | GRID_INIT | siMain.AddTextColumn | ("Type", GroupColumns.TYPE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbb43f10 | this.Load | DM0006_POPUP_01.cs:636 |  | GRID_INIT | siMain.AddComboColumn | ("Vaild", GroupColumns.VALID, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ee77c26 | this.Load | DM0006_POPUP_01.cs:638 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 1, 1, 3, 25, "Column", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0006_POPUP_01.InitSpread_Where

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd857986 | this.Load | DM0006_POPUP_01.cs:643 |  | GRID_INIT | siWhere.InitSheet | (siWhere.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c62044b6 | this.Load | DM0006_POPUP_01.cs:645 |  | GRID_INIT | siWhere.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7657d368 | this.Load | DM0006_POPUP_01.cs:646 |  | GRID_INIT | siWhere.AddComboColumn | ("Type", WhereColumns.TYPE, FPMerge.None, 80, true, dtDataType, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-257ebff3 | this.Load | DM0006_POPUP_01.cs:647 |  | GRID_INIT | siWhere.AddTextColumn | ("Column", WhereColumns.COLUMN, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1fa5c1cc | this.Load | DM0006_POPUP_01.cs:648 |  | GRID_INIT | siWhere.AddComboColumn | ("Vaild", WhereColumns.VALID, FPMerge.None, 80, true, dtYesOrNo, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b02139e | this.Load | DM0006_POPUP_01.cs:651 |  | GRID_INIT | siWhere.ColumnHeaderSpan | (0, 1, 1, 3, 25, "Condition", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0006_POPUP_01.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-587563aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:581 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3263a34c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:589 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3df7202f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:592 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(GroupColumns.NAME), dtCols) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e6cc5a4c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:593 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(GroupColumns.TYPE), dtTypes) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8bbf608b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:599 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (GroupColumns.VALID, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-1aa824f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:601 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-aa35d948 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:612 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | DATA_OP | siWhere.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9074823 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:615 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | GRID_COMBO | siWhere.SetCellTypeCombo | (insCell.Row.Index, siWhere.GetColumnIndex(WhereColumns.TYPE), dtDataType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-047f84b3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:616 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | GRID_COMBO | siWhere.SetCellTypeCombo | (insCell.Row.Index, siWhere.GetColumnIndex(WhereColumns.COLUMN), dtCols) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-09135818 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:621 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | DATA_OP | defaultData.Add | (WhereColumns.VALID, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-081ffc62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:623 | if (fps.Name == "fpWhere") ▸ if (siWhere != null && siWhere.IsLock(siWhere.SheetName) == false) ▸ if (siWhere.SheetName == SpdSheet.shtWhere… | GRID_SET | siWhere.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-366c869a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d6feb43c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:266 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column1, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7d54eee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column2, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-9745a7e8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:268 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column3, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-17918a33 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0006_POPUP_01.cs:270 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0006_POPUP_01.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46bdb9ab | (진입점 미연결) | DM0006_POPUP_01.cs:117 |  | FLAG | this.clsData | clsData | 화면 필드/플래그 변경 |  |  |  |
| AC-b4714cde | (진입점 미연결) | DM0006_POPUP_01.cs:119 |  | VALUE_SET | lbl_DQ_ID.Text | clsData.sDq_ID | 컨트롤 값 설정 |  |  |  |

## DM0006_POPUP_01.mSave

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea444d80 | (진입점 미연결) | DM0006_POPUP_01.cs:477 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_ADM_DQ_CREATE") ⇒ DM.PR_DM_ADM_DQ_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-dcea2241 | (진입점 미연결) | DM0006_POPUP_01.cs:478 |  | DATA_OP | request.Parameters["p_active_flag"] | sFlag | 행/컬럼 값 대입 |  |  |  |
| AC-48a4cb31 | (진입점 미연결) | DM0006_POPUP_01.cs:479 |  | DATA_OP | request.Parameters["p_DQ_ID"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-43b7626e | (진입점 미연결) | DM0006_POPUP_01.cs:480 |  | DATA_OP | request.Parameters["p_DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c5ed1b8a | (진입점 미연결) | DM0006_POPUP_01.cs:481 |  | DATA_OP | request.Parameters["p_DQ_NAME"] | txtReportName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e93d5f77 | (진입점 미연결) | DM0006_POPUP_01.cs:482 |  | DATA_OP | request.Parameters["p_DESC"] | txtDescription.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7f60c958 | (진입점 미연결) | DM0006_POPUP_01.cs:483 |  | DATA_OP | request.Parameters["p_QUERY"] | rtxtSQL.Text | 행/컬럼 값 대입 |  |  |  |
| AC-dfa718e0 | (진입점 미연결) | DM0006_POPUP_01.cs:484 |  | DATA_OP | request.Parameters["p_VALID_YN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-746d9de1 | (진입점 미연결) | DM0006_POPUP_01.cs:485 |  | DATA_OP | request.Parameters["p_ADMIN_ONLY_YN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-1a23c27e | (진입점 미연결) | DM0006_POPUP_01.cs:486 |  | DATA_OP | request.Parameters["p_CREATED_BY"] | "DB" | 행/컬럼 값 대입 |  |  |  |
| AC-3779830e | (진입점 미연결) | DM0006_POPUP_01.cs:487 |  | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | "DB" | 행/컬럼 값 대입 |  |  |  |
| AC-878f68c3 | (진입점 미연결) | DM0006_POPUP_01.cs:488 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-587fff26 | (진입점 미연결) | DM0006_POPUP_01.cs:498 | if (sRMSG.Trim() == "success") | VALUE_SET | lbl_DQ_ID.Text | response.DataSet.Tables[response.DataSet.Tables.Count - 1].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1ff510fe | (진입점 미연결) | DM0006_POPUP_01.cs:501 | if (sRMSG.Trim() == "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "저장 되었습니다." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1de2dd24 | (진입점 미연결) | DM0006_POPUP_01.cs:513 | else of (sRMSG.Trim() == "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { sRMSG }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0006_POPUP_01.ParameterData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / this.Load [if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / FindButton [if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / EditButton [if (dtCols == null) ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sMode == "LOAD") ▸ if (clsData.sFlag != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f7396e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:411 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS") ⇒ DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | 엔드포인트 요청 생성 |  |  |  |
| AC-b90b68df | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:412 |  | DATA_OP | request.Parameters["p_dq_id"] | lbl_DQ_ID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-204f16d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:413 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2b03886 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | DM0006_POPUP_01.cs:415 |  | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |

## DM0006_POPUP_01.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec41b692 | SaveButton | DM0006_POPUP_01.cs:182 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8dc8f7d7 | SaveButton | DM0006_POPUP_01.cs:191 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e66b381e | SaveButton | DM0006_POPUP_01.cs:193 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-195d0961 | SaveButton | DM0006_POPUP_01.cs:194 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-73ad5997 | SaveButton | DM0006_POPUP_01.cs:195 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-825faa5b | SaveButton | DM0006_POPUP_01.cs:196 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-97eea566 | SaveButton | DM0006_POPUP_01.cs:197 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5648d1ee | SaveButton | DM0006_POPUP_01.cs:199 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-75ec0246 | SaveButton | DM0006_POPUP_01.cs:202 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26011763 | SaveButton | DM0006_POPUP_01.cs:205 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f598d91b | SaveButton | DM0006_POPUP_01.cs:206 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column2) | 데이터 객체 조작/조회 |  |  |  |
| AC-a60b992f | SaveButton | DM0006_POPUP_01.cs:217 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b7bb01d | SaveButton | DM0006_POPUP_01.cs:218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e3be1af | SaveButton | DM0006_POPUP_01.cs:227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c261fd2c | SaveButton | DM0006_POPUP_01.cs:228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f44788df | SaveButton | DM0006_POPUP_01.cs:229 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ee31835f | SaveButton | DM0006_POPUP_01.cs:233 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-cfa86178 | SaveButton | DM0006_POPUP_01.cs:234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-3eabd7ee | SaveButton | DM0006_POPUP_01.cs:235 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-d7f3bd4b | SaveButton | DM0006_POPUP_01.cs:237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-9bb03ffd | SaveButton | DM0006_POPUP_01.cs:237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-071aa6d8 | SaveButton | DM0006_POPUP_01.cs:241 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e368603f | SaveButton | DM0006_POPUP_01.cs:245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42d1c1b2 | SaveButton | DM0006_POPUP_01.cs:245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-1e01f96b | SaveButton | DM0006_POPUP_01.cs:250 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0006_POPUP_01.SetItem

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8df47b97 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:526 |  | FLAG | this.clsData | new DyamicSqlPopup() | 화면 필드/플래그 변경 |  |  |  |
| AC-3eb97045 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:526 |  | POPUP | new DyamicSqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-111aca40 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:528 |  | UI_PROP | this.clsData.sFlag | "true" | 속성 sFlag 설정 |  |  |  |
| AC-cb0049a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:529 |  | UI_PROP | this.clsData.sDq_ID | lbl_DQ_ID.Text | 속성 sDq_ID 설정 |  |  |  |
| AC-ea5c3c28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:530 |  | UI_PROP | this.clsData.sReport_Name | txtReportName.Text | 속성 sReport_Name 설정 |  |  |  |
| AC-efe49caa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:531 |  | UI_PROP | this.clsData.sDes | txtDescription.Text | 속성 sDes 설정 |  |  |  |
| AC-cbb703d7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:532 |  | UI_PROP | this.clsData.sSql | rtxtSQL.Text | 속성 sSql 설정 |  |  |  |
| AC-665125ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:533 |  | UI_PROP | this.clsData.sRole_ID | clbRole.ControlValues | 속성 sRole_ID 설정 |  |  |  |
| AC-4c85b122 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:534 |  | UI_PROP | this.clsData.sRole_Name | clbRole.NameList | 속성 sRole_Name 설정 |  |  |  |
| AC-3fe5a2cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:555 |  | UI_PROP | this.clsData.sColumns | p_active_flag | 속성 sColumns 설정 |  |  |  |
| AC-7a0b7b07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DM0006_POPUP_01.cs:575 |  | UI_PROP | this.clsData.sParameters | p_active_flag | 속성 sParameters 설정 |  |  |  |

