# AS-IS 액션 대조표 — DM0004

> 원천: `Doc/asisfacts/screens/DM0004/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 889행 · 메서드 80 · 종류 DATA_OP 165 · GRID_SET 119 · MESSAGE 96 · RETURN 82 · FLAG 75 · GRID_LOCK 60 · COMBO_DATA 55 · ENDPOINT 44 · UI_PROP 38 · GRID_INIT 38 · LIST_REBIND 32 · POPUP 28 · UI_MISC 24 · GRID_COMBO 13 · GRID_BIND 8 · CALL_EXT 5 · VALUE_SET 3 · STATE 2 · STATE_RESET 2 · ⚠ 의미 확인 필요 5


## DM0004_SalesSite.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb9ecc11 | this.chkDetail.CheckedChanged | DM0004_SalesSite.cs:2275 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0004_SalesSite.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f64d043 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1756 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-291491d7 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1756 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b64453d | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1757 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b5631cac | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1761 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1fd8e263 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1761 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9c2ba66c | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1762 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-66f75329 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1766 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-cdeb54c5 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1766 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5db12c0 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1767 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2cf42b94 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1769 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-40d0c249 | this.clbDivision.SelectedIndexChanged | DM0004_SalesSite.cs:1769 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0004_SalesSite.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-229c275a | this.clbEndCustomer.SelectedIndexChanged | DM0004_SalesSite.cs:1791 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c219e53b | this.clbEndCustomer.SelectedIndexChanged | DM0004_SalesSite.cs:1791 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f8806a87 | this.clbEndCustomer.SelectedIndexChanged | DM0004_SalesSite.cs:1792 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0004_SalesSite.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1ae10db | this.clbTeam.SelectedIndexChanged | DM0004_SalesSite.cs:1777 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b1c17ff | this.clbTeam.SelectedIndexChanged | DM0004_SalesSite.cs:1777 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-203188fc | this.clbTeam.SelectedIndexChanged | DM0004_SalesSite.cs:1778 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1d307027 | this.clbTeam.SelectedIndexChanged | DM0004_SalesSite.cs:1782 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-39f7bc4e | this.clbTeam.SelectedIndexChanged | DM0004_SalesSite.cs:1782 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f828aa0 | this.clbTeam.SelectedIndexChanged | DM0004_SalesSite.cs:1783 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0004_SalesSite.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a109cfda | this.Load | DM0004_SalesSite.cs:296 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c4d68667 | this.Load | DM0004_SalesSite.cs:297 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eabbf1a9 | this.Load | DM0004_SalesSite.cs:301 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubCustomer, SpdSheet.shtSubCustomer, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f69c4c3b | this.Load | DM0004_SalesSite.cs:302 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubLocation, SpdSheet.shtSubLocation, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9669fb12 | this.Load | DM0004_SalesSite.cs:303 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubBucket, SpdSheet.shtSubBucket, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-527c024a | this.Load | DM0004_SalesSite.cs:305 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubCustomer) | 화면 필드/플래그 변경 |  |  |  |
| AC-52d5b489 | this.Load | DM0004_SalesSite.cs:306 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubLocation) | 화면 필드/플래그 변경 |  |  |  |
| AC-43648af0 | this.Load | DM0004_SalesSite.cs:307 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubBucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce02b91d | this.Load | DM0004_SalesSite.cs:309 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78014fe3 | this.Load | DM0004_SalesSite.cs:312 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79a60e86 | this.Load | DM0004_SalesSite.cs:315 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d7d67a1 | this.Load | DM0004_SalesSite.cs:318 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b7087f2 | this.Load | DM0004_SalesSite.cs:322 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0004_SalesSite.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9747b100 | this.Load | DM0004_SalesSite.cs:277 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |
| AC-b573cca3 | this.Load | DM0004_SalesSite.cs:278 |  | STATE | usrConditionPanel2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-7a16e15c | this.Load | DM0004_SalesSite.cs:279 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-076d6d5b | this.Load | DM0004_SalesSite.cs:281 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-137a08de | this.Load | DM0004_SalesSite.cs:283 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-c664e492 | this.Load | DM0004_SalesSite.cs:283 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bbf014f | this.Load | DM0004_SalesSite.cs:286 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-b0862385 | this.Load | DM0004_SalesSite.cs:288 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a4d5dfc3 | this.Load | DM0004_SalesSite.cs:289 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-b02864c0 | this.Load | DM0004_SalesSite.cs:290 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-06794062 | this.Load | DM0004_SalesSite.cs:291 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0004_SalesSite.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99d7275f | DeleteButton | DM0004_SalesSite.cs:407 | if (fps.Name == "spdMain") ▸ if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Strin… | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-09056828 | DeleteButton | DM0004_SalesSite.cs:414 | else of (fps.Name == "spdMain") ▸ if (siSub.GetText(siSub.ActiveRowIndex, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Str… | CALL_EXT | siSub.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0004_SalesSite.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f196802 | Dispose | DM0004_SalesSite.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0004_SalesSite.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2314d785 | EditButton | DM0004_SalesSite.cs:427 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-16da54d0 | EditButton | DM0004_SalesSite.cs:428 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59d6d9ba | EditButton | DM0004_SalesSite.cs:431 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-49244cef | EditButton | DM0004_SalesSite.cs:432 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-622dbc15 | EditButton | DM0004_SalesSite.cs:438 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c776cb7f | EditButton | DM0004_SalesSite.cs:439 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-41fc2fc0 | EditButton | DM0004_SalesSite.cs:443 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f4d449e | EditButton | DM0004_SalesSite.cs:452 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55b63e8e | EditButton | DM0004_SalesSite.cs:453 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd8c9f7e | EditButton | DM0004_SalesSite.cs:464 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-dac4ec99 | EditButton | DM0004_SalesSite.cs:465 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-edcf4035 | EditButton | DM0004_SalesSite.cs:475 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Sh… | 그리드 편집 잠금/해제 |  |  |  |
| AC-be87df15 | EditButton | DM0004_SalesSite.cs:476 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-05bf1484 | EditButton | DM0004_SalesSite.cs:480 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0e6b4cd6 | EditButton | DM0004_SalesSite.cs:490 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Pl… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3e0c1a4 | EditButton | DM0004_SalesSite.cs:491 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0648d5c9 | EditButton | DM0004_SalesSite.cs:495 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ea7e9c6 | EditButton | DM0004_SalesSite.cs:507 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.In… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c344f1d7 | EditButton | DM0004_SalesSite.cs:508 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a8586eb | EditButton | DM0004_SalesSite.cs:512 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |

## DM0004_SalesSite.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-840dac83 | FindButton | DM0004_SalesSite.cs:372 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSite.FindData_Main

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3051de16 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:558 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-823d9835 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:570 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b03e5ce | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:572 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12111263 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:580 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-28238c28 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:584 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_DATA") ⇒ DM.DM0004_GET_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0060236a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:586 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-e27dbed0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:587 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-749c8008 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:588 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-255e336b | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:589 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9a8cacd9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:590 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-e144d6be | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:591 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-686ba75f | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:592 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5c1cf858 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:594 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4fa20eaa | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:596 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f6e601d2 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:603 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-25dbb4b9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:604 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e39e081c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:613 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-130a8bd0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSite.cs:620 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSite.FindData_SubBucket

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f919e846 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:750 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9bdc2552 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:757 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-359e8432 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:761 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_BUCKET_DATA") ⇒ DM.DM0004_GET_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-68dd23ba | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:763 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-245493f5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:764 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-2c2adbef | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:765 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b89ad1e2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:766 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b75729bb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:768 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b7f501d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:770 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0fdb04c7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:777 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6c3f6a54 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:778 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e79b8675 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:780 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5347d5a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:787 |  | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DM0004_SalesSite.FindData_SubCustomer

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d1a3cb7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:631 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a65ed858 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:635 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6cfa4ba5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:642 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88ad06a5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:646 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA") ⇒ DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-55ae3a84 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:648 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-11e48037 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:649 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-7f6a4bc7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:650 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-32c145ff | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:651 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1355afb7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:652 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1e45dd2c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:654 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2b08af64 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:656 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ccde1e5f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:663 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-17c27427 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:664 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5acd9f9a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:674 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-84a5441b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:675 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-023bbb54 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:683 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSite.FindData_SubLocation

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub != null && siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-817e2ece | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:690 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-12ed543a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:694 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c80e193 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:701 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c260754f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:705 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_LOCATION_DATA") ⇒ DM.DM0004_GET_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-7df3afac | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:707 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dcf8f598 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:708 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-ee5b739a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:709 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-c5d416ff | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:710 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-de160496 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:711 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61c0aa84 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:713 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8419b904 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:715 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c356e28d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:722 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5edf677d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:723 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14cd6d39 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:733 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-37ed5da5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSite.cs:741 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSite.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8912600 | this.Load | DM0004_SalesSite.cs:225 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-bca58367 | this.Load | DM0004_SalesSite.cs:226 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0004_SalesSite.GetPlantbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bd32ac3 | (진입점 미연결) | DM0004_SalesSite.cs:2313 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-ee957751 | (진입점 미연결) | DM0004_SalesSite.cs:2314 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-30d252ff | (진입점 미연결) | DM0004_SalesSite.cs:2315 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-450ad7b8 | (진입점 미연결) | DM0004_SalesSite.cs:2318 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSite.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4b21103 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSite.cs:2301 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0004", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a3d3e59f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSite.cs:2303 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSite.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b6e0e8a | this.Load | DM0004_SalesSite.cs:240 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-c22127a6 | this.Load | DM0004_SalesSite.cs:240 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-21a3e91c | this.Load | DM0004_SalesSite.cs:241 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-136d07c4 | this.Load | DM0004_SalesSite.cs:245 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-d4303485 | this.Load | DM0004_SalesSite.cs:245 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b47fa80 | this.Load | DM0004_SalesSite.cs:246 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a2da1ff9 | this.Load | DM0004_SalesSite.cs:250 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-df55b224 | this.Load | DM0004_SalesSite.cs:250 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-41ad652e | this.Load | DM0004_SalesSite.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4dc622f3 | this.Load | DM0004_SalesSite.cs:256 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c527dc46 | this.Load | DM0004_SalesSite.cs:256 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c5c89c80 | this.Load | DM0004_SalesSite.cs:258 |  | FLAG | dtDetailSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3ef50fb8 | this.Load | DM0004_SalesSite.cs:258 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93bbdef5 | this.Load | DM0004_SalesSite.cs:259 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f4453450 | this.Load | DM0004_SalesSite.cs:261 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8f01f2ba | this.Load | DM0004_SalesSite.cs:263 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-103ac2e2 | this.Load | DM0004_SalesSite.cs:263 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, clbDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e14aa25 | this.Load | DM0004_SalesSite.cs:265 |  | FLAG | dtTeamAll | Data.Common(Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 화면 필드/플래그 변경 |  |  |  |
| AC-7eb9d413 | this.Load | DM0004_SalesSite.cs:265 |  | COMBO_DATA | Data.Common | (Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0004_SalesSite.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07fa6a74 | this.Load | DM0004_SalesSite.cs:349 |  | FLAG | dtSubBucket | new DataTable("SubSubBucketSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-b04e869e | this.Load | DM0004_SalesSite.cs:350 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ac0ab86 | this.Load | DM0004_SalesSite.cs:351 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.SiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-75bc9c91 | this.Load | DM0004_SalesSite.cs:352 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-689900dc | this.Load | DM0004_SalesSite.cs:353 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5c648a3 | this.Load | DM0004_SalesSite.cs:354 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.BucketPer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfb40a54 | this.Load | DM0004_SalesSite.cs:355 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0004_SalesSite.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b77e4fb6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSite.cs:327 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2f811aa | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSite.cs:328 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0004_SalesSite.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e46c756 | InsertButton | DM0004_SalesSite.cs:1509 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c849d7d9 | InsertButton | DM0004_SalesSite.cs:1511 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f8ff452 | InsertButton | DM0004_SalesSite.cs:1514 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4723ae0a | InsertButton | DM0004_SalesSite.cs:1524 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.Ge… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-073c84d6 | InsertButton | DM0004_SalesSite.cs:1524 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInde… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecd739fe | InsertButton | DM0004_SalesSite.cs:1525 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9ac8c7f7 | InsertButton | DM0004_SalesSite.cs:1527 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.G… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-89c84ba7 | InsertButton | DM0004_SalesSite.cs:1527 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInd… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b6b0634 | InsertButton | DM0004_SalesSite.cs:1529 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a2a85372 | InsertButton | DM0004_SalesSite.cs:1530 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1b19dd58 | InsertButton | DM0004_SalesSite.cs:1533 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SiteId), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-95119cdf | InsertButton | DM0004_SalesSite.cs:1534 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a5d15b5 | InsertButton | DM0004_SalesSite.cs:1539 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-dcaccff0 | InsertButton | DM0004_SalesSite.cs:1540 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CountryNa… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4f198885 | InsertButton | DM0004_SalesSite.cs:1541 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CityName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-9667dd25 | InsertButton | DM0004_SalesSite.cs:1543 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-38eaf0ee | InsertButton | DM0004_SalesSite.cs:1545 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55a4fe81 | InsertButton | DM0004_SalesSite.cs:1551 | else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-942eda03 | InsertButton | DM0004_SalesSite.cs:1555 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-43cea83a | InsertButton | DM0004_SalesSite.cs:1557 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-360af0d6 | InsertButton | DM0004_SalesSite.cs:1560 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-61ecadd1 | InsertButton | DM0004_SalesSite.cs:1563 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.A… | 그리드 값 설정 |  |  |  |
| AC-cc28018a | InsertButton | DM0004_SalesSite.cs:1564 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId), siMain.GetValue(siMain.Act… | 그리드 값 설정 |  |  |  |
| AC-99f97c28 | InsertButton | DM0004_SalesSite.cs:1568 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01e7c86a | InsertButton | DM0004_SalesSite.cs:1569 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec2fa65c | InsertButton | DM0004_SalesSite.cs:1570 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b7ce518 | InsertButton | DM0004_SalesSite.cs:1571 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-e1d38c89 | InsertButton | DM0004_SalesSite.cs:1573 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4f9ff9ec | InsertButton | DM0004_SalesSite.cs:1574 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-dc5480cb | InsertButton | DM0004_SalesSite.cs:1576 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.RepYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-83cb6c4a | InsertButton | DM0004_SalesSite.cs:1577 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-b040dde4 | InsertButton | DM0004_SalesSite.cs:1581 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-134264fe | InsertButton | DM0004_SalesSite.cs:1582 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), siSub.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53322120 | InsertButton | DM0004_SalesSite.cs:1583 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-e6d52ab4 | InsertButton | DM0004_SalesSite.cs:1584 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationCode… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-a747baf1 | InsertButton | DM0004_SalesSite.cs:1588 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2c5dfd8c | InsertButton | DM0004_SalesSite.cs:1589 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-7645c179 | InsertButton | DM0004_SalesSite.cs:1593 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSite.SaveData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2b63cdd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:798 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee9b528f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:860 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c27b8a7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:862 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4cf84bd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:871 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac197cde | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:873 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17ff80ef | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:882 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4a27948 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:884 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13929923 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:893 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b160d57 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:895 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86f97617 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:904 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb625bd2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:906 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3608b09d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:915 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6170927f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:917 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-589ae84b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:926 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08eb0866 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:928 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-50e26267 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:937 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e1e9604 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:939 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-609a814a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:954 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-62b8e29c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:955 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-2dddd543 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:956 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-430822ad | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:957 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-1ea424ff | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:958 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_description"] | sSalesSiteDesc | 행/컬럼 값 대입 |  |  |  |
| AC-4b62df5d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:959 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-4a96d60c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:960 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sold_customer"] | sSoldToCode | 행/컬럼 값 대입 |  |  |  |
| AC-97a84283 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:961 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_city"] | sCity | 행/컬럼 값 대입 |  |  |  |
| AC-cc7523a9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:962 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_country"] | sCountry | 행/컬럼 값 대입 |  |  |  |
| AC-09ba5a9e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:963 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-f181a680 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:964 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | sVmiYN | 행/컬럼 값 대입 |  |  |  |
| AC-06be6836 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:965 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-6c6dd4eb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:966 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-e8a242d0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:968 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac061f76 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:972 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-22b422d2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:977 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-471b0471 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:984 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 화면 필드/플래그 변경 |  |  |  |
| AC-ba5061ae | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:984 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45326ad7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:985 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-adedad58 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:989 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, U… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-ec8bbe42 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:989 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea7add24 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:990 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-737ce913 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:1001 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-572cd87a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSite.cs:1010 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSite.SaveSubBucketData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-796f894d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1374 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fe6d4cc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1429 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e33754f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1430 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61eff55e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1435 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5919c83b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1436 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d95b33a0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1441 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8fef0f1c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1442 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7252d3d5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1455 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-7787b9d0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1456 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-70ee044e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1457 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-5c11862e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1458 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-bcd47af7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1459 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_Incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-9440a97d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1460 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-bb0e7470 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1461 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bucket_per"] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-3bea9cdb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1462 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_conversion_type"] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-0012aece | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1464 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-b1992af0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1466 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bdf34c7c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1470 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-85ad7d73 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1474 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fc084b9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1486 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b166da91 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1495 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSite.SaveSubCustomerData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7f31033 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1021 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8039ff88 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1049 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00120") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b5469c1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1050 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c07181ef | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1087 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8870d970 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1089 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-475c866e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1098 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d6313de | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1100 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84678d7f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1109 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78fc37a7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1111 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37a96fc8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1120 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6d9488d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1122 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-489866a4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1138 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-aefce3c1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1139 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-53b196f9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1140 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-05e92e1d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1141 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-06b0cbfe | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1142 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_code"] | sSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-3f69fd08 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1143 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_description"] | sSoldToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-aa5ddfb4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1144 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_code"] | sShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-75962394 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1145 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_description"] | sShipToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-f86c0505 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1146 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_rep_yn"] | sRepYN | 행/컬럼 값 대입 |  |  |  |
| AC-1d2af654 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1147 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-8f233b9e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1148 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-827fb20c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1150 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dcefc958 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1159 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00179", new object[] { SalesSiteId, ShipToCode }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-995b91a0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1163 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ els… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7920f86c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1168 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a0a7b7e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1181 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-983f83f6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSite.cs:1190 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSite.SaveSubLocationData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04d45e92 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1199 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-accd0dcc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1262 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-307ffa2d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1264 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81545de9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1273 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-091e0c9f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1275 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5341c3a6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1299 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c6c1c38 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1301 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationCode), "") | 그리드 값 설정 |  |  |  |
| AC-6433f2d2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1302 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationDescription), "") | 그리드 값 설정 |  |  |  |
| AC-9dea6aac | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1303 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.PlantId), "") | 그리드 값 설정 |  |  |  |
| AC-c4bb797e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1305 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f551998 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1324 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-8152f99d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1325 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-5e846815 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1326 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_seq"] | sLocationSeq | 행/컬럼 값 대입 |  |  |  |
| AC-48f85834 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1327 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-333d9d3b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1328 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_code"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-54427d86 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1329 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_description"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-39b9d3a5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1330 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-1bae344b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1331 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_id"] | sPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-f5a97208 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1332 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_storage_id"] | sStorageId | 행/컬럼 값 대입 |  |  |  |
| AC-648db0f0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1333 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-11b9e3cc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1334 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-619763c5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1336 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-806cc9d0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1340 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e43a9823 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1344 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e6da9d71 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1357 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4eeb5eff | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSite.cs:1366 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSite.SetSubBucketData

진입점: dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e575688d | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2146 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-82381f21 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2150 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b0ca9182 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2151 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-3f8ad5fb | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2152 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SiteId] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-b5780ac9 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2153 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-bf7077cd | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2154 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-9233d8c3 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2155 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-b9aecb3b | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2156 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-a3a6529d | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2158 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-b81f4916 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2159 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ebcc8d9d | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2163 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-2ad8114f | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSite.cs:2164 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0004_SalesSite.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-672a8210 | dsdm.Changed | DM0004_SalesSite.cs:2211 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Sold… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), sScmSite) | 그리드 값 설정 |  |  |  |
| AC-49d33b0b | dsdm.Changed | DM0004_SalesSite.cs:2223 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-359e8725 | dsdm.Changed | DM0004_SalesSite.cs:2241 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d6cabbb | dsdm.Changed | DM0004_SalesSite.cs:2243 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-4258d5b0 | dsdm.Changed | DM0004_SalesSite.cs:2254 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-f7d380d7 | dsdm.Changed | DM0004_SalesSite.cs:2255 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-fd3b4a27 | dsdm.Changed | DM0004_SalesSite.cs:2262 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |
| AC-01a38059 | dsdm.Changed | DM0004_SalesSite.cs:2263 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSite.shtSubBucketDataModel_Changed

진입점: dsdm3.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68eb05a6 | dsdm3.Changed | DM0004_SalesSite.cs:2081 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6eacaff4 | dsdm3.Changed | DM0004_SalesSite.cs:2082 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78db4d6d | dsdm3.Changed | DM0004_SalesSite.cs:2087 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8fbd7cf2 | dsdm3.Changed | DM0004_SalesSite.cs:2088 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73f2f622 | dsdm3.Changed | DM0004_SalesSite.cs:2093 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-186c3aad | dsdm3.Changed | DM0004_SalesSite.cs:2094 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afcfbf33 | dsdm3.Changed | DM0004_SalesSite.cs:2125 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33739883 | dsdm3.Changed | DM0004_SalesSite.cs:2127 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.Incoterms), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSite.shtSubCustomerDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cb719ec | dsdm2.Changed | DM0004_SalesSite.cs:1999 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | MESSAGE | MessageHelper.GMessageBox | ("MSG00149") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12a4de47 | dsdm2.Changed | DM0004_SalesSite.cs:2000 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | GRID_SET | siSub.SetValue | (e.Row, e.Column, "N") | 그리드 값 설정 |  |  |  |
| AC-ab8d5202 | dsdm2.Changed | DM0004_SalesSite.cs:2028 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf65804e | dsdm2.Changed | DM0004_SalesSite.cs:2030 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), "") | 그리드 값 설정 |  |  |  |
| AC-63e7fac1 | dsdm2.Changed | DM0004_SalesSite.cs:2031 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), "") | 그리드 값 설정 |  |  |  |
| AC-09e564ec | dsdm2.Changed | DM0004_SalesSite.cs:2032 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |
| AC-60a67aab | dsdm2.Changed | DM0004_SalesSite.cs:2033 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSite.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a315511 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1605 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac33adc1 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1611 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdb8040a | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1612 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2f58542 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1619 | if (siMain.IsLock(siMain.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c2c5cff | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1636 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.String… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-497a36f8 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1655 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), "") | 그리드 값 설정 |  |  |  |
| AC-3e801df4 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1657 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | new SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-91347bbe | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1659 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.Form_Load | (false, sDivisionId, sSoldToName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0bb40972 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1660 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | UI_PROP | popSoldto.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f7b22d42 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1661 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-14850665 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1668 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), sSoldToCode.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-0922a1fe | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1669 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldToName), sSoldToName.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-e8e583a6 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1691 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-62534ac9 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1692 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0373b598 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1693 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3c2e6384 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1703 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | msScmSite | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) + "_" + sCity.Substring(0,… | 화면 필드/플래그 변경 |  |  |  |
| AC-06e67aea | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1706 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | mbScmSite | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5be8afe6 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1709 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), sCountry) | 그리드 값 설정 |  |  |  |
| AC-6bc17cf1 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1710 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CountryName), sCountryName) | 그리드 값 설정 |  |  |  |
| AC-31366b39 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1711 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), sCity) | 그리드 값 설정 |  |  |  |
| AC-9553315b | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1712 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CityName), sCityName) | 그리드 값 설정 |  |  |  |
| AC-5fb5e665 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1731 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e2ac98fb | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1733 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7bcbc9a3 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1734 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-55c21957 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1735 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3078b1e6 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1742 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-75826839 | this.spdMain.CellDoubleClick | DM0004_SalesSite.cs:1743 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sTeamName) | 그리드 값 설정 |  |  |  |

## DM0004_SalesSite.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10586502 | this.spdMain.ComboSelChange | DM0004_SalesSite.cs:1811 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-9d1757c6 | this.spdMain.ComboSelChange | DM0004_SalesSite.cs:1811 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8221dcb7 | this.spdMain.ComboSelChange | DM0004_SalesSite.cs:1817 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f38812cb | this.spdMain.ComboSelChange | DM0004_SalesSite.cs:1819 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-ae14df78 | this.spdMain.ComboSelChange | DM0004_SalesSite.cs:1819 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-217d83a0 | this.spdMain.ComboSelChange | DM0004_SalesSite.cs:1820 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0004_SalesSite.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cb7f1b3 | this.spdMain.EditChange | DM0004_SalesSite.cs:1935 | if (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), "") | 그리드 값 설정 |  |  |  |
| AC-a2bf9d5c | this.spdMain.EditChange | DM0004_SalesSite.cs:1939 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-a4a63dd7 | this.spdMain.EditChange | DM0004_SalesSite.cs:1943 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) ▸ if … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSite.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b773f9d | this.spdMain.LeaveCell | DM0004_SalesSite.cs:1973 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0004_SalesSite.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7595d292 | this.spdMain.TopChange | DM0004_SalesSite.cs:2281 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0004_SalesSite.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd20d0d2 | this.spdSub.ActiveSheetChanging | DM0004_SalesSite.cs:1959 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-7ec1eed0 | this.spdSub.ActiveSheetChanging | DM0004_SalesSite.cs:1961 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11236d87 | this.spdSub.ActiveSheetChanging | DM0004_SalesSite.cs:1962 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSite.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3cfa2ce | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1864 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ef5aa56 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1878 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f5682961 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1880 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.Form_Load | (false, sDivisionId, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e6b49b08 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1881 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d1d45fa1 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1882 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b8226e35 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1891 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-b7e05d90 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1892 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), popCustomer.SoldToDesc) | 그리드 값 설정 |  |  |  |
| AC-0e7dfa84 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1893 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-95542546 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1894 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), popCustomer.ShipToDesc) | 그리드 값 설정 |  |  |  |
| AC-75418b65 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1895 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName), popCustomer.ShiptoRegion) | 그리드 값 설정 |  |  |  |
| AC-48d48607 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1896 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName), popCustomer.ShiptoCity) | 그리드 값 설정 |  |  |  |
| AC-f3b04820 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1908 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | new SCM0002_StoragebyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e588a547 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1910 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.Form_Load | (false, sDivisionId, sLocationCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e4ee4abe | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1911 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | UI_PROP | popLocation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cbbb8a22 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1912 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-500a7062 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1919 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationCode), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-7233dfb1 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1920 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationDescription), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-3ec8c184 | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1922 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.StorageId), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-be347aff | this.spdSub.CellDoubleClick | DM0004_SalesSite.cs:1923 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PlantId), popLocation.PlantId) | 그리드 값 설정 |  |  |  |

## DM0004_SalesSite.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ebdf274 | this.spdSub.ComboSelChange | DM0004_SalesSite.cs:1853 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d34c28e3 | this.spdSub.ComboSelChange | DM0004_SalesSite.cs:1853 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95080b96 | this.spdSub.ComboSelChange | DM0004_SalesSite.cs:1856 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SiteId), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0004_SalesSite.spdSub_EditChange

진입점: this.spdSub.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54f89653 | this.spdSub.EditChange | DM0004_SalesSite.cs:1951 | if (e.Column == siSub.GetColumnIndex(DefColumns.SoldToCode)) | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSite.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fe336a1 | this.spdSub.TopChange | DM0004_SalesSite.cs:2288 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0004_SalesSiteTest99.cboDivision_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a5f94f6 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1831 | if (sDivision != "40") | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-3c5be8c9 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1831 | if (sDivision != "40") | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2760d0b | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1832 | if (sDivision != "40") | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3f87a280 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1836 | if (sDivision != "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8ccd5748 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1836 | if (sDivision != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2c5c6720 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1837 | if (sDivision != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-82d93341 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1841 | if (sDivision != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0724dfe3 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1841 | if (sDivision != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54e7e953 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1842 | if (sDivision != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-74e38d4a | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1846 | else of (sDivision != "40") | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e393543 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1846 | else of (sDivision != "40") | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c83c4fca | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1847 | else of (sDivision != "40") | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a1722300 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1851 | else of (sDivision != "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a86c7426 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1851 | else of (sDivision != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aac446cd | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1852 | else of (sDivision != "40") | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-42d6c845 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1856 | else of (sDivision != "40") | FLAG | dtSalesSite | Data.ScmSitebyEndCustomer40(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-56ae78c1 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1856 | else of (sDivision != "40") | COMBO_DATA | Data.ScmSitebyEndCustomer40 | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07bb30a0 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1857 | else of (sDivision != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b38d7e03 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1860 |  | FLAG | dtSoldToCustomer | Data.Common(Data.Type.SoldCustomer, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-0b31cd21 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1860 |  | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-08e1560d | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1861 |  | LIST_REBIND | clsCtrl.setListBox | (dtSoldToCustomer, clbSoldToCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ac28b9cb | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1863 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-37ce0461 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1863 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e2ff0fbf | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1868 |  | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-74625ad8 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1872 | if (cboDivision.ControlValues == "40") | UI_PROP | lblSoldToCustomer.Width | 350 | 속성 Width 설정 |  |  |  |
| AC-2d93a48f | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1873 | if (cboDivision.ControlValues == "40") | UI_PROP | lblSalesSite.Width | 300 | 속성 Width 설정 |  |  |  |
| AC-372784f7 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1874 | if (cboDivision.ControlValues == "40") | UI_PROP | lblActive.Width | 200 | 속성 Width 설정 |  |  |  |
| AC-65284e85 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1878 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblTeam.Width | 220 | 속성 Width 설정 |  |  |  |
| AC-24249606 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1879 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblEndCustomer.Width | 240 | 속성 Width 설정 |  |  |  |
| AC-065e9a17 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1880 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblSoldToCustomer.Width | 250 | 속성 Width 설정 |  |  |  |
| AC-7a023422 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1881 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblSalesSite.Width | 200 | 속성 Width 설정 |  |  |  |
| AC-9ad9a033 | this.Load 외 1 | DM0004_SalesSiteTest99.cs:1882 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblActive.Width | 150 | 속성 Width 설정 |  |  |  |

## DM0004_SalesSiteTest99.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bfe2d74 | this.chkDetail.CheckedChanged | DM0004_SalesSiteTest99.cs:2427 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DM0004_SalesSiteTest99.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe12011f | this.clbEndCustomer.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1939 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c1c4955d | this.clbEndCustomer.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1939 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fecd700e | this.clbEndCustomer.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1940 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0004_SalesSiteTest99.clbSoldToCustomer_SelectedIndexChanged

진입점: this.clbSoldToCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67290dd0 | this.clbSoldToCustomer.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1947 |  | COMBO_DATA | Data.SiteByEndCustomerSold | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f8ef17ca | this.clbSoldToCustomer.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1948 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0004_SalesSiteTest99.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ef3c2ef | this.clbTeam.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1925 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-56ff61af | this.clbTeam.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1925 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d18d517d | this.clbTeam.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1926 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-275198ab | this.clbTeam.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1930 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a619d993 | this.clbTeam.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1930 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31cdcaa2 | this.clbTeam.SelectedIndexChanged | DM0004_SalesSiteTest99.cs:1931 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0004_SalesSiteTest99.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a0f2d2c | this.Load | DM0004_SalesSiteTest99.cs:313 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b9367cc5 | this.Load | DM0004_SalesSiteTest99.cs:314 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2d3ff69a | this.Load | DM0004_SalesSiteTest99.cs:318 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubCustomer, SpdSheet.shtSubCustomer, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6c3a3bc3 | this.Load | DM0004_SalesSiteTest99.cs:319 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubLocation, SpdSheet.shtSubLocation, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2ccb17a7 | this.Load | DM0004_SalesSiteTest99.cs:320 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubBucket, SpdSheet.shtSubBucket, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0c31c5cc | this.Load | DM0004_SalesSiteTest99.cs:322 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubCustomer) | 화면 필드/플래그 변경 |  |  |  |
| AC-dda472ca | this.Load | DM0004_SalesSiteTest99.cs:323 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubLocation) | 화면 필드/플래그 변경 |  |  |  |
| AC-163b3a2d | this.Load | DM0004_SalesSiteTest99.cs:324 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubBucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-653f76fa | this.Load | DM0004_SalesSiteTest99.cs:326 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9123df23 | this.Load | DM0004_SalesSiteTest99.cs:329 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd2f22db | this.Load | DM0004_SalesSiteTest99.cs:332 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-527e8565 | this.Load | DM0004_SalesSiteTest99.cs:335 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e3ceb15 | this.Load | DM0004_SalesSiteTest99.cs:339 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0004_SalesSiteTest99.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-751756f7 | this.Load | DM0004_SalesSiteTest99.cs:294 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |
| AC-3948bb0f | this.Load | DM0004_SalesSiteTest99.cs:295 |  | STATE | usrConditionPanel2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-2817848e | this.Load | DM0004_SalesSiteTest99.cs:296 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-8bee946a | this.Load | DM0004_SalesSiteTest99.cs:298 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-752dd5c1 | this.Load | DM0004_SalesSiteTest99.cs:300 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-05ad8a80 | this.Load | DM0004_SalesSiteTest99.cs:300 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b3af82f | this.Load | DM0004_SalesSiteTest99.cs:303 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-38965fd4 | this.Load | DM0004_SalesSiteTest99.cs:305 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e04ae78c | this.Load | DM0004_SalesSiteTest99.cs:306 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-7654b7ea | this.Load | DM0004_SalesSiteTest99.cs:307 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-79a5e1b0 | this.Load | DM0004_SalesSiteTest99.cs:308 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DM0004_SalesSiteTest99.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-393195a7 | DeleteButton | DM0004_SalesSiteTest99.cs:424 | if (fps.Name == "spdMain") ▸ if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Strin… | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-60a75bcf | DeleteButton | DM0004_SalesSiteTest99.cs:431 | else of (fps.Name == "spdMain") ▸ if (siSub.GetText(siSub.ActiveRowIndex, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Str… | CALL_EXT | siSub.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0004_SalesSiteTest99.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03f2b5c8 | Dispose | DM0004_SalesSiteTest99.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0004_SalesSiteTest99.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e36b565 | EditButton | DM0004_SalesSiteTest99.cs:444 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5b9f172b | EditButton | DM0004_SalesSiteTest99.cs:445 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce6c8f69 | EditButton | DM0004_SalesSiteTest99.cs:448 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-21071275 | EditButton | DM0004_SalesSiteTest99.cs:449 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c876d9c6 | EditButton | DM0004_SalesSiteTest99.cs:458 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) | CALL_EXT | f.IsRowFilteredOut | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6a5cfcb | EditButton | DM0004_SalesSiteTest99.cs:465 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1eaa7d7 | EditButton | DM0004_SalesSiteTest99.cs:466 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f57b19e6 | EditButton | DM0004_SalesSiteTest99.cs:470 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(iRow, siMain.GetColumnIndex… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c56b2738 | EditButton | DM0004_SalesSiteTest99.cs:479 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76ca0e51 | EditButton | DM0004_SalesSiteTest99.cs:480 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-075dff8c | EditButton | DM0004_SalesSiteTest99.cs:491 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e04ef623 | EditButton | DM0004_SalesSiteTest99.cs:492 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2606155d | EditButton | DM0004_SalesSiteTest99.cs:502 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Sh… | 그리드 편집 잠금/해제 |  |  |  |
| AC-876417b4 | EditButton | DM0004_SalesSiteTest99.cs:503 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b72db56 | EditButton | DM0004_SalesSiteTest99.cs:507 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a67825f | EditButton | DM0004_SalesSiteTest99.cs:517 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Pl… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9f05d24 | EditButton | DM0004_SalesSiteTest99.cs:518 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc9b02ab | EditButton | DM0004_SalesSiteTest99.cs:522 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c557c07 | EditButton | DM0004_SalesSiteTest99.cs:534 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.In… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1c78ab8 | EditButton | DM0004_SalesSiteTest99.cs:535 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-378e6dbf | EditButton | DM0004_SalesSiteTest99.cs:539 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |

## DM0004_SalesSiteTest99.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86a7f368 | FindButton | DM0004_SalesSiteTest99.cs:389 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSiteTest99.FindData_Main

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7459b964 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:585 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-186f6615 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:598 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f07dae6c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:600 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1a96fdc | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:608 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-381e1690 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:612 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_DATA_40") ⇒ DM.DM0004_GET_SALES_SITE_DATA_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-755c2620 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:614 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-c95d9c12 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:615 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-695b668c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:616 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a5dd2166 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:617 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-6a4a4e3d | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:618 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-530dc8b9 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:619 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-eb1d806c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:620 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9ba95fc4 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:621 | lambda | DATA_OP | request.Parameters["p_soldto_customer"] | clbSoldToCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-2253c06b | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:623 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06286198 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:625 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3bb9b154 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:632 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cf8c2f41 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:633 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-204894ce | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:642 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbecb65a | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DM0004_SalesSiteTest99.cs:649 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSiteTest99.FindData_SubBucket

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cdd2d58 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:775 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64bbd384 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:782 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f47176ca | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:786 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_BUCKET_DATA") ⇒ DM.DM0004_GET_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-70f47236 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:788 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c7735b3c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:789 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-d915e8c7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:790 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7a4c9d67 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:791 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f684ac06 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:793 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d6814ea8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:795 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eb73e921 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:802 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-71be97df | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:803 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8206fedb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:805 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67eb1d87 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:812 |  | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DM0004_SalesSiteTest99.FindData_SubCustomer

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d166d58 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:656 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9d035204 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:660 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b8d98ad | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:667 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-106ac247 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:671 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA_40") ⇒ DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-2e9b8ce0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:673 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-881ac58a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:674 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-f16ef6e1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:675 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-1adc8c5a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:676 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8c5e6219 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:677 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fdc526fc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:679 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-19add55b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:681 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-bca71855 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:688 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-54e5a98d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:689 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3e18d7cd | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:699 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2273aef1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:700 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-80f0933e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:708 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSiteTest99.FindData_SubLocation

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub != null && siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a78355fe | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:715 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f5f0ec75 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:719 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1924f5b9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:726 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f76057fe | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:730 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0004_GET_SALES_SITE_LOCATION_DATA") ⇒ DM.DM0004_GET_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-421991ca | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:732 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-988b2df4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:733 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-ea6fe0ee | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:734 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-34bb9af2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:735 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-07d06b04 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:736 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-91612111 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:738 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-668507f6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:740 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0dcb393c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:747 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e161b1d4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:748 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0977a0a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:758 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-74d80c5b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DM0004_SalesSiteTest99.cs:766 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSiteTest99.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a7e4a96 | this.Load | DM0004_SalesSiteTest99.cs:225 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b7de0aa | this.Load | DM0004_SalesSiteTest99.cs:226 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0004_SalesSiteTest99.GetPlantbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43e7e602 | (진입점 미연결) | DM0004_SalesSiteTest99.cs:2466 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d6928bc3 | (진입점 미연결) | DM0004_SalesSiteTest99.cs:2467 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9f58225e | (진입점 미연결) | DM0004_SalesSiteTest99.cs:2468 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7166242 | (진입점 미연결) | DM0004_SalesSiteTest99.cs:2471 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSiteTest99.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ebba0b2 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSiteTest99.cs:2454 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0004_TEST", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-27a1cf36 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSiteTest99.cs:2456 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSiteTest99.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47130250 | this.Load | DM0004_SalesSiteTest99.cs:256 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-86a4d779 | this.Load | DM0004_SalesSiteTest99.cs:256 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d52bb3ea | this.Load | DM0004_SalesSiteTest99.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3cba6d21 | this.Load | DM0004_SalesSiteTest99.cs:261 | if (dtDivision.Rows.Count == 1 && dtDivision.Rows[0][0].ToString() == "40") | VALUE_SET | cboDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-6d2079ad | this.Load | DM0004_SalesSiteTest99.cs:266 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-aa4f5a70 | this.Load | DM0004_SalesSiteTest99.cs:266 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4c17e3e | this.Load | DM0004_SalesSiteTest99.cs:267 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1fc144e4 | this.Load | DM0004_SalesSiteTest99.cs:271 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5060084c | this.Load | DM0004_SalesSiteTest99.cs:271 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fdaf0bdb | this.Load | DM0004_SalesSiteTest99.cs:272 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4156eb02 | this.Load | DM0004_SalesSiteTest99.cs:276 |  | FLAG | dtSoldToCustomer | Data.Common(Data.Type.SoldCustomer, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-c5e32551 | this.Load | DM0004_SalesSiteTest99.cs:276 |  | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7898d849 | this.Load | DM0004_SalesSiteTest99.cs:277 |  | LIST_REBIND | clsCtrl.setListBox | (dtSoldToCustomer, clbSoldToCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e6c86d3e | this.Load | DM0004_SalesSiteTest99.cs:279 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a18f6c5c | this.Load | DM0004_SalesSiteTest99.cs:279 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-486a22da | this.Load | DM0004_SalesSiteTest99.cs:280 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-19d42f8a | this.Load | DM0004_SalesSiteTest99.cs:282 |  | FLAG | dtDetailSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-839e9701 | this.Load | DM0004_SalesSiteTest99.cs:282 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33437adc | this.Load | DM0004_SalesSiteTest99.cs:284 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1f2354cc | this.Load | DM0004_SalesSiteTest99.cs:286 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-7c57e18a | this.Load | DM0004_SalesSiteTest99.cs:286 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8946a34f | this.Load | DM0004_SalesSiteTest99.cs:288 |  | FLAG | dtTeamAll | Data.Common(Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 화면 필드/플래그 변경 |  |  |  |
| AC-58029c2c | this.Load | DM0004_SalesSiteTest99.cs:288 |  | COMBO_DATA | Data.Common | (Data.Type.TeambyAll, false) ⇒ biz:CommonData.CommonDataList [code=TeambyAll] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0004_SalesSiteTest99.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b353fe4a | this.Load | DM0004_SalesSiteTest99.cs:366 |  | FLAG | dtSubBucket | new DataTable("SubSubBucketSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-d7b68501 | this.Load | DM0004_SalesSiteTest99.cs:367 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-970e0c7b | this.Load | DM0004_SalesSiteTest99.cs:368 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.SiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea14cc5e | this.Load | DM0004_SalesSiteTest99.cs:369 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5918f2ea | this.Load | DM0004_SalesSiteTest99.cs:370 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3e7a2f0 | this.Load | DM0004_SalesSiteTest99.cs:371 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.BucketPer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a68ca4a7 | this.Load | DM0004_SalesSiteTest99.cs:372 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0004_SalesSiteTest99.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86c2ed75 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSiteTest99.cs:344 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac7c822f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 3 | DM0004_SalesSiteTest99.cs:345 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0004_SalesSiteTest99.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f17fd61b | InsertButton | DM0004_SalesSiteTest99.cs:1571 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fbbe5173 | InsertButton | DM0004_SalesSiteTest99.cs:1573 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e12070c | InsertButton | DM0004_SalesSiteTest99.cs:1586 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.Ge… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-78edae02 | InsertButton | DM0004_SalesSiteTest99.cs:1586 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInde… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c226a52b | InsertButton | DM0004_SalesSiteTest99.cs:1587 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-94ee66dd | InsertButton | DM0004_SalesSiteTest99.cs:1589 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.G… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-cc5f8f6b | InsertButton | DM0004_SalesSiteTest99.cs:1589 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInd… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b387837e | InsertButton | DM0004_SalesSiteTest99.cs:1591 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0b06c6f6 | InsertButton | DM0004_SalesSiteTest99.cs:1592 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c3b5dcad | InsertButton | DM0004_SalesSiteTest99.cs:1595 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SiteId), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e27d97ea | InsertButton | DM0004_SalesSiteTest99.cs:1596 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a0319e7 | InsertButton | DM0004_SalesSiteTest99.cs:1597 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eccc01a7 | InsertButton | DM0004_SalesSiteTest99.cs:1602 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-975d63c0 | InsertButton | DM0004_SalesSiteTest99.cs:1603 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CountryNa… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f449c268 | InsertButton | DM0004_SalesSiteTest99.cs:1604 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CityName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-5bc168f9 | InsertButton | DM0004_SalesSiteTest99.cs:1606 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-83e77d00 | InsertButton | DM0004_SalesSiteTest99.cs:1607 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VmiYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-ffc6565c | InsertButton | DM0004_SalesSiteTest99.cs:1608 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), cboDivision.ControlVal… | 그리드 값 설정 |  |  |  |
| AC-b34a545a | InsertButton | DM0004_SalesSiteTest99.cs:1610 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a652becc | InsertButton | DM0004_SalesSiteTest99.cs:1616 | else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ed9be32 | InsertButton | DM0004_SalesSiteTest99.cs:1620 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7ec4fe26 | InsertButton | DM0004_SalesSiteTest99.cs:1622 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c37364eb | InsertButton | DM0004_SalesSiteTest99.cs:1625 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6048d6fb | InsertButton | DM0004_SalesSiteTest99.cs:1628 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.A… | 그리드 값 설정 |  |  |  |
| AC-e704206b | InsertButton | DM0004_SalesSiteTest99.cs:1629 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId), siMain.GetValue(siMain.Act… | 그리드 값 설정 |  |  |  |
| AC-60579dce | InsertButton | DM0004_SalesSiteTest99.cs:1633 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b325d21 | InsertButton | DM0004_SalesSiteTest99.cs:1634 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dc6f9f8f | InsertButton | DM0004_SalesSiteTest99.cs:1635 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToDescription), siSub.ActiveRow… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ff98be0f | InsertButton | DM0004_SalesSiteTest99.cs:1636 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5861751 | InsertButton | DM0004_SalesSiteTest99.cs:1638 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-bb834ffb | InsertButton | DM0004_SalesSiteTest99.cs:1639 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2fe118ac | InsertButton | DM0004_SalesSiteTest99.cs:1641 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.RepYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-bd1f40c3 | InsertButton | DM0004_SalesSiteTest99.cs:1642 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-9ae92223 | InsertButton | DM0004_SalesSiteTest99.cs:1643 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValue… | 그리드 값 설정 |  |  |  |
| AC-ed54aa4b | InsertButton | DM0004_SalesSiteTest99.cs:1647 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-09e6da7d | InsertButton | DM0004_SalesSiteTest99.cs:1648 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), siSub.ActiveR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-98a3266c | InsertButton | DM0004_SalesSiteTest99.cs:1649 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-c63166f0 | InsertButton | DM0004_SalesSiteTest99.cs:1650 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationCode… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b91458c1 | InsertButton | DM0004_SalesSiteTest99.cs:1652 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-badbaf97 | InsertButton | DM0004_SalesSiteTest99.cs:1653 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValue… | 그리드 값 설정 |  |  |  |
| AC-f2ac2c17 | InsertButton | DM0004_SalesSiteTest99.cs:1657 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bb5c4feb | InsertButton | DM0004_SalesSiteTest99.cs:1658 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), siSub.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-13f4f597 | InsertButton | DM0004_SalesSiteTest99.cs:1660 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValue… | 그리드 값 설정 |  |  |  |
| AC-3085ce0b | InsertButton | DM0004_SalesSiteTest99.cs:1663 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-76cf9439 | InsertButton | DM0004_SalesSiteTest99.cs:1664 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0004_SalesSiteTest99.SaveData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-634298c5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:823 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a2b1860 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:916 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b62af338 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:918 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColu… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb021c60 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:929 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1bb3efdc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:931 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d46eca4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:943 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4aa0f13 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:945 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ef13f32 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:955 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2120068 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:957 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d49e314a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:966 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-caeb51df | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:968 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8ffbbecc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:977 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f96e5cc1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:979 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea594f08 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:988 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6507c5f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:990 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98306c91 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:999 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5fd813c4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1001 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.GetValue(i, siMain.Ge… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87c60163 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1016 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-502ec5b0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1017 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-127adb7c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1018 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-b6dd6ea3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1019 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-3f4662f3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1020 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_description"] | sSalesSiteDesc | 행/컬럼 값 대입 |  |  |  |
| AC-e7738cab | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1021 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-2ade6f30 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1022 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sold_customer"] | sSoldToCode | 행/컬럼 값 대입 |  |  |  |
| AC-be56bf0f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1023 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_city"] | sCity | 행/컬럼 값 대입 |  |  |  |
| AC-aa35014e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1024 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_country"] | sCountry | 행/컬럼 값 대입 |  |  |  |
| AC-6145a48a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1025 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-e7fca751 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1026 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | sVmiYN | 행/컬럼 값 대입 |  |  |  |
| AC-d9baaf17 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1027 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-b9254be9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1028 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-4923bfc2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1030 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-03f736e1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1034 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d19fabf | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1039 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c645582b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1046 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 화면 필드/플래그 변경 |  |  |  |
| AC-7f42c836 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1046 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivisionDept, false, sDivision, sTeam, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivisionDept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-223b594a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1047 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7cd81688 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1051 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, U… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-965eb6b0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1051 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer, false, sDivision, clbEndCustomer.ControlValues, UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a823ed4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1052 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSoldToCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-251bb34a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1063 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-455bf678 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DM0004_SalesSiteTest99.cs:1072 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSiteTest99.SaveSubBucketData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ababa5d1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1436 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5f64697 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1491 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6227cba | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1492 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd42e0fd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1497 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b0235a4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1498 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3d5edb3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1503 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdfd3f02 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1504 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3392899 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1517 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-4bb3e559 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1518 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-04171570 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1519 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-d3012cfa | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1520 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-e0cc902e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1521 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_Incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-8c56b638 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1522 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-8c9df3da | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1523 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bucket_per"] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-3cae6246 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1524 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_conversion_type"] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-b6e988e5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1526 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-20d1f7e4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1528 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-880a176d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1532 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9eaf5d1f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1536 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c492bb1f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1548 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a282fca7 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1557 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSiteTest99.SaveSubCustomerData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-927e9b05 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1083 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89bd6519 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1111 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00120") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-953cca08 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1112 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b49f01d1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1149 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-29482cac | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1151 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a945708d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1160 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5755ee31 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1162 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0864b969 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1171 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa545496 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1173 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f16a8da | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1182 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee406a89 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1184 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a729778 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1200 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-7c0edc89 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1201 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-53c2de17 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1202 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-f441d9b9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1203 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-290fb984 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1204 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_code"] | sSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-9dc6a597 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1205 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_description"] | sSoldToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-11814aea | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1206 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_code"] | sShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-fa6fa249 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1207 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_description"] | sShipToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-8f190492 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1208 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_rep_yn"] | sRepYN | 행/컬럼 값 대입 |  |  |  |
| AC-fe066fff | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1209 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-b26081f6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1210 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-eda9d46d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1212 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f1bde107 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1221 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00179", new object[] { SalesSiteId, ShipToCode }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-167e3872 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1225 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ els… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d947e63d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1230 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b28389c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1243 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e5b32cd3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DM0004_SalesSiteTest99.cs:1252 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSiteTest99.SaveSubLocationData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5b6c1f4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1261 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21c8de83 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1324 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b96f2dfd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1326 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc0c5424 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1335 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f530275 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1337 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52e09301 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1361 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e961ff8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1363 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationCode), "") | 그리드 값 설정 |  |  |  |
| AC-ef1b8c30 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1364 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationDescription), "") | 그리드 값 설정 |  |  |  |
| AC-95d91937 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1365 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.PlantId), "") | 그리드 값 설정 |  |  |  |
| AC-7c203fdb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1367 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c85edcc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1386 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0004_SAVE_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-cf9cdcd0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1387 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-be346e58 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1388 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_seq"] | sLocationSeq | 행/컬럼 값 대입 |  |  |  |
| AC-1573445c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1389 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-92467f19 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1390 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_code"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-ad0187c6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1391 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_description"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-67c3d01d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1392 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-1b02b0cd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1393 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_id"] | sPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-07ecd2bb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1394 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_storage_id"] | sStorageId | 행/컬럼 값 대입 |  |  |  |
| AC-6af3b0f3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1395 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-589f326e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1396 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-38ef869b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1398 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b457251f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1402 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd1dd614 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1406 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da57094f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1419 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52528c71 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DM0004_SalesSiteTest99.cs:1428 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0004_SalesSiteTest99.SetGridHeader

진입점: this.Load / cboDivision.SelectedIndexChanged / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70f77b72 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1889 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0004_TEST", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-60ae9c18 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1900 | if (cboDivision.ControlValues == "40") ▸ for (i < dt.Rows.Count - 1) ▸ if (sDivGbn == "81,82") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.Team].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-65f98e14 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1901 | if (cboDivision.ControlValues == "40") ▸ for (i < dt.Rows.Count - 1) ▸ if (sDivGbn == "81,82") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TeamName].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-93dd88c5 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1902 | if (cboDivision.ControlValues == "40") ▸ for (i < dt.Rows.Count - 1) ▸ if (sDivGbn == "81,82") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.EndCustomer].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-915d19af | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1906 | if (cboDivision.ControlValues == "40") | UI_PROP | lblTeam.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-48a3b423 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1907 | if (cboDivision.ControlValues == "40") | UI_PROP | lblEndCustomer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5409ef0b | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1911 | else of (cboDivision.ControlValues == "40") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.Team].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c003dd0c | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1912 | else of (cboDivision.ControlValues == "40") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TeamName].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9227f391 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1913 | else of (cboDivision.ControlValues == "40") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.EndCustomer].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d2e34a81 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1915 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblTeam.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6e61a709 | this.Load 외 3 | DM0004_SalesSiteTest99.cs:1916 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblEndCustomer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## DM0004_SalesSiteTest99.SetSubBucketData

진입점: dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73e27be3 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2298 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-9be9f807 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2302 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-785ed5fb | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2303 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-c9e67b3a | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2304 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SiteId] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-089ed3ac | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2305 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-4ca69955 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2306 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-8d9e1aa5 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2307 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-fd7db6ee | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2308 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-ac1fdffa | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2310 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-0139022e | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2311 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-60a876db | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2315 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-4b6930de | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DM0004_SalesSiteTest99.cs:2316 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0004_SalesSiteTest99.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-827d4a85 | dsdm.Changed | DM0004_SalesSiteTest99.cs:2363 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Sold… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), sScmSite) | 그리드 값 설정 |  |  |  |
| AC-7f65f176 | dsdm.Changed | DM0004_SalesSiteTest99.cs:2375 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b8935427 | dsdm.Changed | DM0004_SalesSiteTest99.cs:2393 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff014767 | dsdm.Changed | DM0004_SalesSiteTest99.cs:2395 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-c17cbfc9 | dsdm.Changed | DM0004_SalesSiteTest99.cs:2406 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-c1a6141c | dsdm.Changed | DM0004_SalesSiteTest99.cs:2407 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-008048b6 | dsdm.Changed | DM0004_SalesSiteTest99.cs:2414 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |
| AC-95eb4054 | dsdm.Changed | DM0004_SalesSiteTest99.cs:2415 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSiteTest99.shtSubBucketDataModel_Changed

진입점: dsdm3.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e37ba0f9 | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2233 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d23a0045 | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2234 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bda79ea6 | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2239 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb7473dc | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2240 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c3395ee | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2245 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f62f9822 | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2246 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a80a1d5 | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2277 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04a1a2be | dsdm3.Changed | DM0004_SalesSiteTest99.cs:2279 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.Incoterms), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSiteTest99.shtSubCustomerDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03d724bc | dsdm2.Changed | DM0004_SalesSiteTest99.cs:2151 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | MESSAGE | MessageHelper.GMessageBox | ("MSG00149") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-185fa33e | dsdm2.Changed | DM0004_SalesSiteTest99.cs:2152 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | GRID_SET | siSub.SetValue | (e.Row, e.Column, "N") | 그리드 값 설정 |  |  |  |
| AC-452f0747 | dsdm2.Changed | DM0004_SalesSiteTest99.cs:2180 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a06fc6f | dsdm2.Changed | DM0004_SalesSiteTest99.cs:2182 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), "") | 그리드 값 설정 |  |  |  |
| AC-835bcfbd | dsdm2.Changed | DM0004_SalesSiteTest99.cs:2183 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), "") | 그리드 값 설정 |  |  |  |
| AC-cee2f17f | dsdm2.Changed | DM0004_SalesSiteTest99.cs:2184 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |
| AC-a533fa30 | dsdm2.Changed | DM0004_SalesSiteTest99.cs:2185 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-043a4abe | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1676 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb43d4ef | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1682 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e044f337 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1683 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-336592d3 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1690 | if (siMain.IsLock(siMain.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-805abdb4 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1707 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.String… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15ce2b7c | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1726 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), "") | 그리드 값 설정 |  |  |  |
| AC-17bfdbab | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1728 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | new SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-349bc695 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1730 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.Form_Load | (false, sDivisionId, sSoldToName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-852e337e | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1731 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | UI_PROP | popSoldto.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4173ef08 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1732 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ffb11e59 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1739 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), sSoldToCode.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-9b6b9cd1 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1740 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldToName), sSoldToName.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-2831801a | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1762 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ac0ca1c3 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1763 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7edd3022 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1764 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ad225237 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1774 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | msScmSite | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) + "_" + sCity.Substring(0,… | 화면 필드/플래그 변경 |  |  |  |
| AC-3eafa12d | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1777 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | mbScmSite | true | 화면 필드/플래그 변경 |  |  |  |
| AC-997daeac | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1780 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), sCountry) | 그리드 값 설정 |  |  |  |
| AC-b39b2ba6 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1781 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CountryName), sCountryName) | 그리드 값 설정 |  |  |  |
| AC-37ede831 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1782 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), sCity) | 그리드 값 설정 |  |  |  |
| AC-b78df1f8 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1783 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CityName), sCityName) | 그리드 값 설정 |  |  |  |
| AC-daa79ba8 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1802 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4953e898 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1804 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-47f02a22 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1805 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c9a1af62 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1806 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2be55334 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1813 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-590e4a18 | this.spdMain.CellDoubleClick | DM0004_SalesSiteTest99.cs:1814 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sTeamName) | 그리드 값 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b84a0863 | this.spdMain.ComboSelChange | DM0004_SalesSiteTest99.cs:1966 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-4efa8f57 | this.spdMain.ComboSelChange | DM0004_SalesSiteTest99.cs:1966 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-182f69ef | this.spdMain.ComboSelChange | DM0004_SalesSiteTest99.cs:1972 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-35ce3114 | this.spdMain.ComboSelChange | DM0004_SalesSiteTest99.cs:1974 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b4db2f6 | this.spdMain.ComboSelChange | DM0004_SalesSiteTest99.cs:1974 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-994f7c63 | this.spdMain.ComboSelChange | DM0004_SalesSiteTest99.cs:1975 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ba8aa7e | this.spdMain.EditChange | DM0004_SalesSiteTest99.cs:2087 | if (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), "") | 그리드 값 설정 |  |  |  |
| AC-2b4a4d1f | this.spdMain.EditChange | DM0004_SalesSiteTest99.cs:2091 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-8554e937 | this.spdMain.EditChange | DM0004_SalesSiteTest99.cs:2095 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) ▸ if … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-414d014c | this.spdMain.LeaveCell | DM0004_SalesSiteTest99.cs:2125 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d684675b | this.spdMain.TopChange | DM0004_SalesSiteTest99.cs:2433 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0004_SalesSiteTest99.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f02bb769 | this.spdSub.ActiveSheetChanging | DM0004_SalesSiteTest99.cs:2111 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-ec349950 | this.spdSub.ActiveSheetChanging | DM0004_SalesSiteTest99.cs:2113 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4dbe8e30 | this.spdSub.ActiveSheetChanging | DM0004_SalesSiteTest99.cs:2114 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0004_SalesSiteTest99.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c190f96 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2016 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5a904f4 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2030 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-64ba03ff | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2032 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.Form_Load | (false, sDivisionId, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-08f4b76a | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2033 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1a56f13d | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2034 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aee3ae2f | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2043 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-a3a6dc26 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2044 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), popCustomer.SoldToDesc) | 그리드 값 설정 |  |  |  |
| AC-1c7897d8 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2045 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-92e9147b | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2046 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), popCustomer.ShipToDesc) | 그리드 값 설정 |  |  |  |
| AC-9095fe82 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2047 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName), popCustomer.ShiptoRegion) | 그리드 값 설정 |  |  |  |
| AC-9601319f | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2048 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName), popCustomer.ShiptoCity) | 그리드 값 설정 |  |  |  |
| AC-03256126 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2060 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | new SCM0002_StoragebyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5712ca8b | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2062 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.Form_Load | (false, sDivisionId, sLocationCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8f67f7aa | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2063 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | UI_PROP | popLocation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d5441e32 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2064 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aae1e758 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2071 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationCode), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-1cba25bd | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2072 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationDescription), popLocation.StorageDesc) | 그리드 값 설정 |  |  |  |
| AC-bc2ac3ae | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2074 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.StorageId), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-96efdad3 | this.spdSub.CellDoubleClick | DM0004_SalesSiteTest99.cs:2075 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PlantId), popLocation.PlantId) | 그리드 값 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1f8d1aa | this.spdSub.ComboSelChange | DM0004_SalesSiteTest99.cs:2005 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-58f33422 | this.spdSub.ComboSelChange | DM0004_SalesSiteTest99.cs:2005 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7bac8f97 | this.spdSub.ComboSelChange | DM0004_SalesSiteTest99.cs:2008 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SiteId), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdSub_EditChange

진입점: this.spdSub.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b22a526a | this.spdSub.EditChange | DM0004_SalesSiteTest99.cs:2103 | if (e.Column == siSub.GetColumnIndex(DefColumns.SoldToCode)) | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |

## DM0004_SalesSiteTest99.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e483c6ac | this.spdSub.TopChange | DM0004_SalesSiteTest99.cs:2440 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

