# AS-IS 액션 대조표 — DMF0006

> 원천: `Doc/asisfacts/screens/DMF0006/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 297행 · 메서드 24 · 종류 DATA_OP 56 · GRID_SET 36 · FLAG 33 · GRID_LOCK 32 · COMBO_DATA 25 · UI_PROP 19 · RETURN 14 · LIST_REBIND 13 · POPUP 12 · ENDPOINT 9 · GRID_INIT 8 · MESSAGE 8 · GRID_COMBO 8 · CALL_EXT 7 · STATE 4 · UI_MISC 4 · THROW 4 · VALUE_SET 2 · GRID_STYLE 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 7


## DMF0006_CustomerModelMapping.btnModelType_Click

진입점: this.btnModelType.Click / this.umltModel.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ee36011 | this.btnModelType.Click 외 1 | DMF0006_CustomerModelMapping.cs:794 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-83b947b1 | this.btnModelType.Click 외 1 | DMF0006_CustomerModelMapping.cs:796 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0b20c673 | this.btnModelType.Click 외 1 | DMF0006_CustomerModelMapping.cs:797 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-075dc465 | this.btnModelType.Click 외 1 | DMF0006_CustomerModelMapping.cs:798 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bdbd65f8 | this.btnModelType.Click 외 1 | DMF0006_CustomerModelMapping.cs:800 |  | VALUE_SET | umltModel.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0006_CustomerModelMapping.btnProject_Click

진입점: this.btnProject.Click / this.umltProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09e32560 | this.btnProject.Click 외 1 | DMF0006_CustomerModelMapping.cs:812 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e47b96d9 | this.btnProject.Click 외 1 | DMF0006_CustomerModelMapping.cs:813 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b2ba02dd | this.btnProject.Click 외 1 | DMF0006_CustomerModelMapping.cs:814 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fd79965c | this.btnProject.Click 외 1 | DMF0006_CustomerModelMapping.cs:815 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-53b6eed2 | this.btnProject.Click 외 1 | DMF0006_CustomerModelMapping.cs:817 |  | VALUE_SET | umltProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0006_CustomerModelMapping.clbDivision_SelectedIndexChanged

진입점: clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-279c0802 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:830 | if (sDivision == "40") | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PROJECT_CODE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-29bba776 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:831 | if (sDivision == "40") | STATE | layoutControlItem9.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-94df751a | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:832 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7b053f7c | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:835 | else of (sDivision == "40") | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PROJECT_CODE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f8a99da7 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:836 | else of (sDivision == "40") | STATE | layoutControlItem9.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7e9c174b | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:837 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5a906597 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:840 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-24fd8b50 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:840 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e0979a4 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:841 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d6263888 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:850 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bea4f417 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:851 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer40, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5506b445 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:856 | if (sDivision == "40") | COMBO_DATA | Data.ScmSitebyEndCustomer40 | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce9fac3c | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:857 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d9c2d129 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:863 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba09e966 | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:864 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-921c329a | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:868 | else of (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d147373e | clbDivisions.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:869 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0006_CustomerModelMapping.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-561f2f24 | this.clbEndCustomer.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1128 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-94588b2a | this.clbEndCustomer.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1128 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9633fa93 | this.clbEndCustomer.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1129 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0006_CustomerModelMapping.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-951aed72 | this.clbTeam.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1154 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-311c2406 | this.clbTeam.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1154 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20c3ed26 | this.clbTeam.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1155 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d5283726 | this.clbTeam.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1159 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-61d3b1cb | this.clbTeam.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1159 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9b29fec8 | this.clbTeam.SelectedIndexChanged | DMF0006_CustomerModelMapping.cs:1160 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0006_CustomerModelMapping.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86d4c54e | this.Load | DMF0006_CustomerModelMapping.cs:210 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4eecc6ef | this.Load | DMF0006_CustomerModelMapping.cs:211 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5db789ec | this.Load | DMF0006_CustomerModelMapping.cs:212 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4faef0a9 | this.Load | DMF0006_CustomerModelMapping.cs:219 |  | FLAG | dsdm | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Dat… | 화면 필드/플래그 변경 |  |  |  |

## DMF0006_CustomerModelMapping.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f043c3cb | this.Load | DMF0006_CustomerModelMapping.cs:177 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-645d7e14 | this.Load | DMF0006_CustomerModelMapping.cs:179 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-ab75920f | this.Load | DMF0006_CustomerModelMapping.cs:181 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-eaf55ccc | this.Load | DMF0006_CustomerModelMapping.cs:182 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-0b46ed41 | this.Load | DMF0006_CustomerModelMapping.cs:183 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-d2136b18 | this.Load | DMF0006_CustomerModelMapping.cs:184 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0006_CustomerModelMapping.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edd50e7d | DeleteButton | DMF0006_CustomerModelMapping.cs:258 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0006_CustomerModelMapping.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09641429 | Dispose | DMF0006_CustomerModelMapping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0006_CustomerModelMapping.Dsdm_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd83b50d | dsdm.Changed | DMF0006_CustomerModelMapping.cs:1171 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97f5c7f3 | dsdm.Changed | DMF0006_CustomerModelMapping.cs:1176 | if (e.Column < 0 \|\| e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07a5c960 | dsdm.Changed | DMF0006_CustomerModelMapping.cs:1177 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-124532e5 | dsdm.Changed | DMF0006_CustomerModelMapping.cs:1178 | if (siMain.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5da8d6fa | dsdm.Changed | DMF0006_CustomerModelMapping.cs:1193 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetColumnIndex(DefColumns.CONVERT_QT… | GRID_SET | siMain.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-17338f0c | dsdm.Changed | DMF0006_CustomerModelMapping.cs:1205 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## DMF0006_CustomerModelMapping.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15296bb8 | EditButton | DMF0006_CustomerModelMapping.cs:265 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-96733e4e | EditButton | DMF0006_CustomerModelMapping.cs:266 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-24ae3627 | EditButton | DMF0006_CustomerModelMapping.cs:269 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.SCM_SITE_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28e4df4d | EditButton | DMF0006_CustomerModelMapping.cs:270 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.GetColumnIndex(DefColumns.CUSTOMER… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7541fa6c | EditButton | DMF0006_CustomerModelMapping.cs:271 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), siMain.GetColumnIndex(DefColumns.CAPAC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-06e4e046 | EditButton | DMF0006_CustomerModelMapping.cs:272 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetColumnIndex(DefColumns.LAST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c49a32b7 | EditButton | DMF0006_CustomerModelMapping.cs:273 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.LAST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c64461ac | EditButton | DMF0006_CustomerModelMapping.cs:280 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), i, siMain.GetColumnIndex(DefColumns.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b9ab791b | EditButton | DMF0006_CustomerModelMapping.cs:281 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), i, siMain.GetColumnIndex(DefColumns.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-89b08cde | EditButton | DMF0006_CustomerModelMapping.cs:282 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID), i, siMain.GetColumnIndex(DefColumns.ITEM_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-572b4efc | EditButton | DMF0006_CustomerModelMapping.cs:283 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a016c2c6 | EditButton | DMF0006_CustomerModelMapping.cs:284 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.ITEM_NAME), i, siMain.GetColumnIndex(DefColumns.ITEM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5023299e | EditButton | DMF0006_CustomerModelMapping.cs:285 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CAPACITY), i, siMain.GetColumnIndex(DefColumns.CAPACI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cfa7b3c4 | EditButton | DMF0006_CustomerModelMapping.cs:286 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-938c85c8 | EditButton | DMF0006_CustomerModelMapping.cs:287 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).ToStrin… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), i, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d7c94a4 | EditButton | DMF0006_CustomerModelMapping.cs:294 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).To… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5f093158 | EditButton | DMF0006_CustomerModelMapping.cs:304 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).To… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-085791ed | EditButton | DMF0006_CustomerModelMapping.cs:305 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.GetColumnIndex(CAppSetting.StringAction)).To… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), i, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bb116852 | EditButton | DMF0006_CustomerModelMapping.cs:312 | if (this.fps != null) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (AUTHORITY_YN == "N") | GRID_LOCK | siMain.LockRange | (i, 0, i, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0006_CustomerModelMapping.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8e33adc | ExcelButton | DMF0006_CustomerModelMapping.cs:333 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-975e3032 | ExcelButton | DMF0006_CustomerModelMapping.cs:334 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-276ca932 | ExcelButton | DMF0006_CustomerModelMapping.cs:335 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-fe54e910 | ExcelButton | DMF0006_CustomerModelMapping.cs:336 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-c55e8967 | ExcelButton | DMF0006_CustomerModelMapping.cs:337 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-075ecf79 | ExcelButton | DMF0006_CustomerModelMapping.cs:338 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-b36bb617 | ExcelButton | DMF0006_CustomerModelMapping.cs:339 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-ede0efcf | ExcelButton | DMF0006_CustomerModelMapping.cs:341 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-c07025a5 | ExcelButton | DMF0006_CustomerModelMapping.cs:342 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-1785700b | ExcelButton | DMF0006_CustomerModelMapping.cs:344 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-433a7ee8 | ExcelButton | DMF0006_CustomerModelMapping.cs:348 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db0667b2 | ExcelButton | DMF0006_CustomerModelMapping.cs:353 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-8ea66620 | ExcelButton | DMF0006_CustomerModelMapping.cs:357 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0006_CustomerModelMapping.FindData

진입점: FindButton / SaveButton [try ▸ if (sRMSG.Trim() == "success") ▸ if (blnInsert)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e981026f | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:374 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a240dabf | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:375 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8582268b | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:378 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-77a98df6 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:391 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff81526f | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:392 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d554a95 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:397 | try | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f4cbbb1 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:402 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0751743b | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:406 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA") ⇒ DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0eb754d9 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:408 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-77217350 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:409 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f69d9afb | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:410 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ee53c426 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:411 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-1ddc2a6c | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:412 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-ab0cd8c8 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:413 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a75e6c23 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:414 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_project_code"] | p_customer_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-3ffae76d | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:415 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model"] | p_customer_model | 행/컬럼 값 대입 |  |  |  |
| AC-5ed44960 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:416 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-72a459d1 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:417 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f343ef80 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:418 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5b9b1290 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:419 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3eea2391 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:421 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-959869c2 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:425 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-123db129 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:426 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fb97a03e | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:429 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50fdace1 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:436 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6f90abce | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:441 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME) > 0) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-c83d37b9 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:445 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if ((iRow % 100) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-21e130f5 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:457 | try ▸ if (!blnInsert) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (iUpdateRow, iUpdateCol) | 그리드 표시 설정 |  |  |  |
| AC-3b0eacc5 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:458 | try ▸ if (!blnInsert) | CALL_EXT | spdMain.ShowActiveCell | (FarPoint.Win.Spread.VerticalPosition.Center, FarPoint.Win.Spread.HorizontalPosition.Cente… | ⚠ 의미 확인 필요 |  |  |  |
| AC-82c7ded4 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:463 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fcddbdf8 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:467 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b9a586e5 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:468 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-89a52e00 | FindButton 외 1 | DMF0006_CustomerModelMapping.cs:472 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0006_CustomerModelMapping.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9534d6a2 | this.Load | DMF0006_CustomerModelMapping.cs:130 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a4b7751 | this.Load | DMF0006_CustomerModelMapping.cs:131 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0006_CustomerModelMapping.GetSpdTitle

진입점: this.Load / clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d25d864f | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1136 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-3896a5f1 | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1137 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-032d0841 | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1138 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-db673a6c | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1139 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8512b2dc | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1140 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0006" | 행/컬럼 값 대입 |  |  |  |
| AC-ba35e035 | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1141 |  | DATA_OP | request.Parameters["p_sheet_name"] | "Customer Model Mapping" | 행/컬럼 값 대입 |  |  |  |
| AC-0ffee873 | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1143 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-39e7113f | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1143 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b6d0f94 | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:1146 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0006_CustomerModelMapping.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b396daf | this.Load | DMF0006_CustomerModelMapping.cs:140 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d5d09d4a | this.Load | DMF0006_CustomerModelMapping.cs:142 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-88599993 | this.Load | DMF0006_CustomerModelMapping.cs:142 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5634cc91 | this.Load | DMF0006_CustomerModelMapping.cs:143 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d8a190a0 | this.Load | DMF0006_CustomerModelMapping.cs:146 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-745e67e7 | this.Load | DMF0006_CustomerModelMapping.cs:146 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99a1b216 | this.Load | DMF0006_CustomerModelMapping.cs:147 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-062a541c | this.Load | DMF0006_CustomerModelMapping.cs:153 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-b8d0e397 | this.Load | DMF0006_CustomerModelMapping.cs:153 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c65334fa | this.Load | DMF0006_CustomerModelMapping.cs:157 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bfa29bf6 | this.Load | DMF0006_CustomerModelMapping.cs:157 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-13d62a43 | this.Load | DMF0006_CustomerModelMapping.cs:160 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-226228b0 | this.Load | DMF0006_CustomerModelMapping.cs:164 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a42cd78 | this.Load | DMF0006_CustomerModelMapping.cs:164 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivisions.Contr… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-abcec3fa | this.Load | DMF0006_CustomerModelMapping.cs:165 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-028e3c62 | this.Load | DMF0006_CustomerModelMapping.cs:168 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true,"Y") | 목록 컨트롤 재구성 |  |  |  |

## DMF0006_CustomerModelMapping.InitSpread

진입점: this.Load / clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d73f1314 | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:227 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0006_CustomerModelMapping.InitSpread_X

진입점: this.Load / clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b3e59ae | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:236 |  | GRID_STYLE | siMain.SetColumnMerge | (siMain.GetColumnIndex(DefColumns.PROJECT_CODE), FPMerge.None) | 그리드 표시 설정 |  |  |  |
| AC-5b5ee509 | this.Load 외 1 | DMF0006_CustomerModelMapping.cs:238 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0006_CustomerModelMapping.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bafb170 | InsertButton | DMF0006_CustomerModelMapping.cs:709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-de11c640 | InsertButton | DMF0006_CustomerModelMapping.cs:715 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-ea015a73 | InsertButton | DMF0006_CustomerModelMapping.cs:716 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f6771f0a | InsertButton | DMF0006_CustomerModelMapping.cs:718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), sDivision) | 그리드 값 설정 |  |  |  |
| AC-1c2d9112 | InsertButton | DMF0006_CustomerModelMapping.cs:720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-153d50b0 | InsertButton | DMF0006_CustomerModelMapping.cs:725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8d580a8 | InsertButton | DMF0006_CustomerModelMapping.cs:726 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d9f85dbe | InsertButton | DMF0006_CustomerModelMapping.cs:734 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6683e841 | InsertButton | DMF0006_CustomerModelMapping.cs:735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8ed4036f | InsertButton | DMF0006_CustomerModelMapping.cs:738 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c51f8697 | InsertButton | DMF0006_CustomerModelMapping.cs:739 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), siMain.ActiveRowIndex, siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9267693a | InsertButton | DMF0006_CustomerModelMapping.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-70af1179 | InsertButton | DMF0006_CustomerModelMapping.cs:746 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9ff6d76 | InsertButton | DMF0006_CustomerModelMapping.cs:747 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b68f1d24 | InsertButton | DMF0006_CustomerModelMapping.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d190b650 | InsertButton | DMF0006_CustomerModelMapping.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRow, siMain.GetColumnIndex(DefColumns.I… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6a5bcd17 | InsertButton | DMF0006_CustomerModelMapping.cs:751 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f56e8e30 | InsertButton | DMF0006_CustomerModelMapping.cs:752 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_NAME), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d30a883 | InsertButton | DMF0006_CustomerModelMapping.cs:753 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.CAPACITY), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fac5ba7c | InsertButton | DMF0006_CustomerModelMapping.cs:754 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-71bb1c4a | InsertButton | DMF0006_CustomerModelMapping.cs:755 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f85e040 | InsertButton | DMF0006_CustomerModelMapping.cs:757 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_PACK, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-e053c466 | InsertButton | DMF0006_CustomerModelMapping.cs:758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_MODULE, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-9df53e44 | InsertButton | DMF0006_CustomerModelMapping.cs:759 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CONVERT_QTY_CELL, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c194772 | InsertButton | DMF0006_CustomerModelMapping.cs:761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.CAPACITY, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c3e8123 | InsertButton | DMF0006_CustomerModelMapping.cs:762 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-a89342d4 | InsertButton | DMF0006_CustomerModelMapping.cs:763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LAST_UPDATED_BY, base.UserInfo.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-af712ee5 | InsertButton | DMF0006_CustomerModelMapping.cs:764 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LAST_UPDATE_DATE, System.DateTime.Now.ToString("yyyy-MM-dd hh:ss")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8778b37f | InsertButton | DMF0006_CustomerModelMapping.cs:767 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DMF0006_CustomerModelMapping.SaveData_DataService

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83092a5c | SaveButton | DMF0006_CustomerModelMapping.cs:486 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3dca90e5 | SaveButton | DMF0006_CustomerModelMapping.cs:487 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4beb7019 | SaveButton | DMF0006_CustomerModelMapping.cs:490 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-94df712d | SaveButton | DMF0006_CustomerModelMapping.cs:533 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisioin == "40" && (sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" \|\| … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-254391a2 | SaveButton | DMF0006_CustomerModelMapping.cs:534 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivisioin == "40" && (sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" \|\| … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5483b3f9 | SaveButton | DMF0006_CustomerModelMapping.cs:552 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivisioin == "40" && (sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edc5032c | SaveButton | DMF0006_CustomerModelMapping.cs:553 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivisioin == "40" && (sCustomPJT == "" \|\| sCustomerModel == "" \|\| sScmSiteid == "" … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-662c8daa | SaveButton | DMF0006_CustomerModelMapping.cs:567 | try ▸ for (i <= siMain.GetMaxRowIndex()) | ENDPOINT | (new CUIControl()).GetDataUsingSQLByDB2 | (sSQL) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1d22663f | SaveButton | DMF0006_CustomerModelMapping.cs:573 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (ds.Tables[0].Rows.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { msg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-324d1eb6 | SaveButton | DMF0006_CustomerModelMapping.cs:574 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (ds.Tables[0].Rows.Count != 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a811384 | SaveButton | DMF0006_CustomerModelMapping.cs:599 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols["A"] | += action + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-519bc8b9 | SaveButton | DMF0006_CustomerModelMapping.cs:601 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.DIVISION_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-1fddfce2 | SaveButton | DMF0006_CustomerModelMapping.cs:602 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.SCM_SITE_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-3970469e | SaveButton | DMF0006_CustomerModelMapping.cs:603 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.PROJECT_CODE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-d5398a79 | SaveButton | DMF0006_CustomerModelMapping.cs:605 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.ITEM_CLASS_NAME] | += "^" | 행/컬럼 값 대입 |  |  |  |
| AC-0852ec9d | SaveButton | DMF0006_CustomerModelMapping.cs:606 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.ITEM_ID] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-3bdbf0d2 | SaveButton | DMF0006_CustomerModelMapping.cs:608 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CUSTOMER_PROJECT_CODE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_PROJECT_CODE)).ToString() … | 행/컬럼 값 대입 |  |  |  |
| AC-440e6899 | SaveButton | DMF0006_CustomerModelMapping.cs:609 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CUSTOMER_MODEL] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CUSTOMER_MODEL)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-47866216 | SaveButton | DMF0006_CustomerModelMapping.cs:611 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_PACK] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_PACK)).ToString() == ""… | 행/컬럼 값 대입 |  |  |  |
| AC-37eedcf1 | SaveButton | DMF0006_CustomerModelMapping.cs:612 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_MODULE] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE)).ToString() == … | 행/컬럼 값 대입 |  |  |  |
| AC-5fe10fa4 | SaveButton | DMF0006_CustomerModelMapping.cs:613 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CONVERT_QTY_CELL] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL)).ToString() == ""… | 행/컬럼 값 대입 |  |  |  |
| AC-9ab6da39 | SaveButton | DMF0006_CustomerModelMapping.cs:615 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.CAPACITY] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CAPACITY)).ToString() == "" ? "0" :… | 행/컬럼 값 대입 |  |  |  |
| AC-ef669e5c | SaveButton | DMF0006_CustomerModelMapping.cs:617 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.VALID_YN] | += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-f563f194 | SaveButton | DMF0006_CustomerModelMapping.cs:619 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.LAST_UPDATE_DATE] | += System.DateTime.Now.ToString() + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-4219c307 | SaveButton | DMF0006_CustomerModelMapping.cs:620 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | nvcCols[DefColumns.LAST_UPDATED_BY] | += sUserId + "^" | 행/컬럼 값 대입 |  |  |  |
| AC-47db8862 | SaveButton | DMF0006_CustomerModelMapping.cs:632 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc96c522 | SaveButton | DMF0006_CustomerModelMapping.cs:636 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA") ⇒ DM.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-04298b5d | SaveButton | DMF0006_CustomerModelMapping.cs:637 | try ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | nvcCols["A"].Substring(0, nvcCols["A"].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-30c4f924 | SaveButton | DMF0006_CustomerModelMapping.cs:638 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | nvcCols[DefColumns.DIVISION_ID].Substring(0, nvcCols[DefColumns.DIVISION_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-53fba5fe | SaveButton | DMF0006_CustomerModelMapping.cs:639 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_project_code"] | nvcCols[DefColumns.CUSTOMER_PROJECT_CODE].Substring(0, nvcCols[DefColumns.CUSTOMER_PROJECT… | 행/컬럼 값 대입 |  |  |  |
| AC-d56e2897 | SaveButton | DMF0006_CustomerModelMapping.cs:640 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model"] | nvcCols[DefColumns.CUSTOMER_MODEL].Substring(0, nvcCols[DefColumns.CUSTOMER_MODEL].Length … | 행/컬럼 값 대입 |  |  |  |
| AC-5e287bf0 | SaveButton | DMF0006_CustomerModelMapping.cs:641 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | nvcCols[DefColumns.SCM_SITE_ID].Substring(0, nvcCols[DefColumns.SCM_SITE_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b634849d | SaveButton | DMF0006_CustomerModelMapping.cs:642 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | nvcCols[DefColumns.PROJECT_CODE].Substring(0, nvcCols[DefColumns.PROJECT_CODE].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7dd07b7e | SaveButton | DMF0006_CustomerModelMapping.cs:643 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | nvcCols[DefColumns.ITEM_ID].Substring(0, nvcCols[DefColumns.ITEM_ID].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-40e6dd70 | SaveButton | DMF0006_CustomerModelMapping.cs:644 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | nvcCols[DefColumns.VALID_YN].Substring(0, nvcCols[DefColumns.VALID_YN].Length - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-8d7914f9 | SaveButton | DMF0006_CustomerModelMapping.cs:645 | try ▸ lambda | DATA_OP | request.Parameters["p_customer_model_type"] | nvcCols[DefColumns.ITEM_CLASS_NAME].Substring(0, nvcCols[DefColumns.ITEM_CLASS_NAME].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-73c348ad | SaveButton | DMF0006_CustomerModelMapping.cs:646 | try ▸ lambda | DATA_OP | request.Parameters["p_convert_qty_pack"] | nvcCols[DefColumns.CONVERT_QTY_PACK].Substring(0, nvcCols[DefColumns.CONVERT_QTY_PACK].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-83895f51 | SaveButton | DMF0006_CustomerModelMapping.cs:647 | try ▸ lambda | DATA_OP | request.Parameters["p_convert_qty_module"] | nvcCols[DefColumns.CONVERT_QTY_MODULE].Substring(0, nvcCols[DefColumns.CONVERT_QTY_MODULE]… | 행/컬럼 값 대입 |  |  |  |
| AC-cf2bd372 | SaveButton | DMF0006_CustomerModelMapping.cs:648 | try ▸ lambda | DATA_OP | request.Parameters["p_convert_qty_cell"] | nvcCols[DefColumns.CONVERT_QTY_CELL].Substring(0, nvcCols[DefColumns.CONVERT_QTY_CELL].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-d40162df | SaveButton | DMF0006_CustomerModelMapping.cs:649 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-9119cf90 | SaveButton | DMF0006_CustomerModelMapping.cs:650 | try ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-b45e6906 | SaveButton | DMF0006_CustomerModelMapping.cs:651 | try ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | nvcCols[DefColumns.LAST_UPDATED_BY].Substring(0, nvcCols[DefColumns.LAST_UPDATED_BY].Lengt… | 행/컬럼 값 대입 |  |  |  |
| AC-42b2fe00 | SaveButton | DMF0006_CustomerModelMapping.cs:652 | try ▸ lambda | DATA_OP | request.Parameters["p_last_update_date"] | nvcCols[DefColumns.LAST_UPDATE_DATE].Substring(0, nvcCols[DefColumns.LAST_UPDATE_DATE].Len… | 행/컬럼 값 대입 |  |  |  |
| AC-cf9f9952 | SaveButton | DMF0006_CustomerModelMapping.cs:656 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eacda761 | SaveButton | DMF0006_CustomerModelMapping.cs:656 | try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-b275f579 | SaveButton | DMF0006_CustomerModelMapping.cs:667 | try ▸ if (sRMSG.Trim() == "success") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-91eeb07d | SaveButton | DMF0006_CustomerModelMapping.cs:670 | try ▸ if (sRMSG.Trim() == "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCUD }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b9f49532 | SaveButton | DMF0006_CustomerModelMapping.cs:683 | try ▸ else of (sRMSG.Trim() == "success") | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bbef8131 | SaveButton | DMF0006_CustomerModelMapping.cs:686 | try ▸ else of (sRMSG.Trim() == "success") | CALL_EXT | log.Write | (FoxLogLevel.Error, sRMSG) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f14ffbe2 | SaveButton | DMF0006_CustomerModelMapping.cs:687 | try ▸ else of (sRMSG.Trim() == "success") | MESSAGE | MessageBox.Show | (sRMSG, "Warning!") | 메시지 표시 |  |  |  |
| AC-6876ac7b | SaveButton | DMF0006_CustomerModelMapping.cs:694 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-26d42581 | SaveButton | DMF0006_CustomerModelMapping.cs:695 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-6639be2c | SaveButton | DMF0006_CustomerModelMapping.cs:699 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0006_CustomerModelMapping.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7debc9d | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1002 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c91dc858 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1033 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-3e66c960 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1034 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1b0fe0e1 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1035 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f92a93f | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1036 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9beda300 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1048 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), popProject.ProjectCode) | 그리드 값 설정 |  |  |  |
| AC-c4e1a729 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1049 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), popProject.ProjectName) | 그리드 값 설정 |  |  |  |
| AC-fac1906e | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1052 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-529fe170 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1053 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-abb0483d | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1061 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-ed6e681b | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1063 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f514b1c1 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1064 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6b366bf4 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1065 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-13265270 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1069 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-24d305cd | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1070 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), popItem.ItemClassName) | 그리드 값 설정 |  |  |  |
| AC-ed46190e | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1071 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), popItem.ItemName) | 그리드 값 설정 |  |  |  |
| AC-effbd800 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1073 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a27c209 | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1077 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), e.Row, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-86f9515c | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1087 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_CELL), e.Row, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b76a593e | this.spdMain.CellDoubleClick | DMF0006_CustomerModelMapping.cs:1088 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.P… | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefColumns.CONVERT_QTY_MODULE), e.Row, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0006_CustomerModelMapping.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b61e6868 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:890 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-468c05e5 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:890 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9cf71b1d | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:891 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7f905d44 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:901 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-b428ce96 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:901 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-558d8a11 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:905 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3628c489 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:905 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b923ff6f | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:911 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-8f7e92a4 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:911 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e667bc93 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:912 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d9b13843 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:916 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c0014e81 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:918 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-877a7bb1 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:920 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ee15aa87 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:922 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-7fb5bdd8 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:924 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-0f147d8a | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:926 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-8b8e1231 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:928 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(D… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-d2c24d07 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:939 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-e14299fd | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:939 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72bc5d21 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:942 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0e156d44 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:942 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8006e93 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:944 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6244dd7b | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:949 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-75e55ffe | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:949 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6106e7d3 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:950 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3782bdbc | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:954 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), "") | 그리드 값 설정 |  |  |  |
| AC-76703dce | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:956 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c746e039 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:958 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-9569b0fe | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:960 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-3258875e | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:962 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-75a34664 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:964 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-396bc3a0 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:970 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-50ea9895 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:970 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b7700cf | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:971 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ae0ccb44 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:974 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-95d0b3f5 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:976 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-8ba71c0e | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:978 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-1470f257 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:980 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-1928030c | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:982 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-e90a937f | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:987 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-764e8d21 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:989 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-02809aa5 | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:991 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-06e2808f | this.spdMain.ComboSelChange | DMF0006_CustomerModelMapping.cs:993 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), "") | 그리드 값 설정 |  |  |  |

## DMF0006_CustomerModelMapping.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-761ea66a | this.spdMain.KeyUp | DMF0006_CustomerModelMapping.cs:1105 | if (e.Control == true && e.KeyCode == Keys.V) | CALL_EXT | spdMain.Sheets[0].ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a5afe7f | this.spdMain.KeyUp | DMF0006_CustomerModelMapping.cs:1112 | if (e.Control == true && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0006_CustomerModelMapping.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baca27f9 | this.spdMain.TopChange | DMF0006_CustomerModelMapping.cs:1122 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

