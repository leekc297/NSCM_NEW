# AS-IS 액션 대조표 — DM0035

> 원천: `Doc/asisfacts/screens/DM0035/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 465행 · 메서드 71 · 종류 DATA_OP 60 · FLAG 55 · RETURN 42 · ENDPOINT 42 · POPUP 41 · GRID_INIT 40 · LIST_REBIND 39 · COMBO_DATA 33 · GRID_SET 26 · UI_PROP 23 · VALUE_SET 14 · UI_MISC 10 · CALL_EXT 10 · MESSAGE 8 · STATE 8 · GRID_STYLE 4 · GRID_COMBO 4 · VALIDATE 2 · GRID_BIND 2 · GRID_LOCK 2 · ⚠ 의미 확인 필요 10


## DM0035_MktFcstWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e86c42e8 | this.btnColumn.Click | DM0035_MktFcstWaterfall.cs:863 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DM0035", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-a41f6338 | this.btnColumn.Click | DM0035_MktFcstWaterfall.cs:864 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d6762fcd | this.btnColumn.Click | DM0035_MktFcstWaterfall.cs:865 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0035_MktFcstWaterfall.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34933930 | this.btnItemId.Click | DM0035_MktFcstWaterfall.cs:847 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0fcd83a6 | this.btnItemId.Click | DM0035_MktFcstWaterfall.cs:849 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7815eeaa | this.btnItemId.Click | DM0035_MktFcstWaterfall.cs:850 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ffd49cc6 | this.btnItemId.Click | DM0035_MktFcstWaterfall.cs:851 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8452d20a | this.btnItemId.Click | DM0035_MktFcstWaterfall.cs:857 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfall.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f659af6 | this.btnMeasure.Click | DM0035_MktFcstWaterfall.cs:875 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("DM0035", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-b3805bf9 | this.btnMeasure.Click | DM0035_MktFcstWaterfall.cs:876 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9b1ee352 | this.btnMeasure.Click | DM0035_MktFcstWaterfall.cs:877 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0035_MktFcstWaterfall.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-669cee58 | this.btnProject.Click | DM0035_MktFcstWaterfall.cs:826 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-63d473e9 | this.btnProject.Click | DM0035_MktFcstWaterfall.cs:828 |  | POPUP | popProject.Form_Load | (true, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f936a43b | this.btnProject.Click | DM0035_MktFcstWaterfall.cs:829 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bd108b50 | this.btnProject.Click | DM0035_MktFcstWaterfall.cs:830 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-966f1a07 | this.btnProject.Click | DM0035_MktFcstWaterfall.cs:836 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a923474 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfall.cs:1147 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1827849e | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfall.cs:1148 |  | POPUP | popVersion.Form_Load | (true, "MF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-50ff12d4 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfall.cs:1149 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-93277bd8 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfall.cs:1150 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7e59cd48 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfall.cs:1154 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-bfced364 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfall.cs:1155 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-790a093e | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:642 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-45df4ef2 | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:642 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d08af702 | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:643 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0035_MktFcstWaterfall.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f84910 | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:593 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-cd201a9e | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:593 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93a54301 | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:594 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4f0e3bcf | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:598 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-284b9f70 | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:598 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb7066c4 | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:599 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-66c09a41 | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:603 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c2c0ac4c | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:603 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d5780fc0 | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:604 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-93bf170a | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:606 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-0460e1b7 | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:606 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-51ee3f6f | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:607 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9204ed8d | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:609 |  | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-523b756d | clbDivision.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:610 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0035_MktFcstWaterfall.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3ad94da | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:620 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7fd8bceb | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:620 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6cf4292b | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:621 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-595f54c1 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:625 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6287df43 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:625 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5b33156 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:626 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6646e01c | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:628 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-2b42ee7d | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:628 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-98484e8b | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:629 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a35b8cc4 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:631 |  | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c404e64 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfall.cs:632 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0035_MktFcstWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35fc28ad | this.Load | DM0035_MktFcstWaterfall.cs:225 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0424d833 | this.Load | DM0035_MktFcstWaterfall.cs:226 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e966e302 | this.Load | DM0035_MktFcstWaterfall.cs:227 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0035_MktFcstWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05bb37d4 | this.Load | DM0035_MktFcstWaterfall.cs:219 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-efa5f660 | this.Load | DM0035_MktFcstWaterfall.cs:220 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f47546f1 | Dispose | DM0035_MktFcstWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0035_MktFcstWaterfall.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa00cc5a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0035_MktFcstWaterfall.cs:384 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97cffd20 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | DM0035_MktFcstWaterfall.cs:385 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7efb3be | FindButton | DM0035_MktFcstWaterfall.cs:401 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-17e644be | FindButton | DM0035_MktFcstWaterfall.cs:401 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58ca6650 | FindButton | DM0035_MktFcstWaterfall.cs:405 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-64fcb475 | FindButton | DM0035_MktFcstWaterfall.cs:412 | if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10aa41c0 | FindButton | DM0035_MktFcstWaterfall.cs:414 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3934baa8 | FindButton | DM0035_MktFcstWaterfall.cs:421 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9cced1fa | FindButton | DM0035_MktFcstWaterfall.cs:422 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d9fbf39 | FindButton | DM0035_MktFcstWaterfall.cs:427 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d59547e | FindButton | DM0035_MktFcstWaterfall.cs:429 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-3a391e8b | FindButton | DM0035_MktFcstWaterfall.cs:431 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e98ca260 | FindButton | DM0035_MktFcstWaterfall.cs:441 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4589c46b | FindButton | DM0035_MktFcstWaterfall.cs:445 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0035_GET_MKT_FCST_WATERFALL") ⇒ DM.DM0035_GET_MKT_FCST_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-1a98e015 | FindButton | DM0035_MktFcstWaterfall.cs:447 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e033c18a | FindButton | DM0035_MktFcstWaterfall.cs:449 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e577bf7b | FindButton | DM0035_MktFcstWaterfall.cs:450 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-092c2c3f | FindButton | DM0035_MktFcstWaterfall.cs:451 | lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5f274780 | FindButton | DM0035_MktFcstWaterfall.cs:452 | lambda | DATA_OP | request.Parameters["p_team_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-bd1af052 | FindButton | DM0035_MktFcstWaterfall.cs:453 | lambda | DATA_OP | request.Parameters["p_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8fcbb982 | FindButton | DM0035_MktFcstWaterfall.cs:454 | lambda | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-32ccecdc | FindButton | DM0035_MktFcstWaterfall.cs:455 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5e2b703b | FindButton | DM0035_MktFcstWaterfall.cs:456 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-f2a7bd85 | FindButton | DM0035_MktFcstWaterfall.cs:457 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-c9901af5 | FindButton | DM0035_MktFcstWaterfall.cs:458 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-2efa6f7d | FindButton | DM0035_MktFcstWaterfall.cs:459 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f4e168b1 | FindButton | DM0035_MktFcstWaterfall.cs:460 | lambda | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-75074042 | FindButton | DM0035_MktFcstWaterfall.cs:461 | lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ac77c5be | FindButton | DM0035_MktFcstWaterfall.cs:462 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7f23ac5 | FindButton | DM0035_MktFcstWaterfall.cs:464 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f486b366 | FindButton | DM0035_MktFcstWaterfall.cs:507 | if (ds.Tables[0] != null) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-75c757d9 | FindButton | DM0035_MktFcstWaterfall.cs:515 | if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-82e3fc0c | FindButton | DM0035_MktFcstWaterfall.cs:515 | if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ea6baa0 | FindButton | DM0035_MktFcstWaterfall.cs:521 | if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8e80cce4 | FindButton | DM0035_MktFcstWaterfall.cs:522 | if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b845b9a | FindButton | DM0035_MktFcstWaterfall.cs:523 | if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2acfae26 | FindButton | DM0035_MktFcstWaterfall.cs:535 | if (siMain.GetMaxRowIndex() > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-944898f5 | FindButton | DM0035_MktFcstWaterfall.cs:537 | if (siMain.GetMaxRowIndex() > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9e6a12be | FindButton | DM0035_MktFcstWaterfall.cs:568 | for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-9f8caac1 | FindButton | DM0035_MktFcstWaterfall.cs:569 | for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iResultMonth, i, iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-0134fddc | FindButton | DM0035_MktFcstWaterfall.cs:581 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0035_MktFcstWaterfall.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7771a0ff | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:985 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-fbc94201 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:989 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6d9a17b | this.Load | DM0035_MktFcstWaterfall.cs:157 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e074206f | this.Load | DM0035_MktFcstWaterfall.cs:158 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0035_MktFcstWaterfall.GetBizTypebyDivision

진입점: this.clbTeam.SelectedIndexChanged / this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6215c64f | this.clbTeam.SelectedIndexChanged 외 2 | DM0035_MktFcstWaterfall.cs:1132 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-8a9c2804 | this.clbTeam.SelectedIndexChanged 외 2 | DM0035_MktFcstWaterfall.cs:1133 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9353744d | this.clbTeam.SelectedIndexChanged 외 2 | DM0035_MktFcstWaterfall.cs:1134 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8aff4ffe | this.clbTeam.SelectedIndexChanged 외 2 | DM0035_MktFcstWaterfall.cs:1137 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8293bc23 | this.Load | DM0035_MktFcstWaterfall.cs:1075 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-0a15cf0b | this.Load | DM0035_MktFcstWaterfall.cs:1076 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-22c64250 | this.Load | DM0035_MktFcstWaterfall.cs:1079 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a895276 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1117 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7444bf92 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1118 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-cfae5078 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1119 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-c4f0d2d2 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1120 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30e9de89 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1123 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3738429d | this.Load | DM0035_MktFcstWaterfall.cs:1047 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72a8ec18 | this.Load | DM0035_MktFcstWaterfall.cs:1052 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6a622e5 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:998 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c4f34bb6 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1000 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eba790b0 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1003 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a79befd7 | this.Load | DM0035_MktFcstWaterfall.cs:1088 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-7aef1374 | this.Load | DM0035_MktFcstWaterfall.cs:1089 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-60d75e77 | this.Load | DM0035_MktFcstWaterfall.cs:1090 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc772ee1 | this.Load | DM0035_MktFcstWaterfall.cs:1093 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetLastWeekSunDayByDate

진입점: FindButton [for (i <= siMain.GetMaxRowIndex()) ▸ else of (sVersion.ToUpper() == "CURRENT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c99eb85 | FindButton [for (i <= siMain.GetMaxRowIndex()) ▸ else of (sV… | DM0035_MktFcstWaterfall.cs:1205 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e446abe | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1028 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-06fde57a | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1029 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a4e1583b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1030 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9f66093a | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1031 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-0194a870 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1032 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-81eb4e91 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1035 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57eb54d7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1012 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-07952979 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1013 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4bead799 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1014 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-9b69cc07 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1015 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-8235c5a1 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1016 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-718095df | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfall.cs:1019 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d24e2a6d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:1061 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0035_GET_SPREAD_TITLE") ⇒ DM.DM0035_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-2152b70b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:1062 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-34ee7237 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:1063 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-cc764a21 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:1064 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4151d5c5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:1066 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-898a33b0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:1066 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DM0035_MktFcstWaterfall.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af27e8fd | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1103 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5dedc869 | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1104 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f8291d9c | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1105 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b9e5c1b | (진입점 미연결) | DM0035_MktFcstWaterfall.cs:1108 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.GetThisWeekMonday

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49a20369 | FindButton | DM0035_MktFcstWaterfall.cs:1175 | while (true) ▸ if (dtStart.DayOfWeek == DayOfWeek.Monday) | FLAG | thisWeekDate | dtStart | 화면 필드/플래그 변경 |  |  |  |
| AC-4126531b | FindButton | DM0035_MktFcstWaterfall.cs:1182 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ffec6c7 | this.Load | DM0035_MktFcstWaterfall.cs:171 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3791ef9 | this.Load | DM0035_MktFcstWaterfall.cs:171 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9dee0dc8 | this.Load | DM0035_MktFcstWaterfall.cs:172 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6cba2293 | this.Load | DM0035_MktFcstWaterfall.cs:177 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-c37ec6bf | this.Load | DM0035_MktFcstWaterfall.cs:177 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3ca4bf40 | this.Load | DM0035_MktFcstWaterfall.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4bb5e640 | this.Load | DM0035_MktFcstWaterfall.cs:182 |  | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-abd6b98b | this.Load | DM0035_MktFcstWaterfall.cs:182 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d83414f | this.Load | DM0035_MktFcstWaterfall.cs:183 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b1e50b38 | this.Load | DM0035_MktFcstWaterfall.cs:185 |  | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-307021d5 | this.Load | DM0035_MktFcstWaterfall.cs:186 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0392204b | this.Load | DM0035_MktFcstWaterfall.cs:190 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-85e4f4d1 | this.Load | DM0035_MktFcstWaterfall.cs:190 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-103076be | this.Load | DM0035_MktFcstWaterfall.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ace4f945 | this.Load | DM0035_MktFcstWaterfall.cs:193 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-44d386f3 | this.Load | DM0035_MktFcstWaterfall.cs:193 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b8c886b1 | this.Load | DM0035_MktFcstWaterfall.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-189cb62c | this.Load | DM0035_MktFcstWaterfall.cs:196 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-16e8bfb5 | this.Load | DM0035_MktFcstWaterfall.cs:197 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d469c1c7 | this.Load | DM0035_MktFcstWaterfall.cs:207 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-490d9fdb | this.Load | DM0035_MktFcstWaterfall.cs:209 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a378cef0 | this.Load | DM0035_MktFcstWaterfall.cs:210 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5e2e5d87 | this.Load | DM0035_MktFcstWaterfall.cs:213 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1c02ef0 | this.Load | DM0035_MktFcstWaterfall.cs:214 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |

## DM0035_MktFcstWaterfall.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ff5af11 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:235 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0035_MktFcstWaterfall.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e291cd7b | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0035_MktFcstWaterfall.cs:906 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c46e5058 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0035_MktFcstWaterfall.cs:911 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-4bcb3ec3 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0035_MktFcstWaterfall.cs:918 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-efa6190d | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0035_MktFcstWaterfall.cs:922 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3fa87874 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0035_MktFcstWaterfall.cs:927 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-50948de5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0035_MktFcstWaterfall.cs:934 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b98d4f1a | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | DM0035_MktFcstWaterfall.cs:938 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DM0035_MktFcstWaterfall.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [if (dtTitle != null && dtTitle.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-165e477f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:271 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cfddb8e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:279 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c5b55c72 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:292 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-60f8fa31 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:311 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1d97293e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:312 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f1ba72b1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:317 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94680e33 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:318 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e25f954 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:325 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a4455ac | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:326 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9ea2182 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:337 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f842c69d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:338 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e579d401 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:339 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2eb15138 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:340 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8015725 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:342 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-28e3015f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 3 | DM0035_MktFcstWaterfall.cs:343 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0035_MktFcstWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80040070 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:720 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-9901484b | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:726 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-dc82da94 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:742 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-b9c07069 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:756 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-521f1be0 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:764 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d34ebc53 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:766 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-02cee56b | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:767 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-60f25fce | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:768 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4170440b | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:772 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-bacd0719 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:781 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dac9fd88 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:783 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.Form_Load | (false, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-20bb5c36 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:784 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7e8fe269 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:785 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8f2c3915 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfall.cs:789 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |

## DM0035_MktFcstWaterfall.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-721a929f | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfall.cs:702 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-be847185 | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfall.cs:703 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9330deb5 | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfall.cs:705 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-e2d82e11 | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfall.cs:706 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0035_MktFcstWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b5d3778 | this.spdMain.KeyUp | DM0035_MktFcstWaterfall.cs:803 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd8de253 | this.spdMain.KeyUp | DM0035_MktFcstWaterfall.cs:807 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dff990c | this.spdMain.KeyUp | DM0035_MktFcstWaterfall.cs:813 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-845cb92c | this.spdMain.KeyUp | DM0035_MktFcstWaterfall.cs:814 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0035_MktFcstWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cf84bdb | this.spdMain.TopChange | DM0035_MktFcstWaterfall.cs:797 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0035_MktFcstWaterfallTest96.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a586292a | this.btnColumn.Click | DM0035_MktFcstWaterfallTest96.cs:956 |  | POPUP | new SCM0002_TitleSetForm_Popup_test | ("DM0035_TEST", SpdSheet.shtMain, true, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-3f7ec6ba | this.btnColumn.Click | DM0035_MktFcstWaterfallTest96.cs:957 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-09b9cbf3 | this.btnColumn.Click | DM0035_MktFcstWaterfallTest96.cs:958 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0035_MktFcstWaterfallTest96.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8afb2fb7 | this.btnItemId.Click | DM0035_MktFcstWaterfallTest96.cs:938 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-082dc531 | this.btnItemId.Click | DM0035_MktFcstWaterfallTest96.cs:941 |  | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-33ee720c | this.btnItemId.Click | DM0035_MktFcstWaterfallTest96.cs:942 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5b57448b | this.btnItemId.Click | DM0035_MktFcstWaterfallTest96.cs:943 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e6b4f2f8 | this.btnItemId.Click | DM0035_MktFcstWaterfallTest96.cs:949 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6acc119b | this.btnMeasure.Click | DM0035_MktFcstWaterfallTest96.cs:968 |  | POPUP | new SCM0002_TitleSetForm_Popup_test | ("DM0035_TEST", SpdSheet.shtMain, false, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-bccfca94 | this.btnMeasure.Click | DM0035_MktFcstWaterfallTest96.cs:970 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-70ac6391 | this.btnMeasure.Click | DM0035_MktFcstWaterfallTest96.cs:971 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0035_MktFcstWaterfallTest96.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc8aa3b9 | this.btnOwner.Click | DM0035_MktFcstWaterfallTest96.cs:1314 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-91b84d1d | this.btnOwner.Click | DM0035_MktFcstWaterfallTest96.cs:1317 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ea24e1ac | this.btnOwner.Click | DM0035_MktFcstWaterfallTest96.cs:1318 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2a301db9 | this.btnOwner.Click | DM0035_MktFcstWaterfallTest96.cs:1319 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-05edd6a0 | this.btnOwner.Click | DM0035_MktFcstWaterfallTest96.cs:1321 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1aa7042f | this.btnProject.Click | DM0035_MktFcstWaterfallTest96.cs:913 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dd2622ff | this.btnProject.Click | DM0035_MktFcstWaterfallTest96.cs:915 |  | POPUP | popProject.Form_Load | (true, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-56c794c7 | this.btnProject.Click | DM0035_MktFcstWaterfallTest96.cs:916 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e74dad02 | this.btnProject.Click | DM0035_MktFcstWaterfallTest96.cs:917 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-054066c1 | this.btnProject.Click | DM0035_MktFcstWaterfallTest96.cs:923 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af0b3ff | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfallTest96.cs:1242 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9bdbde2a | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfallTest96.cs:1243 |  | POPUP | popVersion.Form_Load | (true, "MF", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e6e06ee3 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfallTest96.cs:1244 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bf844e03 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfallTest96.cs:1245 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-61b2a06c | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfallTest96.cs:1249 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-12e92809 | this.btnVersion.Click 외 1 | DM0035_MktFcstWaterfallTest96.cs:1250 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.cboDivision_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff1a4fd | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:636 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9b8c1794 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:637 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7338790b | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:638 | if (sDivision == "40") | STATE | lblBizType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1bd76cec | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:639 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cdb74c5a | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:643 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d545d29a | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:644 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8ed96c46 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:645 | else of (sDivision == "40") | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2e103ed0 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:646 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-238b38ac | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:649 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-6f2a7904 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:649 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97ada10e | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:650 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51f59e17 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:656 | if (cboDivision.ControlValues != "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d1951450 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:656 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33dd2240 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:657 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d29afb4a | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:661 | if (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-55c7aa9b | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:661 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8e8b7241 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:662 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7cd707e8 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:666 | else of (cboDivision.ControlValues != "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-c72c6d97 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:666 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b777fd5a | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:667 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-01b079a1 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:672 | else of (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-c0a1eb6d | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:672 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-57116072 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:673 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ae99bc5b | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:676 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-fc5c9082 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:676 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f168a803 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:677 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-050a9973 | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:681 |  | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff77cece | this.Load 외 1 | DM0035_MktFcstWaterfallTest96.cs:682 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0035_MktFcstWaterfallTest96.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d292f80 | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:726 | if (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-32b75d49 | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:726 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-82c82f7f | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:730 | else of (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-7c0ae48c | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:730 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-11b4a8da | this.clbCustomer.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:732 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0035_MktFcstWaterfallTest96.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e8d2191 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:693 | if (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-c9819818 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:693 | if (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95499718 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:694 | if (cboDivision.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-19b7f81b | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:698 | else of (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-46d572aa | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:698 | else of (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a5cee0c6 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:699 | else of (cboDivision.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bf73fa67 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:704 | if (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-54dc2ed4 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:704 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, clbCust… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9cbaa6a | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:708 | else of (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-80ff0eb7 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:708 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16478475 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:710 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c14e2344 | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:712 |  | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-e78ad98b | this.clbTeam.SelectedIndexChanged | DM0035_MktFcstWaterfallTest96.cs:713 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0035_MktFcstWaterfallTest96.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cac76999 | this.Load | DM0035_MktFcstWaterfallTest96.cs:257 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d46a4f1e | this.Load | DM0035_MktFcstWaterfallTest96.cs:258 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-81c22788 | this.Load | DM0035_MktFcstWaterfallTest96.cs:259 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0035_MktFcstWaterfallTest96.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e41ed5c0 | this.Load | DM0035_MktFcstWaterfallTest96.cs:251 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-e9ad5827 | this.Load | DM0035_MktFcstWaterfallTest96.cs:252 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5a28fe5 | Dispose | DM0035_MktFcstWaterfallTest96.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0035_MktFcstWaterfallTest96.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a94de5bd | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0035_MktFcstWaterfallTest96.cs:415 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fe394cf4 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0035_MktFcstWaterfallTest96.cs:416 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d01ff088 | FindButton | DM0035_MktFcstWaterfallTest96.cs:432 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d9d70283 | FindButton | DM0035_MktFcstWaterfallTest96.cs:432 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2aba9f8 | FindButton | DM0035_MktFcstWaterfallTest96.cs:436 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-46e64760 | FindButton | DM0035_MktFcstWaterfallTest96.cs:443 | if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ae57240 | FindButton | DM0035_MktFcstWaterfallTest96.cs:445 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0398e3b2 | FindButton | DM0035_MktFcstWaterfallTest96.cs:452 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dae61a05 | FindButton | DM0035_MktFcstWaterfallTest96.cs:453 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-803a5a51 | FindButton | DM0035_MktFcstWaterfallTest96.cs:458 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0aed1b93 | FindButton | DM0035_MktFcstWaterfallTest96.cs:460 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-f62ef18d | FindButton | DM0035_MktFcstWaterfallTest96.cs:462 | if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d92dbd5 | FindButton | DM0035_MktFcstWaterfallTest96.cs:472 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { //… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fe0ae9ba | FindButton | DM0035_MktFcstWaterfallTest96.cs:477 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DM0035_GET_MKT_FCST_WATERFALL_40") ⇒ DM.DM0035_GET_MKT_FCST_WATERFALL_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-a861323e | FindButton | DM0035_MktFcstWaterfallTest96.cs:480 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2b24eef8 | FindButton | DM0035_MktFcstWaterfallTest96.cs:482 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1524f81b | FindButton | DM0035_MktFcstWaterfallTest96.cs:483 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b16bc9ca | FindButton | DM0035_MktFcstWaterfallTest96.cs:484 | lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e76c26a2 | FindButton | DM0035_MktFcstWaterfallTest96.cs:486 | lambda | DATA_OP | request.Parameters["p_team_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-42757d7b | FindButton | DM0035_MktFcstWaterfallTest96.cs:487 | lambda | DATA_OP | request.Parameters["p_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3b319e82 | FindButton | DM0035_MktFcstWaterfallTest96.cs:488 | lambda | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9ffa6bfa | FindButton | DM0035_MktFcstWaterfallTest96.cs:489 | lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-24dc5040 | FindButton | DM0035_MktFcstWaterfallTest96.cs:490 | lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-16138fde | FindButton | DM0035_MktFcstWaterfallTest96.cs:491 | lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-83dc0036 | FindButton | DM0035_MktFcstWaterfallTest96.cs:492 | lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-43325e5c | FindButton | DM0035_MktFcstWaterfallTest96.cs:493 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-99e7fd76 | FindButton | DM0035_MktFcstWaterfallTest96.cs:494 | lambda | DATA_OP | request.Parameters["p_version_no"] | txtVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b58bc297 | FindButton | DM0035_MktFcstWaterfallTest96.cs:495 | lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-dfeb8f1b | FindButton | DM0035_MktFcstWaterfallTest96.cs:496 | lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-9ec14b92 | FindButton | DM0035_MktFcstWaterfallTest96.cs:497 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7f824e7 | FindButton | DM0035_MktFcstWaterfallTest96.cs:499 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-868a0e07 | FindButton | DM0035_MktFcstWaterfallTest96.cs:542 | if (ds.Tables[0] != null) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-fc5c2de5 | FindButton | DM0035_MktFcstWaterfallTest96.cs:550 | if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-16e895c8 | FindButton | DM0035_MktFcstWaterfallTest96.cs:550 | if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e3be81a | FindButton | DM0035_MktFcstWaterfallTest96.cs:556 | if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-38e1157c | FindButton | DM0035_MktFcstWaterfallTest96.cs:557 | if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30ad84e0 | FindButton | DM0035_MktFcstWaterfallTest96.cs:558 | if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-da6e0277 | FindButton | DM0035_MktFcstWaterfallTest96.cs:570 | if (siMain.GetMaxRowIndex() > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d899db8 | FindButton | DM0035_MktFcstWaterfallTest96.cs:572 | if (siMain.GetMaxRowIndex() > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cdf6fef8 | FindButton | DM0035_MktFcstWaterfallTest96.cs:603 | for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-311907ad | FindButton | DM0035_MktFcstWaterfallTest96.cs:604 | for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iResultMonth, i, iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-f1a19c86 | FindButton | DM0035_MktFcstWaterfallTest96.cs:616 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0035_MktFcstWaterfallTest96.fnValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9b746de | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1079 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-ff862d86 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1083 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41b7893c | this.Load | DM0035_MktFcstWaterfallTest96.cs:167 |  | FLAG | miFormLoad | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-6a494885 | this.Load | DM0035_MktFcstWaterfallTest96.cs:169 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5a71f8a | this.Load | DM0035_MktFcstWaterfallTest96.cs:170 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-41d201e3 | this.Load | DM0035_MktFcstWaterfallTest96.cs:177 |  | FLAG | miFormLoad | 1 | 화면 필드/플래그 변경 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetBizTypebyDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c964c53b | this.Load 외 2 | DM0035_MktFcstWaterfallTest96.cs:1227 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a8abb464 | this.Load 외 2 | DM0035_MktFcstWaterfallTest96.cs:1228 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-bc7ebd86 | this.Load 외 2 | DM0035_MktFcstWaterfallTest96.cs:1229 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e83cbb7e | this.Load 외 2 | DM0035_MktFcstWaterfallTest96.cs:1232 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cf5ba3b | this.Load | DM0035_MktFcstWaterfallTest96.cs:1170 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-fbaa7a0b | this.Load | DM0035_MktFcstWaterfallTest96.cs:1171 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b03ee815 | this.Load | DM0035_MktFcstWaterfallTest96.cs:1174 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80adee2f | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1212 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-608cdaac | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1213 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b2ffc237 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1214 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-b24a7fd1 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1215 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee388956 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1218 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e57a2c94 | this.Load | DM0035_MktFcstWaterfallTest96.cs:1141 |  | COMBO_DATA | Data.MultiTimeZone | (UserInfoContext.Current["TimeZone"]) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0633aa25 | this.Load | DM0035_MktFcstWaterfallTest96.cs:1146 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0af8299 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1092 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d54ca105 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1094 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-07fe1313 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1097 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc0c73b5 | this.Load | DM0035_MktFcstWaterfallTest96.cs:1183 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-7cb7b723 | this.Load | DM0035_MktFcstWaterfallTest96.cs:1184 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-2d23c2dc | this.Load | DM0035_MktFcstWaterfallTest96.cs:1185 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0b9141a3 | this.Load | DM0035_MktFcstWaterfallTest96.cs:1188 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetLastWeekSunDayByDate

진입점: FindButton [for (i <= siMain.GetMaxRowIndex()) ▸ else of (sVersion.ToUpper() == "CURRENT")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33c1e79b | FindButton [for (i <= siMain.GetMaxRowIndex()) ▸ else of (sV… | DM0035_MktFcstWaterfallTest96.cs:1300 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cafb076 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1122 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-1b60509c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1123 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9f254129 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1124 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-4ebdf9ca | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1125 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-4caf3c0c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1126 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9a163197 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1129 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cba5637 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1106 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-4227235c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1107 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-93794c92 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1108 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-362a9d2b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1109 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-5aa84b8c | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1110 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b409f30d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DM0035_MktFcstWaterfallTest96.cs:1113 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b9923ab | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:1155 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0035_GET_SPREAD_TITLE_40") ⇒ DM.DM0035_GET_SPREAD_TITLE_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-455d0fdc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:1156 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-012d8fa7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:1157 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-eae07064 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:1158 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b7ae5fa4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:1159 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b01f6db8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:1161 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-5a252284 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:1161 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eed666e8 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1198 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-998ca64e | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1199 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-819720e8 | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1200 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27bfff9a | (진입점 미연결) | DM0035_MktFcstWaterfallTest96.cs:1203 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.GetThisWeekMonday

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d72d229b | FindButton | DM0035_MktFcstWaterfallTest96.cs:1270 | while (true) ▸ if (dtStart.DayOfWeek == DayOfWeek.Monday) | FLAG | thisWeekDate | dtStart | 화면 필드/플래그 변경 |  |  |  |
| AC-31b32b9a | FindButton | DM0035_MktFcstWaterfallTest96.cs:1277 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DM0035_MktFcstWaterfallTest96.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5197227 | this.Load | DM0035_MktFcstWaterfallTest96.cs:187 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d751be02 | this.Load | DM0035_MktFcstWaterfallTest96.cs:187 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-250d94e0 | this.Load | DM0035_MktFcstWaterfallTest96.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cad83e88 | this.Load | DM0035_MktFcstWaterfallTest96.cs:194 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a0bff12 | this.Load | DM0035_MktFcstWaterfallTest96.cs:194 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3894a45 | this.Load | DM0035_MktFcstWaterfallTest96.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d41426db | this.Load | DM0035_MktFcstWaterfallTest96.cs:202 | if (cboDivision.ControlValues != "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-6f491167 | this.Load | DM0035_MktFcstWaterfallTest96.cs:202 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4a227220 | this.Load | DM0035_MktFcstWaterfallTest96.cs:203 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-add5fd08 | this.Load | DM0035_MktFcstWaterfallTest96.cs:207 | else of (cboDivision.ControlValues != "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a65d6f39 | this.Load | DM0035_MktFcstWaterfallTest96.cs:207 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1faa2dfc | this.Load | DM0035_MktFcstWaterfallTest96.cs:208 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4ddcd09d | this.Load | DM0035_MktFcstWaterfallTest96.cs:211 |  | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c804756a | this.Load | DM0035_MktFcstWaterfallTest96.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6b507838 | this.Load | DM0035_MktFcstWaterfallTest96.cs:216 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0e05d6a7 | this.Load | DM0035_MktFcstWaterfallTest96.cs:216 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-043853c3 | this.Load | DM0035_MktFcstWaterfallTest96.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-faeac2f6 | this.Load | DM0035_MktFcstWaterfallTest96.cs:219 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-1a94263a | this.Load | DM0035_MktFcstWaterfallTest96.cs:219 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4734d950 | this.Load | DM0035_MktFcstWaterfallTest96.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-23ca1625 | this.Load | DM0035_MktFcstWaterfallTest96.cs:222 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d59e5164 | this.Load | DM0035_MktFcstWaterfallTest96.cs:223 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-94b6db2e | this.Load | DM0035_MktFcstWaterfallTest96.cs:233 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-6f001c28 | this.Load | DM0035_MktFcstWaterfallTest96.cs:235 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-76d8488f | this.Load | DM0035_MktFcstWaterfallTest96.cs:236 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3a17fafd | this.Load | DM0035_MktFcstWaterfallTest96.cs:239 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5dd3e5da | this.Load | DM0035_MktFcstWaterfallTest96.cs:240 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7910e5f4 | this.Load | DM0035_MktFcstWaterfallTest96.cs:244 | if (dtDivision.Rows.Count > 1) | VALUE_SET | cboDivision.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / cboDivision.SelectedIndexChanged [if (miFormLoad == 1)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab46e786 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:267 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0035_MktFcstWaterfallTest96.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [if (siMain.GetM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d605cf53 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DM0035_MktFcstWaterfallTest96.cs:1000 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-70d5d81a | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DM0035_MktFcstWaterfallTest96.cs:1005 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-78921ced | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DM0035_MktFcstWaterfallTest96.cs:1012 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-83c78b67 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DM0035_MktFcstWaterfallTest96.cs:1016 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-dc80173c | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DM0035_MktFcstWaterfallTest96.cs:1021 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d434ea80 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DM0035_MktFcstWaterfallTest96.cs:1028 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d58caf38 | this.chkSum.CheckedChanged [if (siMain != null)] 외 7 | DM0035_MktFcstWaterfallTest96.cs:1032 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (miFormLoad == 1) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [if (dtTitle != null && dtTitle.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-177a2509 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:303 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0efc855 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:311 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f3c5ee41 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:324 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e49f13e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:343 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c070223f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:344 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed4a8d86 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:349 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37056258 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:350 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a69a6742 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:357 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd41584f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:358 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c532f8ea | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:369 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d368fcf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:370 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c304b975 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:371 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc79b386 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:372 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73bc1e5a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:374 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e44614f2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DM0035_MktFcstWaterfallTest96.cs:375 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0035_MktFcstWaterfallTest96.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5655c31d | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:807 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-5845b4ff | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:813 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-48341ef1 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:829 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-783a7638 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:843 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9654fa75 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:851 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-57085f1f | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:853 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-1c0d4017 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:854 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-baa91ceb | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:855 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3f2923fc | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:859 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-088cb698 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:868 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-eb7ea3da | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:870 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.Form_Load | (false, sDivision, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a5766464 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:871 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8a04c18d | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:872 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a4170283 | this.spdMain.CellDoubleClick | DM0035_MktFcstWaterfallTest96.cs:876 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d079945 | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfallTest96.cs:789 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-e0c86474 | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfallTest96.cs:790 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4c26fd09 | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfallTest96.cs:792 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-66627451 | this.spdMain.ComboSelChange | DM0035_MktFcstWaterfallTest96.cs:793 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0035_MktFcstWaterfallTest96.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79c1b65a | this.spdMain.KeyUp | DM0035_MktFcstWaterfallTest96.cs:890 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-054e641f | this.spdMain.KeyUp | DM0035_MktFcstWaterfallTest96.cs:894 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc71573b | this.spdMain.KeyUp | DM0035_MktFcstWaterfallTest96.cs:900 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d13a5a8d | this.spdMain.KeyUp | DM0035_MktFcstWaterfallTest96.cs:901 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0035_MktFcstWaterfallTest96.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1602031 | this.spdMain.TopChange | DM0035_MktFcstWaterfallTest96.cs:884 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

