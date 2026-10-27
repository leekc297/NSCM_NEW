# AS-IS 액션 대조표 — DMF0010

> 원천: `Doc/asisfacts/screens/DMF0010/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 426행 · 메서드 46 · 종류 DATA_OP 59 · FLAG 54 · UI_PROP 48 · GRID_SET 43 · COMBO_DATA 32 · POPUP 30 · RETURN 30 · UI_MISC 20 · MESSAGE 16 · GRID_INIT 15 · ENDPOINT 15 · CALL_EXT 13 · GRID_COMBO 12 · LIST_REBIND 11 · STATE 9 · GRID_LOCK 7 · VALUE_SET 4 · VALUE_CLEAR 3 · THROW 2 · GRID_STYLE 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 13


## DMF0010_BizPlanPrice..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-643a1fb0 | .ctor | DMF0010_BizPlanPrice.cs:306 |  | UI_PROP | usrMonthFrom.MonthText | now.AddYears(1).ToString("yyyy") + "01" | 속성 MonthText 설정 |  |  |  |
| AC-942d35a9 | .ctor | DMF0010_BizPlanPrice.cs:307 |  | UI_PROP | usrMonthTo.MonthText | now.AddYears(5).ToString("yyyy") + "12" | 속성 MonthText 설정 |  |  |  |

## DMF0010_BizPlanPrice.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8af1fbae | this.btnColumn.Click | DMF0010_BizPlanPrice.cs:2433 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.DM0002_TitleSetForm_Popup | ("DMF0010", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-e9e7d6fa | this.btnColumn.Click | DMF0010_BizPlanPrice.cs:2434 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-43d965e5 | this.btnColumn.Click | DMF0010_BizPlanPrice.cs:2435 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0010_BizPlanPrice.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ef603a7 | this.btnCutOff.Click | DMF0010_BizPlanPrice.cs:2476 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-1e505a1e | this.btnCutOff.Click | DMF0010_BizPlanPrice.cs:2477 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd75475c | this.btnCutOff.Click | DMF0010_BizPlanPrice.cs:2482 |  | POPUP | new GSCM.DM.Master.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-f8a3e04f | this.btnCutOff.Click | DMF0010_BizPlanPrice.cs:2484 |  | CALL_EXT | popup.LoadDataDiv | (sVersion_Type, sFoxData, sDivisionId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82696193 | this.btnCutOff.Click | DMF0010_BizPlanPrice.cs:2485 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-89df7e08 | this.btnCutOff.Click | DMF0010_BizPlanPrice.cs:2486 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0010_BizPlanPrice.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bb5be99 | this.btnExchangeRate.Click | DMF0010_BizPlanPrice.cs:2453 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55397914 | this.btnExchangeRate.Click | DMF0010_BizPlanPrice.cs:2454 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a041634 | this.btnExchangeRate.Click | DMF0010_BizPlanPrice.cs:2457 |  | POPUP | new DMF009_MetalCurrencyPricePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-985f3b04 | this.btnExchangeRate.Click | DMF0010_BizPlanPrice.cs:2458 |  | CALL_EXT | popup.LoadData | (DateTime.Now.ToString("yyyy") + "01", DateTime.Now.AddYears(5).ToString("yyyy") + "12", c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfffbb85 | this.btnExchangeRate.Click | DMF0010_BizPlanPrice.cs:2459 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1425ac43 | this.btnExchangeRate.Click | DMF0010_BizPlanPrice.cs:2460 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0010_BizPlanPrice.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f486460d | this.btnItemId.Click | DMF0010_BizPlanPrice.cs:1941 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-eb729068 | this.btnItemId.Click | DMF0010_BizPlanPrice.cs:1943 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ca38623e | this.btnItemId.Click | DMF0010_BizPlanPrice.cs:1944 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b6c207c0 | this.btnItemId.Click | DMF0010_BizPlanPrice.cs:1945 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-12bb10ab | this.btnItemId.Click | DMF0010_BizPlanPrice.cs:1951 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0010_BizPlanPrice.btnModelChange_Click

진입점: this.btnModelChange.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daf139b7 | this.btnModelChange.Click | DMF0010_BizPlanPrice.cs:2420 |  | CALL_EXT | popup.LoadData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ada9a1c | this.btnModelChange.Click | DMF0010_BizPlanPrice.cs:2421 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7ee1996b | this.btnModelChange.Click | DMF0010_BizPlanPrice.cs:2422 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0010_BizPlanPrice.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94e60a55 | this.btnOwner.Click | DMF0010_BizPlanPrice.cs:2214 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-704c97a4 | this.btnOwner.Click | DMF0010_BizPlanPrice.cs:2217 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-765a222c | this.btnOwner.Click | DMF0010_BizPlanPrice.cs:2218 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f3a92052 | this.btnOwner.Click | DMF0010_BizPlanPrice.cs:2219 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-18d7b04d | this.btnOwner.Click | DMF0010_BizPlanPrice.cs:2221 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0010_BizPlanPrice.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a340068 | this.btnProject.Click | DMF0010_BizPlanPrice.cs:1918 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-f86a3a59 | this.btnProject.Click | DMF0010_BizPlanPrice.cs:1919 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1e85eb2b | this.btnProject.Click | DMF0010_BizPlanPrice.cs:1920 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fb36b48f | this.btnProject.Click | DMF0010_BizPlanPrice.cs:1921 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7103333c | this.btnProject.Click | DMF0010_BizPlanPrice.cs:1927 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0010_BizPlanPrice.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56fe6170 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1777 |  | CALL_EXT | stopwatch.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b1cc3f5 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1784 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-28bc0752 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1794 | if (sDivision == "40") | FLAG | dtEndCustomer | dtEndCustomer40 | 화면 필드/플래그 변경 |  |  |  |
| AC-36452549 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1797 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0df93690 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1798 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a167997e | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1808 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-85039d12 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1809 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6ad129c0 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1812 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f152d974 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1813 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-77a47778 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1827 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-30c9f1cc | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1828 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bc9dfc67 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1831 | else of (sDivision == "40") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a84bee89 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1833 | else of (sDivision == "40") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-971275a5 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1835 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-958859f9 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1844 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-848a61c2 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1847 |  | CALL_EXT | siMain.FilterRemove | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4cca91a0 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1850 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5ce71b86 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1851 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-12cd0fd1 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1852 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a32ae831 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1855 |  | CALL_EXT | stopwatch.Stop | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0010_BizPlanPrice.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e51aaef | this.clbEndCustomer.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1892 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3fd76974 | this.clbEndCustomer.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1892 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1482dada | this.clbEndCustomer.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1893 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0010_BizPlanPrice.ClbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3da3e47 | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1873 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-0bca0618 | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1873 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18de8d37 | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1877 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ed264a5c | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1877 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5aa48a9 | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1879 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-63028700 | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1883 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7de3714a | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1883 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1eae4294 | this.clbTeam.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:1884 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0010_BizPlanPrice.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a88e7bd | this.Load | DMF0010_BizPlanPrice.cs:470 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d2fe369c | this.Load | DMF0010_BizPlanPrice.cs:471 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6af0614f | this.Load | DMF0010_BizPlanPrice.cs:472 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0010_BizPlanPrice.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-598d19c8 | this.Load | DMF0010_BizPlanPrice.cs:435 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-53e5b34f | this.Load | DMF0010_BizPlanPrice.cs:438 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c465d49 | this.Load | DMF0010_BizPlanPrice.cs:440 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-c4f7c490 | this.Load | DMF0010_BizPlanPrice.cs:440 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7abfd056 | this.Load | DMF0010_BizPlanPrice.cs:443 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-54396961 | this.Load | DMF0010_BizPlanPrice.cs:444 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(imageList1.Images[0]) | 속성 BackgroundImage 설정 |  |  |  |
| AC-cfd04a8b | this.Load | DMF0010_BizPlanPrice.cs:445 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-3e8213ec | this.Load | DMF0010_BizPlanPrice.cs:446 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-372c4f3a | this.Load | DMF0010_BizPlanPrice.cs:460 | else of (clbDivision.ControlValues.ToString() == "40") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0010_BizPlanPrice.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ac7d05a | DeleteButton | DMF0010_BizPlanPrice.cs:618 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7c83d31 | DeleteButton | DMF0010_BizPlanPrice.cs:620 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d016ce75 | DeleteButton | DMF0010_BizPlanPrice.cs:621 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd8c9689 | DeleteButton | DMF0010_BizPlanPrice.cs:623 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0010_BizPlanPrice.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cf9a0ab | Dispose | DMF0010_BizPlanPrice.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0010_BizPlanPrice.DrawData

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / FindButton [try] / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22ed1c7e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:900 | if (dsMain == null \|\| dsMain.Tables == null \|\| dsMain.Tables.Count < 1 \|\| dtSpan == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dc5e31d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:902 | if (string.IsNullOrWhiteSpace(gDivisionID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c066f8c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:948 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-734c4437 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:949 |  | GRID_BIND | siMain.Query | (dsScreen) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5ba7bb9d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:950 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1480ef4a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:952 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-07711ed8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:975 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IDX_PROJECT_CODE != -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, IDX_PROJECT_CODE].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-8c83ed76 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:979 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IDX_PROJECT_CODE != -1) ▸ if (bProduct == false && siMain.GetValue(iRow, IDX_ITEM_TYPE).ToString… | FLAG | bProduct | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8677dd1d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:980 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IDX_PROJECT_CODE != -1) ▸ if (bProduct == false && siMain.GetValue(iRow, IDX_ITEM_TYPE).ToString… | FLAG | nProduct | iRow | 화면 필드/플래그 변경 |  |  |  |
| AC-0d76972f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:1006 |  | FLAG | this.StartYM | usrMonthFrom.MonthText.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-718b1a18 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 3 | DMF0010_BizPlanPrice.cs:1007 |  | FLAG | this.EndYM | usrMonthTo.MonthText.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |

## DMF0010_BizPlanPrice.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04ef37c4 | EditButton | DMF0010_BizPlanPrice.cs:628 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6858770 | EditButton | DMF0010_BizPlanPrice.cs:630 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86c7520e | EditButton | DMF0010_BizPlanPrice.cs:631 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-836dc460 | EditButton | DMF0010_BizPlanPrice.cs:634 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e172f67 | EditButton | DMF0010_BizPlanPrice.cs:635 | if (string.IsNullOrWhiteSpace(fps.Name) \|\| fps.Name != "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8893575 | EditButton | DMF0010_BizPlanPrice.cs:637 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-87f778b6 | EditButton | DMF0010_BizPlanPrice.cs:640 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c633eda1 | EditButton | DMF0010_BizPlanPrice.cs:643 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e7ce56e4 | EditButton | DMF0010_BizPlanPrice.cs:644 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-fb01f954 | EditButton | DMF0010_BizPlanPrice.cs:645 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a9cfd670 | EditButton | DMF0010_BizPlanPrice.cs:657 | if (IsEditMode) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EditFlag) == CAppSetting.String… | GRID_LOCK | siMain.LockRange2 | (iRow, IDX_DIVISION_ID, iRow, IDX_END_YM, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-c70f34fd | EditButton | DMF0010_BizPlanPrice.cs:661 | if (IsEditMode) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EditFlag) == CAppSetting.String… | GRID_SET | siMain.SetValue | (iRow, IDX_ACTION, CAppSetting.StringM) | 그리드 값 설정 |  |  |  |
| AC-1639d906 | EditButton | DMF0010_BizPlanPrice.cs:672 | else of (IsEditMode) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange2 | (iRow, IDX_MEASURE, iRow, IDX_MAX, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-9f7fd2d4 | EditButton | DMF0010_BizPlanPrice.cs:681 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0010_BizPlanPrice.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8524348c | ExcelButton | DMF0010_BizPlanPrice.cs:702 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-ecbc700e | ExcelButton | DMF0010_BizPlanPrice.cs:703 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-d10513df | ExcelButton | DMF0010_BizPlanPrice.cs:704 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.ShowZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-ef917481 | ExcelButton | DMF0010_BizPlanPrice.cs:705 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-1ba3a544 | ExcelButton | DMF0010_BizPlanPrice.cs:706 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-1fbc612f | ExcelButton | DMF0010_BizPlanPrice.cs:707 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-63a5f40a | ExcelButton | DMF0010_BizPlanPrice.cs:709 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-52d01bab | ExcelButton | DMF0010_BizPlanPrice.cs:710 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-906fbaae | ExcelButton | DMF0010_BizPlanPrice.cs:712 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-49511cbf | ExcelButton | DMF0010_BizPlanPrice.cs:716 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ce45970 | ExcelButton | DMF0010_BizPlanPrice.cs:721 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d531d131 | ExcelButton | DMF0010_BizPlanPrice.cs:725 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0010_BizPlanPrice.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9e404c3 | FindButton | DMF0010_BizPlanPrice.cs:601 |  | DATA_OP | viewAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dc95020 | FindButton | DMF0010_BizPlanPrice.cs:603 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4521fd50 | FindButton | DMF0010_BizPlanPrice.cs:604 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fd83692 | FindButton | DMF0010_BizPlanPrice.cs:606 |  | FLAG | fromFindButton | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0010_BizPlanPrice.FindData

진입점: this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK)] / FindButton / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-435c4cc5 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:736 |  | DATA_OP | viewAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d27d5a1 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:738 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-628ebeb3 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:739 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ab4b47a | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:741 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-edef8935 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:752 | if (fromFindButton) | FLAG | fromFindButton | false | 화면 필드/플래그 변경 |  |  |  |
| AC-134cadec | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:754 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eca48d02 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:758 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-03fb6e16 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:767 | try | FLAG | gDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-fcebb862 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:783 | try ▸ if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e82d527 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:785 | try ▸ if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e0ca41a | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:792 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1bbf4ceb | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:794 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { //FP.Common.UIL.FilterDataSet Filter = new FP.Common.UIL.FilterDataSet(); //Filte… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc086c2c | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:808 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0010_GET_BIZ_PLAN_PRICE") ⇒ DM.DMF0010_GET_BIZ_PLAN_PRICE | 엔드포인트 요청 생성 |  |  |  |
| AC-8b636340 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:809 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0311f561 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:810 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-62cac319 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:811 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-65d3b09b | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:812 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a9dc9ca4 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:813 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7270fe3e | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:814 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-390e9ab6 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:815 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-60684bab | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:816 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-50d9b5ba | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:817 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-10384b0a | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:818 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68b012dd | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:819 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text | 행/컬럼 값 대입 |  |  |  |
| AC-295adc42 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:820 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-47fea2a2 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:821 | try ▸ lambda | DATA_OP | request.Parameters["p_end_cust_report_yn"] | sEndCustReportYN | 행/컬럼 값 대입 |  |  |  |
| AC-db02f533 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:823 | try ▸ lambda | DATA_OP | request.Parameters["p_START_STND_YM"] | usrMonthFrom.MonthText.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-c0d1aefe | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:824 | try ▸ lambda | DATA_OP | request.Parameters["p_END_STND_YM"] | usrMonthTo.MonthText.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-6e9ba1ca | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:826 | try ▸ lambda | DATA_OP | request.Parameters["p_month_info"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-90bd29fb | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:828 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb93cd24 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:829 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5ea812df | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:835 | try | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-f093061b | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:844 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cc66d8d | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:845 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-93024ae8 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:846 | try | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-09688f94 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:848 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0ce10e20 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:852 | try ▸ try ▸ if (siMain.ActiveSheet.Columns["CELL_PROD_SITE"].Width == 0) | GRID_SET | siMain.ActiveSheet.Columns["CELL_PROD_SITE"].Width | cell_prod_width | 그리드 속성/값 설정 |  |  |  |
| AC-0e31f6bd | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:859 | try ▸ if (bProduct) | MESSAGE | MessageHelper.GMessageBox | ("MSG00358") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e52e6adb | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:860 | try ▸ if (bProduct) | GRID_SET | siMain.ActiveSheet.ActiveColumnIndex | nProduct | 그리드 속성/값 설정 |  |  |  |
| AC-4fe37841 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:865 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b91a3db3 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:869 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-50004c55 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0010_BizPlanPrice.cs:870 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0010_BizPlanPrice.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d437791 | this.Load | DMF0010_BizPlanPrice.cs:316 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5af24a97 | this.Load | DMF0010_BizPlanPrice.cs:317 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0010_BizPlanPrice.GetComboData

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (columnName == "MEASURE")] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ if (columnName == "MEASURE")] / this.Load [if (columnName == "MEASURE")] / this.clbDivision.SelectedIndexChanged [if (columnName == "MEASURE")] / FindButton [try ▸ if (columnName == "MEASURE")] / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try ▸ if (columnName == "MEASURE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6bf26fd | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2079 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_CODE") ⇒ DM.DMF0009_GET_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-fd52848a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2080 |  | DATA_OP | request.Parameters["p_code_type"] | code | 행/컬럼 값 대입 |  |  |  |
| AC-12cf0803 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2081 |  | DATA_OP | request.Parameters["p_param1"] | (param1 == null ? "" : param1) | 행/컬럼 값 대입 |  |  |  |
| AC-4b8d080f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2082 |  | DATA_OP | request.Parameters["p_param2"] | (param2 == null ? "" : param2) | 행/컬럼 값 대입 |  |  |  |
| AC-33f52518 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2083 |  | DATA_OP | request.Parameters["p_param3"] | (param3 == null ? "" : param3) | 행/컬럼 값 대입 |  |  |  |
| AC-77c48f1f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2085 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba99d142 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2087 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0010_BizPlanPrice.GetItemType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-687f321c | (진입점 미연결) | DMF0010_BizPlanPrice.cs:2230 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-ed97d5af | (진입점 미연결) | DMF0010_BizPlanPrice.cs:2231 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-c62f730b | (진입점 미연결) | DMF0010_BizPlanPrice.cs:2232 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d09c2b9 | (진입점 미연결) | DMF0010_BizPlanPrice.cs:2234 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0010_BizPlanPrice.GetScmSiteInfobyDivision

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ea20992 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0010_BizPlanPrice.cs:2133 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9ffe7e37 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0010_BizPlanPrice.cs:2134 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-623a5a88 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0010_BizPlanPrice.cs:2135 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-231c7a1f | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0010_BizPlanPrice.cs:2136 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ed1694b8 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… | DMF0010_BizPlanPrice.cs:2139 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0010_BizPlanPrice.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-921e6168 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2147 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0009_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-9c2f7202 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2148 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b8f990c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2149 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-778ac568 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2150 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f0befc0b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2151 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0010" | 행/컬럼 값 대입 |  |  |  |
| AC-cbfc6317 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2152 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-631b5aa0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2153 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-cbc141ec | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2155 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dab388e2 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2158 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0010_BizPlanPrice.GetValueToString

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SALES_PLANT))] / EditButton [if (IsEditMode) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1615bca | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 2 | DMF0010_BizPlanPrice.cs:2116 | if (col == -1) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |
| AC-7247706e | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 2 | DMF0010_BizPlanPrice.cs:2118 | else of (col == -1) | RETURN | return spread.GetValue(row, col).ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-b97dd3ae | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 2 | DMF0010_BizPlanPrice.cs:2123 | if (col == -1) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |
| AC-bac1ed0a | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 2 | DMF0010_BizPlanPrice.cs:2125 | else of (col == -1) | RETURN | return spread.GetValue(row, col).ToString(); |  | 처리 중단/반환 |  |  |  |

## DMF0010_BizPlanPrice.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-607d97da | this.Load | DMF0010_BizPlanPrice.cs:381 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c083b1d7 | this.Load | DMF0010_BizPlanPrice.cs:382 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-2a6ea54e | this.Load | DMF0010_BizPlanPrice.cs:382 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6bd8ed17 | this.Load | DMF0010_BizPlanPrice.cs:384 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-00484e8c | this.Load | DMF0010_BizPlanPrice.cs:388 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e82e481 | this.Load | DMF0010_BizPlanPrice.cs:388 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90f02a6f | this.Load | DMF0010_BizPlanPrice.cs:389 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4126e001 | this.Load | DMF0010_BizPlanPrice.cs:396 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-ec392394 | this.Load | DMF0010_BizPlanPrice.cs:396 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fc55b57 | this.Load | DMF0010_BizPlanPrice.cs:397 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0b2ebb9b | this.Load | DMF0010_BizPlanPrice.cs:398 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-63747c67 | this.Load | DMF0010_BizPlanPrice.cs:406 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dd22f293 | this.Load | DMF0010_BizPlanPrice.cs:407 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c98b87f1 | this.Load | DMF0010_BizPlanPrice.cs:410 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b542660a | this.Load | DMF0010_BizPlanPrice.cs:411 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d2d804e1 | this.Load | DMF0010_BizPlanPrice.cs:417 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ead8de08 | this.Load | DMF0010_BizPlanPrice.cs:417 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4a843aa | this.Load | DMF0010_BizPlanPrice.cs:418 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8413fac6 | this.Load | DMF0010_BizPlanPrice.cs:419 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9fc0a224 | this.Load | DMF0010_BizPlanPrice.cs:420 | else of (sDivision == "40") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5fac53ba | this.Load | DMF0010_BizPlanPrice.cs:422 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-60ec531a | this.Load | DMF0010_BizPlanPrice.cs:426 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3ddec630 | this.Load | DMF0010_BizPlanPrice.cs:426 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4024567c | this.Load | DMF0010_BizPlanPrice.cs:427 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1474e01f | this.Load | DMF0010_BizPlanPrice.cs:429 |  | FLAG | dtItemType | Data.Common(Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 화면 필드/플래그 변경 |  |  |  |
| AC-4cfcbf04 | this.Load | DMF0010_BizPlanPrice.cs:429 |  | COMBO_DATA | Data.Common | (Data.Type.ItemType, false) ⇒ biz:CommonData.CommonDataList [code=ItemType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9adb969 | this.Load | DMF0010_BizPlanPrice.cs:430 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0010_BizPlanPrice.InitSpread

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-933d4792 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:482 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-fe1c2b76 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:483 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-1a966bd8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:486 |  | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.KWH), 0, 10, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e13f7ba8 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:488 |  | GRID_SET | spreadInfo.Sheet().ColumnHeader.RowCount | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-e88a9e46 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:496 | for (col <= col2) | GRID_STYLE | spreadInfo.Sheet().SetColumnVisible | (col, true) | 그리드 표시 설정 |  |  |  |
| AC-9989b9ea | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:503 | for (col < col2) | GRID_STYLE | spreadInfo.Sheet().SetColumnMerge | (col, FarPoint.Win.Spread.Model.MergePolicy.Always) | 그리드 표시 설정 |  |  |  |
| AC-4995b16f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:507 |  | FLAG | dsSpan | null | 화면 필드/플래그 변경 |  |  |  |
| AC-22fb1e5a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:508 |  | FLAG | dtSpan | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c2fb763f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:511 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE") ⇒ DM.DMF0009_GET_METAL_CURRENCY_PRICE_POPUP_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-a3aa3abf | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:512 |  | DATA_OP | request.Parameters["p_start_yyyymm"] | usrMonthFrom.MonthText.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-95475129 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:513 |  | DATA_OP | request.Parameters["p_end_yyyymm"] | usrMonthTo.MonthText.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-217db6ea | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:514 |  | FLAG | dsSpan | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-eaaf0fbb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:514 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6de150f6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:516 | if (dsSpan!=null && dsSpan.Tables!=null && dsSpan.Tables.Count > 0) | FLAG | dtSpan | dsSpan.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-6050b113 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:529 | for (i < dtSpan.Rows.Count) ▸ if (sDivision.Equals("40")) | GRID_INIT | spreadInfo.AddNumColumn | (dtSpan.Rows[i]["COL_HEADER"].ToString(), dtSpan.Rows[i]["COLUMN_NAME"].ToString(), FPMerg… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4eb44c5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:531 | for (i < dtSpan.Rows.Count) ▸ else of (sDivision.Equals("40")) | GRID_INIT | spreadInfo.AddNumColumn | (dtSpan.Rows[i]["COL_HEADER"].ToString(), dtSpan.Rows[i]["COLUMN_NAME"].ToString(), FPMerg… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d7b38b41 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:535 | for (i < dtSpan.Rows.Count) ▸ if (sSPAN_HEADER != dtSpan.Rows[i]["SPAN_HEADER"].ToString()) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spanStartCol, 1, spanColCount - 1, 25, sSPAN_HEADER, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6085cf61 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:542 | for (i < dtSpan.Rows.Count) ▸ if (i == dtSpan.Rows.Count - 1) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spanStartCol, 1, spanColCount, 25, sSPAN_HEADER, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0010_BizPlanPrice.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbe15a12 | SaveButton | DMF0010_BizPlanPrice.cs:686 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b22ab0c8 | SaveButton | DMF0010_BizPlanPrice.cs:688 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff1db451 | SaveButton | DMF0010_BizPlanPrice.cs:689 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0010_BizPlanPrice.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dd1205c | SaveButton | DMF0010_BizPlanPrice.cs:1070 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-db01454e | SaveButton | DMF0010_BizPlanPrice.cs:1072 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f49f8bc | SaveButton | DMF0010_BizPlanPrice.cs:1073 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbd50046 | SaveButton | DMF0010_BizPlanPrice.cs:1076 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) \|\| !siMain.SheetName.Equals(SpdSheet.shtMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ba715f3 | SaveButton | DMF0010_BizPlanPrice.cs:1165 | if (count > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ {?string.Empty} \| DM.DMF0010_SAVE_BIZ_PLAN_PRICE \| DM.DMF0010_SAVE_ESS_BIZ_PLA… | 엔드포인트 요청 생성 |  |  |  |
| AC-cade0e18 | SaveButton | DMF0010_BizPlanPrice.cs:1166 | if (count > 0) ▸ try | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5ac3cae6 | SaveButton | DMF0010_BizPlanPrice.cs:1169 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_SAVE_FLAG"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-6a9c09bb | SaveButton | DMF0010_BizPlanPrice.cs:1170 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_DIVISION_ID"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8c6e9a9f | SaveButton | DMF0010_BizPlanPrice.cs:1171 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_PROJECT_CODE"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-9b245ba8 | SaveButton | DMF0010_BizPlanPrice.cs:1172 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fa8d56e5 | SaveButton | DMF0010_BizPlanPrice.cs:1173 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_ITEM_ID"] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-45d2dcbd | SaveButton | DMF0010_BizPlanPrice.cs:1174 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_MEASURE"] | sMEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-ea6a3cb2 | SaveButton | DMF0010_BizPlanPrice.cs:1175 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_STND_YM"] | sSTND_YM | 행/컬럼 값 대입 |  |  |  |
| AC-fb00aa68 | SaveButton | DMF0010_BizPlanPrice.cs:1176 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_PRICE"] | sPRICE | 행/컬럼 값 대입 |  |  |  |
| AC-7c0c87dd | SaveButton | DMF0010_BizPlanPrice.cs:1178 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_START_STND_YM"] | this.StartYM | 행/컬럼 값 대입 |  |  |  |
| AC-6fd9102d | SaveButton | DMF0010_BizPlanPrice.cs:1179 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_END_STND_YM"] | this.EndYM | 행/컬럼 값 대입 |  |  |  |
| AC-bd71f90f | SaveButton | DMF0010_BizPlanPrice.cs:1180 | if (count > 0) ▸ try | DATA_OP | request.Parameters["p_CREATED_BY"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f326fbf6 | SaveButton | DMF0010_BizPlanPrice.cs:1182 | if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_CELL_PROD_SITE"] | sCELL_PROD_SITE | 행/컬럼 값 대입 |  |  |  |
| AC-41d9bb9d | SaveButton | DMF0010_BizPlanPrice.cs:1185 | if (count > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-38a9f4b5 | SaveButton | DMF0010_BizPlanPrice.cs:1190 | if (count > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "MSG00156") | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aed2668c | SaveButton | DMF0010_BizPlanPrice.cs:1194 | if (count > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToString() == "MSG00156") | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5dcac0d | SaveButton | DMF0010_BizPlanPrice.cs:1199 | if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6de40dfa | SaveButton | DMF0010_BizPlanPrice.cs:1200 | if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f31b3c16 | SaveButton | DMF0010_BizPlanPrice.cs:1207 | if (count > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-f0bbc756 | SaveButton | DMF0010_BizPlanPrice.cs:1216 | else of (count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0010_BizPlanPrice.SetBackColor

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / FindButton [try] / EditButton / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be2748d0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0010_BizPlanPrice.cs:1976 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-499b6bc5 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0010_BizPlanPrice.cs:1978 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55823390 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0010_BizPlanPrice.cs:1992 |  | CALL_EXT | siMain.SetColor2 | (0, col, row2, col, System.Drawing.Color.Black, System.Drawing.Color.White, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3858d7c4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0010_BizPlanPrice.cs:1997 | for (i <= row2) ▸ if (alternated) | CALL_EXT | siMain.SetColor2 | (i, col, i + (rowCount - 1), col, System.Drawing.Color.Black, System.Drawing.Color.FromArg… | ⚠ 의미 확인 필요 |  |  |  |
| AC-23e0fa2d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 4 | DMF0010_BizPlanPrice.cs:2001 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0010_BizPlanPrice.SetChangeControl

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48fe6ad2 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:336 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0cc72837 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:337 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8b4d2451 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:343 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cc51ac7f | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:343 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2a9457d7 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:348 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8bf0eacc | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:350 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a334602 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:350 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2b53acc8 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:355 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a9f7d24c | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:356 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-aab1be10 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:358 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d3e54c2 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:358 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-37778897 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:363 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ec644e7f | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:365 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-94a1a905 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:367 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-98a9a128 | this.clbDivision.SelectedIndexChanged | DMF0010_BizPlanPrice.cs:367 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0010_BizPlanPrice.SetComboCol

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (columnName == "MEASURE")] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ if (columnName == "MEASURE")] / this.Load [if (columnName == "MEASURE")] / this.clbDivision.SelectedIndexChanged [if (columnName == "MEASURE")] / FindButton [try ▸ if (columnName == "MEASURE")] / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try ▸ if (columnName == "MEASURE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e9ac804 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2097 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-08f74e0b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2098 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-f798d408 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2102 |  | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-8db22151 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2103 |  | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-3de23722 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2104 |  | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-8affa30c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2105 |  | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-2cd7485c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2109 |  | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |

## DMF0010_BizPlanPrice.SetComboColumn

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e16d413 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:2066 | else of (columnName == "MEASURE") | DATA_OP | dtTitle.Select | ($"COLUMN_NAME = '{columnName}'") | 데이터 객체 조작/조회 |  |  |  |

## DMF0010_BizPlanPrice.SetFroz

진입점: this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / FindButton [try] / EditButton / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0785c79 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 3 | DMF0010_BizPlanPrice.cs:887 |  | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | froz | 그리드 속성/값 설정 |  |  |  |
| AC-e34148f0 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 3 | DMF0010_BizPlanPrice.cs:888 |  | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |

## DMF0010_BizPlanPrice.SetLockForCell

진입점: this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.END_CUSTOMER40)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SALES_PLANT))] / EditButton [if (IsEditMode) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86c530c3 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0010_BizPlanPrice.cs:2008 |  | GRID_LOCK | spread.LockRange2 | (row, spread.GetColumnIndex(DefColumns.START_YM), row, spread.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-dac0b95b | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0010_BizPlanPrice.cs:2011 | if (!string.IsNullOrEmpty(sSTART_YM) && !string.IsNullOrEmpty(sEND_YM) && (sMEASURE.Equals("BasePriceChangeCur") \|\| sMEASURE…) | CALL_EXT | sEND_YM.CompareTo | (this.StartYM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4af8710e | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0010_BizPlanPrice.cs:2011 | if (!string.IsNullOrEmpty(sSTART_YM) && !string.IsNullOrEmpty(sEND_YM) && (sMEASURE.Equals("BasePriceChangeCur") \|\| sMEASURE…) | CALL_EXT | sSTART_YM.CompareTo | (this.EndYM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2527b735 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0010_BizPlanPrice.cs:2015 | if (!string.IsNullOrEmpty(sSTART_YM) && !string.IsNullOrEmpty(sEND_YM) && (sMEASURE.Equals("BasePriceChangeCur") \|\| sMEASURE…) ▸ else of (… | CALL_EXT | sSTART_YM.CompareTo | (this.StartYM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21acad7e | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0010_BizPlanPrice.cs:2016 | if (!string.IsNullOrEmpty(sSTART_YM) && !string.IsNullOrEmpty(sEND_YM) && (sMEASURE.Equals("BasePriceChangeCur") \|\| sMEASURE…) ▸ else of (… | CALL_EXT | sEND_YM.CompareTo | (this.EndYM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-56664d92 | this.spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetN… 외 1 | DMF0010_BizPlanPrice.cs:2017 | if (!string.IsNullOrEmpty(sSTART_YM) && !string.IsNullOrEmpty(sEND_YM) && (sMEASURE.Equals("BasePriceChangeCur") \|\| sMEASURE…) ▸ else of (… | GRID_LOCK | spread.LockRange2 | (row, spread.GetColumnIndex($"C{startYM}"), row, spread.GetColumnIndex($"C{endYM}"), false… | 그리드 편집 잠금 전환 |  |  |  |

## DMF0010_BizPlanPrice.SetSpreadHeaderSpan

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (count > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87b84129 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:556 |  | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(CAppSetting.StringAction), 2, 1, 30, "A", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbb5fe6d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:567 | for (index < dt.Rows.Count) ▸ else of (sLargeLabelName == string.Empty) ▸ if (sLargeLabelName != dr["LARGE_CLASS_LABEL_NAME"].ToString()) ▸ … | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 2, 1, 20, sLargeLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2be601cc | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:569 | for (index < dt.Rows.Count) ▸ else of (sLargeLabelName == string.Empty) ▸ if (sLargeLabelName != dr["LARGE_CLASS_LABEL_NAME"].ToString()) ▸ … | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 1, colSpanCount, 20, sLargeLabelName, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-068da6e7 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:575 | for (index < dt.Rows.Count) | GRID_SET | spread.Sheet().ColumnHeader.Cells[1, spread.GetColumnIndex(dr["COLUMN_NAME"].ToString())].… | dr["COLUMN_LABEL_NAME"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-fbaa7703 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:580 | if (colSpanCount == 1) | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 2, 1, 20, sLargeLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bf94611 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0010_BizPlanPrice.cs:582 | else of (colSpanCount == 1) | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 1, colSpanCount, 20, sLargeLabelName, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0010_BizPlanPrice.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c38d9e1 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1580 | if (e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b309cdeb | dsdm.Changed | DMF0010_BizPlanPrice.cs:1593 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.LIAB… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.LIABILITY_PERIOD), "") | 그리드 값 설정 |  |  |  |
| AC-a7d74473 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1603 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-b01894a0 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1619 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00177") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba002ac3 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1621 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-54261b7a | dsdm.Changed | DMF0010_BizPlanPrice.cs:1622 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CELL_PER_MODULE), "") | 그리드 값 설정 |  |  |  |
| AC-1b4e1cda | dsdm.Changed | DMF0010_BizPlanPrice.cs:1623 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-31b3e465 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1631 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), iModulePerCar) | 그리드 값 설정 |  |  |  |
| AC-44e813ad | dsdm.Changed | DMF0010_BizPlanPrice.cs:1640 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-6ddb98c8 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1647 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.MODULE_PER_CAR), "") | 그리드 값 설정 |  |  |  |
| AC-0285d460 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1707 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex(DefColumns.VMI_LT), vmi_lt) | 그리드 값 설정 |  |  |  |

## DMF0010_BizPlanPrice.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02b571fe | this.spdMain.CellClick | DMF0010_BizPlanPrice.cs:2257 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-debb3083 | this.spdMain.CellClick | DMF0010_BizPlanPrice.cs:2257 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5463800e | this.spdMain.CellClick | DMF0010_BizPlanPrice.cs:2258 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-30c3f46f | this.spdMain.CellClick | DMF0010_BizPlanPrice.cs:2269 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) ▸ if (e.Column == … | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-d537567b | this.spdMain.CellClick | DMF0010_BizPlanPrice.cs:2269 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) ▸ if (e.Column == … | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe5f8421 | this.spdMain.CellClick | DMF0010_BizPlanPrice.cs:2270 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.SALES_COMPANY)) ▸ if (e.Column == … | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0010_BizPlanPrice.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bb316da | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1420 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9e1331e | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1433 | if (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) != -1) | FLAG | division | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-bfcb37e7 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1435 | if (siMain.IsLock(siMain.SheetName)) ▸ if (IDX_PROJECT_CODE != -1) | FLAG | projectCode | siMain.GetText(e.Row, IDX_PROJECT_CODE) | 화면 필드/플래그 변경 |  |  |  |
| AC-f38f1fb7 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1437 | if (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnIndex(DefColumns.SCM_SITE_ID) != -1) | FLAG | site_ID | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID)) | 화면 필드/플래그 변경 |  |  |  |
| AC-37423a12 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1463 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-75257443 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1464 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-831377f6 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1465 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3421d412 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1466 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6610b593 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1478 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) ▸ if (popPr… | GRID_SET | siMain.SetText | (e.Row, IDX_PROJECT_CODE, sProject) | 그리드 값 설정 |  |  |  |
| AC-e69567a3 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1479 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) ▸ if (popPr… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-279fa8a3 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1480 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) ▸ if (popPr… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_STATUS), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-75d4382b | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1482 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) ▸ if (popPr… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-dc08791b | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1484 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (e.Column == IDX_PROJECT_CODE && siMain.GetText(e.Row, 0) == CAppSetting.StringI) ▸ if (popPr… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_OWNER), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-c6cfb56c | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1510 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | POPUP | new DM0002_ItembySmallDivPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c1097487 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1514 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | POPUP | popItem.Form_Load | (true, sDivision, "ALL", "ALL", "ALL", "ALL", sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7cf4edfd | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1515 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1bb83f62 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1516 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-45f113c4 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1529 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |
| AC-18769caa | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1531 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_NAME), sItemName) | 그리드 값 설정 |  |  |  |
| AC-ff70e95f | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1533 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | GRID_SET | siMain.SetText | (e.Row, IDX_ITEM_TYPE, sItemType) | 그리드 값 설정 |  |  |  |
| AC-f9d0f623 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1535 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), sNickName) | 그리드 값 설정 |  |  |  |
| AC-46bfe858 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1537 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_CLASS_NAME), sItemclassname) | 그리드 값 설정 |  |  |  |
| AC-980be47b | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1539 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.ITEM_I… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CURRENCY), sCurrency) | 그리드 값 설정 |  |  |  |
| AC-38cf6ddd | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1554 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | POPUP | new DMF000_OwnerSet_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-62f7fa9b | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1559 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | POPUP | popOwner.Form_Load | (sDivision, sUSER_ID) | 팝업 초기화(인자 전달) |  |  |  |
| AC-88654a95 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1560 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | UI_PROP | popOwner.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9062fb69 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1561 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | POPUP | popOwner.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b28a6537 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1565 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.OWNER), popOwner.userNameEn) | 그리드 값 설정 |  |  |  |
| AC-9e33d3ee | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1566 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID), popOwner.owner) | 그리드 값 설정 |  |  |  |
| AC-12d5f9a7 | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1568 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID2), popOwner.DEPT_ID) | 그리드 값 설정 |  |  |  |
| AC-6863fdba | this.spdMain.CellDoubleClick | DMF0010_BizPlanPrice.cs:1570 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.EditFlag)) == "Y" \|\| siMain.GetText… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), popOwner.DEPT_ID) | 그리드 값 설정 |  |  |  |

## DMF0010_BizPlanPrice.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92f921e9 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1392 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == IDX_PROJECT_CODE) | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-f495653b | dsdm.Changed | DMF0010_BizPlanPrice.cs:1392 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == IDX_PROJECT_CODE) | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e179490c | dsdm.Changed | DMF0010_BizPlanPrice.cs:1393 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == IDX_PROJECT_CODE) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d6ef56c5 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1396 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == IDX_PROJECT_CODE) | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-ba1dd7bb | dsdm.Changed | DMF0010_BizPlanPrice.cs:1396 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == IDX_PROJECT_CODE) | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-55232d15 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1397 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == IDX_PROJECT_CODE) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-11495099 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1406 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == IDX_PROJECT_CODE) ▸ if (e.Column… | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e8e036 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1406 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == IDX_PROJECT_CODE) ▸ if (e.Column… | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-944f15dd | dsdm.Changed | DMF0010_BizPlanPrice.cs:1407 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == IDX_PROJECT_CODE) ▸ if (e.Column… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7a99221e | dsdm.Changed | DMF0010_BizPlanPrice.cs:1410 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == IDX_PROJECT_CODE) ▸ if (e.Column… | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-325feef1 | dsdm.Changed | DMF0010_BizPlanPrice.cs:1410 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == IDX_PROJECT_CODE) ▸ if (e.Column… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43b96b5b | dsdm.Changed | DMF0010_BizPlanPrice.cs:1411 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == IDX_PROJECT_CODE) ▸ if (e.Column… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0010_BizPlanPrice.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8848fd2 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2301 | if (!IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65fcc461 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2323 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-d0bb0041 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2323 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f5a7404 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2324 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant.Rows[0]["CODE"].ToStrin… | 그리드 값 설정 |  |  |  |
| AC-e187da24 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2334 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-85b1cf34 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2334 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-beb476bf | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2335 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany.Rows[0]["CODE"].ToS… | 그리드 값 설정 |  |  |  |
| AC-2dda13f0 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2404 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c21218a9 | this.spdMain.ClipboardPasted | DMF0010_BizPlanPrice.cs:2407 | try | UI_PROP | this.Cursor | Cursors.Default | 속성 Cursor 설정 |  |  |  |

## DMF0010_BizPlanPrice.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cfec850 | this.spdMain.ClipboardPasting | DMF0010_BizPlanPrice.cs:2279 | if (!IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4490d8b3 | this.spdMain.ClipboardPasting | DMF0010_BizPlanPrice.cs:2280 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dcc7a28b | this.spdMain.ClipboardPasting | DMF0010_BizPlanPrice.cs:2284 | try | UI_PROP | this.Cursor | Cursors.WaitCursor | 속성 Cursor 설정 |  |  |  |

## DMF0010_BizPlanPrice.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad2ede33 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1259 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-3355f96a | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1259 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c29256e | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1260 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-96a95bda | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1263 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-1a489e19 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1263 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d8c90164 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1264 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-29f54f92 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1267 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-5595d17c | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1267 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-316e8b95 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1268 | if (siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e150ad16 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1274 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-099f4d79 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1274 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9cc59a53 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1275 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c32befec | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1278 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-1224e79d | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1278 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bca2e5b3 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1279 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-61cb3de3 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1286 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-e25c896e | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1286 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3b30957 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1287 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b610682a | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1301 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesSiteInfo | GetScmSiteInfobyDivision(sDivision, sScmSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae0410f5 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1309 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-63b32425 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1310 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-98b46e10 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1311 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), dtSalesSiteInfo.Rows[0][DefColumns.… | 그리드 값 설정 |  |  |  |
| AC-95f06290 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1312 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), dtSalesSiteInfo.Rows[0][DefC… | 그리드 값 설정 |  |  |  |
| AC-0714a659 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1320 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-fe66a87f | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1321 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SOLDTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-2b700034 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1322 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_CODE), "") | 그리드 값 설정 |  |  |  |
| AC-3c235fd4 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1323 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SHIPTO_DESCRIPTION), "") | 그리드 값 설정 |  |  |  |
| AC-e4f5bfb8 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1337 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-01450d16 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1337 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a82d6962 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1338 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_PLANT), dtSalesPlant.Rows[0]["CODE"].ToStri… | 그리드 값 설정 |  |  |  |
| AC-60a4dfe2 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1350 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-6f5045e4 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1350 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a00947e7 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1354 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SALES_COMPANY), dtSalesCompany.Rows[0]["CODE"].To… | 그리드 값 설정 |  |  |  |
| AC-7b994dfa | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1360 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9fcfc9c4 | this.spdMain.ComboSelChange | DMF0010_BizPlanPrice.cs:1362 | if (siMain.IsLock(siMain.SheetName) == false) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == s… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0010_BizPlanPrice.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0190bc29 | this.spdMain.TopChange | DMF0010_BizPlanPrice.cs:1970 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0010_BizPlanPrice.txtProject_KeyDown

진입점: this.txtProject.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08a5dcbd | this.txtProject.KeyDown | DMF0010_BizPlanPrice.cs:2163 | if (e.KeyCode != System.Windows.Forms.Keys.Enter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7e3f067 | this.txtProject.KeyDown | DMF0010_BizPlanPrice.cs:2184 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-be150027 | this.txtProject.KeyDown | DMF0010_BizPlanPrice.cs:2185 |  | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-3927c221 | this.txtProject.KeyDown | DMF0010_BizPlanPrice.cs:2186 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c940807a | this.txtProject.KeyDown | DMF0010_BizPlanPrice.cs:2187 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f711ba4e | this.txtProject.KeyDown | DMF0010_BizPlanPrice.cs:2199 | if (popProject.ProjectCode != null) | VALUE_SET | txtProject.ControlValues | sProjectName | 컨트롤 값 설정 |  |  |  |

