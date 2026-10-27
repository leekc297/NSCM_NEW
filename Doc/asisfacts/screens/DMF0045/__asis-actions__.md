# AS-IS 액션 대조표 — DMF0045

> 원천: `Doc/asisfacts/screens/DMF0045/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 389행 · 메서드 35 · 종류 GRID_SET 72 · DATA_OP 67 · FLAG 29 · RETURN 23 · POPUP 22 · COMBO_DATA 22 · GRID_INIT 22 · UI_PROP 20 · MESSAGE 18 · GRID_LOCK 16 · CALL_EXT 14 · GRID_STYLE 14 · LIST_REBIND 13 · ENDPOINT 13 · UI_MISC 12 · VALUE_SET 5 · GRID_COMBO 4 · GRID_BIND 1 · STATE_RESET 1 · VALIDATE 1 · ⚠ 의미 확인 필요 14


## DMF0045_ShipmentRequest.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33d81dba | this.btnColumn.Click | DMF0045_ShipmentRequest.cs:2122 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF0045", SpdSheet.shtPack, true) | 팝업/폼 생성 |  |  |  |
| AC-1dd8134a | this.btnColumn.Click | DMF0045_ShipmentRequest.cs:2123 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-61e27e28 | this.btnColumn.Click | DMF0045_ShipmentRequest.cs:2124 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0045_ShipmentRequest.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d4dd7cd | this.btnItemId.Click | DMF0045_ShipmentRequest.cs:2107 |  | POPUP | new DMF0047_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e6cdf5de | this.btnItemId.Click | DMF0045_ShipmentRequest.cs:2108 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId, sBizType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d203d321 | this.btnItemId.Click | DMF0045_ShipmentRequest.cs:2109 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7bf29a2b | this.btnItemId.Click | DMF0045_ShipmentRequest.cs:2110 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-27d59268 | this.btnItemId.Click | DMF0045_ShipmentRequest.cs:2116 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0045_ShipmentRequest.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff85de30 | this.btnMeasure.Click | DMF0045_ShipmentRequest.cs:2293 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0045", strSheetName, false) | 팝업/폼 생성 |  |  |  |
| AC-a0ebf04c | this.btnMeasure.Click | DMF0045_ShipmentRequest.cs:2295 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e2d31fd2 | this.btnMeasure.Click | DMF0045_ShipmentRequest.cs:2296 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0045_ShipmentRequest.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f3b9de0 | this.btnProject.Click | DMF0045_ShipmentRequest.cs:2083 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-3da905b1 | this.btnProject.Click | DMF0045_ShipmentRequest.cs:2085 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c3177054 | this.btnProject.Click | DMF0045_ShipmentRequest.cs:2086 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c9e6b542 | this.btnProject.Click | DMF0045_ShipmentRequest.cs:2087 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e2cf5af6 | this.btnProject.Click | DMF0045_ShipmentRequest.cs:2093 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0045_ShipmentRequest.cboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-104cf928 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1094 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-d9538804 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1094 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07905b50 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1095 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-50476569 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1099 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1ffd1773 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1099 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f05d80c | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1100 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-455101ef | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1104 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6cec2558 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1104 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aaedfb7f | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1105 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-25ef5800 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1107 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-ca6b9be0 | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1107 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d9a006ea | this.cboDivision.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1108 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0045_ShipmentRequest.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6677a5b8 | this.clbCustomer.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1128 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-18127ad2 | this.clbCustomer.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1128 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aef122d1 | this.clbCustomer.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1129 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0045_ShipmentRequest.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deb78932 | this.clbTeam.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1116 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3ecaaaaa | this.clbTeam.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1116 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-719d75c6 | this.clbTeam.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1117 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-55a3b088 | this.clbTeam.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1120 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-47c5afb8 | this.clbTeam.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1120 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fd29713 | this.clbTeam.SelectedIndexChanged | DMF0045_ShipmentRequest.cs:1121 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0045_ShipmentRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91b0efcd | this.Load | DMF0045_ShipmentRequest.cs:255 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPack, SpdSheet.shtPack, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-41d16277 | this.Load | DMF0045_ShipmentRequest.cs:256 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPack) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2a53f36 | this.Load | DMF0045_ShipmentRequest.cs:257 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70514ee7 | this.Load | DMF0045_ShipmentRequest.cs:260 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtCell, SpdSheet.shtCell, 3, 1, 40) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a5855578 | this.Load | DMF0045_ShipmentRequest.cs:261 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtCell) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac6f0bee | this.Load | DMF0045_ShipmentRequest.cs:262 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtCell) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b512070f | this.Load | DMF0045_ShipmentRequest.cs:265 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPack) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0045_ShipmentRequest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bee51d6 | this.Load | DMF0045_ShipmentRequest.cs:240 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-7b873fcb | this.Load | DMF0045_ShipmentRequest.cs:241 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-9e1d7b99 | this.Load | DMF0045_ShipmentRequest.cs:243 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-883e6ff6 | this.Load | DMF0045_ShipmentRequest.cs:244 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-1a2bf33e | this.Load | DMF0045_ShipmentRequest.cs:245 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-6e03d840 | this.Load | DMF0045_ShipmentRequest.cs:246 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-a596aa23 | this.Load | DMF0045_ShipmentRequest.cs:249 |  | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0045_ShipmentRequest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-723fa0c1 | DeleteButton | DMF0045_ShipmentRequest.cs:435 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0045_ShipmentRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73e5daf8 | Dispose | DMF0045_ShipmentRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0045_ShipmentRequest.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45cc3fa0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:443 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1cc41422 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:444 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-32e92da0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:446 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.Requestor), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a381fe5d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:453 | if (this.fps != null) | CALL_EXT | fps.ActiveSheet.Columns.Get | (fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a6f1c90 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:453 | if (this.fps != null) | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7befe59d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:456 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Requestor) + 1, siMain.ActiveSheet.RowCount - 1, siMa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eebebbaf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:463 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99fa0480 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:486 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-67667f7d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:490 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 표시 설정 |  |  |  |
| AC-d1d6cae6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:502 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | GRID_STYLE | siMain.SetBGColor | (iRow, iFrom, iRow, iTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-7d36be75 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:505 | if (this.fps != null) ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == f… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76304a49 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:515 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ToSite)).ToString… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7924f54 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:539 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e7488aff | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:540 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-9421b1fa | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:545 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol + FrozenCnt + 1, iRow, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad5481a6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:550 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.FcstType), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-18c14866 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:551 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(DefColu… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.FcstType), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 표시 설정 |  |  |  |
| AC-94262e7c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:556 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) ▸ else of (siMain.GetText(iRow, siMain.GetColumnIndex(De… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol + FrozenCnt + 1, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ffc4e8f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DMF0045_ShipmentRequest.cs:561 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (FrozenCnt != 0) | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0045_ShipmentRequest.FindData

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78d1d0dd | FindButton 외 1 | DMF0045_ShipmentRequest.cs:579 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-6157761c | FindButton 외 1 | DMF0045_ShipmentRequest.cs:579 |  | COMBO_DATA | Data.Common | (Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e313818 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:581 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-81fdd34c | FindButton 외 1 | DMF0045_ShipmentRequest.cs:589 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dfc55e1a | FindButton 외 1 | DMF0045_ShipmentRequest.cs:590 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff608c94 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:594 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4004fa8a | FindButton 외 1 | DMF0045_ShipmentRequest.cs:599 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7abbd404 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:605 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42495fa6 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:609 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0045_GET_SHIPMENT_REQUEST") ⇒ DM.DMF0045_GET_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-48876b5c | FindButton 외 1 | DMF0045_ShipmentRequest.cs:611 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-134f858c | FindButton 외 1 | DMF0045_ShipmentRequest.cs:613 | try ▸ lambda | DATA_OP | request.Parameters["p_sheet_name"] | siMain.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-af1821f0 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:614 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-2003b70a | FindButton 외 1 | DMF0045_ShipmentRequest.cs:615 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | (sTeam=="ALL")?"":sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-fce9056c | FindButton 외 1 | DMF0045_ShipmentRequest.cs:616 | try ▸ lambda | DATA_OP | request.Parameters["p_customer"] | (clbCustomer.ControlValues=="ALL")?"": clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3cd698ea | FindButton 외 1 | DMF0045_ShipmentRequest.cs:617 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | (clbSalesSite.ControlValues=="ALL")?"": clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d30ef9b4 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:618 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | (clbPlantSite.ControlValues=="ALL")?"": clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0752e8fc | FindButton 외 1 | DMF0045_ShipmentRequest.cs:619 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c431055f | FindButton 외 1 | DMF0045_ShipmentRequest.cs:620 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-26356441 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:621 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-3af072df | FindButton 외 1 | DMF0045_ShipmentRequest.cs:622 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-c17dac62 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:623 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b5d663a3 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:624 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7c99a7df | FindButton 외 1 | DMF0045_ShipmentRequest.cs:626 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0aefd1d6 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:628 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-97241301 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:641 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d53d8048 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:641 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2ca1504a | FindButton 외 1 | DMF0045_ShipmentRequest.cs:645 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4afb490e | FindButton 외 1 | DMF0045_ShipmentRequest.cs:646 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09007daa | FindButton 외 1 | DMF0045_ShipmentRequest.cs:647 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-24b2cddd | FindButton 외 1 | DMF0045_ShipmentRequest.cs:653 | try ▸ if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-9e4c826c | FindButton 외 1 | DMF0045_ShipmentRequest.cs:664 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns… | CALL_EXT | Convert.ToInt16 | (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ShipFrozen)).ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d658fab | FindButton 외 1 | DMF0045_ShipmentRequest.cs:687 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (FrozenCnt != 0) | GRID_STYLE | siMain.SetBGColor | (iRow, iStartCol, iRow, iStartCol + FrozenCnt, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-9814d5b7 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:691 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 표시 설정 |  |  |  |
| AC-02edeeaa | FindButton 외 1 | DMF0045_ShipmentRequest.cs:704 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns… | GRID_STYLE | siMain.SetBGColor | (iRow, iFrom, iRow, iTo, Color.FromArgb(219, 229, 241)) | 그리드 표시 설정 |  |  |  |
| AC-1f873b4d | FindButton 외 1 | DMF0045_ShipmentRequest.cs:710 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ab2e9c6f | FindButton 외 1 | DMF0045_ShipmentRequest.cs:718 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3a5d8a3 | FindButton 외 1 | DMF0045_ShipmentRequest.cs:722 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0c3c5fff | FindButton 외 1 | DMF0045_ShipmentRequest.cs:724 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0045_ShipmentRequest.fnValidation

진입점: SaveButton [try ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4be89abd | SaveButton [try ▸ if (fps.Name == "spdMain")] | DMF0045_ShipmentRequest.cs:2238 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-e7e73a55 | SaveButton [try ▸ if (fps.Name == "spdMain")] | DMF0045_ShipmentRequest.cs:2241 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0045_ShipmentRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c1be3c8 | this.Load | DMF0045_ShipmentRequest.cs:170 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-036d9b57 | this.Load | DMF0045_ShipmentRequest.cs:171 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0045_ShipmentRequest.GetBizTypebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14a82805 | (진입점 미연결) | DMF0045_ShipmentRequest.cs:2278 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-677ce3d6 | (진입점 미연결) | DMF0045_ShipmentRequest.cs:2279 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-71de5f3a | (진입점 미연결) | DMF0045_ShipmentRequest.cs:2280 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-461dfe72 | (진입점 미연결) | DMF0045_ShipmentRequest.cs:2283 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0045_ShipmentRequest.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c28429c9 | this.Load | DMF0045_ShipmentRequest.cs:2266 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-3d45b06a | this.Load | DMF0045_ShipmentRequest.cs:2267 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-09ae19eb | this.Load | DMF0045_ShipmentRequest.cs:2269 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0045_ShipmentRequest.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9ba98eb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2249 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0045_GET_SPREAD_TITLE") ⇒ DM.DMF0045_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-2ce04b76 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2250 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-6a59897a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2251 |  | DATA_OP | request.Parameters["p_sheet_name"] | sSheetName | 행/컬럼 값 대입 |  |  |  |
| AC-8c3a514d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2252 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2754a954 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2253 |  | DATA_OP | request.Parameters["p_start_dt"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-7fe75002 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2254 |  | DATA_OP | request.Parameters["p_end_dt"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-f7cde2db | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2256 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d54ea028 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2256 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14c3b31b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2257 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-edf667e8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:2257 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0045_ShipmentRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7deb49ae | this.Load | DMF0045_ShipmentRequest.cs:200 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-01ced099 | this.Load | DMF0045_ShipmentRequest.cs:200 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea28ae96 | this.Load | DMF0045_ShipmentRequest.cs:204 | for (i <= dtDivision.Rows.Count - 1) ▸ if (dtDivision.Rows[i]["CODE"].ToString() == "40") | DATA_OP | dtDivision.Rows.RemoveAt | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-feb8577e | this.Load | DMF0045_ShipmentRequest.cs:206 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ba079826 | this.Load | DMF0045_ShipmentRequest.cs:209 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-ab4b9a71 | this.Load | DMF0045_ShipmentRequest.cs:209 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b3457d1 | this.Load | DMF0045_ShipmentRequest.cs:210 |  | FLAG | dtTeamSpr | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-58270c05 | this.Load | DMF0045_ShipmentRequest.cs:210 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a45fb3c9 | this.Load | DMF0045_ShipmentRequest.cs:211 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-82ca9263 | this.Load | DMF0045_ShipmentRequest.cs:214 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1d8e4c9f | this.Load | DMF0045_ShipmentRequest.cs:214 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d1d0eef | this.Load | DMF0045_ShipmentRequest.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e18a9ce2 | this.Load | DMF0045_ShipmentRequest.cs:219 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f657265f | this.Load | DMF0045_ShipmentRequest.cs:219 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3f3610f | this.Load | DMF0045_ShipmentRequest.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb052256 | this.Load | DMF0045_ShipmentRequest.cs:222 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-93f649a0 | this.Load | DMF0045_ShipmentRequest.cs:222 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c82dee3 | this.Load | DMF0045_ShipmentRequest.cs:223 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dd92f0af | this.Load | DMF0045_ShipmentRequest.cs:225 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a031c204 | this.Load | DMF0045_ShipmentRequest.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-88727df2 | this.Load | DMF0045_ShipmentRequest.cs:229 |  | VALUE_SET | drpPeriod.InitValue | DateTime.Now.ToString("yyyyMMdd") + ":" + DateTime.Now.AddDays(55).ToString("yyyyMMdd") | 컨트롤 값 설정 |  |  |  |
| AC-216a640c | this.Load | DMF0045_ShipmentRequest.cs:231 |  | FLAG | dtMeasure | Data.Common(Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-454bfad4 | this.Load | DMF0045_ShipmentRequest.cs:231 |  | COMBO_DATA | Data.Common | (Data.Type.Measure) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e40f20d | this.Load | DMF0045_ShipmentRequest.cs:234 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-874cc61e | this.Load | DMF0045_ShipmentRequest.cs:235 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |

## DMF0045_ShipmentRequest.InitSaveDataTable

진입점: this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d131a873 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:400 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-9a2734f6 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:401 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfcaa839 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:402 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0390718c | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:403 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FromSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a22f5de | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:404 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d3325f1 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:405 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-89b1ce9c | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:406 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d9aa8c5 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:407 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.TrMode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-89a82292 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:408 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-232b61a6 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:409 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ToSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c01d92d3 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:410 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44479ab8 | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:413 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BodId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e72e3fa | this.cboDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0045_ShipmentRequest.cs:414 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0045_ShipmentRequest.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.cboDivision.SelectedIndexChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4748e54e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:272 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0045_ShipmentRequest.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a137edb3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:285 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a029be60 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:286 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-fb95eb46 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:293 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a500dc62 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:294 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-556ecb95 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:295 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-e683aa83 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:296 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0045_ShipmentRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bab2f6a9 | InsertButton | DMF0045_ShipmentRequest.cs:987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-07956381 | InsertButton | DMF0045_ShipmentRequest.cs:988 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f591fc8 | InsertButton | DMF0045_ShipmentRequest.cs:992 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-ab0200e5 | InsertButton | DMF0045_ShipmentRequest.cs:993 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-72fc00c0 | InsertButton | DMF0045_ShipmentRequest.cs:994 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TrMode)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-045d6ddb | InsertButton | DMF0045_ShipmentRequest.cs:1000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6216549 | InsertButton | DMF0045_ShipmentRequest.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.Common | (Data.Type.FCST_TYPE) ⇒ biz:CommonData.CommonDataList [code=FCST_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0bef17c3 | InsertButton | DMF0045_ShipmentRequest.cs:1003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.FcstType), dtFcstType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6e022e10 | InsertButton | DMF0045_ShipmentRequest.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | FLAG | dtMeasure | Data.Common(Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-7aef943e | InsertButton | DMF0045_ShipmentRequest.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | COMBO_DATA | Data.Common | (Data.Type.Measure, false, "DMF0045", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c5d4400 | InsertButton | DMF0045_ShipmentRequest.cs:1005 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3a5df5e5 | InsertButton | DMF0045_ShipmentRequest.cs:1009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), cboDivision.ControlVal… | 그리드 값 설정 |  |  |  |
| AC-d996fe1c | InsertButton | DMF0045_ShipmentRequest.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), "SHIP_REQ") | 그리드 값 설정 |  |  |  |
| AC-e5b607a0 | InsertButton | DMF0045_ShipmentRequest.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3cc58ea6 | InsertButton | DMF0045_ShipmentRequest.cs:1016 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.NickName), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-524f027b | InsertButton | DMF0045_ShipmentRequest.cs:1017 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (siMain.GetMaxR… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Measure), iRow, siMain.GetColumnIndex(DefColumns.R… | 그리드 편집 잠금/해제 |  |  |  |
| AC-092e5f1d | InsertButton | DMF0045_ShipmentRequest.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iResultCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6a7ae731 | InsertButton | DMF0045_ShipmentRequest.cs:1043 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.FromArgb(242, 242, 242)) | 그리드 표시 설정 |  |  |  |
| AC-1e356957 | InsertButton | DMF0045_ShipmentRequest.cs:1044 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ if (iResultCol > i… | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-8a8b03dc | InsertButton | DMF0045_ShipmentRequest.cs:1057 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-36af6d38 | InsertButton | DMF0045_ShipmentRequest.cs:1064 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-228cc616 | InsertButton | DMF0045_ShipmentRequest.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) ▸ for (iCol <= siMai… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d1ace05e | InsertButton | DMF0045_ShipmentRequest.cs:1076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == siMain.ActiveSheet.SheetName) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0045_ShipmentRequest.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d433a1c8 | OnShown | DMF0045_ShipmentRequest.cs:187 | if (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-374be3ed | OnShown | DMF0045_ShipmentRequest.cs:191 | else of (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## DMF0045_ShipmentRequest.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15181cc7 | SaveButton | DMF0045_ShipmentRequest.cs:803 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c1e4eed7 | SaveButton | DMF0045_ShipmentRequest.cs:807 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a97db395 | SaveButton | DMF0045_ShipmentRequest.cs:812 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6f31791 | SaveButton | DMF0045_ShipmentRequest.cs:815 | try ▸ if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-9c29fba8 | SaveButton | DMF0045_ShipmentRequest.cs:815 | try ▸ if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88058959 | SaveButton | DMF0045_ShipmentRequest.cs:820 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82117ff3 | SaveButton | DMF0045_ShipmentRequest.cs:821 | try ▸ if (fps.Name == "spdMain") ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4679f913 | SaveButton | DMF0045_ShipmentRequest.cs:865 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-a8d2845e | SaveButton | DMF0045_ShipmentRequest.cs:866 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-685ee5b9 | SaveButton | DMF0045_ShipmentRequest.cs:867 | try ▸ if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ff69cbf | SaveButton | DMF0045_ShipmentRequest.cs:893 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7e7157c5 | SaveButton | DMF0045_ShipmentRequest.cs:896 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("DM.DMF0045_SAVE_SHIPMENT_REQUEST") ⇒ DM.DMF0045_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-3bdafba4 | SaveButton | DMF0045_ShipmentRequest.cs:899 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5191ee52 | SaveButton | DMF0045_ShipmentRequest.cs:901 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { re… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2f8142c8 | SaveButton | DMF0045_ShipmentRequest.cs:905 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f588788f | SaveButton | DMF0045_ShipmentRequest.cs:907 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-73fc1108 | SaveButton | DMF0045_ShipmentRequest.cs:908 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7ef3df5e | SaveButton | DMF0045_ShipmentRequest.cs:909 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-eaaec2cb | SaveButton | DMF0045_ShipmentRequest.cs:910 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-cdc843c6 | SaveButton | DMF0045_ShipmentRequest.cs:911 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-943b28ef | SaveButton | DMF0045_ShipmentRequest.cs:912 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-33d91e08 | SaveButton | DMF0045_ShipmentRequest.cs:913 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-7991c5d2 | SaveButton | DMF0045_ShipmentRequest.cs:914 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-d690a25c | SaveButton | DMF0045_ShipmentRequest.cs:915 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | sTransportMode | 행/컬럼 값 대입 |  |  |  |
| AC-eaf5f2f7 | SaveButton | DMF0045_ShipmentRequest.cs:916 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | sBodId | 행/컬럼 값 대입 |  |  |  |
| AC-4f05a6fc | SaveButton | DMF0045_ShipmentRequest.cs:917 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-55f5fe5d | SaveButton | DMF0045_ShipmentRequest.cs:918 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-c036adb8 | SaveButton | DMF0045_ShipmentRequest.cs:919 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-ab08fa3e | SaveButton | DMF0045_ShipmentRequest.cs:920 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dd31564b | SaveButton | DMF0045_ShipmentRequest.cs:921 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e8a62105 | SaveButton | DMF0045_ShipmentRequest.cs:923 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ef0934e | SaveButton | DMF0045_ShipmentRequest.cs:923 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-57bdb4ee | SaveButton | DMF0045_ShipmentRequest.cs:934 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c0fcddc2 | SaveButton | DMF0045_ShipmentRequest.cs:935 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8fc7f9e6 | SaveButton | DMF0045_ShipmentRequest.cs:937 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e0e965f | SaveButton | DMF0045_ShipmentRequest.cs:939 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-b8360372 | SaveButton | DMF0045_ShipmentRequest.cs:940 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1056a058 | SaveButton | DMF0045_ShipmentRequest.cs:950 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9fc9995c | SaveButton | DMF0045_ShipmentRequest.cs:951 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (t.Dat… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9611f817 | SaveButton | DMF0045_ShipmentRequest.cs:956 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ef24e953 | SaveButton | DMF0045_ShipmentRequest.cs:957 | try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6cea103a | SaveButton | DMF0045_ShipmentRequest.cs:963 | try ▸ if (fps.Name == "spdMain") ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14e6c640 | SaveButton | DMF0045_ShipmentRequest.cs:969 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fdd87699 | SaveButton | DMF0045_ShipmentRequest.cs:970 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8559242 | SaveButton | DMF0045_ShipmentRequest.cs:976 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0045_ShipmentRequest.Set_SumValues

진입점: FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8929db49 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0045_ShipmentRequest.cs:744 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e218143 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0045_ShipmentRequest.cs:748 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-f473cf48 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0045_ShipmentRequest.cs:783 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |
| AC-720f8650 | FindButton [try ▸ if (ds.Tables[0] != null) ▸ if (dsSort.Tab… 외 1 | DMF0045_ShipmentRequest.cs:788 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |

## DMF0045_ShipmentRequest.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43d8a2a0 | (진입점 미연결) | DMF0045_ShipmentRequest.cs:1452 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.TrMode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## DMF0045_ShipmentRequest.SetSaveData

진입점: dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)] / dsdmCell.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc38ffdd | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2023 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b3c90d9 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2027 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b868d6c | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2028 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e4e3d053 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2029 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Project] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-f67ea625 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2030 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FromSite] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-86db0283 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2031 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-0ba35173 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2032 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-4207d21d | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2033 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-47eea336 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2034 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-5348ccc0 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2035 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ToSite] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-8442942c | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2036 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-0684ed45 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2037 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-cbb31b44 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2039 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9b96f5c | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2040 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4c1bfa6 | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2044 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-48c2324e | dsdmPack.Changed [switch (e.Type) case FarPoint.Win.Spread.M… 외 1 | DMF0045_ShipmentRequest.cs:2045 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0045_ShipmentRequest.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() >= 0)] / SaveButton [try ▸ if (fps.N…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f926281f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0045_ShipmentRequest.cs:2152 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-15428353 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0045_ShipmentRequest.cs:2157 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-57c57de7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0045_ShipmentRequest.cs:2164 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-54ac8aed | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0045_ShipmentRequest.cs:2168 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-798844da | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0045_ShipmentRequest.cs:2173 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-b3a034cc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0045_ShipmentRequest.cs:2180 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1ab20aa7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0045_ShipmentRequest.cs:2184 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0045_ShipmentRequest.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboDivision.SelectedIndexChanged [if (siMain != null) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8349d6b4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:327 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93251f6f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:335 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-903f2410 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:346 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-33d0d899 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:352 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54244357 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:353 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2a4de9e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:358 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b1edce5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:359 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2a259db | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:366 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eabf3502 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:367 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e2b05a17 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:378 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0326c06 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:379 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a697a54 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:380 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e67b06b7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:381 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d60d3577 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:383 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Requestor) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e04f697b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0045_ShipmentRequest.cs:385 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0045_ShipmentRequest.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d8bf583 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1211 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-041a1695 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1217 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-6afb7ecc | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1233 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-f28fb50b | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1247 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4de86406 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1268 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-6c6a95c8 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1269 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-cff4f2cb | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1270 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-40b29a9e | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1271 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-234bd2c7 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1283 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-95a663cc | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1287 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-45d5591a | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1292 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-c4c02e8a | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1297 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), sBizType) | 그리드 값 설정 |  |  |  |
| AC-c4d96e37 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1302 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectOwner), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-7c670552 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1307 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-64f94005 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1314 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId)) | 그리드 표시 설정 |  |  |  |
| AC-0f086a7a | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1323 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b74fcf9 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1330 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new DMF0046_GetBODItemPrjRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-b79654bb | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1331 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_division_id | p_divisionId | 속성 p_division_id 설정 |  |  |  |
| AC-9d958867 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1332 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_item_id | p_item_id | 속성 p_item_id 설정 |  |  |  |
| AC-ddb36010 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1333 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.p_from_site | p_from_site | 속성 p_from_site 설정 |  |  |  |
| AC-9020f487 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1335 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | bodPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-264c755f | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1336 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | bodPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-29adc39b | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1358 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.FromSite), sFromSite) | 그리드 값 설정 |  |  |  |
| AC-8d57ab88 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1363 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ToSite), sToSite) | 그리드 값 설정 |  |  |  |
| AC-10954893 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1368 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Incoterms), sIncoterms) | 그리드 값 설정 |  |  |  |
| AC-9baa4803 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1373 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TrMode), sTransportMode) | 그리드 값 설정 |  |  |  |
| AC-50e5d409 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1377 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BodId), sBodId) | 그리드 값 설정 |  |  |  |
| AC-ad64c6f2 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1381 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-39af481a | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1385 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), sEndCustomer) | 그리드 값 설정 |  |  |  |
| AC-b372956d | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1389 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sDeptNameKo) | 그리드 값 설정 |  |  |  |
| AC-cc63dcc7 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1396 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId)) | 그리드 표시 설정 |  |  |  |
| AC-fd17dc3c | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1410 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | new DMF0047_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c172419f | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1411 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.Form_Load | (false, p_divisionId, "", "", "", "", "", sBizType) | 팝업 초기화(인자 전달) |  |  |  |
| AC-825b1f2f | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1412 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-83b79dd5 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1413 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ad5b5aab | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1423 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemId), sItemId) | 그리드 값 설정 |  |  |  |
| AC-a4084cb9 | this.spdMain.CellDoubleClick | DMF0045_ShipmentRequest.cs:1427 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName) | 그리드 값 설정 |  |  |  |

## DMF0045_ShipmentRequest.spdMain_Changed

진입점: dsdmPack.Changed / dsdmCell.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-932d3724 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1460 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad3a5f11 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1495 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Division ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f0c0f83 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1497 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-6bc8f03e | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1499 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80076b7f | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1503 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Project Code" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68077044 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1505 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-d4c88c1e | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1507 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ba73d68 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1511 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Sales Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f49e14d | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1513 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-929e064c | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1515 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5539c6f | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1519 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Item ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1fdcb01 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1521 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-02794b9a | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1523 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5308d99 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1527 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "FCST Type" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a7bab9a | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1529 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-6d18048b | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1531 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f3ef689 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1535 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Incoterms" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-afb7e6a2 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1537 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-fb8477de | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1539 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed9e3dac | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1543 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-872d9c72 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1545 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-c73c745a | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1547 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23cd5a84 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1551 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plant Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6f93f72 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1553 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-201cfb89 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1555 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c94cd0d8 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1582 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 2, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d1f2ebcf | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1605 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-c4957ae3 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1619 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.ActiveSheet.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-3c072036 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1685 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-395cd845 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1693 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-beb18e5d | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1708 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-76660844 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1716 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-b7ed5d24 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1738 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-22a9fdee | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1749 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8802f0c | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1763 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f6edb30a | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1773 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iSetCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-21739328 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1801 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-5a68bf16 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1811 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60347f74 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1892 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-484da0ed | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1900 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-bc9cd19c | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1914 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-2bc3796c | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1922 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-20d6c72d | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1939 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-de0fde44 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1969 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-9c9c0911 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:1974 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-410944c7 | dsdmPack.Changed 외 1 | DMF0045_ShipmentRequest.cs:2000 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iWeekCol, iWeeklySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0045_ShipmentRequest.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51c6eccf | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1157 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-cc67d683 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1157 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1d1241c0 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1158 | if (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FromSite), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f6aa9b81 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1162 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-26a94223 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1166 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), "") | 그리드 값 설정 |  |  |  |
| AC-4ff71105 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1171 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), "") | 그리드 값 설정 |  |  |  |
| AC-cc2c8dda | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1176 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), "") | 그리드 값 설정 |  |  |  |
| AC-6806e934 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1181 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-8bdf8d62 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1186 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-17fc450c | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1194 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-0c2fdc0c | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1194 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c1b8513 | this.spdMain.ComboSelChange | DMF0045_ShipmentRequest.cs:1195 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FromSite)) ▸ if (siMain.… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0045_ShipmentRequest.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6e551f9 | this.spdMain.KeyUp | DMF0045_ShipmentRequest.cs:2059 | if (siMain.GetColumnIndex(DefColumns.Requestor) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f71381a5 | this.spdMain.KeyUp | DMF0045_ShipmentRequest.cs:2063 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a61454b | this.spdMain.KeyUp | DMF0045_ShipmentRequest.cs:2068 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0215342 | this.spdMain.KeyUp | DMF0045_ShipmentRequest.cs:2069 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0045_ShipmentRequest.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88742731 | this.spdMain.TopChange | DMF0045_ShipmentRequest.cs:2053 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

