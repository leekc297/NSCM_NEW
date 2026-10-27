# AS-IS 액션 대조표 — DM0022

> 원천: `Doc/asisfacts/screens/DM0022/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 631행 · 메서드 47 · 종류 DATA_OP 98 · RETURN 86 · FLAG 80 · ENDPOINT 64 · LIST_REBIND 38 · CALL_EXT 37 · GRID_INIT 36 · GRID_SET 34 · COMBO_DATA 32 · POPUP 30 · UI_MISC 27 · UI_PROP 18 · VALUE_SET 15 · MESSAGE 14 · THROW 6 · LIST_BIND 4 · GRID_COMBO 4 · VALIDATE 2 · GRID_BIND 2 · GRID_LOCK 2 · GRID_STYLE 2 · ⚠ 의미 확인 필요 37


## DM0022_SalesPlanWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6dca6a5 | this.btnColumn.Click | DM0022_SalesPlanWaterfall.cs:1283 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DM0022", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-62e40b66 | this.btnColumn.Click | DM0022_SalesPlanWaterfall.cs:1284 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18bde3e9 | this.btnColumn.Click | DM0022_SalesPlanWaterfall.cs:1285 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d319d40d | this.btnColumn.Click | DM0022_SalesPlanWaterfall.cs:1253 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DM0022", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-5e1e1389 | this.btnColumn.Click | DM0022_SalesPlanWaterfall.cs:1254 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e3a2bd48 | this.btnColumn.Click | DM0022_SalesPlanWaterfall.cs:1255 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0022_SalesPlanWaterfall.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72361f92 | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1272 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-1a12ad19 | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1274 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7c019268 | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1275 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e49f4ec4 | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1276 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-07f9e85e | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1278 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |
| AC-71f82228 | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1242 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-9379380e | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1244 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dc40c5b4 | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1245 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ab911e3a | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1246 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b1ca5c0a | this.btnItemId.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1248 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DM0022_SalesPlanWaterfall.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50a96d4a | this.btnMeasure.Click | DM0022_SalesPlanWaterfall.cs:1295 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DM0022", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-ef11931b | this.btnMeasure.Click | DM0022_SalesPlanWaterfall.cs:1296 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-798df9dd | this.btnMeasure.Click | DM0022_SalesPlanWaterfall.cs:1297 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a1b13ea1 | this.btnMeasure.Click | DM0022_SalesPlanWaterfall.cs:1265 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DM0022", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-046d58e1 | this.btnMeasure.Click | DM0022_SalesPlanWaterfall.cs:1266 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b3602ce9 | this.btnMeasure.Click | DM0022_SalesPlanWaterfall.cs:1267 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0022_SalesPlanWaterfall.btnProject_Click

진입점: this.btnProject.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5df8bec6 | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1254 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-0f72a20b | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1255 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-12e766d7 | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1256 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2d3a5096 | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1257 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-86c40c75 | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1259 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |
| AC-56224845 | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1224 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-9a1a6a46 | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1225 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-10c832db | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1226 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fe51faeb | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1227 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d28fd55b | this.btnProject.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1229 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0022_SalesPlanWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6da0eb69 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1946 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a7917b99 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1947 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-611be9c0 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1948 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6d052d74 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1949 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-93ff43d0 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1953 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-ba2e7b8e | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1954 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |
| AC-390de2bf | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1916 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e672b9c1 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1917 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-93c1b678 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1918 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dcbc78a3 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1919 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-efc9dfd4 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1923 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-b362ad38 | this.btnVersion.Click 외 1 | DM0022_SalesPlanWaterfall.cs:1924 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DM0022_SalesPlanWaterfall.cboKRW_SelectedIndexChanged

진입점: this.cboKRW.SelectedIndexChanged / cboKRW.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-299f1421 | this.cboKRW.SelectedIndexChanged 외 1 | DM0022_SalesPlanWaterfall.cs:1688 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60cf220c | this.cboKRW.SelectedIndexChanged 외 1 | DM0022_SalesPlanWaterfall.cs:1658 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.cboLOC_SelectedIndexChanged

진입점: this.cboLOC.SelectedIndexChanged / cboLOC.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-450dc2a9 | this.cboLOC.SelectedIndexChanged 외 1 | DM0022_SalesPlanWaterfall.cs:1709 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f4d3333 | this.cboLOC.SelectedIndexChanged 외 1 | DM0022_SalesPlanWaterfall.cs:1679 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.cboUSD_SelectedIndexChanged

진입점: this.cboUSD.SelectedIndexChanged / cboUSD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a3acec8 | this.cboUSD.SelectedIndexChanged 외 1 | DM0022_SalesPlanWaterfall.cs:1699 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1ff1bb0 | this.cboUSD.SelectedIndexChanged 외 1 | DM0022_SalesPlanWaterfall.cs:1669 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6b3cb18 | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1677 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c98db03 | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1679 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ca23862 | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1681 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-17b5e5e2 | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1681 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9cf7d837 | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1682 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e1f1b4cf | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1647 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c83fe019 | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1649 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d0dfa6a | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1651 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bfc6dd6d | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1651 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7ff7738e | this.clbCustomer.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1652 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0022_SalesPlanWaterfall.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-962adda5 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:991 | try ▸ if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7fa0aef5 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:993 | try ▸ if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-461cfdf2 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:999 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27ab5b02 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1002 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4c267617 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1021 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-1b4ccd2b | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1021 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ef57c9b | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1022 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-47486606 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1026 | try | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a14ddc1 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1026 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ddfdcfe6 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1027 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d8a4043 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1031 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8f891504 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1031 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ca348f2 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1032 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3b014b71 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1034 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-7235e0b9 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1034 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54695102 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1035 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-daa75a64 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1037 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa1278f9 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1038 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7c0d29b6 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1054 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4afe88b2 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1055 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-7e82bc6e | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1059 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-510a7021 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:961 | try ▸ if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4a82a7f | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:963 | try ▸ if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af21e3bc | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:969 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35175cf2 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:972 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f1626faa | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:991 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6f06ae76 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:991 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-437c3e84 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:992 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-522884a7 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:996 | try | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-80b9a19e | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:996 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-61c2f8d2 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:997 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-27c3ccd7 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1001 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4f0486b6 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1001 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c9459f0 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1002 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8f9942bf | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1004 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-abb985a6 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1004 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d75685c | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1005 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bfefe4cb | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1007 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-30fd0e44 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1008 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f368331d | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1024 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f4b4a71f | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1025 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-b75f9c31 | clbDivision.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1029 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DM0022_SalesPlanWaterfall.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35c0f24b | clbPlantSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1079 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c17dfcf | clbPlantSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1081 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79ec8353 | clbPlantSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1049 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3201050 | clbPlantSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1051 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.ClbSalesSite_SelectedIndexChanged

진입점: clbSalesSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-350d6933 | clbSalesSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1068 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d702f51f | clbSalesSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1070 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c87b8b08 | clbSalesSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1038 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fcfce18f | clbSalesSite.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1040 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43f79a38 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1879 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f42c52a3 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1881 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8200187d | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1886 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-3e354de4 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1886 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-73645bf3 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1887 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e3f7e847 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1891 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-85fd37aa | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1891 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19bdd7c5 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1892 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b6a27c60 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1849 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df79023a | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1851 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70386d79 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1856 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-336c5607 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1856 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a5aa2bed | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1857 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3370f19d | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1861 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7ff912ff | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1861 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e344b61 | this.clbTeam.SelectedIndexChanged | DM0022_SalesPlanWaterfall.cs:1862 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0022_SalesPlanWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-306647d1 | this.Load | DM0022_SalesPlanWaterfall.cs:354 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bd73f8bb | this.Load | DM0022_SalesPlanWaterfall.cs:355 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eb13c9a1 | this.Load | DM0022_SalesPlanWaterfall.cs:356 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0205bfd0 | this.Load | DM0022_SalesPlanWaterfall.cs:357 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8b03b7ba | this.Load | DM0022_SalesPlanWaterfall.cs:358 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-11a03f75 | this.Load | DM0022_SalesPlanWaterfall.cs:359 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0022_SalesPlanWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72a64381 | this.Load | DM0022_SalesPlanWaterfall.cs:325 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-44da806e | this.Load | DM0022_SalesPlanWaterfall.cs:326 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-8d0b3c8a | this.Load | DM0022_SalesPlanWaterfall.cs:329 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-9c58a02a | this.Load | DM0022_SalesPlanWaterfall.cs:330 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-29f8ba52 | this.Load | DM0022_SalesPlanWaterfall.cs:328 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-f30b9c36 | this.Load | DM0022_SalesPlanWaterfall.cs:329 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-7c260c2e | this.Load | DM0022_SalesPlanWaterfall.cs:332 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-16635f06 | this.Load | DM0022_SalesPlanWaterfall.cs:333 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DM0022_SalesPlanWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3d8bb91 | Dispose | DM0022_SalesPlanWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-ef30ff56 | Dispose | DM0022_SalesPlanWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0022_SalesPlanWaterfall.DM0022_SalesPlanWaterfall_FormClosed

진입점: this.FormClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9690378d | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1967 | try | CALL_EXT | GC.SuppressFinalize | (this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7b4ebd4 | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1969 | try | CALL_EXT | GC.Collect | (0, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-76d10773 | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1970 | try | CALL_EXT | GC.Collect | (1, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82837940 | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1971 | try | CALL_EXT | GC.Collect | (2, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89ccc684 | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1937 | try | CALL_EXT | GC.SuppressFinalize | (this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e646f1e8 | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1939 | try | CALL_EXT | GC.Collect | (0, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2f4ea47 | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1940 | try | CALL_EXT | GC.Collect | (1, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28d8be99 | this.FormClosed | DM0022_SalesPlanWaterfall.cs:1941 | try | CALL_EXT | GC.Collect | (2, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |

## DM0022_SalesPlanWaterfall.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e05b1de | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0022_SalesPlanWaterfall.cs:604 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-80f8e537 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0022_SalesPlanWaterfall.cs:605 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abdf92c2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0022_SalesPlanWaterfall.cs:607 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c9a0aa6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0022_SalesPlanWaterfall.cs:608 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b3a308c | FindButton | DM0022_SalesPlanWaterfall.cs:620 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-be016fac | FindButton | DM0022_SalesPlanWaterfall.cs:627 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9619a41e | FindButton | DM0022_SalesPlanWaterfall.cs:628 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-417067f7 | FindButton | DM0022_SalesPlanWaterfall.cs:631 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6c720960 | FindButton | DM0022_SalesPlanWaterfall.cs:633 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-92d86064 | FindButton | DM0022_SalesPlanWaterfall.cs:633 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac67c5d3 | FindButton | DM0022_SalesPlanWaterfall.cs:643 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0900b3b3 | FindButton | DM0022_SalesPlanWaterfall.cs:644 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b673ba91 | FindButton | DM0022_SalesPlanWaterfall.cs:650 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-461edd98 | FindButton | DM0022_SalesPlanWaterfall.cs:652 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-2cc319cd | FindButton | DM0022_SalesPlanWaterfall.cs:654 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6ff7607 | FindButton | DM0022_SalesPlanWaterfall.cs:658 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f589dd6 | FindButton | DM0022_SalesPlanWaterfall.cs:660 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6643e4f | FindButton | DM0022_SalesPlanWaterfall.cs:679 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-853835dc | FindButton | DM0022_SalesPlanWaterfall.cs:680 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32d58d3d | FindButton | DM0022_SalesPlanWaterfall.cs:684 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8088b43f | FindButton | DM0022_SalesPlanWaterfall.cs:694 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-73e00e06 | FindButton | DM0022_SalesPlanWaterfall.cs:695 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ace4cfc2 | FindButton | DM0022_SalesPlanWaterfall.cs:700 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL") ⇒ DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-d827e75f | FindButton | DM0022_SalesPlanWaterfall.cs:702 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-de9bb34d | FindButton | DM0022_SalesPlanWaterfall.cs:704 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2d297272 | FindButton | DM0022_SalesPlanWaterfall.cs:705 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb949ec6 | FindButton | DM0022_SalesPlanWaterfall.cs:706 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-6ec45715 | FindButton | DM0022_SalesPlanWaterfall.cs:707 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-589dd4c5 | FindButton | DM0022_SalesPlanWaterfall.cs:708 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-0ea2d280 | FindButton | DM0022_SalesPlanWaterfall.cs:709 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d079b03 | FindButton | DM0022_SalesPlanWaterfall.cs:710 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-54913519 | FindButton | DM0022_SalesPlanWaterfall.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-a53e3fb2 | FindButton | DM0022_SalesPlanWaterfall.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-ab753af8 | FindButton | DM0022_SalesPlanWaterfall.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-e0cbf6ff | FindButton | DM0022_SalesPlanWaterfall.cs:714 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3cfd9529 | FindButton | DM0022_SalesPlanWaterfall.cs:715 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-13931e92 | FindButton | DM0022_SalesPlanWaterfall.cs:716 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-d1867031 | FindButton | DM0022_SalesPlanWaterfall.cs:717 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-bae2b5c6 | FindButton | DM0022_SalesPlanWaterfall.cs:718 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7854b23c | FindButton | DM0022_SalesPlanWaterfall.cs:720 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a210100b | FindButton | DM0022_SalesPlanWaterfall.cs:725 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-736af4fb | FindButton | DM0022_SalesPlanWaterfall.cs:731 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a5a68ee | FindButton | DM0022_SalesPlanWaterfall.cs:734 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d1f4d26b | FindButton | DM0022_SalesPlanWaterfall.cs:736 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-55bc2918 | FindButton | DM0022_SalesPlanWaterfall.cs:737 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5e3eb4a | FindButton | DM0022_SalesPlanWaterfall.cs:740 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") ▸ if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-40f4ebb4 | FindButton | DM0022_SalesPlanWaterfall.cs:744 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10933ed4 | FindButton | DM0022_SalesPlanWaterfall.cs:764 | try ▸ try ▸ if (chkMem.Checked == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-18162148 | FindButton | DM0022_SalesPlanWaterfall.cs:810 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-bc2a1f78 | FindButton | DM0022_SalesPlanWaterfall.cs:811 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iResultMonth, i, iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-150954eb | FindButton | DM0022_SalesPlanWaterfall.cs:833 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= iTotalRowCount) ▸ if ((i % 1000) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-a696988a | FindButton | DM0022_SalesPlanWaterfall.cs:895 | try ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("1_2:" + e.ToString()) | 메시지 표시 |  |  |  |
| AC-cf4ee708 | FindButton | DM0022_SalesPlanWaterfall.cs:916 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-8ed02586 | FindButton | DM0022_SalesPlanWaterfall.cs:917 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bb1637b1 | FindButton | DM0022_SalesPlanWaterfall.cs:932 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afe65994 | FindButton | DM0022_SalesPlanWaterfall.cs:964 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5c7dd39e | FindButton | DM0022_SalesPlanWaterfall.cs:969 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageBox.Show | ("2_2:" + ex.ToString()) | 메시지 표시 |  |  |  |
| AC-7b282f23 | FindButton | DM0022_SalesPlanWaterfall.cs:976 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f034cbb3 | FindButton | DM0022_SalesPlanWaterfall.cs:977 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-922f8ddf | FindButton | DM0022_SalesPlanWaterfall.cs:978 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55bf0058 | FindButton | DM0022_SalesPlanWaterfall.cs:623 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ca673495 | FindButton | DM0022_SalesPlanWaterfall.cs:630 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f79170f7 | FindButton | DM0022_SalesPlanWaterfall.cs:631 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6071d914 | FindButton | DM0022_SalesPlanWaterfall.cs:634 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-75b7f572 | FindButton | DM0022_SalesPlanWaterfall.cs:636 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-7d1d500b | FindButton | DM0022_SalesPlanWaterfall.cs:636 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec97e676 | FindButton | DM0022_SalesPlanWaterfall.cs:646 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-70e683fd | FindButton | DM0022_SalesPlanWaterfall.cs:647 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f1c89b3 | FindButton | DM0022_SalesPlanWaterfall.cs:653 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b3bcfd1 | FindButton | DM0022_SalesPlanWaterfall.cs:655 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-8c1045e1 | FindButton | DM0022_SalesPlanWaterfall.cs:657 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1a59d5b | FindButton | DM0022_SalesPlanWaterfall.cs:661 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-18175117 | FindButton | DM0022_SalesPlanWaterfall.cs:663 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6470674 | FindButton | DM0022_SalesPlanWaterfall.cs:682 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66afa3c7 | FindButton | DM0022_SalesPlanWaterfall.cs:683 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5e8f3459 | FindButton | DM0022_SalesPlanWaterfall.cs:687 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dedbd6ff | FindButton | DM0022_SalesPlanWaterfall.cs:697 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0c6c4156 | FindButton | DM0022_SalesPlanWaterfall.cs:698 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cfe0ff0f | FindButton | DM0022_SalesPlanWaterfall.cs:703 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL") ⇒ DM_H.DM0022_GET_DM_PLN_SALES_PLAN_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-91506017 | FindButton | DM0022_SalesPlanWaterfall.cs:705 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-63879db4 | FindButton | DM0022_SalesPlanWaterfall.cs:707 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-00a476d7 | FindButton | DM0022_SalesPlanWaterfall.cs:708 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-d0eeff6e | FindButton | DM0022_SalesPlanWaterfall.cs:709 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-5adfccd0 | FindButton | DM0022_SalesPlanWaterfall.cs:710 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ca47c4fb | FindButton | DM0022_SalesPlanWaterfall.cs:711 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-32448616 | FindButton | DM0022_SalesPlanWaterfall.cs:712 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-4a47efc5 | FindButton | DM0022_SalesPlanWaterfall.cs:713 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-ea54bb94 | FindButton | DM0022_SalesPlanWaterfall.cs:714 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-0567ef3b | FindButton | DM0022_SalesPlanWaterfall.cs:715 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-a6aaf1f1 | FindButton | DM0022_SalesPlanWaterfall.cs:716 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-17853e2b | FindButton | DM0022_SalesPlanWaterfall.cs:717 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-439732b8 | FindButton | DM0022_SalesPlanWaterfall.cs:718 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-0488f5b6 | FindButton | DM0022_SalesPlanWaterfall.cs:719 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-f1b53f08 | FindButton | DM0022_SalesPlanWaterfall.cs:720 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-07d2ec51 | FindButton | DM0022_SalesPlanWaterfall.cs:721 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-10bf6007 | FindButton | DM0022_SalesPlanWaterfall.cs:723 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4a2043c9 | FindButton | DM0022_SalesPlanWaterfall.cs:728 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7bb9571e | FindButton | DM0022_SalesPlanWaterfall.cs:734 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c3f538d | FindButton | DM0022_SalesPlanWaterfall.cs:737 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-317acde6 | FindButton | DM0022_SalesPlanWaterfall.cs:739 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-61e6c97d | FindButton | DM0022_SalesPlanWaterfall.cs:740 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b339b429 | FindButton | DM0022_SalesPlanWaterfall.cs:747 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70c05026 | FindButton | DM0022_SalesPlanWaterfall.cs:767 | try ▸ try ▸ if (chkMem.Checked == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d8854b9 | FindButton | DM0022_SalesPlanWaterfall.cs:801 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= iTotalRowCount) ▸ if ((i % 1000) == 0) | UI_MISC | Application.DoEvents | () | 화면 갱신/대기창 |  |  |  |
| AC-a5f23b86 | FindButton | DM0022_SalesPlanWaterfall.cs:822 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex("VERSION_NO") > -1) ▸ if (sVersion.ToUpper()… | GRID_SET | spdMain.ActiveSheet.Cells[i, iStartCol, i, iResultCol].BackColor | Color.Gainsboro | 그리드 속성/값 설정 |  |  |  |
| AC-9abb40d0 | FindButton | DM0022_SalesPlanWaterfall.cs:823 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex("VERSION_NO") > -1) ▸ if (sVersion.ToUpper()… | GRID_SET | spdMain.ActiveSheet.Cells[i, iResultMonth, i, iResultMonth].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-b55f5e65 | FindButton | DM0022_SalesPlanWaterfall.cs:835 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex("VERSION_NO") > -1) ▸ else of (sVersion.ToUp… | GRID_SET | spdMain.ActiveSheet.Cells[i, iStartCol, i, iResultCol].BackColor | Color.Gainsboro | 그리드 속성/값 설정 |  |  |  |
| AC-0c783e52 | FindButton | DM0022_SalesPlanWaterfall.cs:836 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= iTotalRowCount) ▸ if (siMain.GetColumnIndex("VERSION_NO") > -1) ▸ else of (sVersion.ToUp… | GRID_SET | spdMain.ActiveSheet.Cells[i, iResultMonth, i, iResultMonth].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-dfb4f46a | FindButton | DM0022_SalesPlanWaterfall.cs:860 | try ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("1_2:" + e.ToString()) | 메시지 표시 |  |  |  |
| AC-5a89c799 | FindButton | DM0022_SalesPlanWaterfall.cs:881 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-32eacdfa | FindButton | DM0022_SalesPlanWaterfall.cs:882 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-86efff80 | FindButton | DM0022_SalesPlanWaterfall.cs:886 | try ▸ if (dsOrigianlCopy != null) | CALL_EXT | task.Start | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f3874c7 | FindButton | DM0022_SalesPlanWaterfall.cs:889 | try ▸ if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-49ffef86 | FindButton | DM0022_SalesPlanWaterfall.cs:902 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ad0cb74 | FindButton | DM0022_SalesPlanWaterfall.cs:915 | try | VALUE_SET | cboKRW.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-480051f9 | FindButton | DM0022_SalesPlanWaterfall.cs:916 | try | VALUE_SET | cboUSD.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-96e5eb0c | FindButton | DM0022_SalesPlanWaterfall.cs:917 | try | VALUE_SET | cboLOC.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e0c33924 | FindButton | DM0022_SalesPlanWaterfall.cs:934 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e9cdaf84 | FindButton | DM0022_SalesPlanWaterfall.cs:939 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageBox.Show | ("2_2:" + ex.ToString()) | 메시지 표시 |  |  |  |
| AC-0d7896ed | FindButton | DM0022_SalesPlanWaterfall.cs:946 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a10ce082 | FindButton | DM0022_SalesPlanWaterfall.cs:947 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bc95dc1c | FindButton | DM0022_SalesPlanWaterfall.cs:948 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0022_SalesPlanWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-954df8ac | this.Load | DM0022_SalesPlanWaterfall.cs:192 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-649419ca | this.Load | DM0022_SalesPlanWaterfall.cs:198 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5500e6b9 | this.Load | DM0022_SalesPlanWaterfall.cs:195 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-667634bc | this.Load | DM0022_SalesPlanWaterfall.cs:201 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0022_SalesPlanWaterfall.GetBizTypebyDivision

진입점: this.Load [try] / clbDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35eb7d4e | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1601 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e396f5c5 | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1602 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8a9fed99 | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1603 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6fc03f4b | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1606 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-2b5f0f07 | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1571 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e93ec447 | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1572 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9ce031d4 | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1573 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-06ff65ca | this.Load [try] 외 1 | DM0022_SalesPlanWaterfall.cs:1576 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetBizTypebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4469cfd0 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1615 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b7ec8072 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1616 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b8362879 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1617 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eab43032 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1620 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-de7136d2 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1585 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a9331325 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1586 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-36ca4d00 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1587 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-626139a9 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1590 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6339fcce | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1503 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-0876c907 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1504 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6a9feef7 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1507 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-7a5985f6 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1473 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b15ab69e | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1474 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5dabf888 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1477 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b71baef3 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1564 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-356613eb | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1565 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6fd8191d | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1566 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-7b539021 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1567 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f76dd44f | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1570 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-f6b54bbb | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1534 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-83128033 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1535 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c25553a6 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1536 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e3c5f709 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1537 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c2f3c83b | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1540 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c0a87dc | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1579 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1044ac83 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1580 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-951291eb | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1581 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-a33a129c | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1582 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-46371c8c | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1585 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-fbe816a6 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1549 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5f21f5b2 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1550 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-45e116fe | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1551 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-7832078a | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1552 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-82e23808 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1555 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33c40852 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1901 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f53b007a | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1918 | for (i < sv.ColumnCount) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-09beb279 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1920 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-47d63a32 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1924 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-be8c3a35 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1928 | if (ds2 != null) | UI_MISC | ds2.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-f835b716 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1930 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1b2f1b29 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1871 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5586372 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1888 | for (i < sv.ColumnCount) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cfd9714 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1890 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-72250f81 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1894 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-69df658f | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1898 | if (ds2 != null) | UI_MISC | ds2.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-75829574 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1900 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetDayRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0d3f4ef | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1456 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-14d0da0b | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1461 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-47292f60 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1426 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0ac7fb95 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1431 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-773ce771 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1516 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-4e069e52 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1517 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-bebd5b6b | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1518 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c887fe8 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1521 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-d5d1c5da | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1486 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-d11a2bf4 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1487 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-ceb08bdc | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1488 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-157c1f77 | this.Load [try] | DM0022_SalesPlanWaterfall.cs:1491 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetLastWeekSunDayByDate

진입점: FindButton [try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sVersion.ToUpper() == "CURRENT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d68e0d11 | FindButton [try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i… | DM0022_SalesPlanWaterfall.cs:1670 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |
| AC-49991bb6 | FindButton [try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i… | DM0022_SalesPlanWaterfall.cs:1640 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bb89e34 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1410 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-59a2cfbc | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1411 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-32e5deb1 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1412 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-1aca3988 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1413 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-45caa5d6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1414 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91e52583 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1417 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-e72144b1 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1380 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-eeab02d2 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1381 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7678aaf4 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1382 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e0997c76 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1383 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-8443f1b9 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1384 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2b9a3f3b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1387 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54e2f698 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1426 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-7a108bab | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1427 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8bfdcfdf | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1428 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9b2d704d | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1429 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-f14cf154 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1430 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2b9cda8 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1433 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-5f6c3347 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1396 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-8de9d046 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1397 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-149fa6c8 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1398 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-8ba2421b | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1399 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-44075586 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1400 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6590d734 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1403 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9f03a23 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1370 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5ace9870 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1371 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a64cfba7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1372 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-fc523fc6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1373 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-d66ee95e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1374 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-02d2a39b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1377 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-4a17c37c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1340 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b5894fe7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1341 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8296416f | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1342 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-8a36715b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1343 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-0ca0b3a4 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1344 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c056ea3 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0022_SalesPlanWaterfall.cs:1347 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a8f168f | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1386 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3b27bcaa | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1387 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1f74eb3d | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1388 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-cb255b38 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1389 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-b072f589 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1390 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2ce141cc | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1393 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-da5d7f7e | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1356 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-13cb923a | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1357 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c5bb469f | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1358 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ded3dc39 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1359 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-51f7daaf | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1360 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b62fa0cd | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1363 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / FindButton [try ▸ try ▸ else of ((d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18ae9c3b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1485 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0022_GET_SPREAD_TITLE") ⇒ DM_H.DM0022_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-dcafe63f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1486 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-82309739 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1487 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-c479c5cf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1488 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f3568c52 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1492 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-cadfc9f8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1492 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-850d1ac8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1495 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-4587ceaa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1455 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0022_GET_SPREAD_TITLE") ⇒ DM_H.DM0022_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c567e732 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1456 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-b7d9ee6d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1457 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-a5342931 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1458 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-be62e2b4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1462 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6d6cd069 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1462 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-84186b30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:1465 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-129d2c70 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1531 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7c7178c8 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1532 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-48ce0c93 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1533 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f484f3d | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1536 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-fe3ea635 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1501 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-816d3807 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1502 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4210e37a | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1503 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ca514df | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1506 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f805528 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1545 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e28062a0 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1546 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-88eb483d | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1547 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07384fd6 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1549 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-1a4ba282 | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1515 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5fb63b0d | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1516 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4fa7721f | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1517 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d66c881f | (진입점 미연결) | DM0022_SalesPlanWaterfall.cs:1519 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38b9ce3e | FindButton [try] | DM0022_SalesPlanWaterfall.cs:1647 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |
| AC-49daca6c | FindButton [try] | DM0022_SalesPlanWaterfall.cs:1617 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b8d5d96 | this.Load | DM0022_SalesPlanWaterfall.cs:215 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f9000967 | this.Load | DM0022_SalesPlanWaterfall.cs:216 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5c117b59 | this.Load | DM0022_SalesPlanWaterfall.cs:218 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-bd4ce3b1 | this.Load | DM0022_SalesPlanWaterfall.cs:248 | try | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9a1115c9 | this.Load | DM0022_SalesPlanWaterfall.cs:248 | try | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4ca21ad4 | this.Load | DM0022_SalesPlanWaterfall.cs:249 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1c575b98 | this.Load | DM0022_SalesPlanWaterfall.cs:252 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-bca8f9bc | this.Load | DM0022_SalesPlanWaterfall.cs:252 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-749bfd74 | this.Load | DM0022_SalesPlanWaterfall.cs:253 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7383c059 | this.Load | DM0022_SalesPlanWaterfall.cs:264 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-2675e3c2 | this.Load | DM0022_SalesPlanWaterfall.cs:265 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-96b7cfeb | this.Load | DM0022_SalesPlanWaterfall.cs:267 | try | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-358a98bb | this.Load | DM0022_SalesPlanWaterfall.cs:267 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-832ae414 | this.Load | DM0022_SalesPlanWaterfall.cs:268 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2f69b085 | this.Load | DM0022_SalesPlanWaterfall.cs:276 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-1f50e50f | this.Load | DM0022_SalesPlanWaterfall.cs:276 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c16c1dc5 | this.Load | DM0022_SalesPlanWaterfall.cs:277 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aff309f9 | this.Load | DM0022_SalesPlanWaterfall.cs:279 | try | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-9178a6fc | this.Load | DM0022_SalesPlanWaterfall.cs:279 | try | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23318a28 | this.Load | DM0022_SalesPlanWaterfall.cs:280 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c6e41a37 | this.Load | DM0022_SalesPlanWaterfall.cs:282 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-87c0d6a6 | this.Load | DM0022_SalesPlanWaterfall.cs:283 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7501da0c | this.Load | DM0022_SalesPlanWaterfall.cs:296 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9a2d50e6 | this.Load | DM0022_SalesPlanWaterfall.cs:297 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-693ae69b | this.Load | DM0022_SalesPlanWaterfall.cs:300 | try | FLAG | dtAmoutKrw | Data.Common(Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 화면 필드/플래그 변경 |  |  |  |
| AC-35551be5 | this.Load | DM0022_SalesPlanWaterfall.cs:300 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-048e933c | this.Load | DM0022_SalesPlanWaterfall.cs:301 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutKrw, cboKRW, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-083c94b9 | this.Load | DM0022_SalesPlanWaterfall.cs:302 | try | FLAG | dtAmoutUsd | Data.Common(Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 화면 필드/플래그 변경 |  |  |  |
| AC-08dcfacb | this.Load | DM0022_SalesPlanWaterfall.cs:302 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8bc93526 | this.Load | DM0022_SalesPlanWaterfall.cs:303 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutUsd, cboUSD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-17a3c9b1 | this.Load | DM0022_SalesPlanWaterfall.cs:304 | try | FLAG | dtAmoutLoc | Data.Common(Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 화면 필드/플래그 변경 |  |  |  |
| AC-6b2e587c | this.Load | DM0022_SalesPlanWaterfall.cs:304 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1f4ee7f | this.Load | DM0022_SalesPlanWaterfall.cs:305 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutLoc, cboLOC, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-23e5f3c6 | this.Load | DM0022_SalesPlanWaterfall.cs:308 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8dc5ed1f | this.Load | DM0022_SalesPlanWaterfall.cs:309 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ad1192c | this.Load | DM0022_SalesPlanWaterfall.cs:313 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-fd9ffbc9 | this.Load | DM0022_SalesPlanWaterfall.cs:317 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3dd8161d | this.Load | DM0022_SalesPlanWaterfall.cs:318 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |
| AC-daaef6c8 | this.Load | DM0022_SalesPlanWaterfall.cs:218 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5afbdfd9 | this.Load | DM0022_SalesPlanWaterfall.cs:219 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8ef3aa32 | this.Load | DM0022_SalesPlanWaterfall.cs:221 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-29772de5 | this.Load | DM0022_SalesPlanWaterfall.cs:251 | try | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-efb951d8 | this.Load | DM0022_SalesPlanWaterfall.cs:251 | try | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3bef1e39 | this.Load | DM0022_SalesPlanWaterfall.cs:252 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-58435d5d | this.Load | DM0022_SalesPlanWaterfall.cs:255 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6345fbe6 | this.Load | DM0022_SalesPlanWaterfall.cs:255 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd7c8a7b | this.Load | DM0022_SalesPlanWaterfall.cs:256 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-87f0b2af | this.Load | DM0022_SalesPlanWaterfall.cs:267 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-561048de | this.Load | DM0022_SalesPlanWaterfall.cs:268 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6e032b58 | this.Load | DM0022_SalesPlanWaterfall.cs:270 | try | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1ddd695 | this.Load | DM0022_SalesPlanWaterfall.cs:270 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d67aa4e | this.Load | DM0022_SalesPlanWaterfall.cs:271 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3f5647a5 | this.Load | DM0022_SalesPlanWaterfall.cs:279 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bdae0157 | this.Load | DM0022_SalesPlanWaterfall.cs:279 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b08e83eb | this.Load | DM0022_SalesPlanWaterfall.cs:280 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7d1c6dd3 | this.Load | DM0022_SalesPlanWaterfall.cs:282 | try | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-aac01e0a | this.Load | DM0022_SalesPlanWaterfall.cs:282 | try | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2632c4c4 | this.Load | DM0022_SalesPlanWaterfall.cs:283 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b293a59b | this.Load | DM0022_SalesPlanWaterfall.cs:285 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4adcf96 | this.Load | DM0022_SalesPlanWaterfall.cs:286 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dbbdea64 | this.Load | DM0022_SalesPlanWaterfall.cs:299 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-4fe556b9 | this.Load | DM0022_SalesPlanWaterfall.cs:300 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dd9c1f62 | this.Load | DM0022_SalesPlanWaterfall.cs:303 | try | FLAG | dtAmoutKrw | Data.Common(Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 화면 필드/플래그 변경 |  |  |  |
| AC-6124355d | this.Load | DM0022_SalesPlanWaterfall.cs:303 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-205fe1fc | this.Load | DM0022_SalesPlanWaterfall.cs:304 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutKrw, cboKRW, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4e3974a0 | this.Load | DM0022_SalesPlanWaterfall.cs:305 | try | FLAG | dtAmoutUsd | Data.Common(Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 화면 필드/플래그 변경 |  |  |  |
| AC-f08b4a8b | this.Load | DM0022_SalesPlanWaterfall.cs:305 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d98f1cae | this.Load | DM0022_SalesPlanWaterfall.cs:306 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutUsd, cboUSD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-edd76e1e | this.Load | DM0022_SalesPlanWaterfall.cs:307 | try | FLAG | dtAmoutLoc | Data.Common(Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 화면 필드/플래그 변경 |  |  |  |
| AC-a371d2c1 | this.Load | DM0022_SalesPlanWaterfall.cs:307 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e3f99f1 | this.Load | DM0022_SalesPlanWaterfall.cs:308 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutLoc, cboLOC, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-64521ed6 | this.Load | DM0022_SalesPlanWaterfall.cs:311 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6dfcd94 | this.Load | DM0022_SalesPlanWaterfall.cs:312 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-76fb7a15 | this.Load | DM0022_SalesPlanWaterfall.cs:316 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ad4ae6c7 | this.Load | DM0022_SalesPlanWaterfall.cs:320 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c72c1cd1 | this.Load | DM0022_SalesPlanWaterfall.cs:321 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DM0022_SalesPlanWaterfall.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86b23d87 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:380 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-00b0f0f0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:386 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7987588b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:391 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e80703 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:392 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-4f8c4304 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:396 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-31b19b91 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:404 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-04e68be2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:408 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2ad67888 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:383 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a0bd9bce | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:389 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-268a67fe | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:394 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-4810fdf9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:395 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-eed437ed | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:399 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-44c9fc08 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:407 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-3e8d4abf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:411 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0022_SalesPlanWaterfall.InitSpread_X

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / FindButton [try ▸ try ▸ else of ((d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc9b3173 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:437 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a914f2d0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:456 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-b59729e6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:457 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-6fa4ec6c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:458 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1eb7975d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:460 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0022_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0022_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac2a27cb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:460 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0022_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-fcb61400 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:482 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2822340f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:484 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be71eac1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:496 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77d72098 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:507 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59ee9607 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:512 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13f50771 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:514 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14b30411 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:522 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow - 1, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5149125f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:529 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac142a44 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:537 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_DAY"].ToString(), dt.Rows[i]["BASIS_YYYYMMDD"].ToString(), FPMerge.N… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11f4725e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:539 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-fc9f1395 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:541 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SUN") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d26023e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:550 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-283bb548 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:557 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-97febd16 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:563 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89239a8a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:440 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.MEASURE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08284bfa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:459 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-6e596b91 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:460 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-aa59ea20 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:461 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-81185f6e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:463 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0022_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0022_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-84cca0fb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:463 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0022_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-40431075 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:485 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5407e3a1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:487 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5b4c625c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:499 | for (i < dt.Rows.Count) ▸ if (i == 0) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e3d0edb6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:510 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow - 1, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03856666 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:515 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("M_" + sFYear, "M_" + sFYear, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bfd3e25 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:517 | for (i < dt.Rows.Count) ▸ if (sFYear != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iFCow, 2, 1, 25, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32b14901 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:525 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow - 1, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e11a4877 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:532 | for (i < dt.Rows.Count) ▸ if (sFWeek != dt.Rows[i]["COL_WEEK_NAME"].ToString()) | GRID_INIT | siMain.AddNumColumn | ("SUM", "W_" + sFWeek, FPMerge.None, 100, true, FPHAlign.Right, FPVAlign.Center, 2, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b998147 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:540 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["CALENDAR_DAY"].ToString(), dt.Rows[i]["BASIS_YYYYMMDD"].ToString(), FPMerge.N… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab0f4488 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:542 | for (i < dt.Rows.Count) ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-c540c9c9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:544 | for (i < dt.Rows.Count) ▸ else of (dt.Rows[i]["DAYOFWEEK"].ToString() == "SAT") ▸ if (dt.Rows[i]["DAYOFWEEK"].ToString() == "SUN") | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[2, siMain.GetColumnIndex(dt.Rows[i]["BASIS_YYYYMMDD"… | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e550472a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:553 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFCow, 1, iLCow, 25, sYear, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1bf82476 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:560 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWeekFRow, 1, iWeekLRow, 25, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ccb91fa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0022_SalesPlanWaterfall.cs:566 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0022_SalesPlanWaterfall.SetAmountCalculating

진입점: this.cboLOC.SelectedIndexChanged / this.cboKRW.SelectedIndexChanged / this.cboUSD.SelectedIndexChanged / cboKRW.SelectedIndexChanged / cboUSD.SelectedIndexChanged / cboLOC.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7835fdaf | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1721 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-917eb9a5 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1725 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-344c7e1b | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1731 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-ffa73b2e | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1732 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f029f9c5 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1738 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8f95c282 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1740 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-675acccd | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1843 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbKrwDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-d296ac5e | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1845 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbUsdDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-fefc15bd | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1847 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbLocDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-34e180f3 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1853 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3a88454d | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1859 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-6024a7de | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1863 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-9dd4ffb3 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1867 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-dba3cf3c | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1870 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fba6c5c | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1691 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6069b930 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1695 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-56c1a33e | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1701 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-23e4a87e | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1702 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13d6e2bc | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1708 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-02ec78fd | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1710 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3618b0a | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1813 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbKrwDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-f1e743dd | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1815 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbUsdDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-c154dc19 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1817 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbLocDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-830f2c3b | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1823 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac1a1683 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1829 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-9dda354a | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1833 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-1094aeb8 | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1837 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-6d6c028f | this.cboLOC.SelectedIndexChanged 외 6 | DM0022_SalesPlanWaterfall.cs:1840 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0022_SalesPlanWaterfall.SetOriginalData

진입점: FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5353db65 | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:1958 | try | CALL_EXT | conn.Open | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef5dbbdc | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:1960 | try | CALL_EXT | conn.BeginTransaction | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-de08792b | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:1964 | try | CALL_EXT | sqlcmd.ExecuteReader | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f29b7cb5 | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:1966 | try | CALL_EXT | dt.Load | (rd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00a28dc4 | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:1993 | try | ENDPOINT | sqlcmd.ExecuteNonQuery | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-43856600 | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:2014 | try ▸ for (j < ds.Tables[0].Rows.Count) | ENDPOINT | sqlcmd.ExecuteNonQuery | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b7dd5ec7 | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:2017 | try | CALL_EXT | trans.Commit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-32caf769 | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:2018 | try | UI_MISC | sqlcmd.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-13bd3ae8 | FindButton [try ▸ if (dsOrigianlCopy != null) ▸ lambda] | DM0022_SalesPlanWaterfall.cs:2023 | catch () ▸ if (trans != null) | CALL_EXT | trans.Rollback | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0022_SalesPlanWaterfall.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeri…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dbc54ef | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1326 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9ff4b9f1 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1331 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-4eebdc46 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1338 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6f9c4af5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1342 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-30cd6f47 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1347 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-75cb1c66 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1354 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-af5aa51d | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1358 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-70e003c4 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1296 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-31a3f986 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1301 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f6104a08 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1308 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-aab49e4a | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1312 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-39dd9504 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1317 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-22144554 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1324 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a07cd511 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0022_SalesPlanWaterfall.cs:1328 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DM0022_SalesPlanWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f50eaa7 | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1146 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-3b25da52 | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1152 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-7b08be6b | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1168 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-552c2132 | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1182 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df71159d | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1116 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-b2428bda | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1122 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-04782d0c | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1138 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-c14c61af | this.spdMain.CellDoubleClick | DM0022_SalesPlanWaterfall.cs:1152 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0022_SalesPlanWaterfall.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0db7a3b4 | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1128 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-2de2fe5c | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1129 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-12b39be7 | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1131 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-96ba72fb | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1132 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7500d97a | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1098 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-4f615e03 | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1099 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-83c25e50 | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1101 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-4c8fcbbb | this.spdMain.ComboSelChange | DM0022_SalesPlanWaterfall.cs:1102 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0022_SalesPlanWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e61029fd | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1229 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df3d6347 | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1233 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60a7ad86 | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1239 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f45a0ab | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1240 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7df51798 | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1199 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdd4ee48 | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1203 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-618d80d0 | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1209 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcf001a9 | this.spdMain.KeyUp | DM0022_SalesPlanWaterfall.cs:1210 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0022_SalesPlanWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d410ed26 | this.spdMain.TopChange | DM0022_SalesPlanWaterfall.cs:1223 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aebe5c6f | this.spdMain.TopChange | DM0022_SalesPlanWaterfall.cs:1193 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

