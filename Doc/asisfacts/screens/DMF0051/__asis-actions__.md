# AS-IS 액션 대조표 — DMF0051

> 원천: `Doc/asisfacts/screens/DMF0051/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1193행 · 메서드 139 · 종류 DATA_OP 296 · FLAG 123 · RETURN 109 · GRID_SET 98 · UI_PROP 79 · ENDPOINT 71 · CALL_EXT 70 · LIST_REBIND 45 · GRID_INIT 45 · POPUP 42 · STATE 37 · UI_MISC 35 · COMBO_DATA 33 · MESSAGE 29 · GRID_LOCK 22 · VALUE_SET 19 · VALUE_CLEAR 12 · THROW 7 · GRID_BIND 5 · GRID_STYLE 5 · LIST_BIND 4 · GRID_COMBO 4 · VALIDATE 3 · ⚠ 의미 확인 필요 70


## DMF0051_1_BizPlanWaterfall.btnBPCutOff_Click

진입점: this.btnBPCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-614f343a | this.btnBPCutOff.Click | DMF0051_1_BizPlanWaterfall.cs:4680 |  | POPUP | new DMF0071_BPCutOffPopup | (sDivision) | 팝업/폼 생성 |  |  |  |
| AC-7d13a8da | this.btnBPCutOff.Click | DMF0051_1_BizPlanWaterfall.cs:4681 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-58fd5e08 | this.btnBPCutOff.Click | DMF0051_1_BizPlanWaterfall.cs:4682 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52ee200e | this.btnColumn.Click | DMF0051_1_BizPlanWaterfall.cs:1664 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-fba5f3f1 | this.btnColumn.Click | DMF0051_1_BizPlanWaterfall.cs:1665 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-326f945c | this.btnColumn.Click | DMF0051_1_BizPlanWaterfall.cs:1666 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnConfirmBP_Click

진입점: this.btnConfirmBP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69f5af0a | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4052 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c00cde55 | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4052 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b38a46c6 | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4059 | if (siMain.ActiveRowIndex == -1) | MESSAGE | MessageBox.Show | ("조회 후 시도해 주세요") | 메시지 표시 |  |  |  |
| AC-e36a3935 | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4060 | if (siMain.ActiveRowIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a2d74a3 | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4068 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_1_BIZPLAN_TO_BPS") ⇒ DM.DMF0051_1_BIZPLAN_TO_BPS | 엔드포인트 요청 생성 |  |  |  |
| AC-aa7207f5 | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4069 |  | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-46274f6e | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4070 |  | DATA_OP | request.Parameters["p_version_no"] | pVersion_No | 행/컬럼 값 대입 |  |  |  |
| AC-8770356e | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4072 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df93a70b | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4077 | if (sRet != "SUCCESS") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-23569992 | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4078 | if (sRet != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-596a69c8 | this.btnConfirmBP.Click | DMF0051_1_BizPlanWaterfall.cs:4082 | else of (sRet != "SUCCESS") | MESSAGE | MessageBox.Show | ("BPS로 데이터 생성이 완료되었습니다.") | 메시지 표시 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9156c41 | this.btnItemId.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1653 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-37b2ed51 | this.btnItemId.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1655 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a9052b4d | this.btnItemId.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1656 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9100ade2 | this.btnItemId.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1657 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d50d1132 | this.btnItemId.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1659 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-583f94a6 | this.btnMeasure.Click | DMF0051_1_BizPlanWaterfall.cs:1676 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-c50a3d18 | this.btnMeasure.Click | DMF0051_1_BizPlanWaterfall.cs:1677 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-70f875d6 | this.btnMeasure.Click | DMF0051_1_BizPlanWaterfall.cs:1678 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnOwner_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f2bcb0f | this.usrButton1.Click | DMF0051_1_BizPlanWaterfall.cs:2319 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b670c777 | this.usrButton1.Click | DMF0051_1_BizPlanWaterfall.cs:2321 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ad6b658b | this.usrButton1.Click | DMF0051_1_BizPlanWaterfall.cs:2322 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e799e6ff | this.usrButton1.Click | DMF0051_1_BizPlanWaterfall.cs:2323 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-eb6aa473 | this.usrButton1.Click | DMF0051_1_BizPlanWaterfall.cs:2325 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnProject_Click

진입점: this.btnProject.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70886111 | this.btnProject.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1635 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-28657164 | this.btnProject.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1636 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4fb8976d | this.btnProject.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1637 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-227f3a19 | this.btnProject.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1638 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2915e08e | this.btnProject.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:1640 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnReleaseSCP_Click

진입점: this.btnReleaseSCP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0f0e09c | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4020 | if (siMain.ActiveRowIndex == -1) | MESSAGE | MessageBox.Show | ("조회 후 시도해 주세요") | 메시지 표시 |  |  |  |
| AC-16a76d1c | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4021 | if (siMain.ActiveRowIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f392b31 | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4028 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_DM_PLN_BIZPLAN_TO_NET_DEMAND") ⇒ DM.PR_DM_PLN_BIZPLAN_TO_NET_DEMAND | 엔드포인트 요청 생성 |  |  |  |
| AC-78a7182e | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4029 |  | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e662fb5a | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4030 |  | DATA_OP | request.Parameters["p_version_no"] | pVersion_No | 행/컬럼 값 대입 |  |  |  |
| AC-df71e5a1 | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4032 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-495659b0 | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4037 | if (sRet != "SUCCESS") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-de06301e | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4038 | if (sRet != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f20e02c | this.btnReleaseSCP.Click | DMF0051_1_BizPlanWaterfall.cs:4042 | else of (sRet != "SUCCESS") | MESSAGE | MessageBox.Show | ("NET DEMAND 생성이 완료되었습니다.") | 메시지 표시 |  |  |  |

## DMF0051_1_BizPlanWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-608558a5 | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2280 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d8955d24 | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2281 |  | POPUP | popVersion.Form_Load | (true, "BP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9151f3c3 | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2282 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-75f02629 | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2283 |  | CALL_EXT | popVersion.weekChecked | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d334fffc | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2284 |  | CALL_EXT | popVersion.monthChecked | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1eb5c6c6 | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2285 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-87d4c4dc | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2289 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-eb8d20f9 | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2290 | if (popVersion.sVersions != "") | FLAG | this.createDate | popVersion.CreateDate | 화면 필드/플래그 변경 |  |  |  |
| AC-db899602 | this.btnVersion.Click 외 1 | DMF0051_1_BizPlanWaterfall.cs:2291 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.cboKRW_SelectedIndexChanged

진입점: this.cboKRW.SelectedIndexChanged / cboKRW.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32b4e450 | this.cboKRW.SelectedIndexChanged 외 1 | DMF0051_1_BizPlanWaterfall.cs:1950 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.cboLOC_SelectedIndexChanged

진입점: this.cboLOC.SelectedIndexChanged / cboLOC.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ed6452f | this.cboLOC.SelectedIndexChanged 외 1 | DMF0051_1_BizPlanWaterfall.cs:1967 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-914d8dff | this.cboQTY.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1975 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.cboUSD_SelectedIndexChanged

진입점: this.cboUSD.SelectedIndexChanged / cboUSD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dac84370 | this.cboUSD.SelectedIndexChanged 외 1 | DMF0051_1_BizPlanWaterfall.cs:1959 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c17fa8ca | this.clbCustomer.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1939 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cf7caa1 | this.clbCustomer.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1941 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14b7370a | this.clbCustomer.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1943 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-b3f6c128 | this.clbCustomer.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1943 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-35842651 | this.clbCustomer.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1944 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0051_1_BizPlanWaterfall.ClbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfaa638e | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1218 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bbaab90a | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1222 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-af13a042 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1222 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3c14840c | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1223 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d2623841 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1229 | try ▸ if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString()… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b1058ad | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1229 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString(), clbTeam.C… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7f8cd43 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1231 | try ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-341c9b0d | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1231 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-444bf962 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1232 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-15b9a8cf | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1234 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7d0ac42e | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1235 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a05ca719 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1236 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9cc613e5 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1237 | try ▸ if (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b37aa670 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1241 | try ▸ else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-70dcf2d9 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1241 | try ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1d469be | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1243 | try ▸ else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivisionAsync(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-578f5814 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1244 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9ed05414 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1246 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4e469736 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1247 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9bc1320f | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1248 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d50fa9b4 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1249 | try ▸ else of (sDivision == "40") | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-96fae3f1 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1252 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d148daf2 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1254 | try | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d3ab6b78 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1258 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b6d5a20 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1258 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6c6b7844 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1259 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2f1e0406 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1261 | try | FLAG | dtPlantSite | Data.UserPlantSiteByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curren… | 화면 필드/플래그 변경 |  |  |  |
| AC-fdfc8894 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1261 | try | COMBO_DATA | Data.UserPlantSiteByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5efa5abc | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1262 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-adbd6279 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1270 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0a994c06 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1271 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ee486771 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1272 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-872270ea | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1273 | try | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c1343c4e | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1281 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-438a3014 | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1282 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-2218f26e | this.clbDivision.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1286 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_BizPlanWaterfall.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a0569d4 | clbPlantSite.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1306 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-291604f1 | clbPlantSite.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1308 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.ClbSalesSite_SelectedIndexChanged

진입점: clbSalesSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fa4f7f7 | clbSalesSite.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1295 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f958143 | clbSalesSite.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:1297 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4d745fc | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2242 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaa2d9c7 | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2244 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3d767be | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2251 | if (sDivision == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f019f61 | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2251 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04706cb3 | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2255 | else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-42c1ca58 | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2255 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cb28b36f | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2257 |  | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-903ca563 | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2261 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ad383952 | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2261 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-768ae6cc | this.clbTeam.SelectedIndexChanged | DMF0051_1_BizPlanWaterfall.cs:2262 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0051_1_BizPlanWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb90ec1a | this.Load | DMF0051_1_BizPlanWaterfall.cs:352 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-037263f4 | this.Load | DMF0051_1_BizPlanWaterfall.cs:353 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e71cb55 | this.Load | DMF0051_1_BizPlanWaterfall.cs:354 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0051_1_BizPlanWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c5b9304 | this.Load | DMF0051_1_BizPlanWaterfall.cs:317 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-c113c83e | this.Load | DMF0051_1_BizPlanWaterfall.cs:318 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-fbf06dec | this.Load | DMF0051_1_BizPlanWaterfall.cs:321 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-6182fb82 | this.Load | DMF0051_1_BizPlanWaterfall.cs:322 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_BizPlanWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a8c1fa3 | Dispose | DMF0051_1_BizPlanWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0051_1_BizPlanWaterfall.DM0051_BizPlanWaterfall_FormClosed

진입점: this.FormClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d61d448d | this.FormClosed | DMF0051_1_BizPlanWaterfall.cs:2299 | try | CALL_EXT | GC.SuppressFinalize | (this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1344d29 | this.FormClosed | DMF0051_1_BizPlanWaterfall.cs:2301 | try | CALL_EXT | GC.Collect | (0, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea9265a3 | this.FormClosed | DMF0051_1_BizPlanWaterfall.cs:2302 | try | CALL_EXT | GC.Collect | (1, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eddb99ec | this.FormClosed | DMF0051_1_BizPlanWaterfall.cs:2303 | try | CALL_EXT | GC.Collect | (2, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_1_BizPlanWaterfall.Draw

진입점: FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e08fc473 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4197 | if (data_start_pos < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-699746b9 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4211 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8f763a82 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4228 | for (j < maxCol) | DATA_OP | colnames[j - data_start_pos] | siMain.GetColumnTag(j) | 행/컬럼 값 대입 |  |  |  |
| AC-a5d475c3 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4247 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ if (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Plan_Con… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2cf6df6 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4249 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ if (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Plan_Con… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-acb6ac22 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4268 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a7271ea | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4270 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b667e54 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4272 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f92e8e06 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4274 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-eeab192f | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4276 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-159c4909 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4320 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-41d23636 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4322 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.#0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-eafe6d5a | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4324 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.#0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a129f63 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4326 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.##") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9b8e2f8 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4360 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-48eebe8d | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4362 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.#00") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90800c75 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4364 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-39c6b21f | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4366 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e4c3a5c | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4368 | for (j < maxCol) ▸ for (i < maxRow) ▸ if (Val != "" && Val != "0") ▸ else of (strMeasure == "Business_Plan" \|\| strMeasure == "Business_Pla… | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###.###") | ⚠ 의미 확인 필요 |  |  |  |
| AC-96dfff06 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4403 | for (j < maxCol) ▸ for (i < maxRow) ▸ else of (Val != "" && Val != "0") | CALL_EXT | siMain.SetRowFormat | (i, j, maxCol - data_start_pos, "###,###,###,##0") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c47cf54d | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:4410 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0051_1_BizPlanWaterfall.EditButton

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f2d80f6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:454 | if (this.fps != null) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-576e6e61 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:455 | if (this.fps != null) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5916c51 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:458 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d572afba | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:459 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c7881993 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:468 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-211a74f2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:471 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (siMain.… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6abfaae6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:477 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-474fe028 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:480 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBuck… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-11a38fea | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:486 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-02435926 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:489 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cb… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2e44f09 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:504 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-96c43ce7 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:511 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IsEditMode == false) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-877c9b98 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:512 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IsEditMode == false) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-caafddc3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:518 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ if (siMain… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].BackColor | Color.AliceBlue | 그리드 속성/값 설정 |  |  |  |
| AC-bd5d5c00 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:519 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ if (siMain… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.DarkBlue | 그리드 속성/값 설정 |  |  |  |
| AC-746cac29 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:523 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ else of (s… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].BackColor | Color.PaleGoldenrod | 그리드 속성/값 설정 |  |  |  |
| AC-678e9951 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:524 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ else of (s… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Maroon | 그리드 속성/값 설정 |  |  |  |
| AC-7504cae0 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:531 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), fa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c120ba6a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:562 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if ((sEdit == CAppSetting.StringY)) ▸ if (sD… | MESSAGE | MessageBox.Show | ("BizPlanPrice_CUR") | 메시지 표시 |  |  |  |
| AC-7a37aa63 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:575 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if ((sEdit == CAppSetting.StringY)) ▸ if (sD… | GRID_LOCK | siMain.LockRange | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-34177792 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:586 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if ((sEdit == CAppSetting.StringY)) ▸ if (sD… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), fa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3885f136 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:590 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if ((sEdit == CAppSetting.StringY)) ▸ if (sD… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-350489af | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:611 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if ((sEdit == CAppSetting.StringY)) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRow, iColumn, iRow, iColumn, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed660a1e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:622 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if ((sEdit == CAppSetting.StringY)) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), fa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-62549920 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:626 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if ((sEdit == CAppSetting.StringY)) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-31a7e427 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:639 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ if (s… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].BackColor | Color.AliceBlue | 그리드 속성/값 설정 |  |  |  |
| AC-76093d7d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:640 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ if (s… | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.DarkBlue | 그리드 속성/값 설정 |  |  |  |
| AC-180730a2 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:644 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].BackColor | Color.PaleGoldenrod | 그리드 속성/값 설정 |  |  |  |
| AC-7d1c3df1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 2 | DMF0051_1_BizPlanWaterfall.cs:645 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (IsEditMode == false) ▸ if (iRow != siMain.GetMaxRowIndex()) ▸ else … | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Maroon | 그리드 속성/값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e39f472 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:700 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-72acdfa3 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:701 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-67f48d62 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:702 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-f23a054b | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:703 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-622196aa | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:704 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-36958a50 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:705 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-7fa55dc3 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:707 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-976a0af1 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:708 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-f9ab0f75 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:710 |  | UI_PROP | exportOption.AmendDecimalFormat | "###,###,###,##0;[Red]-###,###,###,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-f61164aa | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:719 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d89f40d5 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:724 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0e8f5f23 | ExcelButton | DMF0051_1_BizPlanWaterfall.cs:728 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0051_1_BizPlanWaterfall.ExportExcel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4a0bd30 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4421 |  | UI_PROP | ExcelOptionEx.Border | ExcelBorderOptionEx.All | 속성 Border 설정 |  |  |  |
| AC-ccc92c84 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4422 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-21f27ee0 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4425 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b478b53 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4431 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8bb25dbc | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4439 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a61fb9a2 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4443 | try ▸ if (myarray.Length == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8341d1c4 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4444 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-830c6066 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4448 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-65d8c5f9 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4490 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-40eb5aa3 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4490 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-550f94c7 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4496 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-e0f18833 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4510 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-18bb9ad5 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4514 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (RemoveActionCell == tr… | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5518dbe8 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4518 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-74c3e090 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4530 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-2960de4c | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4531 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-1722e8f5 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4540 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-7583656b | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4541 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-1c6eaeb0 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4547 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-e9252cc9 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4556 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7b6968b | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4558 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-618687d6 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4570 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (ignoreDepth > 0) ▸ for (i < newSheet.RowCount) ▸ for (j < collen) ▸ if (newSheet.Cells… | GRID_SET | newSheet.Cells[i, j].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-a5a6cf5e | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4581 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-0e8f73b8 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4590 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-29cf6d41 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4597 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7b1e577 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4605 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: ▸ if (newSheet.Fr… | UI_PROP | si.MaxRightMerge | newSheet.FrozenColumnCount | 속성 MaxRightMerge 설정 |  |  |  |
| AC-15b031ef | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4607 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | CALL_EXT | si.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e735804b | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4612 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.SeperatedRows: case ExcelExp… | CALL_EXT | si.UnMerge | (newSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13af4b2a | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4620 | try ▸ if (ExcelOptionEx.Border == ExcelBorderOptionEx.All) | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-5847cbc2 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4624 | try ▸ else of (ExcelOptionEx.Border == ExcelBorderOptionEx.All) ▸ if (ExcelOptionEx.Border == ExcelBorderOptionEx.None) | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-06b67213 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4628 | try ▸ else of (ExcelOptionEx.Border == ExcelBorderOptionEx.All) ▸ else of (ExcelOptionEx.Border == ExcelBorderOptionEx.None) ▸ if (ExcelOpti… | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, false, false, true, false) | 속성 Border 설정 |  |  |  |
| AC-1a7cadb9 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4631 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-ac02d48b | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4635 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-dd72b480 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4637 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-2887cc4d | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4640 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-f4d66ab6 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4642 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-0a4e1eaa | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4647 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-bb94f88e | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4657 | try | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b99a0990 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4662 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-588482d0 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4668 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1690504f | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:4672 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0051_1_BizPlanWaterfall.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ba7baa2 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:750 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d1c17f5b | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:757 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f3e7fe1d | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:758 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4aedc9d | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:761 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-896e6363 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:763 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-a6f96e5e | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:763 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ad05231 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:773 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5e99f52 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:774 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-918b3e49 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:780 | try ▸ if (drpPeriod.Value1.AddYears(10) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e1f7c1d | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:782 | try ▸ if (drpPeriod.Value1.AddYears(10) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(10) | 속성 Value2 설정 |  |  |  |
| AC-8cd1d791 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:784 | try ▸ if (drpPeriod.Value1.AddYears(10) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fd1d6e5 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:788 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a84b34b8 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:790 | try | CALL_EXT | Convert.ToInt32(sEndDate).CompareTo | (Convert.ToInt32(sNowDate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a103752 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:810 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93a6a06b | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:811 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48f4fecb | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:815 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fc6f3ce0 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:824 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8aa45527 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:826 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-09448a43 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:831 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_1_GET_DM_PLN_BIZ_PLAN_WATERFALL") ⇒ DM.DMF0051_1_GET_DM_PLN_BIZ_PLAN_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-29eaed4c | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:833 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4ccaf20e | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:835 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e3651f16 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:836 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-20c23c25 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:837 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-ca0da4ab | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:838 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-e58af50b | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:839 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-577e7f7a | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:840 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-916d8586 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:841 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-56e745ab | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:842 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-56ff879e | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:843 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-fce0c2cb | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:844 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-253810cd | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:845 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d2e62775 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:846 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-fea95bcf | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:847 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-ed954283 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:848 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-ad67d10a | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:849 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-a94c9e06 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:850 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_yn"] | (cboCellQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-b8598ba4 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:853 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cbxQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e5866766 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:854 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-631a43ea | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:855 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-751be9c6 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:858 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62f3a315 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:860 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0503bfdf | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:865 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a51082fb | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:871 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-683ebf5b | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1004 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4ff587ed | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1006 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1824266e | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1011 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-3b75e11e | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1019 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") ▸ if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-08c86e83 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1023 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8daa5d73 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1043 | try ▸ try ▸ if (chkMem.Checked == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0a913b6d | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1120 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-bf34a9da | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1127 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) ▸ if (sLockDate.In… | GRID_STYLE | siMain.SetBGColor | (i, iResultYear, i, iResultYear, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-29753d51 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1136 | try ▸ catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBoxForException | (e) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7799c11c | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1148 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i != siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(i, siMain.GetColumnIndex(DefColumns.MEASUR… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].BackColor | Color.AliceBlue | 그리드 속성/값 설정 |  |  |  |
| AC-8f7a2320 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1149 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i != siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(i, siMain.GetColumnIndex(DefColumns.MEASUR… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.DarkBlue | 그리드 속성/값 설정 |  |  |  |
| AC-b80b15d1 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1153 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i != siMain.GetMaxRowIndex()) ▸ else of (siMain.GetText(i, siMain.GetColumnIndex(DefColumns.M… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].BackColor | Color.PaleGoldenrod | 그리드 속성/값 설정 |  |  |  |
| AC-20f2c91a | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1154 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (i != siMain.GetMaxRowIndex()) ▸ else of (siMain.GetText(i, siMain.GetColumnIndex(DefColumns.M… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.MEASURE)].ForeColor | Color.Maroon | 그리드 속성/값 설정 |  |  |  |
| AC-a29e4643 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1163 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-5109249c | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1164 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a75c96c7 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1174 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f2e39ff | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1193 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9df011d4 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1198 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78644520 | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1204 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7ccc871e | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1205 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1668f52d | FindButton 외 1 | DMF0051_1_BizPlanWaterfall.cs:1206 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0051_1_BizPlanWaterfall.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dce9ad1a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0051_1_BizPlanWaterfall.cs:3015 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-ea0660a9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0051_1_BizPlanWaterfall.cs:3057 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-433a06e3 | this.Load | DMF0051_1_BizPlanWaterfall.cs:194 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-15cac673 | this.Load | DMF0051_1_BizPlanWaterfall.cs:196 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetBizTypebyDivision

진입점: this.Load [try ▸ else of (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7b8faed | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_1_BizPlanWaterfall.cs:1881 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-3a833339 | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_1_BizPlanWaterfall.cs:1882 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a38fdfe6 | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_1_BizPlanWaterfall.cs:1883 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ff7b4b98 | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_1_BizPlanWaterfall.cs:1886 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetBizTypebyDivisionAsync

진입점: this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-def42485 | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_1_BizPlanWaterfall.cs:1895 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-1c3e41bb | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_1_BizPlanWaterfall.cs:1896 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-658ec04b | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_1_BizPlanWaterfall.cs:1897 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e49ff183 | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_1_BizPlanWaterfall.cs:1900 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6569baa | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1854 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-077a41e8 | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1855 |  | DATA_OP | request.Parameters["p_lookup_type"] | "BUCKET2_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-209d099b | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1856 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a21be90c | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1858 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Column) \|\| (siMain.GetColumnIndex(DefColumns.UNIT_ENERGY) == e.Column))] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagM) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b61815ae | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 1 | DMF0051_1_BizPlanWaterfall.cs:3068 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetComboData

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d05d914c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4122 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0009_GET_CODE") ⇒ DM.DMF0009_GET_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-c4b68e9c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4123 |  | DATA_OP | request.Parameters["p_code_type"] | code | 행/컬럼 값 대입 |  |  |  |
| AC-7d7e844b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4124 |  | DATA_OP | request.Parameters["p_param1"] | (param1 == null ? "" : param1) | 행/컬럼 값 대입 |  |  |  |
| AC-3e97569f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4125 |  | DATA_OP | request.Parameters["p_param2"] | (param2 == null ? "" : param2) | 행/컬럼 값 대입 |  |  |  |
| AC-c821efce | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4126 |  | DATA_OP | request.Parameters["p_param3"] | (param3 == null ? "" : param3) | 행/컬럼 값 대입 |  |  |  |
| AC-8415bb88 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4128 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5693ca27 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4130 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bce1b16 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:1818 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-9e345371 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:1819 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ed5aa3e7 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:1820 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-457ad7bf | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:1822 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9280e766 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:1825 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-004609b3 | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1867 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-c596ac42 | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1868 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-7e47842b | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1869 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cf83e313 | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1872 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59876a28 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1413 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-0e45a98d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1414 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-646db67b | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1415 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-6ad50f71 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1416 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-5f28af57 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1417 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-29d31e7d | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1420 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetQtyData

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab6e73a8 | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1909 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-1c9a22e2 | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1910 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b76138e0 | this.Load [try] | DMF0051_1_BizPlanWaterfall.cs:1913 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44a5cacf | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1397 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-85ec0408 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1398 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e0b0468a | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1399 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-3ea034d9 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1400 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-3aa09e08 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1401 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f7626d7 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_1_BizPlanWaterfall.cs:1404 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62b4d87b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1831 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-6073661f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1835 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_1_GET_SPREAD_TITLE") ⇒ DM.DMF0051_1_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-3f0e0549 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1836 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-a1944cd1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1837 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-18522771 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1838 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-92e10a58 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1839 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-359a83ad | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1840 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-7e3186ac | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1842 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4a0852a5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1842 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ef3af49 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1843 |  | FLAG | dtTitle | dsSpdTitle.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2fad84f8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1846 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.GetThisWeekMonday

진입점: FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-249d51e6 | FindButton [try] 외 1 | DMF0051_1_BizPlanWaterfall.cs:1932 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5735fcb4 | this.Load | DMF0051_1_BizPlanWaterfall.cs:216 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5303e54b | this.Load | DMF0051_1_BizPlanWaterfall.cs:217 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c493d0fc | this.Load | DMF0051_1_BizPlanWaterfall.cs:223 | try | VALUE_SET | drpPeriod.InitValue | NextYear + "0101:" + NextYear + "1231" | 컨트롤 값 설정 |  |  |  |
| AC-335e1b23 | this.Load | DMF0051_1_BizPlanWaterfall.cs:228 | try | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-e9e5d0e8 | this.Load | DMF0051_1_BizPlanWaterfall.cs:228 | try | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-88893873 | this.Load | DMF0051_1_BizPlanWaterfall.cs:229 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8bd8cfa4 | this.Load | DMF0051_1_BizPlanWaterfall.cs:233 | try | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-fb84c6a4 | this.Load | DMF0051_1_BizPlanWaterfall.cs:233 | try | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e385d786 | this.Load | DMF0051_1_BizPlanWaterfall.cs:234 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-08d3a88c | this.Load | DMF0051_1_BizPlanWaterfall.cs:238 | try ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-f05c3caa | this.Load | DMF0051_1_BizPlanWaterfall.cs:238 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0dede065 | this.Load | DMF0051_1_BizPlanWaterfall.cs:239 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c9d1feaf | this.Load | DMF0051_1_BizPlanWaterfall.cs:241 | try ▸ if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString()… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-52a43744 | this.Load | DMF0051_1_BizPlanWaterfall.cs:241 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, clbDivision.SelectedValue.ToString(), clbTeam.C… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2df8e45 | this.Load | DMF0051_1_BizPlanWaterfall.cs:243 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0d471f20 | this.Load | DMF0051_1_BizPlanWaterfall.cs:244 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6cbab62e | this.Load | DMF0051_1_BizPlanWaterfall.cs:245 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ee3ce547 | this.Load | DMF0051_1_BizPlanWaterfall.cs:247 | try ▸ if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-be5a6e63 | this.Load | DMF0051_1_BizPlanWaterfall.cs:248 | try ▸ if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-995c21bf | this.Load | DMF0051_1_BizPlanWaterfall.cs:249 | try ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0051_1_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0051_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-db6902dc | this.Load | DMF0051_1_BizPlanWaterfall.cs:249 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0051_1_BP_Measure, false, "40", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0051_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4adc845 | this.Load | DMF0051_1_BizPlanWaterfall.cs:253 | try ▸ else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-7e28c8af | this.Load | DMF0051_1_BizPlanWaterfall.cs:253 | try ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1e567412 | this.Load | DMF0051_1_BizPlanWaterfall.cs:255 | try ▸ else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c071ee3b | this.Load | DMF0051_1_BizPlanWaterfall.cs:256 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9b203815 | this.Load | DMF0051_1_BizPlanWaterfall.cs:258 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f2ef8bba | this.Load | DMF0051_1_BizPlanWaterfall.cs:259 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2d9a2d73 | this.Load | DMF0051_1_BizPlanWaterfall.cs:260 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-58231ea1 | this.Load | DMF0051_1_BizPlanWaterfall.cs:261 | try ▸ else of (sDivision == "40") | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-df3a2864 | this.Load | DMF0051_1_BizPlanWaterfall.cs:262 | try ▸ else of (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.DMF0051_1_BP_Measure, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0051_1_BP_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e5956b82 | this.Load | DMF0051_1_BizPlanWaterfall.cs:262 | try ▸ else of (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DMF0051_1_BP_Measure, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0051_1_BP_Measure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b2dca1c0 | this.Load | DMF0051_1_BizPlanWaterfall.cs:264 | try | VALUE_SET | chkMem.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-cbfe94f2 | this.Load | DMF0051_1_BizPlanWaterfall.cs:265 | try | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-cebbc53e | this.Load | DMF0051_1_BizPlanWaterfall.cs:267 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20414212 | this.Load | DMF0051_1_BizPlanWaterfall.cs:269 | try | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-78de0f7b | this.Load | DMF0051_1_BizPlanWaterfall.cs:269 | try | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4e384ac2 | this.Load | DMF0051_1_BizPlanWaterfall.cs:270 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-59e088e6 | this.Load | DMF0051_1_BizPlanWaterfall.cs:272 | try | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-91f5beeb | this.Load | DMF0051_1_BizPlanWaterfall.cs:272 | try | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, clbDivision.Contro… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c2e7b93 | this.Load | DMF0051_1_BizPlanWaterfall.cs:273 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b82dd17d | this.Load | DMF0051_1_BizPlanWaterfall.cs:275 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-36461fdd | this.Load | DMF0051_1_BizPlanWaterfall.cs:276 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2e7a4b5b | this.Load | DMF0051_1_BizPlanWaterfall.cs:284 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-33fc21c2 | this.Load | DMF0051_1_BizPlanWaterfall.cs:285 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d7986b33 | this.Load | DMF0051_1_BizPlanWaterfall.cs:288 | try | FLAG | dtAmoutKrw | Data.Common(Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 화면 필드/플래그 변경 |  |  |  |
| AC-d726db89 | this.Load | DMF0051_1_BizPlanWaterfall.cs:288 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-231fcc4a | this.Load | DMF0051_1_BizPlanWaterfall.cs:289 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutKrw, cboKRW, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-149fe84c | this.Load | DMF0051_1_BizPlanWaterfall.cs:290 | try | FLAG | dtAmoutUsd | Data.Common(Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f0f8c9e | this.Load | DMF0051_1_BizPlanWaterfall.cs:290 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7caa21b6 | this.Load | DMF0051_1_BizPlanWaterfall.cs:291 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutUsd, cboUSD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7d1dc698 | this.Load | DMF0051_1_BizPlanWaterfall.cs:292 | try | FLAG | dtAmoutLoc | Data.Common(Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 화면 필드/플래그 변경 |  |  |  |
| AC-4dddbeed | this.Load | DMF0051_1_BizPlanWaterfall.cs:292 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-670ddd14 | this.Load | DMF0051_1_BizPlanWaterfall.cs:293 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutLoc, cboLOC, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-890b1e7b | this.Load | DMF0051_1_BizPlanWaterfall.cs:295 | try | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9d1068d | this.Load | DMF0051_1_BizPlanWaterfall.cs:296 | try | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-53021b99 | this.Load | DMF0051_1_BizPlanWaterfall.cs:299 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6d941ef | this.Load | DMF0051_1_BizPlanWaterfall.cs:300 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6af23bab | this.Load | DMF0051_1_BizPlanWaterfall.cs:305 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-88435522 | this.Load | DMF0051_1_BizPlanWaterfall.cs:309 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3e4908ac | this.Load | DMF0051_1_BizPlanWaterfall.cs:310 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_BizPlanWaterfall.InitSaveDataTable

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77eac677 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2400 |  | FLAG | dtSave | new DataTable("BP_WATERFALL_SAVE") | 화면 필드/플래그 변경 |  |  |  |
| AC-0dcebc40 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2401 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69a4d981 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2402 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DIVISION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa7a4eec | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2403 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.VERSION_NO, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9baf9bb | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2404 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PROJECT_CODE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b145a40e | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2405 |  | DATA_OP | dtSave.Columns.Add | ("SCM_SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-db97f537 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2408 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.END_CUSTOMER, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-459a7b71 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2409 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.END_CUSTOMER40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-10334037 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2410 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ITEM_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-304a3578 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2412 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DOM_EXP, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef739acd | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2413 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.INCOTERMS, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6271f7cb | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2414 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FCST_TYPE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6db164fc | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2415 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MEASURE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62bde411 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2416 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PLANT_SITE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3435fa7b | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2417 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMM, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53eb7222 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2418 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.QTY, typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c21bca7 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2419 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CURRENCY, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc5b7d05 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2420 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DEPT_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c931728 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2421 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BIZ_TYPE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79057e5f | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2422 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CELL_PROD_SITE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0051_1_BizPlanWaterfall.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca695b24 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:363 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dtTitle, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |
| AC-5fcca58e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:370 | foreach (DataRow dr in dtTitle.Rows) ▸ if (dr["COLUMN_NAME"].ToString().Substring(0, 1) == "M") | DATA_OP | dr["COLUMN_WIDTH"] | "300" | 행/컬럼 값 대입 |  |  |  |

## DMF0051_1_BizPlanWaterfall.InitSpreadFooterSum

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a97332f5 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:386 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-971fe8ed | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:387 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-047ff53d | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:394 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fb758c0 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:395 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81e9705d | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:396 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-c7f3b429 | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:397 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.MinColumnChk

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName)) ▸ if (this.fps != null)] / EditButton [if (this.fps != null)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deb9b0a6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0051_1_BizPlanWaterfall.cs:2350 | if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 //\|\| siMain.Ge… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a4cd23b1 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0051_1_BizPlanWaterfall.cs:2370 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "82") ▸… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c94b0f19 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0051_1_BizPlanWaterfall.cs:2391 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "8… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b10790eb | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DMF0051_1_BizPlanWaterfall.cs:2395 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.ParameterString

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d0a13fd | (진입점 미연결) | DMF0051_1_BizPlanWaterfall.cs:2919 |  | RETURN | return strParameter; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.PopupChk

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab326567 | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1436 | if (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.DIVISION_ID) == -1 \|\| siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-81ad2678 | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1449 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ if (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain.GetC… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5b23e70f | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1462 | else of (clbDivision.SelectedValue.ToString().Substring(0, 2) == "81") ▸ else of (clbDivision.SelectedValue.ToString() == "82") ▸ if (siMain… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3320d010 | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1465 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_BizPlanWaterfall.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a85e60ce | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b273ea33 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (MinColumnChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3cf8f84b | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2499 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageBox.Show | ("Version이 CURRENT 이면 저장을 할 수 없습니다.") | 메시지 표시 |  |  |  |
| AC-576bc13f | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2500 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-740b6a67 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dc02e1c0 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2668 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew["Action"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-5a679b78 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2669 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.DIVISION_ID] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b7fbe5b6 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2670 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.VERSION_NO] | pVersion_No | 행/컬럼 값 대입 |  |  |  |
| AC-4ebac410 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2671 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.PROJECT_CODE] | pProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-40ab5b10 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2672 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew["SCM_SITE_ID"] | pScm_Site_Id | 행/컬럼 값 대입 |  |  |  |
| AC-ee421f00 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.ITEM_ID] | pItem_Id | 행/컬럼 값 대입 |  |  |  |
| AC-27fd3616 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2674 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.DOM_EXP] | pDom_Exp | 행/컬럼 값 대입 |  |  |  |
| AC-e5fdc4fb | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.FCST_TYPE] | pFcst_Type | 행/컬럼 값 대입 |  |  |  |
| AC-7eaee948 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2676 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.INCOTERMS] | pIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-1e534276 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.MEASURE] | pMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-9199c74a | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2678 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.PLANT_SITE_ID] | pPlant_Site_Id | 행/컬럼 값 대입 |  |  |  |
| AC-c99e4b4b | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2679 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.YYYYMM] | pYyyyMM | 행/컬럼 값 대입 |  |  |  |
| AC-4bd4335e | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2680 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.QTY] | pQTY | 행/컬럼 값 대입 |  |  |  |
| AC-b9171807 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2681 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.CURRENCY] | pCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-aa1a8f65 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.DEPT_ID] | p_DEPT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7f631143 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2684 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.BIZ_TYPE] | p_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-b7562f49 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2685 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.CELL_PROD_SITE] | pCell_Prod_Site | 행/컬럼 값 대입 |  |  |  |
| AC-748e329a | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2692 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.END_CUSTOMER] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-1239b54f | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | drNew[DefColumns.END_CUSTOMER] | pEnd_Customer | 행/컬럼 값 대입 |  |  |  |
| AC-054cb261 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2702 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfb3c619 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2703 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-59a9d769 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2713 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79f4cf65 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2714 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (fnValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79ac6c79 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2841 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_1_SAVE_DM_PLN_BIZ_PLAN_WATERFALL") ⇒ DM.DMF0051_1_SAVE_DM_PLN_BIZ_PLAN_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-db139141 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2843 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | request.CommandTimeout | 1000 * 1000 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d708110e | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2845 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_active_flag"] | pAction | 행/컬럼 값 대입 |  |  |  |
| AC-8cb2c14d | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2846 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DIVISION_ID"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b1c53884 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2847 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_VERSION_NO"] | pVersion_No | 행/컬럼 값 대입 |  |  |  |
| AC-f34eb1d2 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2848 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PROJECT_CODE"] | pProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-26a490fd | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2849 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | pScm_Site_Id | 행/컬럼 값 대입 |  |  |  |
| AC-6012e428 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_END_CUSTOMER"] | pEnd_Customer | 행/컬럼 값 대입 |  |  |  |
| AC-32f65dba | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2851 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_PLANT_SITE_ID"] | pPlant_Site_Id | 행/컬럼 값 대입 |  |  |  |
| AC-db5e94af | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2852 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_ITEM_ID"] | pItem_Id | 행/컬럼 값 대입 |  |  |  |
| AC-a9ec142e | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2853 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DOM_EXP"] | pDom_Exp | 행/컬럼 값 대입 |  |  |  |
| AC-2ba20450 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2854 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_FCST_TYPE"] | pFcst_Type | 행/컬럼 값 대입 |  |  |  |
| AC-adf76b17 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2855 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_INCOTERMS"] | pIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-7683074b | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2856 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_MEASURE"] | pMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-7cc12f6b | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2857 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_YYYYMM"] | pYyyyMM | 행/컬럼 값 대입 |  |  |  |
| AC-4f8a17ab | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2858 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_QTY"] | pQTY | 행/컬럼 값 대입 |  |  |  |
| AC-6147101c | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_DEPT_ID"] | p_DEPT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8204c99b | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_BIZ_TYPE"] | p_BIZ_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-42edb8c7 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CELL_PROD_SITE"] | pCell_Prod_Site | 행/컬럼 값 대입 |  |  |  |
| AC-fe2980f7 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CURRENCY"] | pCurrency | 행/컬럼 값 대입 |  |  |  |
| AC-95666a66 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_CREATED_BY"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-6e1a36bb | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2868 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | request.Parameters["p_LAST_UPDATED_BY"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-4f856558 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2870 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a5f00f3 | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2875 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | MESSAGE | MessageBox.Show | (sRet, "Error!") | 메시지 표시 |  |  |  |
| AC-e358c21a | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2876 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sRet != "success") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb0cae3f | SaveButton | DMF0051_1_BizPlanWaterfall.cs:2880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sRet != "success") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0051_1_BizPlanWaterfall.SetAmountCalculating

진입점: this.cboLOC.SelectedIndexChanged / this.cboKRW.SelectedIndexChanged / this.cboUSD.SelectedIndexChanged / this.cboQTY.SelectedIndexChanged / cboKRW.SelectedIndexChanged / cboUSD.SelectedIndexChanged / cboLOC.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb7468dc | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:1985 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6e8dce7 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:1989 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6c3fdb68 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:1995 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-d3b23fd3 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:1996 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4781a8a | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:1999 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b88e2733 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2000 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5b12347 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2201 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbKrwDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-693c7858 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2203 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbUsdDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-6686e27a | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2205 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbLocDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-c72565b4 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2210 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-82d6d23e | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2216 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3ea7400a | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2222 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-12d582d7 | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2226 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-a102a88d | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2230 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-035fcf7e | this.cboLOC.SelectedIndexChanged 외 8 | DMF0051_1_BizPlanWaterfall.cs:2233 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_1_BizPlanWaterfall.SetCellColor

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ if ((sBucketType == BucketType.Quarterly) && sColName.IndexOf("Q_") == 0) ▸ if (!bWeekAll) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (dDaycnt == iCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dd9d57d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0051_1_BizPlanWaterfall.cs:3077 |  | UI_PROP | range1.ForeColor | System.Drawing.Color.Red | 속성 ForeColor 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.SetComboCol

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-627dfad2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4139 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-f440334c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4140 | for (i <= dt.Rows.Count - 1) | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-264ac6fe | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4144 |  | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-3abc0bf9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4145 |  | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-925cdd3b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4146 |  | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-b90132ca | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4147 |  | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-e0afbcf4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4151 |  | UI_PROP | column.CellType | cb | 속성 CellType 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.SetComboColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4e87e5e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:4112 |  | DATA_OP | dtTitle.Select | ($"COLUMN_NAME = '{columnName}'") | 데이터 객체 조작/조회 |  |  |  |

## DMF0051_1_BizPlanWaterfall.SetSpreadColumn

진입점: this.chkMem.CheckedChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.clbDivision.SelectedIndexChanged [try ▸ if (dtTitle != null && dtTitle.Rows.Co…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a3a4c76 | this.chkMem.CheckedChanged [if (siMain != null)] 외 9 | DMF0051_1_BizPlanWaterfall.cs:1787 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4a426dfa | this.chkMem.CheckedChanged [if (siMain != null)] 외 9 | DMF0051_1_BizPlanWaterfall.cs:1790 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("Y… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-1425f3f9 | this.chkMem.CheckedChanged [if (siMain != null)] 외 9 | DMF0051_1_BizPlanWaterfall.cs:1795 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-989e76b3 | this.chkMem.CheckedChanged [if (siMain != null)] 외 9 | DMF0051_1_BizPlanWaterfall.cs:1797 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9553affe | this.chkMem.CheckedChanged [if (siMain != null)] 외 9 | DMF0051_1_BizPlanWaterfall.cs:1800 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f08ecb5d | this.chkMem.CheckedChanged [if (siMain != null)] 외 9 | DMF0051_1_BizPlanWaterfall.cs:1805 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8ad9030d | this.chkMem.CheckedChanged [if (siMain != null)] 외 9 | DMF0051_1_BizPlanWaterfall.cs:1807 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.clbDivision.SelectedIndexChanged [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (dtTitle != nu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7014196d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1722 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 40, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-643bf155 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1730 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.COLUMN_NAME].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f0b4ab4b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1742 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7bb20da0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1743 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61326185 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1748 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a079972 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1749 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90ae4575 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1756 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-142d65f7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1757 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-922dd661 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1768 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a11e3ce1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1769 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f555a492 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1770 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c04ee5d0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1771 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92e22c9c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1773 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1662d130 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0051_1_BizPlanWaterfall.cs:1775 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0051_1_BizPlanWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-434fcf64 | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1473 | if (PopupChk() == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb7a67ac | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1474 | if (PopupChk() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-248ed020 | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1514 | if (siMain.GetColumnTag(e.Column).ToString() == "MEASURE") ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString(… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4c4bb37b | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1515 | if (siMain.GetColumnTag(e.Column).ToString() == "MEASURE") ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToString(… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-26d167ad | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1551 | if (siMain.GetColumnTag(e.Column).ToString() == "MEASURE") ▸ else of (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToSt… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ff90686d | this.spdMain.CellDoubleClick | DMF0051_1_BizPlanWaterfall.cs:1552 | if (siMain.GetColumnTag(e.Column).ToString() == "MEASURE") ▸ else of (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)).ToSt… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0051_1_BizPlanWaterfall.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a0b4e63 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3082 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c9972e8 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3085 | if (e.Column < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-749dd23b | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3086 | if (e.Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c65f15b | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3090 | if (siMain.GetValue(e.Row, e.Column).ToString() == "") | GRID_SET | siMain.SetValue | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |
| AC-1e671bdb | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3117 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90b9c08f | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3128 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8d3e3d3 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3132 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | GRID_SET | siMain.SetValue | (e.Row, e.Column, strValue[0] + ".000") | 그리드 값 설정 |  |  |  |
| AC-2a867e2a | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3133 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) < e.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00289") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f6832fe | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3208 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, e.Column)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-180e37fe | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3249 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | CALL_EXT | Convert.ToInt64 | (iQuarterlySum) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cec1c611 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3274 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-9aca29fa | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3280 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-081df055 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3294 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-7224b4ad | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3300 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-5b6f016c | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3321 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-15aeb65a | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3349 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(e.Row, iCol)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a1c7b80 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3357 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f7ccd39c | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3375 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | CALL_EXT | Convert.ToInt64 | (Convert.ToDecimal(siMain.GetValue(e.Row, e.Column))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f9c8081 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3384 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | CALL_EXT | Convert.ToInt64 | (DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc99303d | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3384 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | CALL_EXT | Convert.ToInt64 | (DateTime.Today.DayOfWeek) | ⚠ 의미 확인 필요 |  |  |  |
| AC-baeae4c3 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3442 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-6097045b | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3448 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b4b5214e | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3464 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-58a3e85b | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3470 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-29f3e028 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3492 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-7804ed54 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3527 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-463b60fc | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3532 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (strCheckMeasure == "Business_Plan_Conf") ▸ else o… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-1e65982c | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3599 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ i… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dQuarterlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ed4b1a0c | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3626 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ i… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-cd144fae | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3706 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-b6c2e1fc | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3712 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d0caad81 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3726 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-5106b78b | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3732 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-1c3c64ca | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3753 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-426d8433 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3789 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, dYearlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d266a94f | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3874 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-1a7b2983 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3880 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-475596bc | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3896 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-81171e16 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3902 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-189cd479 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3924 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-5463832c | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3959 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f66f44ba | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3964 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iCol, dDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f367ea09 | dsdm.Changed | DMF0051_1_BizPlanWaterfall.cs:3993 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (strCheckMeasure == "Business_Plan_Conf") ▸ e… | GRID_SET | siMain.SetText | (e.Row, iQuarterCol, dQuarterlySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf86bba6 | this.spdMain.ComboSelChange | DMF0051_1_BizPlanWaterfall.cs:1382 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-42954fde | this.spdMain.ComboSelChange | DMF0051_1_BizPlanWaterfall.cs:1383 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siteIndex, dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8f0dfbeb | this.spdMain.ComboSelChange | DMF0051_1_BizPlanWaterfall.cs:1385 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-89f30f10 | this.spdMain.ComboSelChange | DMF0051_1_BizPlanWaterfall.cs:1386 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siteIndex, dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0051_1_BizPlanWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08266760 | this.spdMain.KeyUp | DMF0051_1_BizPlanWaterfall.cs:1615 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0820eea | this.spdMain.KeyUp | DMF0051_1_BizPlanWaterfall.cs:1618 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-edacbef7 | this.spdMain.KeyUp | DMF0051_1_BizPlanWaterfall.cs:1622 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0e37739 | this.spdMain.KeyUp | DMF0051_1_BizPlanWaterfall.cs:1623 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_1_BizPlanWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9f1e7cf | this.spdMain.TopChange | DMF0051_1_BizPlanWaterfall.cs:1609 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0051_1_Business_Plan_Conf.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c30671dd | this.Load | DMF0051_1_Business_Plan_Conf.cs:191 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4b2511ed | this.Load | DMF0051_1_Business_Plan_Conf.cs:192 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b2df071 | this.Load | DMF0051_1_Business_Plan_Conf.cs:193 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0051_1_Business_Plan_Conf.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e59bf90 | Dispose | DMF0051_1_Business_Plan_Conf.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0051_1_Business_Plan_Conf.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f9dcbeb | EditButton | DMF0051_1_Business_Plan_Conf.cs:408 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_Business_Plan_Conf.FindData

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8510e9ce | .ctor | DMF0051_1_Business_Plan_Conf.cs:274 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b3707057 | .ctor | DMF0051_1_Business_Plan_Conf.cs:281 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f150e6d2 | .ctor | DMF0051_1_Business_Plan_Conf.cs:285 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_1_GET_BIZPLAN_CONF") ⇒ DM.DMF0051_1_GET_BIZPLAN_CONF | 엔드포인트 요청 생성 |  |  |  |
| AC-3eee5250 | .ctor | DMF0051_1_Business_Plan_Conf.cs:287 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3b7337a1 | .ctor | DMF0051_1_Business_Plan_Conf.cs:289 | lambda | DATA_OP | request.Parameters["p_version_no"] | sVERSION_NO | 행/컬럼 값 대입 |  |  |  |
| AC-22e68222 | .ctor | DMF0051_1_Business_Plan_Conf.cs:290 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c19ae1ae | .ctor | DMF0051_1_Business_Plan_Conf.cs:291 | lambda | DATA_OP | request.Parameters["p_project_code"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-3afecb4e | .ctor | DMF0051_1_Business_Plan_Conf.cs:292 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ea966db7 | .ctor | DMF0051_1_Business_Plan_Conf.cs:293 | lambda | DATA_OP | request.Parameters["p_item_id"] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b2a207d7 | .ctor | DMF0051_1_Business_Plan_Conf.cs:294 | lambda | DATA_OP | request.Parameters["p_incoterms"] | sINCOTERMS | 행/컬럼 값 대입 |  |  |  |
| AC-0d0b100b | .ctor | DMF0051_1_Business_Plan_Conf.cs:296 | lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sFROM_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-2a9063ec | .ctor | DMF0051_1_Business_Plan_Conf.cs:297 | lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sTO_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-29b0c01a | .ctor | DMF0051_1_Business_Plan_Conf.cs:300 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42dae87c | .ctor | DMF0051_1_Business_Plan_Conf.cs:302 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4bc98ea9 | .ctor | DMF0051_1_Business_Plan_Conf.cs:313 |  | FLAG | _PLAN_START_DATE | sPLAN_START_DATE.Substring(0, 6).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b5affd44 | .ctor | DMF0051_1_Business_Plan_Conf.cs:324 | for (c <= ds.Tables[0].Columns.Count - 1) | DATA_OP | dt.Columns.Add | (ds.Tables[0].Columns[c].Caption.ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f556b61 | .ctor | DMF0051_1_Business_Plan_Conf.cs:331 | foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | dt.ImportRow | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-24596e52 | .ctor | DMF0051_1_Business_Plan_Conf.cs:365 | for (c <= dt.Columns.Count - 1) ▸ for (r <= dt.Rows.Count - 1) ▸ if (dt.Columns[c].Caption.ToString().Substring(0, 2) == "20") | DATA_OP | dt.Rows[r].BeginEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-94f69d1f | .ctor | DMF0051_1_Business_Plan_Conf.cs:366 | for (c <= dt.Columns.Count - 1) ▸ for (r <= dt.Rows.Count - 1) ▸ if (dt.Columns[c].Caption.ToString().Substring(0, 2) == "20") | GRID_SET | dt.Rows[r][Col] | Value.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-adc757a4 | .ctor | DMF0051_1_Business_Plan_Conf.cs:367 | for (c <= dt.Columns.Count - 1) ▸ for (r <= dt.Rows.Count - 1) ▸ if (dt.Columns[c].Caption.ToString().Substring(0, 2) == "20") | DATA_OP | dt.Rows[r].EndEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e760f5bd | .ctor | DMF0051_1_Business_Plan_Conf.cs:374 |  | GRID_BIND | siMain.Query | (dt) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-61478aa9 | .ctor | DMF0051_1_Business_Plan_Conf.cs:377 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0051_1_Business_Plan_Conf.FindDataMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9607a94e | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:456 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_Business_Plan_Conf.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-794dfdc7 | this.Load | DMF0051_1_Business_Plan_Conf.cs:114 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-612cbe31 | this.Load | DMF0051_1_Business_Plan_Conf.cs:115 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0051_1_Business_Plan_Conf.GetSLOC

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c3cd469 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:593 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-8019604b | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:594 |  | DATA_OP | request.Parameters["CODE"] | "PR_SLOC" | 행/컬럼 값 대입 |  |  |  |
| AC-ac8eb297 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:595 |  | DATA_OP | request.Parameters["PARAM1"] | SPlant | 행/컬럼 값 대입 |  |  |  |
| AC-f440fa89 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:596 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c607c124 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:597 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c1eab0ac | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:598 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e7f060b2 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:599 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-90ffd4ae | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:600 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-824f9104 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:602 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_Business_Plan_Conf.GetSPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78654dd5 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:575 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-b9eaa35b | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:576 |  | DATA_OP | request.Parameters["CODE"] | "PR_SPLANT" | 행/컬럼 값 대입 |  |  |  |
| AC-8bb563c5 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:577 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b78398d | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:578 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-905c03d8 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:579 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65a97b7b | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:580 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5bda3707 | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:581 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e66b4e6f | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:582 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bf4353bd | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:584 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_Business_Plan_Conf.GetSplit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1e4c3ea | (진입점 미연결) | DMF0051_1_Business_Plan_Conf.cs:542 |  | RETURN | return sar.Split('^'); |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_Business_Plan_Conf.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18060861 | this.Load | DMF0051_1_Business_Plan_Conf.cs:154 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0051_1_Business_Plan_Conf.InitSpread

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e18d2833 | .ctor | DMF0051_1_Business_Plan_Conf.cs:206 |  | DATA_OP | dtTitle.Columns.Add | ("PROGRAM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d886d75d | .ctor | DMF0051_1_Business_Plan_Conf.cs:207 |  | DATA_OP | dtTitle.Columns.Add | ("SHEET_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9223daec | .ctor | DMF0051_1_Business_Plan_Conf.cs:208 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-75b605c7 | .ctor | DMF0051_1_Business_Plan_Conf.cs:209 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14019e1c | .ctor | DMF0051_1_Business_Plan_Conf.cs:210 |  | DATA_OP | dtTitle.Columns.Add | ("SORT_ORDER_NO", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-727e6232 | .ctor | DMF0051_1_Business_Plan_Conf.cs:211 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_SORT_METHOD_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7f23ca0 | .ctor | DMF0051_1_Business_Plan_Conf.cs:212 |  | DATA_OP | dtTitle.Columns.Add | ("SMALL_CLASS_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd680ba1 | .ctor | DMF0051_1_Business_Plan_Conf.cs:213 |  | DATA_OP | dtTitle.Columns.Add | ("LARGE_CLASS_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-191c6cb9 | .ctor | DMF0051_1_Business_Plan_Conf.cs:214 |  | DATA_OP | dtTitle.Columns.Add | ("FIXED_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-85d141e6 | .ctor | DMF0051_1_Business_Plan_Conf.cs:215 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_WIDTH", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee95334a | .ctor | DMF0051_1_Business_Plan_Conf.cs:216 |  | DATA_OP | dtTitle.Columns.Add | ("CELL_CONTROL_OBJECT_TYPE_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8367db9 | .ctor | DMF0051_1_Business_Plan_Conf.cs:217 |  | DATA_OP | dtTitle.Columns.Add | ("CELL_COMBO_DATA_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea62da85 | .ctor | DMF0051_1_Business_Plan_Conf.cs:218 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_SCALE_NUMBER", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-77b2afc9 | .ctor | DMF0051_1_Business_Plan_Conf.cs:219 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_MAX_LENGTH", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1130e8b9 | .ctor | DMF0051_1_Business_Plan_Conf.cs:220 |  | DATA_OP | dtTitle.Columns.Add | ("HORIZONTAL_ALIGN_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f74557b | .ctor | DMF0051_1_Business_Plan_Conf.cs:221 |  | DATA_OP | dtTitle.Columns.Add | ("UPPERCASE_APPLY_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-875e2130 | .ctor | DMF0051_1_Business_Plan_Conf.cs:222 |  | DATA_OP | dtTitle.Columns.Add | ("VISIBLE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7890a787 | .ctor | DMF0051_1_Business_Plan_Conf.cs:223 |  | DATA_OP | dtTitle.Columns.Add | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dca5c1d | .ctor | DMF0051_1_Business_Plan_Conf.cs:224 |  | DATA_OP | dtTitle.Columns.Add | ("DEFAULT_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62f26825 | .ctor | DMF0051_1_Business_Plan_Conf.cs:225 |  | DATA_OP | dtTitle.Columns.Add | ("USER_SELECTABLE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-95952696 | .ctor | DMF0051_1_Business_Plan_Conf.cs:226 |  | DATA_OP | dtTitle.Columns.Add | ("VALID_YN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16d80a29 | .ctor | DMF0051_1_Business_Plan_Conf.cs:228 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "SCM_SITE_ID", "Sales Site", "10", "", "Sales Si… | 데이터 객체 조작/조회 |  |  |  |
| AC-bfda567f | .ctor | DMF0051_1_Business_Plan_Conf.cs:229 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "PROJECT_CODE", "Project Code", "20", "", "Proje… | 데이터 객체 조작/조회 |  |  |  |
| AC-2f96343b | .ctor | DMF0051_1_Business_Plan_Conf.cs:230 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "PROJECT_NAME", "Project Name", "20", "", "Proje… | 데이터 객체 조작/조회 |  |  |  |
| AC-c52ca983 | .ctor | DMF0051_1_Business_Plan_Conf.cs:231 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "ITEM_ID", "Model Code", "30", "", "Model Code",… | 데이터 객체 조작/조회 |  |  |  |
| AC-492ce834 | .ctor | DMF0051_1_Business_Plan_Conf.cs:232 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "ITEM_NICKNAME", "Model NickName", "40", "", "Mo… | 데이터 객체 조작/조회 |  |  |  |
| AC-b807f402 | .ctor | DMF0051_1_Business_Plan_Conf.cs:233 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "EE_CORP_ID", "전극생산지", "50", "", "전극생산지", "전극생산지… | 데이터 객체 조작/조회 |  |  |  |
| AC-510acbe3 | .ctor | DMF0051_1_Business_Plan_Conf.cs:234 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "CELL_CORP_ID", "Cell생산지", "60", "", "Cell생산지", … | 데이터 객체 조작/조회 |  |  |  |
| AC-06f0c655 | .ctor | DMF0051_1_Business_Plan_Conf.cs:235 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "PACK_CORP_ID", "PACK생산지", "70", "", "PACK생산지", … | 데이터 객체 조작/조회 |  |  |  |
| AC-260f1215 | .ctor | DMF0051_1_Business_Plan_Conf.cs:236 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "OSP_YN", "외주여부", "80", "", "외주여부", "외주여부", "", … | 데이터 객체 조작/조회 |  |  |  |
| AC-2d946022 | .ctor | DMF0051_1_Business_Plan_Conf.cs:237 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "MEASURE", "MEASURE", "90", "", "MEASURE", "MEAS… | 데이터 객체 조작/조회 |  |  |  |
| AC-489dfe45 | .ctor | DMF0051_1_Business_Plan_Conf.cs:239 |  | FLAG | _PLAN_START_DATE | _FROM_YYYYMM.Substring(0, 4).ToString() + "-" + _FROM_YYYYMM.Substring(4, 2).ToString() + … | 화면 필드/플래그 변경 |  |  |  |
| AC-6cf64c92 | .ctor | DMF0051_1_Business_Plan_Conf.cs:256 | for (i <= Period) | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", month, month.Substring(0, 4) + "'" + month.Subst… | 데이터 객체 조작/조회 |  |  |  |
| AC-816b88f0 | .ctor | DMF0051_1_Business_Plan_Conf.cs:259 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0051_1_Business_Plan_Conf.RTF_Load

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca8313be | .ctor | DMF0051_1_Business_Plan_Conf.cs:130 |  | FLAG | _VERSION_NO | VERSION_NO | 화면 필드/플래그 변경 |  |  |  |
| AC-456b4df3 | .ctor | DMF0051_1_Business_Plan_Conf.cs:131 |  | FLAG | _DIVISION_ID | DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-e2aec97d | .ctor | DMF0051_1_Business_Plan_Conf.cs:132 |  | FLAG | _PROJECT_CODE | PROJECT_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-1924ce0d | .ctor | DMF0051_1_Business_Plan_Conf.cs:133 |  | FLAG | _SCM_SITE_ID | SCM_SITE_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-e7a7adf1 | .ctor | DMF0051_1_Business_Plan_Conf.cs:134 |  | FLAG | _ITEM_ID | ITEM_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-a0b8f665 | .ctor | DMF0051_1_Business_Plan_Conf.cs:135 |  | FLAG | _INCOTERMS | INCOTERMS | 화면 필드/플래그 변경 |  |  |  |
| AC-a61b928c | .ctor | DMF0051_1_Business_Plan_Conf.cs:136 |  | FLAG | _FROM_YYYYMM | FROM_YYYYMM | 화면 필드/플래그 변경 |  |  |  |
| AC-637b1f74 | .ctor | DMF0051_1_Business_Plan_Conf.cs:137 |  | FLAG | _TO_YYYYMM | TO_YYYYMM | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_RELEASE_SCP.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd8325bf | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:260 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f06ca3c1 | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:263 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0051_1_RELEASE_SCP.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e34ace6 | this.Load | DMF0051_1_RELEASE_SCP.cs:129 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-1ff03090 | this.Load | DMF0051_1_RELEASE_SCP.cs:132 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0051_1_RELEASE_SCP.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29add4dd | Dispose | DMF0051_1_RELEASE_SCP.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0051_1_RELEASE_SCP.FindData

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-446f5ca6 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:198 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17a63713 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:202 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP") ⇒ DM.DMF0043_GET_CONT_VIEW_VERSIONPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-9547f000 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:203 | lambda | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-2ad6d7a6 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:204 | lambda | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b1578aa1 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:206 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c88f2a7c | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:208 | lambda | DATA_OP | request.Parameters["p_description"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c0e350c3 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:211 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57a58897 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:213 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ee8e3332 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:217 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dda338e0 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:218 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-daa92cf3 | this.Load 외 1 | DMF0051_1_RELEASE_SCP.cs:225 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_RELEASE_SCP.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0673fd6d | this.Load | DMF0051_1_RELEASE_SCP.cs:92 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-17b29fa1 | this.Load | DMF0051_1_RELEASE_SCP.cs:93 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0051_1_RELEASE_SCP.GetLookupData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dbf035d | this.Load | DMF0051_1_RELEASE_SCP.cs:344 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-fa7c5d01 | this.Load | DMF0051_1_RELEASE_SCP.cs:345 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-246ee0ed | this.Load | DMF0051_1_RELEASE_SCP.cs:346 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-66a8c3f9 | this.Load | DMF0051_1_RELEASE_SCP.cs:348 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_RELEASE_SCP.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-972601fb | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:286 |  | ENDPOINT | new FoxDataRequest | ("DM_H.DM0000_GET_COMMON_SPREAD_TITLE") ⇒ DM_H.DM0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-62719674 | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:287 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-18a6a6c4 | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:288 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-03716d91 | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:289 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ee738237 | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:290 |  | DATA_OP | request.Parameters["p_program_id"] | "SCM0002" | 행/컬럼 값 대입 |  |  |  |
| AC-9635d8cf | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:291 |  | DATA_OP | request.Parameters["p_sheet_name"] | "VersionPopup" | 행/컬럼 값 대입 |  |  |  |
| AC-a1a07668 | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:293 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-93548fd8 | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:293 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f95d247b | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:296 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_RELEASE_SCP.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf5e9b7 | this.Load | DMF0051_1_RELEASE_SCP.cs:113 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-f58764b1 | this.Load | DMF0051_1_RELEASE_SCP.cs:113 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3362aa07 | this.Load | DMF0051_1_RELEASE_SCP.cs:114 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-06318aaa | this.Load | DMF0051_1_RELEASE_SCP.cs:116 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |

## DMF0051_1_RELEASE_SCP.spdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b72a8af | (진입점 미연결) | DMF0051_1_RELEASE_SCP.cs:277 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0051_1_RTF.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33509a25 | this.Load | DMF0051_1_RTF.cs:191 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-563c56ae | this.Load | DMF0051_1_RTF.cs:192 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48417948 | this.Load | DMF0051_1_RTF.cs:193 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0051_1_RTF.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16cdf977 | Dispose | DMF0051_1_RTF.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0051_1_RTF.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86698dbf | EditButton | DMF0051_1_RTF.cs:397 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_RTF.FindData

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ac53931 | .ctor | DMF0051_1_RTF.cs:273 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e47fedf7 | .ctor | DMF0051_1_RTF.cs:280 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c470d3bf | .ctor | DMF0051_1_RTF.cs:284 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_1_GET_BIZPLAN_RTF") ⇒ DM.DMF0051_1_GET_BIZPLAN_RTF | 엔드포인트 요청 생성 |  |  |  |
| AC-c5b4a836 | .ctor | DMF0051_1_RTF.cs:286 | lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-304f3bf8 | .ctor | DMF0051_1_RTF.cs:288 | lambda | DATA_OP | request.Parameters["p_version_no"] | sVERSION_NO | 행/컬럼 값 대입 |  |  |  |
| AC-b53970b5 | .ctor | DMF0051_1_RTF.cs:289 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1132f9e8 | .ctor | DMF0051_1_RTF.cs:290 | lambda | DATA_OP | request.Parameters["p_project_code"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-e8cfb471 | .ctor | DMF0051_1_RTF.cs:291 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b9bb2e25 | .ctor | DMF0051_1_RTF.cs:292 | lambda | DATA_OP | request.Parameters["p_item_id"] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e61b78f1 | .ctor | DMF0051_1_RTF.cs:293 | lambda | DATA_OP | request.Parameters["p_incoterms"] | sINCOTERMS | 행/컬럼 값 대입 |  |  |  |
| AC-fadf8cd0 | .ctor | DMF0051_1_RTF.cs:295 | lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sFROM_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-25321558 | .ctor | DMF0051_1_RTF.cs:296 | lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sTO_YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-ea1c2ce3 | .ctor | DMF0051_1_RTF.cs:298 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d97f5da6 | .ctor | DMF0051_1_RTF.cs:300 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-abb441af | .ctor | DMF0051_1_RTF.cs:307 |  | FLAG | _PLAN_START_DATE | sPLAN_START_DATE.Substring(0, 6).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ba866a22 | .ctor | DMF0051_1_RTF.cs:314 | for (c <= ds.Tables[0].Columns.Count - 1) | DATA_OP | dt.Columns.Add | (ds.Tables[0].Columns[c].Caption.ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9caa8572 | .ctor | DMF0051_1_RTF.cs:319 | foreach (DataRow row in ds.Tables[0].Rows) | DATA_OP | dt.ImportRow | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb95bbe7 | .ctor | DMF0051_1_RTF.cs:353 | for (c <= dt.Columns.Count - 1) ▸ for (r <= dt.Rows.Count - 1) ▸ if (dt.Columns[c].Caption.ToString().Substring(0, 2) == "20") | DATA_OP | dt.Rows[r].BeginEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f99a61ee | .ctor | DMF0051_1_RTF.cs:354 | for (c <= dt.Columns.Count - 1) ▸ for (r <= dt.Rows.Count - 1) ▸ if (dt.Columns[c].Caption.ToString().Substring(0, 2) == "20") | GRID_SET | dt.Rows[r][Col] | Value.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-26ee2afd | .ctor | DMF0051_1_RTF.cs:355 | for (c <= dt.Columns.Count - 1) ▸ for (r <= dt.Rows.Count - 1) ▸ if (dt.Columns[c].Caption.ToString().Substring(0, 2) == "20") | DATA_OP | dt.Rows[r].EndEdit | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cb749d3a | .ctor | DMF0051_1_RTF.cs:364 |  | GRID_BIND | siMain.Query | (dt) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b037d10a | .ctor | DMF0051_1_RTF.cs:365 |  | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-03f864b4 | .ctor | DMF0051_1_RTF.cs:367 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0051_1_RTF.FindDataMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9d84bf6 | (진입점 미연결) | DMF0051_1_RTF.cs:445 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_RTF.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f643a28f | this.Load | DMF0051_1_RTF.cs:114 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc1a22c1 | this.Load | DMF0051_1_RTF.cs:115 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0051_1_RTF.GetSLOC

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6831040b | (진입점 미연결) | DMF0051_1_RTF.cs:582 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-4819b2bb | (진입점 미연결) | DMF0051_1_RTF.cs:583 |  | DATA_OP | request.Parameters["CODE"] | "PR_SLOC" | 행/컬럼 값 대입 |  |  |  |
| AC-3b108934 | (진입점 미연결) | DMF0051_1_RTF.cs:584 |  | DATA_OP | request.Parameters["PARAM1"] | SPlant | 행/컬럼 값 대입 |  |  |  |
| AC-f0e0c559 | (진입점 미연결) | DMF0051_1_RTF.cs:585 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-59463b04 | (진입점 미연결) | DMF0051_1_RTF.cs:586 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-528e9994 | (진입점 미연결) | DMF0051_1_RTF.cs:587 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6b4df9cc | (진입점 미연결) | DMF0051_1_RTF.cs:588 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe9e65dc | (진입점 미연결) | DMF0051_1_RTF.cs:589 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aeb8af5b | (진입점 미연결) | DMF0051_1_RTF.cs:591 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_RTF.GetSPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e46ca7a | (진입점 미연결) | DMF0051_1_RTF.cs:564 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-26916d4a | (진입점 미연결) | DMF0051_1_RTF.cs:565 |  | DATA_OP | request.Parameters["CODE"] | "PR_SPLANT" | 행/컬럼 값 대입 |  |  |  |
| AC-ab83e588 | (진입점 미연결) | DMF0051_1_RTF.cs:566 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-93947802 | (진입점 미연결) | DMF0051_1_RTF.cs:567 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f06b09d | (진입점 미연결) | DMF0051_1_RTF.cs:568 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-60ff9558 | (진입점 미연결) | DMF0051_1_RTF.cs:569 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b8cc4e95 | (진입점 미연결) | DMF0051_1_RTF.cs:570 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b03a532 | (진입점 미연결) | DMF0051_1_RTF.cs:571 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6942ed77 | (진입점 미연결) | DMF0051_1_RTF.cs:573 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_RTF.GetSplit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-696cf20b | (진입점 미연결) | DMF0051_1_RTF.cs:531 |  | RETURN | return sar.Split('^'); |  | 처리 중단/반환 |  |  |  |

## DMF0051_1_RTF.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f12e9a | this.Load | DMF0051_1_RTF.cs:154 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0051_1_RTF.InitSpread

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d8d032b | .ctor | DMF0051_1_RTF.cs:206 |  | DATA_OP | dtTitle.Columns.Add | ("PROGRAM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e140087 | .ctor | DMF0051_1_RTF.cs:207 |  | DATA_OP | dtTitle.Columns.Add | ("SHEET_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-76b75b98 | .ctor | DMF0051_1_RTF.cs:208 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e80c292d | .ctor | DMF0051_1_RTF.cs:209 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-73c1e51b | .ctor | DMF0051_1_RTF.cs:210 |  | DATA_OP | dtTitle.Columns.Add | ("SORT_ORDER_NO", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da048641 | .ctor | DMF0051_1_RTF.cs:211 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_SORT_METHOD_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2e6e2f2 | .ctor | DMF0051_1_RTF.cs:212 |  | DATA_OP | dtTitle.Columns.Add | ("SMALL_CLASS_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d101095f | .ctor | DMF0051_1_RTF.cs:213 |  | DATA_OP | dtTitle.Columns.Add | ("LARGE_CLASS_LABEL_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b70eceb | .ctor | DMF0051_1_RTF.cs:214 |  | DATA_OP | dtTitle.Columns.Add | ("FIXED_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3eef3e58 | .ctor | DMF0051_1_RTF.cs:215 |  | DATA_OP | dtTitle.Columns.Add | ("COLUMN_WIDTH", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da39cb68 | .ctor | DMF0051_1_RTF.cs:216 |  | DATA_OP | dtTitle.Columns.Add | ("CELL_CONTROL_OBJECT_TYPE_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2ad5914 | .ctor | DMF0051_1_RTF.cs:217 |  | DATA_OP | dtTitle.Columns.Add | ("CELL_COMBO_DATA_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-90b52077 | .ctor | DMF0051_1_RTF.cs:218 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_SCALE_NUMBER", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce9bd655 | .ctor | DMF0051_1_RTF.cs:219 |  | DATA_OP | dtTitle.Columns.Add | ("DATA_MAX_LENGTH", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-20884279 | .ctor | DMF0051_1_RTF.cs:220 |  | DATA_OP | dtTitle.Columns.Add | ("HORIZONTAL_ALIGN_CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3555be6d | .ctor | DMF0051_1_RTF.cs:221 |  | DATA_OP | dtTitle.Columns.Add | ("UPPERCASE_APPLY_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cff48f7e | .ctor | DMF0051_1_RTF.cs:222 |  | DATA_OP | dtTitle.Columns.Add | ("VISIBLE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3f7ba52 | .ctor | DMF0051_1_RTF.cs:223 |  | DATA_OP | dtTitle.Columns.Add | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fb4e63b | .ctor | DMF0051_1_RTF.cs:224 |  | DATA_OP | dtTitle.Columns.Add | ("DEFAULT_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e74b755 | .ctor | DMF0051_1_RTF.cs:225 |  | DATA_OP | dtTitle.Columns.Add | ("USER_SELECTABLE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-80d462ee | .ctor | DMF0051_1_RTF.cs:226 |  | DATA_OP | dtTitle.Columns.Add | ("VALID_YN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd9160db | .ctor | DMF0051_1_RTF.cs:228 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "SCM_SITE_ID", "Sales Site", "10", "", "Sales Si… | 데이터 객체 조작/조회 |  |  |  |
| AC-92fb44cf | .ctor | DMF0051_1_RTF.cs:229 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "PROJECT_CODE", "Project Code", "20", "", "Proje… | 데이터 객체 조작/조회 |  |  |  |
| AC-7195c245 | .ctor | DMF0051_1_RTF.cs:230 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "PROJECT_NAME", "Project Name", "20", "", "Proje… | 데이터 객체 조작/조회 |  |  |  |
| AC-30c97dd4 | .ctor | DMF0051_1_RTF.cs:231 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "ITEM_ID", "Model Code", "30", "", "Model Code",… | 데이터 객체 조작/조회 |  |  |  |
| AC-4502b35e | .ctor | DMF0051_1_RTF.cs:232 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "ITEM_NICKNAME", "Model NickName", "40", "", "Mo… | 데이터 객체 조작/조회 |  |  |  |
| AC-7b8f588e | .ctor | DMF0051_1_RTF.cs:233 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "EE_CORP_ID", "전극생산지", "50", "", "전극생산지", "전극생산지… | 데이터 객체 조작/조회 |  |  |  |
| AC-498948b5 | .ctor | DMF0051_1_RTF.cs:234 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "CELL_CORP_ID", "Cell생산지", "60", "", "Cell생산지", … | 데이터 객체 조작/조회 |  |  |  |
| AC-37a4728c | .ctor | DMF0051_1_RTF.cs:235 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "PACK_CORP_ID", "PACK생산지", "70", "", "PACK생산지", … | 데이터 객체 조작/조회 |  |  |  |
| AC-143baca6 | .ctor | DMF0051_1_RTF.cs:236 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "OSP_YN", "외주여부", "80", "", "외주여부", "외주여부", "", … | 데이터 객체 조작/조회 |  |  |  |
| AC-a1a69025 | .ctor | DMF0051_1_RTF.cs:237 |  | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", "MEASURE", "MEASURE", "90", "", "MEASURE", "MEAS… | 데이터 객체 조작/조회 |  |  |  |
| AC-1ed4d0ca | .ctor | DMF0051_1_RTF.cs:239 |  | FLAG | _PLAN_START_DATE | _FROM_YYYYMM.Substring(0, 4).ToString() + "-" + _FROM_YYYYMM.Substring(4, 2).ToString() + … | 화면 필드/플래그 변경 |  |  |  |
| AC-38d78a09 | .ctor | DMF0051_1_RTF.cs:254 | for (i <= Period) | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0051_1", "RTF POPUP", month, month.Substring(0, 4) + "'" + month.Subst… | 데이터 객체 조작/조회 |  |  |  |
| AC-36ca998e | .ctor | DMF0051_1_RTF.cs:258 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0051_1_RTF.RTF_Load

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf5440df | .ctor | DMF0051_1_RTF.cs:130 |  | FLAG | _VERSION_NO | VERSION_NO | 화면 필드/플래그 변경 |  |  |  |
| AC-f314c51d | .ctor | DMF0051_1_RTF.cs:131 |  | FLAG | _DIVISION_ID | DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-fa6a539a | .ctor | DMF0051_1_RTF.cs:132 |  | FLAG | _PROJECT_CODE | PROJECT_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-689ed3cc | .ctor | DMF0051_1_RTF.cs:133 |  | FLAG | _SCM_SITE_ID | SCM_SITE_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-534b0fd7 | .ctor | DMF0051_1_RTF.cs:134 |  | FLAG | _ITEM_ID | ITEM_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-ee744acb | .ctor | DMF0051_1_RTF.cs:135 |  | FLAG | _INCOTERMS | INCOTERMS | 화면 필드/플래그 변경 |  |  |  |
| AC-8c69eb44 | .ctor | DMF0051_1_RTF.cs:136 |  | FLAG | _FROM_YYYYMM | FROM_YYYYMM | 화면 필드/플래그 변경 |  |  |  |
| AC-69af2048 | .ctor | DMF0051_1_RTF.cs:137 |  | FLAG | _TO_YYYYMM | TO_YYYYMM | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_1_RTF.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba9d03e7 | (진입점 미연결) | DMF0051_1_RTF.cs:690 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.Items | (new String[] { "수요" }) | 속성 Items 설정 |  |  |  |
| AC-0b4ca686 | (진입점 미연결) | DMF0051_1_RTF.cs:691 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-68f91dca | (진입점 미연결) | DMF0051_1_RTF.cs:692 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-ee4225b4 | (진입점 미연결) | DMF0051_1_RTF.cs:693 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-281eb1ba | (진입점 미연결) | DMF0051_1_RTF.cs:697 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, 7].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-d8255d91 | (진입점 미연결) | DMF0051_1_RTF.cs:705 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.Items | (new String[] { "운영" }) | 속성 Items 설정 |  |  |  |
| AC-b99196e1 | (진입점 미연결) | DMF0051_1_RTF.cs:706 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-c1924fa9 | (진입점 미연결) | DMF0051_1_RTF.cs:707 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-32fc6089 | (진입점 미연결) | DMF0051_1_RTF.cs:708 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-2dc6cc15 | (진입점 미연결) | DMF0051_1_RTF.cs:712 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") ▸ for (i <= siMain.GetMaxRowIn… | GRID_SET | siMain.ActiveSheet.Cells[i, 7].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-9d91f634 | (진입점 미연결) | DMF0051_1_RTF.cs:717 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3266304 | (진입점 미연결) | DMF0051_1_RTF.cs:725 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.Items | (new String[] { "차량생산", "차량판매", "물류이슈" }) | 속성 Items 설정 |  |  |  |
| AC-9156085f | (진입점 미연결) | DMF0051_1_RTF.cs:726 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-4eaf00ee | (진입점 미연결) | DMF0051_1_RTF.cs:727 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-d000aa3d | (진입점 미연결) | DMF0051_1_RTF.cs:728 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-9486e6a4 | (진입점 미연결) | DMF0051_1_RTF.cs:732 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | GRID_SET | siMain.ActiveSheet.Cells[i, 8].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-345a6fa6 | (진입점 미연결) | DMF0051_1_RTF.cs:740 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.Items | (new String[] { "시점조정", "모델믹스" }) | 속성 Items 설정 |  |  |  |
| AC-8a4582de | (진입점 미연결) | DMF0051_1_RTF.cs:741 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-701ac5d5 | (진입점 미연결) | DMF0051_1_RTF.cs:742 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-dc926e44 | (진입점 미연결) | DMF0051_1_RTF.cs:743 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-f2956dc2 | (진입점 미연결) | DMF0051_1_RTF.cs:747 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | GRID_SET | siMain.ActiveSheet.Cells[i, 8].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-cddd3a1a | (진입점 미연결) | DMF0051_1_RTF.cs:752 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_BizPlanWaterfall.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5706a4a | this.btnColumn.Click | DMF0051_BizPlanWaterfall.cs:1128 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-fe0f5e2f | this.btnColumn.Click | DMF0051_BizPlanWaterfall.cs:1129 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d5007a8 | this.btnColumn.Click | DMF0051_BizPlanWaterfall.cs:1130 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0051_BizPlanWaterfall.btnItemId_Click

진입점: this.btnItemId.Click / this.txtItemId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d190c288 | this.btnItemId.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1117 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-fb9b1cea | this.btnItemId.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1119 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8cd9d427 | this.btnItemId.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1120 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-910d4c98 | this.btnItemId.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1121 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7637e445 | this.btnItemId.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1123 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0051_BizPlanWaterfall.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d84a2260 | this.btnMeasure.Click | DMF0051_BizPlanWaterfall.cs:1140 |  | POPUP | new DM0002_TitleSetForm_Popup | (sProgram_Id, SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-b72c978c | this.btnMeasure.Click | DMF0051_BizPlanWaterfall.cs:1141 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cffdc463 | this.btnMeasure.Click | DMF0051_BizPlanWaterfall.cs:1142 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0051_BizPlanWaterfall.btnOwner_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c365fc59 | this.usrButton1.Click | DMF0051_BizPlanWaterfall.cs:1811 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9b015467 | this.usrButton1.Click | DMF0051_BizPlanWaterfall.cs:1813 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-eda7cb15 | this.usrButton1.Click | DMF0051_BizPlanWaterfall.cs:1814 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c72610b7 | this.usrButton1.Click | DMF0051_BizPlanWaterfall.cs:1815 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cc8ca679 | this.usrButton1.Click | DMF0051_BizPlanWaterfall.cs:1817 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0051_BizPlanWaterfall.btnProject_Click

진입점: this.btnProject.Click / this.txtProject.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9e87aec | this.btnProject.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1099 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-0da9f797 | this.btnProject.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1100 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-31b0261f | this.btnProject.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1101 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5f07c51c | this.btnProject.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1102 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-646b4c7b | this.btnProject.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1104 |  | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0051_BizPlanWaterfall.btnVersion_Click

진입점: this.btnVersion.Click / this.txtVersion.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cbba4fe | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1773 |  | POPUP | new SCM0002_VersionByWaterfallPopup | () | 팝업/폼 생성 |  |  |  |
| AC-44264adf | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1774 |  | POPUP | popVersion.Form_Load | (true, "BP", sDivision, sStartTime, sEndTinme) | 팝업 초기화(인자 전달) |  |  |  |
| AC-058d32ac | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1775 |  | UI_PROP | popVersion.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7fc43523 | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1776 |  | CALL_EXT | popVersion.weekChecked | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71359769 | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1777 |  | CALL_EXT | popVersion.monthChecked | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7f8fc43 | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1778 |  | POPUP | popVersion.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-55f13bcd | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1782 | if (popVersion.sVersions != "") | VALUE_SET | txtVersion.Text | popVersion.sVersions | 컨트롤 값 설정 |  |  |  |
| AC-ac2ce3c2 | this.btnVersion.Click 외 1 | DMF0051_BizPlanWaterfall.cs:1783 | if (popVersion.sVersions != "") | VALUE_SET | drpPeriod.InitValue | popVersion.sPeriod | 컨트롤 값 설정 |  |  |  |

## DMF0051_BizPlanWaterfall.cboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b81f67f3 | this.cboBucketType.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:936 | if (siMain != null) | FLAG | sBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_BizPlanWaterfall.cboKRW_SelectedIndexChanged

진입점: this.cboKRW.SelectedIndexChanged / cboKRW.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48e2cda8 | this.cboKRW.SelectedIndexChanged 외 1 | DMF0051_BizPlanWaterfall.cs:1452 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.cboLOC_SelectedIndexChanged

진입점: this.cboLOC.SelectedIndexChanged / cboLOC.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94851edb | this.cboLOC.SelectedIndexChanged 외 1 | DMF0051_BizPlanWaterfall.cs:1469 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.cboQTY_SelectedIndexChanged

진입점: this.cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e4a136d | this.cboQTY.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1477 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.cboUSD_SelectedIndexChanged

진입점: this.cboUSD.SelectedIndexChanged / cboUSD.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-426b5227 | this.cboUSD.SelectedIndexChanged 외 1 | DMF0051_BizPlanWaterfall.cs:1461 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94d5c28d | this.clbCustomer.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1437 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-573d1ea7 | this.clbCustomer.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1439 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53e20a1f | this.clbCustomer.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1446 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0051_BizPlanWaterfall.ClbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-723bda9f | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:806 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0b5bb2f0 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:815 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-649c7845 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:826 | try ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-247f51c9 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:826 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6517c6d | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:827 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-144fe877 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:829 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0947469d | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:830 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-de9f11ce | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:831 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f633a8d3 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:832 | try ▸ if (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b9b5b5d9 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:841 | try ▸ else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivisionAsync(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-5ed7acc8 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:842 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3062589e | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:844 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d450e3c1 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:845 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d99726ef | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:846 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c3bef119 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:847 | try ▸ else of (sDivision == "40") | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7a902173 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:850 | try | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a8bb4255 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:854 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-72cdbf53 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:864 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0572800e | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:871 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e95d5eab | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:879 | try | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4c292a9a | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:880 | try | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-485c8b64 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:881 | try | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-28528be1 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:882 | try | VALUE_CLEAR | this.txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d1a09a80 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:890 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-260ef275 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:891 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-fed873d2 | this.clbDivision.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:895 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_BizPlanWaterfall.ClbPlantSite_SelectedIndexChanged

진입점: clbPlantSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a5b337c | clbPlantSite.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:915 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b1e5c45 | clbPlantSite.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:917 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.ClbSalesSite_SelectedIndexChanged

진입점: clbSalesSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36b6c810 | clbSalesSite.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:904 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ae71838 | clbSalesSite.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:906 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20d13495 | this.clbTeam.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1724 | if (blnInit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2dbc226a | this.clbTeam.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1726 | if (base.IsInitOpen) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c260028 | this.clbTeam.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1748 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b57ca93e | this.clbTeam.SelectedIndexChanged | DMF0051_BizPlanWaterfall.cs:1758 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0051_BizPlanWaterfall.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4ea72e2 | this.Load | DMF0051_BizPlanWaterfall.cs:346 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1b575b79 | this.Load | DMF0051_BizPlanWaterfall.cs:347 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b99c9eb | this.Load | DMF0051_BizPlanWaterfall.cs:348 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0051_BizPlanWaterfall.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a78dfe51 | this.Load | DMF0051_BizPlanWaterfall.cs:317 |  | UI_PROP | usrConditionPanel1.Height | 105 | 속성 Height 설정 |  |  |  |
| AC-de35a7fe | this.Load | DMF0051_BizPlanWaterfall.cs:318 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-7b01dfe4 | this.Load | DMF0051_BizPlanWaterfall.cs:321 |  | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-0502c0ee | this.Load | DMF0051_BizPlanWaterfall.cs:322 |  | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_BizPlanWaterfall.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-596cb0f2 | Dispose | DMF0051_BizPlanWaterfall.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0051_BizPlanWaterfall.DM0051_BizPlanWaterfall_FormClosed

진입점: this.FormClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b17d9ad4 | this.FormClosed | DMF0051_BizPlanWaterfall.cs:1791 | try | CALL_EXT | GC.SuppressFinalize | (this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1e0cb7d | this.FormClosed | DMF0051_BizPlanWaterfall.cs:1793 | try | CALL_EXT | GC.Collect | (0, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-befec56c | this.FormClosed | DMF0051_BizPlanWaterfall.cs:1794 | try | CALL_EXT | GC.Collect | (1, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2c2562f | this.FormClosed | DMF0051_BizPlanWaterfall.cs:1795 | try | CALL_EXT | GC.Collect | (2, GCCollectionMode.Forced, true, true) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_BizPlanWaterfall.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c29d265b | EditButton | DMF0051_BizPlanWaterfall.cs:442 | if (this.fps != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f3624b1 | EditButton | DMF0051_BizPlanWaterfall.cs:443 | if (this.fps != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ff85610 | ExcelButton | DMF0051_BizPlanWaterfall.cs:458 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-582f0736 | ExcelButton | DMF0051_BizPlanWaterfall.cs:459 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-235ccc69 | ExcelButton | DMF0051_BizPlanWaterfall.cs:460 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-0a50442c | ExcelButton | DMF0051_BizPlanWaterfall.cs:461 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-1c649c4f | ExcelButton | DMF0051_BizPlanWaterfall.cs:462 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-2fa1fc4e | ExcelButton | DMF0051_BizPlanWaterfall.cs:463 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-018ac4cf | ExcelButton | DMF0051_BizPlanWaterfall.cs:465 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-15461d1a | ExcelButton | DMF0051_BizPlanWaterfall.cs:466 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-684eafa5 | ExcelButton | DMF0051_BizPlanWaterfall.cs:468 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-ea4ab40b | ExcelButton | DMF0051_BizPlanWaterfall.cs:477 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5230f8e0 | ExcelButton | DMF0051_BizPlanWaterfall.cs:482 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ab9e3022 | ExcelButton | DMF0051_BizPlanWaterfall.cs:486 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0051_BizPlanWaterfall.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2182777 | FindButton | DMF0051_BizPlanWaterfall.cs:505 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e826fe90 | FindButton | DMF0051_BizPlanWaterfall.cs:512 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-261b5d7b | FindButton | DMF0051_BizPlanWaterfall.cs:513 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aab9b5df | FindButton | DMF0051_BizPlanWaterfall.cs:516 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ff50abdb | FindButton | DMF0051_BizPlanWaterfall.cs:518 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-a2291d06 | FindButton | DMF0051_BizPlanWaterfall.cs:518 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-281724e8 | FindButton | DMF0051_BizPlanWaterfall.cs:528 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3401af06 | FindButton | DMF0051_BizPlanWaterfall.cs:529 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58917d6f | FindButton | DMF0051_BizPlanWaterfall.cs:535 | try ▸ if (drpPeriod.Value1.AddYears(10) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2b3e0c46 | FindButton | DMF0051_BizPlanWaterfall.cs:537 | try ▸ if (drpPeriod.Value1.AddYears(10) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(10) | 속성 Value2 설정 |  |  |  |
| AC-cc7de433 | FindButton | DMF0051_BizPlanWaterfall.cs:539 | try ▸ if (drpPeriod.Value1.AddYears(10) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-659df0a8 | FindButton | DMF0051_BizPlanWaterfall.cs:543 | try | CALL_EXT | drpPeriod.Value1.CompareTo | (thisWeekDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7090f40 | FindButton | DMF0051_BizPlanWaterfall.cs:545 | try | CALL_EXT | Convert.ToInt32(sEndDate).CompareTo | (Convert.ToInt32(sNowDate)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c5c2a62 | FindButton | DMF0051_BizPlanWaterfall.cs:565 | try ▸ if (p_division_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f450928f | FindButton | DMF0051_BizPlanWaterfall.cs:566 | try ▸ if (p_division_id == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-adc819f5 | FindButton | DMF0051_BizPlanWaterfall.cs:570 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d70dbf7b | FindButton | DMF0051_BizPlanWaterfall.cs:579 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-40a900e7 | FindButton | DMF0051_BizPlanWaterfall.cs:581 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c63c9399 | FindButton | DMF0051_BizPlanWaterfall.cs:586 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL") ⇒ DM.DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-6cbff5f9 | FindButton | DMF0051_BizPlanWaterfall.cs:588 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-418e89f4 | FindButton | DMF0051_BizPlanWaterfall.cs:590 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5337abd0 | FindButton | DMF0051_BizPlanWaterfall.cs:591 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d46f53f | FindButton | DMF0051_BizPlanWaterfall.cs:592 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer | 행/컬럼 값 대입 |  |  |  |
| AC-39fad5d9 | FindButton | DMF0051_BizPlanWaterfall.cs:593 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff8956b4 | FindButton | DMF0051_BizPlanWaterfall.cs:594 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-4bb3cf7d | FindButton | DMF0051_BizPlanWaterfall.cs:595 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-43d68555 | FindButton | DMF0051_BizPlanWaterfall.cs:596 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-b2869f08 | FindButton | DMF0051_BizPlanWaterfall.cs:597 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-b5ea793b | FindButton | DMF0051_BizPlanWaterfall.cs:598 | try ▸ lambda | DATA_OP | request.Parameters["p_now_yyyymmdd"] | sNowDate | 행/컬럼 값 대입 |  |  |  |
| AC-0786f2d5 | FindButton | DMF0051_BizPlanWaterfall.cs:599 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-9ecb2469 | FindButton | DMF0051_BizPlanWaterfall.cs:600 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-935a96f1 | FindButton | DMF0051_BizPlanWaterfall.cs:601 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-15289089 | FindButton | DMF0051_BizPlanWaterfall.cs:602 | try ▸ lambda | DATA_OP | request.Parameters["p_biztype"] | p_biztype | 행/컬럼 값 대입 |  |  |  |
| AC-0b6c8d20 | FindButton | DMF0051_BizPlanWaterfall.cs:603 | try ▸ lambda | DATA_OP | request.Parameters["p_version_type"] | p_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-8ad29b71 | FindButton | DMF0051_BizPlanWaterfall.cs:604 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-15fa75c9 | FindButton | DMF0051_BizPlanWaterfall.cs:605 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_yn"] | (cboCellQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-49566750 | FindButton | DMF0051_BizPlanWaterfall.cs:606 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-9a3c38aa | FindButton | DMF0051_BizPlanWaterfall.cs:608 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a36ece9 | FindButton | DMF0051_BizPlanWaterfall.cs:609 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68937963 | FindButton | DMF0051_BizPlanWaterfall.cs:611 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cbxQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d3bba6f6 | FindButton | DMF0051_BizPlanWaterfall.cs:614 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b5fe014 | FindButton | DMF0051_BizPlanWaterfall.cs:616 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-279f5e83 | FindButton | DMF0051_BizPlanWaterfall.cs:621 | try ▸ if (ds.Tables[0].Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc6e895e | FindButton | DMF0051_BizPlanWaterfall.cs:627 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].Columns.Add | ("Action", typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-576618d5 | FindButton | DMF0051_BizPlanWaterfall.cs:630 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | DATA_OP | ds.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd14367c | FindButton | DMF0051_BizPlanWaterfall.cs:632 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a4ec2311 | FindButton | DMF0051_BizPlanWaterfall.cs:633 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cdfce41c | FindButton | DMF0051_BizPlanWaterfall.cs:636 | try ▸ if (ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["MEASURE"].ToString() != "") ▸ if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-2dbcb05b | FindButton | DMF0051_BizPlanWaterfall.cs:640 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be7fdcda | FindButton | DMF0051_BizPlanWaterfall.cs:653 | try ▸ try ▸ if (chkMem.Checked == true) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9fc1e075 | FindButton | DMF0051_BizPlanWaterfall.cs:728 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-88f3e69a | FindButton | DMF0051_BizPlanWaterfall.cs:733 | try ▸ try ▸ if (chkMem.Checked == true) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetColumnIndex(sLockDate) >= 0) ▸ if (sLockDate.In… | GRID_STYLE | siMain.SetBGColor | (i, iResultYear, i, iResultYear, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-b341d0e7 | FindButton | DMF0051_BizPlanWaterfall.cs:742 | try ▸ catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBoxForException | (e) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1113625 | FindButton | DMF0051_BizPlanWaterfall.cs:750 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c452d62c | FindButton | DMF0051_BizPlanWaterfall.cs:751 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bd1779c7 | FindButton | DMF0051_BizPlanWaterfall.cs:761 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-486331eb | FindButton | DMF0051_BizPlanWaterfall.cs:781 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0f1dc355 | FindButton | DMF0051_BizPlanWaterfall.cs:786 | catch ((Exception ex)) ▸ if (this.Visible) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce36acb6 | FindButton | DMF0051_BizPlanWaterfall.cs:792 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b18ed9c0 | FindButton | DMF0051_BizPlanWaterfall.cs:793 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0cb07f13 | FindButton | DMF0051_BizPlanWaterfall.cs:794 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0051_BizPlanWaterfall.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c1b7608 | this.Load | DMF0051_BizPlanWaterfall.cs:175 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-29adcf38 | this.Load | DMF0051_BizPlanWaterfall.cs:177 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0051_BizPlanWaterfall.GetBizTypebyDivision

진입점: this.Load [try ▸ else of (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f1f30f6 | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_BizPlanWaterfall.cs:1379 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-5f822998 | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_BizPlanWaterfall.cs:1380 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1aa03ddd | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_BizPlanWaterfall.cs:1381 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bfb1892e | this.Load [try ▸ else of (sDivision == "40")] | DMF0051_BizPlanWaterfall.cs:1384 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetBizTypebyDivisionAsync

진입점: this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c636c90 | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_BizPlanWaterfall.cs:1393 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c3cc7698 | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_BizPlanWaterfall.cs:1394 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b54711d8 | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_BizPlanWaterfall.cs:1395 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a1fdc16 | this.clbDivision.SelectedIndexChanged [try ▸ else of (sDivis… | DMF0051_BizPlanWaterfall.cs:1398 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetBucketType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-286924c4 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1352 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-7b8965c3 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1353 |  | DATA_OP | request.Parameters["p_lookup_type"] | "BUCKET2_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-a560e5d8 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1354 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ca8df60 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1356 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetDayRange

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31fde24f | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1317 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-79d1b611 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1318 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4f769a3d | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1319 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-ffd957cf | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1321 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fada805c | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1324 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60fe77c1 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1365 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-ff82cf90 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1366 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-b3b104ad | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1367 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4529ec66 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1370 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetPlantSitebyEndCustomer

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a86f762 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:1008 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-07184725 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:1009 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-25cd790f | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:1010 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-fe5ebed4 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:1011 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-028d19eb | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:1012 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-83837255 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:1015 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetQtyData

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed1b6ce0 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1407 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_QTY_TYPE_CODE") ⇒ DM.DMF0003_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-1ef7880a | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1408 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0cc7ff72 | this.Load [try] | DMF0051_BizPlanWaterfall.cs:1411 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetScmSitebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c06a6a3 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:992 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f71ad3bf | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:993 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c5a0aa80 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:994 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ff6fc386 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:995 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-61fd3869 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:996 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-82626585 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… | DMF0051_BizPlanWaterfall.cs:999 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.clbDivision.SelectedIndexChang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f59a4a4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1330 |  | FLAG | fBucket | cboBucketType.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-47bbb251 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1334 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0051_GET_SPREAD_TITLE") ⇒ DM.DMF0051_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c443ce32 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1335 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-df58afec | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1336 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-d02feae3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1337 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bb49e331 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1338 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-06564e37 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1339 |  | DATA_OP | request.Parameters["p_bucket"] | fBucket | 행/컬럼 값 대입 |  |  |  |
| AC-f7215c96 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1341 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-11313df6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1341 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-735d6dc4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1344 |  | RETURN | return dsSpdTitle.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.GetThisWeekMonday

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00267240 | FindButton [try] | DMF0051_BizPlanWaterfall.cs:1430 |  | RETURN | return sYYYYMMDD; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9ef2bc3 | this.Load | DMF0051_BizPlanWaterfall.cs:194 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cf2cbaf | this.Load | DMF0051_BizPlanWaterfall.cs:197 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-237fbab7 | this.Load | DMF0051_BizPlanWaterfall.cs:198 | try | FLAG | blnInit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-76f7e5c6 | this.Load | DMF0051_BizPlanWaterfall.cs:200 | try | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-de569b7f | this.Load | DMF0051_BizPlanWaterfall.cs:206 | try | FLAG | dtDivision | null | 화면 필드/플래그 변경 |  |  |  |
| AC-32e4b58f | this.Load | DMF0051_BizPlanWaterfall.cs:210 | try | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a7c130e0 | this.Load | DMF0051_BizPlanWaterfall.cs:219 | try | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-97a07b4f | this.Load | DMF0051_BizPlanWaterfall.cs:225 | try ▸ if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ab43f5b5 | this.Load | DMF0051_BizPlanWaterfall.cs:225 | try ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8649f55 | this.Load | DMF0051_BizPlanWaterfall.cs:226 | try ▸ if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0a532072 | this.Load | DMF0051_BizPlanWaterfall.cs:233 | try ▸ if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8bb59019 | this.Load | DMF0051_BizPlanWaterfall.cs:234 | try ▸ if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3ee81107 | this.Load | DMF0051_BizPlanWaterfall.cs:235 | try ▸ if (sDivision == "40") | STATE | layoutControlItem3.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bae477e3 | this.Load | DMF0051_BizPlanWaterfall.cs:237 | try ▸ if (sDivision == "40") | VALUE_CLEAR | txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5c7d30ea | this.Load | DMF0051_BizPlanWaterfall.cs:238 | try ▸ if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-5f6b6b41 | this.Load | DMF0051_BizPlanWaterfall.cs:247 | try ▸ else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-80defa2c | this.Load | DMF0051_BizPlanWaterfall.cs:248 | try ▸ else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f8bbb8b9 | this.Load | DMF0051_BizPlanWaterfall.cs:250 | try ▸ else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a282dcde | this.Load | DMF0051_BizPlanWaterfall.cs:251 | try ▸ else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b5ad2a3b | this.Load | DMF0051_BizPlanWaterfall.cs:252 | try ▸ else of (sDivision == "40") | STATE | layoutControlItem3.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cbec81aa | this.Load | DMF0051_BizPlanWaterfall.cs:253 | try ▸ else of (sDivision == "40") | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d0b00c5f | this.Load | DMF0051_BizPlanWaterfall.cs:255 | try | VALUE_SET | chkMem.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-e0680651 | this.Load | DMF0051_BizPlanWaterfall.cs:256 | try | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-3fea45f0 | this.Load | DMF0051_BizPlanWaterfall.cs:258 | try | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6aeed977 | this.Load | DMF0051_BizPlanWaterfall.cs:266 | try | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-79d8b0ed | this.Load | DMF0051_BizPlanWaterfall.cs:273 | try | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e0794482 | this.Load | DMF0051_BizPlanWaterfall.cs:275 | try | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-641439be | this.Load | DMF0051_BizPlanWaterfall.cs:276 | try | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-920b5e4f | this.Load | DMF0051_BizPlanWaterfall.cs:284 | try | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6c4ae4ac | this.Load | DMF0051_BizPlanWaterfall.cs:285 | try | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f2f832d5 | this.Load | DMF0051_BizPlanWaterfall.cs:288 | try | FLAG | dtAmoutKrw | Data.Common(Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 화면 필드/플래그 변경 |  |  |  |
| AC-8205821a | this.Load | DMF0051_BizPlanWaterfall.cs:288 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_KRW, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26c196a3 | this.Load | DMF0051_BizPlanWaterfall.cs:289 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutKrw, cboKRW, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cbdff851 | this.Load | DMF0051_BizPlanWaterfall.cs:290 | try | FLAG | dtAmoutUsd | Data.Common(Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 화면 필드/플래그 변경 |  |  |  |
| AC-bf0d026a | this.Load | DMF0051_BizPlanWaterfall.cs:290 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_USD, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6aa874f8 | this.Load | DMF0051_BizPlanWaterfall.cs:291 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutUsd, cboUSD, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5b0eca4f | this.Load | DMF0051_BizPlanWaterfall.cs:292 | try | FLAG | dtAmoutLoc | Data.Common(Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"],… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 화면 필드/플래그 변경 |  |  |  |
| AC-4cdddd87 | this.Load | DMF0051_BizPlanWaterfall.cs:292 | try | COMBO_DATA | Data.Common | (Data.Type.SALES_PLAN_AMOUNT_LOC, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23b49ff2 | this.Load | DMF0051_BizPlanWaterfall.cs:293 | try | LIST_REBIND | clsCtrl.setListBox | (dtAmoutLoc, cboLOC, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ca0950f6 | this.Load | DMF0051_BizPlanWaterfall.cs:295 | try | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-34bdabf2 | this.Load | DMF0051_BizPlanWaterfall.cs:296 | try | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ac236da0 | this.Load | DMF0051_BizPlanWaterfall.cs:299 | try | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b54bd3b | this.Load | DMF0051_BizPlanWaterfall.cs:300 | try | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-51e5ba5c | this.Load | DMF0051_BizPlanWaterfall.cs:305 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-1e2d4009 | this.Load | DMF0051_BizPlanWaterfall.cs:309 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6d6bada2 | this.Load | DMF0051_BizPlanWaterfall.cs:310 | finally | FLAG | blnInit | false | 화면 필드/플래그 변경 |  |  |  |

## DMF0051_BizPlanWaterfall.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.clbDivision.SelectedIndexChanged [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd4d1ead | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:357 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6198c653 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:363 | try ▸ if ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d27aa08 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:368 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtStartPeriod | drpPeriod.Value1 | 화면 필드/플래그 변경 |  |  |  |
| AC-415c2cda | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:369 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | FLAG | dtEndPeriod | drpPeriod.Value2 | 화면 필드/플래그 변경 |  |  |  |
| AC-44f9f389 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:374 | try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…) | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dtTitle, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |
| AC-6cebc763 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:384 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-eaddb5fa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:388 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0051_BizPlanWaterfall.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.clbDivision.SelectedIndexChang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97d5100e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:395 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-67a2b3ef | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:396 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-f9bce837 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:403 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-31461c4c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:404 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f23baf7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:405 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-b6bf9cbc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:406 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Q_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0051_BizPlanWaterfall.SetAmountCalculating

진입점: this.cboLOC.SelectedIndexChanged / this.cboKRW.SelectedIndexChanged / this.cboUSD.SelectedIndexChanged / this.cboQTY.SelectedIndexChanged / cboKRW.SelectedIndexChanged / cboUSD.SelectedIndexChanged / cboLOC.SelectedIndexChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb1fe2bc | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1487 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf1c5253 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1491 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3d42cbdf | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1497 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-93ff4581 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1498 | if (cboKRW.SelectedIndex == 0 && cboUSD.SelectedIndex == 0 && cboLOC.SelectedIndex == 0 && cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-330b006b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1501 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b9294e0e | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1502 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5b6a0e7 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1683 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbKrwDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-493444d9 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1685 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbUsdDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-813e5e1b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1687 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbLocDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-5215de05 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1692 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) ▸ if (dsKrw.Tables[0].Columns[j].ColumnName.IndexOf(… | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-e8715f4b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1698 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d422c48d | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1704 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-b7147cba | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1708 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-62e55f5b | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1712 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-cb334ab6 | this.cboLOC.SelectedIndexChanged 외 7 | DMF0051_BizPlanWaterfall.cs:1715 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_BizPlanWaterfall.SetChangeControl

진입점: this.clbCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged [if (sDivision == "40")] / this.Load [try] / this.clbDivision.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8ef7918 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1831 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b0d5d4e | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1832 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f912ab63 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1838 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4dfa3dd | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1838 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0897f2f8 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1843 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3e0404ea | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1845 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4dbc7191 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1845 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a7856a6a | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1850 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-39d77685 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1851 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-a44120b7 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1853 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6fe7e581 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1853 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9f574a05 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1858 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-29e6e1a0 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1859 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-8f01b643 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1860 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-070ba113 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1862 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-31e68f79 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1862 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fe74717a | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1867 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dfc7fd41 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1868 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-91e6e4d0 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1869 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-ce5cd520 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1871 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | FLAG | dtPlantSite | DataService.GetDMInnerTable("UserPlantSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a94c4927 | this.clbCustomer.SelectedIndexChanged 외 3 | DMF0051_BizPlanWaterfall.cs:1871 | switch (triggerControl) case "UserPlantSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserPlantSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0051_BizPlanWaterfall.SetSpreadColumn

진입점: this.chkMem.CheckedChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.Load [try ▸ else…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b4093a6 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1249 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-38259eeb | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1251 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (siMain.GetColumnTag(iCol).Index… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9e3b8f08 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1256 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d70d8e89 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1258 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-100d18e4 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1260 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (cboBucketType.ControlValues == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-3c33107d | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1265 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8fe3157f | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1267 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Monthly) ▸ else of (cboBucketType.ControlValue… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-eef29163 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1278 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.Get… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-4d743d68 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1279 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.Get… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-7e6b7c79 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1280 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.Get… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-e8c56b13 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1289 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-b0dd0225 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1290 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMai… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-54a0eab8 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1298 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ else of (… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-e0e208e7 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1299 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkMem.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ else of (… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-c5d8818e | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1305 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkMem.Checked == false) ▸ if (chkMem.Checked == true) | GRID_STYLE | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-8d43a0b6 | this.chkMem.CheckedChanged [if (siMain != null)] 외 7 | DMF0051_BizPlanWaterfall.cs:1306 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkMem.Checked == false) ▸ if (chkMem.Checked == true) | CALL_EXT | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetFont | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_BizPlanWaterfall.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.Load [try ▸ else of ((dtStartPeriod.ToString("yyyyMMdd") == drpPeriod.Value1.ToString("yyyyMMdd") && dtEndPeriod.ToString("yyyyMMdd") == drpP…)] / this.clbDivision.SelectedIndexChang…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c111ffc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1185 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07c4f3d7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1199 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dec06526 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1200 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70367b8b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1205 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da403a27 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1206 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21882a10 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1213 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1cd73625 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1214 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5fc48a5b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1225 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-052faf1f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1226 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fca299a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1227 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-423b156f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1228 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bee3befe | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1230 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5a3eff70 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | DMF0051_BizPlanWaterfall.cs:1232 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0051_BizPlanWaterfall.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ab10c69 | this.spdMain.CellDoubleClick | DMF0051_BizPlanWaterfall.cs:1029 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-b53e9252 | this.spdMain.CellDoubleClick | DMF0051_BizPlanWaterfall.cs:1035 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-5ec44aee | this.spdMain.CellDoubleClick | DMF0051_BizPlanWaterfall.cs:1041 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.Get… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1e069aa9 | this.spdMain.CellDoubleClick | DMF0051_BizPlanWaterfall.cs:1055 | if (e.ColumnHeader) ▸ else of (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("Q_") == 0) ▸ f… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-f057efb7 | this.spdMain.CellDoubleClick | DMF0051_BizPlanWaterfall.cs:1066 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0051_BizPlanWaterfall.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-990d2ebb | this.spdMain.ComboSelChange | DMF0051_BizPlanWaterfall.cs:977 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtSalesSite | GetScmSitebyDivision(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringALL, C… | 화면 필드/플래그 변경 |  |  |  |
| AC-5625e881 | this.spdMain.ComboSelChange | DMF0051_BizPlanWaterfall.cs:978 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siteIndex, dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-32a7eefb | this.spdMain.ComboSelChange | DMF0051_BizPlanWaterfall.cs:980 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSite | GetPlantSitebyEndCustomer(siMain.GetValue(e.Row, e.Column).ToString(), CAppSetting.StringA… | 화면 필드/플래그 변경 |  |  |  |
| AC-d2528a33 | this.spdMain.ComboSelChange | DMF0051_BizPlanWaterfall.cs:981 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siteIndex, dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0051_BizPlanWaterfall.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a5608e7 | this.spdMain.KeyUp | DMF0051_BizPlanWaterfall.cs:1079 | if (siMain.GetColumnIndex(DefColumns.MEASURE) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-820ba61c | this.spdMain.KeyUp | DMF0051_BizPlanWaterfall.cs:1082 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08b0a2e4 | this.spdMain.KeyUp | DMF0051_BizPlanWaterfall.cs:1086 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-39caf71f | this.spdMain.KeyUp | DMF0051_BizPlanWaterfall.cs:1087 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0051_BizPlanWaterfall.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-807934f5 | this.spdMain.TopChange | DMF0051_BizPlanWaterfall.cs:1073 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

