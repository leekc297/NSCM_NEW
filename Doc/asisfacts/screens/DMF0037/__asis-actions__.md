# AS-IS 액션 대조표 — DMF0037

> 원천: `Doc/asisfacts/screens/DMF0037/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 342행 · 메서드 48 · 종류 DATA_OP 55 · FLAG 47 · RETURN 43 · ENDPOINT 33 · LIST_REBIND 22 · COMBO_DATA 20 · POPUP 18 · CALL_EXT 16 · GRID_INIT 13 · STATE 12 · GRID_SET 11 · UI_PROP 10 · UI_MISC 10 · VALUE_SET 7 · MESSAGE 7 · VALUE_CLEAR 6 · THROW 3 · GRID_STYLE 2 · LIST_BIND 2 · GRID_COMBO 2 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 16


## DMF0037_SalesPlanReport.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f8346a6 | this.btnColumn.Click | DMF0037_SalesPlanReport.cs:1026 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF0037", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-7e1a61ec | this.btnColumn.Click | DMF0037_SalesPlanReport.cs:1027 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-424db974 | this.btnColumn.Click | DMF0037_SalesPlanReport.cs:1028 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0037_SalesPlanReport.btnItemId_Click

진입점: this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95d5d468 | this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Form… 외 1 | DMF0037_SalesPlanReport.cs:1015 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-750c8dc4 | this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Form… 외 1 | DMF0037_SalesPlanReport.cs:1017 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-6b3b05e5 | this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Form… 외 1 | DMF0037_SalesPlanReport.cs:1018 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0333d080 | this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Form… 외 1 | DMF0037_SalesPlanReport.cs:1019 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ebc3dc84 | this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Form… 외 1 | DMF0037_SalesPlanReport.cs:1021 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0037_SalesPlanReport.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1204d035 | this.btnMeasure.Click | DMF0037_SalesPlanReport.cs:1038 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF0037", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-d3ad36bb | this.btnMeasure.Click | DMF0037_SalesPlanReport.cs:1039 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0d2f4719 | this.btnMeasure.Click | DMF0037_SalesPlanReport.cs:1040 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0037_SalesPlanReport.btnProject_Click

진입점: this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc0cd0e6 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 1 | DMF0037_SalesPlanReport.cs:997 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-bf5669c7 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 1 | DMF0037_SalesPlanReport.cs:998 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1008f39d | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 1 | DMF0037_SalesPlanReport.cs:999 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f87e87f4 | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 1 | DMF0037_SalesPlanReport.cs:1000 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2f3d403f | this.txtProject.KeyDown [if (e.KeyCode == System.Windows.For… 외 1 | DMF0037_SalesPlanReport.cs:1002 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0037_SalesPlanReport.btnVersion_Click

진입점: this.txtVersion.KeyDown / this.btnVersion.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0dc4bcd6 | this.txtVersion.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1674 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b589e73b | this.txtVersion.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1675 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2f81f75e | this.txtVersion.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1676 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5aa2e048 | this.txtVersion.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1677 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4b9da8da | this.txtVersion.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1681 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-657b00cc | this.txtVersion.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1682 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0037_SalesPlanReport.btnVersionB_Click

진입점: this.txtVersionB.KeyDown / this.btnVersionB.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d62f7ec | this.txtVersionB.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1698 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6d4ad035 | this.txtVersionB.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1699 |  | POPUP | popVersion.Form_Load | (false, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dabce69b | this.txtVersionB.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1700 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7fc26e1b | this.txtVersionB.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1701 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1d226756 | this.txtVersionB.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1705 | if (popVersion.sVersions != "") | VALUE_SET | txtVersionB.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-18bb2a4c | this.txtVersionB.KeyDown 외 1 | DMF0037_SalesPlanReport.cs:1706 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0037_SalesPlanReport.cboKRW_SelectedIndexChanged

진입점: cboKRW.SelectedIndexChanged / this.cboKRW.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22b6f3ec | cboKRW.SelectedIndexChanged 외 1 | DMF0037_SalesPlanReport.cs:1373 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.cboLOC_SelectedIndexChanged

진입점: cboLOC.SelectedIndexChanged / this.cboLOC.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2741aca | cboLOC.SelectedIndexChanged 외 1 | DMF0037_SalesPlanReport.cs:1394 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea32db0f | this.cboQTY.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1404 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.cboUSD_SelectedIndexChanged

진입점: cboUSD.SelectedIndexChanged / this.cboUSD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81f62f7a | cboUSD.SelectedIndexChanged 외 1 | DMF0037_SalesPlanReport.cs:1384 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0f48e21 | this.clbCustomer.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1362 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69164c0a | this.clbCustomer.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1364 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fa4d696 | this.clbCustomer.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1366 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-13117fbb | this.clbCustomer.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1366 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f2855832 | this.clbCustomer.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1367 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0037_SalesPlanReport.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-672c8a9b | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:781 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afdb0e98 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:784 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-92f497d2 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:788 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-05d71422 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:788 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89398f40 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:789 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6d8ee3f2 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:795 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-525d9806 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:795 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70b71268 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:796 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-667e12fd | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:796 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-568637d7 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:797 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b257f46c | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:800 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-db8e3a52 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:801 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-70bb09e3 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:802 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-896ff87a | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:806 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-93421235 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:806 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d19e9ee | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:807 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | GetBizTypebyDivisionAsync(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-8dd02f26 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:808 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8ec3faa6 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:811 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7594c94f | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:812 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-92fa3d6b | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:813 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-09878c00 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:816 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e85c3098 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:820 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-2df33d6f | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:820 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce61df89 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:821 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-83391c72 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:823 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-b216c342 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:823 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29c35308 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:824 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a9795131 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:832 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-dd2705c8 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:833 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a6120f05 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:834 | try | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0c0ff841 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:835 | try | VALUE_CLEAR | this.txtVersionB.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d68f26bc | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:841 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-15e330da | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:842 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-c865c1f3 | clbDivision.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:846 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0037_SalesPlanReport.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30c1c0b0 | clbPlantSite.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:867 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bdee772 | clbPlantSite.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:869 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.ClbSalesSite_SelectedIndexChanged

진입점: clbSalesSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c77b13de | clbSalesSite.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:856 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12fa3fc6 | clbSalesSite.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:858 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6623b381 | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1611 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-605d28ec | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1613 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c76a8e6a | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1618 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b5165c19 | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1618 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-559bfc54 | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1619 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-995e4b7c | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1623 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-a144c59e | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1623 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92c81f8c | this.clbTeam.SelectedIndexChanged | DMF0037_SalesPlanReport.cs:1624 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0037_SalesPlanReport.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41a83aa2 | this.Load | DMF0037_SalesPlanReport.cs:312 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-84ba9a08 | this.Load | DMF0037_SalesPlanReport.cs:313 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdf69965 | this.Load | DMF0037_SalesPlanReport.cs:314 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0037_SalesPlanReport.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e149833 | this.Load | DMF0037_SalesPlanReport.cs:283 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-a0d0d937 | this.Load | DMF0037_SalesPlanReport.cs:287 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-1d94bdbb | this.Load | DMF0037_SalesPlanReport.cs:288 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DMF0037_SalesPlanReport.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bb6d13f | Dispose | DMF0037_SalesPlanReport.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0037_SalesPlanReport.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff5a5f30 | EditButton | DMF0037_SalesPlanReport.cs:513 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67e4946e | EditButton | DMF0037_SalesPlanReport.cs:514 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f359f6fe | FindButton | DMF0037_SalesPlanReport.cs:529 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b5c4c699 | FindButton | DMF0037_SalesPlanReport.cs:536 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c30ae2c2 | FindButton | DMF0037_SalesPlanReport.cs:537 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cfa71a1 | FindButton | DMF0037_SalesPlanReport.cs:540 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bbd4202d | FindButton | DMF0037_SalesPlanReport.cs:542 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-75919a34 | FindButton | DMF0037_SalesPlanReport.cs:542 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9b697c3 | FindButton | DMF0037_SalesPlanReport.cs:552 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6f636f6 | FindButton | DMF0037_SalesPlanReport.cs:553 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-457dcbbe | FindButton | DMF0037_SalesPlanReport.cs:559 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d2e186fd | FindButton | DMF0037_SalesPlanReport.cs:561 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-032454ad | FindButton | DMF0037_SalesPlanReport.cs:563 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd26c48a | FindButton | DMF0037_SalesPlanReport.cs:567 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34b3d77a | FindButton | DMF0037_SalesPlanReport.cs:569 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5520c69 | FindButton | DMF0037_SalesPlanReport.cs:590 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b13a2304 | FindButton | DMF0037_SalesPlanReport.cs:591 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-946e7e30 | FindButton | DMF0037_SalesPlanReport.cs:595 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d8ac41cd | FindButton | DMF0037_SalesPlanReport.cs:605 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-df721dc5 | FindButton | DMF0037_SalesPlanReport.cs:606 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc9e164d | FindButton | DMF0037_SalesPlanReport.cs:611 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0037_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT") ⇒ DM.DMF0037_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-18948e45 | FindButton | DMF0037_SalesPlanReport.cs:612 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-189a6f55 | FindButton | DMF0037_SalesPlanReport.cs:614 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-61bb7c7f | FindButton | DMF0037_SalesPlanReport.cs:615 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-88391573 | FindButton | DMF0037_SalesPlanReport.cs:616 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-25f2e3b4 | FindButton | DMF0037_SalesPlanReport.cs:617 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e35f5a31 | FindButton | DMF0037_SalesPlanReport.cs:618 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-2db1972d | FindButton | DMF0037_SalesPlanReport.cs:619 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-31b1621a | FindButton | DMF0037_SalesPlanReport.cs:620 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-4365a3a7 | FindButton | DMF0037_SalesPlanReport.cs:623 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-f2452723 | FindButton | DMF0037_SalesPlanReport.cs:624 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-064efdb8 | FindButton | DMF0037_SalesPlanReport.cs:625 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-763573c1 | FindButton | DMF0037_SalesPlanReport.cs:626 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8490ae6f | FindButton | DMF0037_SalesPlanReport.cs:627 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-057ddaa4 | FindButton | DMF0037_SalesPlanReport.cs:628 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-26dbc1ab | FindButton | DMF0037_SalesPlanReport.cs:629 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2c6c5d64 | FindButton | DMF0037_SalesPlanReport.cs:630 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-b3d3b793 | FindButton | DMF0037_SalesPlanReport.cs:631 | try ▸ lambda | DATA_OP | request.Parameters["p_version_typeB"] | p_version_typeB | 행/컬럼 값 대입 |  |  |  |
| AC-d99a770b | FindButton | DMF0037_SalesPlanReport.cs:632 | try ▸ lambda | DATA_OP | request.Parameters["p_internal_yn"] | (InternalYN.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-1455ddd9 | FindButton | DMF0037_SalesPlanReport.cs:633 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9aa64ecc | FindButton | DMF0037_SalesPlanReport.cs:635 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9813234a | FindButton | DMF0037_SalesPlanReport.cs:640 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5b7af84 | FindButton | DMF0037_SalesPlanReport.cs:646 | try | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1f0408a | FindButton | DMF0037_SalesPlanReport.cs:649 | try | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c3962d2d | FindButton | DMF0037_SalesPlanReport.cs:651 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b4250dce | FindButton | DMF0037_SalesPlanReport.cs:652 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-38515b95 | FindButton | DMF0037_SalesPlanReport.cs:655 | try ▸ if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c0e2fb1d | FindButton | DMF0037_SalesPlanReport.cs:663 | try ▸ for (i <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-613be554 | FindButton | DMF0037_SalesPlanReport.cs:668 | try ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ if (sColName.IndexOf("M_") >= 0) ▸ if (dtNowDate > dtYYYYMM) | GRID_STYLE | siMain.SetBGColor | (0, i, siMain.GetMaxRowIndex(), i, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-db66f5b3 | FindButton | DMF0037_SalesPlanReport.cs:673 | try ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ else of (sColName.IndexOf("M_") >= 0) | CALL_EXT | siMain.GetColumnText | (0, i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6f107f5 | FindButton | DMF0037_SalesPlanReport.cs:674 | try ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ else of (sColName.IndexOf("M_") >= 0) | CALL_EXT | Convert.ToInt16 | (strTemp[1]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ab7cc0c | FindButton | DMF0037_SalesPlanReport.cs:676 | try ▸ for (i <= siMain.GetMaxColumnIndex()) ▸ else of (sColName.IndexOf("M_") >= 0) ▸ if (iNowWeek > Convert.ToInt16(strTemp[1])) | GRID_STYLE | siMain.SetBGColor | (0, i, siMain.GetMaxRowIndex(), i, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-332dbb91 | FindButton | DMF0037_SalesPlanReport.cs:682 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ebb3cf7 | FindButton | DMF0037_SalesPlanReport.cs:696 | try ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("1_2:" + e.ToString()) | 메시지 표시 |  |  |  |
| AC-3c4c4933 | FindButton | DMF0037_SalesPlanReport.cs:708 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-af978190 | FindButton | DMF0037_SalesPlanReport.cs:709 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e1417f05 | FindButton | DMF0037_SalesPlanReport.cs:724 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07f8479a | FindButton | DMF0037_SalesPlanReport.cs:752 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d0190cbe | FindButton | DMF0037_SalesPlanReport.cs:757 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageBox.Show | ("2_2:" + ex.ToString()) | 메시지 표시 |  |  |  |
| AC-82928ed3 | FindButton | DMF0037_SalesPlanReport.cs:764 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3176f124 | FindButton | DMF0037_SalesPlanReport.cs:765 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a15d2b96 | FindButton | DMF0037_SalesPlanReport.cs:766 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0037_SalesPlanReport.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22a2edac | this.Load | DMF0037_SalesPlanReport.cs:173 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b041fbcf | this.Load | DMF0037_SalesPlanReport.cs:175 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0037_SalesPlanReport.GetBizTypebyDivision

진입점: this.Load [try ▸ else of (clbDivision.SelectedValue.ToString() == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c65fc294 | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0037_SalesPlanReport.cs:1279 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f9fee589 | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0037_SalesPlanReport.cs:1280 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-19b23fec | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0037_SalesPlanReport.cs:1281 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24b0616e | this.Load [try ▸ else of (clbDivision.SelectedValue.ToString… | DMF0037_SalesPlanReport.cs:1284 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetBizTypebyDivisionAsync

진입점: clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision.SelectedValue.ToString() == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5087fecf | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0037_SalesPlanReport.cs:1293 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b1199dcb | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0037_SalesPlanReport.cs:1294 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a314e54d | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0037_SalesPlanReport.cs:1295 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0aa67c7a | clbDivision.SelectedIndexChanged [try ▸ else of (clbDivision… | DMF0037_SalesPlanReport.cs:1298 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63a12434 | this.Load [try] | DMF0037_SalesPlanReport.cs:1193 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-64a660f9 | this.Load [try] | DMF0037_SalesPlanReport.cs:1194 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-991b81ec | this.Load [try] | DMF0037_SalesPlanReport.cs:1197 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53f0533b | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1249 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-298fdf34 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1250 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cdd1485b | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1251 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-5d5a62e4 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1252 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ec499bcd | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1255 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6867284 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1264 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-03975e27 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1265 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-eed86040 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1266 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-4c1f8825 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1267 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba9a9b88 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1270 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-967515c6 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1633 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-658e55be | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1650 | for (i < sv.ColumnCount) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-228b3986 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1652 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c9c1bb7 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1656 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e02bc73 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1658 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetDayRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75a23c2f | this.Load [try] | DMF0037_SalesPlanReport.cs:1161 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2ff4e80 | this.Load [try] | DMF0037_SalesPlanReport.cs:1166 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fa620f7 | this.Load [try] | DMF0037_SalesPlanReport.cs:1206 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-e72e06da | this.Load [try] | DMF0037_SalesPlanReport.cs:1207 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-ba67de1c | this.Load [try] | DMF0037_SalesPlanReport.cs:1208 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2199c04a | this.Load [try] | DMF0037_SalesPlanReport.cs:1211 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetLastWeekSunDayByDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-010fa51e | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1355 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f722843a | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1130 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-e019bf49 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1131 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3d2c7d8e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1132 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f5ce4c5b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1133 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-fc9ff018 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1134 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6c50647 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1137 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e63819ca | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1146 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-a496f9cd | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1147 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-118a7a1f | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1148 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-36c58e58 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1149 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-54bd1e99 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1150 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9c3703e5 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1153 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetQtyData

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18d6565c | this.Load [try] | DMF0037_SalesPlanReport.cs:1307 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-a93ae75a | this.Load [try] | DMF0037_SalesPlanReport.cs:1308 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ab4990ef | this.Load [try] | DMF0037_SalesPlanReport.cs:1311 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7f4573b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1098 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b96cf28b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1099 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-09e882a3 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1100 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9c769be6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1101 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-21e0f17d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1102 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a655a657 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0037_SalesPlanReport.cs:1105 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d4fe381 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1114 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d562630e | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1115 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-24020c73 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1116 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-88d7f42b | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1117 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-732655c0 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1118 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ad96cb6 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1121 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetSpdTitle

진입점: this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / clbDivision.SelectedIndexChanged [finally ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61ee14c6 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1176 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0037_GET_SPREAD_TITLE") ⇒ DM.DMF0037_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-94cb596c | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1177 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-9488ef66 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1178 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-21c15232 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1179 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a36aed74 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1180 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-9efeb962 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1182 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8a9c778c | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1182 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8265b8c7 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:1185 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f39f00ec | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1221 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c52dcc85 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1222 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-35188f03 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1223 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b763d36a | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1226 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b8f77a2 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1235 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c6f21167 | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1236 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d318a96f | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1237 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7bfbf1e | (진입점 미연결) | DMF0037_SalesPlanReport.cs:1239 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e94c9673 | FindButton [try] | DMF0037_SalesPlanReport.cs:1332 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8e2c371 | this.Load | DMF0037_SalesPlanReport.cs:192 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d1078ef6 | this.Load | DMF0037_SalesPlanReport.cs:193 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-fa664683 | this.Load | DMF0037_SalesPlanReport.cs:195 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-dda24f68 | this.Load | DMF0037_SalesPlanReport.cs:199 | try | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-54ad321f | this.Load | DMF0037_SalesPlanReport.cs:199 | try | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b755e55 | this.Load | DMF0037_SalesPlanReport.cs:201 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-14740505 | this.Load | DMF0037_SalesPlanReport.cs:204 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-aa664a8d | this.Load | DMF0037_SalesPlanReport.cs:204 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-183ca3b4 | this.Load | DMF0037_SalesPlanReport.cs:205 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e615ddc5 | this.Load | DMF0037_SalesPlanReport.cs:209 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-de0ecb85 | this.Load | DMF0037_SalesPlanReport.cs:209 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f6fb109 | this.Load | DMF0037_SalesPlanReport.cs:210 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-44ab7391 | this.Load | DMF0037_SalesPlanReport.cs:212 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-db1d75c8 | this.Load | DMF0037_SalesPlanReport.cs:212 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cfb01e86 | this.Load | DMF0037_SalesPlanReport.cs:215 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9f0a3410 | this.Load | DMF0037_SalesPlanReport.cs:216 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1ba3dcde | this.Load | DMF0037_SalesPlanReport.cs:217 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ce70406c | this.Load | DMF0037_SalesPlanReport.cs:219 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f4da5071 | this.Load | DMF0037_SalesPlanReport.cs:220 | try ▸ if (clbDivision.SelectedValue.ToString() == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-20fbb672 | this.Load | DMF0037_SalesPlanReport.cs:224 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-babdf026 | this.Load | DMF0037_SalesPlanReport.cs:224 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40f8c035 | this.Load | DMF0037_SalesPlanReport.cs:226 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-38beae54 | this.Load | DMF0037_SalesPlanReport.cs:227 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bfa59df5 | this.Load | DMF0037_SalesPlanReport.cs:230 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ff8d7806 | this.Load | DMF0037_SalesPlanReport.cs:231 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dab9d07b | this.Load | DMF0037_SalesPlanReport.cs:232 | try ▸ else of (clbDivision.SelectedValue.ToString() == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f45a28bc | this.Load | DMF0037_SalesPlanReport.cs:234 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-92f4b6ed | this.Load | DMF0037_SalesPlanReport.cs:236 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8527d5e6 | this.Load | DMF0037_SalesPlanReport.cs:236 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1f6fc4ce | this.Load | DMF0037_SalesPlanReport.cs:237 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-494aeee1 | this.Load | DMF0037_SalesPlanReport.cs:239 | try | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-3802f87e | this.Load | DMF0037_SalesPlanReport.cs:239 | try | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2c03b09e | this.Load | DMF0037_SalesPlanReport.cs:240 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-17d63670 | this.Load | DMF0037_SalesPlanReport.cs:242 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-fbb17546 | this.Load | DMF0037_SalesPlanReport.cs:243 | try | FLAG | dtBucketType | dtBucketType.Select("CODE <> 'DAILY'", "CODE DESC").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d00fd48 | this.Load | DMF0037_SalesPlanReport.cs:243 | try | DATA_OP | dtBucketType.Select("CODE <> 'DAILY'", "CODE DESC").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eed78764 | this.Load | DMF0037_SalesPlanReport.cs:243 | try | DATA_OP | dtBucketType.Select | ("CODE <> 'DAILY'", "CODE DESC") | 데이터 객체 조작/조회 |  |  |  |
| AC-deedeb23 | this.Load | DMF0037_SalesPlanReport.cs:244 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-28bd3713 | this.Load | DMF0037_SalesPlanReport.cs:252 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-aad20676 | this.Load | DMF0037_SalesPlanReport.cs:253 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-60642235 | this.Load | DMF0037_SalesPlanReport.cs:256 | try | FLAG | dtAmoutKrw | Data.Common(Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 화면 필드/플래그 변경 |  |  |  |
| AC-63215d14 | this.Load | DMF0037_SalesPlanReport.cs:256 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9fe74f1d | this.Load | DMF0037_SalesPlanReport.cs:257 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutKrw, cboKRW, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d37c6836 | this.Load | DMF0037_SalesPlanReport.cs:258 | try | FLAG | dtAmoutUsd | Data.Common(Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 화면 필드/플래그 변경 |  |  |  |
| AC-5bedc7d1 | this.Load | DMF0037_SalesPlanReport.cs:258 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c80d58a5 | this.Load | DMF0037_SalesPlanReport.cs:259 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutUsd, cboUSD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-10a294f9 | this.Load | DMF0037_SalesPlanReport.cs:260 | try | FLAG | dtAmoutLoc | Data.Common(Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 화면 필드/플래그 변경 |  |  |  |
| AC-03d65a0c | this.Load | DMF0037_SalesPlanReport.cs:260 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5885b1e | this.Load | DMF0037_SalesPlanReport.cs:261 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutLoc, cboLOC, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-08d2a0bb | this.Load | DMF0037_SalesPlanReport.cs:263 | try | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe315914 | this.Load | DMF0037_SalesPlanReport.cs:264 | try | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2dd36a1f | this.Load | DMF0037_SalesPlanReport.cs:267 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f20f5bf4 | this.Load | DMF0037_SalesPlanReport.cs:268 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c17c08de | this.Load | DMF0037_SalesPlanReport.cs:272 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ba14cc30 | this.Load | DMF0037_SalesPlanReport.cs:276 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2dd2a4fd | this.Load | DMF0037_SalesPlanReport.cs:277 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0037_SalesPlanReport.InitSpread

진입점: this.Load / clbDivision.SelectedIndexChanged [finally] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6414765 | this.Load 외 4 | DMF0037_SalesPlanReport.cs:338 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1245bd27 | this.Load 외 4 | DMF0037_SalesPlanReport.cs:344 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-94b86912 | this.Load 외 4 | DMF0037_SalesPlanReport.cs:349 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-3f50c7ec | this.Load 외 4 | DMF0037_SalesPlanReport.cs:350 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-22a59065 | this.Load 외 4 | DMF0037_SalesPlanReport.cs:354 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-5eae4acb | this.Load 외 4 | DMF0037_SalesPlanReport.cs:362 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-6491697b | this.Load 외 4 | DMF0037_SalesPlanReport.cs:366 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0037_SalesPlanReport.InitSpread_X

진입점: this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / clbDivision.SelectedIndexChanged [finally ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-221e8dad | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:371 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1f1e9af | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:377 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-a52c6663 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:378 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-7e0b6f30 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:379 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d02e5dec | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:381 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM.DMF0037_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM.DMF0037_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cec1a5ec | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:381 |  | ENDPOINT | new CUIControl | () ⇒ DM.DMF0037_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-903c652c | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:383 |  | FLAG | iNowWeek | Convert.ToInt16(ds.Tables[1].Rows[0][0]) | 화면 필드/플래그 변경 |  |  |  |
| AC-cfa9ecc6 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:383 |  | CALL_EXT | Convert.ToInt16 | (ds.Tables[1].Rows[0][0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7ba4308 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:414 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["DESCRIPTION"].ToString(), dt.Rows[i]["NEWCOLLIST"].ToString(), FPMerge.None, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23c08fdf | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:415 | for (i < dt.Rows.Count) | CALL_EXT | Convert.ToInt16 | (dt.Rows[i]["ColumnWidth"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1b79fde | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:419 | for (i < dt.Rows.Count) ▸ if (sCOLLIST_COLUMN_LABEL_NAME != dt.Rows[i]["COLLIST"].ToString() + "_" + dt.Rows[i]["COLUMN_LABEL_NAME"].ToStrin… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMFRow, 1, iMLRow - 1, 25, sColumnLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c12539fe | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:428 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iMFRow, 1, iMLRow, 25, sColumnLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3b66cc2 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:440 | for (i < dt.Rows.Count) ▸ if (sMonth != dt.Rows[i]["COLLIST"].ToString()) ▸ if (sMonth.IndexOf("M_") >= 0) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, _Month, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4fed720 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:448 | for (i < dt.Rows.Count) ▸ if (sMonth != dt.Rows[i]["COLLIST"].ToString()) ▸ else of (sMonth.IndexOf("M_") >= 0) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, _Month, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb46d9eb | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:458 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, _Month, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b17d9bf | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 4 | DMF0037_SalesPlanReport.cs:478 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0037_SalesPlanReport.SetAmountCalculating

진입점: cboKRW.SelectedIndexChanged / cboUSD.SelectedIndexChanged / cboLOC.SelectedIndexChanged / this.cboKRW.SelectedIndexChanged / this.cboUSD.SelectedIndexChanged / this.cboLOC.SelectedIndexChanged / this.cboQTY.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2504f2b7 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1414 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2bf3568 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1418 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c93b4aec | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1424 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-a69383e2 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1425 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-495f1be0 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1431 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ff6b5ae8 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1433 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2afbcc26 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1575 | for (iCol < dsOrigianlCopy.Tables[0].Columns.Count) ▸ for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ if ((sColumnName[2] == "SalesAmt") && … | GRID_SET | dsKrw.Tables[0].Rows[i][iCol] | Math.Round(Convert.ToDouble(slValue) / dbKrwDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-8141a575 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1577 | for (iCol < dsOrigianlCopy.Tables[0].Columns.Count) ▸ for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ if ((sColumnName[2] == "SalesAmt") && … | GRID_SET | dsKrw.Tables[0].Rows[i][iCol] | Math.Round(Convert.ToDouble(slValue) / dbUsdDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-66fd678c | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1579 | for (iCol < dsOrigianlCopy.Tables[0].Columns.Count) ▸ for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ if ((sColumnName[2] == "SalesAmt") && … | GRID_SET | dsKrw.Tables[0].Rows[i][iCol] | Math.Round(Convert.ToDouble(slValue) / dbLocDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-f4733ec0 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1581 | for (iCol < dsOrigianlCopy.Tables[0].Columns.Count) ▸ for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ if ((sColumnName[2] == "CUST") \|\| (s… | GRID_SET | dsKrw.Tables[0].Rows[i][iCol] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-ee451260 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1585 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b3b859de | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1591 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-92840fd3 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1595 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-70ded5a4 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1599 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-b11209b3 | cboKRW.SelectedIndexChanged 외 7 | DMF0037_SalesPlanReport.cs:1602 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0037_SalesPlanReport.SetSpreadColumn

진입점: this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / clbDivision.SelectedIndexChanged [finally ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6dd7350 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 6 | DMF0037_SalesPlanReport.cs:1070 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-95e6227f | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 6 | DMF0037_SalesPlanReport.cs:1074 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (siMain.GetColumnTag(iCol).IndexO… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a09dd4e0 | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 6 | DMF0037_SalesPlanReport.cs:1082 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == B… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f7be71dd | this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd"… 외 6 | DMF0037_SalesPlanReport.cs:1086 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == B… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## DMF0037_SalesPlanReport.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7571d99f | this.spdMain.CellDoubleClick | DMF0037_SalesPlanReport.cs:921 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-76290d05 | this.spdMain.CellDoubleClick | DMF0037_SalesPlanReport.cs:927 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-2148fb5d | this.spdMain.CellDoubleClick | DMF0037_SalesPlanReport.cs:943 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-99d0abe8 | this.spdMain.CellDoubleClick | DMF0037_SalesPlanReport.cs:957 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0037_SalesPlanReport.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1afb3b44 | this.spdMain.ComboSelChange | DMF0037_SalesPlanReport.cs:903 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-bf0ec703 | this.spdMain.ComboSelChange | DMF0037_SalesPlanReport.cs:904 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fdad4941 | this.spdMain.ComboSelChange | DMF0037_SalesPlanReport.cs:906 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-4a59079d | this.spdMain.ComboSelChange | DMF0037_SalesPlanReport.cs:907 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0037_SalesPlanReport.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1e430b9 | this.spdMain.KeyUp | DMF0037_SalesPlanReport.cs:972 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d327658 | this.spdMain.KeyUp | DMF0037_SalesPlanReport.cs:976 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47b6b4bb | this.spdMain.KeyUp | DMF0037_SalesPlanReport.cs:982 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c98c3a2f | this.spdMain.KeyUp | DMF0037_SalesPlanReport.cs:983 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0037_SalesPlanReport.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cb44f7b | this.spdMain.TopChange | DMF0037_SalesPlanReport.cs:966 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

