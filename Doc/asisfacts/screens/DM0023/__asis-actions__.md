# AS-IS 액션 대조표 — DM0023

> 원천: `Doc/asisfacts/screens/DM0023/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 266행 · 메서드 44 · 종류 DATA_OP 50 · RETURN 41 · FLAG 36 · ENDPOINT 33 · LIST_REBIND 16 · POPUP 15 · COMBO_DATA 12 · GRID_INIT 12 · CALL_EXT 10 · UI_PROP 9 · GRID_SET 7 · UI_MISC 6 · VALUE_SET 5 · MESSAGE 5 · THROW 4 · GRID_COMBO 2 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 10


## DM0023_SalesPlanReport.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-676b2ca3 | this.btnColumn.Click | DM0023_SalesPlanReport.cs:1307 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF1010", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-068d2ff4 | this.btnColumn.Click | DM0023_SalesPlanReport.cs:1308 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dd438863 | this.btnColumn.Click | DM0023_SalesPlanReport.cs:1309 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0023_SalesPlanReport.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ee00211 | this.btnItemId.Click 외 1 | DM0023_SalesPlanReport.cs:1296 |  | POPUP | new SCM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-c6debf33 | this.btnItemId.Click 외 1 | DM0023_SalesPlanReport.cs:1298 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-49651b79 | this.btnItemId.Click 외 1 | DM0023_SalesPlanReport.cs:1299 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1f554a60 | this.btnItemId.Click 외 1 | DM0023_SalesPlanReport.cs:1300 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-340b16d3 | this.btnItemId.Click 외 1 | DM0023_SalesPlanReport.cs:1302 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DM0023_SalesPlanReport.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2247d261 | this.btnMeasure.Click | DM0023_SalesPlanReport.cs:1319 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DMF1010", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-dbdd50ec | this.btnMeasure.Click | DM0023_SalesPlanReport.cs:1320 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-19c3e9a3 | this.btnMeasure.Click | DM0023_SalesPlanReport.cs:1321 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0023_SalesPlanReport.btnProject_Click

진입점: this.btnProject.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3555d0d5 | this.btnProject.Click 외 1 | DM0023_SalesPlanReport.cs:1278 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-ef2af352 | this.btnProject.Click 외 1 | DM0023_SalesPlanReport.cs:1279 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-068722cb | this.btnProject.Click 외 1 | DM0023_SalesPlanReport.cs:1280 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fc066bd1 | this.btnProject.Click 외 1 | DM0023_SalesPlanReport.cs:1281 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9fc55262 | this.btnProject.Click 외 1 | DM0023_SalesPlanReport.cs:1283 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0023_SalesPlanReport.btnVersion_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d63ef1f2 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1802 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a05588de | (진입점 미연결) | DM0023_SalesPlanReport.cs:1803 |  | POPUP | popVersion.Form_Load | (true, "SP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d229d2b6 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1804 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dc05b82e | (진입점 미연결) | DM0023_SalesPlanReport.cs:1805 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4a71078b | (진입점 미연결) | DM0023_SalesPlanReport.cs:1810 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DM0023_SalesPlanReport.cboKRW_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ca01204 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1707 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.cboLOC_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ac9d7f0 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1728 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.cboUSD_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-638392fe | (진입점 미연결) | DM0023_SalesPlanReport.cs:1718 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23c7e2d8 | this.clbCustomer.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1696 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a66aed3 | this.clbCustomer.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1698 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9c25b65 | this.clbCustomer.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1700 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-da4d6f40 | this.clbCustomer.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1700 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b1d70046 | this.clbCustomer.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1701 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0023_SalesPlanReport.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7d26598 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1015 | try ▸ if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ea4c5da | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1017 | try ▸ if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eba16929 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1023 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b89cba02 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1026 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6ba1cbc5 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1045 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-d690de47 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1045 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96d68056 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1046 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-49002769 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1050 | try | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-fdfc1a09 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1050 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6df574ae | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1051 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c422c2de | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1055 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9a6b7b94 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1055 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97f21937 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1056 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5a634aed | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1058 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba43e9fb | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1058 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-858fe141 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1059 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5b332ce8 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1061 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-5993513a | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1062 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d782bbb6 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1078 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5c30be51 | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1079 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-ef4622fd | clbDivision.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1083 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DM0023_SalesPlanReport.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e5beb20 | clbPlantSite.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1103 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e5e12b2 | clbPlantSite.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1105 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.ClbSalesSite_SelectedIndexChanged

진입점: clbSalesSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2193b89f | clbSalesSite.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1092 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb255798 | clbSalesSite.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1094 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df9178b9 | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1739 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba0f3ab6 | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1741 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f6da43d | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1746 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b1bc1a9 | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1746 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-669c9eaa | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1747 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7f739927 | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1751 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-01f2dc38 | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1751 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5728b81d | this.clbTeam.SelectedIndexChanged | DM0023_SalesPlanReport.cs:1752 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0023_SalesPlanReport.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-496aa0db | this.Load | DM0023_SalesPlanReport.cs:337 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b45ef714 | this.Load | DM0023_SalesPlanReport.cs:338 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a3083bf9 | this.Load | DM0023_SalesPlanReport.cs:339 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0023_SalesPlanReport.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e1d3f84 | this.Load | DM0023_SalesPlanReport.cs:308 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-20d319f3 | this.Load | DM0023_SalesPlanReport.cs:309 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-b35d823a | this.Load | DM0023_SalesPlanReport.cs:312 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-13e625d5 | this.Load | DM0023_SalesPlanReport.cs:313 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DM0023_SalesPlanReport.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7e22fd3 | Dispose | DM0023_SalesPlanReport.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0023_SalesPlanReport.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb6fe42d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0023_SalesPlanReport.cs:553 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-63ca3bef | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0023_SalesPlanReport.cs:554 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0c8aa20 | FindButton | DM0023_SalesPlanReport.cs:569 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-31357d27 | FindButton | DM0023_SalesPlanReport.cs:576 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bfd71666 | FindButton | DM0023_SalesPlanReport.cs:577 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58bd3a21 | FindButton | DM0023_SalesPlanReport.cs:580 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bf84fac7 | FindButton | DM0023_SalesPlanReport.cs:582 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b7ed6c4d | FindButton | DM0023_SalesPlanReport.cs:582 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fd84d55 | FindButton | DM0023_SalesPlanReport.cs:592 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e6d642b | FindButton | DM0023_SalesPlanReport.cs:593 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b173e356 | FindButton | DM0023_SalesPlanReport.cs:599 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-172b18ba | FindButton | DM0023_SalesPlanReport.cs:601 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-fcb04a1d | FindButton | DM0023_SalesPlanReport.cs:603 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5441399 | FindButton | DM0023_SalesPlanReport.cs:607 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89d49961 | FindButton | DM0023_SalesPlanReport.cs:609 | try | CALL_EXT | drpPeriod.Value2.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d39f74b | FindButton | DM0023_SalesPlanReport.cs:628 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-263b9391 | FindButton | DM0023_SalesPlanReport.cs:629 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d2d3aef | FindButton | DM0023_SalesPlanReport.cs:633 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ec61765f | FindButton | DM0023_SalesPlanReport.cs:647 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-61d411a5 | FindButton | DM0023_SalesPlanReport.cs:648 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-909a84d4 | FindButton | DM0023_SalesPlanReport.cs:676 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM_H.DM0021_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT") ⇒ DM_H.DM0021_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-b2b803b4 | FindButton | DM0023_SalesPlanReport.cs:677 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cb0975fc | FindButton | DM0023_SalesPlanReport.cs:679 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-436843eb | FindButton | DM0023_SalesPlanReport.cs:680 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-2a6f2bf1 | FindButton | DM0023_SalesPlanReport.cs:681 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-d034ddb3 | FindButton | DM0023_SalesPlanReport.cs:682 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf2be1b7 | FindButton | DM0023_SalesPlanReport.cs:683 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-79d905dd | FindButton | DM0023_SalesPlanReport.cs:684 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f095c6e | FindButton | DM0023_SalesPlanReport.cs:685 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-d2ba711b | FindButton | DM0023_SalesPlanReport.cs:688 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-af23305c | FindButton | DM0023_SalesPlanReport.cs:689 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-2007d229 | FindButton | DM0023_SalesPlanReport.cs:690 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-7612368d | FindButton | DM0023_SalesPlanReport.cs:691 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-843bec0a | FindButton | DM0023_SalesPlanReport.cs:692 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2774d324 | FindButton | DM0023_SalesPlanReport.cs:693 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-5d1ad7bb | FindButton | DM0023_SalesPlanReport.cs:694 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e6c9ba2e | FindButton | DM0023_SalesPlanReport.cs:695 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25b7d6a9 | FindButton | DM0023_SalesPlanReport.cs:697 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8f6d332b | FindButton | DM0023_SalesPlanReport.cs:702 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c30e64a3 | FindButton | DM0023_SalesPlanReport.cs:705 | try | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1deae592 | FindButton | DM0023_SalesPlanReport.cs:707 | try | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4094ef7d | FindButton | DM0023_SalesPlanReport.cs:709 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9851642c | FindButton | DM0023_SalesPlanReport.cs:710 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-03b5d72b | FindButton | DM0023_SalesPlanReport.cs:713 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-956bf97e | FindButton | DM0023_SalesPlanReport.cs:971 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c803cd6f | FindButton | DM0023_SalesPlanReport.cs:992 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-df8a04c5 | FindButton | DM0023_SalesPlanReport.cs:996 | catch ((Exception ex)) ▸ if (this.Visible) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-c9a12f12 | FindButton | DM0023_SalesPlanReport.cs:1000 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-108c2c30 | FindButton | DM0023_SalesPlanReport.cs:1001 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ea84159e | FindButton | DM0023_SalesPlanReport.cs:1002 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0023_SalesPlanReport.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ced4141 | this.Load | DM0023_SalesPlanReport.cs:174 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-faee59e6 | this.Load | DM0023_SalesPlanReport.cs:180 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0023_SalesPlanReport.GetBizTypebyDivision

진입점: this.Load [try] / clbDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8625076 | this.Load [try] 외 1 | DM0023_SalesPlanReport.cs:1620 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-30dc5edc | this.Load [try] 외 1 | DM0023_SalesPlanReport.cs:1621 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-43f8e4d0 | this.Load [try] 외 1 | DM0023_SalesPlanReport.cs:1622 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cfad0ee7 | this.Load [try] 외 1 | DM0023_SalesPlanReport.cs:1625 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetBizTypebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe852437 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1634 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-93b4c470 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1635 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a9c9e12c | (진입점 미연결) | DM0023_SalesPlanReport.cs:1636 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54b84d06 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1639 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1c1b89f | this.Load [try] | DM0023_SalesPlanReport.cs:1522 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-6ee4f0fa | this.Load [try] | DM0023_SalesPlanReport.cs:1523 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57064146 | this.Load [try] | DM0023_SalesPlanReport.cs:1526 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c00ef605 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1583 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-219fc5c7 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1584 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fb604f2c | (진입점 미연결) | DM0023_SalesPlanReport.cs:1585 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-83a39c27 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1586 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee33ccc0 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1589 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetCustomerbyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6078104e | (진입점 미연결) | DM0023_SalesPlanReport.cs:1598 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b32c75ff | (진입점 미연결) | DM0023_SalesPlanReport.cs:1599 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-31549532 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1600 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f7aa6d29 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1601 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07afdfb2 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1604 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetDataTableMeargeForDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74ad1ba4 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1761 |  | CALL_EXT | sv.GetArray | (0, 0, sv.RowCount - 1, sv.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a49ddb79 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1778 | for (i < sv.ColumnCount) | DATA_OP | table.Columns.Add | (sFieldName, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bb95e69 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1780 |  | DATA_OP | ds2.Tables.Add | (table) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce7349e1 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1784 |  | DATA_OP | ds.Tables[0].Merge | (ds2.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-532649df | (진입점 미연결) | DM0023_SalesPlanReport.cs:1786 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetDayRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae5578ef | this.Load [try] | DM0023_SalesPlanReport.cs:1473 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-dc3bcc6a | this.Load [try] | DM0023_SalesPlanReport.cs:1474 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-73f3b497 | this.Load [try] | DM0023_SalesPlanReport.cs:1475 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-db82bfb8 | this.Load [try] | DM0023_SalesPlanReport.cs:1477 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3bc1a06 | this.Load [try] | DM0023_SalesPlanReport.cs:1480 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afe0a7a6 | this.Load [try] | DM0023_SalesPlanReport.cs:1535 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-550b811d | this.Load [try] | DM0023_SalesPlanReport.cs:1536 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-70157487 | this.Load [try] | DM0023_SalesPlanReport.cs:1537 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5b93a5d2 | this.Load [try] | DM0023_SalesPlanReport.cs:1540 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetLastWeekSunDayByDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b2ed6ab | (진입점 미연결) | DM0023_SalesPlanReport.cs:1689 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d46c251f | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1434 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-c732fa6f | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1435 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5e5230b9 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1436 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-78f205a4 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1437 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-85604b65 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1438 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-97523b27 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1441 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetPlantSitebyEndCustomerAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0bd342d | (진입점 미연결) | DM0023_SalesPlanReport.cs:1450 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-55f7f785 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1451 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-32fa2327 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1452 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-c4f657b5 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1453 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-4615d88d | (진입점 미연결) | DM0023_SalesPlanReport.cs:1454 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b0a0a757 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1457 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a51df1 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1394 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-299efd9b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1395 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d23bd31d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1396 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-e3e003aa | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1397 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-1078ee0b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1398 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5352fa0 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0023_SalesPlanReport.cs:1401 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetScmSitebyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce38a125 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1410 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-db69d6d5 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1411 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6cdad49d | (진입점 미연결) | DM0023_SalesPlanReport.cs:1412 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-3a559809 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1413 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-328181b1 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1414 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-324bee49 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1417 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / FindButton [try ▸ try ▸ else of ((d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88fab53d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:1504 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0023_GET_SPREAD_TITLE") ⇒ DM_H.DM0023_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-91caef68 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:1505 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-fbdf3896 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:1506 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-a57a92c7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:1507 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f67533f4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:1511 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c832cc5c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:1511 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c3c78ca | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:1514 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f744a09d | (진입점 미연결) | DM0023_SalesPlanReport.cs:1550 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-e9546b93 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1551 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4907b275 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1552 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8885100b | (진입점 미연결) | DM0023_SalesPlanReport.cs:1555 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetTeambyDivisionAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30bd76d6 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1564 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9e708a0d | (진입점 미연결) | DM0023_SalesPlanReport.cs:1565 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dca647b9 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1566 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e1744ec5 | (진입점 미연결) | DM0023_SalesPlanReport.cs:1568 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b060925 | FindButton [try] | DM0023_SalesPlanReport.cs:1666 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8368eed | this.Load | DM0023_SalesPlanReport.cs:197 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-048ce570 | this.Load | DM0023_SalesPlanReport.cs:198 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-116a1442 | this.Load | DM0023_SalesPlanReport.cs:200 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-838372b4 | this.Load | DM0023_SalesPlanReport.cs:230 | try | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-195fcb78 | this.Load | DM0023_SalesPlanReport.cs:230 | try | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e78308c1 | this.Load | DM0023_SalesPlanReport.cs:231 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57de9123 | this.Load | DM0023_SalesPlanReport.cs:234 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-11594fea | this.Load | DM0023_SalesPlanReport.cs:234 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2654f67d | this.Load | DM0023_SalesPlanReport.cs:235 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d514826a | this.Load | DM0023_SalesPlanReport.cs:246 | try | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-1020e0d4 | this.Load | DM0023_SalesPlanReport.cs:247 | try | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e075001b | this.Load | DM0023_SalesPlanReport.cs:249 | try | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-bb42149e | this.Load | DM0023_SalesPlanReport.cs:249 | try | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8db62558 | this.Load | DM0023_SalesPlanReport.cs:250 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-84726704 | this.Load | DM0023_SalesPlanReport.cs:258 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4988d7d0 | this.Load | DM0023_SalesPlanReport.cs:258 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-597882f1 | this.Load | DM0023_SalesPlanReport.cs:259 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4ccaa156 | this.Load | DM0023_SalesPlanReport.cs:261 | try | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-d01e2160 | this.Load | DM0023_SalesPlanReport.cs:261 | try | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9eb7400f | this.Load | DM0023_SalesPlanReport.cs:262 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-48348160 | this.Load | DM0023_SalesPlanReport.cs:264 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-cbf63e80 | this.Load | DM0023_SalesPlanReport.cs:265 | try | FLAG | dtBucketType | dtBucketType.Select("CODE <> 'DAILY'", "CODE DESC").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-00e61399 | this.Load | DM0023_SalesPlanReport.cs:265 | try | DATA_OP | dtBucketType.Select("CODE <> 'DAILY'", "CODE DESC").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-218e35d9 | this.Load | DM0023_SalesPlanReport.cs:265 | try | DATA_OP | dtBucketType.Select | ("CODE <> 'DAILY'", "CODE DESC") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd924aec | this.Load | DM0023_SalesPlanReport.cs:266 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5a77c2d7 | this.Load | DM0023_SalesPlanReport.cs:279 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-0bfbea24 | this.Load | DM0023_SalesPlanReport.cs:280 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e4c704a2 | this.Load | DM0023_SalesPlanReport.cs:291 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a589a28 | this.Load | DM0023_SalesPlanReport.cs:292 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac050b9c | this.Load | DM0023_SalesPlanReport.cs:296 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-f2f0171a | this.Load | DM0023_SalesPlanReport.cs:300 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-62cededc | this.Load | DM0023_SalesPlanReport.cs:301 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DM0023_SalesPlanReport.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-620b58f1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:363 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9bac5755 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:369 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d6c6c2f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:374 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-705214ed | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:375 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-d675f3d6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:379 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-4f6d3410 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:387 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-02d2dd0d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:391 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0023_SalesPlanReport.InitSpread_X

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / FindButton [try ▸ try ▸ else of ((d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b77e4aba | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:421 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-155cfb00 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:440 |  | DATA_OP | nvc["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-f6d5799e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:441 |  | DATA_OP | nvc["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-fffdd28d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:442 |  | DATA_OP | nvc["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c20aa113 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:444 |  | ENDPOINT | (new CUIControl()).GetDataUsingByDBEx | ("DM_H.DM0023_GET_SPREAD_TITLE_DATE", nvc) ⇒ DM_H.DM0023_GET_SPREAD_TITLE_DATE | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d55a6cbc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:444 |  | ENDPOINT | new CUIControl | () ⇒ DM_H.DM0023_GET_SPREAD_TITLE_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-73ec5131 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:467 | for (i < dt.Rows.Count) | GRID_INIT | siMain.AddNumColumn | (dt.Rows[i]["COLUMN_LABEL_NAME"].ToString(), dt.Rows[i]["NEWCOLLIST"].ToString(), FPMerge.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25a37c18 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:481 | for (i < dt.Rows.Count) ▸ if (sWeek != dt.Rows[i]["WEEK_NAME"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWFRow, 1, iWLRow - 1, 25, sWeek, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8567ca5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:489 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iWFRow, 1, iWLRow, 25, sWeek, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d74e0f70 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:497 | for (i < dt.Rows.Count) ▸ if (sMonth != dt.Rows[i]["BASIS_YYYYMM"].ToString()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow - 1, 25, _Month, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff2f134b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:505 | for (i < dt.Rows.Count) ▸ if (i == dt.Rows.Count - 1) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iFRow, 1, iLRow, 25, _Month, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7018c41 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0023_SalesPlanReport.cs:512 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.SALES_PLAN_ADJUST_YN) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0023_SalesPlanReport.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToStr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-246e4844 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0023_SalesPlanReport.cs:1362 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b2540efe | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0023_SalesPlanReport.cs:1366 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (siMain.GetColumnTag(iCol).IndexO… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-984a8c08 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0023_SalesPlanReport.cs:1378 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == B… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-82141077 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0023_SalesPlanReport.cs:1382 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == B… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DM0023_SalesPlanReport.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b0b7c2c | this.spdMain.CellDoubleClick | DM0023_SalesPlanReport.cs:1170 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-13eff5d6 | this.spdMain.CellDoubleClick | DM0023_SalesPlanReport.cs:1176 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-4fc34380 | this.spdMain.CellDoubleClick | DM0023_SalesPlanReport.cs:1192 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-264f3492 | this.spdMain.CellDoubleClick | DM0023_SalesPlanReport.cs:1206 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0023_SalesPlanReport.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-395c08d2 | this.spdMain.ComboSelChange | DM0023_SalesPlanReport.cs:1152 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-fde01e31 | this.spdMain.ComboSelChange | DM0023_SalesPlanReport.cs:1153 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-15ed79a8 | this.spdMain.ComboSelChange | DM0023_SalesPlanReport.cs:1155 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-df87f726 | this.spdMain.ComboSelChange | DM0023_SalesPlanReport.cs:1156 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0023_SalesPlanReport.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d98132d3 | this.spdMain.KeyUp | DM0023_SalesPlanReport.cs:1253 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f24a68a9 | this.spdMain.KeyUp | DM0023_SalesPlanReport.cs:1257 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0ce85b7 | this.spdMain.KeyUp | DM0023_SalesPlanReport.cs:1263 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7625ee16 | this.spdMain.KeyUp | DM0023_SalesPlanReport.cs:1264 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0023_SalesPlanReport.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c70034ae | this.spdMain.TopChange | DM0023_SalesPlanReport.cs:1247 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

