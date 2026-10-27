# AS-IS 액션 대조표 — DMF0009

> 원천: `Doc/asisfacts/screens/DMF0009/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 447행 · 메서드 43 · 종류 DATA_OP 91 · FLAG 77 · UI_PROP 45 · GRID_LOCK 38 · RETURN 30 · CALL_EXT 21 · POPUP 19 · MESSAGE 19 · GRID_SET 17 · UI_MISC 17 · COMBO_DATA 16 · ENDPOINT 13 · LIST_REBIND 11 · STATE 10 · GRID_INIT 10 · VALUE_SET 4 · VALUE_CLEAR 3 · GRID_STYLE 3 · THROW 2 · GRID_BIND 1 · ⚠ 의미 확인 필요 21


## DMF0009_BizPlanPrice_Input.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f2f050b | this.btnColumn.Click | DMF0009_BizPlanPrice_Input.cs:1826 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.DM0002_TitleSetForm_Popup | ("DMF0009", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-5a3abbd6 | this.btnColumn.Click | DMF0009_BizPlanPrice_Input.cs:1827 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f695f706 | this.btnColumn.Click | DMF0009_BizPlanPrice_Input.cs:1828 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0009_BizPlanPrice_Input.btnExchangeRate_Click

진입점: this.btnExchangeRate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4a2d164 | this.btnExchangeRate.Click | DMF0009_BizPlanPrice_Input.cs:1839 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00142") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2751c7a7 | this.btnExchangeRate.Click | DMF0009_BizPlanPrice_Input.cs:1840 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5acbb0e7 | this.btnExchangeRate.Click | DMF0009_BizPlanPrice_Input.cs:1843 |  | POPUP | new DMF009_MetalCurrencyPricePopUp | () | 팝업/폼 생성 |  |  |  |
| AC-23219562 | this.btnExchangeRate.Click | DMF0009_BizPlanPrice_Input.cs:1844 |  | CALL_EXT | popup.LoadData | (DateTime.Now.ToString("yyyy") + "01", DateTime.Now.AddYears(5).ToString("yyyy") + "12", c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-af5e9b6d | this.btnExchangeRate.Click | DMF0009_BizPlanPrice_Input.cs:1845 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-777ccf6b | this.btnExchangeRate.Click | DMF0009_BizPlanPrice_Input.cs:1846 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0009_BizPlanPrice_Input.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39f356c2 | this.btnItemId.Click | DMF0009_BizPlanPrice_Input.cs:1779 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-cb326d7e | this.btnItemId.Click | DMF0009_BizPlanPrice_Input.cs:1781 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-037c866d | this.btnItemId.Click | DMF0009_BizPlanPrice_Input.cs:1782 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a5ef4b43 | this.btnItemId.Click | DMF0009_BizPlanPrice_Input.cs:1783 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-13fbae58 | this.btnItemId.Click | DMF0009_BizPlanPrice_Input.cs:1789 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.btnModelChange_Click

진입점: this.btnModelChange.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2f9bab9 | this.btnModelChange.Click | DMF0009_BizPlanPrice_Input.cs:1795 |  | CALL_EXT | popup.LoadData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bc15293 | this.btnModelChange.Click | DMF0009_BizPlanPrice_Input.cs:1796 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3a01a5a6 | this.btnModelChange.Click | DMF0009_BizPlanPrice_Input.cs:1797 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0009_BizPlanPrice_Input.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-127b0e0d | this.btnOwner.Click | DMF0009_BizPlanPrice_Input.cs:1815 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6bad9df5 | this.btnOwner.Click | DMF0009_BizPlanPrice_Input.cs:1818 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-24b7cd35 | this.btnOwner.Click | DMF0009_BizPlanPrice_Input.cs:1819 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4fbe5b4c | this.btnOwner.Click | DMF0009_BizPlanPrice_Input.cs:1820 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d4aa20eb | this.btnOwner.Click | DMF0009_BizPlanPrice_Input.cs:1822 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7503c3e1 | this.btnProject.Click | DMF0009_BizPlanPrice_Input.cs:1716 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-7459535d | this.btnProject.Click | DMF0009_BizPlanPrice_Input.cs:1717 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1f5f90c2 | this.btnProject.Click | DMF0009_BizPlanPrice_Input.cs:1718 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-07eb6659 | this.btnProject.Click | DMF0009_BizPlanPrice_Input.cs:1719 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-72079068 | this.btnProject.Click | DMF0009_BizPlanPrice_Input.cs:1725 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8997205 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1594 |  | CALL_EXT | stopwatch.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-683b55ff | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1603 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-880ff433 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1611 | if (sDivision == "40") | FLAG | dtEndCustomer | dtEndCustomer40 | 화면 필드/플래그 변경 |  |  |  |
| AC-c6cb57d0 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1614 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c27e7e24 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1615 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7a22d5b5 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1623 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ffeef311 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1624 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ce1456f4 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1627 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ab0404d3 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1628 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dcde7b2c | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1639 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f3ff2ece | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1640 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-24b4a3d8 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1643 | else of (sDivision == "40") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d3e93c84 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1645 | else of (sDivision == "40") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d730cab1 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1647 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cc174742 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1656 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6844e464 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1658 |  | CALL_EXT | siMain.FilterRemove | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c0e299c | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1662 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9e79826c | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1663 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9add0860 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1664 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4dac299d | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1667 |  | CALL_EXT | stopwatch.Stop | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0009_BizPlanPrice_Input.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88824032 | this.clbEndCustomer.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1696 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f860532f | this.clbEndCustomer.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1696 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2dd2aad | this.clbEndCustomer.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1697 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0009_BizPlanPrice_Input.ClbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6103feb3 | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1678 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-bad1c010 | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1678 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e9a1d03c | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1682 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8c7abf49 | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1682 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-719d9743 | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1684 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0719095b | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1688 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-60426a14 | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1688 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-718e5ef5 | this.clbTeam.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:1689 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0009_BizPlanPrice_Input.ClearContentsForCell

진입점: this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.SheetName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d94a013b | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1951 | if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_METAL_LINK_YN == colIndex && metal_link_yn == "N") | CALL_EXT | spread.SetValue2 | (rowIndex, IDX_METAL_LINK_PERIOD, rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9af535e | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1953 | if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_METAL_LINK_YN == colIndex && metal_link_yn == "N") | CALL_EXT | spread.SetValue2 | (rowIndex, IDX_AL_KG_PER_BIZ_TYPE, rowIndex, IDX_LIOH_MIX_METAL_LINK_PERIOD, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9583739d | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1958 | if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_CURRENCY == colIndex && currency == "USD") | GRID_SET | spread.SetValue | (rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-4b06e214 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1959 | if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_CURRENCY == colIndex && currency == "USD") | GRID_SET | spread.SetValue | (rowIndex, IDX_CNTRC_EXCHANGE_PRICE, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-5e489c5e | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1968 | if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_METAL_LINK_PERIOD == colIndex) ▸ if (dtMetalLinkPeriod != null) | DATA_OP | dtMetalLinkPeriod.Select | (string.Format("CODE = '{0}'", metal_link_period)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6c0a96f | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1985 | if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_METAL_LINK_PERIOD == colIndex) ▸ else of (metal_link_period == "MIX") | CALL_EXT | spread.SetValue2 | (rowIndex, IDX_AL_MIX_METAL_LINK_PERIOD, rowIndex, IDX_LIOH_MIX_METAL_LINK_PERIOD, DBNull.… | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea2dee00 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1993 | else of (division.StartsWith("81") \|\| division == "40") ▸ if (division == "82") ▸ if (IDX_METAL_LINK_YN == colIndex && metal_link_yn == "N… | CALL_EXT | spread.SetValue2 | (rowIndex, IDX_METAL_LINK_PERIOD, rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f857cf8d | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1995 | else of (division.StartsWith("81") \|\| division == "40") ▸ if (division == "82") ▸ if (IDX_METAL_LINK_YN == colIndex && metal_link_yn == "N… | CALL_EXT | spread.SetValue2 | (rowIndex, IDX_CAP_PCT, rowIndex, IDX_CAP_PCT, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8eadc97 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:1996 | else of (division.StartsWith("81") \|\| division == "40") ▸ if (division == "82") ▸ if (IDX_METAL_LINK_YN == colIndex && metal_link_yn == "N… | CALL_EXT | spread.SetValue2 | (rowIndex, IDX_AL_USD_PER_KG, rowIndex, IDX_LIOH_USD_PER_KG, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82fd9017 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:2001 | else of (division.StartsWith("81") \|\| division == "40") ▸ if (division == "82") ▸ if (IDX_CURRENCY == colIndex && currency == "USD") | GRID_SET | spread.SetValue | (rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-3456146e | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:2002 | else of (division.StartsWith("81") \|\| division == "40") ▸ if (division == "82") ▸ if (IDX_CURRENCY == colIndex && currency == "USD") | GRID_SET | spread.SetValue | (rowIndex, IDX_CNTRC_EXCHANGE_PRICE, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-b6bf27a1 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… | DMF0009_BizPlanPrice_Input.cs:2008 | else of (division.StartsWith("81") \|\| division == "40") ▸ if (division == "82") ▸ if (IDX_METAL_LINK_PERIOD == colIndex) ▸ if (string.IsNu… | CALL_EXT | spread.SetValue2 | (rowIndex, IDX_AL_USD_PER_KG, rowIndex, IDX_LIOH_USD_PER_KG, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0009_BizPlanPrice_Input.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c44269a | this.Load | DMF0009_BizPlanPrice_Input.cs:483 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-526cf2ba | this.Load | DMF0009_BizPlanPrice_Input.cs:484 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-998fe0e2 | this.Load | DMF0009_BizPlanPrice_Input.cs:485 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0009_BizPlanPrice_Input.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3725e927 | this.Load | DMF0009_BizPlanPrice_Input.cs:471 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-4b1f404c | this.Load | DMF0009_BizPlanPrice_Input.cs:478 | else of (clbDivision.ControlValues.ToString() == "40") | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f767677f | DeleteButton | DMF0009_BizPlanPrice_Input.cs:604 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3e31342 | DeleteButton | DMF0009_BizPlanPrice_Input.cs:606 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6755d1cd | DeleteButton | DMF0009_BizPlanPrice_Input.cs:607 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60bc31eb | DeleteButton | DMF0009_BizPlanPrice_Input.cs:609 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0009_BizPlanPrice_Input.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fac95870 | Dispose | DMF0009_BizPlanPrice_Input.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0009_BizPlanPrice_Input.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64a03933 | EditButton | DMF0009_BizPlanPrice_Input.cs:613 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8bc31aa | EditButton | DMF0009_BizPlanPrice_Input.cs:615 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8fbe8d8a | EditButton | DMF0009_BizPlanPrice_Input.cs:616 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5cee9f4f | EditButton | DMF0009_BizPlanPrice_Input.cs:619 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4c20392 | EditButton | DMF0009_BizPlanPrice_Input.cs:620 | if (string.IsNullOrWhiteSpace(fps.Name) \|\| fps.Name != "spdMain") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4f53638 | EditButton | DMF0009_BizPlanPrice_Input.cs:622 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b28d70c0 | EditButton | DMF0009_BizPlanPrice_Input.cs:623 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-269539a0 | EditButton | DMF0009_BizPlanPrice_Input.cs:624 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-689edc9c | EditButton | DMF0009_BizPlanPrice_Input.cs:627 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-848069e1 | EditButton | DMF0009_BizPlanPrice_Input.cs:629 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-aa2e5f57 | EditButton | DMF0009_BizPlanPrice_Input.cs:636 | if (IsEditMode) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.Strin… | GRID_LOCK | siMain.LockRange2 | (iRow, IDX_DIVISION_ID, iRow, IDX_EDIT_FLAG, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e3ff3926 | EditButton | DMF0009_BizPlanPrice_Input.cs:643 | else of (IsEditMode) | GRID_LOCK | siMain.LockRange2 | (0, IDX_EDIT_FLAG + 1, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4dc88ab0 | EditButton | DMF0009_BizPlanPrice_Input.cs:647 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0009_BizPlanPrice_Input.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7da333d3 | ExcelButton | DMF0009_BizPlanPrice_Input.cs:670 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-5090cfb0 | ExcelButton | DMF0009_BizPlanPrice_Input.cs:671 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-68140572 | ExcelButton | DMF0009_BizPlanPrice_Input.cs:672 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-5206dbff | ExcelButton | DMF0009_BizPlanPrice_Input.cs:673 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-0d2ab6a7 | ExcelButton | DMF0009_BizPlanPrice_Input.cs:674 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-97e53ab8 | ExcelButton | DMF0009_BizPlanPrice_Input.cs:675 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-02974e9d | ExcelButton | DMF0009_BizPlanPrice_Input.cs:677 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-3842494a | ExcelButton | DMF0009_BizPlanPrice_Input.cs:678 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-f2de5a94 | ExcelButton | DMF0009_BizPlanPrice_Input.cs:680 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.0##;[Red]-#,##0.0##" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-8488192c | ExcelButton | DMF0009_BizPlanPrice_Input.cs:689 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4547bdab | ExcelButton | DMF0009_BizPlanPrice_Input.cs:694 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-a5a3c457 | ExcelButton | DMF0009_BizPlanPrice_Input.cs:698 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0009_BizPlanPrice_Input.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4be0348 | FindButton | DMF0009_BizPlanPrice_Input.cs:584 |  | DATA_OP | viewAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee02723a | FindButton | DMF0009_BizPlanPrice_Input.cs:586 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-99229ec7 | FindButton | DMF0009_BizPlanPrice_Input.cs:587 | if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea578593 | FindButton | DMF0009_BizPlanPrice_Input.cs:590 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00417") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0009_BizPlanPrice_Input.FindData

진입점: this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK)] / FindButton / SaveButton [try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7218d6b7 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:783 | try ▸ if (bInWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb651ff6 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:784 | try ▸ if (bInWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ba62671 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:787 | try | FLAG | bInWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1bb42e26 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:788 | try | DATA_OP | viewAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2947da6e | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:790 | try ▸ if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-74876b42 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:791 | try ▸ if (!viewAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-199175d9 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:794 | try | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-424590bc | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:806 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3c1d461a | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:807 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8d284e79 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:823 | try ▸ if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f37638a6 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:824 | try ▸ if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbf39510 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:832 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d9055fba | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:833 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2ae0af02 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:837 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_BIZ_PLAN_PRICE_INPUT") ⇒ DM.DMF0009_GET_BIZ_PLAN_PRICE_INPUT | 엔드포인트 요청 생성 |  |  |  |
| AC-a7d2b9b1 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:838 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-954c393f | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:839 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-42d6042c | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:840 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5da887b9 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:841 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-6c5034eb | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:842 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-51360bd3 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:843 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7da919d2 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:844 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-8d13c271 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:845 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-af74209e | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:846 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8b86a2e4 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:847 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1bf5774a | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:848 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text | 행/컬럼 값 대입 |  |  |  |
| AC-79118309 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:849 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-043f9573 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:850 | try ▸ lambda | DATA_OP | request.Parameters["p_end_cust_report_yn"] | sEndCustReportYN | 행/컬럼 값 대입 |  |  |  |
| AC-e2f19cb5 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:852 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17b71dde | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:853 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f26fc425 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:859 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7167f3dd | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:860 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aea65ce0 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:865 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4ef7ba38 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:884 | try ▸ if (colPROJECT_CODE != -1) | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(imageList1.Images[0]) | 속성 BackgroundImage 설정 |  |  |  |
| AC-1c0b6179 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:885 | try ▸ if (colPROJECT_CODE != -1) | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-ed691dd4 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:886 | try ▸ if (colPROJECT_CODE != -1) | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-28a45928 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:892 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (colPROJECT_CODE != -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, colPROJECT_CODE].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f423ca8e | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:905 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-950c910f | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:906 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b1855f1b | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:907 | try | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9cca2c30 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:908 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-04bfac0b | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:912 | try ▸ try ▸ if (siMain.ActiveSheet.Columns["CELL_PROD_SITE"].Width == 0) | GRID_SET | siMain.ActiveSheet.Columns["CELL_PROD_SITE"].Width | cell_prod_width | 그리드 속성/값 설정 |  |  |  |
| AC-2f404294 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:919 | try ▸ if (bProduct) | MESSAGE | MessageHelper.GMessageBox | ("MSG00358") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1531f755 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:920 | try ▸ if (bProduct) | GRID_SET | siMain.ActiveSheet.ActiveColumnIndex | nProduct | 그리드 속성/값 설정 |  |  |  |
| AC-bfc8a51e | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:926 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-18abe4bc | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 2 | DMF0009_BizPlanPrice_Input.cs:930 | finally | FLAG | bInWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0009_BizPlanPrice_Input.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acd1c0dd | this.Load | DMF0009_BizPlanPrice_Input.cs:352 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5554b102 | this.Load | DMF0009_BizPlanPrice_Input.cs:353 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0009_BizPlanPrice_Input.GetComboData

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefColumns.METAL_LINK_START_MONTH)) ▸ if (dtMetalLinkPeriod != null&& !string.IsNullOrWhiteSpace(metal_link_period)) ▸ if (row != null)] / this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.SheetName)) ▸ if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_METAL_LINK_PERIOD == colIndex) ▸ if (dtMetalLinkPeriod != null) ▸ if (row != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.Selecte…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50a13f63 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 7 | DMF0009_BizPlanPrice_Input.cs:2073 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_CODE") ⇒ DM.DMF0009_GET_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-6db7b70d | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 7 | DMF0009_BizPlanPrice_Input.cs:2074 |  | DATA_OP | request.Parameters["p_code_type"] | code | 행/컬럼 값 대입 |  |  |  |
| AC-af30b62d | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 7 | DMF0009_BizPlanPrice_Input.cs:2075 |  | DATA_OP | request.Parameters["p_param1"] | (param1 == null ? "" : param1) | 행/컬럼 값 대입 |  |  |  |
| AC-64f9db8c | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 7 | DMF0009_BizPlanPrice_Input.cs:2076 |  | DATA_OP | request.Parameters["p_param2"] | (param2 == null ? "" : param2) | 행/컬럼 값 대입 |  |  |  |
| AC-958a3759 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 7 | DMF0009_BizPlanPrice_Input.cs:2077 |  | DATA_OP | request.Parameters["p_param3"] | (param3 == null ? "" : param3) | 행/컬럼 값 대입 |  |  |  |
| AC-4972e53c | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 7 | DMF0009_BizPlanPrice_Input.cs:2079 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aee6a633 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 7 | DMF0009_BizPlanPrice_Input.cs:2081 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0009_BizPlanPrice_Input.GetItemType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edca4dc0 | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2180 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-71a60e04 | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2181 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-f8e8613c | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2182 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d06d9f1b | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2184 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0009_BizPlanPrice_Input.GetScmSiteInfobyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-728fb31c | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2148 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-2abcaed7 | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2149 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7a641a31 | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2150 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-ab1d9786 | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2151 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-98ddc2b4 | (진입점 미연결) | DMF0009_BizPlanPrice_Input.cs:2154 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0009_BizPlanPrice_Input.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61798611 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2161 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0009_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-ca457ebf | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2162 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-37cd5678 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2163 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4d418eb6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2164 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-670953bb | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2165 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0009" | 행/컬럼 값 대입 |  |  |  |
| AC-bf9419d4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2166 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-6968984b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2167 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-e90754c0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2169 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4de08a31 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2172 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0009_BizPlanPrice_Input.GetValueToString

진입점: this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount)] / this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.SheetName)) ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40"))] / EditButton [if (IsEditMode) ▸ for (iRow <= siMain.GetMaxRowIndex())] / SaveButton [try ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31e3ac6b | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 3 | DMF0009_BizPlanPrice_Input.cs:2131 | if (col == -1) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |
| AC-08f1ff80 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 3 | DMF0009_BizPlanPrice_Input.cs:2133 | else of (col == -1) | RETURN | return spread.GetValue(row, col).ToString(); |  | 처리 중단/반환 |  |  |  |
| AC-098ef5e0 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 3 | DMF0009_BizPlanPrice_Input.cs:2138 | if (col == -1) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |
| AC-37d6bbed | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 3 | DMF0009_BizPlanPrice_Input.cs:2140 | else of (col == -1) | RETURN | return spread.GetValue(row, col).ToString(); |  | 처리 중단/반환 |  |  |  |

## DMF0009_BizPlanPrice_Input.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63594722 | this.Load | DMF0009_BizPlanPrice_Input.cs:418 |  | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-10e46207 | this.Load | DMF0009_BizPlanPrice_Input.cs:419 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-628bbdb7 | this.Load | DMF0009_BizPlanPrice_Input.cs:419 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8faf67e9 | this.Load | DMF0009_BizPlanPrice_Input.cs:421 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-52cfb7f0 | this.Load | DMF0009_BizPlanPrice_Input.cs:425 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-31324fa1 | this.Load | DMF0009_BizPlanPrice_Input.cs:425 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cbae2e85 | this.Load | DMF0009_BizPlanPrice_Input.cs:426 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a181aa60 | this.Load | DMF0009_BizPlanPrice_Input.cs:433 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-45af5180 | this.Load | DMF0009_BizPlanPrice_Input.cs:433 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40849dc0 | this.Load | DMF0009_BizPlanPrice_Input.cs:434 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8517cefb | this.Load | DMF0009_BizPlanPrice_Input.cs:435 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1a37cfc8 | this.Load | DMF0009_BizPlanPrice_Input.cs:443 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7bcb4608 | this.Load | DMF0009_BizPlanPrice_Input.cs:444 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": case "SCM PI ADMIN": | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e794056f | this.Load | DMF0009_BizPlanPrice_Input.cs:447 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-be8d2d78 | this.Load | DMF0009_BizPlanPrice_Input.cs:448 | if (sDivision == "40") ▸ switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1c2f11de | this.Load | DMF0009_BizPlanPrice_Input.cs:454 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c224ffe1 | this.Load | DMF0009_BizPlanPrice_Input.cs:454 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1db1fd85 | this.Load | DMF0009_BizPlanPrice_Input.cs:455 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c91e10df | this.Load | DMF0009_BizPlanPrice_Input.cs:456 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3b329c43 | this.Load | DMF0009_BizPlanPrice_Input.cs:457 | else of (sDivision == "40") | UI_PROP | layoutControlItem11.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a3a05cd4 | this.Load | DMF0009_BizPlanPrice_Input.cs:459 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3e1f4de6 | this.Load | DMF0009_BizPlanPrice_Input.cs:463 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9864131a | this.Load | DMF0009_BizPlanPrice_Input.cs:463 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f41249d4 | this.Load | DMF0009_BizPlanPrice_Input.cs:464 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-148aa21c | this.Load | DMF0009_BizPlanPrice_Input.cs:466 |  | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0cf66c8 | this.Load | DMF0009_BizPlanPrice_Input.cs:467 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0009_BizPlanPrice_Input.InitSpread

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c612f324 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:493 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-f24e47fa | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:494 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-3ff84943 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:497 |  | GRID_SET | spreadInfo.Sheet().ColumnHeader.RowCount | 2 | 그리드 속성/값 설정 |  |  |  |
| AC-3363478c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:516 | for (col <= col2) | GRID_STYLE | spreadInfo.Sheet().SetColumnVisible | (col, true) | 그리드 표시 설정 |  |  |  |
| AC-5050d380 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:529 | for (col <= spreadInfo.GetMaxColumnIndex()) ▸ if (col < col1 \|\| col >= col2) | GRID_STYLE | spreadInfo.Sheet().SetColumnMerge | (col, FarPoint.Win.Spread.Model.MergePolicy.None) | 그리드 표시 설정 |  |  |  |
| AC-9b21205e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:531 | for (col <= spreadInfo.GetMaxColumnIndex()) ▸ else of (col < col1 \|\| col >= col2) | GRID_STYLE | spreadInfo.Sheet().SetColumnMerge | (col, FarPoint.Win.Spread.Model.MergePolicy.Always) | 그리드 표시 설정 |  |  |  |
| AC-edd91228 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:537 | if (clbDivision.ControlValues.Equals("40")) | CALL_EXT | spreadInfo.SetDecimal | (IDX_BASE_PRICE, IDX_BASE_PRICE, 3, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0009_BizPlanPrice_Input.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b3bb50d | InsertButton | DMF0009_BizPlanPrice_Input.cs:596 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-94aa517e | InsertButton | DMF0009_BizPlanPrice_Input.cs:598 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-889e0c12 | InsertButton | DMF0009_BizPlanPrice_Input.cs:599 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0009_BizPlanPrice_Input.LoadColumnIndex

진입점: this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.SheetName))] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / EditButton / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93d6b469 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:255 |  | FLAG | IDX_DIVISION_ID | spcold.GetColumnIndex(DefColumns.DIVISION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-134495d7 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:256 |  | FLAG | IDX_USER_ID | spcold.GetColumnIndex(DefColumns.USER_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4dda8cb | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:257 |  | FLAG | IDX_SCM_SITE_ID | spcold.GetColumnIndex(DefColumns.SCM_SITE_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-53e8b8b9 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:258 |  | FLAG | IDX_PROJECT_CODE | spcold.GetColumnIndex(DefColumns.PROJECT_CODE) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b651e02 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:259 |  | FLAG | IDX_ITEM_TYPE | spcold.GetColumnIndex(DefColumns.ITEM_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-0fe8cd68 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:260 |  | FLAG | IDX_ITEM_ID | spcold.GetColumnIndex(DefColumns.ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-62bd4006 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:261 |  | FLAG | IDX_SALES_COMPANY | spcold.GetColumnIndex(DefColumns.SALES_COMPANY) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3a36406 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:262 |  | FLAG | IDX_SALES_PLANT | spcold.GetColumnIndex(DefColumns.SALES_PLANT) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f61b46d | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:263 |  | FLAG | IDX_EDIT_FLAG | spcold.GetColumnIndex(DefColumns.EDIT_FLAG) | 화면 필드/플래그 변경 |  |  |  |
| AC-87384fad | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:266 |  | FLAG | IDX_CELL_TYPE_81 | spcold.GetColumnIndex(DefColumns.CELL_TYPE_81) | 화면 필드/플래그 변경 |  |  |  |
| AC-91e06158 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:267 |  | FLAG | IDX_CELL_TYPE_82 | spcold.GetColumnIndex(DefColumns.CELL_TYPE_82) | 화면 필드/플래그 변경 |  |  |  |
| AC-e588293c | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:270 |  | FLAG | IDX_DEPT_ID2 | spcold.GetColumnIndex(DefColumns.DEPT_ID2) | 화면 필드/플래그 변경 |  |  |  |
| AC-38bfe844 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:271 |  | FLAG | IDX_END_CUSTOMER40 | spcold.GetColumnIndex(DefColumns.END_CUSTOMER40) | 화면 필드/플래그 변경 |  |  |  |
| AC-fac98503 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:272 |  | FLAG | IDX_SOLDTO_CUSTOMER | spcold.GetColumnIndex(DefColumns.SOLDTO_CUSTOMER) | 화면 필드/플래그 변경 |  |  |  |
| AC-58a78bf4 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:273 |  | FLAG | IDX_SCM_SITE_ID40 | spcold.GetColumnIndex(DefColumns.SCM_SITE_ID40) | 화면 필드/플래그 변경 |  |  |  |
| AC-bcf957af | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:275 |  | FLAG | IDX_CELL_PROD_SITE | spcold.GetColumnIndex(DefColumns.CELL_PROD_SITE) | 화면 필드/플래그 변경 |  |  |  |
| AC-b829041f | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:278 |  | FLAG | IDX_BASE_PRICE | spcold.GetColumnIndex(DefColumns.BASE_PRICE) | 화면 필드/플래그 변경 |  |  |  |
| AC-d80a8278 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:279 |  | FLAG | IDX_METAL_LINK_YN | spcold.GetColumnIndex(DefColumns.METAL_LINK_YN) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e21b08d | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:280 |  | FLAG | IDX_CURRENCY | spcold.GetColumnIndex(DefColumns.CURRENCY) | 화면 필드/플래그 변경 |  |  |  |
| AC-78a2c7de | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:281 |  | FLAG | IDX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-2d719af3 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:282 |  | FLAG | IDX_METAL_LINK_START_MONTH | spcold.GetColumnIndex(DefColumns.METAL_LINK_START_MONTH) | 화면 필드/플래그 변경 |  |  |  |
| AC-38b1a0f2 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:283 |  | FLAG | IDX_METAL_LINK_MTD | spcold.GetColumnIndex(DefColumns.METAL_LINK_MTD) | 화면 필드/플래그 변경 |  |  |  |
| AC-36122e89 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:285 |  | FLAG | IDX_START_YM | spcold.GetColumnIndex(DefColumns.START_YM) | 화면 필드/플래그 변경 |  |  |  |
| AC-a21c8710 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:286 |  | FLAG | IDX_END_YM | spcold.GetColumnIndex(DefColumns.END_YM) | 화면 필드/플래그 변경 |  |  |  |
| AC-943b5667 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:288 |  | FLAG | IDX_AL_KG_PER_BIZ_TYPE | spcold.GetColumnIndex(DefColumns.AL_KG_PER_BIZ_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-db4e3dd8 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:289 |  | FLAG | IDX_CU_KG_PER_BIZ_TYPE | spcold.GetColumnIndex(DefColumns.CU_KG_PER_BIZ_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1e0c02b | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:290 |  | FLAG | IDX_MN_KG_PER_BIZ_TYPE | spcold.GetColumnIndex(DefColumns.MN_KG_PER_BIZ_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-72e76afd | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:291 |  | FLAG | IDX_NI_KG_PER_BIZ_TYPE | spcold.GetColumnIndex(DefColumns.NI_KG_PER_BIZ_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f603d55 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:292 |  | FLAG | IDX_CO_KG_PER_BIZ_TYPE | spcold.GetColumnIndex(DefColumns.CO_KG_PER_BIZ_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c4ecc7d | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:293 |  | FLAG | IDX_LI2CO3_KG_PER_BIZ_TYPE | spcold.GetColumnIndex(DefColumns.LI2CO3_KG_PER_BIZ_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-56a71035 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:294 |  | FLAG | IDX_LIOH_KG_PER_BIZ_TYPE | spcold.GetColumnIndex(DefColumns.LIOH_KG_PER_BIZ_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-93ecfc29 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:295 |  | FLAG | IDX_AL_USD_PER_KG | spcold.GetColumnIndex(DefColumns.AL_USD_PER_KG) | 화면 필드/플래그 변경 |  |  |  |
| AC-a8f6a59a | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:296 |  | FLAG | IDX_CU_USD_PER_KG | spcold.GetColumnIndex(DefColumns.CU_USD_PER_KG) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d731264 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:297 |  | FLAG | IDX_MN_USD_PER_KG | spcold.GetColumnIndex(DefColumns.MN_USD_PER_KG) | 화면 필드/플래그 변경 |  |  |  |
| AC-bab376d7 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:298 |  | FLAG | IDX_NI_USD_PER_KG | spcold.GetColumnIndex(DefColumns.NI_USD_PER_KG) | 화면 필드/플래그 변경 |  |  |  |
| AC-d899a701 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:299 |  | FLAG | IDX_CO_USD_PER_KG | spcold.GetColumnIndex(DefColumns.CO_USD_PER_KG) | 화면 필드/플래그 변경 |  |  |  |
| AC-60785257 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:300 |  | FLAG | IDX_LI2CO3_USD_PER_KG | spcold.GetColumnIndex(DefColumns.LI2CO3_USD_PER_KG) | 화면 필드/플래그 변경 |  |  |  |
| AC-c11cd643 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:301 |  | FLAG | IDX_LIOH_USD_PER_KG | spcold.GetColumnIndex(DefColumns.LIOH_USD_PER_KG) | 화면 필드/플래그 변경 |  |  |  |
| AC-e408e8f3 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:302 |  | FLAG | IDX_CNTRC_EXCHANGE_PRICE | spcold.GetColumnIndex(DefColumns.CNTRC_EXCHANGE_PRICE) | 화면 필드/플래그 변경 |  |  |  |
| AC-40334612 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:303 |  | FLAG | IDX_AL_MIX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.AL_MIX_METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-d686f67f | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:304 |  | FLAG | IDX_CU_MIX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.CU_MIX_METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d2c52fd | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:305 |  | FLAG | IDX_MN_MIX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.MN_MIX_METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-753efc8a | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:306 |  | FLAG | IDX_NI_MIX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.NI_MIX_METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-1ef99406 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:307 |  | FLAG | IDX_CO_MIX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.CO_MIX_METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1e2a911 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:308 |  | FLAG | IDX_LI2CO3_MIX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.LI2CO3_MIX_METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a27b53f | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:309 |  | FLAG | IDX_LIOH_MIX_METAL_LINK_PERIOD | spcold.GetColumnIndex(DefColumns.LIOH_MIX_METAL_LINK_PERIOD) | 화면 필드/플래그 변경 |  |  |  |
| AC-881be7ba | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:320 |  | FLAG | IDX_BASE_PRICE_PER_EA | spcold.GetColumnIndex(DefColumns.BASE_PRICE_PER_EA) | 화면 필드/플래그 변경 |  |  |  |
| AC-13fb1d35 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:323 |  | FLAG | IDX_CELL_NICK | spcold.GetColumnIndex(DefColumns.CELL_NICK) | 화면 필드/플래그 변경 |  |  |  |
| AC-a3164a4f | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:324 |  | FLAG | IDX_CELL_QTY | spcold.GetColumnIndex(DefColumns.CELL_QTY) | 화면 필드/플래그 변경 |  |  |  |
| AC-abc467f1 | this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.Sheet… 외 7 | DMF0009_BizPlanPrice_Input.cs:332 |  | FLAG | IDX_CAP_PCT | spcold.GetColumnIndex(DefColumns.CAP_PCT) | 화면 필드/플래그 변경 |  |  |  |

## DMF0009_BizPlanPrice_Input.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55bfdf3f | SaveButton | DMF0009_BizPlanPrice_Input.cs:651 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-65f1b025 | SaveButton | DMF0009_BizPlanPrice_Input.cs:653 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd97e32c | SaveButton | DMF0009_BizPlanPrice_Input.cs:654 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0009_BizPlanPrice_Input.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e8d817d | SaveButton | DMF0009_BizPlanPrice_Input.cs:944 |  | DATA_OP | editAuth.Contains | (UserInfoContext.Current["NowGroupID"]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a601a5a1 | SaveButton | DMF0009_BizPlanPrice_Input.cs:946 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-638a82a4 | SaveButton | DMF0009_BizPlanPrice_Input.cs:947 | if (!editAuth.Contains(UserInfoContext.Current["NowGroupID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c06ee5e | SaveButton | DMF0009_BizPlanPrice_Input.cs:950 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) \|\| !siMain.SheetName.Equals(SpdSheet.shtMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3188ecdb | SaveButton | DMF0009_BizPlanPrice_Input.cs:954 | if (bInWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17a31fab | SaveButton | DMF0009_BizPlanPrice_Input.cs:955 | if (bInWork) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-dad038ce | SaveButton | DMF0009_BizPlanPrice_Input.cs:960 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55d1b41d | SaveButton | DMF0009_BizPlanPrice_Input.cs:1294 | try ▸ if (count > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ {?string.Empty} \| DM.DMF0009_SAVE_BIZ_PLAN_PRICE_INPUT \| DM.DMF0009_SAVE_ESS_B… | 엔드포인트 요청 생성 |  |  |  |
| AC-58aeab80 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1295 | try ▸ if (count > 0) ▸ try | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-aa499c91 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1298 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_SAVE_FLAG"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-87804af2 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1299 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_DIVISION_ID"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-283e37fa | SaveButton | DMF0009_BizPlanPrice_Input.cs:1300 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_PROJECT_CODE"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-89589588 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1301 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0362ba88 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1302 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_ITEM_ID"] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-887b8037 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1305 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_BASE_PRICE"] | sBASE_PRICE | 행/컬럼 값 대입 |  |  |  |
| AC-e4b1b0dd | SaveButton | DMF0009_BizPlanPrice_Input.cs:1308 | try ▸ if (count > 0) ▸ try ▸ else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivis… | DATA_OP | request.Parameters["p_BASE_PRICE_PER_EA"] | sBASE_PRICE_PER_EA | 행/컬럼 값 대입 |  |  |  |
| AC-85aa0760 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1309 | try ▸ if (count > 0) ▸ try ▸ else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivis… | DATA_OP | request.Parameters["p_CELL_NICK"] | sCELL_NICK | 행/컬럼 값 대입 |  |  |  |
| AC-71c2c27c | SaveButton | DMF0009_BizPlanPrice_Input.cs:1310 | try ▸ if (count > 0) ▸ try ▸ else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivis… | DATA_OP | request.Parameters["p_CELL_QTY"] | sCELL_QTY | 행/컬럼 값 대입 |  |  |  |
| AC-1c90601c | SaveButton | DMF0009_BizPlanPrice_Input.cs:1311 | try ▸ if (count > 0) ▸ try ▸ else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivis… | DATA_OP | request.Parameters["p_CAP_PCT"] | sCAP_PCT | 행/컬럼 값 대입 |  |  |  |
| AC-347dd7ad | SaveButton | DMF0009_BizPlanPrice_Input.cs:1314 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_METAL_LINK_YN"] | sMETAL_LINK_YN | 행/컬럼 값 대입 |  |  |  |
| AC-ff6f4cbb | SaveButton | DMF0009_BizPlanPrice_Input.cs:1315 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_CURRENCY"] | sCURRENCY | 행/컬럼 값 대입 |  |  |  |
| AC-f03726c5 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1316 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_METAL_LINK_PERIOD"] | sMETAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-926bee1e | SaveButton | DMF0009_BizPlanPrice_Input.cs:1317 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_METAL_LINK_START_MONTH"] | sMETAL_LINK_START_MONTH | 행/컬럼 값 대입 |  |  |  |
| AC-a165f0da | SaveButton | DMF0009_BizPlanPrice_Input.cs:1318 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_METAL_LINK_MTD"] | sMETAL_LINK_MTD | 행/컬럼 값 대입 |  |  |  |
| AC-e7f91d07 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1319 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_START_YM"] | sSTART_YM | 행/컬럼 값 대입 |  |  |  |
| AC-dd7e32b4 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1320 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_END_YM"] | sEND_YM | 행/컬럼 값 대입 |  |  |  |
| AC-378c5a21 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1322 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_AL_USD_PER_KG"] | sAL_USD_PER_KG | 행/컬럼 값 대입 |  |  |  |
| AC-576d0f0e | SaveButton | DMF0009_BizPlanPrice_Input.cs:1323 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_CU_USD_PER_KG"] | sCU_USD_PER_KG | 행/컬럼 값 대입 |  |  |  |
| AC-ebf98a0c | SaveButton | DMF0009_BizPlanPrice_Input.cs:1324 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_MN_USD_PER_KG"] | sMN_USD_PER_KG | 행/컬럼 값 대입 |  |  |  |
| AC-f5cc84d3 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1325 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_NI_USD_PER_KG"] | sNI_USD_PER_KG | 행/컬럼 값 대입 |  |  |  |
| AC-d6e0c761 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1326 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_CO_USD_PER_KG"] | sCO_USD_PER_KG | 행/컬럼 값 대입 |  |  |  |
| AC-fb6acd62 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1327 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_LI2CO3_USD_PER_KG"] | sLI2CO3_USD_PER_KG | 행/컬럼 값 대입 |  |  |  |
| AC-7df2f7ad | SaveButton | DMF0009_BizPlanPrice_Input.cs:1328 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_LIOH_USD_PER_KG"] | sLIOH_USD_PER_KG | 행/컬럼 값 대입 |  |  |  |
| AC-16af9211 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1329 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_CNTRC_EXCHANGE_PRICE"] | sCNTRC_EXCHANGE_PRICE | 행/컬럼 값 대입 |  |  |  |
| AC-c8d11283 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1333 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_AL_KG_PER_BIZ_TYPE"] | sAL_KG_PER_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-525c667d | SaveButton | DMF0009_BizPlanPrice_Input.cs:1334 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_CU_KG_PER_BIZ_TYPE"] | sCU_KG_PER_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-c749b91d | SaveButton | DMF0009_BizPlanPrice_Input.cs:1335 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_MN_KG_PER_BIZ_TYPE"] | sMN_KG_PER_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-d4a2216d | SaveButton | DMF0009_BizPlanPrice_Input.cs:1336 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_NI_KG_PER_BIZ_TYPE"] | sNI_KG_PER_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-96a9ecc4 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1337 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_CO_KG_PER_BIZ_TYPE"] | sCO_KG_PER_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-4cc83473 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1338 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_LI2CO3_KG_PER_BIZ_TYPE"] | sLI2CO3_KG_PER_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-eb7a399b | SaveButton | DMF0009_BizPlanPrice_Input.cs:1339 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_LIOH_KG_PER_BIZ_TYPE"] | sLIOH_KG_PER_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-00b8e5bf | SaveButton | DMF0009_BizPlanPrice_Input.cs:1341 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_AL_MIX_METAL_LINK_PERIOD"] | sAL_MIX_METAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-f4f8d6d3 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1342 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_CU_MIX_METAL_LINK_PERIOD"] | sCU_MIX_METAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-8e8ddb5d | SaveButton | DMF0009_BizPlanPrice_Input.cs:1343 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_MN_MIX_METAL_LINK_PERIOD"] | sMN_MIX_METAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-f8790843 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1344 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_NI_MIX_METAL_LINK_PERIOD"] | sNI_MIX_METAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-a0a74878 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1345 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_CO_MIX_METAL_LINK_PERIOD"] | sCO_MIX_METAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-286d07a4 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1346 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_LI2CO3_MIX_METAL_LINK_PERIOD"] | sLI2CO3_MIX_METAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-f1d7c17c | SaveButton | DMF0009_BizPlanPrice_Input.cs:1347 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_LIOH_MIX_METAL_LINK_PERIOD"] | sLIOH_MIX_METAL_LINK_PERIOD | 행/컬럼 값 대입 |  |  |  |
| AC-6675a16d | SaveButton | DMF0009_BizPlanPrice_Input.cs:1356 | try ▸ if (count > 0) ▸ try ▸ if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | DATA_OP | request.Parameters["p_CELL_PROD_SITE"] | sCELL_PROD_SITE | 행/컬럼 값 대입 |  |  |  |
| AC-5bc597b9 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1362 | try ▸ if (count > 0) ▸ try | DATA_OP | request.Parameters["p_CREATED_BY"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5313d7a6 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1365 | try ▸ if (count > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-011e11e1 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1372 | try ▸ if (count > 0) ▸ try ▸ if (response !=null && response.DataSet.Tables.Count != 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString… | MESSAGE | MessageHelper.GMessageBox | ("MSG00156") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3263ed4e | SaveButton | DMF0009_BizPlanPrice_Input.cs:1373 | try ▸ if (count > 0) ▸ try ▸ if (response !=null && response.DataSet.Tables.Count != 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString… | FLAG | bInWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5a7a83f1 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1374 | try ▸ if (count > 0) ▸ try ▸ if (response !=null && response.DataSet.Tables.Count != 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ad7549d | SaveButton | DMF0009_BizPlanPrice_Input.cs:1381 | try ▸ if (count > 0) ▸ try ▸ if (response !=null && response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToS… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02d53774 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1382 | try ▸ if (count > 0) ▸ try ▸ if (response !=null && response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToS… | FLAG | bInWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c6664ec5 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1383 | try ▸ if (count > 0) ▸ try ▸ if (response !=null && response.DataSet.Tables.Count != 0) ▸ else of (response.DataSet.Tables[0].Rows[0][0].ToS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c506c1e6 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1388 | try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c9e9a89 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1389 | try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-71eba072 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1398 | try ▸ if (count > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-3a97ff77 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1408 | try ▸ else of (count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c3fb7b2 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1414 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-55f21a34 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1419 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b2b26de0 | SaveButton | DMF0009_BizPlanPrice_Input.cs:1420 | finally | FLAG | bInWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0009_BizPlanPrice_Input.SetChangeControl

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2acd9d3 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:372 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-75e82c81 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:373 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4721fc37 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:379 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2afb9ea1 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:379 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-37b6df04 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:384 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8610146e | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:386 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-368dce48 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:386 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2f9216c8 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:391 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-448e36a7 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:392 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-da88aa9f | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:394 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c835bc7 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:394 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-07a1b47e | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:399 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-de4d1df0 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:401 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-88f7a162 | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:403 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-29d6be1b | this.clbDivision.SelectedIndexChanged | DMF0009_BizPlanPrice_Input.cs:403 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0009_BizPlanPrice_Input.SetComboCell

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefColumns.METAL_LINK_START_MONTH)) ▸ if (dtMetalLinkPeriod != null&& !string.IsNullOrWhiteSpace(metal_link_period)) ▸ if (row != null) ▸ if (dt != null)] / this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.SheetName)) ▸ if (division.StartsWith("81") \|\| division == "40") ▸ if (IDX_METAL_LINK_PERIOD == colIndex) ▸ if (dtMetalLinkPeriod != null) ▸ if (row != null) ▸ if (dt != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffe6a368 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | DMF0009_BizPlanPrice_Input.cs:2112 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a6661c6 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | DMF0009_BizPlanPrice_Input.cs:2113 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-31b21d68 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | DMF0009_BizPlanPrice_Input.cs:2117 |  | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-59b69e96 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | DMF0009_BizPlanPrice_Input.cs:2118 |  | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-23014aed | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | DMF0009_BizPlanPrice_Input.cs:2119 |  | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-8a3234d5 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | DMF0009_BizPlanPrice_Input.cs:2120 |  | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-a5f34ff3 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | DMF0009_BizPlanPrice_Input.cs:2125 |  | GRID_SET | siMain.ActiveSheet.Cells[row, columnIndex].CellType | cb | 그리드 속성/값 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.SetComboCol

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8eb10656 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2090 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-16f5db99 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2091 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-83f326c0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2095 |  | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-34b34904 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2096 |  | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-4fb7ff56 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2097 |  | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-f53817b9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2098 |  | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-ba63364a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2102 |  | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.SetComboColumn

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b27552d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2017 |  | DATA_OP | dtTitle.Select | ($"COLUMN_NAME = 'CURRENCY'") | 데이터 객체 조작/조회 |  |  |  |
| AC-3665b851 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2057 |  | DATA_OP | dtTitle.Select | ($"COLUMN_NAME = '{columnName}'") | 데이터 객체 조작/조회 |  |  |  |
| AC-f04df2bd | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:2062 | if (cell_commbo_data_type == "DMF_BIZ_PLAN_METAL_LINK_PERIOD") | FLAG | dtMetalLinkPeriod | dt | 화면 필드/플래그 변경 |  |  |  |

## DMF0009_BizPlanPrice_Input.SetFroz

진입점: this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / FindButton [try] / EditButton / SaveButton [try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db7138b0 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 3 | DMF0009_BizPlanPrice_Input.cs:936 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db4bb5d0 | this.btnModelChange.Click [if (popup.DialogResult == DialogR… 외 3 | DMF0009_BizPlanPrice_Input.cs:939 | if (froz > 0) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | froz | 그리드 속성/값 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.SetLockForCell

진입점: this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG) == CAppSetting.StringY)] / this.spdMain.ComboSelChange [if (!siMain.IsLock(siMain.SheetName))] / EditButton [if (IsEditMode) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.StringY)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fb353ef | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1858 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | GRID_LOCK | spread.LockRange2 | (row, IDX_BASE_PRICE, row, IDX_LIOH_MIX_METAL_LINK_PERIOD, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-85f6e608 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1860 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | GRID_LOCK | spread.LockRange2 | (row, IDX_BASE_PRICE, row, IDX_BASE_PRICE, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-3a53d434 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1861 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_YN, row, IDX_METAL_LINK_YN, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-a1244ab7 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1862 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | GRID_LOCK | spread.LockRange2 | (row, IDX_CURRENCY, row, IDX_CURRENCY, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-cf333819 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1863 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | GRID_LOCK | spread.LockRange2 | (row, IDX_START_YM, row, IDX_START_YM, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-428edd02 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1864 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) | GRID_LOCK | spread.LockRange2 | (row, IDX_END_YM, row, IDX_END_YM, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-b749e75e | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1868 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (this.GetValueToString(spread, row, DefColu… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_PERIOD, row, IDX_METAL_LINK_PERIOD, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-7ce6e30d | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1869 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (this.GetValueToString(spread, row, DefColu… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_START_MONTH, row, IDX_METAL_LINK_START_MONTH, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-75cef93f | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1878 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (this.GetValueToString(spread, row, DefColu… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_MTD, row, IDX_METAL_LINK_MTD, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-dc1b6ecc | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1879 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (this.GetValueToString(spread, row, DefColu… | GRID_LOCK | spread.LockRange2 | (row, IDX_CNTRC_EXCHANGE_PRICE, row, IDX_CNTRC_EXCHANGE_PRICE, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-8ace1968 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1884 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ else of (this.GetValueToString(spread, row, De… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_PERIOD, row, IDX_METAL_LINK_PERIOD, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-bc047e89 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1885 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ else of (this.GetValueToString(spread, row, De… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_START_MONTH, row, IDX_METAL_LINK_START_MONTH, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-d118471c | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1890 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (!string.IsNullOrEmpty(this.GetValueToStrin… | GRID_LOCK | spread.LockRange2 | (row, IDX_AL_KG_PER_BIZ_TYPE, row, IDX_LIOH_KG_PER_BIZ_TYPE, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-7d5bfd86 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1891 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (!string.IsNullOrEmpty(this.GetValueToStrin… | GRID_LOCK | spread.LockRange2 | (row, IDX_AL_USD_PER_KG, row, IDX_LIOH_USD_PER_KG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-543af1b9 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1896 | if (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (this.GetValueToString(spread, row, DefColu… | GRID_LOCK | spread.LockRange2 | (row, IDX_AL_MIX_METAL_LINK_PERIOD, row, IDX_LIOH_MIX_METAL_LINK_PERIOD, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e8bee8eb | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1901 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_BASE_PRICE_PER_EA, row, IDX_CNTRC_EXCHANGE_PRICE, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-fb4926fe | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1903 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_BASE_PRICE_PER_EA, row, IDX_BASE_PRICE_PER_EA, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-522a5e29 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1904 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_YN, row, IDX_METAL_LINK_YN, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-2560d8af | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1905 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_CURRENCY, row, IDX_CURRENCY, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e6a17fee | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1906 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_CELL_NICK, row, IDX_CELL_NICK, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-41016b37 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1907 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_CELL_QTY, row, IDX_CELL_QTY, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-1b537c35 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1908 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_START_YM, row, IDX_START_YM, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-8d577516 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1909 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_END_YM, row, IDX_END_YM, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-995dae4b | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1913 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_PERIOD, row, IDX_METAL_LINK_PERIOD, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-2867e57e | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1914 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_START_MONTH, row, IDX_METAL_LINK_START_MONTH, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5b2035e3 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1915 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_CAP_PCT, row, IDX_CAP_PCT, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-6601af1d | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1923 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_MTD, row, IDX_METAL_LINK_MTD, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-28743829 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1924 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_CNTRC_EXCHANGE_PRICE, row, IDX_CNTRC_EXCHANGE_PRICE, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ae031fa4 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1929 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_PERIOD, row, IDX_METAL_LINK_PERIOD, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-cb5cf988 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1930 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_METAL_LINK_START_MONTH, row, IDX_METAL_LINK_START_MONTH, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5c364c81 | this.spdMain.ClipboardPasted [if (cbSmart.Checked == true) ▸… 외 2 | DMF0009_BizPlanPrice_Input.cs:1935 | else of (clbDivision.ControlValues.StartsWith("81") \|\| clbDivision.ControlValues.Equals("40")) ▸ if (clbDivision.ControlValues.Equals("82"… | GRID_LOCK | spread.LockRange2 | (row, IDX_AL_USD_PER_KG, row, IDX_LIOH_USD_PER_KG, false) | 그리드 편집 잠금 전환 |  |  |  |

## DMF0009_BizPlanPrice_Input.SetSpreadHeaderSpan

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnModelChange.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.Load / this.clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [try ▸ if (count > 0) ▸ try ▸ else of (response !=null && response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b9dbf8b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:547 |  | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(CAppSetting.StringAction), 2, 1, 45, "A", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-067bc482 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:558 | for (index < dt.Rows.Count) ▸ else of (sLargeLabelName == string.Empty) ▸ if (sLargeLabelName != dr["LARGE_CLASS_LABEL_NAME"].ToString()) ▸ … | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 2, 1, 20, sLargeLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6e87bb9 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:560 | for (index < dt.Rows.Count) ▸ else of (sLargeLabelName == string.Empty) ▸ if (sLargeLabelName != dr["LARGE_CLASS_LABEL_NAME"].ToString()) ▸ … | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 1, colSpanCount, 20, sLargeLabelName, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f88fb73a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:566 | for (index < dt.Rows.Count) | GRID_SET | spread.Sheet().ColumnHeader.Cells[1, spread.GetColumnIndex(dr["COLUMN_NAME"].ToString())].… | dr["COLUMN_LABEL_NAME"].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-b81c222b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:571 | if (colSpanCount == 1) | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 2, 1, 20, sLargeLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1931e657 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 5 | DMF0009_BizPlanPrice_Input.cs:573 | else of (colSpanCount == 1) | GRID_INIT | spread.ColumnHeaderSpan | (0, spread.GetColumnIndex(sColumnName), 1, colSpanCount, 20, sLargeLabelName, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0009_BizPlanPrice_Input.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90968b44 | this.spdMain.CellClick | DMF0009_BizPlanPrice_Input.cs:2199 | if (e.Column == siMain.GetColumnIndex(DefColumns.METAL_LINK_START_MONTH)) ▸ if (dtMetalLinkPeriod != null&& !string.IsNullOrWhiteSpace(metal… | DATA_OP | dtMetalLinkPeriod.Select | (string.Format("CODE = '{0}'", metal_link_period)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec3fd93 | this.spdMain.CellClick | DMF0009_BizPlanPrice_Input.cs:2213 | if (e.Column == siMain.GetColumnIndex(DefColumns.METAL_LINK_START_MONTH)) ▸ else of (dtMetalLinkPeriod != null&& !string.IsNullOrWhiteSpace(… | UI_PROP | codeName.TableName | "empty" | 속성 TableName 설정 |  |  |  |
| AC-8844a092 | this.spdMain.CellClick | DMF0009_BizPlanPrice_Input.cs:2214 | if (e.Column == siMain.GetColumnIndex(DefColumns.METAL_LINK_START_MONTH)) ▸ else of (dtMetalLinkPeriod != null&& !string.IsNullOrWhiteSpace(… | DATA_OP | codeName.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa5a71b4 | this.spdMain.CellClick | DMF0009_BizPlanPrice_Input.cs:2215 | if (e.Column == siMain.GetColumnIndex(DefColumns.METAL_LINK_START_MONTH)) ▸ else of (dtMetalLinkPeriod != null&& !string.IsNullOrWhiteSpace(… | DATA_OP | codeName.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0009_BizPlanPrice_Input.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8c415b4 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1474 | if (!IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93f595bf | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1495 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.StringY) … | FLAG | dtSalesPlant | Data.Common(Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-f68b2bc1 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1495 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.StringY) … | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, sSalesCompany, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8b28b7a | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1496 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.StringY) … | GRID_SET | siMain.SetValue | (iRow, IDX_SALES_PLANT, dtSalesPlant.Rows[0]["CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-580114b1 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1506 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.StringY) … | FLAG | dtSalesCompany | Data.Common(Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 화면 필드/플래그 변경 |  |  |  |
| AC-477fc612 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1506 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.StringY) … | COMBO_DATA | Data.Common | (Data.Type.SalesCompany, false, sSalesPlant, sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=SalesCompany] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9342482 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1507 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ if (this.GetValueToString(siMain, iRow, DefColumns.EDIT_FLAG) == CAppSetting.StringY) … | GRID_SET | siMain.SetValue | (iRow, IDX_SALES_COMPANY, dtSalesCompany.Rows[0]["CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-aef45b2e | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1518 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | GRID_LOCK | siMain.LockRange2 | (rowIndex, IDX_DIVISION_ID, rowIndex, IDX_EDIT_FLAG, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-aae2d304 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1531 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | CALL_EXT | siMain.SetValue2 | (rowIndex, IDX_METAL_LINK_PERIOD, rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf3200c9 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1533 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | CALL_EXT | siMain.SetValue2 | (rowIndex, IDX_AL_KG_PER_BIZ_TYPE, rowIndex, IDX_LIOH_MIX_METAL_LINK_PERIOD, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cbba0c2a | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1538 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | GRID_SET | siMain.SetValue | (rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-fc2575e6 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1539 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | GRID_SET | siMain.SetValue | (rowIndex, IDX_CNTRC_EXCHANGE_PRICE, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-2b1ddf07 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1547 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | CALL_EXT | siMain.SetValue2 | (rowIndex, IDX_AL_MIX_METAL_LINK_PERIOD, rowIndex, IDX_LIOH_MIX_METAL_LINK_PERIOD, DBNull.… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6330b6c | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1554 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | CALL_EXT | siMain.SetValue2 | (rowIndex, IDX_METAL_LINK_PERIOD, rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fea52852 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1556 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | CALL_EXT | siMain.SetValue2 | (rowIndex, IDX_CAP_PCT, rowIndex, IDX_CAP_PCT, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8237a91 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1557 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | CALL_EXT | siMain.SetValue2 | (rowIndex, IDX_AL_USD_PER_KG, rowIndex, IDX_LIOH_USD_PER_KG, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58fc3575 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1562 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | GRID_SET | siMain.SetValue | (rowIndex, IDX_METAL_LINK_MTD, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-6318270a | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1563 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | GRID_SET | siMain.SetValue | (rowIndex, IDX_CNTRC_EXCHANGE_PRICE, DBNull.Value) | 그리드 값 설정 |  |  |  |
| AC-313492c2 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1567 | if (cbSmart.Checked == true) ▸ for (rowIndex <= siMain.GetMaxRowIndex()) ▸ if (this.GetValueToString(siMain, rowIndex, DefColumns.EDIT_FLAG)… | CALL_EXT | siMain.SetValue2 | (rowIndex, IDX_AL_USD_PER_KG, rowIndex, IDX_LIOH_USD_PER_KG, DBNull.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b63c16e4 | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1578 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3f24a9da | this.spdMain.ClipboardPasted | DMF0009_BizPlanPrice_Input.cs:1581 | try | UI_PROP | this.Cursor | Cursors.Default | 속성 Cursor 설정 |  |  |  |

## DMF0009_BizPlanPrice_Input.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02af8376 | this.spdMain.ClipboardPasting | DMF0009_BizPlanPrice_Input.cs:1452 | if (!IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-205c31dc | this.spdMain.ClipboardPasting | DMF0009_BizPlanPrice_Input.cs:1453 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e9a9c813 | this.spdMain.ClipboardPasting | DMF0009_BizPlanPrice_Input.cs:1457 | try | UI_PROP | this.Cursor | Cursors.WaitCursor | 속성 Cursor 설정 |  |  |  |
| AC-5305db02 | this.spdMain.ClipboardPasting | DMF0009_BizPlanPrice_Input.cs:1467 | if (cbSmart.Checked == true) | GRID_LOCK | siMain.LockRange2 | (0, IDX_EDIT_FLAG + 1, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금 전환 |  |  |  |

## DMF0009_BizPlanPrice_Input.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fcfe58e | this.spdMain.ComboSelChange | DMF0009_BizPlanPrice_Input.cs:1434 | if (!siMain.IsLock(siMain.SheetName)) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-59be05cb | this.spdMain.ComboSelChange | DMF0009_BizPlanPrice_Input.cs:1438 | if (!siMain.IsLock(siMain.SheetName)) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0009_BizPlanPrice_Input.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6de89084 | this.spdMain.TopChange | DMF0009_BizPlanPrice_Input.cs:1444 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0009_BizPlanPrice_Input.txtProject_KeyDown

진입점: this.txtProject.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35db901c | this.txtProject.KeyDown | DMF0009_BizPlanPrice_Input.cs:1730 | if (e.KeyCode != System.Windows.Forms.Keys.Enter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7206acf9 | this.txtProject.KeyDown | DMF0009_BizPlanPrice_Input.cs:1751 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-3ae9c15b | this.txtProject.KeyDown | DMF0009_BizPlanPrice_Input.cs:1752 |  | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-197a2464 | this.txtProject.KeyDown | DMF0009_BizPlanPrice_Input.cs:1753 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-090399fa | this.txtProject.KeyDown | DMF0009_BizPlanPrice_Input.cs:1754 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3778aa85 | this.txtProject.KeyDown | DMF0009_BizPlanPrice_Input.cs:1766 | if (popProject.ProjectCode != null) | VALUE_SET | txtProject.ControlValues | sProjectName | 컨트롤 값 설정 |  |  |  |

