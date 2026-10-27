# AS-IS 액션 대조표 — DM0005

> 원천: `Doc/asisfacts/screens/DM0005/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1090행 · 메서드 106 · 종류 DATA_OP 209 · GRID_SET 136 · FLAG 110 · COMBO_DATA 85 · GRID_LOCK 82 · MESSAGE 80 · RETURN 71 · POPUP 68 · UI_PROP 61 · LIST_REBIND 48 · ENDPOINT 43 · GRID_COMBO 32 · GRID_INIT 30 · VALUE_SET 20 · GRID_BIND 7 · UI_MISC 6 · CALL_EXT 2 · ⚠ 의미 확인 필요 2


## DM0005_SaleSite_PjtModelMapping.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9be9fadb | this.btnItemId.Click | DM0005_SaleSite_PjtModelMapping.cs:1343 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-e89d50b4 | this.btnItemId.Click | DM0005_SaleSite_PjtModelMapping.cs:1345 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-5c98500b | this.btnItemId.Click | DM0005_SaleSite_PjtModelMapping.cs:1346 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-851c1c4e | this.btnItemId.Click | DM0005_SaleSite_PjtModelMapping.cs:1347 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-267b597b | this.btnItemId.Click | DM0005_SaleSite_PjtModelMapping.cs:1353 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c72f4cc | this.btnProject.Click | DM0005_SaleSite_PjtModelMapping.cs:1312 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-901690e0 | this.btnProject.Click | DM0005_SaleSite_PjtModelMapping.cs:1313 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-53d20fec | this.btnProject.Click | DM0005_SaleSite_PjtModelMapping.cs:1314 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8e030f7f | this.btnProject.Click | DM0005_SaleSite_PjtModelMapping.cs:1315 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ac6c1f66 | this.btnProject.Click | DM0005_SaleSite_PjtModelMapping.cs:1321 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3e6d840 | this.chkDetail.CheckedChanged | DM0005_SaleSite_PjtModelMapping.cs:1220 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94d857e8 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1180 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-53871a6f | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1180 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea5b12ba | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1181 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4950674c | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1185 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-abe64369 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1185 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e71b66d9 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1186 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c6e80cd7 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1190 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1bd32838 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1190 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-15c01d20 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1191 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba10f174 | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1213 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c2fc7ee7 | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1213 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5cff529f | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1214 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.ClbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da87edef | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1199 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6640c55e | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1199 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-14fd71f3 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1200 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6caa29ee | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1204 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7a063e75 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1204 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9a86dff | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMapping.cs:1205 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a033150 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:222 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8c8cfd86 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:223 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-767d28fd | this.Load | DM0005_SaleSite_PjtModelMapping.cs:225 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c40881b9 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:226 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-903ef5df | this.Load | DM0005_SaleSite_PjtModelMapping.cs:228 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b63e208e | this.Load | DM0005_SaleSite_PjtModelMapping.cs:205 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-84a69027 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:206 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-9d0d4814 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:208 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f91dee0a | this.Load | DM0005_SaleSite_PjtModelMapping.cs:210 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-8af4b3a2 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:210 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a2d2ac0 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:213 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-eb77ea6d | this.Load | DM0005_SaleSite_PjtModelMapping.cs:214 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a0f0a2e2 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:215 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-5e544cfe | this.Load | DM0005_SaleSite_PjtModelMapping.cs:216 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-f2f31526 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:217 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2962cc1 | DeleteButton | DM0005_SaleSite_PjtModelMapping.cs:269 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d5385b7 | Dispose | DM0005_SaleSite_PjtModelMapping.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9418162a | EditButton | DM0005_SaleSite_PjtModelMapping.cs:282 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad06b6ae | EditButton | DM0005_SaleSite_PjtModelMapping.cs:283 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-702934a5 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:286 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-819ae0bb | EditButton | DM0005_SaleSite_PjtModelMapping.cs:287 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1cade084 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:289 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78ef8f80 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:298 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3da623bb | EditButton | DM0005_SaleSite_PjtModelMapping.cs:299 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3fba82f9 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:303 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-41c3137b | EditButton | DM0005_SaleSite_PjtModelMapping.cs:306 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-47ff1003 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:307 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ec43568 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:311 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6de78c36 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:337 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e101db88 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:338 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce179305 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:349 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bef89c81 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:350 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e6454ebd | EditButton | DM0005_SaleSite_PjtModelMapping.cs:356 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColum… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.PROJECT_CODE), siSub.GetColumnIndex(DefColumns.BPMS_EXIST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53117b68 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:357 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColum… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siSub.GetColumnIndex(DefColumns.EditFl… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4189e036 | EditButton | DM0005_SaleSite_PjtModelMapping.cs:361 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(iRow, siSub.GetColumnIndex(Def… | GRID_LOCK | siSub.LockRange | (iRow, 0, iRow, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8dbbca6 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:392 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f00d8703 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:394 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b36c8786 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:402 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2cd470a | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:406 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION") ⇒ DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION | 엔드포인트 요청 생성 |  |  |  |
| AC-86202d48 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:408 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-40b5800e | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:409 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3465c842 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:410 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ea902e89 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:411 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-52e0e181 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:412 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-55db6c19 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:413 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1a3c0b4e | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:414 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-4e1519d4 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:415 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a932d257 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:416 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec0a89a4 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:418 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bcccf1a8 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:420 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2f4a4bfe | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:427 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-87c4dc93 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:428 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ffd41d54 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:435 | for (iRow <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-28eab38c | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:441 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae2c7106 | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:446 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-f2959b0a | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:446 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e61c647d | FindButton 외 1 | DM0005_SaleSite_PjtModelMapping.cs:447 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-557d7d64 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:461 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c5a10e9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:465 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE") ⇒ DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | 엔드포인트 요청 생성 |  |  |  |
| AC-f976db75 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:467 | lambda | DATA_OP | request.Parameters["p_project_code"] | projectCode | 행/컬럼 값 대입 |  |  |  |
| AC-392d245c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:468 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-00b2dad3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:469 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a606d3b4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:470 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-af5579a6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:472 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-145d9734 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:474 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d7ba50f0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:481 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ff72310e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:482 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-032df351 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:490 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2061dbb5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:495 |  | FLAG | saveDSSub | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-d386dd6b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:495 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6974ad63 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMapping.cs:496 |  | DATA_OP | saveDSSub.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23644b45 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:166 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ceea2f83 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.GetScmSiteInfobyDivision

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec9e2a15 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMapping.cs:1399 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-889013e4 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMapping.cs:1400 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-097a068e | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMapping.cs:1401 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-0d370be7 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMapping.cs:1402 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e82b13ca | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMapping.cs:1405 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-131ba65b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMapping.cs:1415 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0005", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-899f3ed4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMapping.cs:1417 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d964087a | this.Load | DM0005_SaleSite_PjtModelMapping.cs:180 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0bf1bcce | this.Load | DM0005_SaleSite_PjtModelMapping.cs:181 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-a9ab8d77 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:181 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa7e80b0 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:182 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f153a8b4 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:186 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-70c305d3 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:186 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae438130 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-473d6660 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:191 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d4290115 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:191 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-739e0a6d | this.Load | DM0005_SaleSite_PjtModelMapping.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b53855fd | this.Load | DM0005_SaleSite_PjtModelMapping.cs:196 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-68139402 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:196 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a526d938 | this.Load | DM0005_SaleSite_PjtModelMapping.cs:197 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5e64946f | this.Load | DM0005_SaleSite_PjtModelMapping.cs:199 |  | FLAG | dtItemType | Data.Common(Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 화면 필드/플래그 변경 |  |  |  |
| AC-4580d89a | this.Load | DM0005_SaleSite_PjtModelMapping.cs:199 |  | COMBO_DATA | Data.Common | (Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1e8150a | this.Load | DM0005_SaleSite_PjtModelMapping.cs:200 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2f41d8e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMapping.cs:238 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-5580662a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMapping.cs:239 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59dfaf26 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:889 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c51b5f3d | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:892 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4c3e11b9 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:897 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a623e2a1 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0572ce1c | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:899 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-efe62e87 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:900 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9804cf21 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:901 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-937ba330 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-49399c9f | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:905 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f3946c7 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-42fbd6e0 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:907 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f835a67 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:908 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), siMain.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22af40b5 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:909 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81c8bb89 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:911 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-cb0d082d | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:912 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), "Y") | 그리드 값 설정 |  |  |  |
| AC-5c960d5a | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:913 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-19059d68 | InsertButton | DM0005_SaleSite_PjtModelMapping.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef78e2d1 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:578 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec49da84 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:580 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89a5d888 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:611 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50e84726 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2336537c | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-894f218b | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:624 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fc6acf0e | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55b7791b | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c489af8 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:655 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61c7fc9f | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:657 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2863d86 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fff06c6b | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-3c1749ff | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6945ac2d | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | 엔드포인트 요청 생성 |  |  |  |
| AC-ae94b610 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:699 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-a165a956 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:700 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-f5ee98e7 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:701 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-005a7632 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:702 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-cadafd3f | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:703 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-606b47d8 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:704 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-5dfb41e0 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:705 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | sCellPerCar | 행/컬럼 값 대입 |  |  |  |
| AC-61071189 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:706 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | sCellPerModule | 행/컬럼 값 대입 |  |  |  |
| AC-6e774194 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:707 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-9ded33bc | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:708 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-cc41497d | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-c04f0984 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-7f5992f6 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-052e7536 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:713 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cust_group"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6e178ec5 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:714 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cust_group_dtl"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-006756db | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:715 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_owner"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e97533d | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:716 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_application"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a50de436 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:717 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_route"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-155dab26 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:719 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-c59b5518 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:721 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-596803ea | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:727 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e6737d41 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:731 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-474c5679 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f384a26 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:746 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b14b047 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3658741 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:834 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | 엔드포인트 요청 생성 |  |  |  |
| AC-3990fb5a | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:835 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-866a2456 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:836 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-468e64ce | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:837 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-3748768d | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:838 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-f074b45c | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:839 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-69c8f543 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:840 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-58f63b44 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:841 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cebcdbd5 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:842 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cea86f45 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:843 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-80730701 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:844 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-7e766ab3 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:845 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-0f0f0f65 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:846 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-1de5eedf | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:847 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-59587c21 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:848 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-c6448240 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:850 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a987f630 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:854 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ if (respons… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-908e7953 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:858 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ else of (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c15766b9 | SaveButton | DM0005_SaleSite_PjtModelMapping.cs:869 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ catch ((Exception… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0005_SaleSite_PjtModelMapping.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6868ea5f | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1096 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LIAB… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |
| AC-49b50427 | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1106 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-df7350dc | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1118 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00177") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b8ba2de7 | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1120 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-88126a53 | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1121 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), "") | 그리드 값 설정 |  |  |  |
| AC-ac2d058f | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1122 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-bf75dc01 | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1129 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iModulePerCar) | 그리드 값 설정 |  |  |  |
| AC-309de0bd | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1138 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-34a5602a | dsdm.Changed | DM0005_SaleSite_PjtModelMapping.cs:1145 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.shtSubDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8979e56 | dsdm2.Changed | DM0005_SaleSite_PjtModelMapping.cs:1167 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.LIABI… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08d502e5 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1018 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb1b8f31 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1024 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76a3cd36 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1025 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd255c11 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1028 | if (siMain.IsLock(siMain.SheetName)) | FLAG | projectCode | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-c139785b | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1056 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-baaec3ac | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1057 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b2e012ca | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1058 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ff7dd2fb | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1059 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f7bb9b8f | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1071 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-41099770 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1072 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-6dd815fa | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1073 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-18538d54 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1075 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-f352d690 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1077 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), sProjectOwner) | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b84adb54 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:953 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b467810 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:953 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a079b81 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:954 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5e109f6c | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:957 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-33163052 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:957 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-702957d3 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:958 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0b6f2ecf | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:961 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9c01349 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:961 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f1641018 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:962 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6b522b83 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:968 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-4ef3d012 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:968 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9841b51 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:969 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c0c86c50 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:972 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1eb4dde | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:972 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-48c00c4e | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:973 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7f0c6d92 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:979 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-2f69bc3e | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:979 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-523a4025 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:980 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8275dab6 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:987 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSiteInfo | GetScmSiteInfobyDivision(sDivision, sScmSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae76eed3 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:995 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-f3aca593 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:996 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-a6ba73ba | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:997 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-c4f4e565 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:998 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-36db4a2a | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:1006 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-77f1ad62 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:1007 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-ed2563dc | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:1008 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-754e3af0 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMapping.cs:1009 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4310ec4 | this.spdMain.LeaveCell | DM0005_SaleSite_PjtModelMapping.cs:1364 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4eca7ac4 | this.spdMain.TopChange | DM0005_SaleSite_PjtModelMapping.cs:1372 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1df74430 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1239 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-19366e4b | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1240 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6c0028af | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1241 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-de8dbd58 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1242 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-89bf25a4 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1254 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-19a87a3f | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1255 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-00524d31 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1256 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-46bd84ec | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1258 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-a4f4a3e9 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1273 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-eec29596 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1275 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | popItem.Form_Load | (true, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ed59646b | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1276 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b402fb68 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1277 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1bfc5701 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1286 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-1f292daa | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1287 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_TYPE), sItemType) | 그리드 값 설정 |  |  |  |
| AC-d5297c0d | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1288 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelType) | 그리드 값 설정 |  |  |  |
| AC-430cf448 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMapping.cs:1289 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ece5ceb | this.spdSub.TopChange | DM0005_SaleSite_PjtModelMapping.cs:1379 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMapping.txtProject_KeyDown

진입점: this.txtProject.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f346a59 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMapping.cs:1423 | if (e.KeyCode != System.Windows.Forms.Keys.Enter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c4566bf | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMapping.cs:1444 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-7d5e0422 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMapping.cs:1445 |  | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8ac1f401 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMapping.cs:1446 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fe6d70a4 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMapping.cs:1447 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c08fb60f | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMapping.cs:1459 | if (popProject.ProjectCode != null) | VALUE_SET | txtProject.ControlValues | sProjectName | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c29de9ce | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1336 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a6d2fc57 | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1338 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c1d8ffaf | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1339 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ba7eca3c | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1340 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a907fa75 | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1346 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8828fc32 | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1305 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-00dbb2e3 | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1306 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-37e09875 | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1307 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-155dfd8a | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1308 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7ae1a07c | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1314 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0024645 | this.chkDetail.CheckedChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1213 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76664aeb | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1173 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1f4d07c | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1173 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55a07b38 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1174 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-65ca9cc2 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1178 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c69b6316 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1178 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e0d58712 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1179 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-62149f12 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1183 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-575daa3c | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1183 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a1b9e87 | this.clbDivision.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1184 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91cf5ea9 | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1206 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1559e19c | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1206 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66d2ce2b | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1207 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.ClbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fd3ce25 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1192 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-01f42e74 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1192 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d5e81c9a | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1193 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bf163ac3 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1197 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b021d130 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1197 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb9f1010 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1198 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60fc38d0 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:222 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e08305ac | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:223 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-25a7c3ed | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:225 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-681b5398 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:226 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f942b237 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:228 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d9f39bf | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:205 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-acdbfd51 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:206 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-36f91f93 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:208 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-adc88fe0 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:210 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-fdaddee9 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:210 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cea2fef4 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:213 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-ef0831fe | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:214 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-10af4c68 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:215 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-588c3192 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:216 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-42cbee44 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:217 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc191f0 | DeleteButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:269 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1986f9c | Dispose | DM0005_SaleSite_PjtModelMappingTest98_BAK.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c13deb76 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:282 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72aa2899 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:283 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6bc150d | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:286 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-84fd4e66 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:287 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-9bcf457f | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:289 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a73a1b36 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:298 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-26e57d40 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:299 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-06cf2aab | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:303 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ced4cfed | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:306 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee8d7f55 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:307 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e2ada51 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:311 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d181051 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:337 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1b0e014 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:338 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-583e7a69 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:349 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-89744d16 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:350 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4902b45e | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:356 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColum… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.PROJECT_CODE), siSub.GetColumnIndex(DefColumns.BPMS_EXIST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa346303 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:357 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColum… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siSub.GetColumnIndex(DefColumns.EditFl… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53199931 | EditButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:361 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(iRow, siSub.GetColumnIndex(Def… | GRID_LOCK | siSub.LockRange | (iRow, 0, iRow, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5265a5d | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:392 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06223d30 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:394 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34a857a6 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:402 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7262a6cd | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:406 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION") ⇒ DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION | 엔드포인트 요청 생성 |  |  |  |
| AC-bd7b0c6c | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:408 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-2f760e29 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:409 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b6400596 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:410 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-268c8414 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:411 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-6647f97e | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:412 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e7984938 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:413 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-174ad125 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:414 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-be6af759 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:415 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9f324eca | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:416 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eee1d28d | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:418 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5b3474ed | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:420 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-21234100 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:427 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-03fc9f19 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:428 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bf311cd6 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:435 | for (iRow <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-62aca7e8 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:441 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0cb3032 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:446 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-460857b6 | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:446 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a85861fe | FindButton 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:447 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / SaveButton [if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c06cf88 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:461 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-11bdaba7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:465 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE") ⇒ DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | 엔드포인트 요청 생성 |  |  |  |
| AC-7ceb954d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:467 | lambda | DATA_OP | request.Parameters["p_project_code"] | projectCode | 행/컬럼 값 대입 |  |  |  |
| AC-fd73adbc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:468 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-c9c6f151 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:469 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2c25e46f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:470 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7422f3de | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:472 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-233f766d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:474 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b23aba3b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:481 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6e2a72b2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:482 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a0be91ce | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:490 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cd7f211 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:495 |  | FLAG | saveDSSub | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-dba1c260 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:495 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-95e75e16 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:496 |  | DATA_OP | saveDSSub.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b1bfe77 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:166 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e288eb8 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:167 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.GetScmSiteInfobyDivision

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea33405e | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1392 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7104104f | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1393 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3e8e9a92 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1394 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-aadd8e85 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1395 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3b4e467e | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1398 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-437c4c0b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1408 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0005", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b820875 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1410 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b45ae9f4 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:180 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-83e4e4da | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:181 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d2ce5228 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:181 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b4ede6e | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:182 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b8ad06e7 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:186 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-b87586eb | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:186 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e35de953 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-888cdb3b | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:191 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c907a780 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:191 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19a729be | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-87bea199 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:196 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-87b4edb6 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:196 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1780ce14 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:197 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-205b421e | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:199 |  | FLAG | dtItemType | Data.Common(Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 화면 필드/플래그 변경 |  |  |  |
| AC-32a2ee00 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:199 |  | COMBO_DATA | Data.Common | (Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecd7c9e6 | this.Load | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:200 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fa0db81 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:238 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-b192c72b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:239 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0afce2d0 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00090647 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:885 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0613f0d3 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:890 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44a930c3 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:891 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd169818 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:892 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a684caf5 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:893 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f03c1772 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3913bddc | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:895 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-98024d5a | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a0ecc8d3 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:899 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c655fe07 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:900 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2e51a25 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:901 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), siMain.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1f0d058 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac5482de | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-187303c0 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:905 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), "Y") | 그리드 값 설정 |  |  |  |
| AC-a54cab77 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-d4ee5c75 | InsertButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:908 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9ff9028 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:578 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e96b0d06 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:580 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9bb683c5 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:611 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7dd89fd2 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a7ed323 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:622 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cdecf797 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:624 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1c5f9572 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:633 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7de201bd | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb5dee42 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:655 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88d6daa6 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:657 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38d9b294 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0431c680 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-5e62ea73 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e357c64 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | 엔드포인트 요청 생성 |  |  |  |
| AC-a8fbe32a | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:699 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-afd22bbf | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:700 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-6bd922ea | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:701 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-5c036ce8 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:702 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-0f97402c | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:703 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-610ea984 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:704 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-2f77c70c | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:705 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | sCellPerCar | 행/컬럼 값 대입 |  |  |  |
| AC-d4042af2 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:706 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | sCellPerModule | 행/컬럼 값 대입 |  |  |  |
| AC-f7b66f0f | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:707 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-d79ed6e8 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:708 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-9aa89de8 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-a56428b2 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-745fc9fe | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-3eeca9a0 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:712 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-d9ce659d | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:714 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b37a4b86 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98eb2c17 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:724 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-85898ec3 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:730 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-01d33893 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:739 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56280123 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:751 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bdf5de2 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:827 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION | 엔드포인트 요청 생성 |  |  |  |
| AC-95d03e33 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:828 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-57b0954b | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:829 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-13fcc506 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:830 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-80a967e1 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:831 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-f0394631 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:832 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-b333b0c0 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:833 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-8bc102bc | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:834 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f42b2ad | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:835 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-250337b5 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:836 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-6c59aace | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:837 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-048394ec | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:838 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-b88f9978 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:839 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-0a1e51f2 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:840 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-8b7bdeaf | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:841 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-d903ef83 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:843 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc41bb43 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:847 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ if (respons… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-646392f3 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:851 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ else of (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-352fb325 | SaveButton | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:862 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ catch ((Exception… | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a657db4 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1089 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LIAB… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |
| AC-c404be08 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1099 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-d8cedab5 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1111 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00177") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-abd09e25 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1113 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-ec4570a3 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1114 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), "") | 그리드 값 설정 |  |  |  |
| AC-f56043b1 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1115 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-38409f6c | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1122 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iModulePerCar) | 그리드 값 설정 |  |  |  |
| AC-8f521ab0 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1131 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-aec5b0bd | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1138 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.shtSubDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73e114a1 | dsdm2.Changed | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1160 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.LIABI… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64e08a23 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1011 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4db831c4 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1017 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e35b0934 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1018 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9daaea26 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1021 | if (siMain.IsLock(siMain.SheetName)) | FLAG | projectCode | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-e65493eb | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1049 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-421b6474 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1050 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-96469552 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1051 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9d418ef9 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1052 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dbc29ac6 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1064 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-c3c418df | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1065 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-b99f95b7 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1066 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-7c24925f | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1068 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-07be2fee | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1070 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), sProjectOwner) | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2ad3053 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:946 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6eb2260 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:946 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25ab86ca | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:947 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b122d500 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:950 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-1fea3a41 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:950 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5f0e6eab | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:951 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a10e45b1 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:954 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-6a8d0804 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:954 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a594064a | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:955 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fdc5bb45 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:961 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-c6678f6b | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:961 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41e56d21 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:962 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3dc21473 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:965 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-493834ce | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:965 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af91368b | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:966 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-21687715 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:972 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9762a69 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:972 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44e7b472 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:973 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7d7d5de5 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:980 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSiteInfo | GetScmSiteInfobyDivision(sDivision, sScmSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7bc6495 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:988 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-6c12f73b | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:989 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-4a5e989e | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:990 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-56e2043a | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:991 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-6e55e8f1 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:999 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-0d70f390 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1000 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-11a8884a | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1001 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-8e383f91 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1002 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b68a87fe | this.spdMain.LeaveCell | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1357 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc618bfb | this.spdMain.TopChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1365 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef2d4b34 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1232 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2486db04 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1233 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e5b5cce6 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1234 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8588d6fe | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1235 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-501dce80 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1247 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-0ef91762 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1248 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-33789bf5 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1249 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-5a7f255c | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1251 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-534c5ced | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1266 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-56d95bd7 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1268 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | popItem.Form_Load | (true, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c494c202 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1269 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-97b7cc87 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1270 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a0b5e23b | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1279 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-ef2f31bc | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1280 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_TYPE), sItemType) | 그리드 값 설정 |  |  |  |
| AC-55063d00 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1281 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelType) | 그리드 값 설정 |  |  |  |
| AC-dc542da9 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1282 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3e19605 | this.spdSub.TopChange | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1372 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98_BAK.txtProject_KeyDown

진입점: this.txtProject.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40886cc2 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1416 | if (e.KeyCode != System.Windows.Forms.Keys.Enter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9679ff06 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1437 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-da976f4c | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1438 |  | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2829a337 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1439 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-89ebee87 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1440 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a2ec40b2 | this.txtProject.KeyDown | DM0005_SaleSite_PjtModelMappingTest98_BAK.cs:1452 | if (popProject.ProjectCode != null) | VALUE_SET | txtProject.ControlValues | sProjectName | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c711a4bd | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2230 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-497f4956 | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2232 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dc85e2e9 | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2233 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c0ed1912 | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2234 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-790c4cec | this.btnItemId.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2240 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.btnItemId40_Click

진입점: this.btnItemId40.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6595c559 | this.btnItemId40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2543 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-0f1db600 | this.btnItemId40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2546 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b53407c4 | this.btnItemId40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2547 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-690ae494 | this.btnItemId40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2548 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bfc66ed4 | this.btnItemId40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2554 | if (popItem.ItemID != "") | VALUE_SET | txtItemId40.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67c86c6d | this.btnOwner.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2724 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ebb977d8 | this.btnOwner.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2727 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-02ac37fd | this.btnOwner.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2728 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d0b2b68c | this.btnOwner.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2729 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-581ecff0 | this.btnOwner.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2731 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.btnOwner40_Click

진입점: this.btnOwner40.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d808047c | this.btnOwner40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2745 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1d8fe0a9 | this.btnOwner40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2748 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-017b9ce1 | this.btnOwner40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2749 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2bc6d679 | this.btnOwner40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2750 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-78dce240 | this.btnOwner40.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2752 |  | VALUE_SET | txtOwner40.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e2a54f3 | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2199 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-0fe93b44 | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2200 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-20adc93c | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2201 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e2de02af | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2202 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7d5be98d | this.btnProject.Click | DM0005_SaleSite_PjtModelMappingTest98.cs:2208 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.cboDivision_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51c0d8c3 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2575 | if (siMain != null && siMain.ActiveSheet.RowCount > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7533bd2e | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2576 | if (siMain40 != null && siMain40.ActiveSheet.RowCount > 0) | GRID_SET | siMain40.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-4ffa3118 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2577 | if (siSub != null && siSub.ActiveSheet.RowCount > 0) | GRID_SET | siSub.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-894fea0f | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2581 | if (dtDivision40 == null) | FLAG | dtDivision40 | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-c35cc6ed | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2581 | if (dtDivision40 == null) | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d3eee32 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2585 | if (cboDivision40.Items.Count == 0) | LIST_REBIND | clsCtrl.setListBox | (dtDivision40, cboDivision40, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-20016534 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2591 | if (cboDivision40.Items.Count > 0) ▸ if (sDivision == "40") | UI_PROP | xtraTabControl1.SelectedTabPageIndex | 1 | 속성 SelectedTabPageIndex 설정 |  |  |  |
| AC-ddf2b8f0 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2592 | if (cboDivision40.Items.Count > 0) ▸ if (sDivision == "40") | VALUE_SET | cboDivision40.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-8e8a271f | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2596 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-496af5f3 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2596 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52f7e8f1 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2597 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3e0d6129 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2603 | if (cboDivision.ControlValues != "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0059a8e4 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2603 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80ae7723 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2604 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d795225d | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2608 | if (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-26ba4e01 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2608 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0262d908 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2609 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-22d06d29 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2613 | else of (cboDivision.ControlValues != "40") | FLAG | dtEndCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-838a3708 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2613 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3e701b1 | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2614 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer40, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4f85c50b | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2618 | else of (cboDivision.ControlValues != "40") | FLAG | dtSalesSite40 | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6b20892e | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2618 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, cboDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0e44ddfe | this.Load 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2619 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.cboDivision40_SelectedIndexChanged

진입점: cboDivision40.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faab1a7e | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2661 | if (sDivision != "40") | UI_PROP | xtraTabControl1.SelectedTabPageIndex | 0 | 속성 SelectedTabPageIndex 설정 |  |  |  |
| AC-d560990d | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2662 | if (sDivision != "40") | VALUE_SET | cboDivision.SelectedIndex | cboDivision40.SelectedIndex | 컨트롤 값 설정 |  |  |  |
| AC-6235c9c3 | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2665 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-f0cb160f | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2665 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1aeada5 | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2666 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-729899c9 | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2671 |  | FLAG | dtEndCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b88229d | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2671 |  | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac117617 | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2672 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer40, clbEndCustomer40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-094093de | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2675 |  | FLAG | dtSalesSite40 | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam40.ControlValues, clbE… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-da835775 | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2675 |  | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam40.ControlValues, clbEndCustomer4… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06cea659 | cboDivision40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2676 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite40, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716c2511 | this.chkDetail.CheckedChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2107 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.chkDetail40_CheckedChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae4c14a1 | (진입점 미연결) | DM0005_SaleSite_PjtModelMappingTest98.cs:2529 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dd36274 | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2651 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b7e1aa8 | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2651 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54d8d9c7 | this.clbEndCustomer.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2652 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.clbEndCustomer40_SelectedIndexChanged

진입점: this.clbEndCustomer40.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1619d4e4 | this.clbEndCustomer40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2701 |  | FLAG | dtSalesSite40 | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam40.ControlValues, clbE… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-3ed17224 | this.clbEndCustomer40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2701 |  | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam40.ControlValues, clbEndCustomer4… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-249b37ec | this.clbEndCustomer40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2702 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite40, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.ClbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf930a47 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2631 | if (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-24662277 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2631 | if (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d24644aa | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2632 | if (cboDivision.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f3e0c84c | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2636 | else of (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtEndCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-8ab4638b | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2636 | else of (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-83babebb | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2637 | else of (cboDivision.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer40, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c147c4f0 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2642 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-77c63698 | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2642 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7ac6f5fc | this.clbTeam.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2643 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.clbTeam40_SelectedIndexChanged

진입점: this.clbTeam40.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78b71506 | this.clbTeam40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2686 |  | FLAG | dtEndCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam40.ControlValues, UserInf… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-88ba0ea8 | this.clbTeam40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2686 |  | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam40.ControlValues, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79e16c85 | this.clbTeam40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2687 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer40, clbEndCustomer40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4754668b | this.clbTeam40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2691 |  | FLAG | dtSalesSite40 | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam40.ControlValues, sEnd… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-1711f702 | this.clbTeam40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2691 |  | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam40.ControlValues, sEndCustomer40,… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fedf160c | this.clbTeam40.SelectedIndexChanged | DM0005_SaleSite_PjtModelMappingTest98.cs:2692 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite40, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2357348 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:363 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-28c3077e | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:364 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-07da9b9c | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:366 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4967124e | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:367 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f7ddee6 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:369 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a9742c4 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:377 |  | GRID_INIT | this.AddSheet | (spdMain40, SpdSheet40.shtMain, SpdSheet40.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-629c8fe3 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:378 |  | FLAG | siMain40 | GetSheetInfo(spdMain40.Name, spdMain40.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1954bb1 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:380 |  | GRID_INIT | this.AddSheet | (spdSub40, SpdSheet40.shtSub, SpdSheet40.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d0e2cce0 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:381 |  | FLAG | siSub40 | GetSheetInfo(spdSub40.Name, spdSub40.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f79ffd40 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:383 |  | GRID_INIT | siMain40.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ba79902 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:340 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-9db5f0ad | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:341 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-a92d7b93 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:343 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dc66b19f | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:345 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-e05ab3f3 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:345 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e30f8487 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:348 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-261a9346 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:349 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b8a67456 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:350 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-b2475c97 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:351 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-20c61312 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:352 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-8ae30838 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:354 |  | UI_PROP | siSub40.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-8e9e2fef | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:355 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-13853af5 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:356 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub40.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-7d64e5b7 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:357 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-d75ccd33 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:358 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f79dff0 | DeleteButton | DM0005_SaleSite_PjtModelMappingTest98.cs:446 | if (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) … | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fa2a8f39 | DeleteButton | DM0005_SaleSite_PjtModelMappingTest98.cs:453 | else of (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain40.GetText(siMain40.ActiveRowIndex, siMain40.GetColumnIndex(CAppSetting.Stri… | DATA_OP | siMain40.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-564fc4e7 | Dispose | DM0005_SaleSite_PjtModelMappingTest98.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.EditButton1

진입점: EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da564a78 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:474 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a37eda9 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:475 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-167761b1 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:478 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a54dde42 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:479 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ad42da77 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:481 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c68a6faa | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:493 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) | CALL_EXT | f.IsRowFilteredOut | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0061c40 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:501 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a6b451bf | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:502 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), iRow, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f9e941c | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:506 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ad0325c | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:509 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-64582b27 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:510 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRow, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2f4f5c2a | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:514 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DIVISION_ID), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e9c36754 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:523 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f480cd97 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:524 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e983c0d9 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:527 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-012c8b4f | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:528 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1fa5ef7a | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:534 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColum… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.PROJECT_CODE), siSub.GetColumnIndex(DefColumns.BPMS_EXIST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-97df5104 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:535 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColum… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siSub.GetColumnIndex(DefColumns.EditFl… | 그리드 편집 잠금/해제 |  |  |  |
| AC-91746a80 | EditButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:539 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(iRow, siSub.GetColumnIndex(Def… | GRID_LOCK | siSub.LockRange | (iRow, 0, iRow, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.EditButton2

진입점: EditButton [else of (xtraTabControl1.SelectedTabPageIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-874beea8 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:559 | if (fps != null) ▸ if (fps.Name == "spdMain40") | FLAG | siMain40 | GetSheetInfo(spdMain40.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e1979ba | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:560 | if (fps != null) ▸ if (fps.Name == "spdMain40") | GRID_LOCK | siMain40.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-25aeaee9 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:562 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ if (siMain40.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ef6de55 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:571 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) | CALL_EXT | f.IsRowFilteredOut | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55b9c2fd | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:578 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.DIVISION_ID), iRow, siMain40.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-17a8f481 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:579 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER), iRow, siMain40.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e36f490 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:580 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.SOLDTO_CUSTOMER), iRow, siMain40.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b612633b | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:581 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.SOLDTO_CODE), iRow, siMain40.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e26af5a1 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:582 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.ITEM_TYPE), iRow, siMain40.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-90548f02 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:583 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.LAST_UPDATE_DATE), iRow, siMain40.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8f857613 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:584 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.CUSTOMER_MODEL), iRow, siMain40.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d26ae8a0 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:585 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.NICK_NAME), iRow, siMain40.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d255ef85 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:586 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.SCM_SITE_ID), iRow, siMain40.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5af95346 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:587 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.ITEM_CLASS_NAME), iRow, siMain40.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65633a2c | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:588 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ if (siMain40.GetValue(iRow, siMain40.GetColumnIn… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.ITEM_ID), iRow, siMain40.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-43ed8a73 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:595 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ else of (siMain40.GetValue(iRow, siMain40.GetCol… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.DIVISION_ID), iRow, siMain40.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-254c49c5 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:597 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ else of (siMain40.GetValue(iRow, siMain40.GetCol… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.ITEM_TYPE), iRow, siMain40.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-554f8633 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:598 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ else of (siMain40.GetValue(iRow, siMain40.GetCol… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.ITEM_CLASS_NAME), iRow, siMain40.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51870844 | EditButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:599 | if (fps != null) ▸ if (fps.Name == "spdMain40") ▸ for (iRow <= siMain40.GetMaxRowIndex()) ▸ else of (siMain40.GetValue(iRow, siMain40.GetCol… | GRID_LOCK | siMain40.LockRange | (iRow, siMain40.GetColumnIndex(DefColumns40.ATTRIBUTE1), iRow, siMain40.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.FindData_Main

진입점: FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] / SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18eceef1 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:628 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-300b37a5 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:630 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-467d53a1 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:638 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-060eb323 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:642 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40") ⇒ DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-714d6fda | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:644 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0fea62d5 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:645 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-11473531 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:646 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-1e219a56 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:647 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ec34cd40 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:648 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a6fac12f | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:649 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6bfdc1d2 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:650 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-a08f407c | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:651 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f48d10eb | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:652 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c583b766 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:653 | lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-e059b10a | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:655 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-50acc5dc | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:657 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-51336d06 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:664 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4fe29f7f | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:665 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e9aebc8 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:672 | for (iRow <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1984faaa | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:678 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3616688c | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:683 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c194cba | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:683 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b504a887 | FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:684 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.FindData_Main2

진입점: FindButton [else of (xtraTabControl1.SelectedTabPageIndex == 0)] / SaveButton [else of (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd42ed0e | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:700 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69189135 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:702 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fc18fd0 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:710 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c19dc184 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:714 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40") ⇒ DM.DM0005_GET_SALES_SITE_MODEL_PRODUCTION_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-246eb1d2 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:716 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-eb18ebf0 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:717 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam40.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e5cda136 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:718 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer40.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-afdcaecd | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:719 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite40.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-89c3bcd4 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:720 | lambda | DATA_OP | request.Parameters["p_project_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ad5e59e | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:721 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId40.Text | 행/컬럼 값 대입 |  |  |  |
| AC-cfd09eed | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:722 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-4814a8bb | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:723 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3e232c08 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:724 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de1d171f | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:725 | lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner40.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-2d9a98bc | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:727 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62545644 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:729 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-26038678 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:736 |  | GRID_BIND | siMain40.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3403a5cf | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:737 |  | GRID_LOCK | siMain40.LockColumn | (0, siMain40.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d073ecb | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:751 |  | GRID_INIT | siMain40.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4c34911 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:756 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-e8f07ce2 | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:756 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e69f347a | FindButton [else of (xtraTabControl1.SelectedTabPageIndex ==… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:757 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe77dcd4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:771 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7265615c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:775 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE") ⇒ DM.DM0005_GET_SALES_SITE_MODEL_PURCHASE | 엔드포인트 요청 생성 |  |  |  |
| AC-d7c771e7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:777 | lambda | DATA_OP | request.Parameters["p_project_code"] | projectCode | 행/컬럼 값 대입 |  |  |  |
| AC-b4c761e8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:778 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-832fd1a7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:779 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-764a7014 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:780 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-648d2944 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:782 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-864860d9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:784 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-22b32a74 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:791 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-86785ed6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:792 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3cd8503a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:800 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-56785088 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:805 |  | FLAG | saveDSSub | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-27781909 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:805 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a9c30773 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:806 |  | DATA_OP | saveDSSub.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b589a081 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:263 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-80dee69d | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:264 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.GetScmSiteInfobyDivision

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))] / this.spdMain40.ComboSelChange [if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column == siMain40.GetColumnIndex(DefColumns40.SCM_SITE_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75610f72 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2316 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b8862c89 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2317 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0192c3d5 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2318 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-1209d9cf | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2319 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b993a1a | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DM0005_SaleSite_PjtModelMappingTest98.cs:2322 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load / FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] / SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fec632bb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98.cs:2332 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0005_TEST", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd809518 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98.cs:2334 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.GetSpdTitle40

진입점: this.Load / FindButton [else of (xtraTabControl1.SelectedTabPageIndex == 0)] / SaveButton [else of (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27ee86d7 | this.Load 외 2 | DM0005_SaleSite_PjtModelMappingTest98.cs:2344 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0005_40", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33db0fd8 | this.Load 외 2 | DM0005_SaleSite_PjtModelMappingTest98.cs:2346 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8621bd89 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:277 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d270955e | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:278 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-abaeaeaf | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:278 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe22d303 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-18658101 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:280 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision40, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-232589ef | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:284 | if (dtDivision.Rows.Count == 1) | UI_PROP | xtraTabControl1.SelectedTabPageIndex | 1 | 속성 SelectedTabPageIndex 설정 |  |  |  |
| AC-1e63811c | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:285 | if (dtDivision.Rows.Count == 1) | VALUE_SET | cboDivision40.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-ce8111a9 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:292 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-0c7a38b5 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:292 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6324f8f | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:293 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1372ecfb | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:295 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-044db84c | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:300 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-93a8fa3c | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:300 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0003178c | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:301 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-da995c14 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:303 |  | FLAG | dtEndCustomer40 | Data.EndCustomerByDivisionSml(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… | 화면 필드/플래그 변경 |  |  |  |
| AC-39282df9 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:303 |  | COMBO_DATA | Data.EndCustomerByDivisionSml | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision40, sTeam… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e544e58 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:304 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer40, clbEndCustomer40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8dceeb61 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:309 |  | FLAG | dtSalesSite | Data.EndCustomerByDivisionSml(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… | 화면 필드/플래그 변경 |  |  |  |
| AC-81202c0e | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:309 |  | COMBO_DATA | Data.EndCustomerByDivisionSml | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae8b220e | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:310 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0f8a051d | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:313 |  | FLAG | dtSalesSite40 | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0eb8bc68 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:313 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision40, sEndC… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-79d12dee | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:314 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-53eebbd2 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:316 |  | FLAG | dtItemType | Data.Common(Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 화면 필드/플래그 변경 |  |  |  |
| AC-500a0f6d | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:316 |  | COMBO_DATA | Data.Common | (Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b965c8b5 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:317 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7f847427 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:319 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive40, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20cddf55 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:322 |  | UI_PROP | splitContainer2.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-4b23c752 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:326 | if (dtDivision.Rows.Count == 1) | UI_PROP | xtraTabControl1.SelectedTabPageIndex | 1 | 속성 SelectedTabPageIndex 설정 |  |  |  |
| AC-52c9b589 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:327 | if (dtDivision.Rows.Count == 1) | VALUE_SET | cboDivision.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d70cb2c7 | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:331 | else of (dtDivision.Rows.Count == 1) | UI_PROP | xtraTabControl1.SelectedTabPageIndex | 0 | 속성 SelectedTabPageIndex 설정 |  |  |  |
| AC-e1a33cda | this.Load | DM0005_SaleSite_PjtModelMappingTest98.cs:332 | else of (dtDivision.Rows.Count == 1) | VALUE_SET | cboDivision.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName))] / this.Load / FindButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] / SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2b08788 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98.cs:393 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fdfebd2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0005_SaleSite_PjtModelMappingTest98.cs:394 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.InitSpread40

진입점: this.Load / FindButton [else of (xtraTabControl1.SelectedTabPageIndex == 0)] / SaveButton [else of (xtraTabControl1.SelectedTabPageIndex == 0) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0fb70bb | this.Load 외 2 | DM0005_SaleSite_PjtModelMappingTest98.cs:399 |  | FLAG | dtTitle40 | GetSpdTitle40(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-b194eecb | this.Load 외 2 | DM0005_SaleSite_PjtModelMappingTest98.cs:400 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle40) | 그리드 재구성/초기화 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.InsertRow1

진입점: InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e03b1952 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-19df4889 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c24b28de | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1e6ac08c | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-da6e3d7b | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1684 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8d1631a0 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1685 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a9270c45 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1686 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5aff8632 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1689 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4a56708 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1690 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), siMain.ActiveRowIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9eaca6c9 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1691 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), siMain.ActiveRowIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-44289760 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1692 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), siMain.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d74aca6 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1693 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7baa330 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1694 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-10e1e12c | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-9d91a24f | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1697 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BPMS_EXIST), "Y") | 그리드 값 설정 |  |  |  |
| AC-644e6730 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-de429c30 | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1699 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DIVISION_ID), cboDivision.Control… | 그리드 값 설정 |  |  |  |
| AC-c5e4a3ac | InsertButton [if (xtraTabControl1.SelectedTabPageIndex == 0)… | DM0005_SaleSite_PjtModelMappingTest98.cs:1701 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PROJECT_C… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.InsertRow2

진입점: InsertButton [else of (xtraTabControl1.SelectedTabPageIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97c2377f | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1729 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | DATA_OP | siMain40.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e15ccbc5 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1734 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.TEAM_ID), siMain40.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6a07c836 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1739 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | COMBO_DATA | Data.EndCustomerByDivisionSml | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8f83631e | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1740 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | COMBO_DATA | Data.ScmSitebyEndCustomer40 | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e6c5d120 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1744 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_COMBO | siMain40.SetCellTypeCombo | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER), dtEndCustome… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d7fb2918 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1745 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_COMBO | siMain40.SetCellTypeCombo | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.SCM_SITE_ID), dtSalesSiteAu… | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-353a1274 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1746 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.DIVISION_ID), siMain40.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-60f2c84d | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1747 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.SOLDTO_CUSTOMER), siMain40.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8bdca6a | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1748 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.SOLDTO_CODE), siMain40.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c0d68a3 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1749 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.ITEM_TYPE), siMain40.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-437f5f83 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1750 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.CUSTOMER_MODEL), siMain40.A… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cee830e5 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1751 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.NICK_NAME), siMain40.Active… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db076e4f | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1752 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.LAST_UPDATE_DATE), siMain40… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81f7b3d9 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1755 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_SET | siMain40.SetValue | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.DIVISION_ID), "40") | 그리드 값 설정 |  |  |  |
| AC-f5a58f04 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1758 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_SET | siMain40.SetValue | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.VALID_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-380b6d25 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1759 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_SET | siMain40.SetValue | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.SALES_PLAN_ADJUST_YN), "Y") | 그리드 값 설정 |  |  |  |
| AC-f2ac400c | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1764 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_SET | siMain40.ActiveSheet.Cells[siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.I… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a8985e64 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1765 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_SET | siMain40.ActiveSheet.Cells[siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.O… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-ebd06023 | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1767 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.ITEM_ID), siMain40.ActiveRo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-490bedda | InsertButton [else of (xtraTabControl1.SelectedTabPageIndex … | DM0005_SaleSite_PjtModelMappingTest98.cs:1768 | if (siMain40 != null && siMain40.IsLock(siMain40.SheetName) == false) ▸ if (siMain40.SheetName == SpdSheet40.shtMain) | GRID_LOCK | siMain40.LockRange | (siMain40.ActiveRowIndex, siMain40.GetColumnIndex(DefColumns40.ITEM_CLASS_NAME), siMain40.… | 그리드 편집 잠금/해제 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.SaveData1

진입점: SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abbdabcc | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b5e600b | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35eed1dd | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:935 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83fd169a | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:937 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bea80414 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:946 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dfd382ea | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b27ec2f | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:957 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8334bb83 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6b5a55c | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:979 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-698f3122 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:981 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc15776c | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:999 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-48f76d40 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-3894929d | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cb86a2a | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1022 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 \| DM.DM0005_SAVE_SALES_SITE_MODEL… | 엔드포인트 요청 생성 |  |  |  |
| AC-dcc8990b | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-953ff46d | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1024 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-eb8a6d3c | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1025 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-aa8d3125 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1026 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-339b5983 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1027 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-1c277175 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1028 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-c3c63d64 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | sCellPerCar | 행/컬럼 값 대입 |  |  |  |
| AC-0c32e805 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1030 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | sCellPerModule | 행/컬럼 값 대입 |  |  |  |
| AC-43bea0a7 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1031 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-a262528a | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1032 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-461b7861 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1033 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-f6202009 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-7ee8004a | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1035 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-e65a0f75 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1037 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cust_group"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e3e9c372 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1038 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cust_group_dtl"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0983621c | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1039 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_owner"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89bc080d | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1040 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_application"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-aa7548bc | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1041 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_route"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7b828838 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1043 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-2b089e13 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1044 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_attribute1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-337e85ce | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1045 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_attribute2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe1b9458 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1047 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcec0667 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1053 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9245c6ae | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1057 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a0f56316 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1063 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e4d2dee | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c57fa152 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1084 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a0cf371 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1160 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 \| DM.DM0005_SAVE_SALES_SITE_MODEL… | 엔드포인트 요청 생성 |  |  |  |
| AC-51c31475 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1161 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-bc7ed30f | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1162 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-87de7e6d | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1163 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-89396fc1 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1164 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-3b32413c | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1165 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-025bdff9 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1166 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-63244039 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1167 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec7f64c1 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1168 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5465ce6d | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1169 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-8a06dc6b | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1170 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-3a1a280f | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1171 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-ba4af1c5 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1172 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-44caf742 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1173 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-fe132dc2 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1174 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-c791a527 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1176 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-370d3037 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1180 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ if (respons… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ea0f634 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1184 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ else of (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50723373 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1195 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ catch ((Exception… | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-383fd29a | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1279 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 \| DM.DM0005_SAVE_SALES_SITE_MODEL… | 엔드포인트 요청 생성 |  |  |  |
| AC-cf8f4222 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1280 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-00159721 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1281 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-d26860cf | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1282 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-4cb40be7 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1283 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-63b933a6 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1284 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-9ac04754 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1285 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-01745ea7 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1286 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b987a04f | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1287 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5f158f6c | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1288 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-23d93731 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1289 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-f524d650 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1290 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-80bd5e7c | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1291 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-44a9294b | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1292 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-a4100dfd | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1293 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-8256ae8e | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1295 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c09c2e70 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1299 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ if (respons… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd56bb01 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1303 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ try ▸ else of (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ab81189 | SaveButton [if (xtraTabControl1.SelectedTabPageIndex == 0)] | DM0005_SaleSite_PjtModelMappingTest98.cs:1314 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (iCount > 0) ▸ catch ((Exception… | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.SaveData2

진입점: SaveButton [else of (xtraTabControl1.SelectedTabPageIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b29096d | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1429 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14550215 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1431 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6455c5f8 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1440 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee3b3117 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1442 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5f69b05 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1451 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31641b93 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1453 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9738ddc8 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1462 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e645ba03 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1464 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1805f39 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1473 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9887e7d3 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1475 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bae3238f | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1484 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-85301768 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1486 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca24aa50 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1495 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be17da46 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1497 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-689d5dc0 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1506 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e58756c7 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1508 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-967f125d | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1517 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb62d1c0 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1519 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9647619 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1528 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edfc00cf | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1530 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2bcfb20d | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1539 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2edae631 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1541 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95446f20 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1550 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1fab8106 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1552 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0b83a04 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1572 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b466dffd | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1575 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ for (i <= siMain40.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) ▸ for (iRow <= siMai… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcb43984 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1595 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0005_SAVE_SALES_SITE_MODEL_PRODUCTION_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-15caa894 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1596 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-fd7ad418 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1597 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-53473e87 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1598 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-71ef567e | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1599 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-78ec3057 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1600 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-f82bdd8e | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1601 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_currency"] | sCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-a3922d79 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1602 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_car"] | sCellPerCar | 행/컬럼 값 대입 |  |  |  |
| AC-696d55f8 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1603 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cell_per_module"] | sCellPerModule | 행/컬럼 값 대입 |  |  |  |
| AC-58eac7fd | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1604 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_liability_period"] | sLiabilityPeriod | 행/컬럼 값 대입 |  |  |  |
| AC-d955e547 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1605 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sales_plan_adjust_yn"] | sSalesPlanAdjustYN | 행/컬럼 값 대입 |  |  |  |
| AC-6cc3fd49 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1606 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_hrcy_id"] | sItemHrcyId | 행/컬럼 값 대입 |  |  |  |
| AC-46d1aa3d | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1607 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bpms_exist"] | sBpmsExist | 행/컬럼 값 대입 |  |  |  |
| AC-afac02d8 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1608 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-1f38dba7 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1610 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cust_group"] | sCustGroup | 행/컬럼 값 대입 |  |  |  |
| AC-bf6b3a60 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1611 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_cust_group_dtl"] | sCustGroupDtl | 행/컬럼 값 대입 |  |  |  |
| AC-ecceaeaf | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1612 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_owner"] | sOwner | 행/컬럼 값 대입 |  |  |  |
| AC-5b0f42a3 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1613 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_application"] | sApplication | 행/컬럼 값 대입 |  |  |  |
| AC-f0dd17b9 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1614 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_route"] | sRoute | 행/컬럼 값 대입 |  |  |  |
| AC-5d64c15b | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1616 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-485ca7a4 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1617 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_attribute1"] | sAttribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-75db7dcf | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1618 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_attribute2"] | sAttribute2 | 행/컬럼 값 대입 |  |  |  |
| AC-04799b78 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1620 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e9e14f0 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1626 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if (response.DataSet.Table… | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84d88586 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1630 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b09437c2 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1636 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d65b1a1 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1645 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f0684791 | SaveButton [else of (xtraTabControl1.SelectedTabPageIndex ==… | DM0005_SaleSite_PjtModelMappingTest98.cs:1657 | if (siMain40.SheetName == SpdSheet40.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.shtMain40DataModel_Changed

진입점: dsdm40.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e7957b3 | dsdm40.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:2025 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain40.GetColumnIndex(DefColumns.LI… | GRID_SET | siMain40.SetText | (e.Row, siMain40.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7404d5b4 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1932 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LIAB… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |
| AC-d57f4a18 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1942 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-4086ac8e | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1954 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00177") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9909beac | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1956 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-c1223e00 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1957 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), "") | 그리드 값 설정 |  |  |  |
| AC-4eb29e36 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1958 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-64ffc6e7 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1965 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iModulePerCar) | 그리드 값 설정 |  |  |  |
| AC-2f9654d5 | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1974 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-315eee5b | dsdm.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:1981 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.shtSub40DataModel_Changed

진입점: dsdm2_40.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8f91495 | dsdm2_40.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:2097 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siSub40.GetColumnIndex(DefColumns.LIA… | GRID_SET | siSub40.SetText | (e.Row, siSub40.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.shtSubDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bd37935 | dsdm2.Changed | DM0005_SaleSite_PjtModelMappingTest98.cs:2003 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.LIABI… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59f8e65c | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1854 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e563f92f | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1860 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98f95939 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1861 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61e65229 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1864 | if (siMain.IsLock(siMain.SheetName)) | FLAG | projectCode | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f83f58b | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1892 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1d43b510 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1893 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7ae8f2a1 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1894 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9755b85a | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1895 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8b67846b | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1907 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-b409298b | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1908 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-1c6d625b | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1909 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-17528ce4 | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1911 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-81860b2d | this.spdMain.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:1913 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.PROJEC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), sProjectOwner) | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38b80b30 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1789 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-e8b2e038 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1789 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0f49a9a | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1790 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b28d76f5 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1793 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-1563d343 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1793 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-87a6ebaa | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1794 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a55f70b0 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1797 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-1a3c4bf2 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1797 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c5a709e6 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1798 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c308eb43 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1804 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-3bea862a | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1804 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-03aa46f2 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1805 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c1d5b125 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1808 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-27fb17fd | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1808 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef0ef049 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1809 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-573809fe | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1815 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-7d265396 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1815 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55f020ac | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1816 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1f764d36 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1823 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSiteInfo | GetScmSiteInfobyDivision(sDivision, sScmSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c86f07f | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1831 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-dc3f25dc | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1832 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-764a3675 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1833 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-a8f33573 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1834 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-9c2b3b3d | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1842 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-e95711c7 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1843 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-5b61e526 | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1844 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-a8d7ab1b | this.spdMain.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:1845 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f575ae8 | this.spdMain.LeaveCell | DM0005_SaleSite_PjtModelMappingTest98.cs:2289 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57a5fb65 | this.spdMain.TopChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2297 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain40_CellDoubleClick

진입점: this.spdMain40.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b05a162 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2388 | if (siMain40.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ffa22e2 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2393 | if (siMain40.IsLock(siMain40.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8d8cc01 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2410 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | POPUP | new SCM0002_ItembyDivisionPopupExTest98 | () | 팝업/폼 생성 |  |  |  |
| AC-4722f10b | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2414 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | POPUP | popItem.Form_Load | (true, sDivision, "ALL", "ALL", "ALL", "ALL", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4d30eb72 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2415 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7a5bc0d4 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2416 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-89b5cffd | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2430 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | GRID_SET | siMain40.SetText | (e.Row, siMain40.GetColumnIndex(DefColumns40.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-4698825a | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2431 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | GRID_SET | siMain40.SetText | (e.Row, siMain40.GetColumnIndex(DefColumns40.ITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-c05fa3a4 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2432 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | GRID_SET | siMain40.SetText | (e.Row, siMain40.GetColumnIndex(DefColumns40.ITEM_TYPE), sItemType) | 그리드 값 설정 |  |  |  |
| AC-da2b3899 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2433 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | GRID_SET | siMain40.SetText | (e.Row, siMain40.GetColumnIndex(DefColumns40.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-4726a2e1 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2434 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | GRID_SET | siMain40.SetText | (e.Row, siMain40.GetColumnIndex(DefColumns40.ITEM_CLASS_NAME), sItemclassname) | 그리드 값 설정 |  |  |  |
| AC-889d3000 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2435 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetColumnTag(e.Column) == siMain40.GetColumnTag(siMain40.GetColumnIndex(DefColu… | GRID_SET | siMain40.SetText | (e.Row, siMain40.GetColumnIndex(DefColumns40.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-aec1e37e | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2453 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Language") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3ab5b00 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2454 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1963a12 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2457 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | POPUP | new UserInfoPopup40 | () | 팝업/폼 생성 |  |  |  |
| AC-f6ebe6b5 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2459 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | UI_PROP | popup.Width | 600 | 속성 Width 설정 |  |  |  |
| AC-ecd55169 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2460 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-ea911ccd | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2461 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e075eafb | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2462 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | UI_PROP | popup.SSOUserYN | true | 속성 SSOUserYN 설정 |  |  |  |
| AC-9cc388f5 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2463 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | UI_PROP | popup.Language | language | 속성 Language 설정 |  |  |  |
| AC-c4ef4748 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2464 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | UI_PROP | popup.p_CreatedBy | base.UserInfo.UserId | 속성 p_CreatedBy 설정 |  |  |  |
| AC-9dea1ed5 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2466 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-33257d84 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2472 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.OWNER), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-70e6f73e | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2473 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.DEPT_ID), item.Dept_Name) | 그리드 값 설정 |  |  |  |
| AC-91d10083 | this.spdMain40.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2474 | else of (siMain40.IsLock(siMain40.SheetName)) ▸ if (siMain40.GetText(e.Row, siMain40.GetColumnIndex(DefColumns40.EditFlag)) == "Y" \|\| siMa… | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.TEAM_ID), item.Dept_Name) | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain40_ComboSelChange

진입점: this.spdMain40.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3f173a3 | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2499 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ if (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) | FLAG | dtSalesSite40 | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-88cb5a6d | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2499 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ if (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad50e8fb | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2500 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ if (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) | GRID_COMBO | siMain40.SetCellTypeCombo | (e.Row, siMain40.GetColumnIndex(DefColumns40.SCM_SITE_ID), dtSalesSite40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-22c4901f | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2507 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | FLAG | dtSalesSiteInfo | GetScmSiteInfobyDivision(sDivision, sScmSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9e0a791 | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2511 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SOLDTO_CODE), dtSalesSiteInfo.Rows[0][DefColu… | 그리드 값 설정 |  |  |  |
| AC-b23fed29 | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2512 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SOLDTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][… | 그리드 값 설정 |  |  |  |
| AC-dc963bb1 | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2513 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SHIPTO_CODE), dtSalesSiteInfo.Rows[0][DefColu… | 그리드 값 설정 |  |  |  |
| AC-a94142ad | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2514 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SHIPTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][… | 그리드 값 설정 |  |  |  |
| AC-4ab01d64 | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2518 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SOLDTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-33b54dea | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2519 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SOLDTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-822df27c | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2520 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SHIPTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-831fe74f | this.spdMain40.ComboSelChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2521 | if (siMain40.IsLock(siMain40.SheetName) == false) ▸ else of (e.Column == siMain40.GetColumnIndex(DefColumns40.END_CUSTOMER)) ▸ if (e.Column … | GRID_SET | siMain40.SetValue | (e.Row, siMain40.GetColumnIndex(DefColumns40.SHIPTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain40_LeaveCell

진입점: this.spdMain40.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb3f17eb | this.spdMain40.LeaveCell | DM0005_SaleSite_PjtModelMappingTest98.cs:2565 | if (e.Row != e.NewRow) ▸ if (!siSub40.IsLock(siSub40.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdMain40_TopChange

진입점: this.spdMain40.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e72c4f8b | this.spdMain40.TopChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2709 |  | GRID_INIT | siMain40.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-306575a1 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2126 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d0c3ee6d | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2127 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-563515c6 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2128 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-938cf00b | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2129 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE))) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-03ff7302 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2141 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_CODE), sProject) | 그리드 값 설정 |  |  |  |
| AC-6323819a | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2142 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-d27857a2 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2143 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-c2d35e71 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2145 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CODE)))… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-2210a371 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2160 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fbded594 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2162 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | popItem.Form_Load | (true, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3f410ec1 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2163 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ad6a8061 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2164 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-04d5a1ef | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2173 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-781354a2 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2174 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_TYPE), sItemType) | 그리드 값 설정 |  |  |  |
| AC-235d0d01 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2175 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sModelType) | 그리드 값 설정 |  |  |  |
| AC-560bfc68 | this.spdSub.CellDoubleClick | DM0005_SaleSite_PjtModelMappingTest98.cs:2176 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.GetColumnTag(e.Column) == siSub.GetColumnTag(siSub.GetColumnIndex(DefColumns.PROJECT_CO… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-948fb908 | this.spdSub.TopChange | DM0005_SaleSite_PjtModelMappingTest98.cs:2304 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0005_SaleSite_PjtModelMappingTest98.txtProject_KeyDown

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b174a54b | (진입점 미연결) | DM0005_SaleSite_PjtModelMappingTest98.cs:2352 | if (e.KeyCode != System.Windows.Forms.Keys.Enter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7c6d4da | (진입점 미연결) | DM0005_SaleSite_PjtModelMappingTest98.cs:2366 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-ddbd1c82 | (진입점 미연결) | DM0005_SaleSite_PjtModelMappingTest98.cs:2367 |  | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8ca5c2d3 | (진입점 미연결) | DM0005_SaleSite_PjtModelMappingTest98.cs:2368 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c229c600 | (진입점 미연결) | DM0005_SaleSite_PjtModelMappingTest98.cs:2369 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d9477d47 | (진입점 미연결) | DM0005_SaleSite_PjtModelMappingTest98.cs:2381 | if (popProject.ProjectCode != null) | VALUE_SET | txtProject.ControlValues | sProjectName | 컨트롤 값 설정 |  |  |  |

