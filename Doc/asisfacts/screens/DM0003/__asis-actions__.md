# AS-IS 액션 대조표 — DM0003

> 원천: `Doc/asisfacts/screens/DM0003/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 616행 · 메서드 53 · 종류 DATA_OP 105 · GRID_SET 64 · FLAG 58 · GRID_LOCK 50 · COMBO_DATA 48 · ENDPOINT 37 · RETURN 34 · POPUP 29 · UI_PROP 29 · GRID_INIT 29 · GRID_COMBO 25 · MESSAGE 23 · LIST_REBIND 22 · STATE 18 · CALL_EXT 12 · UI_MISC 12 · VALUE_SET 8 · GRID_STYLE 8 · GRID_BIND 3 · STATE_RESET 2 · ⚠ 의미 확인 필요 12


## DM0003_MktFcstTest97.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e609e247 | this.btnColumn.Click | DM0003_MktFcstTest97.cs:3096 |  | POPUP | new SCM0002_TitleSetForm_Popup_test | ("DM0003_TEST", SpdSheet.shtMain, true, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-f4234ff0 | this.btnColumn.Click | DM0003_MktFcstTest97.cs:3097 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4468467f | this.btnColumn.Click | DM0003_MktFcstTest97.cs:3098 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0003_MktFcstTest97.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edd73b41 | this.btnCutOff.Click | DM0003_MktFcstTest97.cs:3150 | if (!siMain.IsLock(siMain.SheetName)) | MESSAGE | MessageBox.Show | ("Edit Mode is not allowed.") | 메시지 표시 |  |  |  |
| AC-16609804 | this.btnCutOff.Click | DM0003_MktFcstTest97.cs:3151 | if (!siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be74b75a | this.btnCutOff.Click | DM0003_MktFcstTest97.cs:3159 |  | POPUP | new GSCM.DM.Plan.UIL.POPUP.VersionCutOffPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-8cb852ce | this.btnCutOff.Click | DM0003_MktFcstTest97.cs:3161 |  | CALL_EXT | popup.LoadData | (sVersion_Type, sFoxData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d85ff359 | this.btnCutOff.Click | DM0003_MktFcstTest97.cs:3162 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5a2f19ed | this.btnCutOff.Click | DM0003_MktFcstTest97.cs:3163 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0003_MktFcstTest97.btnIncotermsChg_Click

진입점: this.btnIncotermsChg.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d53dd68b | this.btnIncotermsChg.Click | DM0003_MktFcstTest97.cs:3480 |  | POPUP | new DM0002_MatsterChgPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e5f98420 | this.btnIncotermsChg.Click | DM0003_MktFcstTest97.cs:3481 |  | POPUP | popAdjst.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e2f2bbd3 | this.btnIncotermsChg.Click | DM0003_MktFcstTest97.cs:3483 |  | UI_PROP | popAdjst.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e9fb4d99 | this.btnIncotermsChg.Click | DM0003_MktFcstTest97.cs:3484 |  | POPUP | popAdjst.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0003_MktFcstTest97.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-657321fc | this.btnItemId.Click | DM0003_MktFcstTest97.cs:3079 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-f855a388 | this.btnItemId.Click | DM0003_MktFcstTest97.cs:3081 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-96c50f92 | this.btnItemId.Click | DM0003_MktFcstTest97.cs:3082 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5228ffad | this.btnItemId.Click | DM0003_MktFcstTest97.cs:3083 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ead3fcbc | this.btnItemId.Click | DM0003_MktFcstTest97.cs:3089 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DM0003_MktFcstTest97.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-814d192b | this.btnMeasure.Click | DM0003_MktFcstTest97.cs:3108 |  | POPUP | new SCM0002_TitleSetForm_Popup_test | ("DM0003_TEST", SpdSheet.shtMain, false, cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-5d78bfe6 | this.btnMeasure.Click | DM0003_MktFcstTest97.cs:3110 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-422c12e8 | this.btnMeasure.Click | DM0003_MktFcstTest97.cs:3111 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DM0003_MktFcstTest97.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2b7d0ca | this.btnOwner.Click | DM0003_MktFcstTest97.cs:3505 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e804343f | this.btnOwner.Click | DM0003_MktFcstTest97.cs:3508 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d56100e9 | this.btnOwner.Click | DM0003_MktFcstTest97.cs:3509 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-70e23a2b | this.btnOwner.Click | DM0003_MktFcstTest97.cs:3510 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7d4effe4 | this.btnOwner.Click | DM0003_MktFcstTest97.cs:3512 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DM0003_MktFcstTest97.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d14eacb | this.btnProject.Click | DM0003_MktFcstTest97.cs:3055 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-74aa3e47 | this.btnProject.Click | DM0003_MktFcstTest97.cs:3057 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e556d697 | this.btnProject.Click | DM0003_MktFcstTest97.cs:3058 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4c42746c | this.btnProject.Click | DM0003_MktFcstTest97.cs:3059 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a99cbf38 | this.btnProject.Click | DM0003_MktFcstTest97.cs:3065 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DM0003_MktFcstTest97.cboDivision_SelectedIndexChanged

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b88fb2e6 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1426 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e901a39d | this.Load 외 1 | DM0003_MktFcstTest97.cs:1427 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d4815664 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1428 | if (sDivision == "40") | STATE | lblBizType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-71e48575 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1429 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4f17fc68 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1433 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a2a6f7db | this.Load 외 1 | DM0003_MktFcstTest97.cs:1434 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-902e75d6 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1435 | else of (sDivision == "40") | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-92df940c | this.Load 외 1 | DM0003_MktFcstTest97.cs:1436 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-506075c8 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1439 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-198a7d7a | this.Load 외 1 | DM0003_MktFcstTest97.cs:1439 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e31558bd | this.Load 외 1 | DM0003_MktFcstTest97.cs:1440 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0d49a7bc | this.Load 외 1 | DM0003_MktFcstTest97.cs:1446 | if (cboDivision.ControlValues != "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8c1bd49a | this.Load 외 1 | DM0003_MktFcstTest97.cs:1446 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66299b00 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1447 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-51f63fa5 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1451 | if (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9b160ca9 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1451 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-67d20874 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1452 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0e0693bb | this.Load 외 1 | DM0003_MktFcstTest97.cs:1456 | else of (cboDivision.ControlValues != "40") | FLAG | dtCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-0d91c444 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1456 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3cad6c7b | this.Load 외 1 | DM0003_MktFcstTest97.cs:1457 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer40, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c0c5db9 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1462 | else of (cboDivision.ControlValues != "40") | FLAG | dtSalesSite40 | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-23be8312 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1462 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4038c84f | this.Load 외 1 | DM0003_MktFcstTest97.cs:1463 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d49d6320 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1466 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-6693216a | this.Load 외 1 | DM0003_MktFcstTest97.cs:1466 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-633f8838 | this.Load 외 1 | DM0003_MktFcstTest97.cs:1467 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a3eaff3b | this.Load 외 1 | DM0003_MktFcstTest97.cs:1469 |  | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c74da2a | this.Load 외 1 | DM0003_MktFcstTest97.cs:1470 |  | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0003_MktFcstTest97.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-947a290e | this.clbCustomer.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1509 | if (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ea91ed61 | this.clbCustomer.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1509 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, cboDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2a7d7a0 | this.clbCustomer.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1513 | else of (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, cboDivision.ControlValues, clbTeam.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-6ce2c6ff | this.clbCustomer.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1513 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, cboDivision.ControlValues, clbTeam.ControlValues, c… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-037e47ef | this.clbCustomer.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1515 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0003_MktFcstTest97.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2155d6a9 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1480 | if (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-e54ce523 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1480 | if (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-949188d6 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1481 | if (cboDivision.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f5dbf1b7 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1485 | else of (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-0a8e33d2 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1485 | else of (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-271bb703 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1486 | else of (cboDivision.SelectedValue.ToString() != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f4fca9b6 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1494 | if (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-212880a1 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1494 | if (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4fef2fff | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1498 | else of (cboDivision.SelectedValue.ToString() != "40") | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-67698007 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1498 | else of (cboDivision.SelectedValue.ToString() != "40") | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae8bce87 | this.clbTeam.SelectedIndexChanged | DM0003_MktFcstTest97.cs:1500 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0003_MktFcstTest97.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcde2ef0 | this.Load | DM0003_MktFcstTest97.cs:350 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf61516f | this.Load | DM0003_MktFcstTest97.cs:351 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-354fd982 | this.Load | DM0003_MktFcstTest97.cs:352 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0003_MktFcstTest97.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd080045 | this.Load | DM0003_MktFcstTest97.cs:303 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-3e525332 | this.Load | DM0003_MktFcstTest97.cs:307 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-b8f709ef | this.Load | DM0003_MktFcstTest97.cs:309 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-da360d01 | this.Load | DM0003_MktFcstTest97.cs:310 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-a50f9edc | this.Load | DM0003_MktFcstTest97.cs:311 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-806d8652 | this.Load | DM0003_MktFcstTest97.cs:312 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-a77fb0c2 | this.Load | DM0003_MktFcstTest97.cs:317 |  | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-89472074 | this.Load | DM0003_MktFcstTest97.cs:323 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c799e430 | this.Load | DM0003_MktFcstTest97.cs:324 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnCutOff.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ad27fc9e | this.Load | DM0003_MktFcstTest97.cs:325 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnIncotermsChg.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d4166c44 | this.Load | DM0003_MktFcstTest97.cs:326 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnIncotermsChg.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-edb0b3f6 | this.Load | DM0003_MktFcstTest97.cs:327 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c8cbb88c | this.Load | DM0003_MktFcstTest97.cs:328 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-5327f92f | this.Load | DM0003_MktFcstTest97.cs:331 | switch (UserInfoContext.Current["NowGroupID"]) case "DM Planner": | STATE | btnIncotermsChg.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-77f909f1 | this.Load | DM0003_MktFcstTest97.cs:332 | switch (UserInfoContext.Current["NowGroupID"]) case "DM Planner": | STATE | btnIncotermsChg.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-85af7fbc | this.Load | DM0003_MktFcstTest97.cs:333 | switch (UserInfoContext.Current["NowGroupID"]) case "DM Planner": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-aff4d9e4 | this.Load | DM0003_MktFcstTest97.cs:336 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd4325fc | this.Load | DM0003_MktFcstTest97.cs:337 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnCutOff.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-525e8d81 | this.Load | DM0003_MktFcstTest97.cs:338 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnIncotermsChg.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-97d20834 | this.Load | DM0003_MktFcstTest97.cs:339 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnIncotermsChg.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a2e97b9f | this.Load | DM0003_MktFcstTest97.cs:340 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a7fe0918 | this.Load | DM0003_MktFcstTest97.cs:341 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DM0003_MktFcstTest97.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bd31c45 | DeleteButton | DM0003_MktFcstTest97.cs:520 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0003_MktFcstTest97.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-050f32ee | Dispose | DM0003_MktFcstTest97.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0003_MktFcstTest97.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-077ad17a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:538 | if (this.fps != null) ▸ if (cboDivision.ControlValues != "40") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siMain.GetColumnInd… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aa8350e0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:539 | if (this.fps != null) ▸ if (cboDivision.ControlValues != "40") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siMain.GetColumnInd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55c56546 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:550 | if (this.fps != null) ▸ else of (cboDivision.ControlValues != "40") ▸ if (siMain.GetColumnIndex(DefColumns.Division40) < 0 \|\| siMain.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25b83534 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:551 | if (this.fps != null) ▸ else of (cboDivision.ControlValues != "40") ▸ if (siMain.GetColumnIndex(DefColumns.Division40) < 0 \|\| siMain.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf8f5a0d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:555 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-81cb8f9c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:556 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-8a49ce32 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:558 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.Measure), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-06058b1e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:575 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColu… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7473ee1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:580 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColu… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8094de2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:590 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (siMain.Ge… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-626d37e5 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:609 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucket… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2bcebc29 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:615 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucket… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f32a6f78 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:636 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucket… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-708a41ee | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:647 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac780cd9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:657 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e8cdc926 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:678 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b79c33d3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:688 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Measure) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fd0d6889 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:692 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetBGColor | (iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1459496c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:700 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) ==… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-978b952c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:704 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) ==… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e33fbcdf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:711 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) ==… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d35cbad | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:715 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) ==… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fc6d178 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:722 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) ==… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-47261102 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:726 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) ==… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7191d3f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:736 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1, siMain.GetMaxRowIndex(), iResultCol, Co… | 그리드 표시 설정 |  |  |  |
| AC-c176d3da | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DM0003_MktFcstTest97.cs:741 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |

## DM0003_MktFcstTest97.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80bd6151 | FindButton 외 1 | DM0003_MktFcstTest97.cs:760 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eafc5a09 | FindButton 외 1 | DM0003_MktFcstTest97.cs:768 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-725411ce | FindButton 외 1 | DM0003_MktFcstTest97.cs:770 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6181c1c | FindButton 외 1 | DM0003_MktFcstTest97.cs:779 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aeaee6ac | FindButton 외 1 | DM0003_MktFcstTest97.cs:780 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-615ec654 | FindButton 외 1 | DM0003_MktFcstTest97.cs:785 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1222b208 | FindButton 외 1 | DM0003_MktFcstTest97.cs:787 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-400e3e44 | FindButton 외 1 | DM0003_MktFcstTest97.cs:789 | try ▸ if (drpPeriod.Value1.AddYears(2) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-231aa7c4 | FindButton 외 1 | DM0003_MktFcstTest97.cs:793 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-938b7f75 | FindButton 외 1 | DM0003_MktFcstTest97.cs:806 | try | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_MKT_FCST_DATA_SML_40") ⇒ DM.DM0003_GET_MKT_FCST_DATA_SML_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-58309475 | FindButton 외 1 | DM0003_MktFcstTest97.cs:808 | try | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d88099aa | FindButton 외 1 | DM0003_MktFcstTest97.cs:810 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-7cf56fce | FindButton 외 1 | DM0003_MktFcstTest97.cs:811 | try | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-732a3960 | FindButton 외 1 | DM0003_MktFcstTest97.cs:812 | try | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d0f1b45e | FindButton 외 1 | DM0003_MktFcstTest97.cs:813 | try | DATA_OP | request.Parameters["p_team_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-78baf42e | FindButton 외 1 | DM0003_MktFcstTest97.cs:814 | try | DATA_OP | request.Parameters["p_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9dc3acb6 | FindButton 외 1 | DM0003_MktFcstTest97.cs:815 | try | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b9600e43 | FindButton 외 1 | DM0003_MktFcstTest97.cs:816 | try | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-9b36bf33 | FindButton 외 1 | DM0003_MktFcstTest97.cs:817 | try | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d32764de | FindButton 외 1 | DM0003_MktFcstTest97.cs:818 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-e44a3ee0 | FindButton 외 1 | DM0003_MktFcstTest97.cs:819 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-4c7e99ed | FindButton 외 1 | DM0003_MktFcstTest97.cs:820 | try | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-44e29383 | FindButton 외 1 | DM0003_MktFcstTest97.cs:821 | try | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1cb05dc5 | FindButton 외 1 | DM0003_MktFcstTest97.cs:822 | try | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5cdaef66 | FindButton 외 1 | DM0003_MktFcstTest97.cs:823 | try | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-a8434197 | FindButton 외 1 | DM0003_MktFcstTest97.cs:825 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cf31bd94 | FindButton 외 1 | DM0003_MktFcstTest97.cs:835 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-027528e8 | FindButton 외 1 | DM0003_MktFcstTest97.cs:863 | try ▸ if (ds.Tables[0] != null) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-5ff1721b | FindButton 외 1 | DM0003_MktFcstTest97.cs:871 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0caeca8 | FindButton 외 1 | DM0003_MktFcstTest97.cs:871 | try ▸ if (ds.Tables[0] != null) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-afaff1dd | FindButton 외 1 | DM0003_MktFcstTest97.cs:877 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-afcf3395 | FindButton 외 1 | DM0003_MktFcstTest97.cs:878 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17eb78ba | FindButton 외 1 | DM0003_MktFcstTest97.cs:879 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-0b21a74b | FindButton 외 1 | DM0003_MktFcstTest97.cs:885 | try ▸ if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-de3d1fdb | FindButton 외 1 | DM0003_MktFcstTest97.cs:910 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-f6af2861 | FindButton 외 1 | DM0003_MktFcstTest97.cs:911 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-84e6b374 | FindButton 외 1 | DM0003_MktFcstTest97.cs:936 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a9ab0d95 | FindButton 외 1 | DM0003_MktFcstTest97.cs:944 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15b9a600 | FindButton 외 1 | DM0003_MktFcstTest97.cs:948 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-eb23a6ca | FindButton 외 1 | DM0003_MktFcstTest97.cs:950 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0003_MktFcstTest97.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75c60e9e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_MktFcstTest97.cs:3310 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-bbcb198f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_MktFcstTest97.cs:3313 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd4a6b45 | this.Load | DM0003_MktFcstTest97.cs:197 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdd54871 | this.Load | DM0003_MktFcstTest97.cs:198 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8bd32223 | this.Load | DM0003_MktFcstTest97.cs:209 | if (cboDivision.ControlValues != "40") | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure) ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-92e8ee79 | this.Load | DM0003_MktFcstTest97.cs:209 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure) ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d26e563e | this.Load | DM0003_MktFcstTest97.cs:213 | else of (cboDivision.ControlValues != "40") | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure40) ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 화면 필드/플래그 변경 |  |  |  |
| AC-209001f0 | this.Load | DM0003_MktFcstTest97.cs:213 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure40) ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0003_MktFcstTest97.GetBizTypebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))] / this.Load [if (cboDivision.ControlValues != "40")] / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a4f1645 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0003_MktFcstTest97.cs:3463 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-97fcfe2d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0003_MktFcstTest97.cs:3464 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fb1cdbca | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0003_MktFcstTest97.cs:3465 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c442d186 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DM0003_MktFcstTest97.cs:3468 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2455c9ad | this.Load | DM0003_MktFcstTest97.cs:3406 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-3322d472 | this.Load | DM0003_MktFcstTest97.cs:3407 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c0b2b60 | this.Load | DM0003_MktFcstTest97.cs:3410 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0b7dcfd | (진입점 미연결) | DM0003_MktFcstTest97.cs:3448 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-548d744e | (진입점 미연결) | DM0003_MktFcstTest97.cs:3449 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4dd129b2 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3450 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-341786bd | (진입점 미연결) | DM0003_MktFcstTest97.cs:3451 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-04088362 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3454 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-012c5413 | this.Load | DM0003_MktFcstTest97.cs:3368 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-4c9ed957 | this.Load | DM0003_MktFcstTest97.cs:3369 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-52edba27 | this.Load | DM0003_MktFcstTest97.cs:3370 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-c8815873 | this.Load | DM0003_MktFcstTest97.cs:3372 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5f3d890 | this.Load | DM0003_MktFcstTest97.cs:3375 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0f89d32 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3322 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-6b828df0 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3324 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-504cc8f5 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3327 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d22840be | this.Load | DM0003_MktFcstTest97.cs:3419 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-25af514e | this.Load | DM0003_MktFcstTest97.cs:3420 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-4bb79ac9 | this.Load | DM0003_MktFcstTest97.cs:3421 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8cef7ac6 | this.Load | DM0003_MktFcstTest97.cs:3424 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f77813f2 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3352 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-b5657702 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3353 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-57f8f540 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3354 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-56bf5183 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3355 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-59267432 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3356 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c2099ec | (진입점 미연결) | DM0003_MktFcstTest97.cs:3359 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3dff155 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3336 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d8f9538a | (진입점 미연결) | DM0003_MktFcstTest97.cs:3337 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-aac0f731 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3338 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-afaa3ab9 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3339 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-b6fe0cd1 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3340 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88951b2f | (진입점 미연결) | DM0003_MktFcstTest97.cs:3343 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / cboDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f264789 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:3384 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_SPREAD_TITLE_40") ⇒ DM.DM0003_GET_SPREAD_TITLE_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-1d46cecf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:3388 | if (cboDivision.ControlValues == "40") | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_SPREAD_TITLE_SML_40") ⇒ DM.DM0003_GET_SPREAD_TITLE_SML_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-029d015b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:3393 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-bf6efa5b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:3394 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-12296a24 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:3395 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-227df699 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:3397 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-5dd01f60 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:3397 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DM0003_MktFcstTest97.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76a2f7e3 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3434 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-824e01c0 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3435 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5aa36284 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3436 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd0cc5b8 | (진입점 미연결) | DM0003_MktFcstTest97.cs:3439 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0003_MktFcstTest97.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f92b74b | this.Load | DM0003_MktFcstTest97.cs:238 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-3d81d013 | this.Load | DM0003_MktFcstTest97.cs:238 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66ce3f4e | this.Load | DM0003_MktFcstTest97.cs:239 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-28428334 | this.Load | DM0003_MktFcstTest97.cs:244 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-e87655db | this.Load | DM0003_MktFcstTest97.cs:244 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-03796ddd | this.Load | DM0003_MktFcstTest97.cs:245 |  | FLAG | dtTeamSpr | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-668d84e4 | this.Load | DM0003_MktFcstTest97.cs:245 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f77e4a00 | this.Load | DM0003_MktFcstTest97.cs:246 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-810fd873 | this.Load | DM0003_MktFcstTest97.cs:253 | if (cboDivision.ControlValues != "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-92409271 | this.Load | DM0003_MktFcstTest97.cs:253 | if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-72d153b2 | this.Load | DM0003_MktFcstTest97.cs:254 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-793cce23 | this.Load | DM0003_MktFcstTest97.cs:256 | if (cboDivision.ControlValues != "40") | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-72fe4eeb | this.Load | DM0003_MktFcstTest97.cs:257 | if (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d66a5c35 | this.Load | DM0003_MktFcstTest97.cs:263 | else of (cboDivision.ControlValues != "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-73e95b96 | this.Load | DM0003_MktFcstTest97.cs:263 | else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-206a95dd | this.Load | DM0003_MktFcstTest97.cs:264 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e9268fd | this.Load | DM0003_MktFcstTest97.cs:266 | else of (cboDivision.ControlValues != "40") | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-14e182c7 | this.Load | DM0003_MktFcstTest97.cs:267 | else of (cboDivision.ControlValues != "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2cb2511b | this.Load | DM0003_MktFcstTest97.cs:272 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-07f11b51 | this.Load | DM0003_MktFcstTest97.cs:272 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a4357e3 | this.Load | DM0003_MktFcstTest97.cs:273 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c9661f9c | this.Load | DM0003_MktFcstTest97.cs:275 |  | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-2d2029bf | this.Load | DM0003_MktFcstTest97.cs:275 |  | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0170f18a | this.Load | DM0003_MktFcstTest97.cs:276 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6e07594d | this.Load | DM0003_MktFcstTest97.cs:278 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-2c108e07 | this.Load | DM0003_MktFcstTest97.cs:279 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9555b3e3 | this.Load | DM0003_MktFcstTest97.cs:281 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-717969ef | this.Load | DM0003_MktFcstTest97.cs:283 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-447bfabc | this.Load | DM0003_MktFcstTest97.cs:284 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-68b0a52d | this.Load | DM0003_MktFcstTest97.cs:287 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-31b6d05f | this.Load | DM0003_MktFcstTest97.cs:288 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb304b46 | this.Load | DM0003_MktFcstTest97.cs:292 | if (cboDivision.Items.Count > 1) | VALUE_SET | cboDivision.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-a2bf93f9 | this.Load | DM0003_MktFcstTest97.cs:296 | else of (cboDivision.Items.Count > 1) | VALUE_SET | cboDivision.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## DM0003_MktFcstTest97.InitSaveDataTable

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bd3898d | this.Load 외 1 | DM0003_MktFcstTest97.cs:483 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-136fea24 | this.Load 외 1 | DM0003_MktFcstTest97.cs:484 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e8fae0a | this.Load 외 1 | DM0003_MktFcstTest97.cs:485 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef763182 | this.Load 외 1 | DM0003_MktFcstTest97.cs:486 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2630d55 | this.Load 외 1 | DM0003_MktFcstTest97.cs:487 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d65c8c43 | this.Load 외 1 | DM0003_MktFcstTest97.cs:488 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb6251ca | this.Load 외 1 | DM0003_MktFcstTest97.cs:489 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dadd4d6b | this.Load 외 1 | DM0003_MktFcstTest97.cs:490 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-55870ad1 | this.Load 외 1 | DM0003_MktFcstTest97.cs:491 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad827f1e | this.Load 외 1 | DM0003_MktFcstTest97.cs:492 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlantSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e061ae91 | this.Load 외 1 | DM0003_MktFcstTest97.cs:493 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d7bf89b | this.Load 외 1 | DM0003_MktFcstTest97.cs:494 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99385a2d | this.Load 외 1 | DM0003_MktFcstTest97.cs:496 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Customer40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-30c9f5e6 | this.Load 외 1 | DM0003_MktFcstTest97.cs:497 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSiteId40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a9215b1 | this.Load 외 1 | DM0003_MktFcstTest97.cs:498 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0003_MktFcstTest97.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / cboDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efa5974d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:360 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0003_MktFcstTest97.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abd6317e | InsertButton | DM0003_MktFcstTest97.cs:1150 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-730d3536 | InsertButton | DM0003_MktFcstTest97.cs:1151 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eeb28775 | InsertButton | DM0003_MktFcstTest97.cs:1157 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-b2881ecc | InsertButton | DM0003_MktFcstTest97.cs:1159 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId)].… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2a57a984 | InsertButton | DM0003_MktFcstTest97.cs:1161 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), cboDivision.ControlVal… | 그리드 값 설정 |  |  |  |
| AC-7d1abe8c | InsertButton | DM0003_MktFcstTest97.cs:1166 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (cboDivision.ControlVa… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId40)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-87b803b4 | InsertButton | DM0003_MktFcstTest97.cs:1170 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (cboDivision.ControlVa… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division40), cboDivision.ControlV… | 그리드 값 설정 |  |  |  |
| AC-7c804b0c | InsertButton | DM0003_MktFcstTest97.cs:1177 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-536b2b7f | InsertButton | DM0003_MktFcstTest97.cs:1181 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, cboDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c740b73f | InsertButton | DM0003_MktFcstTest97.cs:1182 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-679c370d | InsertButton | DM0003_MktFcstTest97.cs:1183 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-92bdfc28 | InsertButton | DM0003_MktFcstTest97.cs:1211 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Team), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-07e6b37f | InsertButton | DM0003_MktFcstTest97.cs:1216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Customer), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2cc95767 | InsertButton | DM0003_MktFcstTest97.cs:1218 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-82a76e50 | InsertButton | DM0003_MktFcstTest97.cs:1222 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (cboDivision.ControlVa… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-98abf484 | InsertButton | DM0003_MktFcstTest97.cs:1224 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (cboDivision.ControlVa… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Customer40), dtEndCustomerAuth40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f2a9ea45 | InsertButton | DM0003_MktFcstTest97.cs:1227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (cboDivision.ControlVa… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ce794745 | InsertButton | DM0003_MktFcstTest97.cs:1228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (cboDivision.ControlVa… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSiteAuth40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2de50aa7 | InsertButton | DM0003_MktFcstTest97.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure,false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-6a0bd120 | InsertButton | DM0003_MktFcstTest97.cs:1237 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure,false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-06bf9c3d | InsertButton | DM0003_MktFcstTest97.cs:1238 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cd664b37 | InsertButton | DM0003_MktFcstTest97.cs:1246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure40, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 화면 필드/플래그 변경 |  |  |  |
| AC-65115829 | InsertButton | DM0003_MktFcstTest97.cs:1246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure40, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8625ffa | InsertButton | DM0003_MktFcstTest97.cs:1247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a1a7084c | InsertButton | DM0003_MktFcstTest97.cs:1254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetMaxRowIndex() > … | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.SoldToCustomer), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-98860a41 | InsertButton | DM0003_MktFcstTest97.cs:1258 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.Measure), "MKT_FCST_RP") | 그리드 값 설정 |  |  |  |
| AC-4b4ea6cc | InsertButton | DM0003_MktFcstTest97.cs:1263 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Project), siMain.ActiveRowIndex, … | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec484103 | InsertButton | DM0003_MktFcstTest97.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectName), siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e603ed7 | InsertButton | DM0003_MktFcstTest97.cs:1272 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.GetMaxRowIndex(), siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8414146d | InsertButton | DM0003_MktFcstTest97.cs:1278 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.BizType), siMain.GetMaxRowIndex(), siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-414ee496 | InsertButton | DM0003_MktFcstTest97.cs:1283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Country), siMain.GetMaxRowIndex(), siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ea8d209c | InsertButton | DM0003_MktFcstTest97.cs:1288 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.CountryName), siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f4631434 | InsertButton | DM0003_MktFcstTest97.cs:1293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.City), siMain.GetMaxRowIndex(), siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-266dae71 | InsertButton | DM0003_MktFcstTest97.cs:1298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.CityName), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b284caa9 | InsertButton | DM0003_MktFcstTest97.cs:1303 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetText(iRow, siMai… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Measure), siMain.GetMaxRowIndex(), siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4070e71a | InsertButton | DM0003_MktFcstTest97.cs:1308 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId), siMain.ActiveRowIndex, s… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6bec113f | InsertButton | DM0003_MktFcstTest97.cs:1313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ItemId40), siMain.ActiveRowIndex,… | 그리드 편집 잠금/해제 |  |  |  |
| AC-844290ae | InsertButton | DM0003_MktFcstTest97.cs:1318 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ItemName), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a92790b8 | InsertButton | DM0003_MktFcstTest97.cs:1323 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ItemType), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38038cd4 | InsertButton | DM0003_MktFcstTest97.cs:1328 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.NickName), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28851e39 | InsertButton | DM0003_MktFcstTest97.cs:1332 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectOwner), siMain.GetMaxRowIndex(), siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9b9786f | InsertButton | DM0003_MktFcstTest97.cs:1336 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Owner), siMain.GetMaxRowIndex(), siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9771a6fb | InsertButton | DM0003_MktFcstTest97.cs:1338 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MeasureGroup), siMain.GetMaxRowIndex(), siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db57e630 | InsertButton | DM0003_MktFcstTest97.cs:1362 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iResultCol > iStartCol) | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iResultCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-34e2ed21 | InsertButton | DM0003_MktFcstTest97.cs:1364 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-10cf7483 | InsertButton | DM0003_MktFcstTest97.cs:1365 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-5fbd432e | InsertButton | DM0003_MktFcstTest97.cs:1378 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-99668af1 | InsertButton | DM0003_MktFcstTest97.cs:1385 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3f2212fd | InsertButton | DM0003_MktFcstTest97.cs:1392 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eab667ef | InsertButton | DM0003_MktFcstTest97.cs:1399 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboDivision.ControlValues … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-008c8e17 | InsertButton | DM0003_MktFcstTest97.cs:1403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (cboDivision.ControlVa… | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division40), siMain.GetMaxRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ede8cfd1 | InsertButton | DM0003_MktFcstTest97.cs:1406 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0003_MktFcstTest97.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed6d42cb | OnShown | DM0003_MktFcstTest97.cs:225 | if (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-8e21a669 | OnShown | DM0003_MktFcstTest97.cs:229 | else of (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## DM0003_MktFcstTest97.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-799d4cb6 | SaveButton | DM0003_MktFcstTest97.cs:981 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!fnValidation()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57b25e7c | SaveButton | DM0003_MktFcstTest97.cs:982 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!fnValidation()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2deb15cc | SaveButton | DM0003_MktFcstTest97.cs:1066 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0003_SAVE_MKT_FCST_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-00acf9ca | SaveButton | DM0003_MktFcstTest97.cs:1067 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-8d4171dc | SaveButton | DM0003_MktFcstTest97.cs:1068 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1c73486b | SaveButton | DM0003_MktFcstTest97.cs:1069 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-ac0b44e3 | SaveButton | DM0003_MktFcstTest97.cs:1070 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-8793e445 | SaveButton | DM0003_MktFcstTest97.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-46cda391 | SaveButton | DM0003_MktFcstTest97.cs:1072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp"] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-dd3beda7 | SaveButton | DM0003_MktFcstTest97.cs:1073 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-4348f3c7 | SaveButton | DM0003_MktFcstTest97.cs:1074 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-66767ec6 | SaveButton | DM0003_MktFcstTest97.cs:1075 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-80bf3dd5 | SaveButton | DM0003_MktFcstTest97.cs:1076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-16f0c65e | SaveButton | DM0003_MktFcstTest97.cs:1077 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-16c7cf08 | SaveButton | DM0003_MktFcstTest97.cs:1078 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-10268c08 | SaveButton | DM0003_MktFcstTest97.cs:1079 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-23fea1a0 | SaveButton | DM0003_MktFcstTest97.cs:1081 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c114f080 | SaveButton | DM0003_MktFcstTest97.cs:1083 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4f896644 | SaveButton | DM0003_MktFcstTest97.cs:1087 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1265e9c8 | SaveButton | DM0003_MktFcstTest97.cs:1091 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ba7e7f5 | SaveButton | DM0003_MktFcstTest97.cs:1093 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc3e3e09 | SaveButton | DM0003_MktFcstTest97.cs:1097 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-0ffcb06e | SaveButton | DM0003_MktFcstTest97.cs:1099 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f92f0141 | SaveButton | DM0003_MktFcstTest97.cs:1107 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBox | (ex.Message) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5547593 | SaveButton | DM0003_MktFcstTest97.cs:1117 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00034") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0003_MktFcstTest97.SetSaveData

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3014e68e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2988 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-00bcd849 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2992 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7611a0e8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2993 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1e05b5db | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2994 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Project] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-b4a20d55 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2995 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSiteId] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-33a8df4c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2996 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-783b2cba | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2997 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-26a3271a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2998 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-0de15e92 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:2999 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-e052bac1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3000 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-1096d5ed | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3001 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlantSiteId] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-b3081d2d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3002 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-1a0e15b1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3003 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-ff2e11b8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3005 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Customer40] | sEndCustomer40 | 행/컬럼 값 대입 |  |  |  |
| AC-0b53d40a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3006 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSiteId40] | sScmSiteId40 | 행/컬럼 값 대입 |  |  |  |
| AC-dfcdd910 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3007 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId40] | sItemId40 | 행/컬럼 값 대입 |  |  |  |
| AC-d3914489 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3009 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-99b3f761 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3010 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eea2c0cd | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3014 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-42d8166a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0003_MktFcstTest97.cs:3015 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0003_MktFcstTest97.SetSaveSheetColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1b2c5c9 | (진입점 미연결) | DM0003_MktFcstTest97.cs:1125 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-be841ab1 | (진입점 미연결) | DM0003_MktFcstTest97.cs:1132 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM \|\… | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-1317f494 | (진입점 미연결) | DM0003_MktFcstTest97.cs:1133 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM \|\… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(CAppSetting.StringAction), iRow, siMain.GetColumnIndex(CAppSe… | 그리드 표시 설정 |  |  |  |
| AC-840232c2 | (진입점 미연결) | DM0003_MktFcstTest97.cs:1134 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM \|\… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.Measure) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금 전환 |  |  |  |
| AC-1657473d | (진입점 미연결) | DM0003_MktFcstTest97.cs:1141 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0003_MktFcstTest97.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() >= 0…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0d3ed4a | this.chkSum.CheckedChanged [if (siMain != null)] 외 8 | DM0003_MktFcstTest97.cs:3184 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-63c20b46 | this.chkSum.CheckedChanged [if (siMain != null)] 외 8 | DM0003_MktFcstTest97.cs:3189 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d6cde90a | this.chkSum.CheckedChanged [if (siMain != null)] 외 8 | DM0003_MktFcstTest97.cs:3196 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-745b77c4 | this.chkSum.CheckedChanged [if (siMain != null)] 외 8 | DM0003_MktFcstTest97.cs:3200 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-104d7ad8 | this.chkSum.CheckedChanged [if (siMain != null)] 외 8 | DM0003_MktFcstTest97.cs:3205 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d255f1e1 | this.chkSum.CheckedChanged [if (siMain != null)] 외 8 | DM0003_MktFcstTest97.cs:3212 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3d09186d | this.chkSum.CheckedChanged [if (siMain != null)] 외 8 | DM0003_MktFcstTest97.cs:3216 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DM0003_MktFcstTest97.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (r…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fef9154 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:396 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95a9eff0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:404 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf2d8c30 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:417 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-32be3229 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:436 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7b8e10b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:437 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bdcd6c42 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:442 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4425b21 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:443 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5674f04a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:450 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c60e8d6b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:451 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8b450ad | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:462 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75d02e92 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:463 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e29d04e3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:464 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77698e80 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:465 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb1523cb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:467 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cfff387f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DM0003_MktFcstTest97.cs:469 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0003_MktFcstTest97.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c66f8ba | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1729 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumn… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-b49c1162 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1735 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol < siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetC… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-83aa9ce2 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1751 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1703ce1e | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1765 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aed226c1 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1790 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-bc2c4dfd | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1792 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e7e172c1 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1793 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5d78a212 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1794 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5515849a | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1804 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-4c62e1b7 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1808 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), sProjectName) | 그리드 값 설정 |  |  |  |
| AC-21f9b8a4 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1813 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), sProjectStatus) | 그리드 값 설정 |  |  |  |
| AC-e8d186fe | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1818 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), sBizType) | 그리드 값 설정 |  |  |  |
| AC-f0792772 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1823 | else of (e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectOwner), sProjectOwner) | 그리드 값 설정 |  |  |  |
| AC-11ee1502 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1853 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-65f9f469 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1856 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9010beb6 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1857 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-44a671ac | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1858 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-95fa1e1b | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1867 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-6aa3fa3e | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1871 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemName), sItemName) | 그리드 값 설정 |  |  |  |
| AC-7cde17e3 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1876 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemType), sItemType) | 그리드 값 설정 |  |  |  |
| AC-dbe55d69 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1881 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumn… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName) | 그리드 값 설정 |  |  |  |
| AC-c9d82437 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1909 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-f43b6fa3 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1912 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-b24a2220 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1913 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-957173f4 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1914 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ed035cf1 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1923 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, e.Column, sItemId) | 그리드 값 설정 |  |  |  |
| AC-0bd18f9b | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1927 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemName), sItemName) | 그리드 값 설정 |  |  |  |
| AC-3144705a | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1932 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ItemType), sItemType) | 그리드 값 설정 |  |  |  |
| AC-305006e3 | this.spdMain.CellDoubleClick | DM0003_MktFcstTest97.cs:1937 | else of (e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Project)) ▸ else of (e.Column == siMain.GetColumnIndex(DefC… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NickName), sNickName) | 그리드 값 설정 |  |  |  |

## DM0003_MktFcstTest97.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-877f4de2 | dsdm.Changed | DM0003_MktFcstTest97.cs:1985 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ca89fa9 | dsdm.Changed | DM0003_MktFcstTest97.cs:2058 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Division ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36c6a4ea | dsdm.Changed | DM0003_MktFcstTest97.cs:2060 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-10b2b4dd | dsdm.Changed | DM0003_MktFcstTest97.cs:2062 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5aa0464 | dsdm.Changed | DM0003_MktFcstTest97.cs:2068 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Project Code" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b16d710b | dsdm.Changed | DM0003_MktFcstTest97.cs:2070 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-35b22e63 | dsdm.Changed | DM0003_MktFcstTest97.cs:2072 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0945073e | dsdm.Changed | DM0003_MktFcstTest97.cs:2077 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Sales Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4ee114f6 | dsdm.Changed | DM0003_MktFcstTest97.cs:2079 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-4f1fad01 | dsdm.Changed | DM0003_MktFcstTest97.cs:2081 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2bd116ea | dsdm.Changed | DM0003_MktFcstTest97.cs:2085 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Item ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5d9ba14 | dsdm.Changed | DM0003_MktFcstTest97.cs:2087 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-2ae69f87 | dsdm.Changed | DM0003_MktFcstTest97.cs:2089 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8ba81a5 | dsdm.Changed | DM0003_MktFcstTest97.cs:2093 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "DOM/EXP" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd298df1 | dsdm.Changed | DM0003_MktFcstTest97.cs:2095 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-e404a00b | dsdm.Changed | DM0003_MktFcstTest97.cs:2097 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18045382 | dsdm.Changed | DM0003_MktFcstTest97.cs:2101 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "FCST Type" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23ac3475 | dsdm.Changed | DM0003_MktFcstTest97.cs:2103 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-b423938f | dsdm.Changed | DM0003_MktFcstTest97.cs:2105 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38d330da | dsdm.Changed | DM0003_MktFcstTest97.cs:2109 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Incoterms" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e30e9fb2 | dsdm.Changed | DM0003_MktFcstTest97.cs:2111 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-092a426a | dsdm.Changed | DM0003_MktFcstTest97.cs:2113 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-06e5f5d9 | dsdm.Changed | DM0003_MktFcstTest97.cs:2117 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Measure" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-26a86550 | dsdm.Changed | DM0003_MktFcstTest97.cs:2119 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-b979cedd | dsdm.Changed | DM0003_MktFcstTest97.cs:2121 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d945b1c3 | dsdm.Changed | DM0003_MktFcstTest97.cs:2125 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plant Site ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1eba437 | dsdm.Changed | DM0003_MktFcstTest97.cs:2127 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-b9a1ad4d | dsdm.Changed | DM0003_MktFcstTest97.cs:2129 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab796d30 | dsdm.Changed | DM0003_MktFcstTest97.cs:2150 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure40, false, sDivision, sSiteId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 화면 필드/플래그 변경 |  |  |  |
| AC-60f5672c | dsdm.Changed | DM0003_MktFcstTest97.cs:2150 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure40, false, sDivision, sSiteId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-069fcd2a | dsdm.Changed | DM0003_MktFcstTest97.cs:2154 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-d5703bed | dsdm.Changed | DM0003_MktFcstTest97.cs:2154 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf7832c4 | dsdm.Changed | DM0003_MktFcstTest97.cs:2156 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7c3a6aab | dsdm.Changed | DM0003_MktFcstTest97.cs:2182 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 2, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ede5985b | dsdm.Changed | DM0003_MktFcstTest97.cs:2206 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f4d97b30 | dsdm.Changed | DM0003_MktFcstTest97.cs:2424 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-4c1bd1ef | dsdm.Changed | DM0003_MktFcstTest97.cs:2433 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f0a707d2 | dsdm.Changed | DM0003_MktFcstTest97.cs:2449 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-32a6bd42 | dsdm.Changed | DM0003_MktFcstTest97.cs:2458 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-84d8102e | dsdm.Changed | DM0003_MktFcstTest97.cs:2481 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-eb245958 | dsdm.Changed | DM0003_MktFcstTest97.cs:2493 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-76222dd8 | dsdm.Changed | DM0003_MktFcstTest97.cs:2510 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-9edff1fd | dsdm.Changed | DM0003_MktFcstTest97.cs:2522 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iSetCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-444c6a64 | dsdm.Changed | DM0003_MktFcstTest97.cs:2552 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-c9dfdb68 | dsdm.Changed | DM0003_MktFcstTest97.cs:2579 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, sBucketType) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca483e02 | dsdm.Changed | DM0003_MktFcstTest97.cs:2790 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-bc1a78a9 | dsdm.Changed | DM0003_MktFcstTest97.cs:2799 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b1400582 | dsdm.Changed | DM0003_MktFcstTest97.cs:2814 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-a92ce54c | dsdm.Changed | DM0003_MktFcstTest97.cs:2823 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-88896598 | dsdm.Changed | DM0003_MktFcstTest97.cs:2843 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-94a6aefd | dsdm.Changed | DM0003_MktFcstTest97.cs:2876 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d9e6133c | dsdm.Changed | DM0003_MktFcstTest97.cs:2882 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f2bc68c9 | dsdm.Changed | DM0003_MktFcstTest97.cs:2941 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iWeekCol, iWeeklySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DM0003_MktFcstTest97.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40a5f027 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1546 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | FLAG | dtTeamSpr | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-b5bcee6a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1546 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-46dc2725 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1548 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Team), dtTeamSpr) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-105c9527 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1555 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-9373cb5d | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1555 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d1d228a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1556 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-59cd3d5e | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1567 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer40) > 0) | FLAG | dtCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-915220c2 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1567 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer40) > 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-88af2ddd | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1568 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer40) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer40), dtCustomer40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c65639b6 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1574 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (cboDivision.ControlValues != "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-ce97b522 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1574 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d9c1cb4 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1575 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (cboDivision.ControlValues != "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-434cd524 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1579 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (cboDivision.ControlValues != "40") | FLAG | dtSalesSite40 | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-8de8255f | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1579 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (cboDivision.ControlValues != "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bbdb22c1 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1580 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (cboDivision.ControlValues != "40") | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a6df943e | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1583 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-5c711929 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1583 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed265009 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1584 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1445cc27 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1586 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c41c57c8 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1587 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-123dde9a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1591 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (sDivision == "81") | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1737000e | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1595 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (sDivision == "81") | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d0da447a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1604 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-1faba91a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1604 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3748001 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1605 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-96401d13 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1613 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnInde… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure40, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a5fa9317 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1613 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnInde… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure40, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c22ac64e | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1614 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ff1491c6 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1624 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-6dd351a1 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1624 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-09553d1b | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1625 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0bed8257 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1628 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-a769a64f | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1628 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a1d28dc3 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1629 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-181946df | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1642 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-abb4b185 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1642 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-533f479a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1645 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-105d2527 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1648 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-aa769ec8 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1648 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d53a53f | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1649 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0565aad2 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1658 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-0582f662 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1658 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eaaf1fd9 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1659 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b86fa24c | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1667 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-907a1889 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1667 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-90fdfa42 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1668 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1a6e41bb | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1673 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-cedd1a8a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1677 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), "") | 그리드 값 설정 |  |  |  |
| AC-6f637507 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1682 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), "") | 그리드 값 설정 |  |  |  |
| AC-cc25a8d1 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1687 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), "") | 그리드 값 설정 |  |  |  |
| AC-0c9ab935 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1692 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-ae21481c | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1701 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-a72aa981 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1701 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f77c3080 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1702 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8ec5ea3a | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1714 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure40, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 화면 필드/플래그 변경 |  |  |  |
| AC-3caf45c3 | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1714 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure40, false, sDivisionID, sScmSiteID, "", "", "") ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f027aeca | this.spdMain.ComboSelChange | DM0003_MktFcstTest97.cs:1715 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DM0003_MktFcstTest97.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46cb5810 | this.spdMain.KeyUp | DM0003_MktFcstTest97.cs:3029 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6739e73 | this.spdMain.KeyUp | DM0003_MktFcstTest97.cs:3033 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0bbe1ac | this.spdMain.KeyUp | DM0003_MktFcstTest97.cs:3039 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b02b9f9a | this.spdMain.KeyUp | DM0003_MktFcstTest97.cs:3040 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DM0003_MktFcstTest97.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87a3fd0c | this.spdMain.TopChange | DM0003_MktFcstTest97.cs:3023 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0003_TEST.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72c7e872 | this.Load | DM0003_TEST.cs:84 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-015c0059 | this.Load | DM0003_TEST.cs:85 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-66270912 | this.Load | DM0003_TEST.cs:86 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0003_TEST.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e3a6e60 | DeleteButton | DM0003_TEST.cs:119 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DM0003_TEST.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ccced86 | Dispose | DM0003_TEST.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0003_TEST.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae6e3ea7 | EditButton | DM0003_TEST.cs:126 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b41b5e5 | EditButton | DM0003_TEST.cs:127 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-1cfafd4a | EditButton | DM0003_TEST.cs:129 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.Column1), siMain.GetColumnIndex(DefColumns.Column3), tru… | 그리드 편집 잠금/해제 |  |  |  |

## DM0003_TEST.FindData

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f578807 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:149 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.DM.REPORT/FoxDataService.svc"… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef929766 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:153 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF_QTEST001") ⇒ DM.DMF_QTEST001 | 엔드포인트 요청 생성 |  |  |  |
| AC-2297c191 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:154 | lambda | DATA_OP | request.Parameters["Search"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bc4feef8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:155 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc98f72f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:157 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c765349c | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:161 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5e813be8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:162 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0c1dff21 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:165 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c140b88d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:170 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a41f6d9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:170 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-88a7cd02 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DM0003_TEST.cs:171 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0003_TEST.FindData_BIZ

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ae9e755 | FindButton | DM0003_TEST.cs:181 |  | ENDPOINT | new FoxBizRequest | ("Authentication", "DoAuthentication") ⇒ biz:Authentication.DoAuthentication | 엔드포인트 요청 생성 |  |  |  |
| AC-a210f44a | FindButton | DM0003_TEST.cs:184 |  | DATA_OP | request.Parameters["id"] | "20140001" | 행/컬럼 값 대입 |  |  |  |
| AC-f59bcb33 | FindButton | DM0003_TEST.cs:186 |  | DATA_OP | request.Parameters["password"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f62d683c | FindButton | DM0003_TEST.cs:187 |  | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2963fd5 | FindButton | DM0003_TEST.cs:195 |  | ENDPOINT | new FoxBizRequest | ("GSCM_DM_Report_BLL", "BLL_DM_REORT_M") ⇒ biz:GSCM_DM_Report_BLL.BLL_DM_REORT_M | 엔드포인트 요청 생성 |  |  |  |
| AC-650ce201 | FindButton | DM0003_TEST.cs:196 |  | DATA_OP | request.Parameters["search"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bafdc405 | FindButton | DM0003_TEST.cs:197 |  | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-248f45e5 | FindButton | DM0003_TEST.cs:203 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxBizClient("GSCM", "GSCM.DM.REPORT.WSL/FoxBizService.sv… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-56f986fc | FindButton | DM0003_TEST.cs:207 | lambda | ENDPOINT | new FoxBizRequest | ("GSCM_DM_Report_BLL", "BLL_DM_REORT_M") ⇒ biz:GSCM_DM_Report_BLL.BLL_DM_REORT_M | 엔드포인트 요청 생성 |  |  |  |
| AC-099098b0 | FindButton | DM0003_TEST.cs:208 | lambda | DATA_OP | request.Parameters["search"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-614fd5cf | FindButton | DM0003_TEST.cs:209 | lambda | ENDPOINT | client.Execute | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba73ec6e | FindButton | DM0003_TEST.cs:210 | lambda | RETURN | return (DataSet)response.Result; |  | 처리 중단/반환 |  |  |  |
| AC-adf692b9 | FindButton | DM0003_TEST.cs:214 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ccf6b2fd | FindButton | DM0003_TEST.cs:215 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d68fdc17 | FindButton | DM0003_TEST.cs:218 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4251e0c6 | FindButton | DM0003_TEST.cs:223 |  | FLAG | saveDS | ds.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-4979afd4 | FindButton | DM0003_TEST.cs:223 |  | DATA_OP | ds.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-408f49f1 | FindButton | DM0003_TEST.cs:224 |  | DATA_OP | saveDS.Tables[0].Columns.Add | ("A", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |

## DM0003_TEST.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0109d9f5 | this.Load | DM0003_TEST.cs:69 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0003_TEST.InitSpread

진입점: this.Load / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ab3e58d | this.Load 외 2 | DM0003_TEST.cs:93 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7733a9cd | this.Load 외 2 | DM0003_TEST.cs:95 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f073618a | this.Load 외 2 | DM0003_TEST.cs:96 |  | GRID_INIT | siMain.AddTextColumn | ("Column1", DefColumns.Column1, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc837984 | this.Load 외 2 | DM0003_TEST.cs:97 |  | GRID_INIT | siMain.AddTextColumn | ("Column2", DefColumns.Column2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf400af5 | this.Load 외 2 | DM0003_TEST.cs:98 |  | GRID_INIT | siMain.AddTextColumn | ("Column3", DefColumns.Column3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-212bc168 | this.Load 외 2 | DM0003_TEST.cs:100 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Column3)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DM0003_TEST.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b132c0ba | InsertButton | DM0003_TEST.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8efcd45b | InsertButton | DM0003_TEST.cs:318 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column1, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-661d2ec6 | InsertButton | DM0003_TEST.cs:319 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column2, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e3307aa | InsertButton | DM0003_TEST.cs:320 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.Column3, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-74030a36 | InsertButton | DM0003_TEST.cs:322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## DM0003_TEST.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cecd7c0 | SaveButton | DM0003_TEST.cs:234 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (saveDS != null) | STATE_RESET | saveDS.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e693790b | SaveButton | DM0003_TEST.cs:243 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33d4cf99 | SaveButton | DM0003_TEST.cs:245 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["A"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-2ac2ad4a | SaveButton | DM0003_TEST.cs:246 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-97463ae6 | SaveButton | DM0003_TEST.cs:247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3b4a583 | SaveButton | DM0003_TEST.cs:248 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr[DefColumns.Column3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.Column3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-84fa4fff | SaveButton | DM0003_TEST.cs:249 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dr["RegtUserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-66903e6f | SaveButton | DM0003_TEST.cs:251 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef2e33f9 | SaveButton | DM0003_TEST.cs:254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8caf070b | SaveButton | DM0003_TEST.cs:257 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3911f8b1 | SaveButton | DM0003_TEST.cs:258 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | DATA_OP | a.Field | (DefColumns.Column2) | 데이터 객체 조작/조회 |  |  |  |
| AC-73113a8e | SaveButton | DM0003_TEST.cs:269 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de44d419 | SaveButton | DM0003_TEST.cs:270 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cnt > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3519545 | SaveButton | DM0003_TEST.cs:279 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dbcc0070 | SaveButton | DM0003_TEST.cs:280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | CALL_EXT | saveDS.Tables[0].Rows[i].SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-abd8e3ab | SaveButton | DM0003_TEST.cs:281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < saveDS.Tables[0].Rows… | DATA_OP | saveDS.Tables[0].Rows[i].Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-86fae44d | SaveButton | DM0003_TEST.cs:285 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.InsertQueryId | "xxxx.InsertQueryId" | 속성 InsertQueryId 설정 |  |  |  |
| AC-d011f90c | SaveButton | DM0003_TEST.cs:286 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DeleteQueryId | "xxxx.DeleteQueryId" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-fcd3b1e6 | SaveButton | DM0003_TEST.cs:287 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.UpdateQueryId | "xxxx.UpdateQueryId" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-8bcf76af | SaveButton | DM0003_TEST.cs:289 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-d594df39 | SaveButton | DM0003_TEST.cs:289 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-013cf562 | SaveButton | DM0003_TEST.cs:293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.xxxx.WSL/FoxDataService.svc")… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-618f66c8 | SaveButton | DM0003_TEST.cs:297 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-80e178f0 | SaveButton | DM0003_TEST.cs:297 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-d02acb0f | SaveButton | DM0003_TEST.cs:302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

