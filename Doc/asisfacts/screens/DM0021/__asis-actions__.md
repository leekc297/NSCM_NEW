# AS-IS 액션 대조표 — DM0021

> 원천: `Doc/asisfacts/screens/DM0021/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 569행 · 메서드 69 · 종류 DATA_OP 134 · GRID_SET 57 · FLAG 56 · RETURN 55 · ENDPOINT 49 · GRID_INIT 33 · COMBO_DATA 26 · GRID_LOCK 22 · POPUP 17 · MESSAGE 17 · LIST_REBIND 17 · UI_PROP 16 · GRID_COMBO 16 · CALL_EXT 15 · UI_MISC 10 · VALUE_SET 7 · THROW 7 · GRID_STYLE 7 · STATE 4 · GRID_BIND 3 · STATE_RESET 1 · ⚠ 의미 확인 필요 15


## DM0021_SalesPlan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9991c34 | this.btnColumn.Click | DM0021_SalesPlan.cs:2587 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF1007", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-76b79d0e | this.btnColumn.Click | DM0021_SalesPlan.cs:2588 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4e63a945 | this.btnColumn.Click | DM0021_SalesPlan.cs:2589 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0021_SalesPlan.btnCutOff_Click

진입점: this.btnCutOff.Click / this.layoutControlItem7.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96d549f2 | this.btnCutOff.Click 외 1 | DM0021_SalesPlan.cs:2920 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-ab59d3d0 | this.btnCutOff.Click 외 1 | DM0021_SalesPlan.cs:2921 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7dd25f5 | this.btnCutOff.Click 외 1 | DM0021_SalesPlan.cs:2927 |  | POPUP | new POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-c40b85cb | this.btnCutOff.Click 외 1 | DM0021_SalesPlan.cs:2928 |  | CALL_EXT | popup.LoadData | (sVersion_Type, sFoxData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0629dcaa | this.btnCutOff.Click 외 1 | DM0021_SalesPlan.cs:2929 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d7617984 | this.btnCutOff.Click 외 1 | DM0021_SalesPlan.cs:2930 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0021_SalesPlan.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fef453ff | this.btnItemId.Click 외 1 | DM0021_SalesPlan.cs:1930 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-13749c5f | this.btnItemId.Click 외 1 | DM0021_SalesPlan.cs:1932 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f682564c | this.btnItemId.Click 외 1 | DM0021_SalesPlan.cs:1933 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0f9bb08d | this.btnItemId.Click 외 1 | DM0021_SalesPlan.cs:1934 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-513be9d1 | this.btnItemId.Click 외 1 | DM0021_SalesPlan.cs:1936 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DM0021_SalesPlan.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c952fc9b | this.btnMeasure.Click | DM0021_SalesPlan.cs:2599 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF1007", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-f2e7d31b | this.btnMeasure.Click | DM0021_SalesPlan.cs:2600 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7c080113 | this.btnMeasure.Click | DM0021_SalesPlan.cs:2601 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0021_SalesPlan.btnProject_Click

진입점: this.btnProject.Click / this.layoutControlItem3.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c12565b1 | this.btnProject.Click 외 2 | DM0021_SalesPlan.cs:1912 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-5520e0c4 | this.btnProject.Click 외 2 | DM0021_SalesPlan.cs:1913 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-589513b9 | this.btnProject.Click 외 2 | DM0021_SalesPlan.cs:1914 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0320d526 | this.btnProject.Click 외 2 | DM0021_SalesPlan.cs:1915 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c2d22af6 | this.btnProject.Click 외 2 | DM0021_SalesPlan.cs:1917 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0021_SalesPlan.cboKRW_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccc602ac | (진입점 미연결) | DM0021_SalesPlan.cs:3182 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.cboLOC_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a2d4883 | (진입점 미연결) | DM0021_SalesPlan.cs:3202 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.cboUSD_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-527973a2 | (진입점 미연결) | DM0021_SalesPlan.cs:3192 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-735d439b | this.clbCustomer.SelectedIndexChanged | DM0021_SalesPlan.cs:2940 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-98e2e272 | this.clbCustomer.SelectedIndexChanged | DM0021_SalesPlan.cs:2940 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b4f9c3c | this.clbCustomer.SelectedIndexChanged | DM0021_SalesPlan.cs:2941 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0021_SalesPlan.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4b123cb | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2952 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7c1bab8 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2955 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-da707fd1 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2974 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-9256f8da | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2974 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3cacdfa1 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2975 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02223cd8 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2979 | try | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5db073d3 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2979 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a21107b3 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2980 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-adcbbb72 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2984 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7708e446 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2984 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6ec3c21 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2985 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0aead33d | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2987 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-42916575 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2987 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-98e4516c | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2988 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb995714 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2990 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6148c02 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2991 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7e47cd34 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2995 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f35cf391 | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:2996 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ce13d56b | this.clbDivision.SelectedIndexChanged | DM0021_SalesPlan.cs:3000 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DM0021_SalesPlan.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a5e45bb | this.clbTeam.SelectedIndexChanged | DM0021_SalesPlan.cs:3116 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-99b7164d | this.clbTeam.SelectedIndexChanged | DM0021_SalesPlan.cs:3116 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca803a8f | this.clbTeam.SelectedIndexChanged | DM0021_SalesPlan.cs:3117 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5d9ba849 | this.clbTeam.SelectedIndexChanged | DM0021_SalesPlan.cs:3121 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b5e18eab | this.clbTeam.SelectedIndexChanged | DM0021_SalesPlan.cs:3121 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab84244c | this.clbTeam.SelectedIndexChanged | DM0021_SalesPlan.cs:3122 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0021_SalesPlan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-744ded3f | this.Load | DM0021_SalesPlan.cs:351 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4150bf33 | this.Load | DM0021_SalesPlan.cs:352 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d5fe636 | this.Load | DM0021_SalesPlan.cs:353 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0021_SalesPlan.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1e794f8 | this.Load | DM0021_SalesPlan.cs:295 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-cc2ebb8f | this.Load | DM0021_SalesPlan.cs:296 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-e87a557e | this.Load | DM0021_SalesPlan.cs:298 |  | UI_PROP | usrConditionPanel2.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-135faee3 | this.Load | DM0021_SalesPlan.cs:301 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-a3b8bf50 | this.Load | DM0021_SalesPlan.cs:303 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-4e711487 | this.Load | DM0021_SalesPlan.cs:305 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-338e349b | this.Load | DM0021_SalesPlan.cs:306 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-4a66b57c | this.Load | DM0021_SalesPlan.cs:307 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-15f70536 | this.Load | DM0021_SalesPlan.cs:308 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-4241eb72 | this.Load | DM0021_SalesPlan.cs:315 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-28dd1c65 | this.Load | DM0021_SalesPlan.cs:316 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-393ceba7 | this.Load | DM0021_SalesPlan.cs:317 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-44488faf | this.Load | DM0021_SalesPlan.cs:320 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f3d2fd42 | this.Load | DM0021_SalesPlan.cs:321 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e19bd4bc | this.Load | DM0021_SalesPlan.cs:322 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DM0021_SalesPlan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e58764f6 | DeleteButton | DM0021_SalesPlan.cs:588 | if (vAction1 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f81a3983 | DeleteButton | DM0021_SalesPlan.cs:590 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0021_SalesPlan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c41c8b1 | Dispose | DM0021_SalesPlan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0021_SalesPlan.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-254d4a7e | dsdm.Changed | DM0021_SalesPlan.cs:2171 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f51af531 | dsdm.Changed | DM0021_SalesPlan.cs:2176 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3977f303 | dsdm.Changed | DM0021_SalesPlan.cs:2177 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e266354 | dsdm.Changed | DM0021_SalesPlan.cs:2178 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d752ec28 | dsdm.Changed | DM0021_SalesPlan.cs:2187 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1fc564b1 | dsdm.Changed | DM0021_SalesPlan.cs:2192 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-8d7c2eba | dsdm.Changed | DM0021_SalesPlan.cs:2193 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-347a6483 | dsdm.Changed | DM0021_SalesPlan.cs:2197 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | CALL_EXT | siMain.SetColor | (e.Row, e.Column, e.Row, e.Column, System.Drawing.Color.Red, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30eafb07 | dsdm.Changed | DM0021_SalesPlan.cs:2211 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column, sVal) | 그리드 값 설정 |  |  |  |
| AC-18bbef40 | dsdm.Changed | DM0021_SalesPlan.cs:2217 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, e.Column - i, (iWeek - iResult).ToString()) | 그리드 값 설정 |  |  |  |
| AC-d64af881 | dsdm.Changed | DM0021_SalesPlan.cs:2228 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, ColPosition, (iMonth - iResult).ToString()) | 그리드 값 설정 |  |  |  |
| AC-17754281 | dsdm.Changed | DM0021_SalesPlan.cs:2235 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Col… | GRID_SET | siMain.SetText | (e.Row, ColPosition, (iMonth - iResult).ToString()) | 그리드 값 설정 |  |  |  |

## DM0021_SalesPlan.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e4bb25f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0021_SalesPlan.cs:600 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f0521a6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0021_SalesPlan.cs:601 | if (this.fps != null) | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-de60567c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0021_SalesPlan.cs:606 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-82006adf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0021_SalesPlan.cs:666 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (sValue.IndexOf("D_") == 0) ▸ … | GRID_LOCK | siMain.LockRange | (i, j, i, j, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a96f7c9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0021_SalesPlan.cs:668 | if (this.fps != null) ▸ try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if (sValue.IndexOf("D_") == 0) ▸ … | GRID_LOCK | siMain.LockRange | (i, j, i, j, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f1b88e9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0021_SalesPlan.cs:674 | if (this.fps != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## DM0021_SalesPlan.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9628b2e4 | FindButton 외 1 | DM0021_SalesPlan.cs:691 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-efb7586b | FindButton 외 1 | DM0021_SalesPlan.cs:698 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5bb45e79 | FindButton 외 1 | DM0021_SalesPlan.cs:699 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3a98421 | FindButton 외 1 | DM0021_SalesPlan.cs:702 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e38ff92c | FindButton 외 1 | DM0021_SalesPlan.cs:712 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f6a753a | FindButton 외 1 | DM0021_SalesPlan.cs:713 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-847df13c | FindButton 외 1 | DM0021_SalesPlan.cs:719 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-95d96755 | FindButton 외 1 | DM0021_SalesPlan.cs:721 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-abaf7ca8 | FindButton 외 1 | DM0021_SalesPlan.cs:723 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0793c9c5 | FindButton 외 1 | DM0021_SalesPlan.cs:727 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9efbf127 | FindButton 외 1 | DM0021_SalesPlan.cs:729 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4b51881 | FindButton 외 1 | DM0021_SalesPlan.cs:747 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f00ada6f | FindButton 외 1 | DM0021_SalesPlan.cs:748 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-050496fa | FindButton 외 1 | DM0021_SalesPlan.cs:752 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-db5333b5 | FindButton 외 1 | DM0021_SalesPlan.cs:762 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e57c0b57 | FindButton 외 1 | DM0021_SalesPlan.cs:763 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ae996674 | FindButton 외 1 | DM0021_SalesPlan.cs:768 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0021_GET_DM_PLN_SALES_PLAN_DATAEx") ⇒ DM.DM0021_GET_DM_PLN_SALES_PLAN_DATAEx | 엔드포인트 요청 생성 |  |  |  |
| AC-24d06067 | FindButton 외 1 | DM0021_SalesPlan.cs:769 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-583a654b | FindButton 외 1 | DM0021_SalesPlan.cs:770 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-942002b7 | FindButton 외 1 | DM0021_SalesPlan.cs:771 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-d1e140fc | FindButton 외 1 | DM0021_SalesPlan.cs:772 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-285cd0f0 | FindButton 외 1 | DM0021_SalesPlan.cs:773 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-64e934d5 | FindButton 외 1 | DM0021_SalesPlan.cs:774 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-c40abb27 | FindButton 외 1 | DM0021_SalesPlan.cs:775 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-699be419 | FindButton 외 1 | DM0021_SalesPlan.cs:778 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-cac7e42e | FindButton 외 1 | DM0021_SalesPlan.cs:779 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-fd760d0e | FindButton 외 1 | DM0021_SalesPlan.cs:780 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ed3e85df | FindButton 외 1 | DM0021_SalesPlan.cs:781 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5c8c7c9d | FindButton 외 1 | DM0021_SalesPlan.cs:782 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-222c4ad9 | FindButton 외 1 | DM0021_SalesPlan.cs:783 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-fff5a946 | FindButton 외 1 | DM0021_SalesPlan.cs:784 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-173f6e5c | FindButton 외 1 | DM0021_SalesPlan.cs:785 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-507fff59 | FindButton 외 1 | DM0021_SalesPlan.cs:787 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-22253a94 | FindButton 외 1 | DM0021_SalesPlan.cs:792 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d117bf1 | FindButton 외 1 | DM0021_SalesPlan.cs:798 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-86e78275 | FindButton 외 1 | DM0021_SalesPlan.cs:802 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-db9d0592 | FindButton 외 1 | DM0021_SalesPlan.cs:804 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7ec7319c | FindButton 외 1 | DM0021_SalesPlan.cs:805 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c7e7d8c | FindButton 외 1 | DM0021_SalesPlan.cs:809 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d34ce2a | FindButton 외 1 | DM0021_SalesPlan.cs:836 | try ▸ try ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-c60df661 | FindButton 외 1 | DM0021_SalesPlan.cs:837 | try ▸ try ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-33484f92 | FindButton 외 1 | DM0021_SalesPlan.cs:840 | try ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-df00d464 | FindButton 외 1 | DM0021_SalesPlan.cs:850 | try ▸ try ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_CODE) > 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-821ef5c0 | FindButton 외 1 | DM0021_SalesPlan.cs:863 | try ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-5807ba5e | FindButton 외 1 | DM0021_SalesPlan.cs:870 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a438e784 | FindButton 외 1 | DM0021_SalesPlan.cs:888 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (dtSave != null) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ac7765b4 | FindButton 외 1 | DM0021_SalesPlan.cs:892 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9be76da9 | FindButton 외 1 | DM0021_SalesPlan.cs:902 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-af4d3e0a | FindButton 외 1 | DM0021_SalesPlan.cs:903 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff8b9924 | FindButton 외 1 | DM0021_SalesPlan.cs:920 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c1b65a55 | FindButton 외 1 | DM0021_SalesPlan.cs:924 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-cf5bd2b8 | FindButton 외 1 | DM0021_SalesPlan.cs:928 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a6b8c1fb | FindButton 외 1 | DM0021_SalesPlan.cs:929 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ea333907 | FindButton 외 1 | DM0021_SalesPlan.cs:930 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0021_SalesPlan.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b53abcf | (진입점 미연결) | DM0021_SalesPlan.cs:2448 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-33d22efa | (진입점 미연결) | DM0021_SalesPlan.cs:2452 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-574833f6 | this.Load | DM0021_SalesPlan.cs:190 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-eeb42a53 | this.Load | DM0021_SalesPlan.cs:194 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0021_SalesPlan.GetBizTypebyDivision

진입점: this.clbDivision.SelectedIndexChanged [try] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a672740 | this.clbDivision.SelectedIndexChanged [try] 외 1 | DM0021_SalesPlan.cs:1853 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-32f88515 | this.clbDivision.SelectedIndexChanged [try] 외 1 | DM0021_SalesPlan.cs:1854 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1da087af | this.clbDivision.SelectedIndexChanged [try] 외 1 | DM0021_SalesPlan.cs:1855 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a6cf2e9c | this.clbDivision.SelectedIndexChanged [try] 외 1 | DM0021_SalesPlan.cs:1858 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetBizTypebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb1ac81f | (진입점 미연결) | DM0021_SalesPlan.cs:3009 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9f64b900 | (진입점 미연결) | DM0021_SalesPlan.cs:3010 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-90966611 | (진입점 미연결) | DM0021_SalesPlan.cs:3011 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b20d3451 | (진입점 미연결) | DM0021_SalesPlan.cs:3014 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-384fecdd | this.Load | DM0021_SalesPlan.cs:1796 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-71160982 | this.Load | DM0021_SalesPlan.cs:1797 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e360bd84 | this.Load | DM0021_SalesPlan.cs:1800 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetCellColor

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9f73fe3 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) … 외 1 | DM0021_SalesPlan.cs:2470 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0c85b1e | (진입점 미연결) | DM0021_SalesPlan.cs:1838 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b397336c | (진입점 미연결) | DM0021_SalesPlan.cs:1839 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-056d992e | (진입점 미연결) | DM0021_SalesPlan.cs:1840 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-5bd22aa2 | (진입점 미연결) | DM0021_SalesPlan.cs:1841 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4b94b9b | (진입점 미연결) | DM0021_SalesPlan.cs:1844 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a208dfc3 | (진입점 미연결) | DM0021_SalesPlan.cs:3048 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-82232326 | (진입점 미연결) | DM0021_SalesPlan.cs:3049 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-efb1d761 | (진입점 미연결) | DM0021_SalesPlan.cs:3050 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-8001fbb9 | (진입점 미연결) | DM0021_SalesPlan.cs:3051 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cd48ad98 | (진입점 미연결) | DM0021_SalesPlan.cs:3054 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b906c2b9 | (진입점 미연결) | DM0021_SalesPlan.cs:3135 | if (sfpInfo.SpreadObject.DataSource == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-0386b4b1 | (진입점 미연결) | DM0021_SalesPlan.cs:3140 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-606d6f7d | (진입점 미연결) | DM0021_SalesPlan.cs:3163 | for (i < sv.ColumnCount) ▸ if (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c41b7b63 | (진입점 미연결) | DM0021_SalesPlan.cs:3166 | for (i < sv.ColumnCount) ▸ else of (sFieldName.IndexOf("D_2") >= 0 \|\| sFieldName.IndexOf("W_2") >= 0 \|\| sFieldName.IndexOf("M_2") >= 0) | DATA_OP | table.Columns.Add | (sFieldName, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b8f4c9b | (진입점 미연결) | DM0021_SalesPlan.cs:3169 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ebcacef | (진입점 미연결) | DM0021_SalesPlan.cs:3173 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-75b38e97 | (진입점 미연결) | DM0021_SalesPlan.cs:3175 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2fac245 | this.Load | DM0021_SalesPlan.cs:1767 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-909ab7eb | this.Load | DM0021_SalesPlan.cs:1768 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-be2f7c12 | this.Load | DM0021_SalesPlan.cs:1769 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-a7431815 | this.Load | DM0021_SalesPlan.cs:1771 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee73b8d6 | this.Load | DM0021_SalesPlan.cs:1774 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa087c6e | (진입점 미연결) | DM0021_SalesPlan.cs:1737 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1e08e2b0 | (진입점 미연결) | DM0021_SalesPlan.cs:1739 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-840a48bd | (진입점 미연결) | DM0021_SalesPlan.cs:1742 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fa7f0f0 | (진입점 미연결) | DM0021_SalesPlan.cs:1867 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-872b0cad | (진입점 미연결) | DM0021_SalesPlan.cs:1868 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-11942927 | (진입점 미연결) | DM0021_SalesPlan.cs:1869 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-3f5c18e1 | (진입점 미연결) | DM0021_SalesPlan.cs:1870 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fa77e353 | (진입점 미연결) | DM0021_SalesPlan.cs:1873 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5ef68d3 | this.Load | DM0021_SalesPlan.cs:1809 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-91b0488f | this.Load | DM0021_SalesPlan.cs:1810 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-fda36dd6 | this.Load | DM0021_SalesPlan.cs:1811 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-613114a1 | this.Load | DM0021_SalesPlan.cs:1814 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f1a1f3a | (진입점 미연결) | DM0021_SalesPlan.cs:2615 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-1b501b8e | (진입점 미연결) | DM0021_SalesPlan.cs:2616 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a0a826bc | (진입점 미연결) | DM0021_SalesPlan.cs:2617 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-012b8eda | (진입점 미연결) | DM0021_SalesPlan.cs:2618 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-a98deee2 | (진입점 미연결) | DM0021_SalesPlan.cs:2619 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7762e733 | (진입점 미연결) | DM0021_SalesPlan.cs:2622 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58019a8e | (진입점 미연결) | DM0021_SalesPlan.cs:3070 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-7fade58c | (진입점 미연결) | DM0021_SalesPlan.cs:3071 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c61f185a | (진입점 미연결) | DM0021_SalesPlan.cs:3072 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-a94914ea | (진입점 미연결) | DM0021_SalesPlan.cs:3073 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-2837f2fa | (진입점 미연결) | DM0021_SalesPlan.cs:3074 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91f6bdc7 | (진입점 미연결) | DM0021_SalesPlan.cs:3077 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetSALESPLAN_MEASUREInfo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bb49da0 | this.Load | DM0021_SalesPlan.cs:1884 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-97a49aed | this.Load | DM0021_SalesPlan.cs:1886 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetSALESPLAN_MEASUREInfo2

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26449c7a | this.Load | DM0021_SalesPlan.cs:1899 |  | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12828280 | this.Load | DM0021_SalesPlan.cs:1901 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69b3412b | (진입점 미연결) | DM0021_SalesPlan.cs:1751 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2b69d8d7 | (진입점 미연결) | DM0021_SalesPlan.cs:1752 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b8aecee2 | (진입점 미연결) | DM0021_SalesPlan.cs:1753 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ef53e1dd | (진입점 미연결) | DM0021_SalesPlan.cs:1754 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-fd20a436 | (진입점 미연결) | DM0021_SalesPlan.cs:1755 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0280b239 | (진입점 미연결) | DM0021_SalesPlan.cs:1758 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31b9d86c | (진입점 미연결) | DM0021_SalesPlan.cs:3093 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-aaa3c55a | (진입점 미연결) | DM0021_SalesPlan.cs:3094 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dbfc4f17 | (진입점 미연결) | DM0021_SalesPlan.cs:3095 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f8da513e | (진입점 미연결) | DM0021_SalesPlan.cs:3096 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-7eccd818 | (진입점 미연결) | DM0021_SalesPlan.cs:3097 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fe391856 | (진입점 미연결) | DM0021_SalesPlan.cs:3100 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.Load [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / FindButton [try ▸ try ▸ else of (dt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24b043e4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:559 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0021_GET_SPREAD_TITLE") ⇒ DM_H.DM0021_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-7fa2d511 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:560 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-fb97eaff | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:561 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-eb93bd6b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:562 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-30fe29c9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:564 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-eba71abc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:564 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0dd82d7c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:567 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d338695 | (진입점 미연결) | DM0021_SalesPlan.cs:1824 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-0d9d7832 | (진입점 미연결) | DM0021_SalesPlan.cs:1825 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6844f4c7 | (진입점 미연결) | DM0021_SalesPlan.cs:1826 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-02c5c9ad | (진입점 미연결) | DM0021_SalesPlan.cs:1829 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdd79499 | (진입점 미연결) | DM0021_SalesPlan.cs:3029 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5ca07edf | (진입점 미연결) | DM0021_SalesPlan.cs:3030 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c40089bc | (진입점 미연결) | DM0021_SalesPlan.cs:3031 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-684257dd | (진입점 미연결) | DM0021_SalesPlan.cs:3033 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.GetThisWeekMonday

진입점: FindButton [try] / InsertButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71a09e8e | FindButton [try] 외 2 | DM0021_SalesPlan.cs:2643 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0021_SalesPlan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c9f2a4f | this.Load | DM0021_SalesPlan.cs:210 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-0fe469b7 | this.Load | DM0021_SalesPlan.cs:221 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-655023cd | this.Load | DM0021_SalesPlan.cs:221 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5cbe72d7 | this.Load | DM0021_SalesPlan.cs:222 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-32ffeab5 | this.Load | DM0021_SalesPlan.cs:225 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-558742ce | this.Load | DM0021_SalesPlan.cs:225 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-edf675f6 | this.Load | DM0021_SalesPlan.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-72e313db | this.Load | DM0021_SalesPlan.cs:237 |  | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e396a6a | this.Load | DM0021_SalesPlan.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8880d49b | this.Load | DM0021_SalesPlan.cs:240 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ddb165b0 | this.Load | DM0021_SalesPlan.cs:240 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b84381e3 | this.Load | DM0021_SalesPlan.cs:241 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02b65780 | this.Load | DM0021_SalesPlan.cs:249 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-61b9c0a7 | this.Load | DM0021_SalesPlan.cs:249 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d11bc966 | this.Load | DM0021_SalesPlan.cs:250 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ec6dac0f | this.Load | DM0021_SalesPlan.cs:252 |  | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-062d3056 | this.Load | DM0021_SalesPlan.cs:252 |  | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b577bf76 | this.Load | DM0021_SalesPlan.cs:253 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-de366689 | this.Load | DM0021_SalesPlan.cs:255 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b761eadb | this.Load | DM0021_SalesPlan.cs:256 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7cc72197 | this.Load | DM0021_SalesPlan.cs:266 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-985d7867 | this.Load | DM0021_SalesPlan.cs:267 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b60d85d | this.Load | DM0021_SalesPlan.cs:270 |  | FLAG | dtINCOTERMSType | (new CUIControl()).GetCommonDataUsingNickNameByDB2("INCOTERMS").Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-80bc74ea | this.Load | DM0021_SalesPlan.cs:270 |  | COMBO_DATA | (new CUIControl()).GetCommonDataUsingNickNameByDB2 | ("INCOTERMS") | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6e5e174b | this.Load | DM0021_SalesPlan.cs:272 |  | FLAG | dtITEM_ID | Data.Common(Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], Us… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-0284fa3d | this.Load | DM0021_SalesPlan.cs:272 |  | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_ITEM_ID, false, UserInfoContext.Current["NowGroupID"], UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_ITEM_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d19b104 | this.Load | DM0021_SalesPlan.cs:275 |  | FLAG | dtCurrencyList | Data.Common(Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInf… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 화면 필드/플래그 변경 |  |  |  |
| AC-9b179d84 | this.Load | DM0021_SalesPlan.cs:275 |  | COMBO_DATA | Data.Common | (Data.Type.CURRENCY_LIST, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=CURRENCY_LIST] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1e724509 | this.Load | DM0021_SalesPlan.cs:278 |  | FLAG | dtMearsure | GetSALESPLAN_MEASUREInfo() | 화면 필드/플래그 변경 |  |  |  |
| AC-84974d0b | this.Load | DM0021_SalesPlan.cs:279 |  | FLAG | dtMearsure2 | GetSALESPLAN_MEASUREInfo2() | 화면 필드/플래그 변경 |  |  |  |

## DM0021_SalesPlan.InitSaveDataTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79163cfc | (진입점 미연결) | DM0021_SalesPlan.cs:2356 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-a25da0ba | (진입점 미연결) | DM0021_SalesPlan.cs:2357 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e40a835 | (진입점 미연결) | DM0021_SalesPlan.cs:2358 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PROJECT_CODE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff4967b4 | (진입점 미연결) | DM0021_SalesPlan.cs:2359 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.SCM_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e66632e | (진입점 미연결) | DM0021_SalesPlan.cs:2360 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ITEM_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-96c0bcc6 | (진입점 미연결) | DM0021_SalesPlan.cs:2361 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0533b06b | (진입점 미연결) | DM0021_SalesPlan.cs:2362 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.INCOTERMS, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-17268983 | (진입점 미연결) | DM0021_SalesPlan.cs:2363 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18c3c080 | (진입점 미연결) | DM0021_SalesPlan.cs:2364 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MEASURE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea2c4da3 | (진입점 미연결) | DM0021_SalesPlan.cs:2365 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2894648c | (진입점 미연결) | DM0021_SalesPlan.cs:2366 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## DM0021_SalesPlan.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (blnInsert) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c241fab0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:372 | try ▸ if (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6dbcb3b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:377 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-feb59b66 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:378 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-c298a423 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:382 | try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-2d13db4a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:390 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DM0021_SalesPlan.InitSpread_X

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.Load [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / FindButton [try ▸ try ▸ else of (dt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0e2f74a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:423 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33c590a7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:442 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-3c20646c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:443 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-ee19f937 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:444 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4c61d768 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:446 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0021_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0021_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d6b3c61 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:446 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0021_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-f9bfd585 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:468 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14bf31a2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:470 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef24a9d2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:482 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-242e6fb2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:493 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29441e32 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:498 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d9f5668 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:500 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6aacbe55 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:508 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow - 1, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-562c083c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:515 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44ac0bef | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:523 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_DAY"].ToString(), dt.Rows[i]["BASIS_YYYYMMDD"].ToString(), FPMerge.N… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e232231 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:525 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-d72619cd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:527 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SUN") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-76244f76 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:536 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-720847fb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:543 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-669b9a68 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0021_SalesPlan.cs:549 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0021_SalesPlan.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93efdf7a | InsertButton | DM0021_SalesPlan.cs:1554 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-132d127d | InsertButton | DM0021_SalesPlan.cs:1558 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2f17a775 | InsertButton | DM0021_SalesPlan.cs:1559 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-82450e2c | InsertButton | DM0021_SalesPlan.cs:1560 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-536d5d4a | InsertButton | DM0021_SalesPlan.cs:1562 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2a723ae9 | InsertButton | DM0021_SalesPlan.cs:1564 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f43bfc9b | InsertButton | DM0021_SalesPlan.cs:1566 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-88860369 | InsertButton | DM0021_SalesPlan.cs:1571 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), dtMearsure2) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e6ef55c7 | InsertButton | DM0021_SalesPlan.cs:1572 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.MEASURE), "SalesAmt_LOC") | 그리드 값 설정 |  |  |  |
| AC-dcb9f33c | InsertButton | DM0021_SalesPlan.cs:1573 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-47c675d8 | InsertButton | DM0021_SalesPlan.cs:1576 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ab952395 | InsertButton | DM0021_SalesPlan.cs:1581 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b742e371 | InsertButton | DM0021_SalesPlan.cs:1586 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), "ETC") | 그리드 값 설정 |  |  |  |
| AC-2eeba0f6 | InsertButton | DM0021_SalesPlan.cs:1587 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc1b84df | InsertButton | DM0021_SalesPlan.cs:1598 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_INCHARGE), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-90b19b13 | InsertButton | DM0021_SalesPlan.cs:1601 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f4c75eb6 | InsertButton | DM0021_SalesPlan.cs:1603 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-30a5533b | InsertButton | DM0021_SalesPlan.cs:1605 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), siMain.ActiveRowI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-05159882 | InsertButton | DM0021_SalesPlan.cs:1608 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BizTypeName), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-107cdb51 | InsertButton | DM0021_SalesPlan.cs:1612 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e9039b46 | InsertButton | DM0021_SalesPlan.cs:1614 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_NAME), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-457930a1 | InsertButton | DM0021_SalesPlan.cs:1617 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemType), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b1cb588 | InsertButton | DM0021_SalesPlan.cs:1619 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.NickName), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f11fe078 | InsertButton | DM0021_SalesPlan.cs:1624 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (insCell.Row.Index, siMain.GetColumnIndex(DefColumns.CURRENCY), dtCurrencyList) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bb6fac16 | InsertButton | DM0021_SalesPlan.cs:1627 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), siMain.Act… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e696c712 | InsertButton | DM0021_SalesPlan.cs:1629 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.INCOTERMS), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0f3159f | InsertButton | DM0021_SalesPlan.cs:1652 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxC… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, i, siMain.ActiveRowIndex, i, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cf540912 | InsertButton | DM0021_SalesPlan.cs:1660 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnInde… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8145af3d | InsertButton | DM0021_SalesPlan.cs:1717 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DM0021_SalesPlan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07c4f724 | SaveButton | DM0021_SalesPlan.cs:1146 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06dc3f8d | SaveButton | DM0021_SalesPlan.cs:1147 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2e7cee5 | SaveButton | DM0021_SalesPlan.cs:1150 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e8327ff4 | SaveButton | DM0021_SalesPlan.cs:1154 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c481972 | SaveButton | DM0021_SalesPlan.cs:1173 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetColumnIndex(DefColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-178dd1f5 | SaveButton | DM0021_SalesPlan.cs:1174 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetColumnIndex(DefColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58ce28ab | SaveButton | DM0021_SalesPlan.cs:1258 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9f89789 | SaveButton | DM0021_SalesPlan.cs:1261 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| … | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-813a4f59 | SaveButton | DM0021_SalesPlan.cs:1263 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2f22554 | SaveButton | DM0021_SalesPlan.cs:1301 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try | DATA_OP | dr.Field | ("ACTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-00621288 | SaveButton | DM0021_SalesPlan.cs:1302 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try | DATA_OP | dr.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-185e0534 | SaveButton | DM0021_SalesPlan.cs:1303 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try | DATA_OP | dr.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-376b78dd | SaveButton | DM0021_SalesPlan.cs:1306 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try | DATA_OP | dr.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcff4cdd | SaveButton | DM0021_SalesPlan.cs:1307 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try | DATA_OP | dr.Field | ("CURRENCY") | 데이터 객체 조작/조회 |  |  |  |
| AC-44b335a5 | SaveButton | DM0021_SalesPlan.cs:1308 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try | DATA_OP | dr.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4f9ec89 | SaveButton | DM0021_SalesPlan.cs:1319 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try ▸ foreach (Dat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { msg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f1e39b1 | SaveButton | DM0021_SalesPlan.cs:1322 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try ▸ foreach (Dat… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-755c05ef | SaveButton | DM0021_SalesPlan.cs:1323 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ try ▸ foreach (Dat… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63037e1c | SaveButton | DM0021_SalesPlan.cs:1456 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e9d98e38 | SaveButton | DM0021_SalesPlan.cs:1457 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-1b90b842 | SaveButton | DM0021_SalesPlan.cs:1458 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-f780d7f4 | SaveButton | DM0021_SalesPlan.cs:1459 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-69be5946 | SaveButton | DM0021_SalesPlan.cs:1460 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], sPLANT_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2007822a | SaveButton | DM0021_SalesPlan.cs:1461 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-89cfced3 | SaveButton | DM0021_SalesPlan.cs:1462 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], p_DOM_EXP, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b577874e | SaveButton | DM0021_SalesPlan.cs:1463 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], p_FCST_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d604e6d6 | SaveButton | DM0021_SalesPlan.cs:1464 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-4880eb9b | SaveButton | DM0021_SalesPlan.cs:1465 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], p_MEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-5dab3cc2 | SaveButton | DM0021_SalesPlan.cs:1466 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-78fc4471 | SaveButton | DM0021_SalesPlan.cs:1467 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_QTY"] | CString.AppendStringEx(nvc["p_QTY"], sPRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-b35d84bc | SaveButton | DM0021_SalesPlan.cs:1468 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CURRENCY"] | CString.AppendStringEx(nvc["p_CURRENCY"], sCURRENCY, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-bce9b1f8 | SaveButton | DM0021_SalesPlan.cs:1469 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-e629c3b5 | SaveButton | DM0021_SalesPlan.cs:1470 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-fbc926f3 | SaveButton | DM0021_SalesPlan.cs:1489 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iDateCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00146", new object[] { i + 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b830d353 | SaveButton | DM0021_SalesPlan.cs:1490 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iDateCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4894ebbe | SaveButton | DM0021_SalesPlan.cs:1509 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0021_SAVE_DM_PLN_SALES_PLAN_ALL", nvc) ⇒ DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 호출 |  |  |  |
| AC-ebf76055 | SaveButton | DM0021_SalesPlan.cs:1509 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-f0a7959d | SaveButton | DM0021_SalesPlan.cs:1514 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (ds.Tables[0].Rows[0][0].ToString(), "Error!") | 메시지 표시 |  |  |  |
| AC-4255702e | SaveButton | DM0021_SalesPlan.cs:1515 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce0df2a5 | SaveButton | DM0021_SalesPlan.cs:1519 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a345f8d1 | SaveButton | DM0021_SalesPlan.cs:1522 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-745d4919 | SaveButton | DM0021_SalesPlan.cs:1533 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-300e0ad0 | SaveButton | DM0021_SalesPlan.cs:1534 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-fbbe0d3a | SaveButton | DM0021_SalesPlan.cs:1539 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DM0021_SalesPlan.SaveData_All

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6758009c | (진입점 미연결) | DM0021_SalesPlan.cs:938 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7f6a32e | (진입점 미연결) | DM0021_SalesPlan.cs:977 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| sSCM_S… | MESSAGE | MessageBox.Show | (sMsg, "Warining!") | 메시지 표시 |  |  |  |
| AC-6971526b | (진입점 미연결) | DM0021_SalesPlan.cs:980 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| sSCM_S… | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-cf800adc | (진입점 미연결) | DM0021_SalesPlan.cs:982 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDIVISION_ID == "" \|\| sPROJECT_CODE == "" \|\| sSCM_S… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-794bcc8e | (진입점 미연결) | DM0021_SalesPlan.cs:1003 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dsSpread.Tables[0].Select | (sWhere) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b4211ae | (진입점 미연결) | DM0021_SalesPlan.cs:1007 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rows.Length > 0) | MESSAGE | MessageBox.Show | ("It happened a Duplication. Informatoin : " + sWhere, "Error!") | 메시지 표시 |  |  |  |
| AC-efc4dac2 | (진입점 미연결) | DM0021_SalesPlan.cs:1010 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rows.Length > 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (i, 2) | 그리드 표시 설정 |  |  |  |
| AC-4accf0f5 | (진입점 미연결) | DM0021_SalesPlan.cs:1011 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ if (rows.Length > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-defc5f17 | (진입점 미연결) | DM0021_SalesPlan.cs:1083 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_active_flag"] | CString.AppendStringEx(nvc["p_active_flag"], stempAction, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d4ad1782 | (진입점 미연결) | DM0021_SalesPlan.cs:1084 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DIVISION_ID"] | CString.AppendStringEx(nvc["p_DIVISION_ID"], sDIVISION_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-2ec90755 | (진입점 미연결) | DM0021_SalesPlan.cs:1085 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PROJECT_CODE"] | CString.AppendStringEx(nvc["p_PROJECT_CODE"], sPROJECT_CODE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-ab945440 | (진입점 미연결) | DM0021_SalesPlan.cs:1086 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_SCM_SITE_ID"] | CString.AppendStringEx(nvc["p_SCM_SITE_ID"], sSCM_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-0e8fc599 | (진입점 미연결) | DM0021_SalesPlan.cs:1087 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_PLANT_SITE_ID"] | CString.AppendStringEx(nvc["p_PLANT_SITE_ID"], sPLANT_SITE_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-07ffea06 | (진입점 미연결) | DM0021_SalesPlan.cs:1088 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_ITEM_ID"] | CString.AppendStringEx(nvc["p_ITEM_ID"], sITEM_ID, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-4524c597 | (진입점 미연결) | DM0021_SalesPlan.cs:1089 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_DOM_EXP"] | CString.AppendStringEx(nvc["p_DOM_EXP"], p_DOM_EXP, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-92f95850 | (진입점 미연결) | DM0021_SalesPlan.cs:1090 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_FCST_TYPE"] | CString.AppendStringEx(nvc["p_FCST_TYPE"], p_FCST_TYPE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-be1a3aeb | (진입점 미연결) | DM0021_SalesPlan.cs:1091 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_INCOTERMS"] | CString.AppendStringEx(nvc["p_INCOTERMS"], sINCOTERMS, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-67a613d0 | (진입점 미연결) | DM0021_SalesPlan.cs:1092 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_MEASURE"] | CString.AppendStringEx(nvc["p_MEASURE"], p_MEASURE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-bd4547e7 | (진입점 미연결) | DM0021_SalesPlan.cs:1093 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_YYYYMMDD"] | CString.AppendStringEx(nvc["p_YYYYMMDD"], sYYYYMMDD, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-5ccbf37b | (진입점 미연결) | DM0021_SalesPlan.cs:1094 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_QTY"] | CString.AppendStringEx(nvc["p_QTY"], sPRICE, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-7f91f864 | (진입점 미연결) | DM0021_SalesPlan.cs:1095 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CREATED_BY"] | CString.AppendStringEx(nvc["p_CREATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-311fde33 | (진입점 미연결) | DM0021_SalesPlan.cs:1096 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_CREATION_DATE"] | CString.AppendStringEx(nvc["p_CREATION_DATE"], System.DateTime.Now.ToString(), iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-3a168269 | (진입점 미연결) | DM0021_SalesPlan.cs:1097 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) | DATA_OP | nvc["p_LAST_UPDATED_BY"] | CString.AppendStringEx(nvc["p_LAST_UPDATED_BY"], UserInfoContext.Current.UserId, iCUD) | 행/컬럼 값 대입 |  |  |  |
| AC-d253cf22 | (진입점 미연결) | DM0021_SalesPlan.cs:1108 | if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex()) ▸ if ((j % 20) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-cfaa2437 | (진입점 미연결) | DM0021_SalesPlan.cs:1115 | if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0021_SAVE_DM_PLN_SALES_PLAN_ALL", nvc) ⇒ DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 호출 |  |  |  |
| AC-a82718ba | (진입점 미연결) | DM0021_SalesPlan.cs:1115 | if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0021_SAVE_DM_PLN_SALES_PLAN_ALL | 엔드포인트 요청 생성 |  |  |  |
| AC-63a87b52 | (진입점 미연결) | DM0021_SalesPlan.cs:1120 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | MESSAGE | MessageBox.Show | (ds.Tables[0].Rows[0][1].ToString(), "Error!") | 메시지 표시 |  |  |  |
| AC-c233c8d1 | (진입점 미연결) | DM0021_SalesPlan.cs:1121 | if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sResultMsg != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e82df42e | (진입점 미연결) | DM0021_SalesPlan.cs:1125 | if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0021_SalesPlan.SetSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e23d57de | (진입점 미연결) | DM0021_SalesPlan.cs:2382 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef2ea84d | (진입점 미연결) | DM0021_SalesPlan.cs:2386 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0425768c | (진입점 미연결) | DM0021_SalesPlan.cs:2387 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DIVISION_ID] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-67b9a0fa | (진입점 미연결) | DM0021_SalesPlan.cs:2388 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PROJECT_CODE] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-fed2b9f4 | (진입점 미연결) | DM0021_SalesPlan.cs:2389 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SCM_SITE_ID] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-f83c76c3 | (진입점 미연결) | DM0021_SalesPlan.cs:2390 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ITEM_ID] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-dc4ec269 | (진입점 미연결) | DM0021_SalesPlan.cs:2391 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-0daf2a67 | (진입점 미연결) | DM0021_SalesPlan.cs:2392 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-f8257e67 | (진입점 미연결) | DM0021_SalesPlan.cs:2393 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.INCOTERMS] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-96e39fba | (진입점 미연결) | DM0021_SalesPlan.cs:2394 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MEASURE] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-c886c21c | (진입점 미연결) | DM0021_SalesPlan.cs:2395 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-053c5a32 | (진입점 미연결) | DM0021_SalesPlan.cs:2396 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-5070f02e | (진입점 미연결) | DM0021_SalesPlan.cs:2398 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-82da0930 | (진입점 미연결) | DM0021_SalesPlan.cs:2399 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d491a024 | (진입점 미연결) | DM0021_SalesPlan.cs:2403 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-2a3769f7 | (진입점 미연결) | DM0021_SalesPlan.cs:2404 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0021_SalesPlan.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpPe…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else of (dtStartPeriod.ToString("yyyyMMdd") == drpPerio…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f72aae8 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DM0021_SalesPlan.cs:1970 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ad9d5e9c | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DM0021_SalesPlan.cs:1975 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-cb8f6e42 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DM0021_SalesPlan.cs:1982 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4abf4ff1 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DM0021_SalesPlan.cs:1986 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5d6e9071 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DM0021_SalesPlan.cs:1991 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ef541021 | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DM0021_SalesPlan.cs:1998 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-92c4f8ef | this.chkSum.CheckedChanged [if (siMain != null)] 외 6 | DM0021_SalesPlan.cs:2002 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DM0021_SalesPlan.SetSpreadColumn2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da404c00 | (진입점 미연결) | DM0021_SalesPlan.cs:2551 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-dec24ee3 | (진입점 미연결) | DM0021_SalesPlan.cs:2556 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-297862aa | (진입점 미연결) | DM0021_SalesPlan.cs:2563 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-973ee018 | (진입점 미연결) | DM0021_SalesPlan.cs:2567 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9839f700 | (진입점 미연결) | DM0021_SalesPlan.cs:2572 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0ff45939 | (진입점 미연결) | DM0021_SalesPlan.cs:2579 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## DM0021_SalesPlan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0dc3836 | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2018 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-401feafc | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2024 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-cbfd7c4f | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2040 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-2889dcbe | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2054 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35caa062 | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2093 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-580566b6 | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2094 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-237ae3eb | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2095 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-247f6103 | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2096 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ba23ca81 | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2114 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-95886beb | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2116 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-fe72913f | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2118 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), popProject.ProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-7f93367a | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2121 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizTypeName), popProject.BizTypeName) | 그리드 값 설정 |  |  |  |
| AC-77a4f9d5 | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2123 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), popProject.ProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-49196edc | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2128 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-f2f62ff9 | this.spdMain.CellDoubleClick | DM0021_SalesPlan.cs:2130 | else of (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJECT_NAME)) \|\| siM… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |

## DM0021_SalesPlan.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f9f8c8f | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2661 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-8f2ff9dc | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2661 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e121fb8 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2662 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-92e0cb39 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2669 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-ea2b32a1 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2669 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75ae398d | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2670 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-98d998c4 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2678 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-762f7d63 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2678 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-435417f5 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2679 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-74fa75fb | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2684 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-e769d8e3 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2684 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-856e4f56 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2685 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dcda90a4 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2695 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-31f71425 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2697 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), e.Row, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-86d70550 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2704 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '82' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7bca2437 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2704 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '82' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-03bb6dc8 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2704 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '82' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b47701a | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2706 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '81' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-32489054 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2706 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '81' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-baf6569b | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2706 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '81' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-d76a7962 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2708 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), dtITEM_ID.Select(@" GUBUN = '40' ").Cop… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a4017b98 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2708 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select(@" GUBUN = '40' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-da29d109 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2708 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | DATA_OP | dtITEM_ID.Select | (@" GUBUN = '40' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c49eb7f | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2713 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ffdb34da | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2715 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-539fc4a9 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2717 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-b1530b23 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2719 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-6e1b59e5 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2721 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-75920250 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2723 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-4f38117a | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2725 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-1df1dfe2 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2732 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-52417543 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2732 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f0f1e16c | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2733 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3f57a703 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2737 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-0f45fe63 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2737 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d133756a | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2738 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5cc10f03 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2744 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-4b2b6353 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2746 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-9fd2a2dd | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2748 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-66313e86 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2750 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-3915c26f | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2752 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-f15a9d59 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2754 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-e9724869 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2760 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-5541e6b0 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2760 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbffff83 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2761 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9ce6c0fd | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2777 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-1cdd95ef | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2779 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-9a722454 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2781 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-5d25ff7d | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2783 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-2468dafd | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2785 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-f2ebbcda | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2794 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-6e5ba25a | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2796 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-e2d8d33a | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2798 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-e0aea999 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2800 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-621e4203 | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2805 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | DATA_OP | dtITEM_ID.Select | ("CODE = '" + sModelCode.Trim() + "' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-30523b1f | this.spdMain.ComboSelChange | DM0021_SalesPlan.cs:2812 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelName) | 그리드 값 설정 |  |  |  |

## DM0021_SalesPlan.spdMain_EnterCell

진입점: this.spdMain.EnterCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82b6e4e2 | this.spdMain.EnterCell | DM0021_SalesPlan.cs:2482 | if (siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) | FLAG | sOrigianlValue | sText == "" ? "0" : sText | 화면 필드/플래그 변경 |  |  |  |

## DM0021_SalesPlan.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a64a4ed | this.spdMain.KeyUp | DM0021_SalesPlan.cs:3211 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b318baa | this.spdMain.KeyUp | DM0021_SalesPlan.cs:3215 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f8d5420 | this.spdMain.KeyUp | DM0021_SalesPlan.cs:3221 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-021b9426 | this.spdMain.KeyUp | DM0021_SalesPlan.cs:3222 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0021_SalesPlan.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8d29dae | this.spdMain.TopChange | DM0021_SalesPlan.cs:1942 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f95aaff6 | this.btnButtonList.UsrButtonList_Click_Detected | DM0021_SalesPlanVersionCutOffPopUp.cs:417 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-001629b7 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:156 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a0725344 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:157 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e82758e5 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:158 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da99522a | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:149 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eec38d8 | DeleteButton | DM0021_SalesPlanVersionCutOffPopUp.cs:203 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2194c283 | Dispose | DM0021_SalesPlanVersionCutOffPopUp.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e0f66fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:263 |  | DATA_OP | nvc["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-48395b35 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:264 |  | DATA_OP | nvc["p_version_description"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-61be5062 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:265 |  | DATA_OP | nvc["p_version_type"] | txtType.Text | 행/컬럼 값 대입 |  |  |  |
| AC-658bda5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:266 |  | DATA_OP | nvc["p_from_yyyymmdd"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-23b7f709 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:267 |  | DATA_OP | nvc["p_to_yyyymmdd"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9646ca80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:268 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6a2762d5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:269 |  | ENDPOINT | (new CUIControl()).GetAsyncDataUsingByDB | (this, "DM0021_GET_DM_MST_VERSION", nvc) ⇒ DM_H.DM0021_GET_DM_MST_VERSION | 엔드포인트 호출 |  |  |  |
| AC-6b5187ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:269 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0021_GET_DM_MST_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-b969e279 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:271 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ac0eaee8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:272 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a449f27 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:275 |  | GRID_BIND | siMain.Query | (CUIControl.GetDatatableFromSpread(siMain, "")) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4f44f723 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:275 |  | ENDPOINT | CUIControl.GetDatatableFromSpread | (siMain, "") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5581f0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:280 |  | DATA_OP | dsSpread.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9ce2ddfb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:288 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3cc6ed3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:291 |  | CALL_EXT | CUIControl.SetPreferredWidth | (siMain.SpreadObject) | ⚠ 의미 확인 필요 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fccdaf1 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-21f20eb1 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:105 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |
| AC-7eeffd52 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:107 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d3e833b | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:140 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a9cab863 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:141 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9ff21da8 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:141 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3de3fb44 | this.Load | DM0021_SalesPlanVersionCutOffPopUp.cs:142 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-774575fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:165 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-4dbea2b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:167 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-db54b6c7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:168 |  | GRID_INIT | siMain.AddComboColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.Restricted, 120, true, dtDivision, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89293064 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:169 |  | GRID_INIT | siMain.AddTextColumn | ("Version NO", DefColumns.VERSION_NO, FPMerge.Restricted, 120, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04bf02c5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:170 |  | GRID_INIT | siMain.AddTextColumn | ("Type", DefColumns.VERSION_TYPE, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1092968e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:172 |  | GRID_INIT | siMain.AddTextColumn | ("Description", DefColumns.VERSION_DESCRIPTION, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d958aa73 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:173 |  | GRID_INIT | siMain.AddTextColumn | ("yyyyMMdd", DefColumns.YYYYMMDD, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0bfb3fcf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:175 |  | GRID_INIT | siMain.AddTextColumn | ("Ver Seq", DefColumns.VER_CRE_SEQ, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8476c27c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:176 |  | GRID_INIT | siMain.AddTextColumn | ("Update By", DefColumns.LAST_UPDATED_BY, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a2dc426 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:177 |  | GRID_INIT | siMain.AddTextColumn | ("Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.Restricted, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e684039c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:179 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4d98377 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | DM0021_SalesPlanVersionCutOffPopUp.cs:182 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b771b1a | (진입점 미연결) | DM0021_SalesPlanVersionCutOffPopUp.cs:118 |  | VALUE_SET | this.Text | "Ver. Cut-Off [" + sVersion_Type + "]" | 컨트롤 값 설정 |  |  |  |
| AC-59da01cf | (진입점 미연결) | DM0021_SalesPlanVersionCutOffPopUp.cs:120 |  | FLAG | this.sVersion_Type | sVersion_Type | 화면 필드/플래그 변경 |  |  |  |
| AC-a1698307 | (진입점 미연결) | DM0021_SalesPlanVersionCutOffPopUp.cs:121 |  | VALUE_SET | txtType.Text | sVersion_Type | 컨트롤 값 설정 |  |  |  |
| AC-ef78b22c | (진입점 미연결) | DM0021_SalesPlanVersionCutOffPopUp.cs:122 |  | FLAG | this.sFoxData | sFoxData | 화면 필드/플래그 변경 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.mOK

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90e34047 | (진입점 미연결) | DM0021_SalesPlanVersionCutOffPopUp.cs:430 |  | FLAG | blnOK | true | 화면 필드/플래그 변경 |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Confirm:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75860740 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:314 | if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9519e43 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:323 | for (i < asDivision.Length) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sPlanBinding)) … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88851b0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:327 | for (i < asDivision.Length) ▸ lambda | ENDPOINT | new FoxDataRequest | (sFoxData) ⇒ DM_H.PR_DM_PLN_SALES_PLAN_CUTOFF \| {?DM0021_SalesPlanVersionCutOffPopUp.sFoxDat… | 엔드포인트 요청 생성 |  |  |  |
| AC-96e3ad79 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:328 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | asDivision[i] | 행/컬럼 값 대입 |  |  |  |
| AC-19015fad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:329 | for (i < asDivision.Length) ▸ lambda | DATA_OP | request.Parameters["p_version_description"] | p_version_description | 행/컬럼 값 대입 |  |  |  |
| AC-6a713c92 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:330 | for (i < asDivision.Length) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c8ee7f5f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:332 | for (i < asDivision.Length) ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d0efff36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DM0021_SalesPlanVersionCutOffPopUp.cs:345 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00143", new object[] { p_division_id, sRMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0021_SalesPlanVersionCutOffPopUp.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0860e9eb | this.spdMain.TopChange | DM0021_SalesPlanVersionCutOffPopUp.cs:436 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

