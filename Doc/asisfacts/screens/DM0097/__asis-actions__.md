# AS-IS 액션 대조표 — DM0097

> 원천: `Doc/asisfacts/screens/DM0097/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1256행 · 메서드 119 · 종류 DATA_OP 222 · GRID_SET 159 · MESSAGE 144 · RETURN 126 · FLAG 105 · GRID_LOCK 84 · COMBO_DATA 72 · ENDPOINT 66 · GRID_INIT 57 · UI_PROP 43 · POPUP 42 · LIST_REBIND 41 · UI_MISC 36 · GRID_COMBO 21 · GRID_BIND 12 · VALUE_SET 10 · CALL_EXT 6 · FOCUS 4 · STATE 3 · STATE_RESET 3 · ⚠ 의미 확인 필요 6


## DM0097_SalesSiteTest.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae9d65e5 | this.chkDetail.CheckedChanged | DM0097_SalesSiteTest.cs:2254 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0097_SalesSiteTest.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04fef302 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1721 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-1a53aa7d | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1721 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71a652fc | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1722 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5b7b66dc | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1726 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-484b7bbd | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1726 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d51bff4 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1727 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3254b43c | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1731 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0009fab0 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1731 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b180c8cc | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1732 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-140ab9e5 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1734 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-b696a33a | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1734 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c30ce9e4 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1740 | if (sDivision == "40") | UI_PROP | tabPane1.SelectedPageIndex | 1 | 속성 SelectedPageIndex 설정 |  |  |  |
| AC-9f95cef5 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1741 | if (sDivision == "40") | VALUE_SET | clbDivision2.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-29d73920 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1742 | if (sDivision == "40") | FOCUS | clbDivision2.Focus | () | 포커스 이동 |  |  |  |
| AC-94ec2921 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1747 | else of (sDivision == "40") | VALUE_SET | clbDivision2.ControlValues | "All" | 컨트롤 값 설정 |  |  |  |

## DM0097_SalesSiteTest.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-019e216a | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1770 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-86a6a2f8 | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1770 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25a4111b | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1771 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0097_SalesSiteTest.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b963ceb8 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1756 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8ef43f35 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1756 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ce8121b | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1757 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e3a31868 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1761 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-dd38aeb2 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1761 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04eeabc6 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest.cs:1762 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0097_SalesSiteTest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ff16d20 | this.Load | DM0097_SalesSiteTest.cs:298 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ee120838 | this.Load | DM0097_SalesSiteTest.cs:299 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-122df43a | this.Load | DM0097_SalesSiteTest.cs:303 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubCustomer, SpdSheet.shtSubCustomer, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c1d93a40 | this.Load | DM0097_SalesSiteTest.cs:304 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubLocation, SpdSheet.shtSubLocation, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c8d11b3c | this.Load | DM0097_SalesSiteTest.cs:305 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubBucket, SpdSheet.shtSubBucket, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dc414703 | this.Load | DM0097_SalesSiteTest.cs:307 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubCustomer) | 화면 필드/플래그 변경 |  |  |  |
| AC-e1cbac9e | this.Load | DM0097_SalesSiteTest.cs:308 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubLocation) | 화면 필드/플래그 변경 |  |  |  |
| AC-1b8e7206 | this.Load | DM0097_SalesSiteTest.cs:309 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubBucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-09370463 | this.Load | DM0097_SalesSiteTest.cs:311 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6002378 | this.Load | DM0097_SalesSiteTest.cs:314 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aef5a8f5 | this.Load | DM0097_SalesSiteTest.cs:317 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ad0b990 | this.Load | DM0097_SalesSiteTest.cs:320 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9df836a | this.Load | DM0097_SalesSiteTest.cs:324 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-549837b0 | this.Load | DM0097_SalesSiteTest.cs:279 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |
| AC-52b3e3dd | this.Load | DM0097_SalesSiteTest.cs:280 |  | STATE | usrConditionPanel2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-61ab1fbf | this.Load | DM0097_SalesSiteTest.cs:281 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-b04d6ef0 | this.Load | DM0097_SalesSiteTest.cs:283 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d191fd90 | this.Load | DM0097_SalesSiteTest.cs:285 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-caf688a6 | this.Load | DM0097_SalesSiteTest.cs:285 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90f4aaaf | this.Load | DM0097_SalesSiteTest.cs:288 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-b247dd58 | this.Load | DM0097_SalesSiteTest.cs:290 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-37500ba2 | this.Load | DM0097_SalesSiteTest.cs:291 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-9823a6ba | this.Load | DM0097_SalesSiteTest.cs:292 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-bd66c1b2 | this.Load | DM0097_SalesSiteTest.cs:293 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0097_SalesSiteTest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83f07649 | DeleteButton | DM0097_SalesSiteTest.cs:409 | if (fps.Name == "spdMain") ▸ if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Strin… | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1a93d86 | DeleteButton | DM0097_SalesSiteTest.cs:416 | else of (fps.Name == "spdMain") ▸ if (siSub.GetText(siSub.ActiveRowIndex, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Str… | CALL_EXT | siSub.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0097_SalesSiteTest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2df92367 | Dispose | DM0097_SalesSiteTest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0097_SalesSiteTest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4a31f51 | EditButton | DM0097_SalesSiteTest.cs:429 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b03ec900 | EditButton | DM0097_SalesSiteTest.cs:430 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8010a5fa | EditButton | DM0097_SalesSiteTest.cs:433 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-28805a79 | EditButton | DM0097_SalesSiteTest.cs:434 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-fd199bbc | EditButton | DM0097_SalesSiteTest.cs:442 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-677fd056 | EditButton | DM0097_SalesSiteTest.cs:443 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-62204d9d | EditButton | DM0097_SalesSiteTest.cs:447 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d977c28 | EditButton | DM0097_SalesSiteTest.cs:453 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (sMyDeptID != "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Division), siMain.GetColumnIndex(DefColumns.CityName), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-59ff5911 | EditButton | DM0097_SalesSiteTest.cs:456 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (sMyDeptID != "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.GetColumnIndex(DefColumns.UpdateUser… | 그리드 편집 잠금/해제 |  |  |  |
| AC-16d472a5 | EditButton | DM0097_SalesSiteTest.cs:467 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a849f35 | EditButton | DM0097_SalesSiteTest.cs:468 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b6dcafc | EditButton | DM0097_SalesSiteTest.cs:475 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (sMyDeptID != "ADMIN") ▸ if (siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df476742 | EditButton | DM0097_SalesSiteTest.cs:479 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-32728b6b | EditButton | DM0097_SalesSiteTest.cs:480 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-140e0ffd | EditButton | DM0097_SalesSiteTest.cs:486 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.ShiptoCityName… | 그리드 편집 잠금/해제 |  |  |  |
| AC-34ec168e | EditButton | DM0097_SalesSiteTest.cs:487 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f29de36f | EditButton | DM0097_SalesSiteTest.cs:491 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.PlantId), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-071e909f | EditButton | DM0097_SalesSiteTest.cs:492 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-87ad8621 | EditButton | DM0097_SalesSiteTest.cs:496 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.Incoterms), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a156d0de | EditButton | DM0097_SalesSiteTest.cs:497 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |

## DM0097_SalesSiteTest.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-460861d9 | FindButton | DM0097_SalesSiteTest.cs:374 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest.FindData_Main

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9bdafe8 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:539 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bc0da25a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:551 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d76454f8 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:553 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b93c2ae | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:561 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5130f459 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:565 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_DATA") ⇒ DM.DM0004_GET_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-d64a5bf1 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:566 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-54a1eb19 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:567 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3101cf74 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:568 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-f50e3f85 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:569 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-07754402 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:570 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-c45811a4 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:571 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec77bf27 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:573 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fe03ff71 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:580 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-65f45f97 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:581 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-78610aae | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:590 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9f6add0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest.cs:597 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest.FindData_SubBucket

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e41ef42 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:721 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b457fcb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:728 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f970a46 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:732 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_BUCKET_DATA") ⇒ DM.DM0004_GET_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-4507cfb5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:733 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3de958f8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:734 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-3653414b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:736 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-332e0c5c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:738 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3838eed1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:745 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-474a62ba | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:746 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-034e68cb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:748 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15670883 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:755 |  | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DM0097_SalesSiteTest.FindData_SubCustomer

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24392db7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:608 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0de439bb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:612 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca9e16f9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:619 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1be5838f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:623 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA") ⇒ DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-912ccdff | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:624 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d5e72ed3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:625 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-b4f66e31 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:626 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-4e1c06cb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:628 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f438f620 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:630 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-aea3737f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:637 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8490d613 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:638 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-424dde39 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:648 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-59a83377 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:649 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-412a3565 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:657 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest.FindData_SubLocation

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub != null && siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c2af6be | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:664 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f03b9ca1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:668 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8002fd1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:675 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2667ff54 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:679 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_LOCATION_DATA") ⇒ DM.DM0004_GET_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-ea76ce21 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:680 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-340ed608 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:681 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-e10840f4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:682 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-a8018a6d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:684 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-de5af222 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:686 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1a8d9552 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:693 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e0bc1334 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:694 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-db9a75fb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:704 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9a47f1aa | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest.cs:712 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa36323f | this.Load | DM0097_SalesSiteTest.cs:221 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-746f452e | this.Load | DM0097_SalesSiteTest.cs:222 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0097_SalesSiteTest.GetPlantbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08b0e229 | (진입점 미연결) | DM0097_SalesSiteTest.cs:2292 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5b9a30c8 | (진입점 미연결) | DM0097_SalesSiteTest.cs:2293 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-05659672 | (진입점 미연결) | DM0097_SalesSiteTest.cs:2294 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-090a1f7a | (진입점 미연결) | DM0097_SalesSiteTest.cs:2297 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0dfbcfbc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest.cs:2280 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0004", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32ca2f53 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest.cs:2282 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1862d6a7 | this.Load | DM0097_SalesSiteTest.cs:236 |  | UI_PROP | tabPane1.SelectedPageIndex | 0 | 속성 SelectedPageIndex 설정 |  |  |  |
| AC-04d096cc | this.Load | DM0097_SalesSiteTest.cs:239 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-ab685799 | this.Load | DM0097_SalesSiteTest.cs:239 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d50a40a4 | this.Load | DM0097_SalesSiteTest.cs:240 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ad95df80 | this.Load | DM0097_SalesSiteTest.cs:243 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-44d8d55d | this.Load | DM0097_SalesSiteTest.cs:247 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-5888cc88 | this.Load | DM0097_SalesSiteTest.cs:247 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f7f03b9 | this.Load | DM0097_SalesSiteTest.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cc15b19f | this.Load | DM0097_SalesSiteTest.cs:252 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-dba50143 | this.Load | DM0097_SalesSiteTest.cs:252 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-30f8dcd0 | this.Load | DM0097_SalesSiteTest.cs:254 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-155614f8 | this.Load | DM0097_SalesSiteTest.cs:258 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8db34ee3 | this.Load | DM0097_SalesSiteTest.cs:258 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1801c83a | this.Load | DM0097_SalesSiteTest.cs:260 |  | FLAG | dtDetailSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-2ae4c76d | this.Load | DM0097_SalesSiteTest.cs:260 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fae855d | this.Load | DM0097_SalesSiteTest.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b195b1c9 | this.Load | DM0097_SalesSiteTest.cs:263 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-152116b1 | this.Load | DM0097_SalesSiteTest.cs:265 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-f068c2eb | this.Load | DM0097_SalesSiteTest.cs:265 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-af8704e4 | this.Load | DM0097_SalesSiteTest.cs:267 |  | FLAG | dtTeamAll | Data.Common(Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 화면 필드/플래그 변경 |  |  |  |
| AC-3c161ecf | this.Load | DM0097_SalesSiteTest.cs:267 |  | COMBO_DATA | Data.Common | (Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0097_SalesSiteTest.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e1bcafe | this.Load | DM0097_SalesSiteTest.cs:351 |  | FLAG | dtSubBucket | new DataTable("SubSubBucketSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-d8b26459 | this.Load | DM0097_SalesSiteTest.cs:352 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-052cf972 | this.Load | DM0097_SalesSiteTest.cs:353 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.SiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-031439b7 | this.Load | DM0097_SalesSiteTest.cs:354 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19c4bf7c | this.Load | DM0097_SalesSiteTest.cs:355 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e185f00 | this.Load | DM0097_SalesSiteTest.cs:356 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.BucketPer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e000921 | this.Load | DM0097_SalesSiteTest.cs:357 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0097_SalesSiteTest.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ed3d108 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest.cs:329 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-ccdab79b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest.cs:330 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0097_SalesSiteTest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a345019 | InsertButton | DM0097_SalesSiteTest.cs:1474 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-07481b67 | InsertButton | DM0097_SalesSiteTest.cs:1476 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8dc2a043 | InsertButton | DM0097_SalesSiteTest.cs:1479 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9737d3f7 | InsertButton | DM0097_SalesSiteTest.cs:1489 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.Ge… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-f458226e | InsertButton | DM0097_SalesSiteTest.cs:1489 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInde… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37d6f21b | InsertButton | DM0097_SalesSiteTest.cs:1490 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b54ddcf4 | InsertButton | DM0097_SalesSiteTest.cs:1492 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.G… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-5789c222 | InsertButton | DM0097_SalesSiteTest.cs:1492 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInd… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90b5eb43 | InsertButton | DM0097_SalesSiteTest.cs:1494 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cfc9ee13 | InsertButton | DM0097_SalesSiteTest.cs:1495 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2dd9ac54 | InsertButton | DM0097_SalesSiteTest.cs:1498 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SiteId), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcedd22b | InsertButton | DM0097_SalesSiteTest.cs:1499 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fe7c259 | InsertButton | DM0097_SalesSiteTest.cs:1504 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-aab14b23 | InsertButton | DM0097_SalesSiteTest.cs:1505 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CountryNa… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-72f200ad | InsertButton | DM0097_SalesSiteTest.cs:1506 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CityName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6788f334 | InsertButton | DM0097_SalesSiteTest.cs:1508 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-5e93e16e | InsertButton | DM0097_SalesSiteTest.cs:1510 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-18719633 | InsertButton | DM0097_SalesSiteTest.cs:1516 | else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f318f39 | InsertButton | DM0097_SalesSiteTest.cs:1520 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-48be4284 | InsertButton | DM0097_SalesSiteTest.cs:1522 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9a252c13 | InsertButton | DM0097_SalesSiteTest.cs:1525 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ab89b2a6 | InsertButton | DM0097_SalesSiteTest.cs:1528 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.A… | 그리드 값 설정 |  |  |  |
| AC-5fe7a848 | InsertButton | DM0097_SalesSiteTest.cs:1529 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId), siMain.GetValue(siMain.Act… | 그리드 값 설정 |  |  |  |
| AC-a7fd6dff | InsertButton | DM0097_SalesSiteTest.cs:1533 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4cbeca83 | InsertButton | DM0097_SalesSiteTest.cs:1534 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-05d0c1a5 | InsertButton | DM0097_SalesSiteTest.cs:1535 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65710490 | InsertButton | DM0097_SalesSiteTest.cs:1536 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-cb8e5699 | InsertButton | DM0097_SalesSiteTest.cs:1538 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a8fb989b | InsertButton | DM0097_SalesSiteTest.cs:1539 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1077668f | InsertButton | DM0097_SalesSiteTest.cs:1541 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.RepYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-fb2ebea7 | InsertButton | DM0097_SalesSiteTest.cs:1542 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-fd775a9f | InsertButton | DM0097_SalesSiteTest.cs:1546 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f4923dd | InsertButton | DM0097_SalesSiteTest.cs:1547 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), siSub.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d613b10 | InsertButton | DM0097_SalesSiteTest.cs:1548 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-f472a02f | InsertButton | DM0097_SalesSiteTest.cs:1549 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationCode… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-03fc584d | InsertButton | DM0097_SalesSiteTest.cs:1553 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-83937623 | InsertButton | DM0097_SalesSiteTest.cs:1554 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-2800ed10 | InsertButton | DM0097_SalesSiteTest.cs:1558 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest.SaveData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15944d0c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:766 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efab0377 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:825 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-236b2ace | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:827 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a68180a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:836 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c196ac46 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:838 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef3b6e4a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:847 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec319399 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:849 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8a6ea21 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:858 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d2decda | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:860 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e09a780f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:869 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c68ede27 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:871 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-153aac0c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:880 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df902646 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:882 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8e15af2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:891 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2e9e5b6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:893 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33e6dc94 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:902 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d4794bc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:904 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba95d66d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:919 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-65aac70d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:920 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-d8aa1410 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:921 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-98fda1fc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:922 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-ccaf418b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:923 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_description"] | sSalesSiteDesc | 행/컬럼 값 대입 |  |  |  |
| AC-88182158 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:924 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-207c7861 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:925 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sold_customer"] | sSoldToCode | 행/컬럼 값 대입 |  |  |  |
| AC-dd6bfbcf | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:926 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_city"] | sCity | 행/컬럼 값 대입 |  |  |  |
| AC-013ffb47 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:927 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_country"] | sCountry | 행/컬럼 값 대입 |  |  |  |
| AC-75dcfa8c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:928 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-5fcf730d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:929 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-00ca3292 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:930 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-8b420ec9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:931 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-7fda1261 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:933 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a2f5eda | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:937 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a26b394d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:942 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1230acb6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:949 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 화면 필드/플래그 변경 |  |  |  |
| AC-74b7cdb5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:949 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e2739d0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:950 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bcce53ff | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:954 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, U… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-e1744948 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:954 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b1d98a28 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:955 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f9006752 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:966 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a0eadc8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest.cs:975 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest.SaveSubBucketData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dc6eb85 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1339 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-073a3ea6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1394 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5f1c2a9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1395 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0baaa6b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1400 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c4ef71d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1401 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ebe4607 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1406 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44e86cbc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1407 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8b7685c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1420 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-47b06592 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1421 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-dd1270dd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1422 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-658b9534 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1423 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-fe275f36 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1424 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_Incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-3e1f75d3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1425 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-87dd594d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1426 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bucket_per"] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-5507e647 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1427 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_conversion_type"] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-efd1868a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1429 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-0556a832 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1431 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-585b3851 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1435 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f9ffd64 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1439 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5173cba2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1451 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f54b6c22 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1460 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest.SaveSubCustomerData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c19bdc4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:986 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73390fcd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1014 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00120") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2decb469 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1015 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea0c660b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1052 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1342a50b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1054 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa720c73 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1063 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3b01f1b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1065 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f9852b66 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1074 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d04094a3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1076 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c34a87e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1085 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dfa1a914 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1087 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3241216f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1103 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-a357ec5e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1104 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-d82900b9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1105 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-1cb6408a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1106 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-f0b102de | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1107 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_code"] | sSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-559cb63d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1108 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_description"] | sSoldToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-99c973bc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1109 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_code"] | sShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-1609dd10 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1110 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_description"] | sShipToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-0e59f9ad | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1111 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_rep_yn"] | sRepYN | 행/컬럼 값 대입 |  |  |  |
| AC-5b61d9aa | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1112 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-de89ba60 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1113 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-157b32e0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1115 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0134b20 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1124 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00179", new object[] { SalesSiteId, ShipToCode }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c848a15 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1128 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ els… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9da74467 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1133 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ccfc672 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1146 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8001e3d8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest.cs:1155 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest.SaveSubLocationData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b46b25d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1164 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34029afb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1227 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45156b08 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1229 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b29f3bfc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1238 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69b6750c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1240 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a63fbd62 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1264 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-492553e8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1266 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationCode), "") | 그리드 값 설정 |  |  |  |
| AC-b71e0ef3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1267 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationDescription), "") | 그리드 값 설정 |  |  |  |
| AC-9bd3903f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1268 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.PlantId), "") | 그리드 값 설정 |  |  |  |
| AC-5ac74e94 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1270 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12df6ab8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1289 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-aa3cb04f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1290 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-954bfa13 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1291 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_seq"] | sLocationSeq | 행/컬럼 값 대입 |  |  |  |
| AC-dfcf1700 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1292 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-5645d944 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1293 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_code"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-f9853728 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1294 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_description"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-a1b6566a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1295 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-a749e060 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1296 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_id"] | sPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-43bfd97d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1297 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_storage_id"] | sStorageId | 행/컬럼 값 대입 |  |  |  |
| AC-af66ce20 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1298 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-2f6ab982 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1299 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-7af57fe8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1301 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e0ce9a4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1305 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e3a8bc4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1309 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56a6560e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1322 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18d8694f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest.cs:1331 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest.SetSubBucketData

진입점: dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-347495bb | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2125 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ce15629 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2129 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a918e79f | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2130 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-c43e5063 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2131 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SiteId] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-dc0e1e7f | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2132 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-f41fecf1 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2133 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-5085e223 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2134 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-30e738e2 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2135 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-50215033 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2137 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-e947b34d | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2138 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-250f776a | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2142 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-90278125 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest.cs:2143 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0097_SalesSiteTest.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b599bde1 | dsdm.Changed | DM0097_SalesSiteTest.cs:2190 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Sold… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), sScmSite) | 그리드 값 설정 |  |  |  |
| AC-313aabdb | dsdm.Changed | DM0097_SalesSiteTest.cs:2202 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-77a1ef81 | dsdm.Changed | DM0097_SalesSiteTest.cs:2220 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9cdc801 | dsdm.Changed | DM0097_SalesSiteTest.cs:2222 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-74a83bfc | dsdm.Changed | DM0097_SalesSiteTest.cs:2233 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-33d8fccf | dsdm.Changed | DM0097_SalesSiteTest.cs:2234 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-ed91b4bb | dsdm.Changed | DM0097_SalesSiteTest.cs:2241 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |
| AC-130a0ea5 | dsdm.Changed | DM0097_SalesSiteTest.cs:2242 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest.shtSubBucketDataModel_Changed

진입점: dsdm3.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-140a5abf | dsdm3.Changed | DM0097_SalesSiteTest.cs:2060 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f026b19 | dsdm3.Changed | DM0097_SalesSiteTest.cs:2061 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d5733c3 | dsdm3.Changed | DM0097_SalesSiteTest.cs:2066 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba092206 | dsdm3.Changed | DM0097_SalesSiteTest.cs:2067 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2171fd13 | dsdm3.Changed | DM0097_SalesSiteTest.cs:2072 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65d714d3 | dsdm3.Changed | DM0097_SalesSiteTest.cs:2073 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0603b56e | dsdm3.Changed | DM0097_SalesSiteTest.cs:2104 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a54d341a | dsdm3.Changed | DM0097_SalesSiteTest.cs:2106 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.Incoterms), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest.shtSubCustomerDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d951f34 | dsdm2.Changed | DM0097_SalesSiteTest.cs:1978 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | MESSAGE | MessageHelper.GMessageBox | ("MSG00149") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d63c1f74 | dsdm2.Changed | DM0097_SalesSiteTest.cs:1979 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | GRID_SET | siSub.SetValue | (e.Row, e.Column, "N") | 그리드 값 설정 |  |  |  |
| AC-af0de5dc | dsdm2.Changed | DM0097_SalesSiteTest.cs:2007 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be94ab1f | dsdm2.Changed | DM0097_SalesSiteTest.cs:2009 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), "") | 그리드 값 설정 |  |  |  |
| AC-84fa7c83 | dsdm2.Changed | DM0097_SalesSiteTest.cs:2010 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), "") | 그리드 값 설정 |  |  |  |
| AC-607ba8ba | dsdm2.Changed | DM0097_SalesSiteTest.cs:2011 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |
| AC-2a1174ec | dsdm2.Changed | DM0097_SalesSiteTest.cs:2012 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1d1bb0b | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1570 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df5351f1 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1576 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79c799e7 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1577 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9f5d93a | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1584 | if (siMain.IsLock(siMain.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e31b333 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1601 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.String… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-420a16ca | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1620 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), "") | 그리드 값 설정 |  |  |  |
| AC-0d44d247 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1622 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | new SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-25a12d41 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1624 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.Form_Load | (false, sDivisionId, sSoldToName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9a25bfc9 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1625 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | UI_PROP | popSoldto.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bf9d5b71 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1626 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0bb83132 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1633 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), sSoldToCode.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-9a7d9759 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1634 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldToName), sSoldToName.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-10e5b8c3 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1656 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-54a61d19 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1657 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-82d452e0 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1658 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b5c756b4 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1668 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | msScmSite | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) + "_" + sCity.Substring(0,… | 화면 필드/플래그 변경 |  |  |  |
| AC-76f3cb3e | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1671 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | mbScmSite | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f0f517bd | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1674 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), sCountry) | 그리드 값 설정 |  |  |  |
| AC-8b345130 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1675 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CountryName), sCountryName) | 그리드 값 설정 |  |  |  |
| AC-612e13f0 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1676 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), sCity) | 그리드 값 설정 |  |  |  |
| AC-fc0082f1 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1677 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CityName), sCityName) | 그리드 값 설정 |  |  |  |
| AC-f7bc640b | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1696 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-74cf1ec3 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1698 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0f3062f5 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1699 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-17706779 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1700 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5e39160e | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1707 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-9e54e303 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest.cs:1708 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sTeamName) | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aa967e8 | this.spdMain.ComboSelChange | DM0097_SalesSiteTest.cs:1790 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-7a5ed3ca | this.spdMain.ComboSelChange | DM0097_SalesSiteTest.cs:1790 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44ead2ad | this.spdMain.ComboSelChange | DM0097_SalesSiteTest.cs:1796 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c31f87bc | this.spdMain.ComboSelChange | DM0097_SalesSiteTest.cs:1798 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-e5d83214 | this.spdMain.ComboSelChange | DM0097_SalesSiteTest.cs:1798 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ef7ba68c | this.spdMain.ComboSelChange | DM0097_SalesSiteTest.cs:1799 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0097_SalesSiteTest.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d03d5d6e | this.spdMain.EditChange | DM0097_SalesSiteTest.cs:1914 | if (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), "") | 그리드 값 설정 |  |  |  |
| AC-a3fbafdc | this.spdMain.EditChange | DM0097_SalesSiteTest.cs:1918 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-8d266329 | this.spdMain.EditChange | DM0097_SalesSiteTest.cs:1922 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) ▸ if … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b17459a4 | this.spdMain.LeaveCell | DM0097_SalesSiteTest.cs:1952 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0097_SalesSiteTest.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fbcce29 | (진입점 미연결) | DM0097_SalesSiteTest.cs:2260 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTest.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca53029c | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTest.cs:1938 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-a98fb44d | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTest.cs:1940 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28cadb3e | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTest.cs:1941 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77600fe5 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1843 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16f699c3 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1857 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-64a74f32 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1859 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.Form_Load | (false, sDivisionId, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-69c8eb3f | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1860 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-625dbff9 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1861 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-df593d02 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1870 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-9d90a89d | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1871 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), popCustomer.SoldToDesc) | 그리드 값 설정 |  |  |  |
| AC-a47a66e9 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1872 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-b1b67c89 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1873 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), popCustomer.ShipToDesc) | 그리드 값 설정 |  |  |  |
| AC-de3ea769 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1874 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName), popCustomer.ShiptoRegion) | 그리드 값 설정 |  |  |  |
| AC-f0cf6c6b | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1875 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName), popCustomer.ShiptoCity) | 그리드 값 설정 |  |  |  |
| AC-6bd554cc | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1887 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | new SCM0002_StoragebyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-446af14e | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1889 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.Form_Load | (false, sDivisionId, sLocationCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6211cb12 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1890 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | UI_PROP | popLocation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7e7816b4 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1891 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-40716aef | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1898 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationCode), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-f7e583b1 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1899 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationDescription), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-1a73b7bf | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1901 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.StorageId), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-e63d55c5 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest.cs:1902 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PlantId), popLocation.PlantId) | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6474b4a3 | this.spdSub.ComboSelChange | DM0097_SalesSiteTest.cs:1832 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d34a7d9f | this.spdSub.ComboSelChange | DM0097_SalesSiteTest.cs:1832 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-736abc13 | this.spdSub.ComboSelChange | DM0097_SalesSiteTest.cs:1835 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SiteId), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0097_SalesSiteTest.spdSub_EditChange

진입점: this.spdSub.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6e7f7b2 | this.spdSub.EditChange | DM0097_SalesSiteTest.cs:1930 | if (e.Column == siSub.GetColumnIndex(DefColumns.SoldToCode)) | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest.spdSub_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3279e221 | (진입점 미연결) | DM0097_SalesSiteTest.cs:2267 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTest.tabPane1_SelectedPageChanged

진입점: this.tabPane1.SelectedPageChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bbc5ddb | this.tabPane1.SelectedPageChanged | DM0097_SalesSiteTest.cs:2308 |  | FOCUS | clbDivision2.Focus | () | 포커스 이동 |  |  |  |

## DM0097_SalesSiteTest4.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bda89d03 | this.chkDetail.CheckedChanged | DM0097_SalesSiteTest4.cs:2280 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0097_SalesSiteTest4.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdedbfef | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1723 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-0ed51dec | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1723 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac3f216f | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1724 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7e19602e | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1728 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a4951065 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1728 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-77d5cffe | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1729 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2f01d836 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1733 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7708264c | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1733 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b3aa9fc | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1734 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bc88a372 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1736 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e135923 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1736 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52d4d413 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1742 | if (sDivision == "40") | UI_PROP | xtraTabControl1.SelectedTabPageIndex | 1 | 속성 SelectedTabPageIndex 설정 |  |  |  |
| AC-34543c0d | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1743 | if (sDivision == "40") | VALUE_SET | clbDivision2.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-23664afa | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1744 | if (sDivision == "40") | FOCUS | clbDivision2.Focus | () | 포커스 이동 |  |  |  |
| AC-95c6ef9a | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1746 | if (sDivision == "40") | VALUE_SET | lblEndCustomer.Text | sOrgEndCustomer | 컨트롤 값 설정 |  |  |  |
| AC-8be64f04 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1751 | else of (sDivision == "40") ▸ if (sDivision == "81") | VALUE_SET | lblEndCustomer.Text | lblEndCustomer.Text + "/81" | 컨트롤 값 설정 |  |  |  |
| AC-349b50fc | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1772 | else of (sDivision == "40") ▸ else of (sDivision == "81") | VALUE_SET | clbDivision2.ControlValues | "All" | 컨트롤 값 설정 |  |  |  |
| AC-f7283055 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1773 | else of (sDivision == "40") ▸ else of (sDivision == "81") | VALUE_SET | lblEndCustomer.Text | sOrgEndCustomer | 컨트롤 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8bf63d0 | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1796 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-665ebfb3 | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1796 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eddc86bc | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1797 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0097_SalesSiteTest4.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5acb9f13 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1782 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5163eb04 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1782 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-30a054a8 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1783 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-07d042c9 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1787 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-658e0d50 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1787 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d792d6e | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTest4.cs:1788 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0097_SalesSiteTest4.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f586e10a | this.Load | DM0097_SalesSiteTest4.cs:298 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b0fd33a | this.Load | DM0097_SalesSiteTest4.cs:299 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a949dc7 | this.Load | DM0097_SalesSiteTest4.cs:303 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubCustomer, SpdSheet.shtSubCustomer, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-73f169d9 | this.Load | DM0097_SalesSiteTest4.cs:304 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubLocation, SpdSheet.shtSubLocation, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-097b11dd | this.Load | DM0097_SalesSiteTest4.cs:305 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubBucket, SpdSheet.shtSubBucket, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3be7dd28 | this.Load | DM0097_SalesSiteTest4.cs:307 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubCustomer) | 화면 필드/플래그 변경 |  |  |  |
| AC-0689fc88 | this.Load | DM0097_SalesSiteTest4.cs:308 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubLocation) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a41a268 | this.Load | DM0097_SalesSiteTest4.cs:309 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubBucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3d22ed8 | this.Load | DM0097_SalesSiteTest4.cs:311 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1c24df1 | this.Load | DM0097_SalesSiteTest4.cs:314 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2482f261 | this.Load | DM0097_SalesSiteTest4.cs:317 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ade39885 | this.Load | DM0097_SalesSiteTest4.cs:320 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63c75c15 | this.Load | DM0097_SalesSiteTest4.cs:324 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTest4.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba79d089 | this.Load | DM0097_SalesSiteTest4.cs:279 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |
| AC-4f139279 | this.Load | DM0097_SalesSiteTest4.cs:280 |  | STATE | usrConditionPanel2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0977e2f4 | this.Load | DM0097_SalesSiteTest4.cs:281 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-fa783fd3 | this.Load | DM0097_SalesSiteTest4.cs:283 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-84a5f35a | this.Load | DM0097_SalesSiteTest4.cs:285 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-acc94496 | this.Load | DM0097_SalesSiteTest4.cs:285 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-99c8dbee | this.Load | DM0097_SalesSiteTest4.cs:288 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f4e7c32c | this.Load | DM0097_SalesSiteTest4.cs:290 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6ae47f1d | this.Load | DM0097_SalesSiteTest4.cs:291 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-550a8d2f | this.Load | DM0097_SalesSiteTest4.cs:292 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-3a3faf7a | this.Load | DM0097_SalesSiteTest4.cs:293 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0097_SalesSiteTest4.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9c47f8e | DeleteButton | DM0097_SalesSiteTest4.cs:409 | if (fps.Name == "spdMain") ▸ if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Strin… | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-247db297 | DeleteButton | DM0097_SalesSiteTest4.cs:416 | else of (fps.Name == "spdMain") ▸ if (siSub.GetText(siSub.ActiveRowIndex, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Str… | CALL_EXT | siSub.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0097_SalesSiteTest4.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5484d6cb | Dispose | DM0097_SalesSiteTest4.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0097_SalesSiteTest4.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-226726c2 | EditButton | DM0097_SalesSiteTest4.cs:429 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a421aff4 | EditButton | DM0097_SalesSiteTest4.cs:430 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e5d4c48 | EditButton | DM0097_SalesSiteTest4.cs:433 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-da80fd29 | EditButton | DM0097_SalesSiteTest4.cs:434 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-167098d6 | EditButton | DM0097_SalesSiteTest4.cs:442 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d39ac1fa | EditButton | DM0097_SalesSiteTest4.cs:443 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8935174c | EditButton | DM0097_SalesSiteTest4.cs:447 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8bd2952f | EditButton | DM0097_SalesSiteTest4.cs:453 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (sMyDeptID != "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Division), siMain.GetColumnIndex(DefColumns.CityName), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-968b25d1 | EditButton | DM0097_SalesSiteTest4.cs:456 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (sMyDeptID != "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.GetColumnIndex(DefColumns.UpdateUser… | 그리드 편집 잠금/해제 |  |  |  |
| AC-985c78aa | EditButton | DM0097_SalesSiteTest4.cs:467 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b7bf59e | EditButton | DM0097_SalesSiteTest4.cs:468 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fab5ceab | EditButton | DM0097_SalesSiteTest4.cs:475 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (sMyDeptID != "ADMIN") ▸ if (siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9e8f50f | EditButton | DM0097_SalesSiteTest4.cs:479 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc3d8026 | EditButton | DM0097_SalesSiteTest4.cs:480 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b536698c | EditButton | DM0097_SalesSiteTest4.cs:486 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.ShiptoCityName… | 그리드 편집 잠금/해제 |  |  |  |
| AC-67c8bf5e | EditButton | DM0097_SalesSiteTest4.cs:487 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c560aa50 | EditButton | DM0097_SalesSiteTest4.cs:491 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.PlantId), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ffb87672 | EditButton | DM0097_SalesSiteTest4.cs:492 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6289ce17 | EditButton | DM0097_SalesSiteTest4.cs:496 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.Incoterms), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eeba4753 | EditButton | DM0097_SalesSiteTest4.cs:497 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |

## DM0097_SalesSiteTest4.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a81fee8 | FindButton | DM0097_SalesSiteTest4.cs:374 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest4.FindData_Main

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6a17da0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:539 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-917d0c26 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:551 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f4dd8a2 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:553 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-072cc295 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:561 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f96f8e03 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:565 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_DATA") ⇒ DM.DM0004_GET_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-72ce8071 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:566 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-127a1bb8 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:567 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-20f711f6 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:568 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-dae14677 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:569 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e1a40d73 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:570 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-afc80063 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:571 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e16c693 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:573 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9750a55a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:580 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-377457db | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:581 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-105d6155 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:590 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d22b869 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTest4.cs:597 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest4.FindData_SubBucket

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d12251f8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:721 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91bdf477 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:728 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89ff19e4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:732 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_BUCKET_DATA") ⇒ DM.DM0004_GET_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-04781fce | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:733 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b88f751c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:734 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-e8801f0e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:736 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-024df4a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:738 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1ee822a3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:745 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-96664248 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:746 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad6f8b03 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:748 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f1aa2ff | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:755 |  | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DM0097_SalesSiteTest4.FindData_SubCustomer

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0da0233d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:608 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-64864c5c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:612 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb89d166 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:619 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c46954d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:623 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA") ⇒ DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-33627b0d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:624 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7640a16c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:625 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-aa66a674 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:626 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-fa035a34 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:628 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f57aa086 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:630 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-cd4bd64a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:637 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-923f4795 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:638 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-542cf0af | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:648 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f35ed4ce | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:649 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b206db4c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:657 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest4.FindData_SubLocation

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub != null && siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e7b6fba | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:664 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9f24bf40 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:668 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1886f83c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:675 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27c5d915 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:679 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_LOCATION_DATA") ⇒ DM.DM0004_GET_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c64697e5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:680 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e56dacad | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:681 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-e2b03d27 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:682 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-86b696f2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:684 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35b75d55 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:686 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0a6d7bde | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:693 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e0ed5e20 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:694 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c2f30d59 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:704 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b2e1c403 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTest4.cs:712 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest4.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbc9a0eb | this.Load | DM0097_SalesSiteTest4.cs:221 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-059b5dfd | this.Load | DM0097_SalesSiteTest4.cs:222 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0097_SalesSiteTest4.GetPlantbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88bdfaf6 | (진입점 미연결) | DM0097_SalesSiteTest4.cs:2318 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-86f2bab7 | (진입점 미연결) | DM0097_SalesSiteTest4.cs:2319 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cd17dff1 | (진입점 미연결) | DM0097_SalesSiteTest4.cs:2320 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2e052ce | (진입점 미연결) | DM0097_SalesSiteTest4.cs:2323 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest4.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bc41a2f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest4.cs:2306 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0004", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-221d0283 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest4.cs:2308 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest4.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc82b071 | this.Load | DM0097_SalesSiteTest4.cs:236 |  | UI_PROP | xtraTabControl1.SelectedTabPageIndex | 0 | 속성 SelectedTabPageIndex 설정 |  |  |  |
| AC-01323356 | this.Load | DM0097_SalesSiteTest4.cs:239 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b066360 | this.Load | DM0097_SalesSiteTest4.cs:239 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd6211e2 | this.Load | DM0097_SalesSiteTest4.cs:240 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7c4c2cdc | this.Load | DM0097_SalesSiteTest4.cs:243 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-80087195 | this.Load | DM0097_SalesSiteTest4.cs:247 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-5d99fddf | this.Load | DM0097_SalesSiteTest4.cs:247 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b4faa1da | this.Load | DM0097_SalesSiteTest4.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e67145e6 | this.Load | DM0097_SalesSiteTest4.cs:252 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a72e4519 | this.Load | DM0097_SalesSiteTest4.cs:252 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f36c67ff | this.Load | DM0097_SalesSiteTest4.cs:254 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c86a34c1 | this.Load | DM0097_SalesSiteTest4.cs:258 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7c704a89 | this.Load | DM0097_SalesSiteTest4.cs:258 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f857c06c | this.Load | DM0097_SalesSiteTest4.cs:260 |  | FLAG | dtDetailSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-263af775 | this.Load | DM0097_SalesSiteTest4.cs:260 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fd5deaa | this.Load | DM0097_SalesSiteTest4.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-50c04316 | this.Load | DM0097_SalesSiteTest4.cs:263 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-45783a65 | this.Load | DM0097_SalesSiteTest4.cs:265 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-eafae4a8 | this.Load | DM0097_SalesSiteTest4.cs:265 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-856025e9 | this.Load | DM0097_SalesSiteTest4.cs:267 |  | FLAG | dtTeamAll | Data.Common(Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 화면 필드/플래그 변경 |  |  |  |
| AC-c9877ae1 | this.Load | DM0097_SalesSiteTest4.cs:267 |  | COMBO_DATA | Data.Common | (Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0097_SalesSiteTest4.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b65248cb | this.Load | DM0097_SalesSiteTest4.cs:351 |  | FLAG | dtSubBucket | new DataTable("SubSubBucketSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-433a2081 | this.Load | DM0097_SalesSiteTest4.cs:352 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11197d75 | this.Load | DM0097_SalesSiteTest4.cs:353 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.SiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9e625b8 | this.Load | DM0097_SalesSiteTest4.cs:354 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea2de362 | this.Load | DM0097_SalesSiteTest4.cs:355 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e08a2448 | this.Load | DM0097_SalesSiteTest4.cs:356 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.BucketPer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f279b4ff | this.Load | DM0097_SalesSiteTest4.cs:357 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0097_SalesSiteTest4.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cc0cb3e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest4.cs:329 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fd56a21 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTest4.cs:330 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0097_SalesSiteTest4.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58dfa13b | InsertButton | DM0097_SalesSiteTest4.cs:1474 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cf0b8c5b | InsertButton | DM0097_SalesSiteTest4.cs:1476 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-db4db7d2 | InsertButton | DM0097_SalesSiteTest4.cs:1479 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6a97efe0 | InsertButton | DM0097_SalesSiteTest4.cs:1489 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.Ge… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-966f6aef | InsertButton | DM0097_SalesSiteTest4.cs:1489 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInde… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c92b67ca | InsertButton | DM0097_SalesSiteTest4.cs:1490 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-d22382bf | InsertButton | DM0097_SalesSiteTest4.cs:1492 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.G… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-27dff3a6 | InsertButton | DM0097_SalesSiteTest4.cs:1492 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInd… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0fc09dac | InsertButton | DM0097_SalesSiteTest4.cs:1494 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-294c79b0 | InsertButton | DM0097_SalesSiteTest4.cs:1495 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9c2444c9 | InsertButton | DM0097_SalesSiteTest4.cs:1498 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SiteId), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b9f3743c | InsertButton | DM0097_SalesSiteTest4.cs:1499 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7140056a | InsertButton | DM0097_SalesSiteTest4.cs:1504 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-69b46690 | InsertButton | DM0097_SalesSiteTest4.cs:1505 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CountryNa… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-cd217234 | InsertButton | DM0097_SalesSiteTest4.cs:1506 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CityName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-58cd7fb6 | InsertButton | DM0097_SalesSiteTest4.cs:1508 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-2167795b | InsertButton | DM0097_SalesSiteTest4.cs:1510 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-010aa360 | InsertButton | DM0097_SalesSiteTest4.cs:1516 | else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49b52536 | InsertButton | DM0097_SalesSiteTest4.cs:1520 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e6c0f0eb | InsertButton | DM0097_SalesSiteTest4.cs:1522 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-40c88599 | InsertButton | DM0097_SalesSiteTest4.cs:1525 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-32ca8cdd | InsertButton | DM0097_SalesSiteTest4.cs:1528 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.A… | 그리드 값 설정 |  |  |  |
| AC-b09e4048 | InsertButton | DM0097_SalesSiteTest4.cs:1529 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId), siMain.GetValue(siMain.Act… | 그리드 값 설정 |  |  |  |
| AC-7f64224a | InsertButton | DM0097_SalesSiteTest4.cs:1533 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5f9b01c | InsertButton | DM0097_SalesSiteTest4.cs:1534 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d0c7b16 | InsertButton | DM0097_SalesSiteTest4.cs:1535 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ab7d105 | InsertButton | DM0097_SalesSiteTest4.cs:1536 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-f0ff78ca | InsertButton | DM0097_SalesSiteTest4.cs:1538 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-1e29a48d | InsertButton | DM0097_SalesSiteTest4.cs:1539 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-dad20701 | InsertButton | DM0097_SalesSiteTest4.cs:1541 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.RepYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-ac43da92 | InsertButton | DM0097_SalesSiteTest4.cs:1542 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-0dd865af | InsertButton | DM0097_SalesSiteTest4.cs:1546 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ffc3603 | InsertButton | DM0097_SalesSiteTest4.cs:1547 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), siSub.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a537989 | InsertButton | DM0097_SalesSiteTest4.cs:1548 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-be68cc99 | InsertButton | DM0097_SalesSiteTest4.cs:1549 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationCode… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-72a32813 | InsertButton | DM0097_SalesSiteTest4.cs:1553 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-02ae46dd | InsertButton | DM0097_SalesSiteTest4.cs:1554 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1e61a79 | InsertButton | DM0097_SalesSiteTest4.cs:1558 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTest4.SaveData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dde1fd0b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:766 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-987ee1f5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:825 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71834750 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:827 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70fce79a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:836 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-057fe7cd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:838 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff415914 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:847 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34885073 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:849 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8027a31d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:858 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1dab069e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:860 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-641f4535 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:869 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a19061d6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:871 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b29504a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:880 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-569a8c81 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:882 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5838f85e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:891 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62bd350e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:893 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12adc792 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:902 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b36a6262 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:904 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd1702bb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:919 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-6d44e335 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:920 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-9afbbca3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:921 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-bde15abb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:922 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-755b1ae1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:923 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_description"] | sSalesSiteDesc | 행/컬럼 값 대입 |  |  |  |
| AC-60da9534 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:924 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-1c2eaa0b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:925 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sold_customer"] | sSoldToCode | 행/컬럼 값 대입 |  |  |  |
| AC-ed9f797c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:926 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_city"] | sCity | 행/컬럼 값 대입 |  |  |  |
| AC-9c070b03 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:927 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_country"] | sCountry | 행/컬럼 값 대입 |  |  |  |
| AC-491a7395 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:928 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-1559db07 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:929 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-8e1528f8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:930 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-e6d5f407 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:931 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-9cb3ce9e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:933 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3bddc3b7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:937 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ab14224 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:942 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a7e06fc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:949 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 화면 필드/플래그 변경 |  |  |  |
| AC-1a902358 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:949 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa5c1b1f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:950 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-96ae0e1c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:954 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, U… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca64bf62 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:954 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-64b1ce15 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:955 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-af1b9276 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:966 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7c248b3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTest4.cs:975 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest4.SaveSubBucketData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-349874f0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1339 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cc39181 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1394 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13e520d7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1395 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a75da80 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1400 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-91440561 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1401 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea9a508e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1406 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e3d613f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1407 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95fee57c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1420 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-4769a8da | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1421 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-39367a90 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1422 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-5529aeb6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1423 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-2af864ae | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1424 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_Incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-ba28af0a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1425 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-1b8a42c3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1426 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bucket_per"] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-dae5b030 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1427 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_conversion_type"] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-7d0bc843 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1429 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-5bd8e2da | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1431 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a046ea5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1435 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dccd6a3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1439 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-668d6e44 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1451 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17045730 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1460 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest4.SaveSubCustomerData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dad39b1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:986 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e8b940f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1014 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00120") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4659f9a8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1015 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bf50488 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1052 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b53cf62 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1054 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93118fc5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1063 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eac907f2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1065 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-23d8ed41 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1074 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d72ba3f5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1076 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af8cf2db | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1085 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a9da0d2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1087 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d6679aa | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1103 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-62778c3a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1104 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-1c926e86 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1105 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-07e3b3bd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1106 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-c6f2f18c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1107 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_code"] | sSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-07cc3c83 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1108 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_description"] | sSoldToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-9f38097e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1109 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_code"] | sShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-ff9e8cf2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1110 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_description"] | sShipToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-319aeb8c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1111 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_rep_yn"] | sRepYN | 행/컬럼 값 대입 |  |  |  |
| AC-baefe931 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1112 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-46e10ace | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1113 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-7c3105b0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1115 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-316613f6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1124 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00179", new object[] { SalesSiteId, ShipToCode }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d1113b7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1128 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ els… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d407b4a6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1133 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4998bb81 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1146 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3fa552f0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTest4.cs:1155 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest4.SaveSubLocationData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b50e57f1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1164 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-790937b6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1227 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e77cce6d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1229 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54d9ff53 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1238 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de083a61 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1240 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42428426 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1264 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-391610be | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1266 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationCode), "") | 그리드 값 설정 |  |  |  |
| AC-33ef7a3f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1267 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationDescription), "") | 그리드 값 설정 |  |  |  |
| AC-7c5a885e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1268 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.PlantId), "") | 그리드 값 설정 |  |  |  |
| AC-2ee240a3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1270 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07338d1a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1289 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0e5ef71e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1290 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-867ce565 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1291 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_seq"] | sLocationSeq | 행/컬럼 값 대입 |  |  |  |
| AC-fae23793 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1292 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-ab14d32c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1293 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_code"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-a635f695 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1294 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_description"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-5601e27d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1295 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-7e877446 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1296 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_id"] | sPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-30a98023 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1297 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_storage_id"] | sStorageId | 행/컬럼 값 대입 |  |  |  |
| AC-a144f02a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1298 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-4f42bbaf | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1299 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-7077572b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1301 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d54d2ac0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1305 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9427ab65 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1309 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de9ac23a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1322 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-260a6892 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTest4.cs:1331 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTest4.SetSubBucketData

진입점: dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73ded8f0 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2151 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f752159 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2155 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26d5fd20 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2156 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-c63db92b | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2157 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SiteId] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-d5174b07 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2158 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-bbdb8055 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2159 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-07b2f57d | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2160 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-60879868 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2161 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-087ca29a | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2163 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-df8ceb0b | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2164 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2ac33a21 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2168 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-8f13e2d8 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTest4.cs:2169 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0097_SalesSiteTest4.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ee8353f | dsdm.Changed | DM0097_SalesSiteTest4.cs:2216 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Sold… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), sScmSite) | 그리드 값 설정 |  |  |  |
| AC-38499eea | dsdm.Changed | DM0097_SalesSiteTest4.cs:2228 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a88d9543 | dsdm.Changed | DM0097_SalesSiteTest4.cs:2246 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a66bd364 | dsdm.Changed | DM0097_SalesSiteTest4.cs:2248 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-ef4f9d7d | dsdm.Changed | DM0097_SalesSiteTest4.cs:2259 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-8053bcb5 | dsdm.Changed | DM0097_SalesSiteTest4.cs:2260 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-8b737fce | dsdm.Changed | DM0097_SalesSiteTest4.cs:2267 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |
| AC-eea62d16 | dsdm.Changed | DM0097_SalesSiteTest4.cs:2268 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.shtSubBucketDataModel_Changed

진입점: dsdm3.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a182077 | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2086 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9720f976 | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2087 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b61acf4 | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2092 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a8b3deb | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2093 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-76fc5ee7 | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2098 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e0fc2d8 | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2099 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98f7cb1e | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2130 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b0d9804 | dsdm3.Changed | DM0097_SalesSiteTest4.cs:2132 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.Incoterms), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.shtSubCustomerDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82aa6a21 | dsdm2.Changed | DM0097_SalesSiteTest4.cs:2004 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | MESSAGE | MessageHelper.GMessageBox | ("MSG00149") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e76ca18 | dsdm2.Changed | DM0097_SalesSiteTest4.cs:2005 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | GRID_SET | siSub.SetValue | (e.Row, e.Column, "N") | 그리드 값 설정 |  |  |  |
| AC-e2926376 | dsdm2.Changed | DM0097_SalesSiteTest4.cs:2033 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc9fe14f | dsdm2.Changed | DM0097_SalesSiteTest4.cs:2035 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), "") | 그리드 값 설정 |  |  |  |
| AC-f65d00fc | dsdm2.Changed | DM0097_SalesSiteTest4.cs:2036 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), "") | 그리드 값 설정 |  |  |  |
| AC-33461806 | dsdm2.Changed | DM0097_SalesSiteTest4.cs:2037 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |
| AC-aa017231 | dsdm2.Changed | DM0097_SalesSiteTest4.cs:2038 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca0d852d | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1570 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-186ef4df | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1576 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c227bbf1 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1577 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e42fa01 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1584 | if (siMain.IsLock(siMain.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98b74830 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1601 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.String… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d55f15f7 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1620 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), "") | 그리드 값 설정 |  |  |  |
| AC-5a2f82a7 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1622 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | new SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-254a4bc2 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1624 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.Form_Load | (false, sDivisionId, sSoldToName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d1784271 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1625 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | UI_PROP | popSoldto.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7fd6b7f3 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1626 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ffa50d85 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1633 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), sSoldToCode.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-b7730425 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1634 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldToName), sSoldToName.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-70ba99fc | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1656 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-690900e5 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1657 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-aa0dee28 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1658 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2287e4bc | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1668 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | msScmSite | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) + "_" + sCity.Substring(0,… | 화면 필드/플래그 변경 |  |  |  |
| AC-18a6b8c4 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1671 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | mbScmSite | true | 화면 필드/플래그 변경 |  |  |  |
| AC-36d15eaa | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1674 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), sCountry) | 그리드 값 설정 |  |  |  |
| AC-ec0fc4e9 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1675 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CountryName), sCountryName) | 그리드 값 설정 |  |  |  |
| AC-02e2d193 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1676 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), sCity) | 그리드 값 설정 |  |  |  |
| AC-8130dfef | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1677 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CityName), sCityName) | 그리드 값 설정 |  |  |  |
| AC-2dbda5ae | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1696 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f6e40dfb | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1698 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6463adf0 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1699 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7157ab98 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1700 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fd53a27f | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1707 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-d9c497b2 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTest4.cs:1708 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sTeamName) | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9108bf8 | this.spdMain.ComboSelChange | DM0097_SalesSiteTest4.cs:1816 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-45b3efdd | this.spdMain.ComboSelChange | DM0097_SalesSiteTest4.cs:1816 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fadf6b22 | this.spdMain.ComboSelChange | DM0097_SalesSiteTest4.cs:1822 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0d465545 | this.spdMain.ComboSelChange | DM0097_SalesSiteTest4.cs:1824 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-a5f13039 | this.spdMain.ComboSelChange | DM0097_SalesSiteTest4.cs:1824 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-354e5697 | this.spdMain.ComboSelChange | DM0097_SalesSiteTest4.cs:1825 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27fbdf67 | this.spdMain.EditChange | DM0097_SalesSiteTest4.cs:1940 | if (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), "") | 그리드 값 설정 |  |  |  |
| AC-c7729981 | this.spdMain.EditChange | DM0097_SalesSiteTest4.cs:1944 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-e0bcd018 | this.spdMain.EditChange | DM0097_SalesSiteTest4.cs:1948 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) ▸ if … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f331a545 | this.spdMain.LeaveCell | DM0097_SalesSiteTest4.cs:1978 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9bc04d9 | (진입점 미연결) | DM0097_SalesSiteTest4.cs:2286 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTest4.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adcb6269 | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTest4.cs:1964 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-059b286a | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTest4.cs:1966 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58b102dc | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTest4.cs:1967 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTest4.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5366a779 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1869 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21b7cccf | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1883 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9598c243 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1885 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.Form_Load | (false, sDivisionId, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bd6ebc1a | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1886 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-13476c30 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1887 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b6a1694b | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1896 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-e79b6d04 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1897 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), popCustomer.SoldToDesc) | 그리드 값 설정 |  |  |  |
| AC-9f73924b | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1898 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-a76699f2 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1899 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), popCustomer.ShipToDesc) | 그리드 값 설정 |  |  |  |
| AC-63085b27 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1900 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName), popCustomer.ShiptoRegion) | 그리드 값 설정 |  |  |  |
| AC-9acaf0b6 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1901 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName), popCustomer.ShiptoCity) | 그리드 값 설정 |  |  |  |
| AC-d97753ce | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1913 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | new SCM0002_StoragebyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b484b9a3 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1915 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.Form_Load | (false, sDivisionId, sLocationCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-aaf2f9ff | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1916 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | UI_PROP | popLocation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-39efba2f | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1917 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-31df6f36 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1924 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationCode), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-94b437c2 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1925 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationDescription), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-483ae2ba | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1927 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.StorageId), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-59743fe0 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTest4.cs:1928 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PlantId), popLocation.PlantId) | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e73c624e | this.spdSub.ComboSelChange | DM0097_SalesSiteTest4.cs:1858 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-f8821fa5 | this.spdSub.ComboSelChange | DM0097_SalesSiteTest4.cs:1858 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0efa6e4c | this.spdSub.ComboSelChange | DM0097_SalesSiteTest4.cs:1861 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SiteId), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdSub_EditChange

진입점: this.spdSub.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3ea7a25 | this.spdSub.EditChange | DM0097_SalesSiteTest4.cs:1956 | if (e.Column == siSub.GetColumnIndex(DefColumns.SoldToCode)) | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTest4.spdSub_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc709d54 | (진입점 미연결) | DM0097_SalesSiteTest4.cs:2293 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTest4.xtraTabControl1_SelectedPageChanged

진입점: this.xtraTabControl1.SelectedPageChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48cf08c9 | this.xtraTabControl1.SelectedPageChanged | DM0097_SalesSiteTest4.cs:2333 |  | FOCUS | clbDivision2.Focus | () | 포커스 이동 |  |  |  |

## DM0097_SalesSiteTestBak.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cc7c697 | this.chkDetail.CheckedChanged | DM0097_SalesSiteTestBak.cs:2234 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0097_SalesSiteTestBak.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baed0f4b | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1715 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba1d7da7 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1715 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b4c7b0d | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1716 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d00bb53a | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1720 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f6abba24 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1720 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4c6a05f | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1721 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ce90e175 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1725 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-53fdf816 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1725 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1811e7f4 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1726 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b0c259bb | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1728 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f1b8875 | this.clbDivision.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1728 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0097_SalesSiteTestBak.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74f805b2 | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1750 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8443c951 | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1750 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dfd12f77 | this.clbEndCustomer.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1751 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0097_SalesSiteTestBak.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdf9429e | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1736 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9e2c6cdf | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1736 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7fa00353 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1737 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-01ee6f03 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1741 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-31cb295a | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1741 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-245cc240 | this.clbTeam.SelectedIndexChanged | DM0097_SalesSiteTestBak.cs:1742 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0097_SalesSiteTestBak.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71fc8ba7 | this.Load | DM0097_SalesSiteTestBak.cs:292 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-29e0bfa9 | this.Load | DM0097_SalesSiteTestBak.cs:293 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7e88077 | this.Load | DM0097_SalesSiteTestBak.cs:297 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubCustomer, SpdSheet.shtSubCustomer, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b1453c22 | this.Load | DM0097_SalesSiteTestBak.cs:298 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubLocation, SpdSheet.shtSubLocation, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2b04e5d2 | this.Load | DM0097_SalesSiteTestBak.cs:299 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubBucket, SpdSheet.shtSubBucket, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1fe3e2b0 | this.Load | DM0097_SalesSiteTestBak.cs:301 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubCustomer) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d98cafb | this.Load | DM0097_SalesSiteTestBak.cs:302 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubLocation) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c254649 | this.Load | DM0097_SalesSiteTestBak.cs:303 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubBucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-dcc055c3 | this.Load | DM0097_SalesSiteTestBak.cs:305 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c90faf2b | this.Load | DM0097_SalesSiteTestBak.cs:308 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82ef9b91 | this.Load | DM0097_SalesSiteTestBak.cs:311 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-635e82c5 | this.Load | DM0097_SalesSiteTestBak.cs:314 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a79e8a62 | this.Load | DM0097_SalesSiteTestBak.cs:318 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTestBak.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5b7b866 | this.Load | DM0097_SalesSiteTestBak.cs:273 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |
| AC-178c9745 | this.Load | DM0097_SalesSiteTestBak.cs:274 |  | STATE | usrConditionPanel2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-85d28bb7 | this.Load | DM0097_SalesSiteTestBak.cs:275 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-bb9ec150 | this.Load | DM0097_SalesSiteTestBak.cs:277 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-553b36e0 | this.Load | DM0097_SalesSiteTestBak.cs:279 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-99c19a12 | this.Load | DM0097_SalesSiteTestBak.cs:279 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cc665acd | this.Load | DM0097_SalesSiteTestBak.cs:282 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-5e409784 | this.Load | DM0097_SalesSiteTestBak.cs:284 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4ecb0d76 | this.Load | DM0097_SalesSiteTestBak.cs:285 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-6b21cc9b | this.Load | DM0097_SalesSiteTestBak.cs:286 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-77d52acd | this.Load | DM0097_SalesSiteTestBak.cs:287 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0097_SalesSiteTestBak.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18e4960b | DeleteButton | DM0097_SalesSiteTestBak.cs:403 | if (fps.Name == "spdMain") ▸ if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Strin… | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-11d20669 | DeleteButton | DM0097_SalesSiteTestBak.cs:410 | else of (fps.Name == "spdMain") ▸ if (siSub.GetText(siSub.ActiveRowIndex, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Str… | CALL_EXT | siSub.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0097_SalesSiteTestBak.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87f2d53a | Dispose | DM0097_SalesSiteTestBak.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0097_SalesSiteTestBak.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cba2c1da | EditButton | DM0097_SalesSiteTestBak.cs:423 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bd0a4cd | EditButton | DM0097_SalesSiteTestBak.cs:424 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96be2f6b | EditButton | DM0097_SalesSiteTestBak.cs:427 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a29be93 | EditButton | DM0097_SalesSiteTestBak.cs:428 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-814cab4f | EditButton | DM0097_SalesSiteTestBak.cs:436 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1d57247 | EditButton | DM0097_SalesSiteTestBak.cs:437 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f83ef7fa | EditButton | DM0097_SalesSiteTestBak.cs:441 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (sMyDeptID != "ADMIN") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-13532892 | EditButton | DM0097_SalesSiteTestBak.cs:447 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (sMyDeptID != "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Division), siMain.GetColumnIndex(DefColumns.CityName), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7cdb17b | EditButton | DM0097_SalesSiteTestBak.cs:450 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (sMyDeptID != "ADMIN") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.GetColumnIndex(DefColumns.UpdateUser… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8680d126 | EditButton | DM0097_SalesSiteTestBak.cs:461 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81f17216 | EditButton | DM0097_SalesSiteTestBak.cs:462 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e65e9461 | EditButton | DM0097_SalesSiteTestBak.cs:469 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (sMyDeptID != "ADMIN") ▸ if (siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnIndex(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a168628 | EditButton | DM0097_SalesSiteTestBak.cs:473 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-efb93284 | EditButton | DM0097_SalesSiteTestBak.cs:474 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-986272a1 | EditButton | DM0097_SalesSiteTestBak.cs:480 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.ShiptoCityName… | 그리드 편집 잠금/해제 |  |  |  |
| AC-85079e2f | EditButton | DM0097_SalesSiteTestBak.cs:481 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-445f99d7 | EditButton | DM0097_SalesSiteTestBak.cs:485 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.PlantId), true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1f1e73d | EditButton | DM0097_SalesSiteTestBak.cs:486 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a3ed6d7 | EditButton | DM0097_SalesSiteTestBak.cs:490 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.Division), siSub.GetColumnIndex(DefColumns.Incoterms), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6de303e0 | EditButton | DM0097_SalesSiteTestBak.cs:491 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.GetColumnIndex(DefColumns.UpdateUser),… | 그리드 편집 잠금/해제 |  |  |  |

## DM0097_SalesSiteTestBak.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-738d6ea3 | FindButton | DM0097_SalesSiteTestBak.cs:368 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTestBak.FindData_Main

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77d31930 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:533 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f86e7192 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:545 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b783757f | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:547 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7688bec6 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:555 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4164b5b | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:559 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_DATA") ⇒ DM.DM0004_GET_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-6e9f3772 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:560 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-74e1833a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:561 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-47c1ac13 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:562 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d7b88fb7 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:563 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-bd91d6ea | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:564 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-36a68e6f | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:565 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-70377e30 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:567 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-865df6d6 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:574 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e9bca30e | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:575 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0cdff4a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:584 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48704840 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0097_SalesSiteTestBak.cs:591 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTestBak.FindData_SubBucket

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f3df167 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:715 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5ff0ebe | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:722 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-73e8ab7a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:726 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_BUCKET_DATA") ⇒ DM.DM0004_GET_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-590528a7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:727 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9f1c4340 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:728 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-5373b089 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:730 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7606c102 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:732 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a698dff6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:739 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-711511ef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:740 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c753e653 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:742 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-652deece | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:749 |  | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DM0097_SalesSiteTestBak.FindData_SubCustomer

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5a54a81 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:602 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dd314886 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:606 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b127fc0e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:613 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b3627e02 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:617 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA") ⇒ DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-a4892203 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:618 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c779d5a4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:619 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-418c4e31 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:620 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-d683d3d9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:622 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0bb4ae5b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:624 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f049ca99 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:631 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0f180bb8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:632 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2318dbea | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:642 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-ab3be459 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:643 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-00f425ac | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:651 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTestBak.FindData_SubLocation

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub != null && siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5630d2e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:658 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4444349a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:662 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-414a7b43 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:669 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a1d8bb07 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:673 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_LOCATION_DATA") ⇒ DM.DM0004_GET_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-2f8e9d99 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:674 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-12ba036a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:675 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-8cb06390 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:676 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-a1217fc2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:678 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6390a81 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:680 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2530f23e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:687 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-569da462 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:688 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d80ba4b7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:698 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-15028875 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0097_SalesSiteTestBak.cs:706 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTestBak.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d3ac438 | this.Load | DM0097_SalesSiteTestBak.cs:221 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-15a66262 | this.Load | DM0097_SalesSiteTestBak.cs:222 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0097_SalesSiteTestBak.GetPlantbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed83ace0 | (진입점 미연결) | DM0097_SalesSiteTestBak.cs:2272 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4f18eb32 | (진입점 미연결) | DM0097_SalesSiteTestBak.cs:2273 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e36c2315 | (진입점 미연결) | DM0097_SalesSiteTestBak.cs:2274 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9fa13f83 | (진입점 미연결) | DM0097_SalesSiteTestBak.cs:2277 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTestBak.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-108bf88d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTestBak.cs:2260 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0004", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25632dc9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTestBak.cs:2262 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTestBak.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec831f06 | this.Load | DM0097_SalesSiteTestBak.cs:236 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-f0d14ebe | this.Load | DM0097_SalesSiteTestBak.cs:236 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e55d639 | this.Load | DM0097_SalesSiteTestBak.cs:237 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ca628977 | this.Load | DM0097_SalesSiteTestBak.cs:241 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-c84fd446 | this.Load | DM0097_SalesSiteTestBak.cs:241 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a44352e1 | this.Load | DM0097_SalesSiteTestBak.cs:242 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-eeb75b73 | this.Load | DM0097_SalesSiteTestBak.cs:246 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-66ada482 | this.Load | DM0097_SalesSiteTestBak.cs:246 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-df13e514 | this.Load | DM0097_SalesSiteTestBak.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1945f0e5 | this.Load | DM0097_SalesSiteTestBak.cs:252 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e762ca8c | this.Load | DM0097_SalesSiteTestBak.cs:252 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f56856f | this.Load | DM0097_SalesSiteTestBak.cs:254 |  | FLAG | dtDetailSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0ca213cc | this.Load | DM0097_SalesSiteTestBak.cs:254 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-27ed7194 | this.Load | DM0097_SalesSiteTestBak.cs:255 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a7b743c9 | this.Load | DM0097_SalesSiteTestBak.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-35a92b73 | this.Load | DM0097_SalesSiteTestBak.cs:259 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-7396e280 | this.Load | DM0097_SalesSiteTestBak.cs:259 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b619f6d1 | this.Load | DM0097_SalesSiteTestBak.cs:261 |  | FLAG | dtTeamAll | Data.Common(Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 화면 필드/플래그 변경 |  |  |  |
| AC-4fc7e527 | this.Load | DM0097_SalesSiteTestBak.cs:261 |  | COMBO_DATA | Data.Common | (Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0097_SalesSiteTestBak.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1862446 | this.Load | DM0097_SalesSiteTestBak.cs:345 |  | FLAG | dtSubBucket | new DataTable("SubSubBucketSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-35cc8601 | this.Load | DM0097_SalesSiteTestBak.cs:346 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8db3d4c7 | this.Load | DM0097_SalesSiteTestBak.cs:347 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.SiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa68cca6 | this.Load | DM0097_SalesSiteTestBak.cs:348 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8503e51e | this.Load | DM0097_SalesSiteTestBak.cs:349 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c04f72c | this.Load | DM0097_SalesSiteTestBak.cs:350 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.BucketPer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d11c2171 | this.Load | DM0097_SalesSiteTestBak.cs:351 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0097_SalesSiteTestBak.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3f1b4f2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTestBak.cs:323 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6e11d64 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0097_SalesSiteTestBak.cs:324 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0097_SalesSiteTestBak.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41f3c600 | InsertButton | DM0097_SalesSiteTestBak.cs:1468 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d58253d1 | InsertButton | DM0097_SalesSiteTestBak.cs:1470 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dad82804 | InsertButton | DM0097_SalesSiteTestBak.cs:1473 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-195d60fb | InsertButton | DM0097_SalesSiteTestBak.cs:1483 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.Ge… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-79f25756 | InsertButton | DM0097_SalesSiteTestBak.cs:1483 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInde… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b0cc91a | InsertButton | DM0097_SalesSiteTestBak.cs:1484 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-62455d66 | InsertButton | DM0097_SalesSiteTestBak.cs:1486 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.G… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-f887d51c | InsertButton | DM0097_SalesSiteTestBak.cs:1486 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInd… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-521f6d77 | InsertButton | DM0097_SalesSiteTestBak.cs:1488 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-799a96ed | InsertButton | DM0097_SalesSiteTestBak.cs:1489 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-295d0f0e | InsertButton | DM0097_SalesSiteTestBak.cs:1492 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SiteId), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6ccd3d19 | InsertButton | DM0097_SalesSiteTestBak.cs:1493 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-045433ea | InsertButton | DM0097_SalesSiteTestBak.cs:1498 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-7d2f64cc | InsertButton | DM0097_SalesSiteTestBak.cs:1499 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CountryNa… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-124f2c47 | InsertButton | DM0097_SalesSiteTestBak.cs:1500 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CityName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a6673815 | InsertButton | DM0097_SalesSiteTestBak.cs:1502 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-9a1351e5 | InsertButton | DM0097_SalesSiteTestBak.cs:1504 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c6b6011b | InsertButton | DM0097_SalesSiteTestBak.cs:1510 | else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16d2ae41 | InsertButton | DM0097_SalesSiteTestBak.cs:1514 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2b9070a9 | InsertButton | DM0097_SalesSiteTestBak.cs:1516 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b55a4c2a | InsertButton | DM0097_SalesSiteTestBak.cs:1519 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dd9a9a83 | InsertButton | DM0097_SalesSiteTestBak.cs:1522 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.A… | 그리드 값 설정 |  |  |  |
| AC-46bb9029 | InsertButton | DM0097_SalesSiteTestBak.cs:1523 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId), siMain.GetValue(siMain.Act… | 그리드 값 설정 |  |  |  |
| AC-2104995f | InsertButton | DM0097_SalesSiteTestBak.cs:1527 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b45cbe0 | InsertButton | DM0097_SalesSiteTestBak.cs:1528 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4ca6a9b3 | InsertButton | DM0097_SalesSiteTestBak.cs:1529 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-88e6dca6 | InsertButton | DM0097_SalesSiteTestBak.cs:1530 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-28b4486f | InsertButton | DM0097_SalesSiteTestBak.cs:1532 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2ee0b82f | InsertButton | DM0097_SalesSiteTestBak.cs:1533 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3451d18d | InsertButton | DM0097_SalesSiteTestBak.cs:1535 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.RepYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-07062f8d | InsertButton | DM0097_SalesSiteTestBak.cs:1536 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-4d9f9bf1 | InsertButton | DM0097_SalesSiteTestBak.cs:1540 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a96dbd14 | InsertButton | DM0097_SalesSiteTestBak.cs:1541 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), siSub.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c6314dcd | InsertButton | DM0097_SalesSiteTestBak.cs:1542 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-6a933c25 | InsertButton | DM0097_SalesSiteTestBak.cs:1543 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationCode… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6e70bad9 | InsertButton | DM0097_SalesSiteTestBak.cs:1547 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f1bcdc6 | InsertButton | DM0097_SalesSiteTestBak.cs:1548 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-2db58973 | InsertButton | DM0097_SalesSiteTestBak.cs:1552 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0097_SalesSiteTestBak.SaveData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22cdc61e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:760 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ff1d4f5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:819 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9649934d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:821 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81023d23 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:830 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d8615d9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:832 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4968ff6e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:841 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fa11f3e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:843 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efc30ebd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:852 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3563a1d7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:854 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43429100 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:863 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9519b96 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:865 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-feb2f784 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:874 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2fb48550 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:876 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69d4edd6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:885 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb51f0a6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:887 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4793cd80 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:896 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-803b310c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:898 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7422099 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:913 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-83586e28 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:914 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-770a7ab9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:915 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-cba09ee3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:916 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-d3679769 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:917 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_description"] | sSalesSiteDesc | 행/컬럼 값 대입 |  |  |  |
| AC-bded2456 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:918 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-92fab8a3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:919 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sold_customer"] | sSoldToCode | 행/컬럼 값 대입 |  |  |  |
| AC-9aaf0004 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:920 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_city"] | sCity | 행/컬럼 값 대입 |  |  |  |
| AC-43f27e0a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:921 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_country"] | sCountry | 행/컬럼 값 대입 |  |  |  |
| AC-ef6345a8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:922 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-8b680de0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:923 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-5af550a8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:924 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-8983ca26 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:925 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-25f4511f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:927 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-009a918a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:931 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e64a91e8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:936 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e722a8ce | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:943 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 화면 필드/플래그 변경 |  |  |  |
| AC-99f87eb1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:943 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23ec750d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:944 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7e1968ad | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:948 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, U… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-61313257 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:948 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ff2e1dc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:949 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-16016225 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:960 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-574ee1b1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0097_SalesSiteTestBak.cs:969 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTestBak.SaveSubBucketData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2dc4b0b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1333 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cb677f4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1388 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59455e44 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1389 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa111863 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1394 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f16d373b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1395 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b410ca4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1400 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1709c5a6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1401 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e67340b4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1414 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-7211ca29 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1415 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-11fad96d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1416 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-2fb2d9d3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1417 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-d1dd9bf6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1418 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_Incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-fb28f7b1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1419 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-f64b6ef9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1420 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bucket_per"] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-043c6d60 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1421 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_conversion_type"] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-80f22349 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1423 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-7b4d4755 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1425 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8a2291f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1429 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d725e55b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1433 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-407a036d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1445 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e310121f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1454 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTestBak.SaveSubCustomerData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2467b6fb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:980 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f42ee5e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1008 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00120") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17a7beba | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1009 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3cce7890 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1046 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8551ece8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1048 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d940fd65 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1057 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3eaad110 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1059 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28e13034 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1068 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17e097a8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1070 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7c3c249 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1079 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f286790 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1081 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-712ace36 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1097 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-9482c41a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1098 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-ebb5886a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1099 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-bb1bb04e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1100 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-f0eca0b1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1101 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_code"] | sSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-903672f9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1102 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_description"] | sSoldToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-fb5c472e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1103 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_code"] | sShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-a33f67b3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1104 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_description"] | sShipToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-a4ab3938 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1105 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_rep_yn"] | sRepYN | 행/컬럼 값 대입 |  |  |  |
| AC-2aa065ba | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1106 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-7012e388 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1107 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-1eef22be | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1109 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d0a26123 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1118 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00179", new object[] { SalesSiteId, ShipToCode }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6dd58280 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1122 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ els… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-703b707d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1127 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7e182c5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1140 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c219d1c4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0097_SalesSiteTestBak.cs:1149 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTestBak.SaveSubLocationData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-267f1ee4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1158 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a8b526f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1221 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06aab964 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1223 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3af297e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1232 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17a2e65d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1234 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-458ad9bb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1258 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-668a6ba5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1260 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationCode), "") | 그리드 값 설정 |  |  |  |
| AC-c3bd858b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1261 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationDescription), "") | 그리드 값 설정 |  |  |  |
| AC-8408f7f7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1262 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.PlantId), "") | 그리드 값 설정 |  |  |  |
| AC-af02f558 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1264 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd995861 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1283 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0d2308a9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1284 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-c3227f51 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1285 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_seq"] | sLocationSeq | 행/컬럼 값 대입 |  |  |  |
| AC-933a72c8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1286 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-16ec7f77 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1287 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_code"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-84ab0299 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1288 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_description"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-020ac2f4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1289 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-6a231d74 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1290 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_id"] | sPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-8ad2eff4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1291 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_storage_id"] | sStorageId | 행/컬럼 값 대입 |  |  |  |
| AC-7c0882ec | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1292 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-8a64db2a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1293 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-e6dfe193 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1295 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2a90839 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1299 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-56bea69c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1303 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da8b6e45 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1316 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4505d7f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0097_SalesSiteTestBak.cs:1325 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0097_SalesSiteTestBak.SetSubBucketData

진입점: dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb164074 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2105 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e6d69d8 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2109 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8f507ce2 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2110 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-8e9c7098 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2111 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SiteId] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-c2cc4880 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2112 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-6f47ecf3 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2113 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-db801d29 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2114 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-a1bc8dfb | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2115 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-60b7df14 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2117 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-99d3dbb1 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2118 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d4ec99c2 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2122 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-e35617cf | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0097_SalesSiteTestBak.cs:2123 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0097_SalesSiteTestBak.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-234200f4 | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2170 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Sold… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), sScmSite) | 그리드 값 설정 |  |  |  |
| AC-bfd6c961 | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2182 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b795f7c7 | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2200 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bea1fbf | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2202 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-27cf6dc0 | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2213 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-60c27811 | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2214 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-7c7073a9 | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2221 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |
| AC-755bb9c6 | dsdm.Changed | DM0097_SalesSiteTestBak.cs:2222 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTestBak.shtSubBucketDataModel_Changed

진입점: dsdm3.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21920576 | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2040 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6635ab33 | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2041 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db5a6e4d | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2046 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2563761 | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2047 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c61d869 | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2052 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b39834ee | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2053 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a527fcfd | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2084 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d116d05 | dsdm3.Changed | DM0097_SalesSiteTestBak.cs:2086 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.Incoterms), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTestBak.shtSubCustomerDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afa8c625 | dsdm2.Changed | DM0097_SalesSiteTestBak.cs:1958 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | MESSAGE | MessageHelper.GMessageBox | ("MSG00149") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22023077 | dsdm2.Changed | DM0097_SalesSiteTestBak.cs:1959 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | GRID_SET | siSub.SetValue | (e.Row, e.Column, "N") | 그리드 값 설정 |  |  |  |
| AC-6a442446 | dsdm2.Changed | DM0097_SalesSiteTestBak.cs:1987 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19f5b7b8 | dsdm2.Changed | DM0097_SalesSiteTestBak.cs:1989 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), "") | 그리드 값 설정 |  |  |  |
| AC-8aacb790 | dsdm2.Changed | DM0097_SalesSiteTestBak.cs:1990 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), "") | 그리드 값 설정 |  |  |  |
| AC-78c2bfcf | dsdm2.Changed | DM0097_SalesSiteTestBak.cs:1991 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |
| AC-2b24d6d2 | dsdm2.Changed | DM0097_SalesSiteTestBak.cs:1992 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-067140b7 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1564 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-630e4230 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1570 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14a65529 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1571 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61fd233d | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1578 | if (siMain.IsLock(siMain.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fa438c5 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1595 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.String… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11e80abe | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1614 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), "") | 그리드 값 설정 |  |  |  |
| AC-571203ea | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1616 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | new SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-84de3385 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1618 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.Form_Load | (false, sDivisionId, sSoldToName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-be260a25 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1619 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | UI_PROP | popSoldto.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-15394279 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1620 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-10edb712 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1627 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), sSoldToCode.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-4f24ce30 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1628 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldToName), sSoldToName.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-96d9ff8f | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1650 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c192387d | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1651 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b2905f47 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1652 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d18ab5ae | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1662 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | msScmSite | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) + "_" + sCity.Substring(0,… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b56bd2f | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1665 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | mbScmSite | true | 화면 필드/플래그 변경 |  |  |  |
| AC-87cc169b | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1668 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), sCountry) | 그리드 값 설정 |  |  |  |
| AC-710c75a0 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1669 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CountryName), sCountryName) | 그리드 값 설정 |  |  |  |
| AC-998a342d | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1670 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), sCity) | 그리드 값 설정 |  |  |  |
| AC-f0f05657 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1671 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CityName), sCityName) | 그리드 값 설정 |  |  |  |
| AC-edd930fd | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1690 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-64f5eebd | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1692 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9c9c5044 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1693 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-863f7074 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1694 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9fb501b3 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1701 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-da99a732 | this.spdMain.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1702 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sTeamName) | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee0674c8 | this.spdMain.ComboSelChange | DM0097_SalesSiteTestBak.cs:1770 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-f32f0646 | this.spdMain.ComboSelChange | DM0097_SalesSiteTestBak.cs:1770 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7fdc9ef | this.spdMain.ComboSelChange | DM0097_SalesSiteTestBak.cs:1776 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d8e2804a | this.spdMain.ComboSelChange | DM0097_SalesSiteTestBak.cs:1778 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-22176df1 | this.spdMain.ComboSelChange | DM0097_SalesSiteTestBak.cs:1778 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ebfee15 | this.spdMain.ComboSelChange | DM0097_SalesSiteTestBak.cs:1779 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3297600 | this.spdMain.EditChange | DM0097_SalesSiteTestBak.cs:1894 | if (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), "") | 그리드 값 설정 |  |  |  |
| AC-0681bbb2 | this.spdMain.EditChange | DM0097_SalesSiteTestBak.cs:1898 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-c537cb6e | this.spdMain.EditChange | DM0097_SalesSiteTestBak.cs:1902 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) ▸ if … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e56100b6 | this.spdMain.LeaveCell | DM0097_SalesSiteTestBak.cs:1932 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-778adc85 | this.spdMain.TopChange | DM0097_SalesSiteTestBak.cs:2240 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0097_SalesSiteTestBak.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f73131b1 | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTestBak.cs:1918 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-f14c0ee2 | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTestBak.cs:1920 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9abfd187 | this.spdSub.ActiveSheetChanging | DM0097_SalesSiteTestBak.cs:1921 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0097_SalesSiteTestBak.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a13b8c1f | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1823 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7038fe8e | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1837 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-67630486 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1839 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.Form_Load | (false, sDivisionId, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0bcf8840 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1840 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f39a1299 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1841 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-08603cae | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1850 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-33acf438 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1851 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), popCustomer.SoldToDesc) | 그리드 값 설정 |  |  |  |
| AC-53e45393 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1852 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-319ee7e7 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1853 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), popCustomer.ShipToDesc) | 그리드 값 설정 |  |  |  |
| AC-391972b7 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1854 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName), popCustomer.ShiptoRegion) | 그리드 값 설정 |  |  |  |
| AC-ea3ef237 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1855 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName), popCustomer.ShiptoCity) | 그리드 값 설정 |  |  |  |
| AC-33c16749 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1867 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | new SCM0002_StoragebyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a7c6899a | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1869 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.Form_Load | (false, sDivisionId, sLocationCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-27680cdd | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1870 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | UI_PROP | popLocation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bd6bc86f | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1871 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6e2a313e | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1878 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationCode), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-ebc58adf | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1879 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationDescription), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-99c9db6c | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1881 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.StorageId), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-da03c173 | this.spdSub.CellDoubleClick | DM0097_SalesSiteTestBak.cs:1882 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PlantId), popLocation.PlantId) | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e20fcaf | this.spdSub.ComboSelChange | DM0097_SalesSiteTestBak.cs:1812 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-4ed7d469 | this.spdSub.ComboSelChange | DM0097_SalesSiteTestBak.cs:1812 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45540286 | this.spdSub.ComboSelChange | DM0097_SalesSiteTestBak.cs:1815 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SiteId), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdSub_EditChange

진입점: this.spdSub.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdd75887 | this.spdSub.EditChange | DM0097_SalesSiteTestBak.cs:1910 | if (e.Column == siSub.GetColumnIndex(DefColumns.SoldToCode)) | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |

## DM0097_SalesSiteTestBak.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24447d44 | this.spdSub.TopChange | DM0097_SalesSiteTestBak.cs:2247 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

